using Rokhsetak.Areas.Trainee.ViewModels.Booking;
using Rokhsetak.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Microsoft.AspNetCore.Mvc;


namespace Rokhsetak.Services.Implementations
{
    public class BookingService : IBookingService
    {
        private readonly RokhsetakDbContext _context;
        private readonly INotificationService _notifications;

        public BookingService(RokhsetakDbContext context, INotificationService notifications)
        {
            _context = context;
            _notifications = notifications;
        }

        // ─────────────────────────────────────────────────────────────────────────
        // BROWSE MENTORS
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<ServiceResult<MentorBrowseListViewModel>> BrowseMentorsAsync(
            int traineeId, MentorBrowseFilterViewModel filter)
        {
            // Trainee's active license type determines which mentors are shown
            var license = await _context.TraineeLicenses
                .FirstOrDefaultAsync(tl => tl.TraineeId == traineeId && tl.IsActive);

            if (license == null)
                return ServiceResult<MentorBrowseListViewModel>.Failure("No active license found.");

            // Only approved mentors (application approved)
            var approvedMentorIds = await _context.MentorApplications
                .Where(a => a.Status == "approved")
                .Select(a => a.MentorId)
                .ToHashSetAsync();

            // Base mentor query filtered by license type
            var mentorQuery = _context.Mentors
                .Where(m => approvedMentorIds.Contains(m.MentorId));

            if (!string.IsNullOrWhiteSpace(filter.City))
                mentorQuery = mentorQuery.Where(m => m.City == filter.City);

            if (filter.MinPrice.HasValue)
                mentorQuery = mentorQuery.Where(m => m.PricePerSession >= filter.MinPrice.Value);

            if (filter.MaxPrice.HasValue)
                mentorQuery = mentorQuery.Where(m => m.PricePerSession <= filter.MaxPrice.Value);

            if (license.LicenseTypeId == 1)
                mentorQuery = mentorQuery.Where(m => m.LicenseTypeId == 1 || m.LicenseTypeId == 2);
            
            if (license.LicenseTypeId == 2)
                mentorQuery = mentorQuery.Where(m => m.LicenseTypeId == 2);


            var mentors = await mentorQuery
                .Join(_context.Users,
                      m => m.MentorId,
                      u => u.UserId,
                      (m, u) => new
                      {
                          m.MentorId,
                          m.City,
                          m.LicenseTypeId,
                          m.PricePerSession,
                          FullName = u.FirstName + " " + u.LastName
                      })
                .Join(_context.LicenseTypes,
                      m => m.LicenseTypeId,
                      lt => lt.LicenseTypeId,
                      (m, lt) => new
                      {
                          m.MentorId,
                          m.City,
                          m.PricePerSession,
                          m.FullName,
                          LicenseName = lt.LicenseName
                      })
                .ToListAsync();

            var mentorIds = mentors.Select(m => m.MentorId).ToList();

            // Ratings per mentor
            var ratings = await _context.Ratings
                .Where(r => mentorIds.Contains(r.MentorId))
                .GroupBy(r => r.MentorId)
                .Select(g => new { MentorId = g.Key, Avg = (double)g.Average(r => r.Score), Count = g.Count() })
                .ToDictionaryAsync(x => x.MentorId);

            // Completion rate per mentor
            var completionRates = await ComputeCompletionRatesAsync(mentorIds);

            var cards = mentors.Select(m =>
            {
                ratings.TryGetValue(m.MentorId, out var rating);
                completionRates.TryGetValue(m.MentorId, out var compRate);

                return new MentorBrowseCardViewModel
                {
                    MentorId = m.MentorId,
                    FullName = m.FullName,
                    City = m.City ?? string.Empty,
                    LicenseType = m.LicenseName,
                    PricePerSession = m.PricePerSession ?? 0,
                    AverageRating = Math.Round(rating?.Avg ?? 0, 1),
                    TotalRatings = rating?.Count ?? 0,
                    CompletionRate = compRate
                };
            });

            // Apply rating filter (post-query)
            if (filter.MinRating.HasValue)
                cards = cards.Where(c => c.AverageRating >= filter.MinRating.Value);

            // Available cities for filter dropdown
            var availableCities = await _context.Mentors
                .Where(m => m.LicenseTypeId == license.LicenseTypeId
                         && m.City != null
                         && approvedMentorIds.Contains(m.MentorId))
                .Select(m => m.City!)
                .Distinct()
                .OrderBy(c => c)
                .ToListAsync();

            filter.AvailableCities = availableCities;

            var activeMentorId = await _context.TraineeLicenses
                .Where(tl => tl.TraineeId == traineeId)
                .Include(m => m.Mentor)
                .Select(m => m.MentorId)
                .FirstOrDefaultAsync();

            var vm = new MentorBrowseListViewModel
            {
                Mentors = cards.OrderByDescending(c => c.AverageRating).ToList(),
                Filter = filter,
                ActiveMentorId = activeMentorId
            };

            return ServiceResult<MentorBrowseListViewModel>.Success(vm);
        }

        // ─────────────────────────────────────────────────────────────────────────
        // GET MENTOR BOOKING PAGE (availability + mentor info)
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<ServiceResult<MentorBookingViewModel>> GetMentorBookingPageAsync(
            int traineeId, int mentorId)
        {
            var license = await _context.TraineeLicenses
                .Include(tl => tl.LicenseType)
                .FirstOrDefaultAsync(tl => tl.TraineeId == traineeId && tl.IsActive);

            if (license == null)
                return ServiceResult<MentorBookingViewModel>.Failure("No active license found.");

            var mentor = await _context.Mentors
                .Where(m => m.MentorId == mentorId)
                .Join(_context.Users,
                      m => m.MentorId,
                      u => u.UserId,
                      (m, u) => new
                      {
                          m.MentorId,
                          m.City,
                          m.PricePerSession,
                          m.LicenseTypeId,
                          FullName = u.FirstName + " " + u.LastName
                      })
                .FirstOrDefaultAsync();

            if (mentor == null)
                return ServiceResult<MentorBookingViewModel>.Failure("Mentor not found.");

            // Verify mentor is approved
            bool isApproved = await _context.MentorApplications
                .AnyAsync(a => a.MentorId == mentorId && a.Status == "approved");

            if (!isApproved)
                return ServiceResult<MentorBookingViewModel>.Failure("Mentor is not yet approved.");

            // Get availability
            var slots = await _context.MentorAvailabilities
                .Where(a => a.MentorId == mentorId && a.IsActive == true)
                .OrderBy(a => a.DayOfWeek)
                .ThenBy(a => a.StartTime)
                .ToListAsync();

            var availableDays = slots
                .GroupBy(s => s.DayOfWeek)
                .Select(g => new AvailableDayViewModel
                {
                    DayOfWeek = g.Key,
                    Slots = g.Select(s => new SlotViewModel
                    {
                        StartTime = s.StartTime,
                        EndTime = s.EndTime
                    }).ToList()
                })
                .ToList();

            // Ratings
            var ratingData = await _context.Ratings
                .Where(r => r.MentorId == mentorId)
                .GroupBy(r => r.MentorId)
                .Select(g => new { Avg = (double)g.Average(r => r.Score), Count = g.Count() })
                .FirstOrDefaultAsync();

            var rates = await ComputeCompletionRatesAsync(new List<int> { mentorId });
            rates.TryGetValue(mentorId, out var compRate);

            var licenseType = await _context.LicenseTypes
                .FirstOrDefaultAsync(lt => lt.LicenseTypeId == mentor.LicenseTypeId);

            var vm = new MentorBookingViewModel
            {
                MentorId = mentorId,
                MentorName = mentor.FullName,
                City = mentor.City ?? string.Empty,
                LicenseType = licenseType?.LicenseName ?? string.Empty,
                PricePerSession = mentor.PricePerSession ?? 0,
                AverageRating = Math.Round(ratingData?.Avg ?? 0, 1),
                TotalRatings = ratingData?.Count ?? 0,
                CompletionRate = compRate,
                TraineeLicenseId = license.TraineeLicenseId,
                LicenseTypeId = license.LicenseTypeId,
                AvailableDays = availableDays
            };

            return ServiceResult<MentorBookingViewModel>.Success(vm);
        }

        // ─────────────────────────────────────────────────────────────────────────
        // BOOK SESSION
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<ServiceResult> BookSessionAsync(int traineeId, BookSessionViewModel model)
        {
            if (model.StartTime >= model.EndTime)
                return ServiceResult.Failure("Start time must be before end time.");

            if (model.SessionType is not ("theoretical" or "practical"))
                return ServiceResult.Failure("Invalid session type.");

            if (model.BookingDate < DateOnly.FromDateTime(DateTime.UtcNow))
            {
                return ServiceResult.Failure("Session Must be in the future");
            }
            await using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                // ── Blocked date ──────────────────────────────────────────────────
                bool isBlocked = await _context.BlockedDates
                    .AnyAsync(bd => bd.BlockedDate1 == model.BookingDate);

                if (isBlocked)
                    return ServiceResult.Failure("This date is blocked and unavailable for booking.");

                // ── Mentor approved ───────────────────────────────────────────────
                bool isApproved = await _context.MentorApplications
                    .AnyAsync(a => a.MentorId == model.MentorId && a.Status == "approved");

                if (!isApproved)
                    return ServiceResult.Failure("Selected mentor is not approved.");

                // ── Mentor conflict ───────────────────────────────────────────────
                bool mentorBusy = await _context.Bookings
                    .AnyAsync(b => b.MentorId == model.MentorId
                                && b.BookingDate == model.BookingDate
                                && b.Status != "cancelled"
                                && model.StartTime < b.EndTime
                                && model.EndTime > b.StartTime);

                if (mentorBusy)
                    return ServiceResult.Failure("Mentor is unavailable at that time. Please select another slot.");

                // ── Trainee conflict ──────────────────────────────────────────────
                bool traineeBusy = await _context.Bookings
                    .AnyAsync(b => b.TraineeId == traineeId
                                && b.BookingDate == model.BookingDate
                                && b.Status != "cancelled"
                                && model.StartTime < b.EndTime
                                && model.EndTime > b.StartTime);

                if (traineeBusy)
                    return ServiceResult.Failure("You already have a session at this time.");

                // ── Verify license belongs to trainee ─────────────────────────────
                var license = await _context.TraineeLicenses
                    .FirstOrDefaultAsync(tl => tl.TraineeLicenseId == model.TraineeLicenseId
                                            && tl.TraineeId == traineeId
                                            && tl.IsActive);

                if (license == null)
                    return ServiceResult.Failure("Invalid license.");

                // ── Create booking ────────────────────────────────────────────────
                var booking = new Booking
                {
                    TraineeId = traineeId,
                    MentorId = model.MentorId,
                    LicenseTypeId = model.LicenseTypeId,
                    SessionType = model.SessionType,
                    BookingDate = model.BookingDate,
                    StartTime = model.StartTime,
                    EndTime = model.EndTime,
                    Status = "pending",
                    TraineeLicenseId = model.TraineeLicenseId,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };

                _context.Bookings.Add(booking);
                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                // Notify both parties
                await _notifications.CreateAsync(
                    traineeId,
                    "Booking Requested",
                    $"Your session on {model.BookingDate:dd MMM yyyy} at {model.StartTime} is pending confirmation.",
                    "Booking");

                await _notifications.CreateAsync(
                    model.MentorId,
                    "New Booking Request",
                    $"You have a new session request on {model.BookingDate:dd MMM yyyy} at {model.StartTime}.",
                    "Booking");
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }

            return ServiceResult.Success();
        }

        // ─────────────────────────────────────────────────────────────────────────
        // CANCEL SESSION
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<ServiceResult> CancelSessionAsync(int traineeId, int bookingId)
        {
            var booking = await _context.Bookings
                .FirstOrDefaultAsync(b => b.BookingId == bookingId && b.TraineeId == traineeId);

            if (booking == null)
                return ServiceResult.Failure("Booking not found.");

            if (booking.Status is "cancelled" or "completed")
                return ServiceResult.Failure("This booking cannot be cancelled.");

            // Must be > 24 hours before session
            var sessionStart = booking.BookingDate.ToDateTime(booking.StartTime);
            if (sessionStart <= DateTime.UtcNow.AddHours(24))
                return ServiceResult.Failure("Cancellations must be made more than 24 hours before the session.");

            booking.Status = "cancelled";
            booking.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            await _notifications.CreateAsync(
                booking.MentorId,
                "Session Cancelled",
                $"The trainee has cancelled the session on {booking.BookingDate:dd MMM yyyy} at {booking.StartTime}.",
                "Booking");

            return ServiceResult.Success();
        }

        // ─────────────────────────────────────────────────────────────────────────
        // GET RESCHEDULE PAGE
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<ServiceResult<RescheduleTraineeViewModel>> GetReschedulePageAsync(
            int traineeId, int bookingId)
        {
            var booking = await _context.Bookings
                .FirstOrDefaultAsync(b => b.BookingId == bookingId && b.TraineeId == traineeId);

            if (booking == null)
                return ServiceResult<RescheduleTraineeViewModel>.Failure("Booking not found.");

            if (booking.Status is not ("pending" or "confirmed"))
                return ServiceResult<RescheduleTraineeViewModel>.Failure("This booking cannot be rescheduled.");

            var sessionStart = booking.BookingDate.ToDateTime(booking.StartTime);
            if (sessionStart <= DateTime.UtcNow.AddHours(24))
                return ServiceResult<RescheduleTraineeViewModel>.Failure("Reschedule must be requested more than 24 hours before the session.");

            // Load mentor info and availability
            var mentorUser = await _context.Users
                .Where(u => u.UserId == booking.MentorId)
                .Select(u => new { u.FirstName, u.LastName })
                .FirstOrDefaultAsync();

            var slots = await _context.MentorAvailabilities
                .Where(a => a.MentorId == booking.MentorId && a.IsActive == true)
                .OrderBy(a => a.DayOfWeek)
                .ThenBy(a => a.StartTime)
                .ToListAsync();

            var availableDays = slots
                .GroupBy(s => s.DayOfWeek)
                .Select(g => new AvailableDayViewModel
                {
                    DayOfWeek = g.Key,
                    Slots = g.Select(s => new SlotViewModel
                    {
                        StartTime = s.StartTime,
                        EndTime = s.EndTime
                    }).ToList()
                }).ToList();

            var vm = new RescheduleTraineeViewModel
            {
                BookingId = bookingId,
                MentorName = mentorUser != null ? $"{mentorUser.FirstName} {mentorUser.LastName}" : "Unknown",
                SessionType = booking.SessionType ?? string.Empty,
                NewDate = booking.BookingDate.AddDays(1),
                NewStartTime = booking.StartTime,
                NewEndTime = booking.EndTime,
                AvailableDays = availableDays
            };

            return ServiceResult<RescheduleTraineeViewModel>.Success(vm);
        }

        // ─────────────────────────────────────────────────────────────────────────
        // RESCHEDULE SESSION (trainee-initiated)
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<ServiceResult> RescheduleSessionAsync(
            int traineeId, RescheduleTraineeViewModel model)
        {
            if (model.NewStartTime >= model.NewEndTime)
                return ServiceResult.Failure("Start time must be before end time.");

            if (model.NewDate <= DateOnly.FromDateTime(DateTime.UtcNow))
                return ServiceResult.Failure("New date must be in the future.");

            await using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var booking = await _context.Bookings
                    .FirstOrDefaultAsync(b => b.BookingId == model.BookingId
                                           && b.TraineeId == traineeId);

                if (booking == null)
                    return ServiceResult.Failure("Booking not found.");

                if (booking.Status is not ("pending" or "confirmed"))
                    return ServiceResult.Failure("Booking cannot be rescheduled in its current state.");

                var sessionStart = booking.BookingDate.ToDateTime(booking.StartTime);
                if (sessionStart <= DateTime.UtcNow.AddHours(24))
                    return ServiceResult.Failure("Reschedule must be requested more than 24 hours before the session.");

                // Blocked date
                bool isBlocked = await _context.BlockedDates
                    .AnyAsync(bd => bd.BlockedDate1 == model.NewDate);

                if (isBlocked)
                    return ServiceResult.Failure("Selected date is blocked.");

                // Mentor conflict
                bool mentorBusy = await _context.Bookings
                    .AnyAsync(b => b.MentorId == booking.MentorId
                                && b.BookingDate == model.NewDate
                                && b.BookingId != booking.BookingId
                                && b.Status != "cancelled"
                                && model.NewStartTime < b.EndTime
                                && model.NewEndTime > b.StartTime);

                if (mentorBusy)
                    return ServiceResult.Failure("Mentor is unavailable at the selected time.");

                // Trainee conflict
                bool traineeBusy = await _context.Bookings
                    .AnyAsync(b => b.TraineeId == traineeId
                                && b.BookingDate == model.NewDate
                                && b.BookingId != booking.BookingId
                                && b.Status != "cancelled"
                                && model.NewStartTime < b.EndTime
                                && model.NewEndTime > b.StartTime);

                if (traineeBusy)
                    return ServiceResult.Failure("You already have a session at the selected time.");

                // Cancel old, create new (pending — mentor must re-confirm)
                booking.Status = "cancelled";
                booking.UpdatedAt = DateTime.UtcNow;

                var newBooking = new Booking
                {
                    TraineeId = traineeId,
                    MentorId = booking.MentorId,
                    LicenseTypeId = booking.LicenseTypeId,
                    SessionType = booking.SessionType,
                    BookingDate = model.NewDate,
                    StartTime = model.NewStartTime,
                    EndTime = model.NewEndTime,
                    Status = "pending",
                    TraineeLicenseId = booking.TraineeLicenseId,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };

                _context.Bookings.Add(newBooking);
                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                await _notifications.CreateAsync(
                    booking.MentorId,
                    "Session Rescheduled by Trainee",
                    $"A trainee has rescheduled their session to {model.NewDate:dd MMM yyyy} at {model.NewStartTime}.",
                    "Booking");
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }

            return ServiceResult.Success();
        }

        // ─────────────────────────────────────────────────────────────────────────
        // GET MY BOOKINGS
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<ServiceResult<TraineeBookingListViewModel>> GetMyBookingsAsync(int traineeId)
        {
            var now = DateTime.UtcNow;
            var mentorUser = await _context.TraineeLicenses
                .Where(tl => tl.TraineeId == traineeId)
                .Join(
                    _context.Users,
                    tl => tl.MentorId,
                    u => u.UserId,
                    (tl, u) => new
                    {
                        u.UserId,
                        FullName = u.FirstName + " " + u.LastName
                    }
                )
                .FirstOrDefaultAsync();

            var bookings = await _context.Bookings
                .AsNoTracking()
                .Where(b => b.TraineeId == traineeId)
                .OrderByDescending(b => b.BookingDate)
                .ThenByDescending(b => b.StartTime)
                .Select(b => new
                {
                    b.BookingId,
                    b.MentorId,
                    b.BookingDate,
                    b.StartTime,
                    b.EndTime,
                    b.SessionType,
                    b.Status,

                    MentorName = mentorUser != null? mentorUser.FullName: null,

                    MentorNotes = b.SessionFeedback != null
                        ? b.SessionFeedback.MentorNotes
                        : null,

                    Score = b.Rating != null
                        ? b.Rating.Score
                        : null
                })
                .ToListAsync();

            var items = bookings.Select(b =>
            {
                var sessionStart = b.BookingDate.ToDateTime(b.StartTime);
                bool canAct = sessionStart > now.AddHours(24)
                           && b.Status is "pending" or "confirmed";
                bool canSeeFeedback = b.MentorNotes != null;
                bool canRate = b.Score == null && sessionStart <= now && b.Status == "completed";
                return new TraineeBookingItemViewModel
                {
                    BookingId = b.BookingId,
                    MentorId = b.MentorId,
                    MentorName = b.MentorName,
                    BookingDate = b.BookingDate,
                    StartTime = b.StartTime,
                    EndTime = b.EndTime,
                    SessionType = b.SessionType ?? string.Empty,
                    Status = b.Status,
                    CanCancel = canAct,
                    CanReschedule = canAct,
                    CanSeeFeedback = canSeeFeedback,
                    CanRate = canRate,
                    Feedback = b.MentorNotes
                };
            }).ToList();

            return ServiceResult<TraineeBookingListViewModel>.Success(
                new TraineeBookingListViewModel
                {
                    Bookings = items,
                    PrimaryMentorId = mentorUser?.UserId,
                    PrimaryMentorName = mentorUser?.FullName
                });
        }
        public async Task<ServiceResult> RateSessionAsync(int traineeId, int bookingId, decimal score, string review)
        {
            var booking = await _context.Bookings
                .Where(b => b.BookingId == bookingId)
                .FirstOrDefaultAsync();

            if (booking == null)
                return ServiceResult.Failure("Booking not found.");

            if (booking.Status is not "completed")
                return ServiceResult.Failure("Only completed booking can be rated");

            var rating = new Rating
            {
                TraineeId = traineeId,
                MentorId = booking.MentorId,
                BookingId = bookingId,
                Score = score,
                ReviewText = review != null
                                ? review
                                : null,

                CreatedAt = DateTime.UtcNow
            };

            _context.Add(rating);
            _context.SaveChanges();

            return ServiceResult.Success();
        }

        // ─────────────────────────────────────────────────────────────────────────
        // PRIVATE: completion rate per mentor
        // ─────────────────────────────────────────────────────────────────────────
        private async Task<Dictionary<int, double>> ComputeCompletionRatesAsync(List<int> mentorIds)
        {
            // trainees per mentor (via bookings)
            var traineesPerMentor = await _context.Bookings
                .Where(b => mentorIds.Contains(b.MentorId))
                .GroupBy(b => b.MentorId)
                .Select(g => new { MentorId = g.Key, Total = g.Select(b => b.TraineeId).Distinct().Count() })
                .ToDictionaryAsync(x => x.MentorId);

            // completed license trainees per mentor
            var completedPerMentor = await _context.TraineeLicenses
                .Where(tl => tl.MentorId != null
                          && mentorIds.Contains(tl.MentorId!.Value)
                          && tl.Stage == "completed")
                .GroupBy(tl => tl.MentorId!.Value)
                .Select(g => new { MentorId = g.Key, Completed = g.Count() })
                .ToDictionaryAsync(x => x.MentorId);

            var result = new Dictionary<int, double>();
            foreach (var id in mentorIds)
            {
                traineesPerMentor.TryGetValue(id, out var total);
                completedPerMentor.TryGetValue(id, out var completed);
                result[id] = total?.Total > 0
                    ? Math.Round((double)(completed?.Completed ?? 0) / total!.Total * 100, 1)
                    : 0.0;
            }

            return result;
        }
    }
}

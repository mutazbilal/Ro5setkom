using Microsoft.EntityFrameworkCore;
using Org.BouncyCastle.Security;
using Rokhsetak.Areas.Mentor.ViewModels.Appointments;
using Rokhsetak.Areas.Mentor.ViewModels.Trainees;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;
using System.Globalization;

namespace Rokhsetak.Services.Implementations;

public class AppointmentService : IAppointmentService
{
    private readonly RokhsetakDbContext _context;
    private readonly INotificationService _notifications;

    public AppointmentService(RokhsetakDbContext context, INotificationService notifications)
    {
        _context = context;
        _notifications = notifications;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET ALL APPOINTMENTS
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<AppointmentListViewModel>> GetAllAppointmentsAsync(int mentorId, string culture)
    {
        var now = DateTime.UtcNow;
        var feedbackIds = await _context.SessionFeedbacks
            .Where(f => f.MentorId == mentorId)
            .Select(f => f.BookingId)
            .ToHashSetAsync();

        var items = await (
            from b in _context.Bookings
            join u in _context.Users on b.TraineeId equals u.UserId
            join lt in _context.LicenseTypes on b.LicenseTypeId equals lt.LicenseTypeId
            where b.MentorId == mentorId
            orderby b.BookingDate descending, b.StartTime descending
            select new
            {
                b.BookingId,
                b.TraineeId,
                b.BookingDate,
                b.StartTime,
                b.EndTime,
                b.SessionType,
                b.Status,
                b.CreatedAt,
                TraineeName = u.FirstName + " " + u.LastName,
                lt.LicenseName,
                u.DisplayNameEn,
                LicenseNameAr = lt.DisplayNameAr,
                LicenseNameEn = lt.DisplayNameEn
            }
        ).ToListAsync();

        var result = items.Select(i =>
        {
            var endDt = i.BookingDate.ToDateTime(i.EndTime);
            bool isPast = endDt <= now;
            bool canFeedback = i.Status == "completed" && !feedbackIds.Contains(i.BookingId);
            bool feedbackGiven = i.Status == "completed" && feedbackIds.Contains(i.BookingId);
            bool cancancel = i.Status == "pending" || i.Status == "confirmed" && !isPast;
            return new AppointmentItemViewModel
            {
                BookingId = i.BookingId,
                TraineeId = i.TraineeId,
                TraineeName = culture == "ar"? i.TraineeName :i.DisplayNameEn,
                BookingDate = i.BookingDate,
                StartTime = i.StartTime,
                EndTime = i.EndTime,
                SessionType = i.SessionType ?? string.Empty,
                Status = i.Status,
                LicenseType = culture == "ar"? i.LicenseNameAr :i.LicenseNameEn,
                CreatedAt = i.CreatedAt ?? DateTime.UtcNow,
                CanConfirm = i.Status == "pending",
                CanReschedule = i.Status == "pending",
                CanMarkDone = i.Status == "confirmed" && isPast,
                CanCancel = cancancel,
                CanFeedback = canFeedback,
                FeedbackGiven = feedbackGiven
            };
        }).ToList();

        return ServiceResult<AppointmentListViewModel>.Success(
            new AppointmentListViewModel { Items = result });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // CONFIRM BOOKING
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> ConfirmBookingAsync(int mentorId, int bookingId)
    {
        var booking = await _context.Bookings
            .FirstOrDefaultAsync(b => b.BookingId == bookingId);

        if (booking == null)
            return ServiceResult.Failure("Booking not found.");

        if (booking.MentorId != mentorId)
            return ServiceResult.Failure("Unauthorized.");

        if (booking.Status != "pending")
            return ServiceResult.Failure("Only pending bookings can be confirmed.");

        booking.Status = "confirmed";
        booking.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
        //update trainee license mentor id
        await ChangePrimaryMentorAsync(booking.TraineeId, mentorId);

        await _notifications.CreateAsync(
            booking.TraineeId,
            "Session Confirmed",
            $"Your session on {booking.BookingDate:dd MMM yyyy} at {booking.StartTime} has been confirmed.",
            "feedback");

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MARK AS DONE
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> MarkAsDoneAsync(int mentorId, int bookingId)
    {
        var booking = await _context.Bookings
            .FirstOrDefaultAsync(b => b.BookingId == bookingId);

        if (booking == null)
            return ServiceResult.Failure("Booking not found.");

        if (booking.MentorId != mentorId)
            return ServiceResult.Failure("Unauthorized.");

        if (booking.Status != "confirmed")
            return ServiceResult.Failure("Only confirmed bookings can be marked as done.");

        var sessionEndDt = booking.BookingDate.ToDateTime(booking.EndTime);
        if (sessionEndDt > DateTime.UtcNow)
            return ServiceResult.Failure("Session has not ended yet.");

        booking.Status = "completed";
        booking.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        await _notifications.CreateAsync(
            booking.TraineeId,
            "Session Completed",
            $"Your session on {booking.BookingDate:dd MMM yyyy} has been marked as completed.",
            "feedback");

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // CANCEL
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> Cancel(int mentorId, int bookingId)
    {
        var booking = await _context.Bookings
            .FirstOrDefaultAsync(b => b.BookingId == bookingId);

        if (booking == null)
            return ServiceResult.Failure("Booking not found.");

        if (booking.MentorId != mentorId)
            return ServiceResult.Failure("Unauthorized.");

        if (booking.Status != "confirmed" && booking.Status != "pending")
            return ServiceResult.Failure("Only confirmed or pending bookings can be cancelled.");


        booking.Status = "cancelled";
        booking.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        await _notifications.CreateAsync(
            booking.TraineeId,
            "Session cancelled",
            $"Your session on {booking.BookingDate:dd MMM yyyy} has been cancelled.",
            "booking");

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // RESCHEDULE
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> RescheduleAsync(int mentorId, RescheduleViewModel model)
    {
        if (model.NewStartTime >= model.NewEndTime)
            return ServiceResult.Failure("Start time must be before end time.");

        if (model.NewDate <= DateOnly.FromDateTime(DateTime.UtcNow))
            return ServiceResult.Failure("New date must be in the future.");

        await using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            // Re-read inside transaction to prevent races
            var booking = await _context.Bookings
                .FirstOrDefaultAsync(b => b.BookingId == model.BookingId);

            if (booking == null)
                return ServiceResult.Failure("Booking not found.");

            if (booking.MentorId != mentorId)
                return ServiceResult.Failure("Unauthorized.");

            if (booking.Status != "pending")
                return ServiceResult.Failure("Only pending bookings can be rescheduled.");

            // ── Blocked date check ────────────────────────────────────────────
            bool isBlocked = await _context.BlockedDates
                .AnyAsync(bd => bd.BlockedDate1 == model.NewDate);

            if (isBlocked)
                return ServiceResult.Failure("Selected date is a blocked date.");

            // ── Mentor conflict check ─────────────────────────────────────────
            bool mentorConflict = await _context.Bookings
                .AnyAsync(b => b.MentorId == mentorId
                            && b.BookingDate == model.NewDate
                            && b.Status != "cancelled"
                            && model.NewStartTime < b.EndTime
                            && model.NewEndTime > b.StartTime);

            if (mentorConflict)
                return ServiceResult.Failure("You have another session at the selected time.");

            // ── Trainee conflict check ────────────────────────────────────────
            bool traineeConflict = await _context.Bookings
                .AnyAsync(b => b.TraineeId == booking.TraineeId
                            && b.BookingDate == model.NewDate
                            && b.Status != "cancelled"
                            && model.NewStartTime < b.EndTime
                            && model.NewEndTime > b.StartTime);

            if (traineeConflict)
                return ServiceResult.Failure("Trainee already has a booking at the selected time.");

            // ── Cancel original booking ───────────────────────────────────────
            booking.Status = "cancelled";
            booking.UpdatedAt = DateTime.UtcNow;

            // ── Create new booking ────────────────────────────────────────────
            var newBooking = new Booking
            {
                TraineeId = booking.TraineeId,
                MentorId = mentorId,
                LicenseTypeId = booking.LicenseTypeId,
                SessionType = booking.SessionType,
                BookingDate = model.NewDate,
                StartTime = model.NewStartTime,
                EndTime = model.NewEndTime,
                Status = "confirmed",  // mentor-initiated reschedule → auto-confirmed
                TraineeLicenseId = booking.TraineeLicenseId,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.Bookings.Add(newBooking);
            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            await _notifications.CreateAsync(
                booking.TraineeId,
                "Session Rescheduled",
                $"Your session has been rescheduled to {model.NewDate:dd MMM yyyy} at {model.NewStartTime}.",
                "feedback");
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GIVE FEEDBACK
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> GiveFeedbackAsync(int mentorId, FeedbackViewModel model)
    {
        var booking = await _context.Bookings
            .FirstOrDefaultAsync(b => b.BookingId == model.BookingId);

        if (booking == null)
            return ServiceResult.Failure("Booking not found.");

        if (booking.MentorId != mentorId)
            return ServiceResult.Failure("Unauthorized.");

        if (booking.Status != "completed")
            return ServiceResult.Failure("Feedback can only be given after a completed session.");

        bool alreadyExists = await _context.SessionFeedbacks
            .AnyAsync(f => f.BookingId == model.BookingId);

        if (alreadyExists)
            return ServiceResult.Failure("Feedback has already been submitted for this session.");

        _context.SessionFeedbacks.Add(new SessionFeedback
        {
            BookingId = model.BookingId,
            TraineeId = booking.TraineeId,
            MentorId = mentorId,
            MentorNotes = model.MentorNotes,
            CreatedAt = DateTime.UtcNow
        });

        await _context.SaveChangesAsync();

        await _notifications.CreateAsync(
            booking.TraineeId,
            "Session Feedback Available",
            "Your mentor has submitted feedback for your last session.",
            "feedback");

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // TRAINEE SUMMARY LIST
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<TraineeSummaryListViewModel>> GetTraineeSummaryAsync(
        int mentorId, string? search, string? statusFilter, string culture)
    {
        // Get distinct trainees who have ≥1 booking with this mentor
        var traineeIds = await _context.Bookings
            .Where(b => b.MentorId == mentorId)
            .Select(b => b.TraineeId)
            .Distinct()
            .ToListAsync();

        if (!traineeIds.Any())
        {
            return ServiceResult<TraineeSummaryListViewModel>.Success(
                new TraineeSummaryListViewModel { SearchTerm = search, StatusFilter = statusFilter });
        }

        // Session stats per trainee
        var sessionStats = await _context.Bookings
            .Where(b => b.MentorId == mentorId && traineeIds.Contains(b.TraineeId))
            .GroupBy(b => b.TraineeId)
            .Select(g => new
            {
                TraineeId = g.Key,
                TotalSessions = g.Count(),
                LastSessionDate = g.Max(b => b.BookingDate)
            })
            .ToDictionaryAsync(x => x.TraineeId);

        // User info for trainee IDs
        var users = await _context.Users
            .Where(u => traineeIds.Contains(u.UserId))
            .Select(u => new { u.UserId, u.FirstName, u.LastName, u.DisplayNameEn})
            .ToDictionaryAsync(u => u.UserId);

        // Active license info
        var licenses = await _context.TraineeLicenses
            .Where(tl => traineeIds.Contains(tl.TraineeId) && tl.IsActive)
            .Join(_context.LicenseTypes,
                  tl => tl.LicenseTypeId,
                  lt => lt.LicenseTypeId,
                  (tl, lt) => new { tl.TraineeId, tl.Stage, lt.DisplayNameAr, lt.DisplayNameEn })
            .ToDictionaryAsync(x => x.TraineeId);

        var items = traineeIds
            .Select(tid =>
            {
                users.TryGetValue(tid, out var u);
                sessionStats.TryGetValue(tid, out var stats);
                licenses.TryGetValue(tid, out var lic);
                return new TraineeSummaryItem
                {
                    TraineeId = tid,
                    FullName =  culture == "ar" ? $"{u.FirstName} {u.LastName}" : u.DisplayNameEn,
                    TotalSessions = stats?.TotalSessions ?? 0,
                    LastSessionDate = stats?.LastSessionDate,
                    LicenseStage = lic?.Stage ?? "—",
                    LicenseType = culture == "ar"? lic.DisplayNameAr :lic.DisplayNameEn
                };
            })
            .AsQueryable();

        // Apply search
        if (!string.IsNullOrWhiteSpace(search))
        {
            var lower = search.ToLower();
            items = items.Where(i => i.FullName.ToLower().Contains(lower));
        }

        // Apply status filter
        if (!string.IsNullOrWhiteSpace(statusFilter))
        {
            items = items.Where(i => i.LicenseStage == statusFilter);
        }

        var vm = new TraineeSummaryListViewModel
        {
            SearchTerm = search,
            StatusFilter = statusFilter,
            Trainees = items.OrderByDescending(i => i.LastSessionDate).ToList()
        };

        return ServiceResult<TraineeSummaryListViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // TRAINEE DETAIL
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<TraineeDetailViewModel>> GetTraineeDetailAsync(
        int mentorId, int traineeId, string culture)
    {
        // Verify this mentor has at least one booking with this trainee
        bool hasRelationship = await _context.Bookings
            .AnyAsync(b => b.MentorId == mentorId && b.TraineeId == traineeId);

        if (!hasRelationship)
            return ServiceResult<TraineeDetailViewModel>.Failure("Trainee not found in your sessions.");

        var user = await _context.Users
            .Where(u => u.UserId == traineeId)
            .Select(u => new { u.FirstName, u.LastName, u.Email, u.DisplayNameEn})
            .FirstOrDefaultAsync();

        if (user == null)
            return ServiceResult<TraineeDetailViewModel>.Failure("Trainee user record not found.");

        var license = await _context.TraineeLicenses
            .Where(tl => tl.TraineeId == traineeId && tl.IsActive)
            .Join(_context.LicenseTypes,
                  tl => tl.LicenseTypeId,
                  lt => lt.LicenseTypeId,
                  (tl, lt) => new
                  {
                      tl.Stage,
                      lt.DisplayNameAr,
                      lt.DisplayNameEn,
                      tl.ProgressPercentage
                  })
            .FirstOrDefaultAsync();

        var sessions = await _context.Bookings
            .Where(b => b.MentorId == mentorId && b.TraineeId == traineeId)
            .OrderByDescending(b => b.BookingDate)
            .Select(b => new TraineeSessionItem
            {
                BookingId = b.BookingId,
                SessionDate = b.BookingDate,
                StartTime = b.StartTime,
                EndTime = b.EndTime,
                SessionType = b.SessionType ?? string.Empty,
                Status = b.Status
            })
            .ToListAsync();

        var feedbacks = await _context.SessionFeedbacks
            .Where(f => f.MentorId == mentorId && f.TraineeId == traineeId)
            .Join(_context.Bookings,
                  f => f.BookingId,
                  b => b.BookingId,
                  (f, b) => new TraineeFeedbackItem
                  {
                      FeedbackId = f.FeedbackId,
                      BookingId = f.BookingId,
                      SessionDate = b.BookingDate,
                      MentorNotes = f.MentorNotes ?? string.Empty,
                      CreatedAt = f.CreatedAt ?? DateTime.UtcNow,
                  })
            .OrderByDescending(f => f.CreatedAt)
            .ToListAsync();

        var vm = new TraineeDetailViewModel
        {
            TraineeId = traineeId,
            FullName = $"{user.FirstName} {user.LastName}",
            Email = user.Email,
            LicenseStage = license?.Stage ?? "—",
            LicenseType = culture == "ar"? license.DisplayNameAr :license.DisplayNameEn,
            ProgressPct = license?.ProgressPercentage ?? 0,
            Sessions = sessions,
            Feedbacks = feedbacks
        };

        return ServiceResult<TraineeDetailViewModel>.Success(vm);
    }

    private async Task ChangePrimaryMentorAsync(int traineeId, int newMentorId)
    {
        //update trainee license mentor id
        var tl = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeId == traineeId);
        var oldMentorId = tl.MentorId;
        
        if (oldMentorId == null)
            return;
        if (oldMentorId != newMentorId)
        {
            tl.MentorId = newMentorId;
            tl.UpdatedAt = DateTime.UtcNow;
        }

        var traineeName = await _context.Users
            .Where(t => t.UserId == traineeId)
            .Select(t => t.FirstName + "" + t.LastName)
            .FirstOrDefaultAsync();

        var mentorName = await _context.Users
            .Where(m => m.UserId == oldMentorId)
            .Select(t => t.FirstName + "" + t.LastName)
            .FirstOrDefaultAsync();

        var oldBbookings = await _context.Bookings
            .Where(b => b.MentorId == oldMentorId && b.TraineeId == traineeId)
            .ToListAsync();

        foreach (var booking in oldBbookings)
        {
            booking.Status = "cancelled";
        }
        await _context.SaveChangesAsync();
        var traineeMessage = "all your future bookings with your mentor have been cancelled";
        if (mentorName != "")
        {
            traineeMessage = $"all your future bookings with {mentorName} have been cancelled";
        }

        var mentorMessage = "all your future bookings with a trainee have been cancelled";
        if (traineeName != "")
        {
            mentorMessage = $"all your future bookings with {traineeName} have been cancelled";
        }

        await _notifications.CreateAsync(traineeId, "bookings cancelled", traineeMessage, "booking");
        await _notifications.CreateAsync(oldMentorId.Value, "bookings cancelled", mentorMessage, "booking");
    }
}
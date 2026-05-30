using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Mentor.ViewModels.Dashboard;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations;

public class MentorDashboardService : IMentorDashboardService
{
    private readonly RokhsetakDbContext _context;

    public MentorDashboardService(RokhsetakDbContext context)
    {
        _context = context;
    }

    public async Task<ServiceResult<MentorDashboardViewModel>> GetDashboardAsync(int mentorId, string culture)
    {
        // Verify mentor exists
        var mentor = await _context.Mentors
            .FirstOrDefaultAsync(m => m.MentorId == mentorId);

        if (mentor == null)
            return ServiceResult<MentorDashboardViewModel>.Failure("Mentor not found.");

        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        var dayOfWeek = DateTime.UtcNow.DayOfWeek.ToString().ToLower();

        // ─── Load all data concurrently ───────────────────────────────────────
        var bookingsTask = await LoadBookingsAsync(mentorId, culture);
        var feedbackTask = await LoadFeedbackBookingIdsAsync(mentorId);
        var slotsTask = await LoadAvailabilityAsync(mentorId, dayOfWeek);
        var pendingCountTask = await _context.Bookings.CountAsync(b => b.MentorId == mentorId && b.Status == "pending");
        var confirmedCountTask = await _context.Bookings.CountAsync(b => b.MentorId == mentorId && b.Status == "confirmed" && b.BookingDate >= today);

        var rawBookings =  bookingsTask;
        var feedbackIds = feedbackTask;
        var rawSlots = slotsTask;

        var now = DateTime.UtcNow;

        // ─── Map bookings to SessionCardViewModels ────────────────────────────
        var allCards = rawBookings.Select(rb => BuildSessionCard(rb, feedbackIds, now)).ToList();

        var todaysConfirmed = allCards
            .Where(c => c.Status == "confirmed" && c.BookingDate == today)
            .OrderBy(c => c.StartTime)
            .ToList();

        var pending = allCards
            .Where(c => c.Status == "pending")
            .OrderBy(c => c.BookingDate)
            .ThenBy(c => c.StartTime)
            .ToList();

        // ─── Map availability slots, marking booked ones ──────────────────────
        var bookedTimesForToday = allCards
            .Where(c => c.BookingDate == today && c.Status is "confirmed" or "pending")
            .Select(c => (c.StartTime, c.EndTime))
            .ToList();

        var availabilitySlots = rawSlots.Select(s => new AvailabilitySlotViewModel
        {
            StartTime = s.StartTime,
            EndTime = s.EndTime,
            IsBooked = bookedTimesForToday.Any(b =>
                b.StartTime < s.EndTime && b.EndTime > s.StartTime)
        })
        .OrderBy(s => s.StartTime)
        .ToList();

        var vm = new MentorDashboardViewModel
        {
            Today = today,
            TodayDayOfWeek = dayOfWeek,
            TodaysConfirmedSessions = todaysConfirmed,
            TodaysAvailabilitySlots = availabilitySlots,
            PendingBookings = pending,
            TotalPendingCount = pendingCountTask,
            TotalConfirmedUpcomingCount = confirmedCountTask
        };

        return ServiceResult<MentorDashboardViewModel>.Success(vm);
    }

    // ─── Private helpers ──────────────────────────────────────────────────────

    private async Task<List<RawBookingRow>> LoadBookingsAsync(int mentorId, string culture)
    {
        var today = DateOnly.FromDateTime(DateTime.UtcNow);

        return await (
            from b in _context.Bookings
            join u in _context.Users on b.TraineeId equals u.UserId
            where b.MentorId == mentorId
               && b.Status != "cancelled"
               && b.BookingDate >= today.AddDays(-1) // yesterday + onwards for dashboard relevance
            select new RawBookingRow
            {
                BookingId = b.BookingId,
                TraineeId = b.TraineeId,
                TraineeName = culture == "ar" ? u.FirstName + " " + u.LastName : u.DisplayNameEn,
                BookingDate = b.BookingDate,
                StartTime = b.StartTime,
                EndTime = b.EndTime,
                SessionType = b.SessionType ?? string.Empty,
                Status = b.Status
            }
        ).ToListAsync();
    }

    private async Task<HashSet<int>> LoadFeedbackBookingIdsAsync(int mentorId)
    {
        var ids = await _context.SessionFeedbacks
            .Where(f => f.MentorId == mentorId)
            .Select(f => f.BookingId)
            .ToListAsync();
        return ids.ToHashSet();
    }

    private async Task<List<RawSlotRow>> LoadAvailabilityAsync(int mentorId, string dayOfWeek)
    {
        return await _context.MentorAvailabilities
            .Where(a => a.MentorId == mentorId && a.DayOfWeek == dayOfWeek && a.IsActive == true)
            .Select(a => new RawSlotRow { StartTime = a.StartTime, EndTime = a.EndTime })
            .ToListAsync();
    }

    private static SessionCardViewModel BuildSessionCard(
        RawBookingRow rb, HashSet<int> feedbackIds, DateTime now)
    {
        var sessionEndDt = rb.BookingDate.ToDateTime(rb.EndTime);
        bool isPast = sessionEndDt <= now;

        bool canFeedback = rb.Status == "completed" && !feedbackIds.Contains(rb.BookingId);
        bool feedbackGiven = rb.Status == "completed" && feedbackIds.Contains(rb.BookingId);

        return new SessionCardViewModel
        {
            BookingId = rb.BookingId,
            TraineeId = rb.TraineeId,
            TraineeName = rb.TraineeName,
            BookingDate = rb.BookingDate,
            StartTime = rb.StartTime,
            EndTime = rb.EndTime,
            SessionType = rb.SessionType,
            Status = rb.Status,
            CanConfirm = rb.Status == "pending",
            CanReschedule = rb.Status == "pending",
            CanMarkDone = rb.Status == "confirmed" && isPast,
            CanFeedback = canFeedback,
            FeedbackGiven = feedbackGiven
        };
    }

    // ─── Internal DTOs (avoid EF tracking across async calls) ─────────────────

    private sealed record RawBookingRow
    {
        public int BookingId { get; init; }
        public int TraineeId { get; init; }
        public string TraineeName { get; init; } = string.Empty;
        public DateOnly BookingDate { get; init; }
        public TimeOnly StartTime { get; init; }
        public TimeOnly EndTime { get; init; }
        public string SessionType { get; init; } = string.Empty;
        public string Status { get; init; } = string.Empty;
    }

    private sealed record RawSlotRow
    {
        public TimeOnly StartTime { get; init; }
        public TimeOnly EndTime { get; init; }
    }
}
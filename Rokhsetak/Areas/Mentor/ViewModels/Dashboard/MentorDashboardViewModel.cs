namespace Rokhsetak.Areas.Mentor.ViewModels.Dashboard;

public class MentorDashboardViewModel
{
    public DateOnly Today { get; set; }
    public string TodayDayOfWeek { get; set; } = string.Empty;

    /// <summary>Today's confirmed sessions — the schedule table.</summary>
    public List<SessionCardViewModel> TodaysConfirmedSessions { get; set; } = new();

    /// <summary>Recurring availability slots for today's day-of-week.</summary>
    public List<AvailabilitySlotViewModel> TodaysAvailabilitySlots { get; set; } = new();

    /// <summary>ALL pending bookings (not just today) that need the mentor's attention.</summary>
    public List<SessionCardViewModel> PendingBookings { get; set; } = new();

    public int TotalPendingCount { get; set; }
    public int TotalConfirmedUpcomingCount { get; set; }
}

public class SessionCardViewModel
{
    public int BookingId { get; set; }
    public int TraineeId { get; set; }
    public string TraineeName { get; set; } = string.Empty;
    public DateOnly BookingDate { get; set; }
    public TimeOnly StartTime { get; set; }
    public TimeOnly EndTime { get; set; }
    public string SessionType { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;

    // Action availability
    public bool CanConfirm { get; set; }
    public bool CanReschedule { get; set; }
    public bool CanMarkDone { get; set; }
    public bool CanFeedback { get; set; }
    public bool FeedbackGiven { get; set; }
}

public class AvailabilitySlotViewModel
{
    public TimeOnly StartTime { get; set; }
    public TimeOnly EndTime { get; set; }
    public bool IsBooked { get; set; }
}
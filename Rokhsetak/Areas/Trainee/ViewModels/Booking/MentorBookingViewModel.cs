namespace Rokhsetak.Areas.Trainee.ViewModels.Booking;

public class MentorBookingViewModel
{
    public int MentorId { get; set; }
    public Models.Mentor? Mentor { get; set; }
    public string LicenseType { get; set; } = string.Empty;
    public double AverageRating { get; set; }
    public int TotalRatings { get; set; }
    public double CompletionRate { get; set; }

    public int TraineeLicenseId { get; set; }
    public int LicenseTypeId { get; set; }

    /// <summary>Grouped by day of week → available time slots.</summary>
    public List<AvailableDayViewModel> AvailableDays { get; set; } = new();
}

public class AvailableDayViewModel
{
    public string DayOfWeek { get; set; } = string.Empty;
    public List<SlotViewModel> Slots { get; set; } = new();
}

public class SlotViewModel
{
    public TimeOnly StartTime { get; set; }
    public TimeOnly EndTime { get; set; }
}
namespace Rokhsetak.Areas.Mentor.ViewModels.Appointments;

public class AppointmentListViewModel
{
    public List<AppointmentItemViewModel> Items { get; set; } = new();
}

public class AppointmentItemViewModel
{
    public int BookingId { get; set; }
    public int TraineeId { get; set; }
    public string TraineeName { get; set; } = string.Empty;
    public DateOnly BookingDate { get; set; }
    public TimeOnly StartTime { get; set; }
    public TimeOnly EndTime { get; set; }
    public string SessionType { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string LicenseType { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }

    // Computed action flags (set by service)
    public bool CanConfirm { get; set; }
    public bool CanReschedule { get; set; }
    public bool CanMarkDone { get; set; }
    public bool CanFeedback { get; set; }
    public bool FeedbackGiven { get; set; }
}
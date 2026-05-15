namespace Rokhsetak.Areas.Mentor.ViewModels.Trainees;

public class TraineeDetailViewModel
{
    public int TraineeId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string LicenseStage { get; set; } = string.Empty;
    public string LicenseType { get; set; } = string.Empty;
    public int ProgressPct { get; set; }

    public List<TraineeSessionItem> Sessions { get; set; } = new();
    public List<TraineeFeedbackItem> Feedbacks { get; set; } = new();
}

public class TraineeSessionItem
{
    public int BookingId { get; set; }
    public DateOnly SessionDate { get; set; }
    public TimeOnly StartTime { get; set; }
    public TimeOnly EndTime { get; set; }
    public string SessionType { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
}

public class TraineeFeedbackItem
{
    public int FeedbackId { get; set; }
    public int BookingId { get; set; }
    public DateOnly SessionDate { get; set; }
    public string MentorNotes { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
}
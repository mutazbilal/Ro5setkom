namespace Rokhsetak.Areas.Mentor.ViewModels.Trainees;

public class TraineeSummaryListViewModel
{
    public string? SearchTerm { get; set; }
    public string? StatusFilter { get; set; }

    public List<TraineeSummaryItem> Trainees { get; set; } = new();

    public static readonly List<string> AvailableStatuses = new()
    {
        "registered", "theoretical_prep", "mock_exam_completed",
        "theory_test_pending", "theory_passed", "medical_exam_pending",
        "medical_passed", "practical_prep", "practical_test_pending", "completed"
    };
}

public class TraineeSummaryItem
{
    public int TraineeId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public int TotalSessions { get; set; }
    public DateOnly? LastSessionDate { get; set; }
    public string LicenseStage { get; set; } = string.Empty;
    public string LicenseType { get; set; } = string.Empty;
}
namespace Rokhsetak.Areas.Trainee.ViewModels.Exam;

public class ExamBookingViewModel
{
    public string ExamType { get; set; } = string.Empty;
    public int TraineeLicenseId { get; set; }
    public bool IsEligible { get; set; }
    public string IneligibilityReason { get; set; } = string.Empty;
    public List<ExamSlotViewModel> AvailableSlots { get; set; } = new();
}

public class ExamSlotViewModel
{
    public int OfficialExamId { get; set; }
    public string CenterName { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public DateOnly ExamDate { get; set; }
    public TimeOnly ExamTime { get; set; }
    public int SlotsRemaining { get; set; }
}
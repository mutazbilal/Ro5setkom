namespace Rokhsetak.Areas.Trainee.ViewModels.Exam;

public class ExamAppointmentListViewModel
{
    public List<ExamAppointmentItemViewModel> Appointments { get; set; } = new();
}

public class ExamAppointmentItemViewModel
{
    public int AppointmentId { get; set; }
    public int OfficialExamId { get; set; }
    public string ExamType { get; set; } = string.Empty;
    public string CenterName { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public DateOnly ExamDate { get; set; }
    public TimeOnly ExamTime { get; set; }
    public string Status { get; set; } = string.Empty;

    // Result from GovExamResults (null if not recorded yet)
    public string? Result { get; set; }
    public int? Score { get; set; }
    public bool CanCancel { get; set; }
}
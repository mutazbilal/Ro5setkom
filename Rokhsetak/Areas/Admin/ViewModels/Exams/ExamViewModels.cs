namespace Rokhsetak.Areas.Admin.ViewModels.Exams;

public class ExamFilter
{
    public string? Status { get; set; }
    public DateOnly? FromDate { get; set; }
    public DateOnly? ToDate { get; set; }
    public int? TraineeId { get; set; }
    public string? Search { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
}

public class AdminExamAppointmentItem
{
    public int ExamAppointmentId { get; set; }
    public int OfficialExamId { get; set; }
    public string TraineeName { get; set; } = string.Empty;
    public int TraineeId { get; set; }
    public DateOnly ExamDate { get; set; }
    public TimeOnly ExamTime { get; set; }
    public string ExamType { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string CenterName { get; set; } = string.Empty;
    public string LicenseType { get; set; } = string.Empty;
    public DateTime? CreatedAt { get; set; }
}

public class AdminExamAppointmentListViewModel
{
    public ExamFilter Filter { get; set; } = new();
    public List<AdminExamAppointmentItem> Items { get; set; } = new();
    public int TotalCount { get; set; }
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)Filter.PageSize);
}

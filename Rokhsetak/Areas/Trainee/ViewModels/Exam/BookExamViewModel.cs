using System.ComponentModel.DataAnnotations;

namespace Rokhsetak.Areas.Trainee.ViewModels.Exam;

public class BookExamViewModel
{
    [Required]
    public int OfficialExamId { get; set; }

    [Required]
    public int TraineeLicenseId { get; set; }

    [Required]
    public string ExamType { get; set; } = string.Empty;
}
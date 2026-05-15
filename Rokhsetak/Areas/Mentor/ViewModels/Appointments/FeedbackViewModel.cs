using System.ComponentModel.DataAnnotations;

namespace Rokhsetak.Areas.Mentor.ViewModels.Appointments;

public class FeedbackViewModel
{
    [Required]
    public int BookingId { get; set; }

    public string TraineeName { get; set; } = string.Empty;
    public DateOnly SessionDate { get; set; }

    [Required(ErrorMessage = "Feedback notes are required.")]
    [StringLength(2000, MinimumLength = 5, ErrorMessage = "Notes must be between 5 and 2000 characters.")]
    public string MentorNotes { get; set; } = string.Empty;
}
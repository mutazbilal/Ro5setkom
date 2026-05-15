using System.ComponentModel.DataAnnotations;

namespace Rokhsetak.Areas.Mentor.ViewModels.Appointments;

public class RescheduleViewModel
{
    [Required]
    public int BookingId { get; set; }

    public string TraineeName { get; set; } = string.Empty;
    public string SessionType { get; set; } = string.Empty;

    [Required(ErrorMessage = "New date is required.")]
    public DateOnly NewDate { get; set; }

    [Required(ErrorMessage = "Start time is required.")]
    public TimeOnly NewStartTime { get; set; }

    [Required(ErrorMessage = "End time is required.")]
    public TimeOnly NewEndTime { get; set; }
}
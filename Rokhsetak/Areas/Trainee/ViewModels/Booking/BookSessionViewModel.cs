using System.ComponentModel.DataAnnotations;

namespace Rokhsetak.Areas.Trainee.ViewModels.Booking;

public class BookSessionViewModel
{
    [Required]
    public int MentorId { get; set; }

    [Required]
    public int TraineeLicenseId { get; set; }

    [Required]
    public int LicenseTypeId { get; set; }

    [Required(ErrorMessage = "Session type is required.")]
    public string SessionType { get; set; } = string.Empty;  // theoretical | practical

    [Required(ErrorMessage = "Booking date is required.")]
    public DateOnly BookingDate { get; set; }

    [Required(ErrorMessage = "Start time is required.")]
    public TimeOnly StartTime { get; set; }

    [Required(ErrorMessage = "End time is required.")]
    public TimeOnly EndTime { get; set; }
}
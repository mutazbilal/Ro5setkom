using Rokhsetak.Areas.Trainee.ViewModels.Booking;
using System.ComponentModel.DataAnnotations;

namespace Rokhsetak.Areas.Trainee.ViewModels.Booking;

public class RescheduleTraineeViewModel
{
    [Required]
    public int BookingId { get; set; }

    public string MentorName { get; set; } = string.Empty;
    public string SessionType { get; set; } = string.Empty;

    [Required(ErrorMessage = "New date is required.")]
    public DateOnly NewDate { get; set; }

    [Required(ErrorMessage = "Start time is required.")]
    public TimeOnly NewStartTime { get; set; }

    [Required(ErrorMessage = "End time is required.")]
    public TimeOnly NewEndTime { get; set; }

    /// <summary>Available slots for the mentor (populated by service for the view).</summary>
    public List<AvailableDayViewModel> AvailableDays { get; set; } = new();
}
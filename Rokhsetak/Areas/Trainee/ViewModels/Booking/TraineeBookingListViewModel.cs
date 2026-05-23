namespace Rokhsetak.Areas.Trainee.ViewModels.Booking;

public class TraineeBookingListViewModel
{
    public List<TraineeBookingItemViewModel> Bookings { get; set; } = new();
    public int? PrimaryMentorId { get; set; }
    public string? PrimaryMentorName { get; set; }
}

public class TraineeBookingItemViewModel
{
    public int BookingId { get; set; }
    public int MentorId { get; set; }
    public string MentorName { get; set; } = string.Empty;
    public DateOnly BookingDate { get; set; }
    public TimeOnly StartTime { get; set; }
    public TimeOnly EndTime { get; set; }
    public string SessionType { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public bool CanCancel { get; set; }
    public bool CanReschedule { get; set; }
}
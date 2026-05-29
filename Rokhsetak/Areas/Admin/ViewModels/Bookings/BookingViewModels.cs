namespace Rokhsetak.Areas.Admin.ViewModels.Bookings;

public class BookingFilter
{
    public string? Status { get; set; }
    public DateOnly? FromDate { get; set; }
    public DateOnly? ToDate { get; set; }
    public int? MentorId { get; set; }
    public int? TraineeId { get; set; }
    public string? Search { get; set; }   // trainee or mentor name
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
}

public class AdminBookingItem
{
    public int BookingId { get; set; }
    public string TraineeName { get; set; } = string.Empty;
    public int TraineeId { get; set; }
    public string MentorName { get; set; } = string.Empty;
    public int MentorId { get; set; }
    public DateOnly BookingDate { get; set; }
    public TimeOnly StartTime { get; set; }
    public TimeOnly EndTime { get; set; }
    public string SessionType { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string LicenseType { get; set; } = string.Empty;
    public DateTime? CreatedAt { get; set; }
}

public class AdminBookingListViewModel
{
    public BookingFilter Filter { get; set; } = new();
    public List<AdminBookingItem> Items { get; set; } = new();
    public int TotalCount { get; set; }
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)Filter.PageSize);
}

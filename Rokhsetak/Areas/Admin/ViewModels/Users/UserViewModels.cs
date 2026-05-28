using System.ComponentModel.DataAnnotations;

namespace Rokhsetak.Areas.Admin.ViewModels.Users;

public class UserListFilter
{
    public string? Search { get; set; }
    public string? Role { get; set; }       // "trainee" | "mentor" | "admin"
    public string? Status { get; set; }     // "active" | "inactive"
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
}

public class UserListItem
{
    public int UserId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Role { get; set; } = string.Empty;
    public bool IsActive { get; set; }
    public DateTime? CreatedAt { get; set; }
    public string? PhoneNumber { get; set; }
}

public class UserListViewModel
{
    public UserListFilter Filter { get; set; } = new();
    public List<UserListItem> Items { get; set; } = new();
    public int TotalCount { get; set; }
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)Filter.PageSize);
}

public class UserBookingHistoryItem
{
    public int BookingId { get; set; }
    public DateOnly BookingDate { get; set; }
    public TimeOnly StartTime { get; set; }
    public TimeOnly EndTime { get; set; }
    public string Counterparty { get; set; } = string.Empty;
    public string SessionType { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
}

public class UserDetailViewModel
{
    public int UserId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? PhoneNumber { get; set; }
    public string? NationalId { get; set; }
    public string Role { get; set; } = string.Empty;
    public bool IsActive { get; set; }
    public DateTime? CreatedAt { get; set; }
    public DateOnly? DateOfBirth { get; set; }
    public string? Gender { get; set; }
    public string? City { get; set; }
    public string? Province { get; set; }
    public string? AddressLine1 { get; set; }
    public string? ProfilePicture { get; set; }

    public List<UserBookingHistoryItem> BookingHistory { get; set; } = new();
}

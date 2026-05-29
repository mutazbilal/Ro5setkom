using Rokhsetak.ViewModels.Registration;

namespace Rokhsetak.Areas.Admin.ViewModels.Mentors;

public class MentorListFilter
{
    public string? Search { get; set; }
    public string? Status { get; set; }       // "active" | "inactive"
    public int? LicenseTypeId { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
    public int? CityId { get; set; }
}

public class MentorListItem
{
    public int MentorId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? PhoneNumber { get; set; }
    public string LicenseType { get; set; } = string.Empty;
    public string? CityName { get; set; }
    public decimal? PricePerSession { get; set; }
    public bool IsActive { get; set; }
    public string ApplicationStatus { get; set; } = string.Empty;
    public double AverageRating { get; set; }
    public int TotalSessions { get; set; }
}

public class MentorListViewModel
{
    public MentorListFilter Filter { get; set; } = new();
    public List<MentorListItem> Items { get; set; } = new();
    public int TotalCount { get; set; }
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)Filter.PageSize);

    public List<(int Id, string Name)> LicenseTypeOptions { get; set; } = new();
    public List<CityOption?>? Cities { get; set; }
}

public class MentorDetailViewModel
{
    public int MentorId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? PhoneNumber { get; set; }
    public string LicenseType { get; set; } = string.Empty;
    public string? CityName { get; set; }
    public string? VehicleType { get; set; }
    public decimal? PricePerSession { get; set; }
    public bool IsActive { get; set; }
    public string ApplicationStatus { get; set; } = string.Empty;
    public double AverageRating { get; set; }
    public int TotalRatings { get; set; }
    public int TotalSessions { get; set; }
    public int CompletedSessions { get; set; }
    public DateTime? CreatedAt { get; set; }
}

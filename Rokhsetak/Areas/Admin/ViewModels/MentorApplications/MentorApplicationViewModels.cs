using System.ComponentModel.DataAnnotations;

namespace Rokhsetak.Areas.Admin.ViewModels.MentorApplications;

public class MentorApplicationListItem
{
    public int ApplicationId { get; set; }
    public int MentorId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? PhoneNumber { get; set; }
    public string LicenseType { get; set; } = string.Empty;
    public string? CityName { get; set; }
    public DateTime? SubmittedAt { get; set; }
    public bool HasCertificationFile { get; set; }
}

public class MentorApplicationListViewModel
{
    public List<MentorApplicationListItem> Items { get; set; } = new();
}

public class MentorApplicationDetailViewModel
{
    public int ApplicationId { get; set; }
    public int MentorId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? PhoneNumber { get; set; }
    public string? NationalId { get; set; }
    public DateOnly? DateOfBirth { get; set; }
    public string? Gender { get; set; }
    public string? CityName { get; set; }
    public string? ProvinceName { get; set; }
    public string LicenseType { get; set; } = string.Empty;
    public string? VehicleType { get; set; }
    public decimal? PricePerSession { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime? SubmittedAt { get; set; }
    public DateTime? CertificationUploadedAt { get; set; }
    public bool HasCertificationFile { get; set; }
    public string? CertificationFileName { get; set; }
}

public class RejectApplicationViewModel
{
    public int ApplicationId { get; set; }

    [Required(ErrorMessage = "A rejection reason is required.")]
    [MinLength(5, ErrorMessage = "Please provide a clearer reason (5+ characters).")]
    [MaxLength(500)]
    [Display(Name = "Rejection reason")]
    public string Reason { get; set; } = string.Empty;
}

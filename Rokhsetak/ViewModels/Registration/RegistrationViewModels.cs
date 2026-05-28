using System.ComponentModel.DataAnnotations;
using Rokhsetak.Utils.Validation;
namespace Rokhsetak.ViewModels.Registration;

// Step 1: Trainee enters National ID to look up gov data
public class NationalIdLookupViewModel
{
    [Required(ErrorMessage = "National ID is required.")]
    [StringLength(10, MinimumLength = 10, ErrorMessage = "National ID must be exactly 10 digits.")]
    [RegularExpression(@"^\d{10}$", ErrorMessage = "National ID must contain only digits.")]
    [Display(Name = "National ID")]
    public string NationalId { get; set; } = null!;

    public bool IsTrainee { get; set; } = true; // toggle for mentor lookup

    
    [MustBeTrue(ErrorMessage = "You must accept the data retrieval consent.")]
    public bool AcceptedDataRetrievalConsent { get; set; }
}

// Step 2: Trainee fills in editable fields; gov data is read-only and pre-filled
public class TraineeRegistrationViewModel
{
    // ─── LOCKED (pre-filled from GovCitizen) ───────────────────────────────
    [Display(Name = "National ID")]
    public string NationalId { get; set; } = null!;

    [Display(Name = "First Name")]
    public string FirstName { get; set; } = null!;

    [Display(Name = "Last Name")]
    public string LastName { get; set; } = null!;

    [Display(Name = "Date of Birth")]
    public DateOnly DateOfBirth { get; set; }

    [Display(Name = "Gender")]
    public string Gender { get; set; } = null!;

    [Display(Name = "Province")]
    public int ProvinceId { get; set; } = 0!;

    [Display(Name = "City")]
    public int CityId { get; set; } = 0!;

    [Display(Name = "Address")]
    public string AddressLine1 { get; set; } = null!;

    public string? AddressLine2 { get; set; }
    public string? PostalCode { get; set; }

    // ─── EDITABLE ──────────────────────────────────────────────────────────
    [Required(ErrorMessage = "Email is required.")]
    [EmailAddress(ErrorMessage = "Please enter a valid email.")]
    [Display(Name = "Email Address")]
    public string Email { get; set; } = null!;

    [Phone(ErrorMessage = "Please enter a valid phone number.")]
    [Display(Name = "Phone Number")]
    public string? PhoneNumber { get; set; }

    [Required(ErrorMessage = "Password is required.")]
    [DataType(DataType.Password)]
    [StringLength(100, MinimumLength = 8, ErrorMessage = "Password must be at least 8 characters.")]
    [Display(Name = "Password")]
    public string Password { get; set; } = null!;

    [Required(ErrorMessage = "Please confirm your password.")]
    [DataType(DataType.Password)]
    [Compare(nameof(Password), ErrorMessage = "Passwords do not match.")]
    [Display(Name = "Confirm Password")]
    public string ConfirmPassword { get; set; } = null!;

    [Required(ErrorMessage = "Please select a license type.")]
    [Display(Name = "License Type")]
    public int LicenseTypeId { get; set; }

    // ─── CONSENT ───────────────────────────────────────────────────────────
    //[Required(ErrorMessage = "You must accept the Terms & Conditions to register.")]
    //[Range(typeof(bool), "true", "true", ErrorMessage = "You must accept the Terms & Conditions.")]
    //[Display(Name = "I accept the Terms & Conditions and Privacy Policy")]
    [MustBeTrue(ErrorMessage = "you must accept the terms and conditions")]
    public bool AcceptedTerms { get; set; }

    // ─── UI only: populated by controller before rendering ─────────────────
    public List<LicenseTypeOption> AvailableLicenseTypes { get; set; } = new();
    public List<CityOption> Cities { get; set; } = new();
    public List<ProvinceOption> Provinces { get; set; } = new();
}

// Step 2 (Mentor) – separate ViewModel
public class MentorRegistrationViewModel
{
    // ─── LOCKED ────────────────────────────────────────────────────────────
    [Display(Name = "National ID")]
    public string NationalId { get; set; } = null!;

    [Display(Name = "First Name")]
    public string FirstName { get; set; } = null!;

    [Display(Name = "Last Name")]
    public string LastName { get; set; } = null!;

    [Display(Name = "Date of Birth")]
    public DateOnly DateOfBirth { get; set; }

    [Display(Name = "Gender")]
    public string Gender { get; set; } = null!;

    [Display(Name = "Province")]
    public int ProvinceId { get; set; }

    [Display(Name = "City")]
    public int CityId { get; set; }

    [Display(Name = "Address")]
    public string AddressLine1 { get; set; } = null!;

    public string? AddressLine2 { get; set; }
    public string? PostalCode { get; set; }

    // ─── EDITABLE ──────────────────────────────────────────────────────────
    [Required(ErrorMessage = "Email is required.")]
    [EmailAddress(ErrorMessage = "Please enter a valid email.")]
    [Display(Name = "Email Address")]
    public string Email { get; set; } = null!;

    [Phone(ErrorMessage = "Please enter a valid phone number.")]
    [Display(Name = "Phone Number")]
    public string? PhoneNumber { get; set; }

    [Required(ErrorMessage = "Password is required.")]
    [DataType(DataType.Password)]
    [StringLength(100, MinimumLength = 8, ErrorMessage = "Password must be at least 8 characters.")]
    [Display(Name = "Password")]
    public string Password { get; set; } = null!;

    [Required(ErrorMessage = "Please confirm your password.")]
    [DataType(DataType.Password)]
    [Compare(nameof(Password), ErrorMessage = "Passwords do not match.")]
    [Display(Name = "Confirm Password")]
    public string ConfirmPassword { get; set; } = null!;

    [Required(ErrorMessage = "Please select the license type you teach.")]
    [Display(Name = "License Type You Teach")]
    public int LicenseTypeId { get; set; }

    [Required(ErrorMessage = "Please select your training center.")]
    [Display(Name = "Your Officail Training Center")]
    public int TrainingCenterId { get; set; }

    [Display(Name = "Vehicle Type")]
    [StringLength(100)]
    public string? VehicleType { get; set; }

    [Display(Name = "Price Per Session (JOD)")]
    [Range(0, 9999.99, ErrorMessage = "Invalid price.")]
    public decimal? PricePerSession { get; set; }

    [Required(ErrorMessage = "Certification document is required.")]
    [Display(Name = "Certification Document (PDF/Image)")]
    public IFormFile CertificationFile { get; set; } = null!;

    // ─── CONSENT ───────────────────────────────────────────────────────────
    [MustBeTrue(ErrorMessage = "you must accept the terms and conditions")]
    public bool AcceptedTerms { get; set; }

    // ─── UI ────────────────────────────────────────────────────────────────
    public List<LicenseTypeOption> AvailableLicenseTypes { get; set; } = new();
    public List<TrainingCenterOption> AvailableTrainingCenters { get; set; } = new();
    public List<CityOption> Cities { get; set; } = new();
    public List<ProvinceOption> Provinces { get; set; } = new();
}

// Lightweight option for dropdowns
public record LicenseTypeOption(int Id, string Name, string? Description);
public record TrainingCenterOption(int Id, string Name);

public record ProvinceOption(
    int ProvinceId,
    string DisplayName
);

public record CityOption(
    int? CityId,
    int? ProvinceId,
    string? DisplayName
);
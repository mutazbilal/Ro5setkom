using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ro5setkom.ViewModels.Profile
{ 
    public class EditProfileViewModel
    {
        // ─── REQUIRED IDENTITY FIELDS ───────────────────────────────

        [Required(ErrorMessage = "Email is required.")]
        [EmailAddress(ErrorMessage = "Please enter a valid email address.")]
        [Display(Name = "Email Address")]
        public string Email { get; set; } = null!;

        [Required(ErrorMessage = "Phone number is required.")]
        [Phone(ErrorMessage = "Please enter a valid phone number.")]
        [MaxLength(13, ErrorMessage = "Please enter a valid phone number.")]
        [Display(Name = "Phone Number")]
        public string PhoneNumber { get; set; } = null!;

        // ─── ADDRESS INFO ────────────────────────────────────────────

        [Required(ErrorMessage = "Province is required.")]
        [StringLength(100, ErrorMessage = "Province cannot exceed 100 characters.")]
        [Display(Name = "Province")]
        public string Province { get; set; } = null!;

        [Required(ErrorMessage = "City is required.")]
        [StringLength(100, ErrorMessage = "City cannot exceed 100 characters.")]
        [Display(Name = "City")]
        public string City { get; set; } = null!;

        [Required(ErrorMessage = "Address line 1 is required.")]
        [StringLength(200, ErrorMessage = "Address cannot exceed 200 characters.")]
        [Display(Name = "Address Line 1")]
        public string AddressLine1 { get; set; } = null!;

        [StringLength(200, ErrorMessage = "Address line 2 cannot exceed 200 characters.")]
        [Display(Name = "Address Line 2")]
        public string? AddressLine2 { get; set; }

        [StringLength(20, ErrorMessage = "Postal code cannot exceed 20 characters.")]
        [Display(Name = "Postal Code")]
        public string? PostalCode { get; set; }

        // for display only, not editable
        [ReadOnly(true)]
        public string FirstName { get; set; }
        [ReadOnly(true)]
        public string LastName { get; set; }
        [ReadOnly(true)]
        public DateOnly DateOfBirth { get; set; }
        [ReadOnly(true)]
        public string Gender { get; set; }
        [ReadOnly(true)]
        public string NationalId { get; set; }
    }
}

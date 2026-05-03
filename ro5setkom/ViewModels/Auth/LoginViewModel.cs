using System.ComponentModel.DataAnnotations;

namespace ro5setkom.ViewModels.Auth;

public class LoginViewModel
{
    [Required(ErrorMessage = "National ID is required.")]
    [StringLength(10, MinimumLength = 10, ErrorMessage = "National ID must be exactly 10 digits.")]
    [RegularExpression(@"^\d{10}$", ErrorMessage = "National ID must contain only digits.")]
    [Display(Name = "National ID")]
    public string NationalId { get; set; } = null!;

    [Required(ErrorMessage = "Password is required.")]
    [DataType(DataType.Password)]
    [Display(Name = "Password")]
    public string Password { get; set; } = null!;

    [Display(Name = "Remember me")]
    public bool RememberMe { get; set; } = false;

    public string Language { get; set; } = "en";
}

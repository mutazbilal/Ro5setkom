using Rokhsetak.ViewModels.Registration;
using System.ComponentModel.DataAnnotations;

namespace Rokhsetak.ViewModels.Profile
{
    public class ChangeLicenseViewModel
    {
        [Required]
        public int NewLicenseTypeId { get; set; }

        [Required]
        public bool ConfirmChange { get; set; }
        //UI
        public List<LicenseTypeOption> AvailableLicenseTypes { get; set; } = new();
    }
}

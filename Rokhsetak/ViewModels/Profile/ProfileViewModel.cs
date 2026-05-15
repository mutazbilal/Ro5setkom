using System.ComponentModel;

namespace Rokhsetak.ViewModels.Profile
{
    public class ProfileViewModel
    {
        // Core.Users (editable)
        public string? Email { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Province { get; set; }
        public string? City { get; set; }
        public string? AddressLine1 { get; set; }
        public string? AddressLine2 { get; set; }
        public string? PostalCode { get; set; }
        
        // for language preference
        public string? LanguagePreference { get; set; }

        // GovCitizens (read-only)
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

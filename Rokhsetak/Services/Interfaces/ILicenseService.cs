using Rokhsetak.ViewModels.Registration;

namespace Rokhsetak.Services.Interfaces
{
    public interface ILicenseService
    {
        /// <summary>
        /// Returns all active license types for populating dropdowns.
        /// </summary>
        Task<List<LicenseTypeOption>> GetLicenseTypesAsync();
    }
}

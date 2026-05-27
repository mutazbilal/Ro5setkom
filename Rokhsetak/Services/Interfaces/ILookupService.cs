using Rokhsetak.ViewModels.Registration;

namespace Rokhsetak.Services.Interfaces
{
    public interface ILookupService
    {
        /// <summary>
        /// Returns all active license types for populating dropdowns.
        /// </summary>
        Task<List<LicenseTypeOption>> GetLicenseTypesAsync(string culture);
        Task<List<TrainingCenterOption>> GetTrainingCentersAsync(string culture);
        Task<List<ProvinceOption>> GetProvincesAsync(string culture);
        Task<List<CityOption>> GetCitiesAsync(string culture);

    }
}

using Rokhsetak.Services.Common;
using Rokhsetak.ViewModels.Profile;

namespace Rokhsetak.Services.Interfaces
{
    public interface IProfileService
    {
        Task<ServiceResult<ProfileViewModel>> GetProfileAsync(int userId);
        Task<ServiceResult> UpdateProfileAsync(int userId, EditProfileViewModel model);
        Task<ServiceResult> ChangeLicenseAsync(int userId, int newLicenseTypeId);
        Task<ServiceResult> ChangeLanguageAsync(int userId, string language);
    }
}

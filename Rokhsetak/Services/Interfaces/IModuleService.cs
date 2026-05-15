using Rokhsetak.Areas.Trainee.ViewModels.Modules;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces
{
    public interface IModuleService
    {
        Task<ServiceResult<ModuleListViewModel>> GetModulesAsync(int traineeId, int traineeLicenseId, string culture);
        Task<ServiceResult<ModuleDetailViewModel>> GetModuleDetailAsync(int traineeId, int traineeLicenseId, int moduleId, string culture);
        Task<ServiceResult> StartModuleAsync(int traineeId, int traineeLicenseId, int moduleId);
        Task<ServiceResult> CompleteModuleAsync(int traineeId, int traineeLicenseId, int moduleId); 
    }
}

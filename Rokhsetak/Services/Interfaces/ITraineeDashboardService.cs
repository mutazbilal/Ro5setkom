using Rokhsetak.Areas.Trainee.ViewModels.Dashboard;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces
{
    public interface ITraineeDashboardService
    {
        Task<ServiceResult<TraineeDashboardViewModel>> GetDashboardAsync(int traineeId, string culture);
    }
}

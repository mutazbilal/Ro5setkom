using Rokhsetak.Areas.Admin.ViewModels.Dashboard;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces;

public interface IAnalyticsService
{
    Task<ServiceResult<AnalyticsDashboardViewModel>> GetDashboardAsync(AnalyticsFilter filter);
}

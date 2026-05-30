using Rokhsetak.Areas.Mentor.ViewModels.Dashboard;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces
{
    public interface IMentorDashboardService
    {
        Task<ServiceResult<MentorDashboardViewModel>> GetDashboardAsync(int mentorId, string culture);
    }
}

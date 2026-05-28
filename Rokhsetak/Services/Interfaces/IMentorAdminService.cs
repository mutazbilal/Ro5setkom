using Rokhsetak.Areas.Admin.ViewModels.MentorApplications;
using Rokhsetak.Areas.Admin.ViewModels.Mentors;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces;

public interface IMentorAdminService
{
    // Listing / details
    Task<ServiceResult<MentorListViewModel>> GetMentorsAsync(MentorListFilter filter, string culture);
    Task<ServiceResult<MentorDetailViewModel>> GetMentorDetailsAsync(int mentorId, string culture);

    // Applications
    Task<ServiceResult<MentorApplicationListViewModel>> GetPendingApplicationsAsync(string culture);
    Task<ServiceResult<MentorApplicationDetailViewModel>> GetApplicationDetailsAsync(int applicationId, string culture);
    Task<ServiceResult> ApproveApplicationAsync(int adminUserId, int applicationId);
    Task<ServiceResult> RejectApplicationAsync(int adminUserId, int applicationId, string reason);

    // Secure file resolution for certification download
    Task<ServiceResult<(string PhysicalPath, string FileName)>> GetCertificationFileAsync(int applicationId);
}

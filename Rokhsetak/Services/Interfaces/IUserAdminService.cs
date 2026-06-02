using Rokhsetak.Areas.Admin.ViewModels.Users;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces;

public interface IUserAdminService
{
    Task<ServiceResult<UserListViewModel>> GetUsersAsync(UserListFilter filter, string culture);
    Task<ServiceResult<UserDetailViewModel>> GetUserDetailsAsync(int userId, string culture);
    Task<ServiceResult> DeactivateUserAsync(int adminUserId, int userId);
    Task<ServiceResult> ReactivateUserAsync(int adminUserId, int userId);
}

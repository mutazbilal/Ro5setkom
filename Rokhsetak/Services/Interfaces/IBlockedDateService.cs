using Rokhsetak.Areas.Admin.ViewModels.BlockedDates;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces;

public interface IBlockedDateService
{
    Task<ServiceResult<BlockedDateListViewModel>> GetBlockedDatesAsync(string culture);
    Task<ServiceResult> AddBlockedDateAsync(int adminUserId, CreateBlockedDateViewModel model);
    Task<ServiceResult> RemoveBlockedDateAsync(int adminUserId, int blockedDateId);
}

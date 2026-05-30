using Rokhsetak.Areas.Admin.ViewModels.Bookings;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces;

public interface IBookingAdminService
{
    Task<ServiceResult<AdminBookingListViewModel>> GetBookingsAsync(BookingFilter filter, string culture);
}

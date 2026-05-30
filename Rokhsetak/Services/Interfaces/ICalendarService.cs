using Rokhsetak.Areas.Trainee.ViewModels.Calendar;
using Rokhsetak.Services.Common;
namespace Rokhsetak.Services.Interfaces;

public interface ICalendarService
{
    Task<ServiceResult<List<CalendarEventViewModel>>> GetCalendarEventsAsync(int traineeId, string culture);
}
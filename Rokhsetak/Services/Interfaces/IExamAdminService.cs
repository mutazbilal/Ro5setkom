using Rokhsetak.Areas.Admin.ViewModels.Exams;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces;

public interface IExamAdminService
{
    Task<ServiceResult<AdminExamAppointmentListViewModel>> GetExamAppointmentsAsync(ExamFilter filter);
}

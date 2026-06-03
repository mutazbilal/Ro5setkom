using Rokhsetak.Areas.Trainee.ViewModels.Exam;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces;

public interface IExamAppointmentService
{
    Task<ServiceResult<ExamBookingViewModel>> GetAvailableExamsAsync(int traineeId, string examType, string culture);
    Task<ServiceResult> BookExamAsync(int traineeId, BookExamViewModel model, string culture);
    Task<ServiceResult<ExamAppointmentListViewModel>> GetMyExamAppointmentsAsync(int traineeId, string culture);
    Task<ServiceResult> CancelExamAppointmentAsync(int traineeId, int appointmentId, string culture);
}
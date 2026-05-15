using Rokhsetak.Areas.Trainee.ViewModels.Exam;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces;

public interface IExamAppointmentService
{
    Task<ServiceResult<ExamBookingViewModel>> GetAvailableExamsAsync(int traineeId, string examType);
    Task<ServiceResult> BookExamAsync(int traineeId, BookExamViewModel model);
    Task<ServiceResult<ExamAppointmentListViewModel>> GetMyExamAppointmentsAsync(int traineeId);
    Task<ServiceResult> CancelExamAppointmentAsync(int traineeId, int appointmentId);
}
using Rokhsetak.Areas.Mentor.ViewModels.Appointments;
using Rokhsetak.Areas.Mentor.ViewModels.Trainees;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces
{
    public interface IAppointmentService
    {
        Task<ServiceResult<AppointmentListViewModel>> GetAllAppointmentsAsync(int mentorId);
        Task<ServiceResult> ConfirmBookingAsync(int mentorId, int bookingId);
        Task<ServiceResult> MarkAsDoneAsync(int mentorId, int bookingId);
        Task<ServiceResult> RescheduleAsync(int mentorId, RescheduleViewModel model);
        Task<ServiceResult> GiveFeedbackAsync(int mentorId, FeedbackViewModel model);
        Task<ServiceResult<TraineeSummaryListViewModel>> GetTraineeSummaryAsync(int mentorId, string? search, string? statusFilter);
        Task<ServiceResult<TraineeDetailViewModel>> GetTraineeDetailAsync(int mentorId, int traineeId);
    }
}

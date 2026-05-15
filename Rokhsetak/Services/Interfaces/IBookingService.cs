using Rokhsetak.Areas.Trainee.ViewModels.Booking;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces;

public interface IBookingService
{
    Task<ServiceResult<MentorBrowseListViewModel>> BrowseMentorsAsync(int traineeId, MentorBrowseFilterViewModel filter);
    Task<ServiceResult<MentorBookingViewModel>> GetMentorBookingPageAsync(int traineeId, int mentorId);
    Task<ServiceResult> BookSessionAsync(int traineeId, BookSessionViewModel model);
    Task<ServiceResult> CancelSessionAsync(int traineeId, int bookingId);
    Task<ServiceResult<RescheduleTraineeViewModel>> GetReschedulePageAsync(int traineeId, int bookingId);
    Task<ServiceResult> RescheduleSessionAsync(int traineeId, RescheduleTraineeViewModel model);
    Task<ServiceResult<TraineeBookingListViewModel>> GetMyBookingsAsync(int traineeId);
}
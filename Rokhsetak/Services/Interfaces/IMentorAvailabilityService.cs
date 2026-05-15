using Rokhsetak.Areas.Mentor.ViewModels.Availability;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces
{
    public interface IMentorAvailabilityService
    {
        Task<ServiceResult> AddSlotAsync(int mentorId, MentorAvailabilityViewModel model);
        Task<ServiceResult> EditSlotAsync(int mentorId, int slotId, MentorAvailabilityViewModel model);
        Task<ServiceResult> DeactivateSlotAsync(int mentorId, int slotId);
        Task<List<MentorAvailabilityViewModel>> GetSlotsAsync(int mentorId);
    }
}

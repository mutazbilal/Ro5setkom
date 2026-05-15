using Rokhsetak.Services.Common;
using Rokhsetak.ViewModels.Registration;

namespace Rokhsetak.Services.Interfaces
{
    public interface IRegistrationService
    {
        /// <summary>
        /// Looks up a citizen in GovCitizens by national ID and runs all
        /// pre-registration eligibility checks (shared by trainee & mentor flows).
        /// </summary>
        Task<ServiceResult<GovCitizenDto>> LookupNationalIdAsync(string nationalId, bool isTrainee);

        /// <summary>
        /// Creates User + Trainee + TraineeLicense + UserConsent in a single transaction.
        /// </summary>
        Task<ServiceResult> RegisterTraineeAsync(TraineeRegistrationViewModel model, string ipAddress);

        /// <summary>
        /// Creates User + MentorApplication (pending) + Mentor in a single transaction.
        /// Handles certification file persistence.
        /// </summary>
        Task<ServiceResult> RegisterMentorAsync(MentorRegistrationViewModel model, string ipAddress);
    }
}

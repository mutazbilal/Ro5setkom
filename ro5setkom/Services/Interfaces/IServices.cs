using ro5setkom.Services.Common;
using ro5setkom.ViewModels.Auth;
using ro5setkom.ViewModels.Mentor;
using ro5setkom.ViewModels.Profile;
using ro5setkom.ViewModels.Registration;
using ro5setkom.Areas.Trainee.ViewModels.Dashboard;
using ro5setkom.Areas.Trainee.ViewModels.Quiz;
using ro5setkom.Areas.Trainee.ViewModels.Modules;

namespace ro5setkom.Services.Interfaces;

// ─────────────────────────────────────────────────────────────────────────────
// IAuthService
// ─────────────────────────────────────────────────────────────────────────────
public interface IAuthService
{
    /// <summary>
    /// Validates credentials, enforces lockout, returns a LoginResultDto on success.
    /// </summary>
    Task<ServiceResult<LoginResultDto>> LoginAsync(LoginViewModel model, string ipAddress);

    /// <summary>
    /// Clears any server-side session state for the user (cookie is handled by controller).
    /// </summary>
    Task LogoutAsync(int userId);
}

// ─────────────────────────────────────────────────────────────────────────────
// IRegistrationService
// ─────────────────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// IPasswordResetService
// ─────────────────────────────────────────────────────────────────────────────
public interface IPasswordResetService
{
    /// <summary>
    /// Generates a one-time token (1-hour expiry), persists it, triggers email.
    /// Always returns success to avoid email-enumeration attacks.
    /// </summary>
    Task<ServiceResult> RequestResetAsync(ForgotPasswordViewModel model);

    /// <summary>
    /// Validates token (exists, not used, not expired) and updates password hash.
    /// Marks token as used on success.
    /// </summary>
    Task<ServiceResult> ResetPasswordAsync(ResetPasswordViewModel model);
}

// ─────────────────────────────────────────────────────────────────────────────
// IEmailService
// ─────────────────────────────────────────────────────────────────────────────
public interface IEmailService
{
    Task SendPasswordResetEmailAsync(string toEmail, string fullName, string resetLink);
    Task SendMentorApplicationStatusEmailAsync(string toEmail, string fullName, bool approved, string? reason);
}

public interface IProfileService
{
    Task<ServiceResult<ProfileViewModel>> GetProfileAsync(int userId);
    Task<ServiceResult> UpdateProfileAsync(int userId, EditProfileViewModel model);
    Task<ServiceResult> ChangeLicenseAsync(int userId, int newLicenseTypeId);
    Task<ServiceResult> ChangeLanguageAsync(int userId, string language);
}

public interface IMentorService
{
    Task<ServiceResult> AddSlotAsync(int mentorId, MentorAvailabilityViewModel model);
    Task<ServiceResult> EditSlotAsync(int mentorId, int slotId, MentorAvailabilityViewModel model);
    Task<ServiceResult> DeactivateSlotAsync(int mentorId, int slotId);
    Task<List<MentorAvailabilityViewModel>> GetSlotsAsync(int mentorId);
}

public interface INotificationService
{
    Task CreateAsync(int userId, string title, string message, string type);
}

public interface ILicenseService
{
    /// <summary>
    /// Returns all active license types for populating dropdowns.
    /// </summary>
    Task<List<LicenseTypeOption>> GetLicenseTypesAsync();
}

public interface ITraineeDashboardService
{
    Task<ServiceResult<TraineeDashboardViewModel>> GetDashboardAsync(int traineeId);
}

public interface IModuleService
{
    Task<ServiceResult<ModuleListViewModel>> GetModulesAsync(int traineeId, int traineeLicenseId, bool isEnglish);
    Task<ServiceResult<ModuleDetailViewModel>> GetModuleDetailAsync(int traineeId, int traineeLicenseId, int moduleId, bool isEnglish);
    Task<ServiceResult> StartModuleAsync(int traineeId, int traineeLicenseId, int moduleId);
    Task<ServiceResult> CompleteModuleAsync(int traineeId, int traineeLicenseId, int moduleId);
}
public interface IQuizService
{
    Task<ServiceResult<QuizViewModel>> GetModuleQuizAsync(int traineeId, int traineeLicenseId, int moduleId);
    Task<ServiceResult<QuizResultViewModel>> SubmitModuleQuizAsync(int traineeId, int traineeLicenseId, SubmitQuizViewModel model);
    Task<ServiceResult<QuizViewModel>> GetMockExamAsync(int traineeId, int traineeLicenseId);
    Task<ServiceResult<QuizResultViewModel>> SubmitMockExamAsync(int traineeId, int traineeLicenseId, SubmitQuizViewModel model);
}


using Rokhsetak.Services.Common;
using Rokhsetak.ViewModels.Auth;

namespace Rokhsetak.Services.Interfaces
{
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
}

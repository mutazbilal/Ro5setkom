using Rokhsetak.Services.Common;
using Rokhsetak.ViewModels.Auth;

namespace Rokhsetak.Services.Interfaces
{
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
}

using System.Collections.Concurrent;
using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.ViewModels.Auth;
using BCrypt.Net;

namespace Rokhsetak.Services.Implementations;

/// <summary>
/// Handles authentication:
///   - Credential validation (National ID + bcrypt-hashed password)
///   - In-memory failed-attempt tracking with lockout (5 attempts → 15-min lockout)
///   - Role-based result so the controller can redirect correctly
///   - Mentor pending-approval gate
/// </summary>
public class AuthService : IAuthService
{
    // ── Role name constants (match Roles lookup table) ──────────────────────
    private const string RoleTrainee = "trainee";
    private const string RoleMentor  = "mentor";
    private const string RoleAdmin   = "admin";

    private const int MaxFailedAttempts = 5;
    private static readonly TimeSpan LockoutDuration = TimeSpan.FromMinutes(15);

    // ── In-memory lockout tracker (key = nationalId) ─────────────────────────
    // For production: move this to IDistributedCache or a dedicated DB table.
    private static readonly ConcurrentDictionary<string, FailedAttemptRecord> _failedAttempts = new();

    private readonly Ro5setkomDbContext _db;
    private readonly ILogger<AuthService> _logger;

    public AuthService(Ro5setkomDbContext db, ILogger<AuthService> logger)
    {
        _db = db;
        _logger = logger;
    }

    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<LoginResultDto>> LoginAsync(LoginViewModel model, string ipAddress) 
    {
        // 1. Check lockout before hitting the DB
        if (IsLockedOut(model.NationalId))
            return ServiceResult<LoginResultDto>.Failure(
                "Your account has been temporarily locked due to too many failed attempts. " +
                "Please try again in 15 minutes.");

        // 2. Load user with role (single query, no sensitive nav-props loaded)
        var user = await _db.Users
            .AsNoTracking()
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.NationalId == model.NationalId);

        // 3. Generic failure for unknown user OR wrong password (prevents enumeration)
        if (user == null || !BCrypt.Net.BCrypt.Verify(model.Password, user.PasswordHash))
        {
            RecordFailedAttempt(model.NationalId);
            _logger.LogWarning("Failed login attempt for National ID {NId} from IP {IP}",
                model.NationalId, ipAddress);
            return ServiceResult<LoginResultDto>.Failure(
                "Invalid National ID or password. Please try again.");
        }

        // 4. Account active check
        if (user.IsActive != true)
            return ServiceResult<LoginResultDto>.Failure(
                "Your account has been deactivated. Please contact support.");

        // 5. Mentor-specific gate: must be approved before login is allowed
        if (user.Role.RoleName == RoleMentor)
        {
            var mentorStatus = await _db.Mentors
                .AsNoTracking()
                .Include(m => m.Application)
                .Where(m => m.MentorId == user.UserId)
                .Select(m => m.Application.Status)
                .FirstOrDefaultAsync();

            if (mentorStatus != "approved")
                return ServiceResult<LoginResultDto>.Failure(
                    "Your mentor application is still under review. " +
                    "You will be notified once it has been approved.");
        }

        // 6. Success – clear lockout counter
        _failedAttempts.TryRemove(model.NationalId, out _);

        return ServiceResult<LoginResultDto>.Success(new LoginResultDto
        {
            UserId     = user.UserId,
            NationalId = user.NationalId,
            FullName   = $"{user.FirstName} {user.LastName}",
            RoleName   = user.Role.RoleName,
            RoleId     = user.RoleId,
            Language   = user.LanguagePreference
        });
    }

    // ─────────────────────────────────────────────────────────────────────────
    public Task LogoutAsync(int userId)
    {
        // Stateless cookie auth needs no server-side cleanup beyond the cookie sign-out.
        // If you add refresh tokens or server sessions, revoke them here.
        _logger.LogInformation("User {UserId} logged out.", userId);
        return Task.CompletedTask;
    }

    // ── Helpers ──────────────────────────────────────────────────────────────
    private static bool IsLockedOut(string nationalId)
    {
        if (!_failedAttempts.TryGetValue(nationalId, out var record)) return false;
        if (record.FailedCount < MaxFailedAttempts)                   return false;
        if (DateTime.UtcNow - record.LastFailedAt < LockoutDuration)  return true;

        // Lockout window expired – reset
        _failedAttempts.TryRemove(nationalId, out _);
        return false;
    }

    private static void RecordFailedAttempt(string nationalId)
    {
        _failedAttempts.AddOrUpdate(
            nationalId,
            _ => new FailedAttemptRecord { FailedCount = 1, LastFailedAt = DateTime.UtcNow },
            (_, old) => new FailedAttemptRecord
            {
                FailedCount  = old.FailedCount + 1,
                LastFailedAt = DateTime.UtcNow
            });
    }

    private class FailedAttemptRecord
    {
        public int FailedCount { get; set; }
        public DateTime LastFailedAt { get; set; }
    }
}

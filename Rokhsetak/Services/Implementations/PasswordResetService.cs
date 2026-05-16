using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.ViewModels.Auth;
using BCrypt.Net;

namespace Rokhsetak.Services.Implementations;

/// <summary>
/// Manages the full password-reset lifecycle:
///
///   RequestResetAsync  – looks up user by email, generates a cryptographically
///                        secure token (256-bit), stores it with a 1-hour expiry,
///                        then triggers the email. Always returns success to
///                        prevent email-enumeration.
///
///   ResetPasswordAsync – validates the token (exists, unused, not expired),
///                        hashes and saves the new password, marks the token used.
/// </summary>
public class PasswordResetService : IPasswordResetService
{
    private static readonly TimeSpan TokenValidity = TimeSpan.FromHours(1);

    private readonly RokhsetakDbContext _db;
    private readonly IEmailService _emailService;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly ILogger<PasswordResetService> _logger;

    public PasswordResetService(
        RokhsetakDbContext db,
        IEmailService emailService,
        IHttpContextAccessor httpContextAccessor,
        ILogger<PasswordResetService> logger)
    {
        _db                  = db;
        _emailService        = emailService;
        _httpContextAccessor = httpContextAccessor;
        _logger              = logger;
    }

    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> RequestResetAsync(ForgotPasswordViewModel model)
    {
        // Always return success to the caller to prevent email enumeration.
        // Actual email is only sent when the address matches a real account.
        var user = await _db.Users
            .FirstOrDefaultAsync(u => u.Email == model.Email && u.IsActive == true);

        if (user == null)
        {
            _logger.LogWarning(
                "Password reset requested for unknown email: {Email}", model.Email);
            return ServiceResult.Success(); // Deliberate: no enumeration signal
        }

        // Invalidate any existing unused tokens for this user
        var existingTokens = await _db.SecurityPasswordResetTokens
            .Where(t => t.UserId == user.UserId && t.Used != true)
            .ToListAsync();

        foreach (var t in existingTokens)
            t.Used = true;

        // Generate new cryptographically secure token
        var rawToken = Convert.ToBase64String(
            System.Security.Cryptography.RandomNumberGenerator.GetBytes(32));

        _db.SecurityPasswordResetTokens.Add(new SecurityPasswordResetToken
        {
            UserId    = user.UserId,
            Token     = rawToken,
            ExpiresAt = DateTime.UtcNow.Add(TokenValidity),
            Used      = false
        });

        await _db.SaveChangesAsync();

        // Build reset link
        var request    = _httpContextAccessor.HttpContext!.Request;
        var resetLink  = $"{request.Scheme}://{request.Host}/Auth/ResetPassword?token={Uri.EscapeDataString(rawToken)}";

        await _emailService.SendPasswordResetEmailAsync(
            user.Email,
            $"{user.FirstName} {user.LastName}",
            resetLink);

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> ResetPasswordAsync(ResetPasswordViewModel model)
    {
        // Load token record eagerly with the owning user
        var tokenRecord = await _db.SecurityPasswordResetTokens
            .Include(t => t.User)
            .FirstOrDefaultAsync(t => t.Token == model.Token);

        if (tokenRecord == null || tokenRecord.Used == true)
            return ServiceResult.Failure(
                "This reset link is invalid or has already been used.");

        if (DateTime.UtcNow > tokenRecord.ExpiresAt)
            return ServiceResult.Failure(
                "This reset link has expired. Please request a new one.");

        // Update password
        tokenRecord.User.PasswordHash = BCrypt.Net.BCrypt.HashPassword(model.NewPassword);
        tokenRecord.User.UpdatedAt    = DateTime.UtcNow;

        // Consume token (one-time use)
        tokenRecord.Used = true;

        await _db.SaveChangesAsync();

        _logger.LogInformation(
            "Password reset completed for UserId={UserId}", tokenRecord.UserId);

        return ServiceResult.Success();
    }
}

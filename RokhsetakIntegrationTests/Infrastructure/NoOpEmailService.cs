using Rokhsetak.Services.Interfaces;

namespace RokhsetakIntegrationTests.Infrastructure;

internal sealed class NoOpEmailService : IEmailService
{
    public Task SendPasswordResetEmailAsync(string toEmail, string fullName, string resetLink) => Task.CompletedTask;
    public Task SendMentorApplicationStatusEmailAsync(string toEmail, string fullName, bool approved, string? reason) => Task.CompletedTask;
}
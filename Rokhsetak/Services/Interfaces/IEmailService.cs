namespace Rokhsetak.Services.Interfaces
{
    public interface IEmailService
    {
        Task SendPasswordResetEmailAsync(string toEmail, string fullName, string resetLink);
        Task SendMentorApplicationStatusEmailAsync(string toEmail, string fullName, bool approved, string? reason);
    }
}

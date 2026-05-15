using MailKit;
using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using Rokhsetak.Services.Interfaces;
using System.Net;


namespace Rokhsetak.Services.Implementations;

/// <summary>
/// Sends transactional emails via SMTP.
/// Configuration is read from appsettings.json (EmailSettings section).
/// In production, swap the SmtpClient for a provider SDK (SendGrid, Mailgun, etc.)
/// </summary>
public class EmailService : IEmailService
{
    private readonly EmailSettings _settings;
    private readonly ILogger<EmailService> _logger;

    public EmailService(IConfiguration configuration, ILogger<EmailService> logger)
    {
        _settings = configuration.GetSection("EmailSettings").Get<EmailSettings>()
                    ?? throw new InvalidOperationException("EmailSettings not configured.");
        _logger = logger;
    }

    public async Task SendPasswordResetEmailAsync(
        string toEmail, string fullName, string resetLink)
    {
        var subject = "Reset Your Password – ro5setak";
        var body    = $"""
            <div dir="ltr" style="font-family:Arial,sans-serif;max-width:600px">
              <h2>Password Reset Request</h2>
              <p>Hello {WebUtility.HtmlEncode(fullName)},</p>
              <p>We received a request to reset your password. Click the button below to proceed.
                 This link expires in <strong>1 hour</strong>.</p>
              <p style="margin:24px 0">
                <a href="{resetLink}"
                   style="background:#1a56db;color:#fff;padding:12px 24px;
                          border-radius:6px;text-decoration:none;font-weight:bold">
                  Reset Password
                </a>
              </p>
              <p>If you did not request this, please ignore this email.
                 Your password will remain unchanged.</p>
              <hr/>
              <small style="color:#6b7280">ro5setak – Driving License Training Platform</small>
            </div>
            """;

        await SendAsync(toEmail, subject, body);
    }

    public async Task SendMentorApplicationStatusEmailAsync(
        string toEmail, string fullName, bool approved, string? reason)
    {
        var subject = approved
            ? "Your Mentor Application Has Been Approved – ro5setak"
            : "Your Mentor Application Status Update – ro5setak";

        var body = approved
            ? $"""
               <div dir="ltr" style="font-family:Arial,sans-serif;max-width:600px">
                 <h2>Application Approved ✅</h2>
                 <p>Congratulations {WebUtility.HtmlEncode(fullName)}!</p>
                 <p>Your mentor application has been approved.
                    You can now log in and start accepting trainees.</p>
               </div>
               """
            : $"""
               <div dir="ltr" style="font-family:Arial,sans-serif;max-width:600px">
                 <h2>Application Update</h2>
                 <p>Hello {WebUtility.HtmlEncode(fullName)},</p>
                 <p>Unfortunately your mentor application was not approved at this time.</p>
                 {(string.IsNullOrWhiteSpace(reason) ? "" :
                   $"<p><strong>Reason:</strong> {WebUtility.HtmlEncode(reason)}</p>")}
                 <p>Please contact support if you believe this is an error.</p>
               </div>
               """;

        await SendAsync(toEmail, subject, body);
    }

    // ── Private helpers ───────────────────────────────────────────────────────
    private async Task SendAsync(string toEmail, string subject, string htmlBody)
    {
        var message = new MimeMessage();

        message.From.Add(new MailboxAddress(_settings.FromName, _settings.FromAddress));
        message.To.Add(MailboxAddress.Parse(toEmail));
        message.Subject = subject;

        message.Body = new BodyBuilder
        {
            HtmlBody = htmlBody
        }.ToMessageBody();

        using var client = new SmtpClient();

        await client.ConnectAsync(
            _settings.Host,
            465,
            SecureSocketOptions.SslOnConnect // 👈 THIS is SMTP_SSL equivalent
        );

        await client.AuthenticateAsync(
            _settings.Username,
            _settings.Password
        );

        await client.SendAsync(message);

        await client.DisconnectAsync(true);
    }
}

/// <summary>Bound from appsettings.json → "EmailSettings"</summary>
public class EmailSettings
{
    public string Host        { get; set; } = null!;
    public int    Port        { get; set; } = 587;
    public string Username    { get; set; } = null!;
    public string Password    { get; set; } = null!;
    public bool   EnableSsl   { get; set; } = true;
    public string FromAddress { get; set; } = null!;
    public string FromName    { get; set; } = null!;
}

using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class User
{
    public int UserId { get; set; }

    public int RoleId { get; set; }

    public string NationalId { get; set; } = null!;

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public DateOnly? DateOfBirth { get; set; }

    public string? Gender { get; set; }

    public string Email { get; set; } = null!;

    public string? PhoneNumber { get; set; }

    public string Province { get; set; } = null!;

    public string City { get; set; } = null!;

    public string AddressLine1 { get; set; } = null!;

    public string? AddressLine2 { get; set; }

    public string? PostalCode { get; set; }

    public string PasswordHash { get; set; } = null!;

    public string? ProfilePicture { get; set; }

    public string? LanguagePreference { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Admin? Admin { get; set; }

    public virtual ICollection<AichatSession> AichatSessions { get; set; } = new List<AichatSession>();

    public virtual ICollection<AuditLog> AuditLogs { get; set; } = new List<AuditLog>();

    public virtual ICollection<ConversationAttachment> ConversationAttachments { get; set; } = new List<ConversationAttachment>();

    public virtual Mentor? Mentor { get; set; }

    public virtual ICollection<Message> Messages { get; set; } = new List<Message>();

    public virtual GovCitizen National { get; set; } = null!;

    public virtual NotificationPreference? NotificationPreference { get; set; }

    public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();

    public virtual Role Role { get; set; } = null!;

    public virtual ICollection<SecurityPasswordResetToken> SecurityPasswordResetTokens { get; set; } = new List<SecurityPasswordResetToken>();

    public virtual Trainee? Trainee { get; set; }

    public virtual ICollection<UserConsent> UserConsents { get; set; } = new List<UserConsent>();
}

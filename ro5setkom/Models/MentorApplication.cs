using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class MentorApplication
{
    public int ApplicationId { get; set; }

    public int MentorId { get; set; }

    public int? ReviewedBy { get; set; }

    public string? Status { get; set; }

    public DateTime? SubmittedAt { get; set; }

    public DateTime? ReviewedAt { get; set; }

    public string? RejectionReason { get; set; }

    public string? CertificationFilePath { get; set; }

    public bool? IsCertificationVerified { get; set; }

    public DateTime? CertificationUploadedAt { get; set; }

    public virtual Mentor Mentor { get; set; } = null!;

    public virtual ICollection<Mentor> Mentors { get; set; } = new List<Mentor>();

    public virtual Admin? ReviewedByNavigation { get; set; }
}

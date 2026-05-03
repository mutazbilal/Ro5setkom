using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class CompletionCertificate
{
    public int CertificateId { get; set; }

    public int TraineeId { get; set; }

    public int MentorId { get; set; }

    public int TraineeLicenseId { get; set; }

    public DateTime IssuedAt { get; set; }

    public string? CertificatePath { get; set; }

    public virtual Mentor Mentor { get; set; } = null!;

    public virtual Trainee Trainee { get; set; } = null!;

    public virtual TraineeLicense TraineeLicense { get; set; } = null!;
}

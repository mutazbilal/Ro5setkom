using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class TraineeLicense
{
    public int TraineeLicenseId { get; set; }

    public int TraineeId { get; set; }

    public int LicenseTypeId { get; set; }

    public int? MentorId { get; set; }

    public string Stage { get; set; } = null!;

    public int ProgressPercentage { get; set; }

    public bool IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Booking? Booking { get; set; }

    public virtual CompletionCertificate? CompletionCertificate { get; set; }

    public virtual ExamAppointment? ExamAppointment { get; set; }

    public virtual LicenseType LicenseType { get; set; } = null!;

    public virtual Mentor? Mentor { get; set; }

    public virtual ICollection<QuizAttempt> QuizAttempts { get; set; } = new List<QuizAttempt>();

    public virtual Trainee Trainee { get; set; } = null!;

    public virtual ICollection<TraineeModuleProgress> TraineeModuleProgresses { get; set; } = new List<TraineeModuleProgress>();
}

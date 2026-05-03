using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class Trainee
{
    public int TraineeId { get; set; }

    public int? LicenseTypeId { get; set; }

    public int? TrainingCenterId { get; set; }

    public DateOnly? EnrolledAt { get; set; }

    public virtual ICollection<Booking> Bookings { get; set; } = new List<Booking>();

    public virtual ICollection<CompletionCertificate> CompletionCertificates { get; set; } = new List<CompletionCertificate>();

    public virtual ICollection<Conversation> Conversations { get; set; } = new List<Conversation>();

    public virtual ICollection<ExamAppointment> ExamAppointments { get; set; } = new List<ExamAppointment>();

    public virtual LicenseType? LicenseType { get; set; }

    public virtual ICollection<ModuleRecommendation> ModuleRecommendations { get; set; } = new List<ModuleRecommendation>();

    public virtual ICollection<QuizAttempt> QuizAttempts { get; set; } = new List<QuizAttempt>();

    public virtual ICollection<Rating> Ratings { get; set; } = new List<Rating>();

    public virtual ICollection<SessionFeedback> SessionFeedbacks { get; set; } = new List<SessionFeedback>();

    public virtual ICollection<TraineeLicense> TraineeLicenses { get; set; } = new List<TraineeLicense>();

    public virtual ICollection<TraineeModuleProgress> TraineeModuleProgresses { get; set; } = new List<TraineeModuleProgress>();

    public virtual User TraineeNavigation { get; set; } = null!;

    public virtual TrainingCenter? TrainingCenter { get; set; }
}

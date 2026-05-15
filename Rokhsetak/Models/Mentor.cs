using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class Mentor
{
    public int MentorId { get; set; }

    public int? TrainingCenterId { get; set; }

    public int? LicenseTypeId { get; set; }

    public int? ApplicationId { get; set; }

    public decimal? PricePerSession { get; set; }

    public string? VehicleType { get; set; }

    public string? City { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual MentorApplication? Application { get; set; }

    public virtual ICollection<Booking> Bookings { get; set; } = new List<Booking>();

    public virtual ICollection<CompletionCertificate> CompletionCertificates { get; set; } = new List<CompletionCertificate>();

    public virtual ICollection<Conversation> Conversations { get; set; } = new List<Conversation>();

    public virtual LicenseType? LicenseType { get; set; }

    public virtual ICollection<MentorApplication> MentorApplications { get; set; } = new List<MentorApplication>();

    public virtual ICollection<MentorAvailability> MentorAvailabilities { get; set; } = new List<MentorAvailability>();

    public virtual User MentorNavigation { get; set; } = null!;

    public virtual ICollection<ModuleRecommendation> ModuleRecommendations { get; set; } = new List<ModuleRecommendation>();

    public virtual ICollection<Rating> Ratings { get; set; } = new List<Rating>();

    public virtual ICollection<SessionFeedback> SessionFeedbacks { get; set; } = new List<SessionFeedback>();

    public virtual ICollection<TraineeLicense> TraineeLicenses { get; set; } = new List<TraineeLicense>();

    public virtual TrainingCenter? TrainingCenter { get; set; }
}

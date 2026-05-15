using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class LicenseType
{
    public int LicenseTypeId { get; set; }

    public string LicenseName { get; set; } = null!;

    public string DisplayNameEn { get; set; } = null!;

    public string DisplayNameAr { get; set; } = null!;

    public string? DescriptionEn { get; set; }

    public string? DescriptionAr { get; set; }

    public virtual ICollection<Booking> Bookings { get; set; } = new List<Booking>();

    public virtual ICollection<GovLicenseRecord> GovLicenseRecords { get; set; } = new List<GovLicenseRecord>();

    public virtual ICollection<GovOfficialExam> GovOfficialExams { get; set; } = new List<GovOfficialExam>();

    public virtual ICollection<LearningModule> LearningModules { get; set; } = new List<LearningModule>();

    public virtual ICollection<Mentor> Mentors { get; set; } = new List<Mentor>();

    public virtual ICollection<Quiz> Quizzes { get; set; } = new List<Quiz>();

    public virtual ICollection<TraineeLicense> TraineeLicenses { get; set; } = new List<TraineeLicense>();

    public virtual ICollection<Trainee> Trainees { get; set; } = new List<Trainee>();
}

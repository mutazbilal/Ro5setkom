using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class GovOfficialExam
{
    public int OfficialExamId { get; set; }

    public int CenterId { get; set; }

    public int LicenseTypeId { get; set; }

    public string ExamType { get; set; } = null!;

    public DateOnly ExamDate { get; set; }

    public TimeOnly ExamTime { get; set; }

    public int TotalSlots { get; set; }

    public int BookedSlots { get; set; }

    public string Status { get; set; } = null!;

    public int? CreatedBy { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual GovExamCenter Center { get; set; } = null!;

    public virtual Admin? CreatedByNavigation { get; set; }

    public virtual ICollection<ExamAppointment> ExamAppointments { get; set; } = new List<ExamAppointment>();

    public virtual ICollection<GovExamResult> GovExamResults { get; set; } = new List<GovExamResult>();

    public virtual LicenseType LicenseType { get; set; } = null!;
}

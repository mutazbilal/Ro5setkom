using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class ExamAppointment
{
    public int ExamAppointmentId { get; set; }

    public int TraineeId { get; set; }

    public int OfficialExamId { get; set; }

    public string? Status { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public int TraineeLicenseId { get; set; }

    public virtual GovOfficialExam OfficialExam { get; set; } = null!;

    public virtual Trainee Trainee { get; set; } = null!;

    public virtual TraineeLicense TraineeLicense { get; set; } = null!;
}

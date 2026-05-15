using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class GovExamResult
{
    public int ResultId { get; set; }

    public int OfficialExamId { get; set; }

    public string NationalId { get; set; } = null!;

    public string Result { get; set; } = null!;

    public int? Score { get; set; }

    public string? Notes { get; set; }

    public int? RecordedBy { get; set; }

    public DateTime? RecordedAt { get; set; }

    public virtual GovCitizen National { get; set; } = null!;

    public virtual GovOfficialExam OfficialExam { get; set; } = null!;

    public virtual Admin? RecordedByNavigation { get; set; }
}

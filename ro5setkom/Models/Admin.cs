using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class Admin
{
    public int AdminId { get; set; }

    public string? Department { get; set; }

    public string? BadgeNumber { get; set; }

    public virtual User AdminNavigation { get; set; } = null!;

    public virtual ICollection<BlockedDate> BlockedDates { get; set; } = new List<BlockedDate>();

    public virtual ICollection<GovExamResult> GovExamResults { get; set; } = new List<GovExamResult>();

    public virtual ICollection<GovOfficialExam> GovOfficialExams { get; set; } = new List<GovOfficialExam>();

    public virtual ICollection<MentorApplication> MentorApplications { get; set; } = new List<MentorApplication>();
}

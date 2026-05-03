using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class TraineeModuleProgress
{
    public int ProgressId { get; set; }

    public int TraineeId { get; set; }

    public int ModuleId { get; set; }

    public int TraineeLicenseId { get; set; }

    public string Status { get; set; } = null!;

    public DateTime? StartedAt { get; set; }

    public DateTime? CompletedAt { get; set; }

    public virtual LearningModule Module { get; set; } = null!;

    public virtual Trainee Trainee { get; set; } = null!;

    public virtual TraineeLicense TraineeLicense { get; set; } = null!;
}

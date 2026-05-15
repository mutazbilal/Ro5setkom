using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class QuizAttempt
{
    public int AttemptId { get; set; }

    public int QuizId { get; set; }

    public int TraineeId { get; set; }

    public int TraineeLicenseId { get; set; }

    public int? Score { get; set; }

    public bool? Passed { get; set; }

    public DateTime? AttemptDate { get; set; }

    public virtual Quiz Quiz { get; set; } = null!;

    public virtual Trainee Trainee { get; set; } = null!;

    public virtual TraineeLicense TraineeLicense { get; set; } = null!;
}

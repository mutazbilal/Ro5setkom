using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class ModuleRecommendation
{
    public int RecommendationId { get; set; }

    public int MentorId { get; set; }

    public int TraineeId { get; set; }

    public int ModuleId { get; set; }

    public string? Note { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Mentor Mentor { get; set; } = null!;

    public virtual LearningModule Module { get; set; } = null!;

    public virtual Trainee Trainee { get; set; } = null!;
}

using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class QuizQuestion
{
    public int QuestionId { get; set; }

    public int QuizId { get; set; }

    public string QuestionText { get; set; } = null!;

    public virtual ICollection<QuestionOption> QuestionOptions { get; set; } = new List<QuestionOption>();

    public virtual Quiz Quiz { get; set; } = null!;
}

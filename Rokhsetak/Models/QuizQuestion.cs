using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class QuizQuestion
{
    public int QuestionId { get; set; }

    public int QuizId { get; set; }

    public virtual ICollection<QuestionOption> QuestionOptions { get; set; } = new List<QuestionOption>();

    public virtual ICollection<QuestionTranslation> QuestionTranslations { get; set; } = new List<QuestionTranslation>();

    public virtual Quiz Quiz { get; set; } = null!;
}

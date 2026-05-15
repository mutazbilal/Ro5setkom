using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class QuestionOption
{
    public int OptionId { get; set; }

    public int QuestionId { get; set; }

    public bool IsCorrect { get; set; }

    public virtual ICollection<OptionTranslation> OptionTranslations { get; set; } = new List<OptionTranslation>();

    public virtual QuizQuestion Question { get; set; } = null!;
}

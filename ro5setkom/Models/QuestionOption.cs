using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class QuestionOption
{
    public int OptionId { get; set; }

    public int QuestionId { get; set; }

    public string OptionText { get; set; } = null!;

    public bool IsCorrect { get; set; }

    public virtual QuizQuestion Question { get; set; } = null!;
}

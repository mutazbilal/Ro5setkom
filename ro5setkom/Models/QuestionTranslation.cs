using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class QuestionTranslation
{
    public int QuestionTranslationId { get; set; }

    public int QuestionId { get; set; }

    public string LanguageCode { get; set; } = null!;

    public string QuestionText { get; set; } = null!;

    public virtual QuizQuestion Question { get; set; } = null!;
}

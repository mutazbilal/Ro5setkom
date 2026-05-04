using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class QuizTranslation
{
    public int QuizTranslationId { get; set; }

    public int QuizId { get; set; }

    public string LanguageCode { get; set; } = null!;

    public string Title { get; set; } = null!;

    public virtual Quiz Quiz { get; set; } = null!;
}

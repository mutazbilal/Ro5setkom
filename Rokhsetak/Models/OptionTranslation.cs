using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class OptionTranslation
{
    public int OptionTranslationId { get; set; }

    public int OptionId { get; set; }

    public string LanguageCode { get; set; } = null!;

    public string OptionText { get; set; } = null!;

    public virtual QuestionOption Option { get; set; } = null!;
}

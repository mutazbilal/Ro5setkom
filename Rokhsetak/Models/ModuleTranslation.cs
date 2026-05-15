using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class ModuleTranslation
{
    public int ModuleTranslationId { get; set; }

    public int ModuleId { get; set; }

    public string LanguageCode { get; set; } = null!;

    public string Title { get; set; } = null!;

    public string? Description { get; set; }

    public virtual LearningModule Module { get; set; } = null!;
}

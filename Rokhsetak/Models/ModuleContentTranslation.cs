using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class ModuleContentTranslation
{
    public int ContentTranslationId { get; set; }

    public int ContentId { get; set; }

    public string LanguageCode { get; set; } = null!;

    public string? TextContent { get; set; }

    public string? VideoUrl { get; set; }

    public virtual ModuleContent Content { get; set; } = null!;
}

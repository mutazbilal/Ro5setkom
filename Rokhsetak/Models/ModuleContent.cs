using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class ModuleContent
{
    public int ContentId { get; set; }

    public int ModuleId { get; set; }

    public string? ContentType { get; set; }

    public virtual LearningModule Module { get; set; } = null!;

    public virtual ICollection<ModuleContentTranslation> ModuleContentTranslations { get; set; } = new List<ModuleContentTranslation>();
}

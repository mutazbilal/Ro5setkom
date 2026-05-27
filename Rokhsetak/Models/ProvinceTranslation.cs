using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class ProvinceTranslation
{
    public int ProvinceTranslationId { get; set; }

    public int ProvinceId { get; set; }

    public string LanguageCode { get; set; } = null!;

    public string DisplayName { get; set; } = null!;

    public virtual Province Province { get; set; } = null!;
}

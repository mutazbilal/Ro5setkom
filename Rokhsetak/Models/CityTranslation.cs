using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class CityTranslation
{
    public int CityTranslationId { get; set; }

    public int CityId { get; set; }

    public string LanguageCode { get; set; } = null!;

    public string DisplayName { get; set; } = null!;

    public virtual City City { get; set; } = null!;
}

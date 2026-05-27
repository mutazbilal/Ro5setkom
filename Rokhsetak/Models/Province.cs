using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class Province
{
    public int ProvinceId { get; set; }

    public string ProvinceKey { get; set; } = null!;

    public virtual ICollection<City> Cities { get; set; } = new List<City>();

    public virtual ICollection<GovCitizen> GovCitizens { get; set; } = new List<GovCitizen>();

    public virtual ICollection<GovExamCenter> GovExamCenters { get; set; } = new List<GovExamCenter>();

    public virtual ICollection<ProvinceTranslation> ProvinceTranslations { get; set; } = new List<ProvinceTranslation>();

    public virtual ICollection<TrainingCenter> TrainingCenters { get; set; } = new List<TrainingCenter>();

    public virtual ICollection<User> Users { get; set; } = new List<User>();
}

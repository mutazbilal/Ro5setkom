using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class City
{
    public int CityId { get; set; }

    public int ProvinceId { get; set; }

    public string CityKey { get; set; } = null!;

    public virtual ICollection<CityTranslation> CityTranslations { get; set; } = new List<CityTranslation>();

    public virtual ICollection<GovCitizen> GovCitizens { get; set; } = new List<GovCitizen>();

    public virtual ICollection<GovExamCenter> GovExamCenters { get; set; } = new List<GovExamCenter>();

    public virtual ICollection<Mentor> Mentors { get; set; } = new List<Mentor>();

    public virtual Province Province { get; set; } = null!;

    public virtual ICollection<TrainingCenter> TrainingCenters { get; set; } = new List<TrainingCenter>();

    public virtual ICollection<User> Users { get; set; } = new List<User>();
}

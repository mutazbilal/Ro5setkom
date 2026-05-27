using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class GovExamCenter
{
    public int CenterId { get; set; }

    public string Name { get; set; } = null!;

    public int ProvinceId { get; set; }

    public int CityId { get; set; }

    public string AddressLine1 { get; set; } = null!;

    public string? AddressLine2 { get; set; }

    public string? PostalCode { get; set; }

    public string? PhoneNumber { get; set; }

    public bool? IsActive { get; set; }

    public virtual City City { get; set; } = null!;

    public virtual ICollection<GovOfficialExam> GovOfficialExams { get; set; } = new List<GovOfficialExam>();

    public virtual Province Province { get; set; } = null!;
}

using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class GovExamCenter
{
    public int CenterId { get; set; }

    public string Name { get; set; } = null!;

    public string Province { get; set; } = null!;

    public string City { get; set; } = null!;

    public string AddressLine1 { get; set; } = null!;

    public string? AddressLine2 { get; set; }

    public string? PostalCode { get; set; }

    public string? PhoneNumber { get; set; }

    public bool? IsActive { get; set; }

    public virtual ICollection<GovOfficialExam> GovOfficialExams { get; set; } = new List<GovOfficialExam>();
}

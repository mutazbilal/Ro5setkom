using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class GovCitizen
{
    public string NationalId { get; set; } = null!;

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public DateOnly DateOfBirth { get; set; }

    public string Gender { get; set; } = null!;

    public string Province { get; set; } = null!;

    public string City { get; set; } = null!;

    public string AddressLine1 { get; set; } = null!;

    public string? AddressLine2 { get; set; }

    public string? PostalCode { get; set; }

    public bool? IsEligible { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<GovExamResult> GovExamResults { get; set; } = new List<GovExamResult>();

    public virtual ICollection<GovLicenseRecord> GovLicenseRecords { get; set; } = new List<GovLicenseRecord>();

    public virtual User? User { get; set; }
}

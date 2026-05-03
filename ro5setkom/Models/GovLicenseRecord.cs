using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class GovLicenseRecord
{
    public int RecordId { get; set; }

    public string NationalId { get; set; } = null!;

    public int LicenseTypeId { get; set; }

    public DateOnly? IssuedDate { get; set; }

    public DateOnly? ExpiryDate { get; set; }

    public string Status { get; set; } = null!;

    public virtual LicenseType LicenseType { get; set; } = null!;

    public virtual GovCitizen National { get; set; } = null!;
}

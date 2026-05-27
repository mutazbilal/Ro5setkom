using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class TrainingCenter
{
    public int CenterId { get; set; }

    public string DisplayNameEn { get; set; } = null!;

    public string DisplayNameAr { get; set; } = null!;

    public int ProvinceId { get; set; }

    public int CityId { get; set; }

    public string AddressLine1 { get; set; } = null!;

    public string? AddressLine2 { get; set; }

    public string? PostalCode { get; set; }

    public string? PhoneNumber { get; set; }

    public string? Email { get; set; }

    public string LicenseNumber { get; set; } = null!;

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual City City { get; set; } = null!;

    public virtual ICollection<Mentor> Mentors { get; set; } = new List<Mentor>();

    public virtual Province Province { get; set; } = null!;

    public virtual ICollection<Trainee> Trainees { get; set; } = new List<Trainee>();
}

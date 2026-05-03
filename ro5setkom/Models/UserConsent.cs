using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class UserConsent
{
    public int ConsentId { get; set; }

    public int UserId { get; set; }

    public string ConsentType { get; set; } = null!;

    public bool Consented { get; set; }

    public DateTime ConsentedAt { get; set; }

    public string? IpAddress { get; set; }

    public virtual User User { get; set; } = null!;
}

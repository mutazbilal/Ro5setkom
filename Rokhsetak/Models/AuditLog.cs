using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class AuditLog
{
    public int LogId { get; set; }

    public int UserId { get; set; }

    public string Action { get; set; } = null!;

    public string? TableName { get; set; }

    public string? RecordId { get; set; }

    public DateTime? PerformedAt { get; set; }

    public virtual User User { get; set; } = null!;
}

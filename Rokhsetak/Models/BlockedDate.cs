using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class BlockedDate
{
    public int BlockedDateId { get; set; }

    public DateOnly BlockedDate1 { get; set; }

    public string? Reason { get; set; }

    public int BlockedBy { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Admin BlockedByNavigation { get; set; } = null!;
}

using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class AichatSession
{
    public int SessionId { get; set; }

    public int UserId { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? EndedAt { get; set; }

    public virtual ICollection<AichatMessage> AichatMessages { get; set; } = new List<AichatMessage>();

    public virtual User User { get; set; } = null!;
}

using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class AichatMessage
{
    public int MessageId { get; set; }

    public int SessionId { get; set; }

    public string Role { get; set; } = null!;

    public string Content { get; set; } = null!;

    public DateTime? SentAt { get; set; }

    public virtual AichatSession Session { get; set; } = null!;
}

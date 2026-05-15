using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class NotificationPreference
{
    public int UserId { get; set; }

    public bool PrefersEmail { get; set; }

    public bool PrefersSms { get; set; }

    public bool PrefersApp { get; set; }

    public int ReminderHoursBefore { get; set; }

    public virtual User User { get; set; } = null!;
}

using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class MentorAvailability
{
    public int AvailabilityId { get; set; }

    public int MentorId { get; set; }

    public string DayOfWeek { get; set; } = null!;

    public TimeOnly StartTime { get; set; }

    public TimeOnly EndTime { get; set; }

    public bool? IsActive { get; set; }

    public virtual Mentor Mentor { get; set; } = null!;
}

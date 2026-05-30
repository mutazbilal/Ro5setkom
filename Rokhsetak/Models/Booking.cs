using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class Booking
{
    public int BookingId { get; set; }

    public int TraineeId { get; set; }

    public int MentorId { get; set; }

    public int LicenseTypeId { get; set; }

    public string? SessionType { get; set; }

    public DateOnly BookingDate { get; set; }

    public TimeOnly StartTime { get; set; }

    public TimeOnly EndTime { get; set; }

    public string? Status { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public int TraineeLicenseId { get; set; }

    public virtual LicenseType LicenseType { get; set; } = null!;

    public virtual Mentor Mentor { get; set; } = null!;

    public virtual Rating? Rating { get; set; }

    public virtual SessionFeedback? SessionFeedback { get; set; }

    public virtual Trainee Trainee { get; set; } = null!;

    public virtual TraineeLicense TraineeLicense { get; set; } = null!;
}

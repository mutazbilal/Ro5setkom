using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class SessionFeedback
{
    public int FeedbackId { get; set; }

    public int BookingId { get; set; }

    public int TraineeId { get; set; }

    public int MentorId { get; set; }

    public string? MentorNotes { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Booking Booking { get; set; } = null!;

    public virtual Mentor Mentor { get; set; } = null!;

    public virtual Trainee Trainee { get; set; } = null!;
}

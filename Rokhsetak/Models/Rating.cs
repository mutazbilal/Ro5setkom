using System;
using System.Collections.Generic;

namespace Rokhsetak.Models;

public partial class Rating
{
    public int RatingId { get; set; }

    public int TraineeId { get; set; }

    public int MentorId { get; set; }

    public int BookingId { get; set; }

    public decimal Score { get; set; }

    public string? ReviewText { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Booking Booking { get; set; } = null!;

    public virtual Mentor Mentor { get; set; } = null!;

    public virtual Trainee Trainee { get; set; } = null!;
}

using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class Conversation
{
    public int ConversationId { get; set; }

    public int TraineeId { get; set; }

    public int MentorId { get; set; }

    public int BookingId { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Booking Booking { get; set; } = null!;

    public virtual ICollection<ConversationAttachment> ConversationAttachments { get; set; } = new List<ConversationAttachment>();

    public virtual Mentor Mentor { get; set; } = null!;

    public virtual ICollection<Message> Messages { get; set; } = new List<Message>();

    public virtual Trainee Trainee { get; set; } = null!;
}

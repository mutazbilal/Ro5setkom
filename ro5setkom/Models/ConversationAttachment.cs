using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class ConversationAttachment
{
    public int AttachmentId { get; set; }

    public int ConversationId { get; set; }

    public int? MessageId { get; set; }

    public int UploadedBy { get; set; }

    public string FileName { get; set; } = null!;

    public string FilePath { get; set; } = null!;

    public string? FileType { get; set; }

    public DateTime? UploadedAt { get; set; }

    public virtual Conversation Conversation { get; set; } = null!;

    public virtual User UploadedByNavigation { get; set; } = null!;
}

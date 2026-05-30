namespace Rokhsetak.ViewModels.Messaging;

/// <summary>
/// Minimal message representation shared internally across both area view-model sets.
/// The area-specific classes embed or inherit from this.
/// </summary>
public sealed class MessageItemViewModel
{
    public int MessageId   { get; init; }
    public int SenderId    { get; init; }
    public string SenderName { get; init; } = string.Empty;
    public bool   IsMine   { get; init; }   // true when SenderId == currentUserId
    public string? Text    { get; init; }

    // File attachment (populated when ConversationAttachment exists for this message)
    public bool   IsFile   { get; init; }
    public string? FileUrl  { get; init; }
    public string? FileName { get; init; }
    public string? FileType { get; init; }  // "pdf" | "png" | "jpg" | "jpeg" | "webp"

    public bool?   IsRead   { get; init; }
    public DateTime SentAt { get; init; }
}

public sealed class SendMessageViewModel
{
    public string? Text { get; set; }
    // File is received via IFormFile; validated in controller / service
}
public sealed record ChatUploadResult(string Url, string OriginalFileName, string Extension);

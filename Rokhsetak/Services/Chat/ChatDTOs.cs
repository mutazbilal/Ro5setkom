namespace Rokhsetak.Services.Chat;

/// <summary>Provider-neutral summary row shown in a thread list.</summary>
public sealed class ChatThreadSummary
{
    public int ThreadId { get; init; }
    public string Title { get; init; } = string.Empty;
    public string AvatarText { get; init; } = "?";
    public string? LastMessage { get; init; }
    public DateTime? LastMessageAt { get; init; }
    public int UnreadCount { get; init; }
    public bool IsFile { get; init; }
}

/// <summary>Provider-neutral single message.</summary>
public sealed class ChatMessageDto
{
    public int MessageId { get; init; }
    public bool IsMine { get; init; }
    public string? Text { get; init; }
    public bool IsFile { get; init; }
    public string? FileUrl { get; init; }
    public string? FileName { get; init; }
    public string? FileType { get; init; }   // pdf | png | jpg | jpeg | webp
    public bool? IsRead { get; init; }
    public DateTime SentAt { get; init; }
    public string Role { get; init; } = "user"; // user | assistant (AI) — informational
}

/// <summary>Provider-neutral open thread.</summary>
public sealed class ChatThreadDetail
{
    public int ThreadId { get; init; }
    public string ProviderKey { get; init; } = string.Empty;
    public string Title { get; init; } = string.Empty;
    public string AvatarText { get; init; } = "?";
    public bool CanSendFiles { get; init; }
    public IReadOnlyList<ChatMessageDto> Messages { get; init; } = Array.Empty<ChatMessageDto>();
}

public sealed class ChatSendResult
{
    public bool Succeeded { get; init; }
    public string? Error { get; init; }
    public int ThreadId { get; init; }
    public static ChatSendResult Ok(int threadId) => new() { Succeeded = true, ThreadId = threadId };
    public static ChatSendResult Fail(string error) => new() { Succeeded = false, Error = error };
}

/// <summary>Metadata a UI needs to render a provider tab without knowing its internals.</summary>
public sealed class ChatProviderDescriptor
{
    public string Key { get; init; } = string.Empty;
    public string Label { get; init; } = string.Empty;
    public string Icon { get; init; } = string.Empty;     // font-awesome class
    public int SortOrder { get; init; }
    public bool SupportsThreadList { get; init; }
    public bool SupportsUnread { get; init; }
}

public sealed class ChatPanelViewModel
{
    public IReadOnlyList<ChatProviderDescriptor> Providers { get; init; } = Array.Empty<ChatProviderDescriptor>();
    public int InitialUnread { get; init; }
    public int CurrentUserId { get; init; }
}

public static class ChatProviderKeys
{
    public const string Human = "human";
    public const string Ai = "ai";
}
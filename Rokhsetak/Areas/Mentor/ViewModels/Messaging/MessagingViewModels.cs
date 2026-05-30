using Rokhsetak.ViewModels.Messaging;

namespace Rokhsetak.Areas.Mentor.ViewModels.Messaging;

// ── Conversation list ─────────────────────────────────────────────────────────

public sealed class ConversationListViewModel
{
    public IReadOnlyList<ConversationSummaryItem> Conversations { get; init; }
        = Array.Empty<ConversationSummaryItem>();

    public int TotalUnread => Conversations.Sum(c => c.UnreadCount);
}

public sealed class ConversationSummaryItem
{
    public int    ConversationId  { get; init; }
    public int    TraineeId       { get; init; }
    public string TraineeName     { get; init; } = string.Empty;
    public string? LastMessage    { get; init; }       // preview text (truncated)
    public DateTime? LastMessageAt { get; init; }
    public int    UnreadCount     { get; init; }
    public bool   IsFile          { get; init; }       // last message was a file?
}

// ── Conversation detail ───────────────────────────────────────────────────────

public sealed class ConversationDetailViewModel
{
    public int    ConversationId  { get; init; }
    public int    TraineeId       { get; init; }
    public string TraineeName     { get; init; } = string.Empty;
    public IReadOnlyList<MessageItemViewModel> Messages { get; init; }
        = Array.Empty<MessageItemViewModel>();
}

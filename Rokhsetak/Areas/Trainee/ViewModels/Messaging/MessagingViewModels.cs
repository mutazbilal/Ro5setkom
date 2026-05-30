using Rokhsetak.ViewModels.Messaging;

namespace Rokhsetak.Areas.Trainee.ViewModels.Messaging;

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
    public int    MentorId        { get; init; }
    public string MentorName      { get; init; } = string.Empty;
    public string? LastMessage    { get; init; }
    public DateTime? LastMessageAt { get; init; }
    public int    UnreadCount     { get; init; }
    public bool   IsFile          { get; init; }
}

// ── Conversation detail ───────────────────────────────────────────────────────

public sealed class ConversationDetailViewModel
{
    public int    ConversationId  { get; init; }
    public int    MentorId        { get; init; }
    public string MentorName      { get; init; } = string.Empty;
    public IReadOnlyList<MessageItemViewModel> Messages { get; init; }
        = Array.Empty<MessageItemViewModel>();
}

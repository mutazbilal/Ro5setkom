namespace Rokhsetak.Services.Chat;

/// <summary>
/// A chat backend (human messaging, AI, future support agents, …).
/// Adding a new provider = implement this + register it in DI. Nothing else changes.
/// </summary>
public interface IChatProvider
{
    string Key { get; }            // stable id used in URLs/DI lookup
    string DisplayName { get; }    // tab label
    string Icon { get; }           // font-awesome class for the tab
    int SortOrder { get; }         // tab order (lower = first/default)

    bool SupportsThreadList { get; } // false ⇒ single implicit thread (e.g. AI)
    bool SupportsUnread { get; }     // false ⇒ excluded from the global unread badge

    Task<IReadOnlyList<ChatThreadSummary>> GetThreadsAsync(int userId, CancellationToken ct = default);
    Task<ChatThreadDetail?> GetThreadAsync(int userId, int threadId, CancellationToken ct = default);
    Task<ChatSendResult> SendAsync(int userId, int threadId, string? text, IFormFile? file, CancellationToken ct = default);
    Task<int> GetUnreadCountAsync(int userId, CancellationToken ct = default);
    Task<int?> GetLatestMessageIdAsync(int userId, int threadId, CancellationToken ct = default);
}
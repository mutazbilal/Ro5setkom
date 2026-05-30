namespace Rokhsetak.Services.Chat;

/// <summary>
/// Optional capability for providers that let the user create and configure threads
/// (e.g. AI personality). Detected via a type-test; the base IChatProvider stays lean.
/// </summary>
public interface IThreadConfigurableProvider
{
    IReadOnlyList<ChatCreateOption> Options { get; }
    Task<ChatSendResult> CreateThreadAsync(int userId, ChatThreadConfig config, CancellationToken ct = default);
    Task<bool> UpdateThreadConfigAsync(int userId, int threadId, ChatThreadConfig config, CancellationToken ct = default);
}
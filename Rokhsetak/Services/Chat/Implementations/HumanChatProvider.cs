using Rokhsetak.Services.Interfaces;
using System.Globalization;

namespace Rokhsetak.Services.Chat.Implementations;

public sealed class HumanChatProvider : IChatProvider
{
    private readonly IConversationService _conv;
    public HumanChatProvider(IConversationService conv) => _conv = conv;

    public string Key => ChatProviderKeys.Human;
    public string culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
    public string DisplayName => culture == "en"? "Mentor Chats" :"محادثات المدربين";
    public string Icon => "fa-solid fa-comments";
    public int SortOrder => 0;
    public bool SupportsThreadList => true;
    public bool SupportsUnread => true;

    public Task<IReadOnlyList<ChatThreadSummary>> GetThreadsAsync(int userId, CancellationToken ct = default)
        => _conv.GetConversationsForUserAsync(userId);

    public Task<ChatThreadDetail?> GetThreadAsync(int userId, int threadId, CancellationToken ct = default)
        => _conv.GetConversationForUserAsync(userId, threadId);

    public async Task<ChatSendResult> SendAsync(int userId, int threadId, string? text, IFormFile? file, CancellationToken ct = default)
    {
        var r = await _conv.SendMessageForUserAsync(threadId, userId, text, file);
        return r.Succeeded ? ChatSendResult.Ok(threadId) : ChatSendResult.Fail(r.Error ?? "Failed to send.");
    }

    public Task<int> GetUnreadCountAsync(int userId, CancellationToken ct = default)
        => _conv.GetUnreadCountForUserAsync(userId);

    public Task<int?> GetLatestMessageIdAsync(int userId, int threadId, CancellationToken ct = default)
        => _conv.GetLatestMessageIdAsync(threadId, userId);
}
using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;

namespace Rokhsetak.Services.Chat.Implementations;

public sealed class AiChatProvider : IChatProvider
{
    private readonly RokhsetakDbContext _db;
    private readonly IAiResponder _responder;

    public AiChatProvider(RokhsetakDbContext db, IAiResponder responder)
    {
        _db = db;
        _responder = responder;
    }

    public string Key => ChatProviderKeys.Ai;
    public string DisplayName => "AI Assistant";
    public string Icon => "fa-solid fa-robot";
    public int SortOrder => 1;
    public bool SupportsThreadList => false;  // single rolling session
    public bool SupportsUnread => false;      // AI has no unread concept

    public async Task<IReadOnlyList<ChatThreadSummary>> GetThreadsAsync(int userId, CancellationToken ct = default)
    {
        var session = await EnsureActiveSessionAsync(userId, ct);
        var last = await _db.AichatMessages
            .Where(m => m.SessionId == session.SessionId)
            .OrderByDescending(m => m.SentAt)
            .Select(m => new { m.Content, m.SentAt })
            .FirstOrDefaultAsync(ct);

        return new[]
        {
            new ChatThreadSummary
            {
                ThreadId = session.SessionId,
                Title = "AI Assistant",
                AvatarText = "AI",
                LastMessage = Truncate(last?.Content, 60) ?? "Ask me anything about your driving journey.",
                LastMessageAt = last?.SentAt,
                UnreadCount = 0,
                IsFile = false
            }
        };
    }

    public async Task<ChatThreadDetail?> GetThreadAsync(int userId, int threadId, CancellationToken ct = default)
    {
        var session = await ResolveSessionAsync(userId, threadId, ct);
        if (session is null) return null;

        var messages = await _db.AichatMessages
            .Where(m => m.SessionId == session.SessionId)
            .OrderBy(m => m.SentAt)
            .Select(m => new ChatMessageDto
            {
                MessageId = m.MessageId,
                IsMine = m.Role == "user",
                Text = m.Content,
                IsFile = false,
                IsRead = true,
                SentAt = m.SentAt ?? DateTime.UtcNow,
                Role = m.Role
            })
            .ToListAsync(ct);

        return new ChatThreadDetail
        {
            ThreadId = session.SessionId,
            ProviderKey = Key,
            Title = "AI Assistant",
            AvatarText = "AI",
            CanSendFiles = false,
            Messages = messages
        };
    }

    public async Task<ChatSendResult> SendAsync(int userId, int threadId, string? text, IFormFile? file, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(text))
            return ChatSendResult.Fail("Message cannot be empty.");

        var session = await ResolveSessionAsync(userId, threadId, ct);
        if (session is null) return ChatSendResult.Fail("AI session not found.");

        _db.AichatMessages.Add(new AichatMessage
        {
            SessionId = session.SessionId,
            Role = "user",
            Content = text.Trim(),
            SentAt = DateTime.UtcNow
        });
        await _db.SaveChangesAsync(ct);

        var history = await _db.AichatMessages
            .Where(m => m.SessionId == session.SessionId)
            .OrderBy(m => m.SentAt)
            .Select(m => new ChatTurn(m.Role, m.Content))
            .ToListAsync(ct);

        var reply = await _responder.GenerateReplyAsync(history, ct);

        _db.AichatMessages.Add(new AichatMessage
        {
            SessionId = session.SessionId,
            Role = "assistant",
            Content = reply,
            SentAt = DateTime.UtcNow
        });
        await _db.SaveChangesAsync(ct);

        return ChatSendResult.Ok(session.SessionId);
    }

    public Task<int> GetUnreadCountAsync(int userId, CancellationToken ct = default) => Task.FromResult(0);

    public async Task<int?> GetLatestMessageIdAsync(int userId, int threadId, CancellationToken ct = default)
    {
        var session = await ResolveSessionAsync(userId, threadId, ct);
        if (session is null) return null;
        return await _db.AichatMessages
            .Where(m => m.SessionId == session.SessionId)
            .OrderByDescending(m => m.MessageId)
            .Select(m => (int?)m.MessageId)
            .FirstOrDefaultAsync(ct);
    }

    // ── helpers ──────────────────────────────────────────────────────────────
    private async Task<AichatSession?> ResolveSessionAsync(int userId, int threadId, CancellationToken ct)
    {
        if (threadId > 0)
            return await _db.AichatSessions.FirstOrDefaultAsync(s => s.SessionId == threadId && s.UserId == userId, ct);
        return await EnsureActiveSessionAsync(userId, ct);
    }

    private async Task<AichatSession> EnsureActiveSessionAsync(int userId, CancellationToken ct)
    {
        var existing = await _db.AichatSessions
            .Where(s => s.UserId == userId && s.EndedAt == null)
            .OrderByDescending(s => s.SessionId)
            .FirstOrDefaultAsync(ct);
        if (existing is not null) return existing;

        var session = new AichatSession { UserId = userId, CreatedAt = DateTime.UtcNow };
        _db.AichatSessions.Add(session);
        await _db.SaveChangesAsync(ct);
        return session;
    }

    private static string? Truncate(string? s, int max)
        => s is null ? null : s.Length <= max ? s : s[..max] + "…";
}
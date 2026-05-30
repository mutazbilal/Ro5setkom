using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;

namespace Rokhsetak.Services.Chat.Implementations;

public sealed class AiChatProvider : IChatProvider, IThreadConfigurableProvider
{
    private readonly RokhsetakDbContext _db;
    private readonly IAiResponder _responder;
    private readonly IAiContextAssembler _assembler;
    private readonly IAiPromptBuilder _promptBuilder;
    private readonly ILogger<AiChatProvider> _logger;

    public AiChatProvider(
        RokhsetakDbContext db,
        IAiResponder responder,
        IAiContextAssembler assembler,
        IAiPromptBuilder promptBuilder,
        ILogger<AiChatProvider> logger)
    {
        _db = db;
        _responder = responder;
        _assembler = assembler;
        _promptBuilder = promptBuilder;
        _logger = logger;
    }

    public string Key => ChatProviderKeys.Ai;
    public string DisplayName => "AI Assistant";
    public string Icon => "fa-solid fa-robot";
    public int SortOrder => 1;
    public bool SupportsThreadList => true;   // now multiple threads
    public bool SupportsUnread => false;

    public IReadOnlyList<ChatCreateOption> Options => AiPersonaCatalog.Options;

    public async Task<IReadOnlyList<ChatThreadSummary>> GetThreadsAsync(int userId, CancellationToken ct = default)
    {
        var rows = await _db.AichatSessions
            .Where(s => s.UserId == userId)
            .Select(s => new
            {
                s.SessionId,
                s.Title,
                s.CreatedAt,
                Last = s.AichatMessages.OrderByDescending(m => m.SentAt)
                        .Select(m => new { m.Content, m.SentAt }).FirstOrDefault()
            })
            .ToListAsync(ct);

        return rows
            .OrderByDescending(r => r.Last?.SentAt ?? r.CreatedAt)
            .Select(r => new ChatThreadSummary
            {
                ThreadId = r.SessionId,
                Title = string.IsNullOrWhiteSpace(r.Title) ? "New chat" : r.Title!,
                AvatarText = "AI",
                LastMessage = Truncate(r.Last?.Content, 60) ?? "No messages yet",
                LastMessageAt = r.Last?.SentAt ?? r.CreatedAt,
                UnreadCount = 0,
                IsFile = false
            })
            .ToList();
    }

    public async Task<ChatThreadDetail?> GetThreadAsync(int userId, int threadId, CancellationToken ct = default)
    {
        var session = await _db.AichatSessions
            .FirstOrDefaultAsync(s => s.SessionId == threadId && s.UserId == userId, ct);
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
            Title = string.IsNullOrWhiteSpace(session.Title) ? "New chat" : session.Title!,
            AvatarText = "AI",
            CanSendFiles = false,
            Messages = messages,
            Configurable = true,
            ConfigKey = session.PersonaKey ?? "tutor",
            ConfigOptions = AiPersonaCatalog.Options
        };
    }

    public Task<int> GetUnreadCountAsync(int userId, CancellationToken ct = default) => Task.FromResult(0);

    public async Task<int?> GetLatestMessageIdAsync(int userId, int threadId, CancellationToken ct = default)
    {
        bool owns = await _db.AichatSessions.AnyAsync(s => s.SessionId == threadId && s.UserId == userId, ct);
        if (!owns) return null;
        return await _db.AichatMessages
            .Where(m => m.SessionId == threadId)
            .OrderByDescending(m => m.MessageId)
            .Select(m => (int?)m.MessageId)
            .FirstOrDefaultAsync(ct);
    }

    // ── IThreadConfigurableProvider ───────────────────────────────────────────
    public async Task<ChatSendResult> CreateThreadAsync(int userId, ChatThreadConfig config, CancellationToken ct = default)
    {
        var key = string.IsNullOrWhiteSpace(config.OptionKey) ? "tutor" : config.OptionKey!;
        var session = new AichatSession
        {
            UserId = userId,
            CreatedAt = DateTime.UtcNow,
            Title = string.IsNullOrWhiteSpace(config.Title) ? "New chat" : config.Title!.Trim(),
            PersonaKey = key,
            SystemPrompt = key == "custom" ? AiPersonaCatalog.Wrap(config.CustomPrompt) : AiPersonaCatalog.Resolve(key)
        };
        _db.AichatSessions.Add(session);
        await _db.SaveChangesAsync(ct);
        return ChatSendResult.Ok(session.SessionId);
    }

    public async Task<bool> UpdateThreadConfigAsync(int userId, int threadId, ChatThreadConfig config, CancellationToken ct = default)
    {
        var session = await _db.AichatSessions
            .FirstOrDefaultAsync(s => s.SessionId == threadId && s.UserId == userId, ct);
        if (session is null) return false;

        var key = string.IsNullOrWhiteSpace(config.OptionKey) ? "tutor" : config.OptionKey!;
        session.PersonaKey = key;
        session.SystemPrompt = key == "custom" ? AiPersonaCatalog.Wrap(config.CustomPrompt) : AiPersonaCatalog.Resolve(key);
        await _db.SaveChangesAsync(ct);
        return true;
    }
    public async Task<ChatSendResult> SendAsync(
        int userId, int threadId, string? text, IFormFile? file, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(text)) return ChatSendResult.Fail("Message cannot be empty.");

        var session = await _db.AichatSessions
            .FirstOrDefaultAsync(s => s.SessionId == threadId && s.UserId == userId, ct);
        if (session is null) return ChatSendResult.Fail("Chat not found.");

        var userText = text.Trim();
        _db.AichatMessages.Add(new AichatMessage
        {
            SessionId = session.SessionId,
            Role = "user",
            Content = userText,
            SentAt = DateTime.UtcNow
        });

        if (string.IsNullOrWhiteSpace(session.Title) || session.Title == "New chat")
            session.Title = userText.Length <= 40 ? userText : userText[..40] + "…";

        await _db.SaveChangesAsync(ct);

        // Build fresh context on every message — always reflects current state
        // pageKey can be passed via a header or query param if available; null is fine
        var pageKey = /* HttpContext?.Request.Headers["X-Page-Key"].FirstOrDefault() */ null as string;
        var ctx = await _assembler.AssembleAsync(userId, session.PersonaKey ?? "tutor", pageKey, ct);
        var systemPrompt = _promptBuilder.Build(ctx);
        _logger.LogInformation("System Prompt Generated for message:" + systemPrompt);
        var history = await _db.AichatMessages
            .Where(m => m.SessionId == session.SessionId)
            .OrderBy(m => m.SentAt)
            .Select(m => new ChatTurn(m.Role, m.Content))
            .ToListAsync(ct);

        var reply = await _responder.GenerateReplyAsync(systemPrompt, history, ct);

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


    private static string? Truncate(string? s, int max)
        => s is null ? null : s.Length <= max ? s : s[..max] + "…";
}
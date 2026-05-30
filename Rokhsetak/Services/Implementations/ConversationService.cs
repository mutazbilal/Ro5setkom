using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Mentor.ViewModels.Messaging;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.ViewModels.Messaging;

namespace Rokhsetak.Services.Implementations;

public sealed class ConversationService : IConversationService
{
    private readonly RokhsetakDbContext _db;
    private readonly IBlobService _blob;                    // ← existing service, not the new one
    private readonly INotificationService _notifications;
    private readonly ILogger<ConversationService> _logger;

    public ConversationService(
        RokhsetakDbContext db,
        IBlobService blob,                                  // ← inject existing IBlobService
        INotificationService notifications,
        ILogger<ConversationService> logger)
    {
        _db = db;
        _blob = blob;
        _notifications = notifications;
        _logger = logger;
    }

    // ═════════════════════════════════════════════════════════════════════════
    // AUTO-CREATION
    // ═════════════════════════════════════════════════════════════════════════

    public async Task<ServiceResult<int>> EnsureConversationExistsAsync(
        int traineeId, int mentorId, int bookingId)
    {
        var existing = await _db.Conversations
            .FirstOrDefaultAsync(c => c.TraineeId == traineeId && c.MentorId == mentorId);

        if (existing is not null)
            return ServiceResult<int>.Success(existing.ConversationId);

        var conversation = new Conversation
        {
            TraineeId = traineeId,
            MentorId = mentorId,
            BookingId = bookingId,
            CreatedAt = DateTime.UtcNow
        };

        _db.Conversations.Add(conversation);
        await _db.SaveChangesAsync();

        _logger.LogInformation(
            "Conversation {Id} created for Trainee {T} ↔ Mentor {M} (Booking {B})",
            conversation.ConversationId, traineeId, mentorId, bookingId);

        return ServiceResult<int>.Success(conversation.ConversationId);
    }

    // ═════════════════════════════════════════════════════════════════════════
    // MENTOR SURFACE
    // ═════════════════════════════════════════════════════════════════════════

    public async Task<ServiceResult<ConversationListViewModel>> GetMentorConversationsAsync(int mentorId)
    {
        var rows = await _db.Conversations
            .Where(c => c.MentorId == mentorId)
            .Select(c => new
            {
                c.ConversationId,
                c.TraineeId,
                TraineeName = c.Trainee.TraineeNavigation.FirstName + " " + c.Trainee.TraineeNavigation.LastName,
                LastMsg = c.Messages
                    .OrderByDescending(m => m.SentAt)
                    .Select(m => new { m.MessageText, m.SentAt })
                    .FirstOrDefault(),
                UnreadCount = c.Messages
                    .Count(m => m.IsRead == false && m.SenderId != mentorId),
                LastMsgId = c.Messages
                    .OrderByDescending(m => m.SentAt)
                    .Select(m => (int?)m.MessageId)
                    .FirstOrDefault()
            })
            .ToListAsync();

        // Resolve "is last message a file?" in a second pass to avoid subquery-in-subquery issues
        var lastMsgIds = rows
            .Where(r => r.LastMsgId.HasValue)
            .Select(r => r.LastMsgId!.Value)
            .ToHashSet();

        var fileMessageIds = await _db.ConversationAttachments
            .Where(a => a.MessageId != null && lastMsgIds.Contains(a.MessageId.Value))
            .Select(a => a.MessageId!.Value)
            .ToHashSetAsync();

        var items = rows
            .OrderByDescending(r => r.LastMsg?.SentAt)
            .Select(r => new ConversationSummaryItem
            {
                ConversationId = r.ConversationId,
                TraineeId = r.TraineeId,
                TraineeName = r.TraineeName,
                LastMessage = r.LastMsgId.HasValue && fileMessageIds.Contains(r.LastMsgId.Value)
                                     ? "📎 Attachment"
                                     : Truncate(r.LastMsg?.MessageText, 60),
                LastMessageAt = r.LastMsg?.SentAt,
                UnreadCount = r.UnreadCount,
                IsFile = r.LastMsgId.HasValue && fileMessageIds.Contains(r.LastMsgId.Value)
            })
            .ToList();

        return ServiceResult<ConversationListViewModel>.Success(
            new ConversationListViewModel { Conversations = items });
    }

    public async Task<ServiceResult<ConversationDetailViewModel>> GetMentorConversationAsync(
        int conversationId, int mentorId)
    {
        var conv = await _db.Conversations
            .Where(c => c.ConversationId == conversationId && c.MentorId == mentorId)
            .Select(c => new
            {
                c.ConversationId,
                c.TraineeId,
                // ✅ FIX: same navigation path
                TraineeName = c.Trainee.TraineeNavigation.FirstName + " " + c.Trainee.TraineeNavigation.LastName
            })
            .FirstOrDefaultAsync();

        if (conv is null)
            return ServiceResult<ConversationDetailViewModel>.Failure("Conversation not found.");

        await MarkMessagesReadAsync(conversationId, mentorId);

        var messages = await BuildMessageListAsync(conversationId, mentorId);

        return ServiceResult<ConversationDetailViewModel>.Success(new ConversationDetailViewModel
        {
            ConversationId = conv.ConversationId,
            TraineeId = conv.TraineeId,
            TraineeName = conv.TraineeName,
            Messages = messages
        });
    }

    public async Task<ServiceResult> SendMessageAsMentorAsync(
        int conversationId, int mentorId, string? text, IFormFile? file)
    {
        bool owns = await _db.Conversations
            .AnyAsync(c => c.ConversationId == conversationId && c.MentorId == mentorId);
        if (!owns)
            return ServiceResult.Failure("Conversation not found.");

        return await SendInternalAsync(conversationId, mentorId, text, file);
    }

    // ═════════════════════════════════════════════════════════════════════════
    // TRAINEE SURFACE
    // ═════════════════════════════════════════════════════════════════════════

    public async Task<ServiceResult<Areas.Trainee.ViewModels.Messaging.ConversationListViewModel>>
        GetTraineeConversationsAsync(int traineeId)
    {
        var rows = await _db.Conversations
            .Where(c => c.TraineeId == traineeId)
            .Select(c => new
            {
                c.ConversationId,
                c.MentorId,
                // ✅ Mentor navigation was already correct — MentorNavigation is the User
                MentorName = c.Mentor.MentorNavigation.FirstName + " " + c.Mentor.MentorNavigation.LastName,
                LastMsg = c.Messages
                    .OrderByDescending(m => m.SentAt)
                    .Select(m => new { m.MessageText, m.SentAt })
                    .FirstOrDefault(),
                UnreadCount = c.Messages
                    .Count(m => m.IsRead == false && m.SenderId != traineeId),
                LastMsgId = c.Messages
                    .OrderByDescending(m => m.SentAt)
                    .Select(m => (int?)m.MessageId)
                    .FirstOrDefault()
            })
            .ToListAsync();

        var lastMsgIds = rows
            .Where(r => r.LastMsgId.HasValue)
            .Select(r => r.LastMsgId!.Value)
            .ToHashSet();

        var fileMessageIds = await _db.ConversationAttachments
            .Where(a => a.MessageId != null && lastMsgIds.Contains(a.MessageId.Value))
            .Select(a => a.MessageId!.Value)
            .ToHashSetAsync();

        var items = rows
            .OrderByDescending(r => r.LastMsg?.SentAt)
            .Select(r => new Areas.Trainee.ViewModels.Messaging.ConversationSummaryItem
            {
                ConversationId = r.ConversationId,
                MentorId = r.MentorId,
                MentorName = r.MentorName,
                LastMessage = r.LastMsgId.HasValue && fileMessageIds.Contains(r.LastMsgId.Value)
                                     ? "📎 Attachment"
                                     : Truncate(r.LastMsg?.MessageText, 60),
                LastMessageAt = r.LastMsg?.SentAt,
                UnreadCount = r.UnreadCount,
                IsFile = r.LastMsgId.HasValue && fileMessageIds.Contains(r.LastMsgId.Value)
            })
            .ToList();

        return ServiceResult<Areas.Trainee.ViewModels.Messaging.ConversationListViewModel>.Success(
            new Areas.Trainee.ViewModels.Messaging.ConversationListViewModel { Conversations = items });
    }

    public async Task<ServiceResult<Areas.Trainee.ViewModels.Messaging.ConversationDetailViewModel>>
        GetTraineeConversationAsync(int conversationId, int traineeId)
    {
        var conv = await _db.Conversations
            .Where(c => c.ConversationId == conversationId && c.TraineeId == traineeId)
            .Select(c => new
            {
                c.ConversationId,
                c.MentorId,
                MentorName = c.Mentor.MentorNavigation.FirstName + " " + c.Mentor.MentorNavigation.LastName
            })
            .FirstOrDefaultAsync();

        if (conv is null)
            return ServiceResult<Areas.Trainee.ViewModels.Messaging.ConversationDetailViewModel>
                .Failure("Conversation not found.");

        await MarkMessagesReadAsync(conversationId, traineeId);

        var messages = await BuildMessageListAsync(conversationId, traineeId);

        return ServiceResult<Areas.Trainee.ViewModels.Messaging.ConversationDetailViewModel>.Success(
            new Areas.Trainee.ViewModels.Messaging.ConversationDetailViewModel
            {
                ConversationId = conv.ConversationId,
                MentorId = conv.MentorId,
                MentorName = conv.MentorName,
                Messages = messages
            });
    }

    public async Task<ServiceResult> SendMessageAsTraineeAsync(
        int conversationId, int traineeId, string? text, IFormFile? file)
    {
        bool owns = await _db.Conversations
            .AnyAsync(c => c.ConversationId == conversationId && c.TraineeId == traineeId);
        if (!owns)
            return ServiceResult.Failure("Conversation not found.");

        return await SendInternalAsync(conversationId, traineeId, text, file);
    }

    // ═════════════════════════════════════════════════════════════════════════
    // SHARED: message count for polling endpoint
    // ═════════════════════════════════════════════════════════════════════════

    /// <summary>
    /// Used by the lightweight polling endpoint to check if new messages
    /// exist since a given message ID, without loading the full thread.
    /// Returns the latest MessageId in the conversation.
    /// </summary>
    public async Task<int?> GetLatestMessageIdAsync(int conversationId, int currentUserId)
    {
        // Ownership check first
        bool owns = await _db.Conversations.AnyAsync(c =>
            c.ConversationId == conversationId &&
            (c.MentorId == currentUserId || c.TraineeId == currentUserId));

        if (!owns) return null;

        return await _db.Messages
            .Where(m => m.ConversationId == conversationId)
            .OrderByDescending(m => m.MessageId)
            .Select(m => (int?)m.MessageId)
            .FirstOrDefaultAsync();
    }

    // ═════════════════════════════════════════════════════════════════════════
    // SHARED
    // ═════════════════════════════════════════════════════════════════════════

    public async Task MarkMessagesReadAsync(int conversationId, int currentUserId)
    {
        var unread = await _db.Messages
            .Where(m => m.ConversationId == conversationId
                     && m.SenderId != currentUserId
                     && m.IsRead == false)
            .ToListAsync();

        if (unread.Count == 0) return;
        foreach (var m in unread) m.IsRead = true;
        await _db.SaveChangesAsync();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Core send
    // ─────────────────────────────────────────────────────────────────────────
    private async Task<ServiceResult> SendInternalAsync(
        int conversationId, int senderId, string? text, IFormFile? file)
    {
        bool hasText = !string.IsNullOrWhiteSpace(text);
        bool hasFile = file is not null && file.Length > 0;

        if (!hasText && !hasFile)
            return ServiceResult.Failure("A message must contain text or a file.");

        await using var tx = await _db.Database.BeginTransactionAsync();
        try
        {
            if (hasText)
            {
                _db.Messages.Add(new Message
                {
                    ConversationId = conversationId,
                    SenderId = senderId,
                    MessageText = text!.Trim(),
                    IsRead = false,
                    SentAt = DateTime.UtcNow
                });
                await _db.SaveChangesAsync();
            }

            if (hasFile)
            {
                // ── Upload via existing BlobService ───────────────────────────
                var upload = await _blob.UploadChatAttachmentAsync(file!);
                if (!upload.Succeeded)
                {
                    await tx.RollbackAsync();
                    return ServiceResult.Failure(upload.Error!);
                }

                var blob = upload.Data!;

                var fileMsg = new Message
                {
                    ConversationId = conversationId,
                    SenderId = senderId,
                    MessageText = blob.Url,
                    IsRead = false,
                    SentAt = DateTime.UtcNow
                };
                _db.Messages.Add(fileMsg);
                await _db.SaveChangesAsync();

                _db.ConversationAttachments.Add(new ConversationAttachment
                {
                    ConversationId = conversationId,
                    MessageId = fileMsg.MessageId,
                    FileName = blob.OriginalFileName,
                    FilePath = blob.Url,
                    FileType = blob.Extension,
                    UploadedBy = senderId,
                    UploadedAt = DateTime.UtcNow
                });
                await _db.SaveChangesAsync();
            }

            await tx.CommitAsync();
        }
        catch (Exception ex)
        {
            await tx.RollbackAsync();
            _logger.LogError(ex, "SendInternal failed for conversation {Id}", conversationId);
            return ServiceResult.Failure("Failed to send message. Please try again.");
        }

        await NotifyRecipientAsync(conversationId, senderId, hasFile && !hasText ? null : text);
        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    private async Task<IReadOnlyList<MessageItemViewModel>> BuildMessageListAsync(
        int conversationId, int currentUserId)
    {
        var attachments = await _db.ConversationAttachments
            .Where(a => a.ConversationId == conversationId && a.MessageId != null)
            .ToDictionaryAsync(a => a.MessageId!.Value);

        var rows = await _db.Messages
            .Where(m => m.ConversationId == conversationId)
            .OrderBy(m => m.SentAt)
            .Select(m => new
            {
                m.MessageId,
                m.SenderId,
                // ✅ Sender IS a User directly (Messages.sender_id → Users), so .FirstName is correct
                SenderName = m.Sender.FirstName + " " + m.Sender.LastName,
                m.MessageText,
                m.IsRead,
                m.SentAt
            })
            .ToListAsync();

        return rows.Select(m =>
        {
            attachments.TryGetValue(m.MessageId, out var att);
            bool isFile = att is not null;

            return new MessageItemViewModel
            {
                MessageId = m.MessageId,
                SenderId = m.SenderId,
                SenderName = m.SenderName,
                IsMine = m.SenderId == currentUserId,
                Text = isFile ? null : m.MessageText,
                IsFile = isFile,
                FileUrl = isFile ? att!.FilePath : null,
                FileName = isFile ? att!.FileName : null,
                FileType = isFile ? att!.FileType : null,
                IsRead = m.IsRead,
                SentAt = m.SentAt ?? DateTime.UtcNow
            };
        }).ToList();
    }

    // ─────────────────────────────────────────────────────────────────────────
    private async Task NotifyRecipientAsync(int conversationId, int senderId, string? text)
    {
        try
        {
            var conv = await _db.Conversations
                .Where(c => c.ConversationId == conversationId)
                .Select(c => new { c.TraineeId, c.MentorId })
                .FirstOrDefaultAsync();

            if (conv is null) return;

            int recipientId = senderId == conv.MentorId ? conv.TraineeId : conv.MentorId;

            var senderName = await _db.Users
                .Where(u => u.UserId == senderId)
                .Select(u => u.FirstName + " " + u.LastName)
                .FirstOrDefaultAsync() ?? "Someone";

            var preview = string.IsNullOrWhiteSpace(text) ? "Sent you an attachment" : Truncate(text, 80);

            await _notifications.CreateAsync(recipientId,
                $"New message from {senderName}", preview!, "message");
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Notification failed for conversation {Id}", conversationId);
        }
    }

    private static string? Truncate(string? s, int max) =>
        s is null ? null : s.Length <= max ? s : s[..max] + "…";
}

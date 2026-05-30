using Rokhsetak.Areas.Mentor;
using Rokhsetak.Areas.Trainee;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Chat;

namespace Rokhsetak.Services.Interfaces;

public interface IConversationService
{
    // ── Auto-creation (called from booking confirmation) ──────────────────────
    /// <summary>
    /// Ensures exactly one conversation exists for a trainee–mentor pair.
    /// If one already exists it is returned unchanged; otherwise a new one is created
    /// linked to the triggering booking.
    /// Returns the ConversationId.
    /// </summary>
    Task<ServiceResult<int>> EnsureConversationExistsAsync(int traineeId, int mentorId);


    // ── Mentor surface ────────────────────────────────────────────────────────
    Task<ServiceResult<Areas.Mentor.ViewModels.Messaging.ConversationListViewModel>> GetMentorConversationsAsync(int mentorId);
    Task<ServiceResult<Areas.Mentor.ViewModels.Messaging.ConversationDetailViewModel>> GetMentorConversationAsync(int conversationId, int mentorId);
    Task<ServiceResult> SendMessageAsMentorAsync(int conversationId, int mentorId, string? text, IFormFile? file);

    // ── Trainee surface ───────────────────────────────────────────────────────
    Task<ServiceResult<Areas.Trainee.ViewModels.Messaging.ConversationListViewModel>> GetTraineeConversationsAsync(int traineeId);
    Task<ServiceResult<Areas.Trainee.ViewModels.Messaging.ConversationDetailViewModel>> GetTraineeConversationAsync(int conversationId, int traineeId);
    Task<ServiceResult> SendMessageAsTraineeAsync(int conversationId, int traineeId, string? text, IFormFile? file);
    Task<int?> GetLatestMessageIdAsync(int conversationId, int currentUserId);
    // ── Shared ────────────────────────────────────────────────────────────────
    /// <summary>Marks all unread messages sent by others in the conversation as read.</summary>
    Task MarkMessagesReadAsync(int conversationId, int currentUserId);

    Task<IReadOnlyList<ChatThreadSummary>> GetConversationsForUserAsync(int userId);
    Task<ChatThreadDetail?> GetConversationForUserAsync(int userId, int conversationId);
    Task<ServiceResult> SendMessageForUserAsync(int conversationId, int userId, string? text, IFormFile? file);
    Task<int> GetUnreadCountForUserAsync(int userId);

}

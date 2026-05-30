using Rokhsetak.Models;

public interface IChatService
{
    Task<int> GetOrCreateConversationAsync(int traineeId, int mentorId, int? bookingId = null);

    Task<List<Conversation>> GetUserConversationsAsync(int userId);

    Task<List<Message>> GetMessagesAsync(int conversationId);

    Task SendMessageAsync(int conversationId, int senderId, string text);

    Task MarkAsReadAsync(int conversationId, int userId);
}
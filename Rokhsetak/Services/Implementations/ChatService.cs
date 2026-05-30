using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;

namespace Rokhsetak.Services.Chat
{
    public class ChatService : IChatService
    {
        private readonly RokhsetakDbContext _context;

        public ChatService(RokhsetakDbContext context)
        {
            _context = context;
        }

        public async Task<int> GetOrCreateConversationAsync(int traineeId, int mentorId, int? bookingId = null)
        {
            var conversation = await _context.Conversations
                .FirstOrDefaultAsync(c =>
                    c.TraineeId == traineeId &&
                    c.MentorId == mentorId);

            if (conversation != null)
                return conversation.ConversationId;

            var newConversation = new Conversation
            {
                TraineeId = traineeId,
                MentorId = mentorId,
                BookingId = bookingId,
                CreatedAt = DateTime.UtcNow
            };

            _context.Conversations.Add(newConversation);
            await _context.SaveChangesAsync();

            return newConversation.ConversationId;
        }

        public async Task<List<Conversation>> GetUserConversationsAsync(int userId)
        {
            var isTrainee = await _context.Trainees
                .AnyAsync(t => t.TraineeNavigation.UserId == userId);

            var isMentor = await _context.Mentors
                .AnyAsync(m => m.MentorNavigation.UserId == userId);

            var query = _context.Conversations
                .Include(c => c.Mentor).ThenInclude(m => m.MentorNavigation)
                .Include(c => c.Trainee).ThenInclude(t => t.TraineeNavigation)
                .Include(c => c.Messages)
                .AsQueryable();

            if (isTrainee)
            {
                query = query.Where(c =>
                    c.Trainee.TraineeNavigation.UserId == userId);
            }

            if (isMentor)
            {
                query = query.Where(c =>
                    c.Mentor.MentorNavigation.UserId == userId);
            }

            return await query
                .OrderByDescending(c =>
                    c.Messages.OrderByDescending(m => m.SentAt)
                              .Select(m => m.SentAt)
                              .FirstOrDefault())
                .ToListAsync();
        }

        public async Task<List<Message>> GetMessagesAsync(int conversationId)
        {
            return await _context.Messages
                .Include(m => m.Sender)
                .Where(m => m.ConversationId == conversationId)
                .OrderBy(m => m.SentAt)
                .ToListAsync();
        }

        public async Task SendMessageAsync(int conversationId, int senderId, string text)
        {
            if (string.IsNullOrWhiteSpace(text))
                return;

            var message = new Message
            {
                ConversationId = conversationId,
                SenderId = senderId,
                MessageText = text,
                SentAt = DateTime.UtcNow,
                IsRead = false
            };

            _context.Messages.Add(message);
            await _context.SaveChangesAsync();
        }

        public async Task MarkAsReadAsync(int conversationId, int userId)
        {
            var messages = await _context.Messages
                .Where(m =>
                    m.ConversationId == conversationId &&
                    m.SenderId != userId &&
                    m.IsRead == false)
                .ToListAsync();

            foreach (var msg in messages)
                msg.IsRead = true;

            await _context.SaveChangesAsync();
        }
    }
}
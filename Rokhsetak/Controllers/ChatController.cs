using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;
using Rokhsetak.Services.Chat;
using System.Security.Claims;

namespace Rokhsetak.Controllers
{
    [Authorize]
    public class ChatController : Controller
    {
        private readonly IChatService _chatService;
        private readonly RokhsetakDbContext _context;

        public ChatController(IChatService chatService, RokhsetakDbContext context)
        {
            _chatService = chatService;
            _context = context;
        }

        /* =========================================================
           GET USER CONVERSATIONS (SIDEBAR LIST)
        ========================================================= */
        [HttpGet]
        public async Task<IActionResult> GetConversations()
        {
            int userId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));

            var conversations = await _context.Conversations
                .Include(c => c.Mentor).ThenInclude(m => m.MentorNavigation)
                .Include(c => c.Trainee).ThenInclude(t => t.TraineeNavigation)
                .Include(c => c.Messages)
                .Where(c =>
                    c.Mentor.MentorNavigation.UserId == userId ||
                    c.Trainee.TraineeNavigation.UserId == userId)
                .ToListAsync();

            var result = conversations.Select(c =>
            {
                var lastMsg = c.Messages
                    .OrderByDescending(m => m.SentAt)
                    .FirstOrDefault();

                var isTrainee = c.Trainee.TraineeNavigation.UserId == userId;

                var otherUserName = isTrainee
                    ? c.Mentor.MentorNavigation.FirstName + " " + c.Mentor.MentorNavigation.LastName
                    : c.Trainee.TraineeNavigation.FirstName + " " + c.Trainee.TraineeNavigation.LastName;

                return new
                {
                    conversationId = c.ConversationId,
                    otherUserName,
                    lastMessage = lastMsg?.MessageText ?? "",
                    lastMessageTime = lastMsg?.SentAt
                };
            });

            return Json(result);
        }

        /* =========================================================
           GET MESSAGES
        ========================================================= */
        [HttpGet]
        public async Task<IActionResult> GetMessages(int conversationId)
        {
            int userId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));

            var messages = await _context.Messages
                .Include(m => m.Sender)
                .Where(m => m.ConversationId == conversationId)
                .OrderBy(m => m.SentAt)
                .Select(m => new
                {
                    text = m.MessageText,
                    sentAt = m.SentAt,
                    isMine = m.SenderId == userId
                })
                .ToListAsync();

            return Json(messages);
        }

        /* =========================================================
           START CONVERSATION (FROM FIND MENTOR)
        ========================================================= */
        [HttpPost]
        public async Task<IActionResult> StartConversation(int mentorId)
        {
            int userId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));

            var trainee = await _context.Trainees
                .FirstOrDefaultAsync(t => t.TraineeNavigation.UserId == userId);

            if (trainee == null)
                return BadRequest("Only trainees can start conversations");

            var conversationId = await _chatService.GetOrCreateConversationAsync(
                trainee.TraineeId,
                mentorId,
                null
            );

            return Json(new { conversationId });
        }

        /* =========================================================
           SEND MESSAGE
        ========================================================= */
        [HttpPost]
        public async Task<IActionResult> Send(int conversationId, string text)
        {
            int userId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));

            var sender = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);

            if (sender == null)
                return BadRequest();

            await _chatService.SendMessageAsync(conversationId, sender.UserId, text);

            return Ok();
        }

        /* =========================================================
           MARK AS READ (optional later use)
        ========================================================= */
        [HttpPost]
        public async Task<IActionResult> MarkAsRead(int conversationId)
        {
            int userId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));

            await _chatService.MarkAsReadAsync(conversationId, userId);

            return Ok();
        }
    }
}
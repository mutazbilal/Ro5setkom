using Rokhsetak.Models;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations
{
    public class NotificationService : INotificationService
    {
        private readonly Ro5setkomDbContext _context;

        public NotificationService(Ro5setkomDbContext context)
        {
            _context = context;
        }

        public async Task CreateAsync(int userId, string title, string message, string type)
        {
            _context.Notifications.Add(new Notification
            {
                UserId = userId,
                Title = title,
                Message = message,
                CreatedAt = DateTime.UtcNow,
                IsRead = false,
                Type = type
            });

            await _context.SaveChangesAsync();
        }
    }
}

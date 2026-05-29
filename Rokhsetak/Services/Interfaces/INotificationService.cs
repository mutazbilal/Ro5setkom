using Rokhsetak.Models;

namespace Rokhsetak.Services.Interfaces
{
    public interface INotificationService
    {
        Task CreateAsync(int userId, string title, string message, string type);

        Task<List<Notification>> GetUserNotificationsAsync(int userId);

        Task<int> GetUnreadCountAsync(int userId);

        Task MarkAllAsReadAsync(int userId);

        Task MarkAsReadAsync(int userId, int notificationId);
    }
}
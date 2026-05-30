using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;

namespace Rokhsetak.Services.Chat.Implementations.Providers
{
    // UserContextProvider.cs
    public class UserContextProvider : IUserContextProvider
    {
        private readonly RokhsetakDbContext _db;
        public UserContextProvider(RokhsetakDbContext db) => _db = db;

        public async Task<UserAiContext?> GetAsync(int userId, CancellationToken ct = default)
        {
            var user = await _db.Users
                .Where(u => u.UserId == userId)
                .Select(u => new { u.FirstName, u.LastName, u.DisplayNameEn, u.LanguagePreference, u.CreatedAt })
                .FirstOrDefaultAsync();

            var fullName = user.LanguagePreference == "ar" ? user.FirstName + " " + user.LastName : user.DisplayNameEn;
            if (user is null) return null;
            return new UserAiContext(
                Name: fullName,
                Role: "trainee",
                Language: user.LanguagePreference ?? "ar",
                RegisteredAt: DateOnly.FromDateTime(user.CreatedAt ?? DateTime.UtcNow)
            );
        }
    }
}

using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;

namespace Rokhsetak.Services.Chat.Implementations.Providers
{
    // BookingContextProvider.cs
    public class BookingContextProvider : IBookingContextProvider
    {
        private readonly RokhsetakDbContext _db;
        public BookingContextProvider(RokhsetakDbContext db) => _db = db;

        public async Task<BookingAiContext?> GetAsync(int userId, string role, CancellationToken ct = default)
        {
            var today = DateOnly.FromDateTime(DateTime.UtcNow);

            bool isMentor = role == UserRole.Mentor;
            bool isTrainee = role == UserRole.Trainee;

            if (!isMentor && !isTrainee) return null;

            var upcoming = await _db.Bookings
                .Include(b => b.Mentor).ThenInclude(m => m.MentorNavigation)
                .Include(b => b.Trainee).ThenInclude(t => t.TraineeNavigation)
                .Where(b => (isMentor ? b.MentorId : b.TraineeId) == userId
                         && b.BookingDate >= today
                         && b.Status != "cancelled")
                .OrderBy(b => b.BookingDate).ThenBy(b => b.StartTime)
                .Take(3)
                .Select(b => new UpcomingBooking(
                    b.BookingDate,
                    b.StartTime,
                    b.SessionType ?? "lesson",
                    isMentor
                        ? b.Trainee.TraineeNavigation.DisplayNameEn   // mentor sees trainee name
                        : b.Mentor.MentorNavigation.DisplayNameEn     // trainee sees mentor name
                ))
                .ToListAsync(ct);

            var completedCount = await _db.Bookings
                .CountAsync(b => (isMentor ? b.MentorId : b.TraineeId) == userId
                              && b.BookingDate < today
                              && b.Status == "completed", ct);

            return new BookingAiContext(upcoming, completedCount);
        }
    }
}

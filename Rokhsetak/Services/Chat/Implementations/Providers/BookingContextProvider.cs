using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;

namespace Rokhsetak.Services.Chat.Implementations.Providers
{
    // BookingContextProvider.cs
    public class BookingContextProvider : IBookingContextProvider
    {
        private readonly RokhsetakDbContext _db;
        public BookingContextProvider(RokhsetakDbContext db) => _db = db;

        public async Task<BookingAiContext?> GetAsync(int userId, CancellationToken ct = default)
        {
            var traineeId = await _db.Trainees
                .Where(t => t.TraineeId == userId)
                .Select(t => (int?)t.TraineeId)
                .FirstOrDefaultAsync(ct);

            if (traineeId is null) return null;

            var today = DateOnly.FromDateTime(DateTime.UtcNow);

            var upcoming = await _db.Bookings
                .Include(b => b.Mentor)
                    .ThenInclude(b => b.MentorNavigation)
                .Where(b => b.TraineeId == traineeId
                         && b.BookingDate >= today
                         && b.Status != "cancelled")
                .OrderBy(b => b.BookingDate).ThenBy(b => b.StartTime)
                .Take(3)
                .Select(b => new UpcomingBooking(
                    b.BookingDate,
                    b.StartTime,
                    b.SessionType ?? "lesson",
                    b.Mentor.MentorNavigation.DisplayNameEn
                ))
                .ToListAsync(ct);

            var completedCount = await _db.Bookings
                .CountAsync(b => b.TraineeId == traineeId
                              && b.BookingDate < today
                              && b.Status == "completed", ct);

            return new BookingAiContext(upcoming, completedCount);
        }
    }
}

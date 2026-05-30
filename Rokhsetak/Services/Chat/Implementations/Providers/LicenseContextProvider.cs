using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;

namespace Rokhsetak.Services.Chat.Implementations.Providers
{
    // LicenseContextProvider.cs
    public class LicenseContextProvider : ILicenseContextProvider
    {
        private readonly RokhsetakDbContext _db;
        public LicenseContextProvider(RokhsetakDbContext db) => _db = db;

        public async Task<LicenseAiContext?> GetAsync(int userId, CancellationToken ct = default)
        {
            // userId here is the trainee's UserId — resolve TraineeId first
            var traineeId = await _db.Trainees
                .Where(t => t.TraineeId == userId)
                .Select(t => (int?)t.TraineeId)
                .FirstOrDefaultAsync(ct);

            if (traineeId is null) return null;

            var lic = await _db.TraineeLicenses
                .Include(l => l.LicenseType)
                .Where(l => l.TraineeId == traineeId && l.IsActive)
                .Select(l => new { l.TraineeLicenseId, l.LicenseType.LicenseName, l.Stage })
                .FirstOrDefaultAsync(ct);

            if (lic is null) return null;
            return new LicenseAiContext(lic.LicenseName, lic.Stage, lic.TraineeLicenseId, true);
        }
    }
}

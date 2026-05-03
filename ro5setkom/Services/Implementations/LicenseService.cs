using Microsoft.EntityFrameworkCore;
using ro5setkom.Models;
using ro5setkom.Services.Interfaces;
using ro5setkom.ViewModels.Registration;

namespace ro5setkom.Services.Implementations
{
    public class LicenseService : ILicenseService
    {
        private readonly Ro5setkomDbContext _db;

        public LicenseService(Ro5setkomDbContext context)
        {
            _db = context;
        }

        // ─────────────────────────────────────────────────────────────────────────
        // License Types dropdown helper
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<List<LicenseTypeOption>> GetLicenseTypesAsync()
            => await _db.LicenseTypes
                .AsNoTracking()
                .OrderBy(l => l.LicenseName)
                .Select(l => new LicenseTypeOption(l.LicenseTypeId, l.LicenseName, l.Description))
                .ToListAsync();
    }
}

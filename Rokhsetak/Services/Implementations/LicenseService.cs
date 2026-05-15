using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.ViewModels.Registration;

namespace Rokhsetak.Services.Implementations
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
                .Select(l => new LicenseTypeOption(l.LicenseTypeId, l.DisplayNameEn, l.DescriptionEn))
                .ToListAsync();
    }
}

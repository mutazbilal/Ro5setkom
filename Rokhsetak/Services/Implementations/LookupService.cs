using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.ViewModels.Registration;

namespace Rokhsetak.Services.Implementations
{
    public class LookupService : ILookupService
    {
        private readonly RokhsetakDbContext _db;

        public LookupService(RokhsetakDbContext context)
        {
            _db = context;
        }

        // ─────────────────────────────────────────────────────────────────────────
        // License Types dropdown helper
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<List<LicenseTypeOption>> GetLicenseTypesAsync(string culture = "ar")
            => await _db.LicenseTypes
                .AsNoTracking()
                .OrderBy(l => l.LicenseName)
                .Select(l => new LicenseTypeOption(
                    l.LicenseTypeId,
                    culture == "ar" ? l.DisplayNameAr : l.DisplayNameEn,
                    culture == "ar" ? l.DescriptionAr : l.DescriptionEn
                ))
                .ToListAsync();

        // ─────────────────────────────────────────────────────────────────────────
        // Training Centers dropdown helper
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<List<TrainingCenterOption>> GetTrainingCentersAsync(string culture = "ar")
        {
            return await _db.TrainingCenters
                .AsNoTracking()
                .OrderBy(tc => culture == "ar"
                    ? tc.DisplayNameAr
                    : tc.DisplayNameEn)
                .Select(tc => new TrainingCenterOption(
                    tc.CenterId,
                    culture == "ar"
                        ? tc.DisplayNameAr
                        : tc.DisplayNameEn
                ))
                .ToListAsync();
        }

        // ─────────────────────────────────────────────────────────────────────────
        // Provinces dropdown helper
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<List<ProvinceOption>> GetProvincesAsync(string culture = "ar")
        {
            return await _db.Provinces
                .AsNoTracking()

                // ORDER USING DB-TRANSLATABLE EXPRESSION
                .OrderBy(p =>
                    p.ProvinceTranslations
                        .Where(pt => pt.LanguageCode == culture)
                        .Select(pt => pt.DisplayName)
                        .FirstOrDefault()
                )

                // THEN PROJECT
                .Select(p => new ProvinceOption(
                    p.ProvinceId,
                    p.ProvinceTranslations
                        .Where(pt => pt.LanguageCode == culture)
                        .Select(pt => pt.DisplayName)
                        .FirstOrDefault()!
                ))
                .ToListAsync();
        }

        // ─────────────────────────────────────────────────────────────────────────
        // Cities dropdown helper
        // ─────────────────────────────────────────────────────────────────────────
        public async Task<List<CityOption>> GetCitiesAsync(string culture = "ar")
        {
            return await _db.Cities
                .AsNoTracking()

                // order using DB-translatable expression FIRST
                .OrderBy(c =>
                    c.CityTranslations
                        .Where(ct => ct.LanguageCode == culture)
                        .Select(ct => ct.DisplayName)
                        .FirstOrDefault()
                )

                // then project AFTER ordering
                .Select(c => new CityOption(
                    c.CityId,
                    c.ProvinceId,
                    c.CityTranslations
                        .Where(ct => ct.LanguageCode == culture)
                        .Select(ct => ct.DisplayName)
                        .FirstOrDefault()!
                ))
                .ToListAsync();
        }
    }
}
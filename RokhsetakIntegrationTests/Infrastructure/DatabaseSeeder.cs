using Rokhsetak.Models;
using BCryptNet = BCrypt.Net.BCrypt;

namespace RokhsetakIntegrationTests.Infrastructure;

internal static class DatabaseSeeder
{
    // Stable IDs so tests can reference them by constant.
    public const int RoleAdminId = 1;
    public const int RoleMentorId = 2;
    public const int RoleTraineeId = 3;

    public const int LicenseTypeBId = 1;

    public static void SeedReferenceData(RokhsetakDbContext db)
    {
        if (!db.Roles.Any())
        {
            db.Roles.AddRange(
                new Role { RoleId = RoleAdminId, RoleName = "admin" },
                new Role { RoleId = RoleMentorId, RoleName = "mentor" },
                new Role { RoleId = RoleTraineeId, RoleName = "trainee" }
            );
        }

        if (!db.LicenseTypes.Any())
        {
            db.LicenseTypes.Add(new LicenseType
            {
                LicenseTypeId = LicenseTypeBId,
                LicenseName = "B",
                DisplayNameEn = "Private Car",
                DisplayNameAr = "سيارة خاصة",
                DescriptionEn = "Standard private vehicle license",
                DescriptionAr = "رخصة سيارة خاصة"
            });
        }

        // ---------------- PROVINCES ----------------
        if (!db.Provinces.Any())
        {
            db.Provinces.AddRange(
                new Province
                {
                    ProvinceId = 1,
                    ProvinceKey = "amman",
                    ProvinceTranslations = new List<ProvinceTranslation>
                    {
                    new ProvinceTranslation
                    {
                        LanguageCode = "en",
                        DisplayName = "Amman"
                    },
                    new ProvinceTranslation
                    {
                        LanguageCode = "ar",
                        DisplayName = "عمان"
                    }
                    }
                },
                new Province
                {
                    ProvinceId = 2,
                    ProvinceKey = "zarqa",
                    ProvinceTranslations = new List<ProvinceTranslation>
                    {
                    new ProvinceTranslation
                    {
                        LanguageCode = "en",
                        DisplayName = "Zarqa"
                    },
                    new ProvinceTranslation
                    {
                        LanguageCode = "ar",
                        DisplayName = "الزرقاء"
                    }
                    }
                }
            );
        }

        // ---------------- CITIES ----------------
        if (!db.Cities.Any())
        {
            db.Cities.AddRange(
                new City
                {
                    CityId = 1,
                    ProvinceId = 1, // Amman
                    CityKey = "ammancity",
                    CityTranslations = new List<CityTranslation>
                    {
                    new CityTranslation
                    {
                        LanguageCode = "en",
                        DisplayName = "Amman City"
                    },
                    new CityTranslation
                    {
                        LanguageCode = "ar",
                        DisplayName = "مدينة عمان"
                    }
                    }
                },
                new City
                {
                    CityId = 2,
                    ProvinceId = 2, // Zarqa
                    CityKey = "citykey",
                    CityTranslations = new List<CityTranslation>
                    {
                    new CityTranslation
                    {
                        LanguageCode = "en",
                        DisplayName = "Zarqa City"
                    },
                    new CityTranslation
                    {
                        LanguageCode = "ar",
                        DisplayName = "مدينة الزرقاء"
                    }
                    }
                }
            );
        }

        db.SaveChanges();
    }

    // ── Citizen + User helpers ───────────────────────────────────────────────
    public static GovCitizen NewCitizen(string nationalId, string firstName = "Test", string lastName = "User")
        => new()
        {
            NationalId = nationalId,
            FirstName = firstName,
            LastName = lastName,
            DateOfBirth = new DateOnly(1995, 1, 1),
            Gender = "male",
            ProvinceId = 1,
            CityId = 1,
            AddressLine1 = "Test Street",
            PostalCode = "11181",
            IsEligible = true
        };

    public static User NewUser(
        int userId, string nationalId, int roleId,
        string email, string plainPassword = "Password1!")
        => new()
        {
            UserId = userId,
            NationalId = nationalId,
            RoleId = roleId,
            FirstName = "Test",
            LastName = "User",
            Email = email,
            PasswordHash = BCryptNet.HashPassword(plainPassword),
            PhoneNumber = "0790000000",
            ProvinceId = 1,
            CityId = 1,
            AddressLine1 = "Test Street",
            DateOfBirth = new DateOnly(1995, 1, 1),
            Gender = "male",
            IsActive = true,
            LanguagePreference = "en"
        };

    public static Mentor NewMentor(int userId)
        => new()
        {
            MentorId = userId,
            LicenseTypeId = LicenseTypeBId,
            PricePerSession = 25m,
            VehicleType = "Sedan"
        };

    public static Trainee NewTrainee(int userId)
        => new() { TraineeId = userId, LicenseTypeId = LicenseTypeBId };

    public static TraineeLicense NewTraineeLicense(
        int id, int traineeId, int mentorId, string stage = "registered", int progress = 0)
        => new()
        {
            TraineeLicenseId = id,
            TraineeId = traineeId,
            MentorId = mentorId,
            LicenseTypeId = LicenseTypeBId,
            Stage = stage,
            ProgressPercentage = progress,
            IsActive = true
        };
}
using FluentAssertions;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using Rokhsetak.Models;
using Rokhsetak.Services.Implementations;
using Rokhsetak.ViewModels.Registration;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

namespace TestRo5setkom
{
    [TestClass]
    public class RegistrationServiceTests
    {
        private RokhsetakDbContext GetDbContext()
        {
            var options = new DbContextOptionsBuilder<RokhsetakDbContext>()
                .UseInMemoryDatabase(Guid.NewGuid().ToString())
                .ConfigureWarnings(w =>
                    w.Ignore(InMemoryEventId.TransactionIgnoredWarning))
                .Options;

            return new RokhsetakDbContext(options);
        }

        [TestMethod]
        public async Task LookupNationalId_ShouldFail_WhenNotFound()
        {
            var db = GetDbContext();

            var service = new RegistrationService(
                db,
                null,
                Mock.Of<ILogger<RegistrationService>>());

            var result = await service.LookupNationalIdAsync("123", true);

            result.Succeeded.Should().BeFalse();
        }

        [TestMethod]
        public async Task LookupNationalId_ShouldFail_WhenUserAlreadyExists()
        {
            var db = GetDbContext();

            db.GovCitizens.Add(new GovCitizen
            {
                NationalId = "1234567890",
                IsEligible = true,

                FirstName = "Test",
                LastName = "User",
                Gender = "M",

                Province = "Amman",
                City = "Amman",

                AddressLine1 = "Street 1",
                AddressLine2 = "Street 2",
                PostalCode = "11111",

                DateOfBirth = new DateOnly(2000, 1, 1)
            });

            db.Users.Add(new User
            {
                RoleId = 1,
                NationalId = "1234567890",

                FirstName = "Test",
                LastName = "User",

                DateOfBirth = new DateOnly(2000, 1, 1),
                Gender = "male",

                Email = "test@test.com",
                PhoneNumber = "0790000000",

                Province = "Amman",
                City = "Amman",

                AddressLine1 = "Street 1",
                AddressLine2 = "Street 2",
                PostalCode = "11111",

                PasswordHash = "hashed_password",

                ProfilePicture = null,
                LanguagePreference = "ar",

                IsActive = true,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            });

            await db.SaveChangesAsync();

            var service = new RegistrationService(db, null, Mock.Of<ILogger<RegistrationService>>());

            var result = await service.LookupNationalIdAsync("1234567890", true);

            result.Succeeded.Should().BeFalse();
            result.Error.Should().Contain("already registered");
        }

        [TestMethod]
        public async Task RegisterTrainee_ShouldSucceed_WhenValid()
        {
            var db = GetDbContext();

            db.GovCitizens.Add(new GovCitizen
            {
                NationalId = "1234567890",
                IsEligible = true,

                FirstName = "Test",
                LastName = "User",
                Gender = "male",

                Province = "Amman",
                City = "Amman",

                AddressLine1 = "Street 1",
                AddressLine2 = "Street 2",
                PostalCode = "11111",

                DateOfBirth = new DateOnly(2000, 1, 1)
            });

            // ─────────────────────────────────────────
            // 2. LicenseType (required by service)
            // ─────────────────────────────────────────
            db.LicenseTypes.Add(new LicenseType
            {
                LicenseTypeId = 1,
                LicenseName = "private_manual",
                DisplayNameEn = "Private Car (Manual)",
                DisplayNameAr = "سيارة خاصة (يدوي)",
                DescriptionEn = "Private car with manual transmission",
                DescriptionAr = "سيارة خاصة ذات ناقل حركة يدوي"
            });

            // ─────────────────────────────────────────
            // 3. IMPORTANT: ensure email is NOT already used
            // (service checks this BEFORE inserting user)
            // ─────────────────────────────────────────
            // DO NOT add any User here

            await db.SaveChangesAsync();

            var service = new RegistrationService(db, null, Mock.Of<ILogger<RegistrationService>>());

            var model = new TraineeRegistrationViewModel
            {
                NationalId = "1234567890",

                FirstName = "Test",
                LastName = "User",

                DateOfBirth = new DateOnly(2000, 1, 1),
                Gender = "male",

                Province = "Amman",
                City = "Amman",
                AddressLine1 = "Street 1",
                AddressLine2 = "Street 2",
                PostalCode = "11111",

                Email = "test@test.com",
                PhoneNumber = "+962778152830",

                Password = "SecurePass123!",
                ConfirmPassword = "SecurePass123!",

                LicenseTypeId = 1,

                AcceptedTerms = true
            };

            var result = await service.RegisterTraineeAsync(model, "127.0.0.1");
            Assert.IsTrue(result.Succeeded, result.Error);
            result.Succeeded.Should().BeTrue();
            db.Users.Count().Should().Be(1);
            db.Trainees.Count().Should().Be(1);
            db.TraineeLicenses.Count().Should().Be(1);
        }

        [TestMethod]
        public async Task RegisterTrainee_ShouldFail_WhenEmailExists()
        {
            var db = GetDbContext();

            db.GovCitizens.Add(new GovCitizen
            {
                NationalId = "1234567890",
                IsEligible = true,

                FirstName = "Test",
                LastName = "User",
                Gender = "M",

                Province = "Amman",
                City = "Amman",

                AddressLine1 = "Street 1",
                AddressLine2 = "Street 2",
                PostalCode = "11111",

                DateOfBirth = new DateOnly(2000, 1, 1)
            });

            db.Users.Add(new User
            {
                RoleId = 1,
                NationalId = "1234567890",

                FirstName = "Test",
                LastName = "User",

                DateOfBirth = new DateOnly(2000, 1, 1),
                Gender = "male",

                Email = "test@test.com",
                PhoneNumber = "0790000000",

                Province = "Amman",
                City = "Amman",

                AddressLine1 = "Street 1",
                AddressLine2 = "Street 2",
                PostalCode = "11111",

                PasswordHash = "hashed_password",

                ProfilePicture = null,
                LanguagePreference = "ar",

                IsActive = true,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            });

            db.LicenseTypes.Add(new LicenseType
            {
                LicenseTypeId = 1,
                LicenseName = "private_manual",
                DisplayNameEn = "Private Car (Manual)",
                DisplayNameAr = "سيارة خاصة (يدوي)",
                DescriptionEn = "Private car with manual transmission",
                DescriptionAr = "سيارة خاصة ذات ناقل حركة يدوي"
            });

            await db.SaveChangesAsync();

            var service = new RegistrationService(db, null, Mock.Of<ILogger<RegistrationService>>());

            var model = new TraineeRegistrationViewModel
            {
                NationalId = "1234567890",
                Email = "test@test.com",
                Password = "123",
                LicenseTypeId = 1
            };

            var result = await service.RegisterTraineeAsync(model, "127.0.0.1");

            result.Succeeded.Should().BeFalse();
            result.Error.Should().Contain("This National ID is already registered");
        }

        private IFormFile CreateFakeFile(string fileName = "test.pdf")
        {
            var content = new MemoryStream(new byte[100]);
            return new FormFile(content, 0, content.Length, "file", fileName);
        }

        [TestMethod]
        public async Task RegisterMentor_ShouldSucceed_WhenValid()
        {
            var db = GetDbContext();

            db.GovCitizens.Add(new GovCitizen
            {
                NationalId = "1234567890",
                IsEligible = true,

                FirstName = "Test",
                LastName = "User",
                Gender = "M",

                Province = "Amman",
                City = "Amman",

                AddressLine1 = "Street 1",
                AddressLine2 = "Street 2",
                PostalCode = "11111",

                DateOfBirth = new DateOnly(2000, 1, 1)
            });

            db.LicenseTypes.Add(new LicenseType
            {
                LicenseTypeId = 1,
                LicenseName = "private_manual",
                DisplayNameEn = "Private Car (Manual)",
                DisplayNameAr = "سيارة خاصة (يدوي)",
                DescriptionEn = "Private car with manual transmission",
                DescriptionAr = "سيارة خاصة ذات ناقل حركة يدوي"
            });

            await db.SaveChangesAsync();

            var envMock = new Mock<IWebHostEnvironment>();
            envMock.Setup(e => e.WebRootPath).Returns(Path.GetTempPath());

            var service = new RegistrationService(
                db,
                envMock.Object,
                Mock.Of<ILogger<RegistrationService>>());

            var model = new MentorRegistrationViewModel
            {
                NationalId = "1234567890",

                FirstName = "Test",
                LastName = "Mentor",

                DateOfBirth = new DateOnly(1995, 1, 1),
                Gender = "male",

                Province = "Amman",
                City = "Amman",
                AddressLine1 = "Street 1",
                AddressLine2 = "Street 2",
                PostalCode = "11111",

                Email = "mentor@test.com",
                PhoneNumber = "+962778152830",

                Password = "SecurePass123!",
                ConfirmPassword = "SecurePass123!",

                LicenseTypeId = 1,

                CertificationFile = CreateFakeFile()
            };

            var result = await service.RegisterMentorAsync(model, "127.0.0.1");
            Assert.IsTrue(result.Succeeded, result.Error);
            result.Succeeded.Should().BeTrue();
            db.Mentors.Count().Should().Be(1);
            db.MentorApplications.Count().Should().Be(1);
        }
    }
}
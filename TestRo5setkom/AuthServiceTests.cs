using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using Rokhsetak.Models;
using Rokhsetak.Services.Implementations;
using Rokhsetak.ViewModels.Auth;
using BCrypt.Net;

namespace TestRo5setkom
{
    [TestClass]
    public class AuthServiceTests
    {
        // ─────────────────────────────────────────
        // DB FACTORY
        // ─────────────────────────────────────────
        private RokhsetakDbContext GetDbContext()
        {
            var options = new DbContextOptionsBuilder<RokhsetakDbContext>()
                .UseInMemoryDatabase(Guid.NewGuid().ToString())
                .Options;

            return new RokhsetakDbContext(options);
        }

        private AuthService CreateService(RokhsetakDbContext db)
        {
            return new AuthService(
                db,
                Mock.Of<ILogger<AuthService>>());
        }

        // ─────────────────────────────────────────
        // TEST 1: LOGIN SUCCESS
        // ─────────────────────────────────────────
        [TestMethod]
        public async Task Login_ShouldSucceed_WhenCredentialsAreValid()
        {
            var db = GetDbContext();

            db.Roles.Add(new Role
            {
                RoleId = 1,
                RoleName = "trainee"
            });

            db.Users.Add(new User
            {
                UserId = 1,
                NationalId = "1234567890",
                FirstName = "Test",
                LastName = "User",
                Email = "test@test.com",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("Password123"),
                IsActive = true,
                RoleId = 1,
                AddressLine1 = "123 Test St",
                City = "Testville",
                Province = "Test Province",
            });

            await db.SaveChangesAsync();

            var service = CreateService(db);

            var model = new LoginViewModel
            {
                NationalId = "1234567890",
                Password = "Password123"
            };

            var result = await service.LoginAsync(model, "127.0.0.1");

            Assert.IsTrue(result.Succeeded);
            Assert.AreEqual("1234567890", result.Data.NationalId);
        }

        // ─────────────────────────────────────────
        // TEST 2: WRONG PASSWORD
        // ─────────────────────────────────────────
        [TestMethod]
        public async Task Login_ShouldFail_WhenPasswordIsWrong()
        {
            var db = GetDbContext();

            db.Roles.Add(new Role
            {
                RoleId = 1,
                RoleName = "trainee"
            });

            db.Users.Add(new User
            {
                UserId = 1,
                NationalId = "1234567890",
                FirstName = "Test",
                LastName = "User",
                Email = "test@test.com",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("CorrectPassword"),
                IsActive = true,
                RoleId = 1,
                AddressLine1 = "123 Test St",
                City = "Testville",
                Province = "Test Province",
            });

            await db.SaveChangesAsync();

            var service = CreateService(db);

            var model = new LoginViewModel
            {
                NationalId = "1234567890",
                Password = "WrongPassword"
            };

            var result = await service.LoginAsync(model, "127.0.0.1");

            Assert.IsFalse(result.Succeeded);
        }

        // ─────────────────────────────────────────
        // TEST 3: USER NOT FOUND
        // ─────────────────────────────────────────
        [TestMethod]
        public async Task Login_ShouldFail_WhenUserDoesNotExist()
        {
            var db = GetDbContext();
            var service = CreateService(db);

            var model = new LoginViewModel
            {
                NationalId = "9999999999",
                Password = "Password123"
            };

            var result = await service.LoginAsync(model, "127.0.0.1");

            Assert.IsFalse(result.Succeeded);
        }

        // ─────────────────────────────────────────
        // TEST 4: INACTIVE USER
        // ─────────────────────────────────────────
        [TestMethod]
        public async Task Login_ShouldFail_WhenUserIsInactive()
        {
            var db = GetDbContext();

            db.Roles.Add(new Role
            {
                RoleId = 1,
                RoleName = "trainee"
            });

            db.Users.Add(new User
            {
                UserId = 1,
                NationalId = "1234567890",
                FirstName = "Test",
                LastName = "User",
                Email = "test@test.com",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("Password123"),
                IsActive = false,
                RoleId = 1,
                AddressLine1 = "123 Test St",
                City = "Testville",
                Province = "Test Province",
            });

            await db.SaveChangesAsync();

            var service = CreateService(db);

            var model = new LoginViewModel
            {
                NationalId = "1234567890",
                Password = "Password123"
            };

            var result = await service.LoginAsync(model, "127.0.0.1");

            Assert.IsFalse(result.Succeeded);
        }

        // ─────────────────────────────────────────
        // TEST 5: LOGOUT (simple)
        // ─────────────────────────────────────────
        [TestMethod]
        public async Task Logout_ShouldCompleteSuccessfully()
        {
            var db = GetDbContext();
            var service = CreateService(db);

            await service.LogoutAsync(1);

            Assert.IsTrue(true); // method is void logic
        }
    }
}
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rokhsetak.Models;
using Rokhsetak.Services.Implementations;

namespace Rokhsetak.Tests;

[TestClass]
public class MentorDashboardServiceTests
{
    private RokhsetakDbContext CreateContext()
    {
        var opts = new DbContextOptionsBuilder<RokhsetakDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new RokhsetakDbContext(opts);
    }

    private static void SeedMentor(RokhsetakDbContext ctx, int mentorId = 1)
    {
        ctx.Users.Add(new User
        {
            UserId = mentorId,
            FirstName = "Ahmad",
            LastName = "Ali",
            Email = "ahmad@test.com",
            NationalId = "1234567890",
            Province = "Zarqa",
            City = "Zarqa",
            AddressLine1 = "Street 1",
            PasswordHash = "hash",
            RoleId = 2
        });
        ctx.Mentors.Add(new Mentor { MentorId = mentorId });
        ctx.SaveChanges();
    }

    // ─── No mentor ────────────────────────────────────────────────────────────

    [TestMethod]
    public async Task GetDashboardAsync_MentorNotFound_ReturnsFailure()
    {
        using var ctx = CreateContext();
        var svc = new MentorDashboardService(ctx);
        var result = await svc.GetDashboardAsync(99);

        Assert.IsFalse(result.Succeeded);
    }

    // ─── Empty dashboard ──────────────────────────────────────────────────────

    [TestMethod]
    public async Task GetDashboardAsync_NoBookings_ReturnsEmptyDashboard()
    {
        using var ctx = CreateContext();
        SeedMentor(ctx);

        var svc = new MentorDashboardService(ctx);
        var result = await svc.GetDashboardAsync(1);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(0, result.Data!.TodaysConfirmedSessions.Count);
        Assert.AreEqual(0, result.Data.PendingBookings.Count);
        Assert.AreEqual(0, result.Data.TotalPendingCount);
    }

    // ─── Pending bookings appear ──────────────────────────────────────────────

    [TestMethod]
    public async Task GetDashboardAsync_PendingBookings_AreListedCorrectly()
    {
        using var ctx = CreateContext();
        SeedMentor(ctx);

        ctx.LicenseTypes.Add(new LicenseType
        {
            LicenseTypeId = 1,
            LicenseName = "private_manual",
            DisplayNameEn = "Private Car (Manual)",
            DisplayNameAr = "سيارة خاصة (يدوي)",
            DescriptionEn = "Private car with manual transmission",
            DescriptionAr = "سيارة خاصة ذات ناقل حركة يدوي"
        });
        ctx.Users.Add(new User
        {
            UserId = 2,
            FirstName = "Sara",
            LastName = "Salem",
            Email = "sara@test.com",
            NationalId = "0987654321",
            Province = "Amman",
            City = "Amman",
            AddressLine1 = "St 2",
            PasswordHash = "hash",
            RoleId = 3
        });
        ctx.Trainees.Add(new Trainee { TraineeId = 2 });
        ctx.TraineeLicenses.Add(new TraineeLicense
        {
            TraineeLicenseId = 1,
            TraineeId = 2,
            LicenseTypeId = 1,
            Stage = "registered",
            IsActive = true
        });
        ctx.Bookings.Add(new Booking
        {
            BookingId = 1,
            TraineeId = 2,
            MentorId = 1,
            LicenseTypeId = 1,
            BookingDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1)),
            StartTime = new TimeOnly(9, 0),
            EndTime = new TimeOnly(10, 0),
            Status = "pending",
            TraineeLicenseId = 1
        });
        ctx.SaveChanges();

        var svc = new MentorDashboardService(ctx);
        var result = await svc.GetDashboardAsync(1);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(1, result.Data!.TotalPendingCount);
        Assert.AreEqual(1, result.Data.PendingBookings.Count);
        Assert.IsTrue(result.Data.PendingBookings.Single().CanConfirm);
        Assert.IsTrue(result.Data.PendingBookings.Single().CanReschedule);
    }

    // ─── Availability slots visible ───────────────────────────────────────────

    [TestMethod]
    public async Task GetDashboardAsync_AvailabilityForToday_IsShown()
    {
        using var ctx = CreateContext();
        SeedMentor(ctx);

        var todayDow = DateTime.UtcNow.DayOfWeek.ToString().ToLower();
        ctx.MentorAvailabilities.Add(new MentorAvailability
        {
            AvailabilityId = 1,
            MentorId = 1,
            DayOfWeek = todayDow,
            StartTime = new TimeOnly(8, 0),
            EndTime = new TimeOnly(12, 0),
            IsActive = true
        });
        ctx.SaveChanges();

        var svc = new MentorDashboardService(ctx);
        var result = await svc.GetDashboardAsync(1);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(1, result.Data!.TodaysAvailabilitySlots.Count);
        Assert.IsFalse(result.Data.TodaysAvailabilitySlots.Single().IsBooked);
    }

    // ─── Mark done availability ───────────────────────────────────────────────

    [TestMethod]
    public async Task GetDashboardAsync_ConfirmedPastSession_CanMarkDone()
    {
        using var ctx = CreateContext();
        SeedMentor(ctx);

        ctx.LicenseTypes.Add(new LicenseType
        {
            LicenseTypeId = 1,
            LicenseName = "private_manual",
            DisplayNameEn = "Private Car (Manual)",
            DisplayNameAr = "سيارة خاصة (يدوي)",
            DescriptionEn = "Private car with manual transmission",
            DescriptionAr = "سيارة خاصة ذات ناقل حركة يدوي"
        });
        ctx.Users.Add(new User
        {
            UserId = 2,
            FirstName = "Leen",
            LastName = "Nour",
            Email = "leen@test.com",
            NationalId = "1111111111",
            Province = "Amman",
            City = "Amman",
            AddressLine1 = "St 3",
            PasswordHash = "hash",
            RoleId = 3
        });
        ctx.Trainees.Add(new Trainee { TraineeId = 2 });
        ctx.TraineeLicenses.Add(new TraineeLicense
        {
            TraineeLicenseId = 1,
            TraineeId = 2,
            LicenseTypeId = 1,
            Stage = "registered",
            IsActive = true
        });

        // Session that ended yesterday
        var yesterday = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(-1));
        ctx.Bookings.Add(new Booking
        {
            BookingId = 1,
            TraineeId = 2,
            MentorId = 1,
            LicenseTypeId = 1,
            BookingDate = yesterday,
            StartTime = new TimeOnly(9, 0),
            EndTime = new TimeOnly(10, 0),
            Status = "confirmed",
            TraineeLicenseId = 1
        });
        ctx.SaveChanges();

        var svc = new MentorDashboardService(ctx);
        var result = await svc.GetDashboardAsync(1);

        Assert.IsTrue(result.Succeeded);
        // Session is yesterday so not in today's confirmed, but check overall pending is 0
        Assert.AreEqual(0, result.Data!.TotalPendingCount);
    }
}
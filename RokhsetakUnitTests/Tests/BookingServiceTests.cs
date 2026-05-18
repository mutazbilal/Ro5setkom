using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Rokhsetak.Areas.Trainee.ViewModels.Booking;
using Rokhsetak.Models;
using Rokhsetak.Services.Implementations;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Tests;

[TestClass]
public class BookingServiceTests
{
    private RokhsetakDbContext CreateContext()
    {
        var opts = new DbContextOptionsBuilder<RokhsetakDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .ConfigureWarnings(w =>
                w.Ignore(
                    Microsoft.EntityFrameworkCore.Diagnostics
                        .InMemoryEventId.TransactionIgnoredWarning))
            .Options;
        return new RokhsetakDbContext(opts);
    }

    private static Mock<INotificationService> MockNotif() => new();

    private static void SeedFull(RokhsetakDbContext ctx)
    {
        ctx.LicenseTypes.Add(new LicenseType
        {
            LicenseTypeId = 1,
            LicenseName = "private_manual",
            DisplayNameEn = "Private Car (Manual)",
            DisplayNameAr = "سيارة خاصة (يدوي)",
            DescriptionEn = "Private car with manual transmission",
            DescriptionAr = "سيارة خاصة ذات ناقل حركة يدوي"
        });

        // Trainee
        ctx.Users.Add(new User
        {
            UserId = 1,
            FirstName = "Sara",
            LastName = "Salem",
            Email = "sara@test.com",
            NationalId = "0000000001",
            Province = "Amman",
            City = "Amman",
            AddressLine1 = "St 1",
            PasswordHash = "hash",
            RoleId = 3
        });
        ctx.Trainees.Add(new Trainee { TraineeId = 1, LicenseTypeId = 1 });
        ctx.TraineeLicenses.Add(new TraineeLicense
        {
            TraineeLicenseId = 1,
            TraineeId = 1,
            LicenseTypeId = 1,
            Stage = "theoretical_prep",
            IsActive = true,
            MentorId = 2
        });

        // Mentor
        ctx.Users.Add(new User
        {
            UserId = 2,
            FirstName = "Ahmad",
            LastName = "Ali",
            Email = "ahmad@test.com",
            NationalId = "0000000002",
            Province = "Amman",
            City = "Amman",
            AddressLine1 = "St 2",
            PasswordHash = "hash",
            RoleId = 2
        });
        ctx.Mentors.Add(new Mentor
        {
            MentorId = 2,
            LicenseTypeId = 1,
            City = "Amman",
            PricePerSession = 15
        });
        ctx.MentorApplications.Add(new MentorApplication
        {
            ApplicationId = 1,
            MentorId = 2,
            Status = "approved"
        });
        ctx.MentorAvailabilities.Add(new MentorAvailability
        {
            AvailabilityId = 1,
            MentorId = 2,
            DayOfWeek = "monday",
            StartTime = new TimeOnly(9, 0),
            EndTime = new TimeOnly(17, 0),
            IsActive = true
        });

        ctx.SaveChanges();
    }

    private static BookSessionViewModel ValidBooking(DateOnly? date = null) =>
        new()
        {
            MentorId = 2,
            TraineeLicenseId = 1,
            LicenseTypeId = 1,
            SessionType = "theoretical",
            BookingDate = date ?? DateOnly.FromDateTime(DateTime.UtcNow.AddDays(3)),
            StartTime = new TimeOnly(10, 0),
            EndTime = new TimeOnly(11, 0)
        };

    // ─── BookSession ──────────────────────────────────────────────────────────

    [TestMethod]
    public async Task BookSessionAsync_ValidRequest_CreatesBooking()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.BookSessionAsync(traineeId: 1, ValidBooking());

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(1, ctx.Bookings.Count());
        Assert.AreEqual("pending", ctx.Bookings.Single().Status);
    }

    [TestMethod]
    public async Task BookSessionAsync_PastDate_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var model = ValidBooking(DateOnly.FromDateTime(DateTime.UtcNow.AddDays(-2)));
        var svc = new BookingService(ctx, MockNotif().Object);

        var result = await svc.BookSessionAsync(1, model);

        Assert.IsFalse(result.Succeeded);
        Assert.AreEqual(0, ctx.Bookings.Count());
    }

    [TestMethod]
    public async Task BookSessionAsync_StartAfterEnd_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var model = ValidBooking();
        model.StartTime = new TimeOnly(12, 0);
        model.EndTime = new TimeOnly(10, 0);

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.BookSessionAsync(1, model);

        Assert.IsFalse(result.Succeeded);
    }

    [TestMethod]
    public async Task BookSessionAsync_MentorConflict_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var date = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(3));
        ctx.Bookings.Add(new Booking
        {
            BookingId = 99,
            TraineeId = 999,
            MentorId = 2,
            LicenseTypeId = 1,
            BookingDate = date,
            StartTime = new TimeOnly(10, 0),
            EndTime = new TimeOnly(11, 0),
            Status = "confirmed",
            TraineeLicenseId = 1,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });
        ctx.SaveChanges();

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.BookSessionAsync(1, ValidBooking(date));

        Assert.IsFalse(result.Succeeded);
    }

    [TestMethod]
    public async Task BookSessionAsync_TraineeConflict_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var date = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(3));
        ctx.Bookings.Add(new Booking
        {
            BookingId = 99,
            TraineeId = 1,
            MentorId = 999,
            LicenseTypeId = 1,
            BookingDate = date,
            StartTime = new TimeOnly(10, 0),
            EndTime = new TimeOnly(11, 0),
            Status = "confirmed",
            TraineeLicenseId = 1,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });
        ctx.SaveChanges();

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.BookSessionAsync(1, ValidBooking(date));

        Assert.IsFalse(result.Succeeded);
    }

    [TestMethod]
    public async Task BookSessionAsync_BlockedDate_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var date = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(3));
        ctx.Admins.Add(new Admin { AdminId = 2 });
        ctx.BlockedDates.Add(new BlockedDate
        {
            BlockedDateId = 1,
            BlockedDate1 = date,
            Reason = "Holiday",
            BlockedBy = 2
        });
        ctx.SaveChanges();

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.BookSessionAsync(1, ValidBooking(date));

        Assert.IsFalse(result.Succeeded);
    }

    [TestMethod]
    public async Task BookSessionAsync_UnapprovedMentor_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        // Change application to pending
        ctx.MentorApplications.Single().Status = "pending";
        ctx.SaveChanges();

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.BookSessionAsync(1, ValidBooking());

        Assert.IsFalse(result.Succeeded);
    }

    // ─── CancelSession ────────────────────────────────────────────────────────

    [TestMethod]
    public async Task CancelSessionAsync_MoreThan24h_CancelsSuccessfully()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var futureDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(5));
        ctx.Bookings.Add(new Booking
        {
            BookingId = 1,
            TraineeId = 1,
            MentorId = 2,
            LicenseTypeId = 1,
            BookingDate = futureDate,
            StartTime = new TimeOnly(10, 0),
            EndTime = new TimeOnly(11, 0),
            Status = "confirmed",
            TraineeLicenseId = 1,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });
        ctx.SaveChanges();

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.CancelSessionAsync(traineeId: 1, bookingId: 1);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual("cancelled", ctx.Bookings.Single().Status);
    }

    [TestMethod]
    public async Task CancelSessionAsync_Within24h_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        // Session in 2 hours
        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        var start = TimeOnly.FromDateTime(DateTime.UtcNow.AddHours(2));
        var end = TimeOnly.FromDateTime(DateTime.UtcNow.AddHours(3));

        ctx.Bookings.Add(new Booking
        {
            BookingId = 1,
            TraineeId = 1,
            MentorId = 2,
            LicenseTypeId = 1,
            BookingDate = today,
            StartTime = start,
            EndTime = end,
            Status = "confirmed",
            TraineeLicenseId = 1,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });
        ctx.SaveChanges();

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.CancelSessionAsync(1, 1);

        Assert.IsFalse(result.Succeeded);
        Assert.AreEqual("confirmed", ctx.Bookings.Single().Status);
    }

    [TestMethod]
    public async Task CancelSessionAsync_WrongTrainee_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var futureDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(5));
        ctx.Bookings.Add(new Booking
        {
            BookingId = 1,
            TraineeId = 1,
            MentorId = 2,
            LicenseTypeId = 1,
            BookingDate = futureDate,
            StartTime = new TimeOnly(10, 0),
            EndTime = new TimeOnly(11, 0),
            Status = "confirmed",
            TraineeLicenseId = 1,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });
        ctx.SaveChanges();

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.CancelSessionAsync(traineeId: 99, bookingId: 1);

        Assert.IsFalse(result.Succeeded);
    }

    // ─── BrowseMentors ────────────────────────────────────────────────────────

    [TestMethod]
    public async Task BrowseMentorsAsync_ReturnsApprovedMentorsForLicenseType()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.BrowseMentorsAsync(1, new MentorBrowseFilterViewModel());

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(1, result.Data!.Mentors.Count);
        Assert.AreEqual("Ahmad Ali", result.Data.Mentors.Single().FullName);
    }

    [TestMethod]
    public async Task BrowseMentorsAsync_CityFilter_FiltersCorrectly()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.BrowseMentorsAsync(1, new MentorBrowseFilterViewModel { City = "Zarqa" });

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(0, result.Data!.Mentors.Count); // mentor is in Amman
    }

    // ─── GetMyBookings ────────────────────────────────────────────────────────

    [TestMethod]
    public async Task GetMyBookingsAsync_ReturnsAllTraineeBookings()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        ctx.Bookings.Add(new Booking
        {
            BookingId = 1,
            TraineeId = 1,
            MentorId = 2,
            LicenseTypeId = 1,
            BookingDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(3)),
            StartTime = new TimeOnly(10, 0),
            EndTime = new TimeOnly(11, 0),
            Status = "confirmed",
            TraineeLicenseId = 1,
            SessionType = "theoretical",
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });
        ctx.SaveChanges();

        var svc = new BookingService(ctx, MockNotif().Object);
        var result = await svc.GetMyBookingsAsync(traineeId: 1);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(1, result.Data!.Bookings.Count);
        Assert.IsTrue(result.Data.Bookings.Single().CanCancel);
    }
}
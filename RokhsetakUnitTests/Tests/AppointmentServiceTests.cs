using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Rokhsetak.Areas.Mentor.ViewModels.Appointments;
using Rokhsetak.Models;
using Rokhsetak.Services.Implementations;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Tests;

[TestClass]
public class AppointmentServiceTests
{
    private RokhsetakDbContext CreateContext()
    {
        var opts = new DbContextOptionsBuilder<RokhsetakDbContext>()
                .UseInMemoryDatabase(Guid.NewGuid().ToString())
                .ConfigureWarnings(w =>
                    w.Ignore(InMemoryEventId.TransactionIgnoredWarning))
                .Options;
        return new RokhsetakDbContext(opts);
    }

    private static Mock<INotificationService> MockNotif() => new();

    private static void SeedFull(RokhsetakDbContext ctx,
        string bookingStatus = "pending",
        DateOnly? bookingDate = null,
        TimeOnly? startTime = null,
        TimeOnly? endTime = null)
    {
        var date = bookingDate ?? DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1));
        var start = startTime ?? new TimeOnly(9, 0);
        var end = endTime ?? new TimeOnly(10, 0);
        if (!ctx.Provinces.Any())
        {
            ctx.Provinces.AddRange(
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
        if (!ctx.Cities.Any())
        {
            ctx.Cities.AddRange(
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
            UserId = 1,
            FirstName = "Ahmad",
            LastName = "Ali",
            Email = "ahmad@test.com",
            NationalId = "1234567890",
            ProvinceId = 1,
            CityId = 1,
            AddressLine1 = "St 1",
            PasswordHash = "hash",
            RoleId = 2
        });
        ctx.Mentors.Add(new Mentor { MentorId = 1 });

        ctx.Users.Add(new User
        {
            UserId = 2,
            FirstName = "Sara",
            LastName = "Salem",
            Email = "sara@test.com",
            NationalId = "0987654321",
            ProvinceId = 1,
            CityId = 1,
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
            BookingDate = date,
            StartTime = start,
            EndTime = end,
            Status = bookingStatus,
            SessionType = "theoretical",
            TraineeLicenseId = 1,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });

        ctx.SaveChanges();
    }

    // ─── ConfirmBooking ───────────────────────────────────────────────────────

    [TestMethod]
    public async Task ConfirmBookingAsync_Pending_ChangesToConfirmed()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "pending");

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.ConfirmBookingAsync(mentorId: 1, bookingId: 1);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual("confirmed", ctx.Bookings.Single().Status);
    }

    [TestMethod]
    public async Task ConfirmBookingAsync_WrongMentor_ReturnsUnauthorized()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "pending");

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.ConfirmBookingAsync(mentorId: 99, bookingId: 1);

        Assert.IsFalse(result.Succeeded);
        Assert.AreEqual("pending", ctx.Bookings.Single().Status);
    }

    [TestMethod]
    public async Task ConfirmBookingAsync_AlreadyConfirmed_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "confirmed");

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.ConfirmBookingAsync(mentorId: 1, bookingId: 1);

        Assert.IsFalse(result.Succeeded);
    }

    // ─── MarkAsDone ───────────────────────────────────────────────────────────

    [TestMethod]
    public async Task MarkAsDoneAsync_PastSession_ChangesToCompleted()
    {
        using var ctx = CreateContext();
        var yesterday = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(-1));
        SeedFull(ctx, "confirmed", yesterday, new TimeOnly(9, 0), new TimeOnly(10, 0));

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.MarkAsDoneAsync(mentorId: 1, bookingId: 1);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual("completed", ctx.Bookings.Single().Status);
    }

    [TestMethod]
    public async Task MarkAsDoneAsync_FutureSession_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "confirmed"); // default = tomorrow

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.MarkAsDoneAsync(mentorId: 1, bookingId: 1);

        Assert.IsFalse(result.Succeeded);
        Assert.AreEqual("confirmed", ctx.Bookings.Single().Status);
    }

    [TestMethod]
    public async Task MarkAsDoneAsync_PendingBooking_ReturnsFailure()
    {
        using var ctx = CreateContext();
        var yesterday = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(-1));
        SeedFull(ctx, "pending", yesterday);

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.MarkAsDoneAsync(mentorId: 1, bookingId: 1);

        Assert.IsFalse(result.Succeeded);
    }

    // ─── Reschedule ───────────────────────────────────────────────────────────

    [TestMethod]
    public async Task RescheduleAsync_ValidSlot_CancelsOldAndCreatesNew()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "pending");

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.RescheduleAsync(1, new RescheduleViewModel
        {
            BookingId = 1,
            NewDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(5)),
            NewStartTime = new TimeOnly(11, 0),
            NewEndTime = new TimeOnly(12, 0)
        });

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(2, ctx.Bookings.Count());
        Assert.AreEqual("cancelled", ctx.Bookings.Single(b => b.BookingId == 1).Status);
        Assert.AreEqual("confirmed", ctx.Bookings.Single(b => b.BookingId != 1).Status);
    }

    [TestMethod]
    public async Task RescheduleAsync_MentorConflict_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "pending");

        // Add a confirmed booking at the exact same new time
        var newDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(5));
        ctx.Bookings.Add(new Booking
        {
            BookingId = 2,
            TraineeId = 2,
            MentorId = 1,
            LicenseTypeId = 1,
            BookingDate = newDate,
            StartTime = new TimeOnly(11, 0),
            EndTime = new TimeOnly(12, 0),
            Status = "confirmed",
            TraineeLicenseId = 1,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });
        ctx.SaveChanges();

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.RescheduleAsync(1, new RescheduleViewModel
        {
            BookingId = 1,
            NewDate = newDate,
            NewStartTime = new TimeOnly(11, 0),
            NewEndTime = new TimeOnly(12, 0)
        });

        Assert.IsFalse(result.Succeeded);
        // Original booking must still be pending
        Assert.AreEqual("pending", ctx.Bookings.Single(b => b.BookingId == 1).Status);
    }

    [TestMethod]
    public async Task RescheduleAsync_StartAfterEnd_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "pending");

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.RescheduleAsync(1, new RescheduleViewModel
        {
            BookingId = 1,
            NewDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(3)),
            NewStartTime = new TimeOnly(14, 0),
            NewEndTime = new TimeOnly(12, 0)  // end < start
        });

        Assert.IsFalse(result.Succeeded);
    }

    [TestMethod]
    public async Task RescheduleAsync_BlockedDate_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "pending");

        var blockedDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(5));
        ctx.Users.First().RoleId = 1; // make user an admin for FK
        ctx.Admins.Add(new Admin { AdminId = 1 });
        ctx.BlockedDates.Add(new BlockedDate
        {
            BlockedDateId = 1,
            BlockedDate1 = blockedDate,
            Reason = "Holiday",
            BlockedBy = 1
        });
        ctx.SaveChanges();

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.RescheduleAsync(1, new RescheduleViewModel
        {
            BookingId = 1,
            NewDate = blockedDate,
            NewStartTime = new TimeOnly(9, 0),
            NewEndTime = new TimeOnly(10, 0)
        });

        Assert.IsFalse(result.Succeeded);
    }

    // ─── Feedback ─────────────────────────────────────────────────────────────

    [TestMethod]
    public async Task GiveFeedbackAsync_CompletedBooking_SavesFeedback()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "completed");

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.GiveFeedbackAsync(1, new FeedbackViewModel
        {
            BookingId = 1,
            MentorNotes = "Good session. Needs to work on mirror checks."
        });

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(1, ctx.SessionFeedbacks.Count());
        Assert.AreEqual("Good session. Needs to work on mirror checks.",
            ctx.SessionFeedbacks.Single().MentorNotes);
    }

    [TestMethod]
    public async Task GiveFeedbackAsync_DuplicateFeedback_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "completed");

        ctx.SessionFeedbacks.Add(new SessionFeedback
        {
            FeedbackId = 1,
            BookingId = 1,
            TraineeId = 2,
            MentorId = 1,
            MentorNotes = "First feedback"
        });
        ctx.SaveChanges();

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.GiveFeedbackAsync(1, new FeedbackViewModel
        {
            BookingId = 1,
            MentorNotes = "Second feedback attempt"
        });

        Assert.IsFalse(result.Succeeded);
        Assert.AreEqual(1, ctx.SessionFeedbacks.Count()); // no duplicate
    }

    [TestMethod]
    public async Task GiveFeedbackAsync_NotCompleted_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "confirmed");

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.GiveFeedbackAsync(1, new FeedbackViewModel
        {
            BookingId = 1,
            MentorNotes = "Notes"
        });

        Assert.IsFalse(result.Succeeded);
    }

    // ─── Trainee summary ──────────────────────────────────────────────────────

    [TestMethod]
    public async Task GetTraineeSummaryAsync_ReturnsTraineesWithBookings()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.GetTraineeSummaryAsync(mentorId: 1, null, null);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(1, result.Data!.Trainees.Count);
        Assert.AreEqual("Sara Salem", result.Data.Trainees.Single().FullName);
        Assert.AreEqual(1, result.Data.Trainees.Single().TotalSessions);
    }

    [TestMethod]
    public async Task GetTraineeSummaryAsync_SearchFilter_WorksCorrectly()
    {
        using var ctx = CreateContext();
        SeedFull(ctx);

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.GetTraineeSummaryAsync(1, "nonexistentname", null);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(0, result.Data!.Trainees.Count);
    }

    // ─── GetAllAppointments action flags ─────────────────────────────────────

    [TestMethod]
    public async Task GetAllAppointmentsAsync_PendingBooking_HasCorrectActionFlags()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "pending");

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.GetAllAppointmentsAsync(mentorId: 1);

        Assert.IsTrue(result.Succeeded);
        var item = result.Data!.Items.Single();
        Assert.IsTrue(item.CanConfirm);
        Assert.IsTrue(item.CanReschedule);
        Assert.IsFalse(item.CanMarkDone);
        Assert.IsFalse(item.CanFeedback);
    }

    [TestMethod]
    public async Task GetAllAppointmentsAsync_CompletedWithNoFeedback_CanFeedback()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, "completed");

        var svc = new AppointmentService(ctx, MockNotif().Object);
        var result = await svc.GetAllAppointmentsAsync(mentorId: 1);

        Assert.IsTrue(result.Succeeded);
        var item = result.Data!.Items.Single();
        Assert.IsTrue(item.CanFeedback);
        Assert.IsFalse(item.FeedbackGiven);
    }
}
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Rokhsetak.Areas.Trainee.ViewModels.Exam;
using Rokhsetak.Models;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Services.Implementations;

namespace Rokhsetak.Tests;

[TestClass]
public class ExamAppointmentServiceTests
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

    private static void SeedBase(RokhsetakDbContext ctx,
        string stage = "mock_exam_completed")
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
            Stage = stage,
            IsActive = true
        });

        ctx.GovExamCenters.Add(new GovExamCenter
        {
            CenterId = 1,
            Name = "Amman Test Center",
            Province = "Amman",
            City = "Amman",
            AddressLine1 = "St 1",
            IsActive = true
        });

        ctx.GovOfficialExams.Add(new GovOfficialExam
        {
            OfficialExamId = 1,
            CenterId = 1,
            LicenseTypeId = 1,
            ExamType = "theory",
            ExamDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(10)),
            ExamTime = new TimeOnly(9, 0),
            TotalSlots = 5,
            BookedSlots = 0,
            Status = "scheduled"
        });

        // All theoretical modules completed
        ctx.LearningModules.Add(new LearningModule
        {
            ModuleId = 1,
            LicenseTypeId = 1,
            Phase = "theoretical",
            OrderIndex = 1
        });
        ctx.TraineeModuleProgresses.Add(new TraineeModuleProgress
        {
            TraineeId = 1,
            ModuleId = 1,
            TraineeLicenseId = 1,
            Status = "completed",
            CompletedAt = DateTime.UtcNow
        });

        // Mock exam completed
        ctx.Quizzes.Add(new Quiz
        {
            QuizId = 99,
            IsMockExam = true,
            LicenseTypeId = 1,
            PassingScore = 70
        });
        ctx.QuizAttempts.Add(new QuizAttempt
        {
            AttemptId = 1,
            QuizId = 99,
            TraineeId = 1,
            TraineeLicenseId = 1,
            Score = 60,
            Passed = false,
            AttemptDate = DateTime.UtcNow
        });

        ctx.SaveChanges();
    }

    // ─── GetAvailableExams — eligibility ─────────────────────────────────────

    [TestMethod]
    public async Task GetAvailableExamsAsync_NotEligible_ModulesIncomplete()
    {
        using var ctx = CreateContext();
        SeedBase(ctx, "theoretical_prep");

        // Remove completed module progress
        ctx.TraineeModuleProgresses.Single().Status = "in_progress";
        ctx.SaveChanges();

        var svc = new ExamAppointmentService(ctx, MockNotif().Object);
        var result = await svc.GetAvailableExamsAsync(traineeId: 1, "theory");

        Assert.IsTrue(result.Succeeded);
        Assert.IsFalse(result.Data!.IsEligible);
    }

    [TestMethod]
    public async Task GetAvailableExamsAsync_Eligible_ReturnsSlots()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        var svc = new ExamAppointmentService(ctx, MockNotif().Object);
        var result = await svc.GetAvailableExamsAsync(1, "theory");

        Assert.IsTrue(result.Succeeded);
        Assert.IsTrue(result.Data!.IsEligible);
        Assert.AreEqual(1, result.Data.AvailableSlots.Count);
        Assert.AreEqual(5, result.Data.AvailableSlots.Single().SlotsRemaining);
    }

    [TestMethod]
    public async Task GetAvailableExamsAsync_NoMockExamAttempt_NotEligible()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        // Remove mock attempt
        ctx.QuizAttempts.RemoveRange(ctx.QuizAttempts);
        ctx.SaveChanges();

        var svc = new ExamAppointmentService(ctx, MockNotif().Object);
        var result = await svc.GetAvailableExamsAsync(1, "theory");

        Assert.IsTrue(result.Succeeded);
        Assert.IsFalse(result.Data!.IsEligible);
    }

    // ─── BookExam ─────────────────────────────────────────────────────────────

    [TestMethod]
    public async Task BookExamAsync_Eligible_CreatesAppointment()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        var svc = new ExamAppointmentService(ctx, MockNotif().Object);
        var result = await svc.BookExamAsync(1, new BookExamViewModel
        {
            OfficialExamId = 1,
            TraineeLicenseId = 1,
            ExamType = "theory"
        });

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(1, ctx.ExamAppointments.Count());
        Assert.AreEqual(1, ctx.GovOfficialExams.Single().BookedSlots);
        Assert.AreEqual("theory_test_pending", ctx.TraineeLicenses.Single().Stage);
    }

    [TestMethod]
    public async Task BookExamAsync_NoSlotsLeft_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        ctx.GovOfficialExams.Single().BookedSlots = 5; // all taken
        ctx.SaveChanges();

        var svc = new ExamAppointmentService(ctx, MockNotif().Object);
        var result = await svc.BookExamAsync(1, new BookExamViewModel
        {
            OfficialExamId = 1,
            TraineeLicenseId = 1,
            ExamType = "theory"
        });

        Assert.IsFalse(result.Succeeded);
    }

    [TestMethod]
    public async Task BookExamAsync_DuplicateBooking_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        // First booking
        ctx.ExamAppointments.Add(new ExamAppointment
        {
            ExamAppointmentId = 1,
            TraineeId = 1,
            OfficialExamId = 1,
            TraineeLicenseId = 1,
            Status = "scheduled",
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });
        ctx.GovOfficialExams.Single().BookedSlots = 1;
        ctx.SaveChanges();

        var svc = new ExamAppointmentService(ctx, MockNotif().Object);
        var result = await svc.BookExamAsync(1, new BookExamViewModel
        {
            OfficialExamId = 1,
            TraineeLicenseId = 1,
            ExamType = "theory"
        });

        Assert.IsFalse(result.Succeeded);
        Assert.AreEqual(1, ctx.ExamAppointments.Count()); // no duplicate
    }

    // ─── CancelExamAppointment ────────────────────────────────────────────────

    [TestMethod]
    public async Task CancelExamAppointmentAsync_FutureExam_CancelsAndDecrementsSlot()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        ctx.ExamAppointments.Add(new ExamAppointment
        {
            ExamAppointmentId = 1,
            TraineeId = 1,
            OfficialExamId = 1,
            TraineeLicenseId = 1,
            Status = "scheduled",
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });
        ctx.GovOfficialExams.Single().BookedSlots = 1;
        ctx.TraineeLicenses.Single().Stage = "theory_test_pending";
        ctx.SaveChanges();

        var svc = new ExamAppointmentService(ctx, MockNotif().Object);
        var result = await svc.CancelExamAppointmentAsync(1, 1);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual("cancelled", ctx.ExamAppointments.Single().Status);
        Assert.AreEqual(0, ctx.GovOfficialExams.Single().BookedSlots);
        Assert.AreEqual("mock_exam_completed", ctx.TraineeLicenses.Single().Stage); // reverted
    }

    [TestMethod]
    public async Task CancelExamAppointmentAsync_WrongTrainee_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        ctx.ExamAppointments.Add(new ExamAppointment
        {
            ExamAppointmentId = 1,
            TraineeId = 1,
            OfficialExamId = 1,
            TraineeLicenseId = 1,
            Status = "scheduled",
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });
        ctx.SaveChanges();

        var svc = new ExamAppointmentService(ctx, MockNotif().Object);
        var result = await svc.CancelExamAppointmentAsync(traineeId: 99, appointmentId: 1);

        Assert.IsFalse(result.Succeeded);
    }

    // ─── GetMyExamAppointments ────────────────────────────────────────────────

    [TestMethod]
    public async Task GetMyExamAppointmentsAsync_ReturnsAppointmentsWithCenterInfo()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        ctx.ExamAppointments.Add(new ExamAppointment
        {
            ExamAppointmentId = 1,
            TraineeId = 1,
            OfficialExamId = 1,
            TraineeLicenseId = 1,
            Status = "scheduled",
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });
        ctx.SaveChanges();

        var svc = new ExamAppointmentService(ctx, MockNotif().Object);
        var result = await svc.GetMyExamAppointmentsAsync(1);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(1, result.Data!.Appointments.Count);
        Assert.AreEqual("Amman Test Center", result.Data.Appointments.Single().CenterName);
        Assert.AreEqual("theory", result.Data.Appointments.Single().ExamType);
    }
}
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Rokhsetak.Models;
using Rokhsetak.Services.Implementations;
using Rokhsetak.Services.Interfaces;

namespace TestRo5setkom;

[TestClass]
public class ModuleServiceTests
{
    private Ro5setkomDbContext CreateContext()
    {
        var opts = new DbContextOptionsBuilder<Ro5setkomDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new Ro5setkomDbContext(opts);
    }

    private static Mock<INotificationService> MockNotif() => new();

    private static void SeedLicense(Ro5setkomDbContext ctx, int traineeId = 1, int licenseId = 1)
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
        ctx.Trainees.Add(new Trainee { TraineeId = traineeId });
        ctx.TraineeLicenses.Add(new TraineeLicense
        {
            TraineeLicenseId = licenseId,
            TraineeId = traineeId,
            LicenseTypeId = 1,
            Stage = "registered",
            IsActive = true
        });
        ctx.SaveChanges();
    }

    // Adds a module + EN/AR translations in one call
    private static void AddModule(Ro5setkomDbContext ctx,
        int moduleId, int licenseTypeId, string phase, int orderIndex,
        int? prerequisiteModuleId = null,
        string titleEn = "Module", string titleAr = "وحدة")
    {
        ctx.LearningModules.Add(new LearningModule
        {
            ModuleId = moduleId,
            LicenseTypeId = licenseTypeId,
            Phase = phase,
            OrderIndex = orderIndex,
            PrerequisiteModuleId = prerequisiteModuleId
        });
        ctx.ModuleTranslations.AddRange(
            new ModuleTranslation { ModuleId = moduleId, LanguageCode = "en", Title = titleEn },
            new ModuleTranslation { ModuleId = moduleId, LanguageCode = "ar", Title = titleAr }
        );
    }

    // Adds a quiz + EN/AR translations in one call
    private static void AddQuiz(Ro5setkomDbContext ctx,
        int quizId, int? moduleId, bool isMockExam, int? licenseTypeId = null,
        int passingScore = 70,
        string titleEn = "Quiz", string titleAr = "اختبار")
    {
        ctx.Quizzes.Add(new Quiz
        {
            QuizId = quizId,
            ModuleId = moduleId,
            IsMockExam = isMockExam,
            LicenseTypeId = licenseTypeId,
            PassingScore = passingScore
        });
        ctx.QuizTranslations.AddRange(
            new QuizTranslation { QuizId = quizId, LanguageCode = "en", Title = titleEn },
            new QuizTranslation { QuizId = quizId, LanguageCode = "ar", Title = titleAr }
        );
    }

    // ─── StartModule ─────────────────────────────────────────────────────────

    [TestMethod]
    public async Task StartModuleAsync_SetsStatusToInProgress()
    {
        using var ctx = CreateContext();
        SeedLicense(ctx);
        AddModule(ctx, moduleId: 1, licenseTypeId: 1, phase: "theoretical", orderIndex: 1, titleEn: "M1");
        ctx.SaveChanges();

        var svc = new ModuleService(ctx, MockNotif().Object);
        var result = await svc.StartModuleAsync(1, 1, 1);

        Assert.IsTrue(result.Succeeded);
        var prog = ctx.TraineeModuleProgresses.Single();
        Assert.AreEqual("in_progress", prog.Status);
    }

    [TestMethod]
    public async Task StartModuleAsync_AdvancesStage_WhenRegistered()
    {
        using var ctx = CreateContext();
        SeedLicense(ctx);
        AddModule(ctx, moduleId: 1, licenseTypeId: 1, phase: "theoretical", orderIndex: 1, titleEn: "M1");
        ctx.SaveChanges();

        var svc = new ModuleService(ctx, MockNotif().Object);
        await svc.StartModuleAsync(1, 1, 1);

        var license = ctx.TraineeLicenses.Single();
        Assert.AreEqual("theoretical_prep", license.Stage);
    }

    [TestMethod]
    public async Task StartModuleAsync_Idempotent_WhenAlreadyStarted()
    {
        using var ctx = CreateContext();
        SeedLicense(ctx);
        AddModule(ctx, moduleId: 1, licenseTypeId: 1, phase: "theoretical", orderIndex: 1, titleEn: "M1");
        ctx.TraineeModuleProgresses.Add(new TraineeModuleProgress
        {
            TraineeId = 1,
            ModuleId = 1,
            TraineeLicenseId = 1,
            Status = "in_progress"
        });
        ctx.SaveChanges();

        var svc = new ModuleService(ctx, MockNotif().Object);
        var result = await svc.StartModuleAsync(1, 1, 1);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(1, ctx.TraineeModuleProgresses.Count()); // no duplicate
    }

    // ─── CompleteModule ───────────────────────────────────────────────────────

    [TestMethod]
    public async Task CompleteModuleAsync_FailsWhenQuizExists()
    {
        using var ctx = CreateContext();
        SeedLicense(ctx);
        AddModule(ctx, moduleId: 1, licenseTypeId: 1, phase: "theoretical", orderIndex: 1, titleEn: "M1");
        AddQuiz(ctx, quizId: 1, moduleId: 1, isMockExam: false, titleEn: "Q1");
        ctx.TraineeModuleProgresses.Add(new TraineeModuleProgress
        {
            TraineeId = 1,
            ModuleId = 1,
            TraineeLicenseId = 1,
            Status = "in_progress"
        });
        ctx.SaveChanges();

        var svc = new ModuleService(ctx, MockNotif().Object);
        var result = await svc.CompleteModuleAsync(1, 1, 1);

        Assert.IsFalse(result.Succeeded);
    }

    [TestMethod]
    public async Task CompleteModuleAsync_Succeeds_WhenNoQuiz()
    {
        using var ctx = CreateContext();
        SeedLicense(ctx);
        AddModule(ctx, moduleId: 1, licenseTypeId: 1, phase: "theoretical", orderIndex: 1, titleEn: "M1");
        ctx.TraineeModuleProgresses.Add(new TraineeModuleProgress
        {
            TraineeId = 1,
            ModuleId = 1,
            TraineeLicenseId = 1,
            Status = "in_progress"
        });
        ctx.SaveChanges();

        var svc = new ModuleService(ctx, MockNotif().Object);
        var result = await svc.CompleteModuleAsync(1, 1, 1);

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual("completed", ctx.TraineeModuleProgresses.Single().Status);
    }

    [TestMethod]
    public async Task CompleteModuleAsync_UpdatesProgressPercentage()
    {
        using var ctx = CreateContext();
        SeedLicense(ctx);
        AddModule(ctx, moduleId: 1, licenseTypeId: 1, phase: "theoretical", orderIndex: 1, titleEn: "M1");
        AddModule(ctx, moduleId: 2, licenseTypeId: 1, phase: "theoretical", orderIndex: 2, titleEn: "M2");
        ctx.TraineeModuleProgresses.Add(new TraineeModuleProgress
        {
            TraineeId = 1,
            ModuleId = 1,
            TraineeLicenseId = 1,
            Status = "in_progress"
        });
        ctx.SaveChanges();

        var svc = new ModuleService(ctx, MockNotif().Object);
        await svc.CompleteModuleAsync(1, 1, 1);

        var license = ctx.TraineeLicenses.Single();
        Assert.AreEqual(50, license.ProgressPercentage);
    }
}
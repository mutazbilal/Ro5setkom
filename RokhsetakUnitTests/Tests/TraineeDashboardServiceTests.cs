using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rokhsetak.Models;
using Rokhsetak.Services.Implementations;

namespace Rokhsetak.Tests;

[TestClass]
public class TraineeDashboardServiceTests
{
    private RokhsetakDbContext CreateContext()
    {
        var options = new DbContextOptionsBuilder<RokhsetakDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new RokhsetakDbContext(options);
    }

    private static void SeedBase(RokhsetakDbContext ctx,
        int traineeId = 1, int licenseTypeId = 1)
    {
        ctx.LicenseTypes.Add(new LicenseType
        {
            LicenseTypeId = licenseTypeId,
            LicenseName = "private_manual",
            DisplayNameEn = "Private Car (Manual)",
            DisplayNameAr = "سيارة خاصة (يدوي)",
            DescriptionEn = "Private car with manual transmission",
            DescriptionAr = "سيارة خاصة ذات ناقل حركة يدوي"
        });

        ctx.Trainees.Add(new Trainee { TraineeId = traineeId });

        ctx.TraineeLicenses.Add(new TraineeLicense
        {
            TraineeLicenseId = 1,
            TraineeId = traineeId,
            LicenseTypeId = licenseTypeId,
            Stage = "theoretical_prep",
            IsActive = true
        });

        ctx.SaveChanges();
    }

    // Adds a module + its EN/AR translations in one call
    private static void AddModule(RokhsetakDbContext ctx,
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
            new ModuleTranslation
            {
                ModuleId = moduleId,
                LanguageCode = "en",
                Title = titleEn,
                Description = null
            },
            new ModuleTranslation
            {
                ModuleId = moduleId,
                LanguageCode = "ar",
                Title = titleAr,
                Description = null
            }
        );
    }

    // Adds a quiz + its EN/AR translations in one call
    private static void AddQuiz(RokhsetakDbContext ctx,
        int quizId, bool isMockExam, int? licenseTypeId, int? moduleId,
        int passingScore = 70,
        string titleEn = "Quiz", string titleAr = "اختبار")
    {
        ctx.Quizzes.Add(new Quiz
        {
            QuizId = quizId,
            IsMockExam = isMockExam,
            LicenseTypeId = licenseTypeId,
            ModuleId = moduleId,
            PassingScore = passingScore
        });

        ctx.QuizTranslations.AddRange(
            new QuizTranslation { QuizId = quizId, LanguageCode = "en", Title = titleEn },
            new QuizTranslation { QuizId = quizId, LanguageCode = "ar", Title = titleAr }
        );
    }

    // ─────────────────────────────────────────────────────────────────────

    [TestMethod]
    public async Task GetDashboardAsync_NoActiveLicense_ReturnsFailure()
    {
        using var ctx = CreateContext();
        var svc = new TraineeDashboardService(ctx);

        var result = await svc.GetDashboardAsync(traineeId: 99, culture: "en");

        Assert.IsFalse(result.Succeeded);
        Assert.IsNotNull(result.Error);
    }

    [TestMethod]
    public async Task GetDashboardAsync_WithLicense_NoModules_ReturnsZeroPercent()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        var svc = new TraineeDashboardService(ctx);
        var result = await svc.GetDashboardAsync(traineeId: 1, culture: "en");

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(0, result.Data!.OverallProgressPercentage);
    }

    [TestMethod]
    public async Task GetDashboardAsync_WithModules_CalculatesProgressCorrectly()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        AddModule(ctx, moduleId: 1, licenseTypeId: 1, phase: "theoretical", orderIndex: 1, titleEn: "M1");
        AddModule(ctx, moduleId: 2, licenseTypeId: 1, phase: "theoretical", orderIndex: 2, titleEn: "M2");

        ctx.TraineeModuleProgresses.Add(new TraineeModuleProgress
        {
            TraineeId = 1,
            ModuleId = 1,
            TraineeLicenseId = 1,
            Status = "completed",
            CompletedAt = DateTime.UtcNow
        });

        ctx.SaveChanges();

        var svc = new TraineeDashboardService(ctx);
        var result = await svc.GetDashboardAsync(traineeId: 1, culture: "en");

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(50, result.Data!.OverallProgressPercentage);
    }

    [TestMethod]
    public async Task GetDashboardAsync_LockedModule_MarkedCorrectly()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        AddModule(ctx, moduleId: 1, licenseTypeId: 1, phase: "theoretical", orderIndex: 1, titleEn: "M1");
        AddModule(ctx, moduleId: 2, licenseTypeId: 1, phase: "theoretical", orderIndex: 2,
            prerequisiteModuleId: 1, titleEn: "M2");

        ctx.SaveChanges();

        var svc = new TraineeDashboardService(ctx);
        var result = await svc.GetDashboardAsync(traineeId: 1, culture: "en");

        Assert.IsTrue(result.Succeeded);
        var m2 = result.Data!.TheoreticalModules.Single(m => m.ModuleId == 2);
        Assert.IsTrue(m2.IsLocked);
    }

    [TestMethod]
    public async Task GetDashboardAsync_MockExamAvailable_WhenAllTheoreticalComplete()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        AddModule(ctx, moduleId: 1, licenseTypeId: 1, phase: "theoretical", orderIndex: 1, titleEn: "M1");
        AddQuiz(ctx, quizId: 99, isMockExam: true, licenseTypeId: 1, moduleId: null, titleEn: "Mock");

        ctx.TraineeModuleProgresses.Add(new TraineeModuleProgress
        {
            TraineeId = 1,
            ModuleId = 1,
            TraineeLicenseId = 1,
            Status = "completed",
            CompletedAt = DateTime.UtcNow
        });

        ctx.SaveChanges();

        var svc = new TraineeDashboardService(ctx);
        var result = await svc.GetDashboardAsync(traineeId: 1, culture: "en");

        Assert.IsTrue(result.Succeeded);
        Assert.IsTrue(result.Data!.IsMockExamAvailable);
        Assert.IsFalse(result.Data.IsMockExamCompleted);
    }

    [TestMethod]
    public async Task GetDashboardAsync_ArabicCulture_ReturnsTitlesInArabic()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        AddModule(ctx, moduleId: 1, licenseTypeId: 1, phase: "theoretical", orderIndex: 1,
            titleEn: "Introduction", titleAr: "مقدمة");

        ctx.SaveChanges();

        var svc = new TraineeDashboardService(ctx);
        var result = await svc.GetDashboardAsync(traineeId: 1, culture: "ar");

        Assert.IsTrue(result.Succeeded);
        var m1 = result.Data!.TheoreticalModules.Single(m => m.ModuleId == 1);
        Assert.AreEqual("مقدمة", m1.Title);
    }

    [TestMethod]
    public async Task GetDashboardAsync_MissingCultureTranslation_FallsBackToEnglish()
    {
        using var ctx = CreateContext();
        SeedBase(ctx);

        // Only seed EN translation — no AR
        ctx.LearningModules.Add(new LearningModule
        {
            ModuleId = 1,
            LicenseTypeId = 1,
            Phase = "theoretical",
            OrderIndex = 1
        });
        ctx.ModuleTranslations.Add(new ModuleTranslation
        {
            ModuleId = 1,
            LanguageCode = "en",
            Title = "English Only"
        });

        ctx.SaveChanges();

        var svc = new TraineeDashboardService(ctx);
        var result = await svc.GetDashboardAsync(traineeId: 1, culture: "ar");

        Assert.IsTrue(result.Succeeded);
        var m1 = result.Data!.TheoreticalModules.Single(m => m.ModuleId == 1);
        Assert.AreEqual("English Only", m1.Title);
    }
}
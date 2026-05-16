using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Rokhsetak.Areas.Trainee.ViewModels.Quiz;
using Rokhsetak.Models;
using Rokhsetak.Services.Implementations;
using Rokhsetak.Services.Interfaces;

namespace TestRo5setkom;

[TestClass]
public class QuizServiceTests
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
        bool addQuiz = true, bool addMockQuiz = false)
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

        ctx.Trainees.Add(new Trainee { TraineeId = 1 });

        ctx.TraineeLicenses.Add(new TraineeLicense
        {
            TraineeLicenseId = 1,
            TraineeId = 1,
            LicenseTypeId = 1,
            Stage = "theoretical_prep",
            IsActive = true
        });

        ctx.LearningModules.Add(new LearningModule
        {
            ModuleId = 1,
            LicenseTypeId = 1,
            Phase = "theoretical",
            OrderIndex = 1
        });
        ctx.ModuleTranslations.AddRange(
            new ModuleTranslation { ModuleId = 1, LanguageCode = "en", Title = "M1" },
            new ModuleTranslation { ModuleId = 1, LanguageCode = "ar", Title = "م1" }
        );

        ctx.TraineeModuleProgresses.Add(new TraineeModuleProgress
        {
            TraineeId = 1,
            ModuleId = 1,
            TraineeLicenseId = 1,
            Status = "in_progress"
        });

        if (addQuiz)
        {
            ctx.Quizzes.Add(new Quiz
            {
                QuizId = 1,
                ModuleId = 1,
                IsMockExam = false,
                PassingScore = 50
            });
            ctx.QuizTranslations.AddRange(
                new QuizTranslation { QuizId = 1, LanguageCode = "en", Title = "M1 Quiz" },
                new QuizTranslation { QuizId = 1, LanguageCode = "ar", Title = "اختبار م1" }
            );

            ctx.QuizQuestions.Add(new QuizQuestion { QuestionId = 1, QuizId = 1 });
            ctx.QuestionTranslations.AddRange(
                new QuestionTranslation { QuestionId = 1, LanguageCode = "en", QuestionText = "Q1?" },
                new QuestionTranslation { QuestionId = 1, LanguageCode = "ar", QuestionText = "س1؟" }
            );

            ctx.QuestionOptions.AddRange(
                new QuestionOption { OptionId = 1, QuestionId = 1, IsCorrect = true },
                new QuestionOption { OptionId = 2, QuestionId = 1, IsCorrect = false }
            );
            ctx.OptionTranslations.AddRange(
                new OptionTranslation { OptionId = 1, LanguageCode = "en", OptionText = "Correct" },
                new OptionTranslation { OptionId = 1, LanguageCode = "ar", OptionText = "صحيح" },
                new OptionTranslation { OptionId = 2, LanguageCode = "en", OptionText = "Wrong" },
                new OptionTranslation { OptionId = 2, LanguageCode = "ar", OptionText = "خطأ" }
            );
        }

        if (addMockQuiz)
        {
            ctx.Quizzes.Add(new Quiz
            {
                QuizId = 99,
                IsMockExam = true,
                LicenseTypeId = 1,
                PassingScore = 70
            });
            ctx.QuizTranslations.AddRange(
                new QuizTranslation { QuizId = 99, LanguageCode = "en", Title = "Mock Exam" },
                new QuizTranslation { QuizId = 99, LanguageCode = "ar", Title = "الاختبار التجريبي" }
            );

            ctx.QuizQuestions.Add(new QuizQuestion { QuestionId = 10, QuizId = 99 });
            ctx.QuestionTranslations.AddRange(
                new QuestionTranslation { QuestionId = 10, LanguageCode = "en", QuestionText = "Mock Q?" },
                new QuestionTranslation { QuestionId = 10, LanguageCode = "ar", QuestionText = "سؤال تجريبي؟" }
            );

            ctx.QuestionOptions.AddRange(
                new QuestionOption { OptionId = 10, QuestionId = 10, IsCorrect = true },
                new QuestionOption { OptionId = 11, QuestionId = 10, IsCorrect = false }
            );
            ctx.OptionTranslations.AddRange(
                new OptionTranslation { OptionId = 10, LanguageCode = "en", OptionText = "Yes" },
                new OptionTranslation { OptionId = 10, LanguageCode = "ar", OptionText = "نعم" },
                new OptionTranslation { OptionId = 11, LanguageCode = "en", OptionText = "No" },
                new OptionTranslation { OptionId = 11, LanguageCode = "ar", OptionText = "لا" }
            );
        }

        ctx.SaveChanges();
    }

    // ─── GetModuleQuiz ────────────────────────────────────────────────────────

    [TestMethod]
    public async Task GetModuleQuizAsync_NotStarted_ReturnsFailure()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, addQuiz: true);
        ctx.TraineeModuleProgresses.Single().Status = "not_started";
        ctx.SaveChanges();

        var svc = new QuizService(ctx, MockNotif().Object);
        var result = await svc.GetModuleQuizAsync(1, 1, 1, culture: "en");

        Assert.IsFalse(result.Succeeded);
    }

    [TestMethod]
    public async Task GetModuleQuizAsync_InProgress_ReturnsQuiz()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, addQuiz: true);

        var svc = new QuizService(ctx, MockNotif().Object);
        var result = await svc.GetModuleQuizAsync(1, 1, 1, culture: "en");

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual(1, result.Data!.Questions.Count);
    }

    [TestMethod]
    public async Task GetModuleQuizAsync_ArabicCulture_ReturnsArabicText()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, addQuiz: true);

        var svc = new QuizService(ctx, MockNotif().Object);
        var result = await svc.GetModuleQuizAsync(1, 1, 1, culture: "ar");

        Assert.IsTrue(result.Succeeded);
        Assert.AreEqual("اختبار م1", result.Data!.Title);
        Assert.AreEqual("س1؟", result.Data.Questions.Single().QuestionText);
        Assert.IsTrue(result.Data.Questions.Single().Options.Any(o => o.OptionText == "صحيح"));
    }

    // ─── SubmitModuleQuiz ─────────────────────────────────────────────────────

    [TestMethod]
    public async Task SubmitModuleQuizAsync_CorrectAnswer_Passes_And_CompletesModule()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, addQuiz: true);

        var svc = new QuizService(ctx, MockNotif().Object);
        var submit = new SubmitQuizViewModel
        {
            QuizId = 1,
            TraineeLicenseId = 1,
            ModuleId = 1,
            Answers = new Dictionary<int, int> { { 1, 1 } } // correct option
        };

        var result = await svc.SubmitModuleQuizAsync(1, 1, submit, culture: "en");

        Assert.IsTrue(result.Succeeded);
        Assert.IsTrue(result.Data!.Passed);
        Assert.AreEqual(100, result.Data.Score);
        Assert.AreEqual("completed", ctx.TraineeModuleProgresses.Single().Status);
    }

    [TestMethod]
    public async Task SubmitModuleQuizAsync_WrongAnswer_Fails_ModuleStaysInProgress()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, addQuiz: true);

        var svc = new QuizService(ctx, MockNotif().Object);
        var submit = new SubmitQuizViewModel
        {
            QuizId = 1,
            TraineeLicenseId = 1,
            ModuleId = 1,
            Answers = new Dictionary<int, int> { { 1, 2 } } // wrong option
        };

        var result = await svc.SubmitModuleQuizAsync(1, 1, submit, culture: "en");

        Assert.IsTrue(result.Succeeded);
        Assert.IsFalse(result.Data!.Passed);
        Assert.AreEqual("in_progress", ctx.TraineeModuleProgresses.Single().Status);
    }

    [TestMethod]
    public async Task SubmitModuleQuizAsync_AttemptIsAlwaysRecorded()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, addQuiz: true);

        var svc = new QuizService(ctx, MockNotif().Object);

        for (int i = 0; i < 2; i++)
        {
            await svc.SubmitModuleQuizAsync(1, 1, new SubmitQuizViewModel
            {
                QuizId = 1,
                TraineeLicenseId = 1,
                ModuleId = 1,
                Answers = new Dictionary<int, int> { { 1, 2 } }
            }, culture: "en");
        }

        Assert.AreEqual(2, ctx.QuizAttempts.Count());
    }

    [TestMethod]
    public async Task SubmitModuleQuizAsync_ResultContainsTranslatedOptionText()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, addQuiz: true);

        var svc = new QuizService(ctx, MockNotif().Object);
        var result = await svc.SubmitModuleQuizAsync(1, 1, new SubmitQuizViewModel
        {
            QuizId = 1,
            TraineeLicenseId = 1,
            ModuleId = 1,
            Answers = new Dictionary<int, int> { { 1, 1 } }
        }, culture: "ar");

        var q = result.Data!.Questions.Single();
        Assert.AreEqual("صحيح", q.CorrectOption);
        Assert.AreEqual("صحيح", q.SelectedOption);
    }

    // ─── MockExam ─────────────────────────────────────────────────────────────

    [TestMethod]
    public async Task SubmitMockExamAsync_AdvancesStageToMockExamCompleted()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, addQuiz: false, addMockQuiz: true);

        ctx.TraineeModuleProgresses.Single().Status = "completed";
        ctx.SaveChanges();

        var svc = new QuizService(ctx, MockNotif().Object);
        var submit = new SubmitQuizViewModel
        {
            QuizId = 99,
            TraineeLicenseId = 1,
            Answers = new Dictionary<int, int> { { 10, 10 } }
        };

        var result = await svc.SubmitMockExamAsync(1, 1, submit, culture: "en");

        Assert.IsTrue(result.Succeeded);
        Assert.IsTrue(result.Data!.IsMockExam);
        Assert.AreEqual("mock_exam_completed", ctx.TraineeLicenses.Single().Stage);
    }

    [TestMethod]
    public async Task SubmitMockExamAsync_RecordsAttemptEvenWhenFailed()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, addQuiz: false, addMockQuiz: true);

        var svc = new QuizService(ctx, MockNotif().Object);
        await svc.SubmitMockExamAsync(1, 1, new SubmitQuizViewModel
        {
            QuizId = 99,
            TraineeLicenseId = 1,
            Answers = new Dictionary<int, int> { { 10, 11 } } // wrong → fail
        }, culture: "en");

        Assert.AreEqual(1, ctx.QuizAttempts.Count());
        Assert.AreEqual("mock_exam_completed", ctx.TraineeLicenses.Single().Stage);
    }

    // ─── Result breakdown ─────────────────────────────────────────────────────

    [TestMethod]
    public async Task SubmitModuleQuizAsync_ResultContainsCorrectAndIncorrectBreakdown()
    {
        using var ctx = CreateContext();
        SeedFull(ctx, addQuiz: true);

        var svc = new QuizService(ctx, MockNotif().Object);
        var result = await svc.SubmitModuleQuizAsync(1, 1, new SubmitQuizViewModel
        {
            QuizId = 1,
            TraineeLicenseId = 1,
            ModuleId = 1,
            Answers = new Dictionary<int, int> { { 1, 1 } }
        }, culture: "en");

        Assert.AreEqual(1, result.Data!.CorrectCount);
        Assert.AreEqual(0, result.Data.IncorrectCount);
        Assert.IsTrue(result.Data.Questions.Single().IsCorrect);
    }
}
using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Trainee.ViewModels.Quiz;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations;

public class QuizService : IQuizService
{
    private const int MockExamTimeLimitMinutes = 45;

    private readonly Ro5setkomDbContext _context;
    private readonly INotificationService _notifications;

    public QuizService(Ro5setkomDbContext context, INotificationService notifications)
    {
        _context = context;
        _notifications = notifications;
    }

    // ─────────────────────────────────────────────────────────────────────
    // GET MODULE QUIZ
    // ─────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<QuizViewModel>> GetModuleQuizAsync(
        int traineeId, int traineeLicenseId, int moduleId, string culture)
    {
        var progress = await _context.TraineeModuleProgresses
            .FirstOrDefaultAsync(p => p.TraineeId == traineeId
                                   && p.ModuleId == moduleId
                                   && p.TraineeLicenseId == traineeLicenseId);

        if (progress == null || progress.Status == "not_started")
            return ServiceResult<QuizViewModel>.Failure("Start the module before taking the quiz.");

        var quiz = await LoadQuizWithTranslationsAsync(
            q => q.ModuleId == moduleId && q.IsMockExam == false);

        if (quiz == null)
            return ServiceResult<QuizViewModel>.Failure("No quiz found for this module.");

        var vm = MapToQuizViewModel(quiz, moduleId, traineeLicenseId, isMockExam: false, culture);
        return ServiceResult<QuizViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────
    // SUBMIT MODULE QUIZ
    // ─────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<QuizResultViewModel>> SubmitModuleQuizAsync(
        int traineeId, int traineeLicenseId, SubmitQuizViewModel model, string culture)
    {
        var quiz = await LoadQuizWithTranslationsAsync(
            q => q.QuizId == model.QuizId && q.IsMockExam == false);

        if (quiz == null)
            return ServiceResult<QuizResultViewModel>.Failure("Quiz not found.");

        var progress = await _context.TraineeModuleProgresses
            .FirstOrDefaultAsync(p => p.TraineeId == traineeId
                                   && p.ModuleId == quiz.ModuleId
                                   && p.TraineeLicenseId == traineeLicenseId);

        if (progress == null || progress.Status == "not_started")
            return ServiceResult<QuizResultViewModel>.Failure("Module must be started before taking the quiz.");

        var (score, passed, resultQuestions) = GradeQuiz(quiz, model.Answers, culture);

        await using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            _context.QuizAttempts.Add(new QuizAttempt
            {
                QuizId = quiz.QuizId,
                TraineeId = traineeId,
                TraineeLicenseId = traineeLicenseId,
                Score = score,
                Passed = passed,
                AttemptDate = DateTime.UtcNow
            });

            if (passed && progress.Status != "completed")
            {
                progress.Status = "completed";
                progress.CompletedAt = DateTime.UtcNow;

                await UpdateLicenseProgressAsync(traineeId, traineeLicenseId);
            }

            await _context.SaveChangesAsync();
            await transaction.CommitAsync();
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }

        if (passed)
        {
            await _notifications.CreateAsync(traineeId,
                "Module Completed",
                "You passed the quiz and completed the module!",
                "quiz");
        }

        var result = new QuizResultViewModel
        {
            QuizId = quiz.QuizId,
            ModuleId = quiz.ModuleId ?? 0,
            TraineeLicenseId = traineeLicenseId,
            Title = GetTranslated(quiz.QuizTranslations, culture, t => t.Title),
            IsMockExam = false,
            Score = score,
            TotalQuestions = quiz.QuizQuestions.Count,
            PassingScore = quiz.PassingScore,
            Passed = passed,
            CorrectCount = resultQuestions.Count(q => q.IsCorrect),
            IncorrectCount = resultQuestions.Count(q => !q.IsCorrect),
            Questions = resultQuestions
        };

        return ServiceResult<QuizResultViewModel>.Success(result);
    }

    // ─────────────────────────────────────────────────────────────────────
    // GET MOCK EXAM
    // ─────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<QuizViewModel>> GetMockExamAsync(
        int traineeId, int traineeLicenseId, string culture)
    {
        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeLicenseId == traineeLicenseId
                                    && tl.TraineeId == traineeId
                                    && tl.IsActive);

        if (license == null)
            return ServiceResult<QuizViewModel>.Failure("License not found.");

        var theoreticalModuleIds = await _context.LearningModules
            .Where(m => m.LicenseTypeId == license.LicenseTypeId && m.Phase == "theoretical")
            .Select(m => m.ModuleId)
            .ToListAsync();

        var completedTheoryCount = await _context.TraineeModuleProgresses
            .CountAsync(p => p.TraineeId == traineeId
                          && p.TraineeLicenseId == traineeLicenseId
                          && theoreticalModuleIds.Contains(p.ModuleId)
                          && p.Status == "completed");

        if (completedTheoryCount < theoreticalModuleIds.Count)
            return ServiceResult<QuizViewModel>.Failure("Complete all theoretical modules before taking the mock exam.");

        var mockQuiz = await LoadQuizWithTranslationsAsync(
            q => q.IsMockExam == true && q.LicenseTypeId == license.LicenseTypeId);

        if (mockQuiz == null)
            return ServiceResult<QuizViewModel>.Failure("No mock exam found for this license type.");

        // Shuffle questions
        mockQuiz.QuizQuestions = mockQuiz.QuizQuestions.OrderBy(_ => Random.Shared.Next()).ToList();

        var vm = MapToQuizViewModel(mockQuiz, 0, traineeLicenseId, isMockExam: true, culture);
        vm.TimeLimitMinutes = MockExamTimeLimitMinutes;

        return ServiceResult<QuizViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────
    // SUBMIT MOCK EXAM
    // ─────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<QuizResultViewModel>> SubmitMockExamAsync(
        int traineeId, int traineeLicenseId, SubmitQuizViewModel model, string culture)
    {
        var quiz = await LoadQuizWithTranslationsAsync(
            q => q.QuizId == model.QuizId && q.IsMockExam == true);

        if (quiz == null)
            return ServiceResult<QuizResultViewModel>.Failure("Mock exam not found.");

        var (score, passed, resultQuestions) = GradeQuiz(quiz, model.Answers, culture);

        await using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            _context.QuizAttempts.Add(new QuizAttempt
            {
                QuizId = quiz.QuizId,
                TraineeId = traineeId,
                TraineeLicenseId = traineeLicenseId,
                Score = score,
                Passed = passed,
                AttemptDate = DateTime.UtcNow
            });

            var license = await _context.TraineeLicenses
                .FirstOrDefaultAsync(tl => tl.TraineeLicenseId == traineeLicenseId && tl.IsActive);

            if (license != null && license.Stage == "theoretical_prep")
            {
                license.Stage = "mock_exam_completed";
                license.UpdatedAt = DateTime.UtcNow;
            }

            await _context.SaveChangesAsync();
            await transaction.CommitAsync();
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }

        await _notifications.CreateAsync(traineeId,
            "Mock Exam Completed",
            passed
                ? $"You passed the mock exam with {score}%! You can now book your theory test."
                : $"Mock exam completed with {score}%. You can retake it or proceed to book the theory test.",
            "quiz");

        var result = new QuizResultViewModel
        {
            QuizId = quiz.QuizId,
            ModuleId = 0,
            TraineeLicenseId = traineeLicenseId,
            Title = GetTranslated(quiz.QuizTranslations, culture, t => t.Title),
            IsMockExam = true,
            Score = score,
            TotalQuestions = quiz.QuizQuestions.Count,
            PassingScore = quiz.PassingScore,
            Passed = passed,
            CorrectCount = resultQuestions.Count(q => q.IsCorrect),
            IncorrectCount = resultQuestions.Count(q => !q.IsCorrect),
            Questions = resultQuestions
        };

        return ServiceResult<QuizResultViewModel>.Success(result);
    }

    // ─────────────────────────────────────────────────────────────────────
    // PRIVATE HELPERS
    // ─────────────────────────────────────────────────────────────────────

    /// <summary>
    /// Single place that loads a quiz with all translation navigations included.
    /// Every public method uses this so no Include chain is ever duplicated.
    /// </summary>
    private Task<Quiz?> LoadQuizWithTranslationsAsync(
        System.Linq.Expressions.Expression<Func<Quiz, bool>> predicate)
    {
        return _context.Quizzes
            .Include(q => q.QuizTranslations)
            .Include(q => q.QuizQuestions)
                .ThenInclude(qq => qq.QuestionTranslations)
            .Include(q => q.QuizQuestions)
                .ThenInclude(qq => qq.QuestionOptions)
                    .ThenInclude(o => o.OptionTranslations)
            .FirstOrDefaultAsync(predicate);
    }

    /// <summary>
    /// Picks the translated string for the requested culture,
    /// falling back to 'en' if unavailable.
    /// </summary>
    private static string GetTranslated<T>(
        IEnumerable<T> translations,
        string culture,
        Func<T, string> selector) where T : class
    {
        // Try requested culture first, then fall back to 'en'
        var match = translations.FirstOrDefault(t =>
        {
            var prop = typeof(T).GetProperty("LanguageCode");
            return prop?.GetValue(t)?.ToString() == culture;
        }) ?? translations.FirstOrDefault(t =>
        {
            var prop = typeof(T).GetProperty("LanguageCode");
            return prop?.GetValue(t)?.ToString() == "en";
        });

        return match != null ? selector(match) : string.Empty;
    }

    private static QuizViewModel MapToQuizViewModel(
        Quiz quiz, int moduleId, int traineeLicenseId, bool isMockExam, string culture)
    {
        return new QuizViewModel
        {
            QuizId = quiz.QuizId,
            ModuleId = moduleId,
            TraineeLicenseId = traineeLicenseId,
            Title = GetTranslated(quiz.QuizTranslations, culture, t => t.Title),
            IsMockExam = isMockExam,
            PassingScore = quiz.PassingScore,
            Questions = quiz.QuizQuestions.Select(q => new QuizQuestionViewModel
            {
                QuestionId = q.QuestionId,
                QuestionText = GetTranslated(q.QuestionTranslations, culture, t => t.QuestionText),
                Options = q.QuestionOptions.Select(o => new QuestionOptionViewModel
                {
                    OptionId = o.OptionId,
                    OptionText = GetTranslated(o.OptionTranslations, culture, t => t.OptionText)
                }).ToList()
            }).ToList()
        };
    }

    private static (int score, bool passed, List<QuizResultQuestionViewModel> questions) GradeQuiz(
        Quiz quiz, Dictionary<int, int> answers, string culture)
    {
        var resultQuestions = new List<QuizResultQuestionViewModel>();
        int correctCount = 0;

        foreach (var q in quiz.QuizQuestions)
        {
            var correctOption = q.QuestionOptions.FirstOrDefault(o => o.IsCorrect);
            answers.TryGetValue(q.QuestionId, out int selectedOptionId);
            bool isCorrect = correctOption != null && correctOption.OptionId == selectedOptionId;

            if (isCorrect) correctCount++;

            resultQuestions.Add(new QuizResultQuestionViewModel
            {
                QuestionText = GetTranslated(q.QuestionTranslations, culture, t => t.QuestionText),
                IsCorrect = isCorrect,
                SelectedOption = q.QuestionOptions
                    .Where(o => o.OptionId == selectedOptionId)
                    .Select(o => GetTranslated(o.OptionTranslations, culture, t => t.OptionText))
                    .FirstOrDefault() ?? "—",
                CorrectOption = correctOption != null
                    ? GetTranslated(correctOption.OptionTranslations, culture, t => t.OptionText)
                    : "—",
                Options = q.QuestionOptions.Select(o => new QuizResultOptionViewModel
                {
                    OptionId = o.OptionId,
                    OptionText = GetTranslated(o.OptionTranslations, culture, t => t.OptionText),
                    IsCorrect = o.IsCorrect,
                    WasSelected = o.OptionId == selectedOptionId
                }).ToList()
            });
        }

        int total = quiz.QuizQuestions.Count;
        int score = total == 0 ? 0 : (int)Math.Round((double)correctCount / total * 100);
        bool passed = score >= quiz.PassingScore;

        return (score, passed, resultQuestions);
    }

    private async Task UpdateLicenseProgressAsync(int traineeId, int traineeLicenseId)
    {
        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeLicenseId == traineeLicenseId && tl.IsActive);

        if (license == null) return;

        int total = await _context.LearningModules
            .CountAsync(m => m.LicenseTypeId == license.LicenseTypeId);

        int completed = await _context.TraineeModuleProgresses
            .CountAsync(p => p.TraineeId == traineeId
                          && p.TraineeLicenseId == traineeLicenseId
                          && p.Status == "completed");

        license.ProgressPercentage = total == 0 ? 0 : (int)Math.Round((double)completed / total * 100);
        license.UpdatedAt = DateTime.UtcNow;
    }
}
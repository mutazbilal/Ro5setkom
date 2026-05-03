using Microsoft.EntityFrameworkCore;
using ro5setkom.Areas.Trainee.ViewModels.Quiz;
using ro5setkom.Models;
using ro5setkom.Services.Common;
using ro5setkom.Services.Interfaces;

namespace ro5setkom.Services.Implementations;

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
        int traineeId, int traineeLicenseId, int moduleId)
    {
        // Module must not be not_started
        var progress = await _context.TraineeModuleProgresses
            .FirstOrDefaultAsync(p => p.TraineeId == traineeId
                                   && p.ModuleId == moduleId
                                   && p.TraineeLicenseId == traineeLicenseId);

        if (progress == null || progress.Status == "not_started")
            return ServiceResult<QuizViewModel>.Failure("Start the module before taking the quiz.");

        var quiz = await _context.Quizzes
            .Include(q => q.QuizQuestions)
                .ThenInclude(qq => qq.QuestionOptions)
            .FirstOrDefaultAsync(q => q.ModuleId == moduleId && q.IsMockExam == false);

        if (quiz == null)
            return ServiceResult<QuizViewModel>.Failure("No quiz found for this module.");

        var vm = MapToQuizViewModel(quiz, moduleId, traineeLicenseId, isMockExam: false);
        return ServiceResult<QuizViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────
    // SUBMIT MODULE QUIZ
    // ─────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<QuizResultViewModel>> SubmitModuleQuizAsync(
        int traineeId, int traineeLicenseId, SubmitQuizViewModel model)
    {
        var quiz = await _context.Quizzes
            .Include(q => q.QuizQuestions)
                .ThenInclude(qq => qq.QuestionOptions)
            .FirstOrDefaultAsync(q => q.QuizId == model.QuizId && q.IsMockExam == false);

        if (quiz == null)
            return ServiceResult<QuizResultViewModel>.Failure("Quiz not found.");

        // Validate module is in progress
        var progress = await _context.TraineeModuleProgresses
            .FirstOrDefaultAsync(p => p.TraineeId == traineeId
                                   && p.ModuleId == quiz.ModuleId
                                   && p.TraineeLicenseId == traineeLicenseId);

        if (progress == null || progress.Status == "not_started")
            return ServiceResult<QuizResultViewModel>.Failure("Module must be started before taking the quiz.");

        // Grade
        var (score, passed, resultQuestions) = GradeQuiz(quiz, model.Answers);

        await using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            // Save attempt
            _context.QuizAttempts.Add(new QuizAttempt
            {
                QuizId = quiz.QuizId,
                TraineeId = traineeId,
                TraineeLicenseId = traineeLicenseId,
                Score = score,
                Passed = passed,
                AttemptDate = DateTime.UtcNow
            });

            // If passed → mark module completed
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

        // Notify
        if (passed)
        {
            var userId = await _context.Trainees
                .Where(t => t.TraineeId == traineeId)
                .Select(t => t.TraineeId)
                .FirstOrDefaultAsync();

            await _notifications.CreateAsync(userId,
                "Module Completed",
                $"You passed the quiz and completed the module!",
                "quiz");
        }

        var result = new QuizResultViewModel
        {
            QuizId = quiz.QuizId,
            ModuleId = quiz.ModuleId ?? 0,
            TraineeLicenseId = traineeLicenseId,
            Title = quiz.Title,
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
        int traineeId, int traineeLicenseId)
    {
        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeLicenseId == traineeLicenseId
                                    && tl.TraineeId == traineeId
                                    && tl.IsActive);

        if (license == null)
            return ServiceResult<QuizViewModel>.Failure("License not found.");

        // All theoretical modules must be completed
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

        var mockQuiz = await _context.Quizzes
            .Include(q => q.QuizQuestions)
                .ThenInclude(qq => qq.QuestionOptions)
            .FirstOrDefaultAsync(q => q.IsMockExam == true && q.LicenseTypeId == license.LicenseTypeId);

        if (mockQuiz == null)
            return ServiceResult<QuizViewModel>.Failure("No mock exam found for this license type.");

        // Shuffle questions
        var rng = new Random();
        var shuffled = mockQuiz.QuizQuestions.OrderBy(_ => rng.Next()).ToList();
        mockQuiz.QuizQuestions = shuffled;

        var vm = MapToQuizViewModel(mockQuiz, 0, traineeLicenseId, isMockExam: true);
        vm.TimeLimitMinutes = MockExamTimeLimitMinutes;

        return ServiceResult<QuizViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────
    // SUBMIT MOCK EXAM
    // ─────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<QuizResultViewModel>> SubmitMockExamAsync(
        int traineeId, int traineeLicenseId, SubmitQuizViewModel model)
    {
        var quiz = await _context.Quizzes
            .Include(q => q.QuizQuestions)
                .ThenInclude(qq => qq.QuestionOptions)
            .FirstOrDefaultAsync(q => q.QuizId == model.QuizId && q.IsMockExam == true);

        if (quiz == null)
            return ServiceResult<QuizResultViewModel>.Failure("Mock exam not found.");

        var (score, passed, resultQuestions) = GradeQuiz(quiz, model.Answers);

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

            // Advance stage to mock_exam_completed (completion, not pass, is required)
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
            Title = quiz.Title,
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
    private static QuizViewModel MapToQuizViewModel(
        Quiz quiz, int moduleId, int traineeLicenseId, bool isMockExam)
    {
        return new QuizViewModel
        {
            QuizId = quiz.QuizId,
            ModuleId = moduleId,
            TraineeLicenseId = traineeLicenseId,
            Title = quiz.Title,
            IsMockExam = isMockExam,
            PassingScore = quiz.PassingScore,
            Questions = quiz.QuizQuestions.Select(q => new QuizQuestionViewModel
            {
                QuestionId = q.QuestionId,
                QuestionText = q.QuestionText,
                Options = q.QuestionOptions.Select(o => new QuestionOptionViewModel
                {
                    OptionId = o.OptionId,
                    OptionText = o.OptionText
                }).ToList()
            }).ToList()
        };
    }

    private static (int score, bool passed, List<QuizResultQuestionViewModel> questions) GradeQuiz(
        Quiz quiz, Dictionary<int, int> answers)
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
                QuestionText = q.QuestionText,
                IsCorrect = isCorrect,
                SelectedOption = q.QuestionOptions.FirstOrDefault(o => o.OptionId == selectedOptionId)?.OptionText ?? "—",
                CorrectOption = correctOption?.OptionText ?? "—",
                Options = q.QuestionOptions.Select(o => new QuizResultOptionViewModel
                {
                    OptionId = o.OptionId,
                    OptionText = o.OptionText,
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
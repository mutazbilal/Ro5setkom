using Markdig;
using Microsoft.EntityFrameworkCore;
using ro5setkom.Areas.Trainee.ViewModels.Modules;
using ro5setkom.Models;
using ro5setkom.Services.Common;
using ro5setkom.Services.Interfaces;

namespace ro5setkom.Services.Implementations;

public class ModuleService : IModuleService
{
    private readonly Ro5setkomDbContext _context;
    private readonly INotificationService _notifications;

    public ModuleService(Ro5setkomDbContext context, INotificationService notifications)
    {
        _context = context;
        _notifications = notifications;
    }

    // ─────────────────────────────────────────────────────────────────────
    // GET MODULES LIST
    // ─────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<ModuleListViewModel>> GetModulesAsync(
        int traineeId, int traineeLicenseId, bool isEnglish)
    {
        var license = await _context.TraineeLicenses
            .Include(tl => tl.LicenseType)
            .FirstOrDefaultAsync(tl => tl.TraineeLicenseId == traineeLicenseId
                                    && tl.TraineeId == traineeId
                                    && tl.IsActive);

        if (license == null)
            return ServiceResult<ModuleListViewModel>.Failure("License not found.");

        var modules = await _context.LearningModules
            .Where(m => m.LicenseTypeId == license.LicenseTypeId)
            .OrderBy(m => m.Phase)
            .ThenBy(m => m.OrderIndex)
            .ToListAsync();

        var progressMap = await _context.TraineeModuleProgresses
            .Where(p => p.TraineeId == traineeId && p.TraineeLicenseId == traineeLicenseId)
            .ToDictionaryAsync(p => p.ModuleId);

        var moduleIds = modules.Select(m => m.ModuleId).ToList();
        var quizByModule = await _context.Quizzes
            .Where(q => q.ModuleId.HasValue && moduleIds.Contains(q.ModuleId.Value) && q.IsMockExam == false)
            .ToDictionaryAsync(q => q.ModuleId!.Value);

        var quizIds = quizByModule.Values.Select(q => q.QuizId).ToList();
        var passedQuizIds = await _context.QuizAttempts
            .Where(a => a.TraineeId == traineeId
                     && a.TraineeLicenseId == traineeLicenseId
                     && quizIds.Contains(a.QuizId)
                     && a.Passed == true)
            .Select(a => a.QuizId)
            .Distinct()
            .ToHashSetAsync();

        // Build ordered status map for prerequisite locking
        var statusMap = new Dictionary<int, string>();
        var cards = new List<ModuleCardViewModel>();

        foreach (var m in modules.OrderBy(m => m.Phase).ThenBy(m => m.OrderIndex))
        {
            progressMap.TryGetValue(m.ModuleId, out var prog);
            var status = prog?.Status ?? "not_started";

            quizByModule.TryGetValue(m.ModuleId, out var quiz);
            bool hasQuiz = quiz != null;
            bool quizPass = hasQuiz && passedQuizIds.Contains(quiz!.QuizId);

            bool isLocked = false;
            if (m.PrerequisiteModuleId.HasValue)
            {
                statusMap.TryGetValue(m.PrerequisiteModuleId.Value, out var prereqStatus);
                isLocked = prereqStatus != "completed";
            }

            statusMap[m.ModuleId] = status;

            cards.Add(new ModuleCardViewModel
            {
                ModuleId = m.ModuleId,
                Title = m.Title,
                Description = m.Description ?? string.Empty,
                Phase = m.Phase,
                Status = status,
                OrderIndex = m.OrderIndex,
                IsLocked = isLocked,
                HasQuiz = hasQuiz,
                QuizPassed = quizPass
            });
        }

        var mockQuiz = await _context.Quizzes
            .FirstOrDefaultAsync(q => q.IsMockExam == true && q.LicenseTypeId == license.LicenseTypeId);

        bool allTheoreticalDone = cards
            .Where(c => c.Phase == "theoretical")
            .All(c => c.Status == "completed");

        bool mockCompleted = false;
        if (mockQuiz != null)
        {
            mockCompleted = await _context.QuizAttempts
                .AnyAsync(a => a.QuizId == mockQuiz.QuizId
                            && a.TraineeId == traineeId
                            && a.TraineeLicenseId == traineeLicenseId);
        }

        var vm = new ModuleListViewModel
        {
            TraineeLicenseId = traineeLicenseId,
            LicenseTypeName = license.LicenseType.LicenseName,
            IsMockExamAvailable = allTheoreticalDone && mockQuiz != null,
            IsMockExamCompleted = mockCompleted,
            TheoreticalModules = cards.Where(c => c.Phase == "theoretical").ToList(),
            PracticalModules = cards.Where(c => c.Phase == "practical").ToList()
        };

        return ServiceResult<ModuleListViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────
    // GET MODULE DETAIL
    // ─────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<ModuleDetailViewModel>> GetModuleDetailAsync(
        int traineeId, int traineeLicenseId, int moduleId, bool isEnglish)
    {
        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeLicenseId == traineeLicenseId
                                    && tl.TraineeId == traineeId
                                    && tl.IsActive);

        if (license == null)
            return ServiceResult<ModuleDetailViewModel>.Failure("License not found.");

        var module = await _context.LearningModules
            .Include(m => m.ModuleContents)
            .FirstOrDefaultAsync(m => m.ModuleId == moduleId && m.LicenseTypeId == license.LicenseTypeId);

        if (module == null)
            return ServiceResult<ModuleDetailViewModel>.Failure("Module not found.");

        // Locking check
        bool isLocked = false;
        if (module.PrerequisiteModuleId.HasValue)
        {
            var prereqProg = await _context.TraineeModuleProgresses
                .FirstOrDefaultAsync(p => p.TraineeId == traineeId
                                       && p.ModuleId == module.PrerequisiteModuleId.Value
                                       && p.TraineeLicenseId == traineeLicenseId);
            isLocked = prereqProg?.Status != "completed";
        }

        if (isLocked)
            return ServiceResult<ModuleDetailViewModel>.Failure("Module is locked. Complete the prerequisite first.");

        // Progress
        var progress = await _context.TraineeModuleProgresses
            .FirstOrDefaultAsync(p => p.TraineeId == traineeId
                                   && p.ModuleId == moduleId
                                   && p.TraineeLicenseId == traineeLicenseId);

        var status = progress?.Status ?? "not_started";

        // Quiz
        var quiz = await _context.Quizzes
            .FirstOrDefaultAsync(q => q.ModuleId == moduleId && q.IsMockExam == false);

        int? lastScore = null;
        bool quizPassed = false;
        if (quiz != null)
        {
            var lastAttempt = await _context.QuizAttempts
                .Where(a => a.QuizId == quiz.QuizId
                         && a.TraineeId == traineeId
                         && a.TraineeLicenseId == traineeLicenseId)
                .OrderByDescending(a => a.AttemptDate)
                .FirstOrDefaultAsync();

            lastScore = lastAttempt?.Score;
            quizPassed = await _context.QuizAttempts
                .AnyAsync(a => a.QuizId == quiz.QuizId
                            && a.TraineeId == traineeId
                            && a.TraineeLicenseId == traineeLicenseId
                            && a.Passed == true);
        }

        // Filter contents by language
        var contents = module.ModuleContents
            .Where(c => c.LanguageEnglish == isEnglish)
            .Select(c => new ModuleContentViewModel
            {
                ContentId = c.ContentId,
                ContentType = c.ContentType,
                VideoUrl = c.VideoUrl,
                TextContent = c.TextContent
            })
            .ToList();
        foreach (var c in contents)
        {
            if (c.ContentType == "text" && !string.IsNullOrEmpty(c.TextContent))
            {
                c.TextContent = Markdown.ToHtml(c.TextContent);
            }
        }
        var vm = new ModuleDetailViewModel
        {
            ModuleId = module.ModuleId,
            TraineeLicenseId = traineeLicenseId,
            Title = module.Title,
            Description = module.Description ?? string.Empty,
            Phase = module.Phase,
            Status = status,
            IsLocked = isLocked,
            HasQuiz = quiz != null,
            QuizId = quiz?.QuizId,
            QuizPassed = quizPassed,
            LastAttemptScore = lastScore,
            CanCompleteDirectly = quiz == null && status == "in_progress",
            Contents = contents
        };

        return ServiceResult<ModuleDetailViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────
    // START MODULE
    // ─────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> StartModuleAsync(int traineeId, int traineeLicenseId, int moduleId)
    {
        var existing = await _context.TraineeModuleProgresses
            .FirstOrDefaultAsync(p => p.TraineeId == traineeId
                                   && p.ModuleId == moduleId
                                   && p.TraineeLicenseId == traineeLicenseId);

        if (existing != null)
            return ServiceResult.Success(); // already started or completed

        // Verify license ownership
        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeLicenseId == traineeLicenseId
                                    && tl.TraineeId == traineeId
                                    && tl.IsActive);

        if (license == null)
            return ServiceResult.Failure("License not found.");

        // Advance stage to theoretical_prep on first module start
        if (license.Stage == "registered")
        {
            license.Stage = "theoretical_prep";
            license.UpdatedAt = DateTime.UtcNow;
        }

        _context.TraineeModuleProgresses.Add(new TraineeModuleProgress
        {
            TraineeId = traineeId,
            ModuleId = moduleId,
            TraineeLicenseId = traineeLicenseId,
            Status = "in_progress",
            StartedAt = DateTime.UtcNow
        });

        await _context.SaveChangesAsync();
        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────
    // COMPLETE MODULE (no-quiz path only — quiz path is handled by QuizService)
    // ─────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> CompleteModuleAsync(int traineeId, int traineeLicenseId, int moduleId)
    {
        // Verify no quiz exists for this module
        bool hasQuiz = await _context.Quizzes
            .AnyAsync(q => q.ModuleId == moduleId && q.IsMockExam == false);

        if (hasQuiz)
            return ServiceResult.Failure("Module requires a passed quiz before completion.");

        var progress = await _context.TraineeModuleProgresses
            .FirstOrDefaultAsync(p => p.TraineeId == traineeId
                                   && p.ModuleId == moduleId
                                   && p.TraineeLicenseId == traineeLicenseId);

        if (progress == null)
            return ServiceResult.Failure("Module has not been started.");

        if (progress.Status == "completed")
            return ServiceResult.Success(); // idempotent

        if (progress.Status != "in_progress")
            return ServiceResult.Failure("Module must be in progress before completing.");

        progress.Status = "completed";
        progress.CompletedAt = DateTime.UtcNow;

        await UpdateLicenseProgressAsync(traineeId, traineeLicenseId);
        await _context.SaveChangesAsync();

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────
    // INTERNAL: recalculate and persist progress %
    // ─────────────────────────────────────────────────────────────────────
    internal async Task UpdateLicenseProgressAsync(int traineeId, int traineeLicenseId)
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
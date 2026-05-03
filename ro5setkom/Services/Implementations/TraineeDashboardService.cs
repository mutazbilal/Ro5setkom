using Microsoft.EntityFrameworkCore;
using ro5setkom.Areas.Trainee.ViewModels.Dashboard;
using ro5setkom.Models;
using ro5setkom.Services.Common;
using ro5setkom.Services.Interfaces;

namespace ro5setkom.Services.Implementations;

public class TraineeDashboardService : ITraineeDashboardService
{
    private readonly Ro5setkomDbContext _context;

    public TraineeDashboardService(Ro5setkomDbContext context)
    {
        _context = context;
    }

    public async Task<ServiceResult<TraineeDashboardViewModel>> GetDashboardAsync(int traineeId)
    {
        // 1. Get active license
        var license = await _context.TraineeLicenses
            .Include(tl => tl.LicenseType)
            .FirstOrDefaultAsync(tl => tl.TraineeId == traineeId && tl.IsActive);

        if (license == null)
            return ServiceResult<TraineeDashboardViewModel>.Failure("No active license found.");

        // 2. Get all modules for this license type, ordered
        var modules = await _context.LearningModules
            .Where(m => m.LicenseTypeId == license.LicenseTypeId)
            .OrderBy(m => m.Phase)
            .ThenBy(m => m.OrderIndex)
            .ToListAsync();

        // 3. Get trainee's progress for this license
        var progressRecords = await _context.TraineeModuleProgresses
            .Where(p => p.TraineeId == traineeId && p.TraineeLicenseId == license.TraineeLicenseId)
            .ToDictionaryAsync(p => p.ModuleId);

        // 4. Get all quiz info for modules in one query
        var moduleIds = modules.Select(m => m.ModuleId).ToList();
        var quizByModule = await _context.Quizzes
            .Where(q => q.ModuleId.HasValue
                 && moduleIds.Contains(q.ModuleId.Value)
                 && q.IsMockExam != true)
            .ToDictionaryAsync(q => q.ModuleId!.Value);

        // 5. Get passed quiz attempts
        var quizIds = quizByModule.Values.Select(q => q.QuizId).ToList();
        var passedQuizIds = await _context.QuizAttempts
            .Where(a => a.TraineeId == traineeId
                     && a.TraineeLicenseId == license.TraineeLicenseId
                     && quizIds.Contains(a.QuizId)
                     && a.Passed == true)
            .Select(a => a.QuizId)
            .Distinct()
            .ToListAsync();

        // 6. Build module progress items
        var progressMap = new Dictionary<int, string>(); // moduleId → status
        var items = new List<ModuleProgressItem>();

        foreach (var module in modules)
        {
            progressRecords.TryGetValue(module.ModuleId, out var prog);
            var status = prog?.Status ?? "not_started";

            quizByModule.TryGetValue(module.ModuleId, out var quiz);
            bool hasQuiz = quiz != null;
            bool quizPass = hasQuiz && passedQuizIds.Contains(quiz!.QuizId);

            bool isLocked = false;
            if (module.PrerequisiteModuleId.HasValue)
            {
                progressMap.TryGetValue(module.PrerequisiteModuleId.Value, out var prereqStatus);
                isLocked = prereqStatus != "completed";
            }

            progressMap[module.ModuleId] = status;

            items.Add(new ModuleProgressItem
            {
                ModuleId = module.ModuleId,
                Title = module.Title,
                Phase = module.Phase,
                Status = status,
                OrderIndex = module.OrderIndex,
                IsLocked = isLocked,
                HasQuiz = hasQuiz,
                QuizPassed = quizPass
            });
        }

        // 7. Mock exam status
        var mockQuiz = await _context.Quizzes
            .FirstOrDefaultAsync(q => q.IsMockExam == true && q.LicenseTypeId == license.LicenseTypeId);

        bool allTheoreticalCompleted = items
            .Where(i => i.Phase == "theoretical")
            .All(i => i.Status == "completed");

        bool mockExamCompleted = false;
        if (mockQuiz != null)
        {
            mockExamCompleted = await _context.QuizAttempts
                .AnyAsync(a => a.QuizId == mockQuiz.QuizId
                            && a.TraineeId == traineeId
                            && a.TraineeLicenseId == license.TraineeLicenseId);
        }

        bool isMockExamAvailable = allTheoreticalCompleted && mockQuiz != null;
        bool isTheoryExamBookable = isMockExamAvailable && mockExamCompleted;

        // 8. Overall progress %
        int totalModules = items.Count;
        int completedModules = items.Count(i => i.Status == "completed");
        int overallPct = totalModules == 0 ? 0 : (int)Math.Round((double)completedModules / totalModules * 100);

        // 9. Next milestone
        string nextMilestone = DetermineNextMilestone(items, isMockExamAvailable, mockExamCompleted, license.Stage);

        var vm = new TraineeDashboardViewModel
        {
            TraineeLicenseId = license.TraineeLicenseId,
            LicenseTypeName = license.LicenseType.LicenseName,
            Stage = license.Stage,
            OverallProgressPercentage = overallPct,
            NextMilestone = nextMilestone,
            IsMockExamAvailable = isMockExamAvailable,
            IsMockExamCompleted = mockExamCompleted,
            IsTheoryExamBookable = isTheoryExamBookable,
            TheoreticalModules = items.Where(i => i.Phase == "theoretical").OrderBy(i => i.OrderIndex).ToList(),
            PracticalModules = items.Where(i => i.Phase == "practical").OrderBy(i => i.OrderIndex).ToList()
        };

        return ServiceResult<TraineeDashboardViewModel>.Success(vm);
    }

    private static string DetermineNextMilestone(
        List<ModuleProgressItem> items,
        bool isMockAvailable,
        bool mockCompleted,
        string stage)
    {
        // First incomplete theoretical module
        var nextTheory = items
            .Where(i => i.Phase == "theoretical" && i.Status != "completed" && !i.IsLocked)
            .OrderBy(i => i.OrderIndex)
            .FirstOrDefault();

        if (nextTheory != null)
            return $"Complete module: {nextTheory.Title}";

        if (isMockAvailable && !mockCompleted)
            return "Take the mock exam";

        if (mockCompleted && stage is "mock_exam_completed" or "theoretical_prep")
            return "Book your theory exam";

        var nextPractical = items
            .Where(i => i.Phase == "practical" && i.Status != "completed" && !i.IsLocked)
            .OrderBy(i => i.OrderIndex)
            .FirstOrDefault();

        if (nextPractical != null)
            return $"Complete practical module: {nextPractical.Title}";

        return stage == "completed" ? "License journey complete!" : "Check your exam appointments";
    }
}
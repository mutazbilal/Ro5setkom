using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Trainee.ViewModels.Dashboard;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations;

public class TraineeDashboardService : ITraineeDashboardService
{
    private readonly RokhsetakDbContext _context;

    public TraineeDashboardService(RokhsetakDbContext context)
    {
        _context = context;
    }

    public async Task<ServiceResult<TraineeDashboardViewModel>> GetDashboardAsync(
        int traineeId, string culture)
    {
        // 1. Active license
        var license = await _context.TraineeLicenses
            .Include(tl => tl.LicenseType)
            .FirstOrDefaultAsync(tl => tl.TraineeId == traineeId && tl.IsActive);

        if (license == null)
            return ServiceResult<TraineeDashboardViewModel>.Failure("No active license found.");

        // 2. Modules — project translated title directly, no extra round-trips
        var modules = await _context.LearningModules
            .Where(m => m.LicenseTypeId == license.LicenseTypeId)
            .OrderBy(m => m.Phase)
            .ThenBy(m => m.OrderIndex)
            .Select(m => new
            {
                m.ModuleId,
                m.Phase,
                m.OrderIndex,
                m.PrerequisiteModuleId,
                Title = m.ModuleTranslations
                    .Where(t => t.LanguageCode == culture)
                    .Select(t => t.Title)
                    .FirstOrDefault()
                    ?? m.ModuleTranslations
                        .Where(t => t.LanguageCode == "en")
                        .Select(t => t.Title)
                        .FirstOrDefault()
                    ?? string.Empty
            })
            .ToListAsync();

        // 3. Progress records for this license
        var progressRecords = await _context.TraineeModuleProgresses
            .Where(p => p.TraineeId == traineeId
                     && p.TraineeId == traineeId &&
                        (
                            p.Module.Phase == "theoretical" ||
                            (
                                p.Module.Phase == "practical" &&
                                p.TraineeLicenseId == license.TraineeLicenseId
                            )
                        ))
            .ToDictionaryAsync(p => p.ModuleId);

        // 4. Quiz info per module
        var moduleIds = modules.Select(m => m.ModuleId).ToList();
        var quizByModule = await _context.Quizzes
            .Where(q => q.ModuleId.HasValue
                     && moduleIds.Contains(q.ModuleId.Value)
                     && q.IsMockExam != true)
            .ToDictionaryAsync(q => q.ModuleId!.Value);

        // 5. Passed quiz attempts
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
            .FirstOrDefaultAsync(q => q.IsMockExam == true
                                   && q.LicenseTypeId == license.LicenseTypeId);

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
        int overallPct = totalModules == 0
            ? 0
            : (int)Math.Round((double)completedModules / totalModules * 100);

        // 9. Next milestone
        string nextMilestone = DetermineNextMilestone(
            items, isMockExamAvailable, mockExamCompleted, license.Stage, culture);

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
        string stage,
        string culture)
    {
        // Milestone strings — extend this to a translation dictionary if you
        // add i18n for UI strings later. For now culture-switches the labels.
        bool isArabic = culture == "ar";

        var nextTheory = items
            .Where(i => i.Phase == "theoretical" && i.Status != "completed" && !i.IsLocked)
            .OrderBy(i => i.OrderIndex)
            .FirstOrDefault();

        if (nextTheory != null)
            return isArabic
                ? $"أكمل الوحدة: {nextTheory.Title}"
                : $"Complete module: {nextTheory.Title}";

        if (isMockAvailable && !mockCompleted)
            return isArabic ? "اجتز الاختبار التجريبي" : "Take the mock exam";

        if (mockCompleted && stage is "mock_exam_completed" or "theoretical_prep")
            return isArabic ? "احجز اختبار النظري" : "Book your theory exam";

        var nextPractical = items
            .Where(i => i.Phase == "practical" && i.Status != "completed" && !i.IsLocked)
            .OrderBy(i => i.OrderIndex)
            .FirstOrDefault();

        if (nextPractical != null)
            return isArabic
                ? $"أكمل الوحدة العملية: {nextPractical.Title}"
                : $"Complete practical module: {nextPractical.Title}";

        return stage == "completed"
            ? (isArabic ? "رحلة الرخصة اكتملت!" : "License journey complete!")
            : (isArabic ? "تحقق من مواعيد اختباراتك" : "Check your exam appointments");
    }
}
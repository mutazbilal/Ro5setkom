using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Chat.Implementations.Providers
{
    // LearningContextProvider.cs  — reuses ITraineeDashboardService you already have
    public class LearningContextProvider : ILearningContextProvider
    {
        private readonly ITraineeDashboardService _dashboard;
        private readonly RokhsetakDbContext _db;
        public LearningContextProvider(ITraineeDashboardService dashboard, RokhsetakDbContext db)
        {
            _dashboard = dashboard;
            _db = db;
        }

        public async Task<LearningAiContext?> GetAsync(int userId, string culture, CancellationToken ct = default)
        {
            var traineeId = await _db.Trainees
                .Where(t => t.TraineeId == userId)
                .Select(t => (int?)t.TraineeId)
                .FirstOrDefaultAsync(ct);

            if (traineeId is null) return null;

            var result = await _dashboard.GetDashboardAsync(traineeId.Value, culture);
            if (!result.Succeeded) return null;

            var vm = result.Data!;

            // Only pass titles of up to 5 next incomplete modules — keeps tokens low
            var incomplete = vm.TheoreticalModules
                .Concat(vm.PracticalModules)
                .Where(m => m.Status != "completed" && !m.IsLocked)
                .OrderBy(m => m.Phase == "theoretical" ? 0 : 1)
                .ThenBy(m => m.OrderIndex)
                .Take(5)
                .Select(m => new ModuleSummary(m.Title, m.Phase, m.IsLocked))
                .ToList();

            var completed = vm.TheoreticalModules
                .Concat(vm.PracticalModules)
                .Where(m => m.Status == "completed")
                .Select(m => new ModuleSummary(m.Title, m.Phase, false))
                .ToList();

            return new LearningAiContext(
                vm.OverallProgressPercentage,
                vm.NextMilestone,
                vm.IsMockExamAvailable,
                vm.IsMockExamCompleted,
                vm.IsTheoryExamBookable,
                incomplete,
                completed
            );
        }
    }
}

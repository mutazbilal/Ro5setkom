namespace Rokhsetak.Areas.Trainee.ViewModels.Dashboard
{
    public class TraineeDashboardViewModel
    {
        public int TraineeLicenseId { get; set; }
        public string LicenseTypeName { get; set; } = string.Empty;
        public string Stage { get; set; } = string.Empty;
        public int OverallProgressPercentage { get; set; }
        public string NextMilestone { get; set; } = string.Empty;
        public bool IsMockExamAvailable { get; set; }
        public bool IsMockExamCompleted { get; set; }
        public bool IsTheoryExamBookable { get; set; }

        public List<ModuleProgressItem> TheoreticalModules { get; set; } = new();
        public List<ModuleProgressItem> PracticalModules { get; set; } = new();
    }

    public class ModuleProgressItem
    {
        public int ModuleId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Phase { get; set; } = string.Empty;
        public string Status { get; set; } = "not_started";
        public int OrderIndex { get; set; }
        public bool IsLocked { get; set; }
        public bool HasQuiz { get; set; }
        public bool QuizPassed { get; set; }
    }

}

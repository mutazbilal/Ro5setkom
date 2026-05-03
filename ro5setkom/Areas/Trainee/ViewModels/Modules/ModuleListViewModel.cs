namespace ro5setkom.Areas.Trainee.ViewModels.Modules
{
    public class ModuleListViewModel
    {
        public int TraineeLicenseId { get; set; }
        public string LicenseTypeName { get; set; } = string.Empty;
        public bool IsMockExamAvailable { get; set; }
        public bool IsMockExamCompleted { get; set; }

        public List<ModuleCardViewModel> TheoreticalModules { get; set; } = new();
        public List<ModuleCardViewModel> PracticalModules { get; set; } = new();
    }

    public class ModuleCardViewModel
    {
        public int ModuleId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Phase { get; set; } = string.Empty;
        public string Status { get; set; } = "not_started";
        public int OrderIndex { get; set; }
        public bool IsLocked { get; set; }
        public bool HasQuiz { get; set; }
        public bool QuizPassed { get; set; }
    }
}

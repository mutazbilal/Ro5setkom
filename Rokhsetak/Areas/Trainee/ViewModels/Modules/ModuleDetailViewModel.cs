namespace Rokhsetak.Areas.Trainee.ViewModels.Modules
{
    public class ModuleDetailViewModel
    {
        public int ModuleId { get; set; }
        public int TraineeLicenseId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Phase { get; set; } = string.Empty;
        public string Status { get; set; } = "not_started";
        public bool IsLocked { get; set; }
        public bool HasQuiz { get; set; }
        public int? QuizId { get; set; }
        public bool QuizPassed { get; set; }
        public int? LastAttemptScore { get; set; }
        public bool CanCompleteDirectly { get; set; }

        public List<ModuleContentViewModel> Contents { get; set; } = new();
    }

    public class ModuleContentViewModel
    {
        public int ContentId { get; set; }
        public string? ContentType { get; set; }
        public string? VideoUrl { get; set; }
        public string? TextContent { get; set; }
    }
}

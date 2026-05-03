namespace ro5setkom.Areas.Trainee.ViewModels.Quiz
{
    public class QuizViewModel
    {
        public int QuizId { get; set; }
        public int ModuleId { get; set; }
        public int TraineeLicenseId { get; set; }
        public string Title { get; set; } = string.Empty;
        public bool IsMockExam { get; set; }
        public int PassingScore { get; set; }
        public int TimeLimitMinutes { get; set; } = 0; // 0 = no limit

        public List<QuizQuestionViewModel> Questions { get; set; } = new();
    }

    public class QuizQuestionViewModel
    {
        public int QuestionId { get; set; }
        public string QuestionText { get; set; } = string.Empty;
        public List<QuestionOptionViewModel> Options { get; set; } = new();
    }

    public class QuestionOptionViewModel
    {
        public int OptionId { get; set; }
        public string OptionText { get; set; } = string.Empty;
    }
}

namespace ro5setkom.Areas.Trainee.ViewModels.Quiz
{
    public class QuizResultViewModel
    {
        public int QuizId { get; set; }
        public int ModuleId { get; set; }
        public int TraineeLicenseId { get; set; }
        public string Title { get; set; } = string.Empty;
        public bool IsMockExam { get; set; }
        public int Score { get; set; }
        public int TotalQuestions { get; set; }
        public int PassingScore { get; set; }
        public bool Passed { get; set; }
        public int CorrectCount { get; set; }
        public int IncorrectCount { get; set; }

        public List<QuizResultQuestionViewModel> Questions { get; set; } = new();
    }

    public class QuizResultQuestionViewModel
    {
        public string QuestionText { get; set; } = string.Empty;
        public bool IsCorrect { get; set; }
        public string SelectedOption { get; set; } = string.Empty;
        public string CorrectOption { get; set; } = string.Empty;
        public List<QuizResultOptionViewModel> Options { get; set; } = new();
    }

    public class QuizResultOptionViewModel
    {
        public int OptionId { get; set; }
        public string OptionText { get; set; } = string.Empty;
        public bool IsCorrect { get; set; }
        public bool WasSelected { get; set; }
    }
}

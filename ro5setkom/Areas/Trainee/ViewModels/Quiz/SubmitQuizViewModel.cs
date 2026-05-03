using System.ComponentModel.DataAnnotations;

namespace ro5setkom.Areas.Trainee.ViewModels.Quiz
{
    public class SubmitQuizViewModel
    {
        [Required]
        public int QuizId { get; set; }

        [Required]
        public int TraineeLicenseId { get; set; }

        public int ModuleId { get; set; }

        /// <summary>
        /// Key = QuestionId, Value = selected OptionId
        /// </summary>
        public Dictionary<int, int> Answers { get; set; } = new();
    }
}

using System.ComponentModel.DataAnnotations;

namespace Rokhsetak.Areas.Trainee.ViewModels.Quiz
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

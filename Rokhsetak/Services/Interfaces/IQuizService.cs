using Rokhsetak.Areas.Trainee.ViewModels.Quiz;
using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces
{
    public interface IQuizService
    {
        Task<ServiceResult<QuizViewModel>> GetModuleQuizAsync(int traineeId, int traineeLicenseId, int moduleId, string culture);
        Task<ServiceResult<QuizResultViewModel>> SubmitModuleQuizAsync(int traineeId, int traineeLicenseId, SubmitQuizViewModel model, string culture);
        Task<ServiceResult<QuizViewModel>> GetMockExamAsync(int traineeId, int traineeLicenseId, string culture);
        Task<ServiceResult<QuizResultViewModel>> SubmitMockExamAsync(int traineeId, int traineeLicenseId, SubmitQuizViewModel model, string culture);
    }
}

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ro5setkom.Areas.Trainee.ViewModels.Quiz;
using ro5setkom.Services.Interfaces;
using ro5setkom.Utils;

namespace ro5setkom.Areas.Trainee.Controllers;

[Area("Trainee")]
[Authorize(Roles = "trainee")]
public class QuizController : Controller
{
    private readonly IQuizService _quizService;
    private readonly ITraineeDashboardService _dashboard;

    public QuizController(IQuizService quizService, ITraineeDashboardService dashboard)
    {
        _quizService = quizService;
        _dashboard = dashboard;
    }

    // GET /Trainee/Quiz/Take?moduleId=5
    public async Task<IActionResult> Take(int moduleId)
    {
        var userId = User.GetUserId().Value;
        var licenseId = await GetActiveLicenseIdAsync(userId);
        if (licenseId == null) return RedirectToAction("Index", "Dashboard");

        var result = await _quizService.GetModuleQuizAsync(userId, licenseId.Value, moduleId);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Detail", "Modules", new { id = moduleId });
        }

        return View(result.Data);
    }

    // POST /Trainee/Quiz/Submit
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Submit(SubmitQuizViewModel model)
    {
        var userId = User.GetUserId().Value;

        if (!ModelState.IsValid)
        {
            TempData["Error"] = "Please answer all questions.";
            return RedirectToAction("Take", new { moduleId = model.ModuleId });
        }

        var result = await _quizService.SubmitModuleQuizAsync(userId, model.TraineeLicenseId, model);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Take", new { moduleId = model.ModuleId });
        }

        return View("Result", result.Data);
    }

    // GET /Trainee/Quiz/MockExam
    public async Task<IActionResult> MockExam()
    {
        var userId = User.GetUserId().Value;
        var licenseId = await GetActiveLicenseIdAsync(userId);
        if (licenseId == null) return RedirectToAction("Index", "Dashboard");

        var result = await _quizService.GetMockExamAsync(userId, licenseId.Value);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index", "Modules");
        }

        return View(result.Data);
    }

    // POST /Trainee/Quiz/SubmitMockExam
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> SubmitMockExam(SubmitQuizViewModel model)
    {
        var userId = User.GetUserId().Value;

        var result = await _quizService.SubmitMockExamAsync(userId, model.TraineeLicenseId, model);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("MockExam");
        }

        return View("Result", result.Data);
    }

    // ─── helper ───────────────────────────────────────────────────────────
    private async Task<int?> GetActiveLicenseIdAsync(int traineeId)
    {
        var result = await _dashboard.GetDashboardAsync(traineeId);
        return result.Succeeded ? result.Data?.TraineeLicenseId : null;
    }
}
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Areas.Trainee.ViewModels.Exam;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;
using System.Globalization;

namespace Rokhsetak.Areas.Trainee.Controllers;

[Area("Trainee")]
public class ExamController : Controller
{
    private readonly IExamAppointmentService _examService;

    public ExamController(IExamAppointmentService examService)
    {
        _examService = examService;
    }

    // ─────────────────────────────────────────────
    // INDEX - MY EXAMS
    // ─────────────────────────────────────────────
    [HttpGet]
    public async Task<IActionResult> Index()
    {
        var traineeId = User.GetUserId().Value;
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _examService.GetMyExamAppointmentsAsync(traineeId, culture);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return View(new ExamAppointmentListViewModel());
        }

        return View(result.Data);
    }

    // ─────────────────────────────────────────────
    // BOOK (GET) - SHOW AVAILABLE EXAMS
    // ─────────────────────────────────────────────
    [HttpGet]
    public async Task<IActionResult> Book(string examType)
    {
        var traineeId = User.GetUserId().Value;
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _examService.GetAvailableExamsAsync(traineeId, examType, culture);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction(nameof(Index));
        }

        return View(result.Data);
    }

    // ─────────────────────────────────────────────
    // BOOK (POST) - CONFIRM BOOKING
    // ─────────────────────────────────────────────
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Book(BookExamViewModel model)
    {
        var traineeId = User.GetUserId().Value;

        var result = await _examService.BookExamAsync(traineeId, model);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction(nameof(Book), new { examType = model.ExamType });
        }

        TempData["Success"] = "Exam booked successfully.";
        return RedirectToAction(nameof(Index));
    }

    // ─────────────────────────────────────────────
    // CANCEL EXAM
    // ─────────────────────────────────────────────
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Cancel(int appointmentId)
    {
        var traineeId = User.GetUserId().Value;

        var result = await _examService.CancelExamAppointmentAsync(traineeId, appointmentId);

        if (!result.Succeeded)
            TempData["Error"] = result.Error;
        else
            TempData["Success"] = "Appointment cancelled successfully.";

        return RedirectToAction(nameof(Index));
    }
}
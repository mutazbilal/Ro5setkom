using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;

namespace Rokhsetak.Areas.Mentor.Controllers;

[Area("Mentor")]
[Authorize(Roles = "mentor")]
public class TraineesController : Controller
{
    private readonly IAppointmentService _appointments;

    public TraineesController(IAppointmentService appointments)
    {
        _appointments = appointments;
    }

    // GET /Mentor/Trainees?search=ali&statusFilter=theoretical_prep
    public async Task<IActionResult> Index(string? search, string? statusFilter)
    {
        var mentorId = User.GetUserId().Value;
        var result = await _appointments.GetTraineeSummaryAsync(mentorId, search, statusFilter);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index", "Dashboard");
        }

        return View(result.Data);
    }

    // GET /Mentor/Trainees/Detail/5
    public async Task<IActionResult> Detail(int id)
    {
        var mentorId = User.GetUserId().Value;
        var result = await _appointments.GetTraineeDetailAsync(mentorId, id);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index");
        }

        return View(result.Data);
    }
}
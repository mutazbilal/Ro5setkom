using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;
using System.Globalization;

namespace Rokhsetak.Areas.Mentor.Controllers;

[Area("Mentor")]
[Authorize(Roles = "mentor")]
public class DashboardController : Controller
{
    private readonly IMentorDashboardService _dashboard;

    public DashboardController(IMentorDashboardService dashboard)
    {
        _dashboard = dashboard;
    }

    public async Task<IActionResult> Index()
    {
        var mentorId = User.GetUserId().Value;
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _dashboard.GetDashboardAsync(mentorId, culture);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index", "Home", new { area = "" });
        }

        return View(result.Data);
    }
}
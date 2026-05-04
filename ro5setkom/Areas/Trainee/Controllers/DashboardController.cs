using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ro5setkom.Services.Interfaces;
using ro5setkom.Utils;
using System.Globalization;

namespace ro5setkom.Areas.Trainee.Controllers;

[Area("Trainee")]
[Authorize(Roles = "trainee")]
public class DashboardController : Controller
{
    private readonly ITraineeDashboardService _dashboard;

    public DashboardController(ITraineeDashboardService dashboard)
    {
        _dashboard = dashboard;
    }

    public async Task<IActionResult> Index()
    {
        var userId = User.GetUserId().Value;
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _dashboard.GetDashboardAsync(userId, culture);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index", "Home", new { area = "" });
        }

        return View(result.Data);
    }
}
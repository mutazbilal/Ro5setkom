using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;
using System.Globalization;

namespace Rokhsetak.Areas.Trainee.Controllers;

[Area("Trainee")]
[Authorize(Roles = "trainee")]
public class ModulesController : Controller
{
    private readonly IModuleService _modules;
    private readonly ITraineeDashboardService _dashboard;

    public ModulesController(IModuleService modules, ITraineeDashboardService dashboard)
    {
        _modules = modules;
        _dashboard = dashboard;
    }

    // GET /Trainee/Modules
    public async Task<IActionResult> Index()
    {
        var userId = User.GetUserId().Value;
        var licenseId = await GetActiveLicenseIdAsync(userId);

        if (licenseId == null)
        {
            TempData["Error"] = "No active license found.";
            return RedirectToAction("Index", "Dashboard");
        }

        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _modules.GetModulesAsync(userId, licenseId.Value, culture);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index", "Dashboard");
        }

        return View(result.Data);
    }

    // GET /Trainee/Modules/Detail/5
    public async Task<IActionResult> Detail(int id)
    {
        var userId = User.GetUserId().Value;
        var licenseId = await GetActiveLicenseIdAsync(userId);

        if (licenseId == null)
            return RedirectToAction("Index", "Dashboard");

        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;

        // Auto-start the module when viewed
        await _modules.StartModuleAsync(userId, licenseId.Value, id);

        var result = await _modules.GetModuleDetailAsync(userId, licenseId.Value, id, culture);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index");
        }

        return View(result.Data);
    }

    // POST /Trainee/Modules/Complete
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Complete(int moduleId, int traineeLicenseId)
    {
        var userId = User.GetUserId().Value;
        var result = await _modules.CompleteModuleAsync(userId, traineeLicenseId, moduleId);

        if (!result.Succeeded)
            TempData["Error"] = result.Error;
        else
            TempData["Success"] = "Module marked as complete!";

        return RedirectToAction("Detail", new { id = moduleId });
    }

    // ─── helper ───────────────────────────────────────────────────────────
    private async Task<int?> GetActiveLicenseIdAsync(int traineeId)
    {
        // Reuse dashboard service to avoid duplicate DB logic
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _dashboard.GetDashboardAsync(traineeId, culture);
        return result.Succeeded ? result.Data?.TraineeLicenseId : null;
    }
}
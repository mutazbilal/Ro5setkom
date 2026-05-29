using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Areas.Admin.ViewModels.Dashboard;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Roles = "admin")]
public class DashboardController : Controller
{
    private readonly IAnalyticsService _analytics;

    public DashboardController(IAnalyticsService analytics)
    {
        _analytics = analytics;
    }

    // GET /Admin/Dashboard
    public async Task<IActionResult> Index(AnalyticsFilter filter)
    {
        var result = await _analytics.GetDashboardAsync(filter);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return View(new AnalyticsDashboardViewModel { Filter = filter });
        }

        ViewData["ActiveNav"] = "dashboard";
        return View(result.Data);
    }
}

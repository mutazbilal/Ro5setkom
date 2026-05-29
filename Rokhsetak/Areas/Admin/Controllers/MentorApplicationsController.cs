using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;
using Rokhsetak.Areas.Admin.ViewModels.MentorApplications;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;
using System.Globalization;

namespace Rokhsetak.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Roles = "admin")]
public class MentorApplicationsController : Controller
{
    private readonly IMentorAdminService _mentors;

    public MentorApplicationsController(IMentorAdminService mentors)
    {
        _mentors = mentors;
    }

    // GET /Admin/MentorApplications
    public async Task<IActionResult> Index()
    {
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _mentors.GetPendingApplicationsAsync(culture);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return View(new MentorApplicationListViewModel());
        }

        ViewData["ActiveNav"] = "applications";
        return View(result.Data);
    }

    // GET /Admin/MentorApplications/Details/5
    public async Task<IActionResult> Details(int id)
    {
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _mentors.GetApplicationDetailsAsync(id, culture);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction(nameof(Index));
        }

        ViewData["ActiveNav"] = "applications";
        return View(result.Data);
    }

    // POST /Admin/MentorApplications/Approve
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Approve(int id)
    {
        var adminUserId = User.GetUserId()!.Value;
        var result = await _mentors.ApproveApplicationAsync(adminUserId, id);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Application approved. Mentor has been notified." : result.Error;

        return RedirectToAction(nameof(Index));
    }

    // POST /Admin/MentorApplications/Reject
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Reject(RejectApplicationViewModel model)
    {
        if (!ModelState.IsValid)
        {
            TempData["Error"] = "Please provide a valid rejection reason.";
            return RedirectToAction(nameof(Details), new { id = model.ApplicationId });
        }

        var adminUserId = User.GetUserId()!.Value;
        var result = await _mentors.RejectApplicationAsync(adminUserId, model.ApplicationId, model.Reason);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Application rejected. Mentor has been notified." : result.Error;

        return RedirectToAction(nameof(Index));
    }

    // GET /Admin/MentorApplications/Download/5
    public async Task<IActionResult> Download(int id, string fileName)
    {
        
        var result = await _mentors.GetCertificationFileAsync(id);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction(nameof(Details), new { id });
        }

        var (stream, resolvedFileName) = result.Data;

        // Prefer filename from query if provided from view
        var finalFileName = string.IsNullOrWhiteSpace(fileName)
            ? resolvedFileName
            : Path.GetFileName(fileName);

        var provider = new FileExtensionContentTypeProvider();

        if (!provider.TryGetContentType(finalFileName, out var contentType))
            contentType = "application/octet-stream";

        return File(stream, contentType, finalFileName);
    }
}

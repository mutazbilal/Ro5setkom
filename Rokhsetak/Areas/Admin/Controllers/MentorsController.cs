using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Areas.Admin.ViewModels.Mentors;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;

namespace Rokhsetak.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Roles = "admin")]
public class MentorsController : Controller
{
    private readonly IMentorAdminService _mentors;
    private readonly IUserAdminService _users;

    public MentorsController(IMentorAdminService mentors, IUserAdminService users)
    {
        _mentors = mentors;
        _users = users;
    }

    // GET /Admin/Mentors
    public async Task<IActionResult> Index(MentorListFilter filter)
    {
        var result = await _mentors.GetMentorsAsync(filter);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return View(new MentorListViewModel { Filter = filter });
        }

        ViewData["ActiveNav"] = "mentors";
        return View(result.Data);
    }

    // GET /Admin/Mentors/Details/5
    public async Task<IActionResult> Details(int id)
    {
        var result = await _mentors.GetMentorDetailsAsync(id);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction(nameof(Index));
        }

        ViewData["ActiveNav"] = "mentors";
        return View(result.Data);
    }

    // POST /Admin/Mentors/Deactivate — deactivation goes through user admin
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Deactivate(int id)
    {
        var adminUserId = User.GetUserId()!.Value;
        var result = await _users.DeactivateUserAsync(adminUserId, id);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Mentor deactivated successfully." : result.Error;

        return RedirectToAction(nameof(Details), new { id });
    }

    // POST /Admin/Mentors/Reactivate
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Reactivate(int id)
    {
        var adminUserId = User.GetUserId()!.Value;
        var result = await _users.ReactivateUserAsync(adminUserId, id);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Mentor reactivated successfully." : result.Error;

        return RedirectToAction(nameof(Details), new { id });
    }
}

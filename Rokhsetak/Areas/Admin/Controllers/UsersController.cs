using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Areas.Admin.ViewModels.Users;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;
using System.Globalization;

namespace Rokhsetak.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Roles = "admin")]
public class UsersController : Controller
{
    private readonly IUserAdminService _users;

    public UsersController(IUserAdminService users)
    {
        _users = users;
    }

    // GET /Admin/Users
    public async Task<IActionResult> Index(UserListFilter filter)
    {
        var result = await _users.GetUsersAsync(filter);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return View(new UserListViewModel { Filter = filter });
        }

        ViewData["ActiveNav"] = "users";
        return View(result.Data);
    }

    // GET /Admin/Users/Details/5
    public async Task<IActionResult> Details(int id)
    {
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _users.GetUserDetailsAsync(id, culture);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction(nameof(Index));
        }

        ViewData["ActiveNav"] = "users";
        return View(result.Data);
    }

    // POST /Admin/Users/Deactivate
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Deactivate(int id, string? returnUrl = null)
    {
        var adminUserId = User.GetUserId()!.Value;
        var result = await _users.DeactivateUserAsync(adminUserId, id);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "User deactivated successfully." : result.Error;

        if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
            return Redirect(returnUrl);

        return RedirectToAction(nameof(Details), new { id });
    }

    // POST /Admin/Users/Reactivate
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Reactivate(int id, string? returnUrl = null)
    {
        var adminUserId = User.GetUserId()!.Value;
        var result = await _users.ReactivateUserAsync(adminUserId, id);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "User reactivated successfully." : result.Error;

        if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
            return Redirect(returnUrl);

        return RedirectToAction(nameof(Details), new { id });
    }
}

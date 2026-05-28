using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Areas.Admin.ViewModels.BlockedDates;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;

namespace Rokhsetak.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Roles = "admin")]
public class BlockedDatesController : Controller
{
    private readonly IBlockedDateService _blockedDates;

    public BlockedDatesController(IBlockedDateService blockedDates)
    {
        _blockedDates = blockedDates;
    }

    // GET /Admin/BlockedDates
    public async Task<IActionResult> Index()
    {
        var result = await _blockedDates.GetBlockedDatesAsync();
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return View(new BlockedDateListViewModel());
        }

        ViewData["ActiveNav"] = "blocked-dates";
        return View(result.Data);
    }

    // POST /Admin/BlockedDates/Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(CreateBlockedDateViewModel model)
    {
        if (!ModelState.IsValid)
        {
            TempData["Error"] = "Invalid date.";
            return RedirectToAction(nameof(Index));
        }

        var adminUserId = User.GetUserId()!.Value;
        var result = await _blockedDates.AddBlockedDateAsync(adminUserId, model);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Date blocked successfully." : result.Error;

        return RedirectToAction(nameof(Index));
    }

    // POST /Admin/BlockedDates/Delete
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        var adminUserId = User.GetUserId()!.Value;
        var result = await _blockedDates.RemoveBlockedDateAsync(adminUserId, id);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Blocked date removed." : result.Error;

        return RedirectToAction(nameof(Index));
    }
}

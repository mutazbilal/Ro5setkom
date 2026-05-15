using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;
using System.Text.Json;

namespace Rokhsetak.Areas.Trainee.Controllers;

[Area("Trainee")]
[Authorize(Roles = "trainee")]
public class CalendarController : Controller
{
    private readonly ICalendarService _calendar;

    public CalendarController(ICalendarService calendar)
    {
        _calendar = calendar;
    }

    public async Task<IActionResult> Index()
    {
        var userId = User.GetUserId().Value;
        var result = await _calendar.GetCalendarEventsAsync(userId);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index", "Dashboard");
        }

        // Serialize for FullCalendar
        var json = JsonSerializer.Serialize(result.Data, new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        });

        ViewBag.EventsJson = json;
        return View();
    }
}
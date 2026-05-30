using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Areas.Trainee.ViewModels.Booking;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;
using System.Globalization;

namespace Rokhsetak.Areas.Trainee.Controllers;

[Area("Trainee")]
[Authorize(Roles = "trainee")]
public class BookingController : Controller
{
    private readonly IBookingService _bookings;
    private readonly ITraineeDashboardService _dashboard;
    private readonly IConversationService _conversations;
    public BookingController(IBookingService bookings, ITraineeDashboardService dashboard, IConversationService conversations)
    {
        _bookings = bookings;
        _dashboard = dashboard;
        _conversations = conversations;
    }

    // GET /Trainee/Booking — my bookings list
    public async Task<IActionResult> Index()
    {
        var userId = User.GetUserId().Value;
        var result = await _bookings.GetMyBookingsAsync(userId);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index", "Dashboard");
        }

        return View(result.Data);
    }

    // GET /Trainee/Booking/Browse
    public async Task<IActionResult> Browse(
        MentorBrowseFilterViewModel filter)
    {
        var userId = User.GetUserId().Value;

        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _bookings.BrowseMentorsAsync(userId, filter, culture);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index", "Dashboard");
        }

        return View(result.Data);
    }

    // GET /Trainee/Booking/Book?mentorId=5
    public async Task<IActionResult> Book(int mentorId)
    {
        var userId = User.GetUserId().Value;
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _bookings.GetMentorBookingPageAsync(userId, mentorId, culture);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Browse");
        }

        return View(result.Data);
    }

    // POST /Trainee/Booking/Book
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Book(BookSessionViewModel model)
    {
        if (!ModelState.IsValid)
        {
            // Re-load page data on validation failure
            var userId2 = User.GetUserId().Value;
            var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
            var page = await _bookings.GetMentorBookingPageAsync(userId2, model.MentorId, culture);
            if (page.Succeeded) return View(page.Data);
            return RedirectToAction("Browse");
        }

        var userId = User.GetUserId().Value;
        var result = await _bookings.BookSessionAsync(userId, model);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Book", new { mentorId = model.MentorId });
        }

        TempData["Success"] = "Session booked! Awaiting mentor confirmation.";
        return RedirectToAction("Index");
    }

    // POST /Trainee/Booking/Cancel
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Cancel(int bookingId)
    {
        var userId = User.GetUserId().Value;
        var result = await _bookings.CancelSessionAsync(userId, bookingId);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Booking cancelled." : result.Error;

        return RedirectToAction("Index");
    }

    // GET /Trainee/Booking/Reschedule?bookingId=5
    public async Task<IActionResult> Reschedule(int bookingId)
    {
        var userId = User.GetUserId().Value;
        var result = await _bookings.GetReschedulePageAsync(userId, bookingId);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index");
        }

        return View(result.Data);
    }

    // POST /Trainee/Booking/Reschedule
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Reschedule(RescheduleTraineeViewModel model)
    {
        if (!ModelState.IsValid)
            return View(model);

        var userId = User.GetUserId().Value;
        var result = await _bookings.RescheduleSessionAsync(userId, model);

        if (!result.Succeeded)
        {
            ModelState.AddModelError(string.Empty, result.Error ?? "Reschedule failed.");
            return View(model);
        }

        TempData["Success"] = "Session rescheduled successfully.";
        return RedirectToAction("Index");
    }
    // POST /Trainee/Booking/RateSession
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Rate(RateSessionDto dto)
    {
        if (!ModelState.IsValid)
            return RedirectToAction("Index");

        var userId = User.GetUserId().Value;
        var result = await _bookings.RateSessionAsync(userId, dto.BookingId, dto.Score, review: dto.Review != null ? dto.Review : null);
        return RedirectToAction("Index");
    }

    // POST /Trainee/Booking/Message  — start/reuse a conversation with any mentor
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Message(int mentorId)
    {
        var traineeId = User.GetUserId().Value;
        var result = await _conversations.EnsureConversationExistsAsync(traineeId, mentorId);
        if (!result.Succeeded) return BadRequest(new { error = result.Error });
        return Json(new { conversationId = result.Data });
    }
}
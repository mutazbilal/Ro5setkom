using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Areas.Mentor.ViewModels.Appointments;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;
using System.Globalization;

namespace Rokhsetak.Areas.Mentor.Controllers;

[Area("Mentor")]
[Authorize(Roles = "mentor")]
public class AppointmentsController : Controller
{
    private readonly IAppointmentService _appointments;

    public AppointmentsController(IAppointmentService appointments)
    {
        _appointments = appointments;
    }

    // GET /Mentor/Appointments
    public async Task<IActionResult> Index()
    {
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var mentorId = User.GetUserId().Value;
        var result = await _appointments.GetAllAppointmentsAsync(mentorId, culture);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index", "Dashboard");
        }

        return View(result.Data);
    }

    // POST /Mentor/Appointments/Confirm
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Confirm(int bookingId)
    {
        var mentorId = User.GetUserId().Value;
        var result = await _appointments.ConfirmBookingAsync(mentorId, bookingId);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Booking confirmed." : result.Error;

        return RedirectToAction("Index");
    }

    // POST /Mentor/Appointments/MarkDone
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> MarkDone(int bookingId)
    {
        var mentorId = User.GetUserId().Value;
        var result = await _appointments.MarkAsDoneAsync(mentorId, bookingId);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Session marked as completed." : result.Error;

        return RedirectToAction("Index");
    }

    // POST /Mentor/Appointments/Cancel
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Cancel(int bookingId)
    {
        var mentorId = User.GetUserId().Value;
        var result = await _appointments.Cancel(mentorId, bookingId);

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Session cancelled." : result.Error;

        return RedirectToAction("Index");
    }

    // GET /Mentor/Appointments/Reschedule?bookingId=5
    public async Task<IActionResult> Reschedule(int bookingId)
    {
        var mentorId = User.GetUserId().Value;
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;

        // Load appointment data to pre-fill form
        var allResult = await _appointments.GetAllAppointmentsAsync(mentorId, culture);
        var booking = allResult.Data?.Items.FirstOrDefault(i => i.BookingId == bookingId);

        if (booking == null)
        {
            TempData["Error"] = "Booking not found.";
            return RedirectToAction("Index");
        }

        if (!booking.CanReschedule)
        {
            TempData["Error"] = "This booking cannot be rescheduled.";
            return RedirectToAction("Index");
        }

        var vm = new RescheduleViewModel
        {
            BookingId = bookingId,
            TraineeName = booking.TraineeName,
            SessionType = booking.SessionType,
            NewDate = booking.BookingDate.AddDays(1), // suggest next day as default
            NewStartTime = booking.StartTime,
            NewEndTime = booking.EndTime
        };

        return View(vm);
    }

    // POST /Mentor/Appointments/Reschedule
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Reschedule(RescheduleViewModel model)
    {
        if (!ModelState.IsValid)
            return View(model);

        var mentorId = User.GetUserId().Value;
        var result = await _appointments.RescheduleAsync(mentorId, model);

        if (!result.Succeeded)
        {
            ModelState.AddModelError(string.Empty, result.Error ?? "Reschedule failed.");
            return View(model);
        }

        TempData["Success"] = "Session rescheduled and trainee has been notified.";
        return RedirectToAction("Index");
    }

    // GET /Mentor/Appointments/Feedback?bookingId=5
    public async Task<IActionResult> Feedback(int bookingId)
    {
        var mentorId = User.GetUserId().Value;
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var allResult = await _appointments.GetAllAppointmentsAsync(mentorId, culture);
        var booking = allResult.Data?.Items.FirstOrDefault(i => i.BookingId == bookingId);

        if (booking == null)
        {
            TempData["Error"] = "Booking not found.";
            return RedirectToAction("Index");
        }

        if (!booking.CanFeedback)
        {
            TempData["Error"] = booking.FeedbackGiven
                ? "Feedback already submitted for this session."
                : "This session is not eligible for feedback yet.";
            return RedirectToAction("Index");
        }

        var vm = new FeedbackViewModel
        {
            BookingId = bookingId,
            TraineeName = booking.TraineeName,
            SessionDate = booking.BookingDate
        };

        return View(vm);
    }

    // POST /Mentor/Appointments/Feedback
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Feedback(FeedbackViewModel model)
    {
        if (!ModelState.IsValid)
            return View(model);

        var mentorId = User.GetUserId().Value;
        var result = await _appointments.GiveFeedbackAsync(mentorId, model);

        if (!result.Succeeded)
        {
            ModelState.AddModelError(string.Empty, result.Error ?? "Feedback submission failed.");
            return View(model);
        }

        TempData["Success"] = "Feedback submitted successfully.";
        return RedirectToAction("Index");
    }
}
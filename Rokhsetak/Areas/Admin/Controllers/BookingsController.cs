using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Areas.Admin.ViewModels.Bookings;
using Rokhsetak.Areas.Admin.ViewModels.Exams;
using Rokhsetak.Services.Interfaces;
using System.Globalization;

namespace Rokhsetak.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Roles = "admin")]
public class BookingsController : Controller
{
    private readonly IBookingAdminService _bookings;
    private readonly IExamAdminService _exams;

    public BookingsController(IBookingAdminService bookings, IExamAdminService exams)
    {
        _bookings = bookings;
        _exams = exams;
    }

    // GET /Admin/Bookings
    public async Task<IActionResult> Index(BookingFilter filter)
    {
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _bookings.GetBookingsAsync(filter, culture);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return View(new AdminBookingListViewModel { Filter = filter });
        }

        ViewData["ActiveNav"] = "bookings";
        ViewData["ActiveTab"] = "bookings";
        return View(result.Data);
    }

    // GET /Admin/Bookings/Exams
    public async Task<IActionResult> Exams(ExamFilter filter)
    {
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        var result = await _exams.GetExamAppointmentsAsync(filter, culture);
        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return View(new AdminExamAppointmentListViewModel { Filter = filter });
        }

        ViewData["ActiveNav"] = "bookings";
        ViewData["ActiveTab"] = "exams";
        return View(result.Data);
    }
}

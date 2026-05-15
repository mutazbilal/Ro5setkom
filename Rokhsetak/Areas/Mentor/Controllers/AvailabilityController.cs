using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Areas.Mentor.ViewModels.Availability;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;


namespace Rokhsetak.Areas.Mentor.Controllers
{
    [Area("Mentor")]
    [Authorize(Roles = "mentor")]
    public class AvailabilityController : Controller
    {
        private readonly IMentorAvailabilityService _mentorAvailabilityService;

        public AvailabilityController(IMentorAvailabilityService mentorService)
        {
            _mentorAvailabilityService = mentorService;
        }

        // ----------------------------
        // VIEW AVAILABILITY
        // ----------------------------
        public async Task<IActionResult> Index()
        {
            
            var mentorId = User.GetUserId().Value;
            if (mentorId == null)
                return Unauthorized();

            // NOTE: you need a method to fetch slots (if not implemented yet)
            var slots = await _mentorAvailabilityService.GetSlotsAsync(mentorId);

            return View(slots);
        }

        // ----------------------------
        // ADD SLOT
        // ----------------------------
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddSlot(MentorAvailabilityViewModel model)
        {
            if (!ModelState.IsValid)
                return RedirectToAction("Availability");

            var mentorId = User.GetUserId();
            if (mentorId == null)
                return Unauthorized();

            var result = await _mentorAvailabilityService.AddSlotAsync(mentorId.Value, model);

            if (!result.Succeeded)
                TempData["Error"] = result.Error;
            else
                TempData["Success"] = "Slot added successfully.";
            return RedirectToAction("Index");
        }

        // ----------------------------
        // EDIT SLOT
        // ----------------------------
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EditSlot(int slotId, MentorAvailabilityViewModel model)
        {
            if (!ModelState.IsValid)
                return RedirectToAction("Availability");

            var mentorId = User.GetUserId();
            if (mentorId == null)
                return Unauthorized();

            var result = await _mentorAvailabilityService.EditSlotAsync(mentorId.Value, slotId, model);

            if (!result.Succeeded)
                TempData["Error"] = result.Error;
            else
                TempData["Success"] = "Slot edited successfully.";
            return RedirectToAction("Index");
        }

        // ----------------------------
        // DEACTIVATE SLOT
        // ----------------------------
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeactivateSlot(int slotId)
        {
            var mentorId = User.GetUserId();
            if (mentorId == null)
                return Unauthorized();

            var result = await _mentorAvailabilityService.DeactivateSlotAsync(mentorId.Value, slotId);

            if (!result.Succeeded)
                TempData["Error"] = result.Error;
            else
                TempData["Success"] = "Slot deactivated successfully.";
            return RedirectToAction("Index");
        }
    }
}

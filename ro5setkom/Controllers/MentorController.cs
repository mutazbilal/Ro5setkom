using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc;
using ro5setkom.Services.Interfaces;
using ro5setkom.Utils;
using ro5setkom.ViewModels.Mentor;
using ro5setkom.ViewModels.Profile;


namespace ro5setkom.Controllers
{
    [Authorize(Roles = "Mentor")]
    public class MentorController : Controller
    {
        private readonly IMentorService _mentorService;

        public MentorController(IMentorService mentorService)
        {
            _mentorService = mentorService;
        }

        // ----------------------------
        // VIEW AVAILABILITY
        // ----------------------------
        public async Task<IActionResult> Availability()
        {
            var mentorId = User.GetUserId().Value;
            if (mentorId == null)
                return Unauthorized();

            // NOTE: you need a method to fetch slots (if not implemented yet)
            var slots = await _mentorService.GetSlotsAsync(mentorId);

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

            var result = await _mentorService.AddSlotAsync(mentorId.Value, model);

            if (!result.Succeeded)
                TempData["Error"] = result.Error;

            return RedirectToAction("Availability");
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

            var result = await _mentorService.EditSlotAsync(mentorId.Value, slotId, model);

            if (!result.Succeeded)
                TempData["Error"] = result.Error;

            return RedirectToAction("Availability");
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

            var result = await _mentorService.DeactivateSlotAsync(mentorId.Value, slotId);

            if (!result.Succeeded)
                TempData["Error"] = result.Error;

            return RedirectToAction("Availability");
        }
    }
}

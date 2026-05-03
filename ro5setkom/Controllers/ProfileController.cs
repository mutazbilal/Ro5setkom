using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Mvc;
using Org.BouncyCastle.Bcpg;
using ro5setkom.Models;
using ro5setkom.Services.Implementations;
using ro5setkom.Services.Interfaces;
using ro5setkom.Utils;
using ro5setkom.ViewModels.Profile;
using System.Security.Claims;

namespace ro5setkom.Controllers
{
    [Authorize]
    public class ProfileController : Controller
    {
        private readonly IProfileService _service;
        private readonly ILicenseService _licenseService;

        public ProfileController(IProfileService service, ILicenseService licenseService)
        {
            _service = service;
            _licenseService = licenseService;
        }

        public async Task<IActionResult> Index()
        {
            var userId = User.GetUserId().Value;

            if (userId == null)
            {
                return Unauthorized();
            }
            var model = await _service.GetProfileAsync(userId);
            return View(model.Data);
        }

        public async Task<IActionResult> Edit()
        {
            if (!User.Identity?.IsAuthenticated ?? false)
                return Unauthorized();

            var userId = User.GetUserId().Value;

            if (userId == null)
            {
                return Unauthorized();
            }

            var profile = await _service.GetProfileAsync(userId);

            return View(new EditProfileViewModel
            {
                Email = profile.Data.Email,
                PhoneNumber = profile.Data.PhoneNumber,
                Province = profile.Data.Province,
                City = profile.Data.City,
                AddressLine1 = profile.Data.AddressLine1,
                AddressLine2 = profile.Data.AddressLine2,
                PostalCode = profile.Data.PostalCode,

                FirstName = profile.Data.FirstName,
                LastName = profile.Data.LastName,
                DateOfBirth = profile.Data.DateOfBirth,
                Gender = profile.Data.Gender,
                NationalId = profile.Data.NationalId,
            });
        }

        [HttpPost]
        public async Task<IActionResult> Edit(EditProfileViewModel model)
        {
            if (!User.Identity?.IsAuthenticated ?? false)
                return Unauthorized();
            if (!ModelState.IsValid) return View(model);

            var userId = User.GetUserId().Value;

            if (userId == null)
            {
                return Unauthorized();
            }
            await _service.UpdateProfileAsync(userId, model);

            return RedirectToAction("Index");
        }

        [HttpGet]
        public async Task<IActionResult> LanguagePreference()
        {
            var userId = User.GetUserId();
            if (userId == null)
                return Unauthorized();

            var profile = await _service.GetProfileAsync(userId.Value);

            if (!profile.Succeeded)
                return RedirectToAction("Index"); // or handle error properly

            var model = new LanguagePreferenceViewModel
            {
                Language = profile.Data.LanguagePreference ?? "ar"
            };

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangeLanguage(LanguagePreferenceViewModel model)
        {
            var userId = User.GetUserId();
            if (userId == null)
                return Unauthorized();

            await _service.ChangeLanguageAsync(userId.Value, model.Language);

            Response.Cookies.Append(
                CookieRequestCultureProvider.DefaultCookieName,
                CookieRequestCultureProvider.MakeCookieValue(new RequestCulture(model.Language)),
                new CookieOptions { Expires = DateTimeOffset.UtcNow.AddYears(1) }
            );

            if (!string.IsNullOrWhiteSpace(model.ReturnUrl) && Url.IsLocalUrl(model.ReturnUrl))
                return Redirect(model.ReturnUrl);

            return RedirectToAction("Index", "Home");
        }

        [HttpGet]
        [Authorize (Roles = "trainee")]
        public async Task<IActionResult> ChangeLicense()
        {
            var licenseTypes = await _licenseService.GetLicenseTypesAsync();
            var model = new ChangeLicenseViewModel
            {
                AvailableLicenseTypes = licenseTypes
            };
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = "trainee")]
        public async Task<IActionResult> ChangeLicense(ChangeLicenseViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var userId = User.GetUserId();
            if (userId == null)
                return Unauthorized();

            var result = await _service.ChangeLicenseAsync(userId.Value, model.NewLicenseTypeId);

            if (!result.Succeeded)
            {
                ModelState.AddModelError("", result.Error);
                return View(model);
            }

            return RedirectToAction("Index");
        }
    }
}

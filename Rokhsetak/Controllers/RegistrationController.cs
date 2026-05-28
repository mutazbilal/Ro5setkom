using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.ViewModels.Registration;
using System.Globalization;
using System.Text.Json;

namespace Rokhsetak.Controllers;

/// <summary> 
/// Thin controller for US-001 (Trainee Registration) and US-002 (Mentor Registration).
///
/// Flow for both roles is identical at the HTTP level:
///   Step 1 – GET  /Register/Trainee (or /Register/Mentor) → National ID lookup form
///   Step 2 – POST /Register/LookupNationalId              → service validates; prepopulates form
///   Step 3 – POST /Register/CompleteTrainee (or Mentor)   → service creates all DB records
///
/// All business rules live in IRegistrationService. This controller only:
///   - Binds input models
///   - Passes client IP to the service
///   - Renders views or redirects on completion
/// </summary>
[AllowAnonymous]
public class RegistrationController : Controller
{
    private readonly IRegistrationService _registrationService;
    private readonly ILogger<RegistrationController> _logger;
    private readonly ILookupService _lookupService;
    public RegistrationController(
        IRegistrationService registrationService,
        ILogger<RegistrationController> logger,
        ILookupService licenseService)
    {
        _registrationService = registrationService;
        _logger              = logger;
        _lookupService      = licenseService;
    }

    [HttpGet]
    public IActionResult Index()
    {
        return View();
    }
  
    // ─────────────────────────────────────────────────────────────────────────
    // US-001 – Trainee Registration Entry
    // ─────────────────────────────────────────────────────────────────────────
    [HttpGet]
    public IActionResult Trainee()
        => View("NationalIdLookup", new NationalIdLookupViewModel { IsTrainee = true });

    // ─────────────────────────────────────────────────────────────────────────
    // US-002 – Mentor Registration Entry
    // ─────────────────────────────────────────────────────────────────────────
    [HttpGet]
    public IActionResult Mentor()
        => View("NationalIdLookup", new NationalIdLookupViewModel { IsTrainee = false });

    // ─────────────────────────────────────────────────────────────────────────
    // Step 1 → Step 2: National ID lookup (shared by both flows)
    // ─────────────────────────────────────────────────────────────────────────
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> LookupNationalId(NationalIdLookupViewModel model)
    {
        if (!ModelState.IsValid)
            return View("NationalIdLookup", model);

        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;

        var result = await _registrationService.LookupNationalIdAsync( 
            model.NationalId, model.IsTrainee, culture);

        if (!result.Succeeded)
        {
            ModelState.AddModelError(string.Empty, result.Error);
            return View("NationalIdLookup", model);
        }

        var citizen          = result.Data!;
        var licenseTypes     = await _lookupService.GetLicenseTypesAsync(culture = culture != null ? culture :"ar");
        var trainingCenters = await _lookupService.GetTrainingCentersAsync(culture = culture != null? culture :"ar");
        var cities = await _lookupService.GetCitiesAsync(culture = culture != null ? culture : "ar");
        var provinces = await _lookupService.GetProvincesAsync(culture = culture != null ? culture : "ar");

        if (model.IsTrainee)
        {
            var vm = new TraineeRegistrationViewModel
            {
                NationalId   = citizen.NationalId,
                FirstName    = citizen.FirstName,
                LastName     = citizen.LastName,
                DateOfBirth  = citizen.DateOfBirth,
                Gender       = citizen.Gender,
                AddressLine1 = citizen.AddressLine1,
                AddressLine2 = citizen.AddressLine2,
                PostalCode   = citizen.PostalCode,
                AvailableLicenseTypes = licenseTypes,
                Provinces = provinces,
                Cities = cities,
                CityId = citizen.CityId,
                ProvinceId = citizen.ProvinceId
            };
            _logger.LogInformation("National ID {NationalId} found for trainee registration. Prepopulating form.", model.NationalId);
            return View("CompleteTrainee", vm);
        }
        else
        {
            var vm = new MentorRegistrationViewModel
            {
                NationalId   = citizen.NationalId,
                FirstName    = citizen.FirstName,
                LastName     = citizen.LastName,
                DateOfBirth  = citizen.DateOfBirth,
                Gender       = citizen.Gender,
                AddressLine1 = citizen.AddressLine1,
                AddressLine2 = citizen.AddressLine2,
                PostalCode   = citizen.PostalCode,
                AvailableLicenseTypes = licenseTypes,
                AvailableTrainingCenters = trainingCenters,
                Provinces = provinces,
                Cities = cities,
                CityId = citizen.CityId,
                ProvinceId = citizen.ProvinceId
            };
            return View("CompleteMentor", vm);
        }
    }
    [HttpGet]
   public IActionResult SelectRole() => View();

    // ─────────────────────────────────────────────────────────────────────────
    // US-001 – Complete Trainee Registration
    // ─────────────────────────────────────────────────────────────────────────
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> CompleteTrainee(TraineeRegistrationViewModel model)
    {
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        string jsonString = JsonSerializer.Serialize(model);
        if (!ModelState.IsValid)
        {
            _logger.LogInformation("model state is invlaid");
            _logger.LogInformation(jsonString);
            model.AvailableLicenseTypes = await _lookupService.GetLicenseTypesAsync(culture = culture != null ? culture : "ar");
            var cities = await _lookupService.GetCitiesAsync(culture = culture != null ? culture : "ar");
            var provinces = await _lookupService.GetProvincesAsync(culture = culture != null ? culture : "ar");
            model.Cities = cities;
            model.Provinces = provinces;
            return View(model);
        }
        _logger.LogInformation("model state is valid");
        _logger.LogInformation(jsonString);

        var result = await _registrationService.RegisterTraineeAsync(model, GetClientIp());

        if (!result.Succeeded)
        {
            ModelState.AddModelError(string.Empty, result.Error!);
            model.AvailableLicenseTypes = await _lookupService.GetLicenseTypesAsync(culture = culture != null ? culture : "ar");
            return View(model);
        }

        TempData["SuccessMessage"] =
            "Registration successful! You can now log in with your National ID and password.";
        return RedirectToAction("Login", "Auth"); 
    }

    // ─────────────────────────────────────────────────────────────────────────
    // US-002 – Complete Mentor Registration
    // ─────────────────────────────────────────────────────────────────────────
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> CompleteMentor(MentorRegistrationViewModel model)
    {
        var culture = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        if (!ModelState.IsValid)
        {
            model.AvailableLicenseTypes = await _lookupService.GetLicenseTypesAsync(culture = culture != null ? culture : "ar");
            model.AvailableTrainingCenters = await _lookupService.GetTrainingCentersAsync(culture = culture != null ? culture : "ar");
            return View(model);
        }

        var result = await _registrationService.RegisterMentorAsync(model, GetClientIp());

        if (!result.Succeeded)
        {
            ModelState.AddModelError(string.Empty, result.Error!);
            model.AvailableLicenseTypes = await _lookupService.GetLicenseTypesAsync(culture = culture != null ? culture : "ar");
            model.AvailableTrainingCenters = await _lookupService.GetTrainingCentersAsync(culture = culture != null ? culture : "ar");
            return View(model);
        }

        TempData["SuccessMessage"] =
            "Your mentor application has been submitted. " +
            "You will be notified by email once an admin reviews your application.";
        return RedirectToAction("MentorPending");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Mentor pending approval landing page
    // ─────────────────────────────────────────────────────────────────────────
    [HttpGet]
    public IActionResult MentorPending() => View();

    // ── Private helpers ───────────────────────────────────────────────────────
    private string GetClientIp()
        => HttpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown";
}

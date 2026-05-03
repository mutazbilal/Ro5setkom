using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ro5setkom.Services.Interfaces;
using ro5setkom.ViewModels.Auth;
using System.Security.Claims;
using System.Text.Json;

namespace ro5setkom.Controllers;

/// <summary>
/// Thin controller for US-003 (Login), US-004 (Password Reset).
///
/// Responsibilities:
///   - Receive HTTP request / bind ViewModel
///   - Delegate ALL business logic to IAuthService / IPasswordResetService
///   - Issue or remove the authentication cookie
///   - Redirect to the correct dashboard based on role
///   - Return views with errors from service results
/// </summary>
public class AuthController : Controller
{
    private readonly IAuthService _authService;
    private readonly IPasswordResetService _passwordResetService;
    private readonly ILogger<AuthController> _logger;

    public AuthController(
        IAuthService authService,
        IPasswordResetService passwordResetService,
        ILogger<AuthController> logger)
    {
        _authService = authService;
        _passwordResetService = passwordResetService;
        _logger = logger;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // US-003 – Login
    // ─────────────────────────────────────────────────────────────────────────
    [HttpGet]
    [AllowAnonymous]
    public IActionResult Login(string? returnUrl = null)
    {
        if (User.Identity?.IsAuthenticated == true)
        {
            _logger.LogInformation("user is already signed in " +
                "redirecting to");
            return RedirectToDashboard();
        }
        ViewData["ReturnUrl"] = returnUrl;
        return View(new LoginViewModel());
    }

    [HttpPost]
    [AllowAnonymous]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Login(LoginViewModel model, string? returnUrl = null)
    {
        string jsonString = JsonSerializer.Serialize(model);
        if (!ModelState.IsValid)
        {
            _logger.LogError("model invalid");
            _logger.LogInformation(jsonString);
            return View(model);
        }
            

        var ipAddress = GetClientIp();
        var result = await _authService.LoginAsync(model, ipAddress);
        
        if (!result.Succeeded)
        {            
            ModelState.AddModelError(string.Empty, result.Error!);
            return View(model);
        }

        // Build claims identity
        var loginData = result.Data!;
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, loginData.UserId.ToString()),
            new(ClaimTypes.Name,           loginData.NationalId),
            new("FullName",                loginData.FullName),
            new(ClaimTypes.Role,           loginData.RoleName),
            new("RoleId",                  loginData.RoleId.ToString()),
            new("language",                loginData.Language)
        };

        var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
        var principal = new ClaimsPrincipal(identity);

        var authProperties = new AuthenticationProperties
        {
            IsPersistent = model.RememberMe,
            ExpiresUtc = model.RememberMe
                ? DateTimeOffset.UtcNow.AddDays(14)
                : DateTimeOffset.UtcNow.AddHours(8)
        };

        await HttpContext.SignInAsync(
            CookieAuthenticationDefaults.AuthenticationScheme,
            principal,
            authProperties);

        _logger.LogInformation(
            "User {UserId} ({Role}) logged in from IP {IP}",
            loginData.UserId, loginData.RoleName, ipAddress);

        if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
            return Redirect(returnUrl);
        _logger.LogInformation("{user.UserId} is logged in: redirecting to dashboard", claims);
        return RedirectToRoleDashboard(loginData.RoleName);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Logout
    // ─────────────────────────────────────────────────────────────────────────
    [HttpPost]
    [Authorize]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Logout()
    {
        var userId = int.TryParse(
            User.FindFirstValue(ClaimTypes.NameIdentifier), out var id) ? id : 0;

        await _authService.LogoutAsync(userId);
        await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);

        return RedirectToAction(nameof(Login));
    }

    // ─────────────────────────────────────────────────────────────────────────
    // US-004 – Password Reset: Request
    // ─────────────────────────────────────────────────────────────────────────
    [HttpGet]
    [AllowAnonymous]
    public IActionResult ForgotPassword() => View(new ForgotPasswordViewModel());

    [HttpPost]
    [AllowAnonymous]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> ForgotPassword(ForgotPasswordViewModel model)
    {
        if (!ModelState.IsValid)
            return View(model);

        // Service always returns success to prevent email enumeration
        await _passwordResetService.RequestResetAsync(model);

        TempData["SuccessMessage"] =
            "If an account with that email exists, a password reset link has been sent.";

        return RedirectToAction(nameof(ForgotPasswordConfirmation));
    }

    [HttpGet]
    [AllowAnonymous]
    public IActionResult ForgotPasswordConfirmation() => View();

    // ─────────────────────────────────────────────────────────────────────────
    // US-004 – Password Reset: Complete
    // ─────────────────────────────────────────────────────────────────────────
    [HttpGet]
    [AllowAnonymous]
    public IActionResult ResetPassword(string? token)
    {
        if (string.IsNullOrWhiteSpace(token))
        {
            TempData["ErrorMessage"] = "Invalid password reset link.";
            return RedirectToAction(nameof(Login));
        }

        return View(new ResetPasswordViewModel { Token = token });
    }

    [HttpPost]
    [AllowAnonymous]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> ResetPassword(ResetPasswordViewModel model)
    {
        if (!ModelState.IsValid)
            return View(model);

        var result = await _passwordResetService.ResetPasswordAsync(model);

        if (!result.Succeeded)
        {
            ModelState.AddModelError(string.Empty, result.Error!);
            return View(model);
        }

        TempData["SuccessMessage"] = "Your password has been reset successfully. Please log in.";
        return RedirectToAction(nameof(Login));
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Access Denied
    // ─────────────────────────────────────────────────────────────────────────
    [HttpGet]
    public IActionResult AccessDenied() => View();

    // ── Private helpers ───────────────────────────────────────────────────────
    private IActionResult RedirectToDashboard()
    {
        var role = User.FindFirstValue(ClaimTypes.Role) ?? string.Empty;
        _logger.LogInformation("Dashboard: {role}", role);
        return RedirectToRoleDashboard(role);
    }

    private IActionResult RedirectToRoleDashboard(string role) => role switch
    {
        //change to actual controllers
        "admin" => RedirectToAction("Index", "Home"),
        "mentor" => RedirectToAction("Index", "Home"),
        "trainee" => RedirectToAction("Index", "Home"),
        _ => RedirectToAction(nameof(Login))
    };

    private string GetClientIp()
        => HttpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown";
}

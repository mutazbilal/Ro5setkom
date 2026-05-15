using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Localization;
using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;
using Rokhsetak.Services.Implementations;
using Rokhsetak.Services.Interfaces;
using System.Globalization;


var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<Ro5setkomDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddLocalization(opts => opts.ResourcesPath = "Resources");

builder.Services.AddControllersWithViews()
    .AddViewLocalization()
    .AddDataAnnotationsLocalization(opts =>
    {
        opts.DataAnnotationLocalizerProvider = (type, factory) =>
            factory.Create(typeof(Rokhsetak.Resources.SharedResourceMarker));
    });

// ─────────────────────────────────────────────────────────────────────────────
// Authentication – Cookie-based (no ASP.NET Identity, purely custom)
// ─────────────────────────────────────────────────────────────────────────────
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/Auth/Login";
        options.LogoutPath = "/Auth/Logout";
        options.AccessDeniedPath = "/Auth/AccessDenied";
        options.ExpireTimeSpan = TimeSpan.FromHours(8);
        options.SlidingExpiration = true;

        // Security hardening
        options.Cookie.HttpOnly = true;
        options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
        options.Cookie.SameSite = SameSiteMode.Strict;
        options.Cookie.Name = "Rokhsetak.auth";
    });

builder.Services.AddAuthorization();

// ─────────────────────────────────────────────────────────────────────────────
// Application services (scoped – one instance per HTTP request)
// ─────────────────────────────────────────────────────────────────────────────
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IRegistrationService, RegistrationService>();
builder.Services.AddScoped<IPasswordResetService, PasswordResetService>();
builder.Services.AddScoped<IProfileService, ProfileService>();
builder.Services.AddScoped<IEmailService, EmailService>();
builder.Services.AddScoped<IMentorAvailabilityService, MentorAvailabilityService>();
builder.Services.AddScoped<INotificationService, NotificationService>();
builder.Services.AddScoped<ILicenseService, LicenseService>();

builder.Services.AddScoped<ITraineeDashboardService, TraineeDashboardService>();
builder.Services.AddScoped<IModuleService, ModuleService>();
builder.Services.AddScoped<IQuizService, QuizService>();

builder.Services.AddScoped<IMentorDashboardService, MentorDashboardService>();
builder.Services.AddScoped<IAppointmentService, AppointmentService>();

builder.Services.AddScoped<IBookingService, BookingService>();
builder.Services.AddScoped<IExamAppointmentService, ExamAppointmentService>();
builder.Services.AddScoped<ICalendarService, CalendarService>();

// IHttpContextAccessor required by PasswordResetService to build reset URLs
builder.Services.AddHttpContextAccessor();


// ─────────────────────────────────────────────────────────────────────────────
// Anti-forgery (CSRF protection)
// ─────────────────────────────────────────────────────────────────────────────
builder.Services.AddAntiforgery(options =>
{
    options.Cookie.Name = "Rokhsetak.xsrf";
    options.Cookie.HttpOnly = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
    options.Cookie.SameSite = SameSiteMode.Strict;
});

var app = builder.Build();

var supportedCultures = new[] { "en", "ar" };
app.UseRequestLocalization(new RequestLocalizationOptions()
    .SetDefaultCulture("ar")
    .AddSupportedCultures(supportedCultures)
    .AddSupportedUICultures(supportedCultures));

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "areas",
    pattern: "{area:exists}/{controller=Dashboard}/{action=Index}/{id?}");

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();


app.Run();
public partial class Program { }
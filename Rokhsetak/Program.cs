using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Localization;
using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;
using Rokhsetak.Services.Chat;
using Rokhsetak.Services.Chat.Implementations;
using Rokhsetak.Services.Chat.Implementations.Providers;
using Rokhsetak.Services.Implementations;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;
using Rokhsetak.Workers;
using System.Globalization;


var builder = WebApplication.CreateBuilder(args);

var conn = builder.Configuration.GetConnectionString("RokhsetakDB");
builder.Services.AddDbContext<RokhsetakDbContext>(options =>
    options.UseSqlServer(conn));

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
builder.Services.AddScoped<ILookupService, LookupService>();

builder.Services.AddScoped<ITraineeDashboardService, TraineeDashboardService>();
builder.Services.AddScoped<IModuleService, ModuleService>();
builder.Services.AddScoped<IQuizService, QuizService>();

builder.Services.AddScoped<IMentorDashboardService, MentorDashboardService>();
builder.Services.AddScoped<IAppointmentService, AppointmentService>();

builder.Services.AddScoped<IBookingService, BookingService>();
builder.Services.AddScoped<IExamAppointmentService, ExamAppointmentService>();
builder.Services.AddScoped<ICalendarService, CalendarService>();
builder.Services.AddScoped<IRecurringExamSchedulerService, RecurringExamSchedulerService>();

builder.Services.AddHostedService<ExamSchedulerWorker>();
builder.Services.AddHostedService<ExamResultSimulatorWorker>();

builder.Services.AddScoped<IAnalyticsService, AnalyticsService>();
builder.Services.AddScoped<IBookingAdminService, BookingAdminService>();
builder.Services.AddScoped<IBlockedDateService, BlockedDateService>();
builder.Services.AddScoped<IAuditService, AuditService>();
builder.Services.AddScoped<IExamAdminService, ExamAdminService>();
builder.Services.AddScoped<IUserAdminService, UserAdminService>();
builder.Services.AddScoped<IMentorAdminService, MentorAdminService>();

builder.Services.AddScoped<IChatProvider, HumanChatProvider>();
builder.Services.AddScoped<IChatProvider, AiChatProvider>();
builder.Services.AddScoped<IChatProviderRegistry, ChatProviderRegistry>();
builder.Services.Configure<DeepSeekOptions>(builder.Configuration.GetSection("DeepSeek"));
builder.Services.AddHttpClient<IAiResponder, DeepSeekAiResponder>();

// Program.cs or a dedicated extension method

builder.Services.AddScoped<IUserContextProvider, UserContextProvider>();
builder.Services.AddScoped<ILicenseContextProvider, LicenseContextProvider>();
builder.Services.AddScoped<ILearningContextProvider, LearningContextProvider>();
builder.Services.AddScoped<IBookingContextProvider, BookingContextProvider>();
builder.Services.AddSingleton<IPageContextProvider, PageContextProvider>(); // pure in-memory
builder.Services.AddScoped<IAiContextAssembler, AiContextAssembler>();
builder.Services.AddSingleton<IAiPromptBuilder, AiPromptBuilder>();     // stateless
builder.Services.AddScoped<StageLocalizer>();

builder.Services.AddScoped<IBlobService, BlobService>();

// ── Messaging (US-024 + US-025) ───────────────────────────────────────────────
builder.Services.AddScoped<IConversationService, ConversationService>();

// ── File upload size limit (must be set before app.Build()) ───────────────────
builder.Services.Configure<Microsoft.AspNetCore.Http.Features.FormOptions>(opts =>
{
    opts.MultipartBodyLengthLimit = 11 * 1024 * 1024; // 11 MB ceiling
});

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
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Admin.ViewModels.MentorApplications;
using Rokhsetak.Areas.Admin.ViewModels.Mentors;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;
using System.Text.RegularExpressions;

namespace Rokhsetak.Services.Implementations;

public class MentorAdminService : IMentorAdminService
{
    private readonly RokhsetakDbContext _context;
    private readonly IAuditService _audit;
    private readonly INotificationService _notifications;
    private readonly IEmailService _email;
    private readonly IWebHostEnvironment _env;
    private readonly IBlobService _blobService;
    private readonly ILookupService _lookupService;

    private const string CertificationsRelative = "uploads/certifications";

    public MentorAdminService(
        RokhsetakDbContext context,
        IAuditService audit,
        INotificationService notifications,
        IEmailService email,
        IWebHostEnvironment env,
        IBlobService blobservice,
        ILookupService lookupService)
    {
        _context = context;
        _audit = audit;
        _notifications = notifications;
        _email = email;
        _env = env;
        _blobService = blobservice;
        _lookupService = lookupService;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // LIST MENTORS
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<MentorListViewModel>> GetMentorsAsync(MentorListFilter filter, string culture)
    {
        if (filter.Page < 1) filter.Page = 1;
        if (filter.PageSize < 1 || filter.PageSize > 100) filter.PageSize = 20;

        var query =
            from m in _context.Mentors.AsNoTracking()
            join u in _context.Users on m.MentorId equals u.UserId into uj
            from u in uj.DefaultIfEmpty()
            join lt in _context.LicenseTypes on m.LicenseTypeId equals lt.LicenseTypeId into ltj
            from lt in ltj.DefaultIfEmpty()
            join app in _context.MentorApplications on m.ApplicationId equals app.ApplicationId into appj
            from app in appj.DefaultIfEmpty()
            join ct in _context.Cities on m.CityId equals ct.CityId into ctj
            from ct in ctj.DefaultIfEmpty()
            select new
            {
                m,
                u,
                LicenseName = culture == "ar"? lt.DisplayNameAr : lt.DisplayNameEn,
                AppStatus = app != null ? app.Status : "—",
                CityName = ct.CityTranslations
                    .Where(c => c.CityId == m.CityId && c.LanguageCode == culture)
                    .Select(c => c.DisplayName)
                    .FirstOrDefault()
            };

        if (filter.LicenseTypeId.HasValue)
            query = query.Where(x => x.m.LicenseTypeId == filter.LicenseTypeId.Value);

        if (filter.CityId.HasValue)
            query = query.Where(x => x.u.CityId == filter.CityId);

        if (!string.IsNullOrWhiteSpace(filter.Status))
        {
            var status = filter.Status.ToLower();

            query = status switch
            {
                "pending" => query.Where(x => x.AppStatus == "pending"),

                "active" => query.Where(x =>
                    x.AppStatus == "approved" &&
                    x.u.IsActive == true),

                "inactive" => query.Where(x =>
                    x.u.IsActive == false),

                _ => query
            };
        }

        if (!string.IsNullOrWhiteSpace(filter.Search))
        {
            var s = filter.Search.Trim().ToLower();
            query = query.Where(x =>
                x.u.Email.ToLower().Contains(s) ||
                (x.u.FirstName + " " + x.u.LastName).ToLower().Contains(s));
        }

        var total = await query.CountAsync();

        var page = await query
            .OrderByDescending(x => x.m.CreatedAt)
            .Skip((filter.Page - 1) * filter.PageSize)
            .Take(filter.PageSize)
            .Select(x => new
            {
                x.m.MentorId,
                x.u.FirstName,
                x.u.LastName,
                x.u.Email,
                x.u.PhoneNumber,
                x.u.IsActive,
                x.m.PricePerSession,
                x.CityName,
                x.LicenseName,
                x.AppStatus,
                x.u.DisplayNameEn
            })
            .ToListAsync();

        var ids = page.Select(p => p.MentorId).ToList();

        var ratingStats = await _context.Ratings
            .Where(r => ids.Contains(r.MentorId))
            .GroupBy(r => r.MentorId)
            .Select(g => new { MentorId = g.Key, Avg = (double)g.Average(r => r.Score) })
            .ToDictionaryAsync(x => x.MentorId, x => x.Avg);

        var sessionStats = await _context.Bookings
            .Where(b => ids.Contains(b.MentorId))
            .GroupBy(b => b.MentorId)
            .Select(g => new { MentorId = g.Key, Total = g.Count() })
            .ToDictionaryAsync(x => x.MentorId, x => x.Total);

        var items = page.Select(p => new MentorListItem
        {
            MentorId = p.MentorId,
            FullName = culture == "ar"? $"{p.FirstName} {p.LastName}" :p.DisplayNameEn,
            Email = p.Email,
            PhoneNumber = p.PhoneNumber,
            LicenseType = p.LicenseName,
            CityName = p.CityName,
            PricePerSession = p.PricePerSession,
            IsActive = p.AppStatus == "approved",
            ApplicationStatus = p.AppStatus,
            AverageRating = ratingStats.TryGetValue(p.MentorId, out var avg) ? Math.Round(avg, 2) : 0,
            TotalSessions = sessionStats.TryGetValue(p.MentorId, out var t) ? t : 0
        }).ToList();

        var licenseTypeOptions = await _context.LicenseTypes
            .AsNoTracking()
            .OrderBy(l => l.LicenseName)
            .Select(l => new { l.LicenseTypeId, l.LicenseName })
            .ToListAsync();

        var cities = await _lookupService.GetCitiesAsync(culture);

        return ServiceResult<MentorListViewModel>.Success(new MentorListViewModel
        {
            Filter = filter,
            Items = items,
            TotalCount = total,
            LicenseTypeOptions = licenseTypeOptions
                .Select(o => (o.LicenseTypeId, o.LicenseName))
                .ToList(),
            Cities = cities
        });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // MENTOR DETAILS
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<MentorDetailViewModel>> GetMentorDetailsAsync(int mentorId, string culture)
    {
        var data = await (
            from m in _context.Mentors.AsNoTracking()
            join u in _context.Users on m.MentorId equals u.UserId
            join lt in _context.LicenseTypes on m.LicenseTypeId equals lt.LicenseTypeId into ltj
            from lt in ltj.DefaultIfEmpty()
            join app in _context.MentorApplications on m.ApplicationId equals app.ApplicationId into appj
            from app in appj.DefaultIfEmpty()
            join ct in _context.Cities on m.CityId equals ct.CityId into ctj
            from ct in ctj.DefaultIfEmpty()
            where m.MentorId == mentorId
            select new
            {
                m,
                u,
                LicenseName = culture == "ar" ? lt.DisplayNameAr : lt.DisplayNameEn,
                AppStatus = app != null ? app.Status : "—",
                CityName = ct.CityTranslations
                    .Where(c => c.CityId == m.CityId && c.LanguageCode == culture)
                    .Select(c => c.DisplayName)
                    .FirstOrDefault()
            }
        ).FirstOrDefaultAsync();

        if (data == null) return ServiceResult<MentorDetailViewModel>.Failure("Mentor not found.");

        var ratingAgg = await _context.Ratings
            .Where(r => r.MentorId == mentorId)
            .GroupBy(r => 1)
            .Select(g => new { Avg = g.Average(r => (double)r.Score), Count = g.Count() })
            .FirstOrDefaultAsync();

        var totalSessions = await _context.Bookings.CountAsync(b => b.MentorId == mentorId);
        var completedSessions = await _context.Bookings.CountAsync(b => b.MentorId == mentorId && b.Status == "completed");

        var vm = new MentorDetailViewModel
        {
            MentorId = data.m.MentorId,
            FullName = culture == "ar"? $"{data.u.FirstName} {data.u.LastName}" :data.u.DisplayNameEn,
            Email = data.u.Email,
            PhoneNumber = data.u.PhoneNumber,
            LicenseType = data.LicenseName,
            CityName = data.CityName,
            VehicleType = data.m.VehicleType,
            PricePerSession = data.m.PricePerSession,
            IsActive = data.u.IsActive ?? true,
            ApplicationStatus = data.AppStatus,
            AverageRating = ratingAgg != null ? Math.Round(ratingAgg.Avg, 2) : 0,
            TotalRatings = ratingAgg?.Count ?? 0,
            TotalSessions = totalSessions,
            CompletedSessions = completedSessions,
            CreatedAt = data.m.CreatedAt
        };

        return ServiceResult<MentorDetailViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PENDING APPLICATIONS
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<MentorApplicationListViewModel>> GetPendingApplicationsAsync(string culture)
    {
        var items = await (
            from app in _context.MentorApplications.AsNoTracking()
            join m in _context.Mentors on app.MentorId equals m.MentorId
            join u in _context.Users on m.MentorId equals u.UserId
            join lt in _context.LicenseTypes on m.LicenseTypeId equals lt.LicenseTypeId into ltj
            from lt in ltj.DefaultIfEmpty()
            join ct in _context.Cities on m.CityId equals ct.CityId into ctj
            from ct in ctj.DefaultIfEmpty()
            where app.Status == "pending"
            orderby app.SubmittedAt
            select new MentorApplicationListItem
            {
                ApplicationId = app.ApplicationId,
                MentorId = m.MentorId,
                FullName = culture == "ar"? u.FirstName + " " + u.LastName :u.DisplayNameEn,
                Email = u.Email,
                PhoneNumber = u.PhoneNumber,
                LicenseType = culture == "ar" ? lt.DisplayNameAr : lt.DisplayNameEn,
                CityName = ct.CityTranslations
                .Where(c => c.CityId == m.CityId && c.LanguageCode == culture)
                .Select(c => c.DisplayName)
                .FirstOrDefault(),
                SubmittedAt = app.SubmittedAt,
                HasCertificationFile = !string.IsNullOrEmpty(app.CertificationFilePath)
            }
        ).ToListAsync();

        return ServiceResult<MentorApplicationListViewModel>.Success(
            new MentorApplicationListViewModel { Items = items });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // APPLICATION DETAILS
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<MentorApplicationDetailViewModel>> GetApplicationDetailsAsync(int applicationId, string culture)
    {
        var data = await (
            from app in _context.MentorApplications.AsNoTracking()
            join m in _context.Mentors on app.MentorId equals m.MentorId
            join u in _context.Users on m.MentorId equals u.UserId
            join lt in _context.LicenseTypes on m.LicenseTypeId equals lt.LicenseTypeId into ltj
            from lt in ltj.DefaultIfEmpty()
            join ct in _context.Cities on m.CityId equals ct.CityId into ctj
            from ct in ctj.DefaultIfEmpty()
            join pr in _context.Provinces on u.ProvinceId equals pr.ProvinceId into prj
            from pr in prj.DefaultIfEmpty()
            where app.ApplicationId == applicationId
            select new
            {
                app,
                m,
                u,
                LicenseName = lt != null ? (culture == "ar" ? lt.DisplayNameAr : lt.DisplayNameEn) : "—",

                CityName = ct.CityTranslations
                .Where(c => c.CityId == m.CityId && c.LanguageCode == culture)
                .Select(c => c.DisplayName)
                .FirstOrDefault(),

                ProvinceName = pr.ProvinceTranslations
                .Where(p => p.ProvinceId == u.ProvinceId && p.LanguageCode == culture)
                .Select(p => p.DisplayName)
                .FirstOrDefault()
            }
        ).FirstOrDefaultAsync();

        if (data == null)
            return ServiceResult<MentorApplicationDetailViewModel>.Failure("Application not found.");

        var fileName = !string.IsNullOrEmpty(data.app.CertificationFilePath)
            ? Path.GetFileName(data.app.CertificationFilePath)
            : null;

        var vm = new MentorApplicationDetailViewModel
        {
            ApplicationId = data.app.ApplicationId,
            MentorId = data.m.MentorId,
            FullName = $"{data.u.FirstName} {data.u.LastName}",
            Email = data.u.Email,
            PhoneNumber = data.u.PhoneNumber,
            NationalId = data.u.NationalId,
            DateOfBirth = data.u.DateOfBirth,
            Gender = data.u.Gender,
            CityName = data.CityName,
            ProvinceName = data.ProvinceName,
            LicenseType = data.LicenseName,
            VehicleType = data.m.VehicleType,
            PricePerSession = data.m.PricePerSession,
            Status = data.app.Status,
            SubmittedAt = data.app.SubmittedAt,
            CertificationUploadedAt = data.app.CertificationUploadedAt,
            HasCertificationFile = !string.IsNullOrEmpty(data.app.CertificationFilePath),
            CertificationFileName = fileName
        };

        return ServiceResult<MentorApplicationDetailViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // APPROVE
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> ApproveApplicationAsync(int adminUserId, int applicationId)
    {
        var app = await _context.MentorApplications
            .FirstOrDefaultAsync(a => a.ApplicationId == applicationId);

        if (app == null) return ServiceResult.Failure("Application not found.");
        if (app.Status != "pending")
            return ServiceResult.Failure("Only pending applications can be approved.");

        app.Status = "approved";
        app.ReviewedAt = DateTime.UtcNow;
        app.ReviewedBy = adminUserId;
        app.IsCertificationVerified = true;

        var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == app.MentorId);

        if (user != null)
        {
            user.IsActive = true;
        }

        _audit.Log(adminUserId, "ApproveMentorApplication", "MentorApplications", applicationId.ToString());

        await _context.SaveChangesAsync();

        // In-app notification
        await _notifications.CreateAsync(
            app.MentorId,
            "Application Approved",
            "Congratulations — your mentor application has been approved. You can now start receiving bookings.",
            "application");

        // Email notification (best-effort, do not fail the action)
        var mentorEmail = await _context.Users
            .Where(u => u.UserId == app.MentorId)
            .Select(u => u.Email)
            .FirstOrDefaultAsync();

        if (!string.IsNullOrWhiteSpace(mentorEmail))
        {
            try
            {
                await _email.SendAsync(
                    mentorEmail,
                    "Your Rokhsetak mentor application has been approved",
                    "<p>Welcome aboard.</p><p>Your mentor application has been approved. You can now sign in and start receiving bookings from trainees.</p>");
            }
            catch
            {
                // Swallow — approval persisted; email delivery is non-critical here.
            }
        }

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // REJECT
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> RejectApplicationAsync(int adminUserId, int applicationId, string reason)
    {
        if (string.IsNullOrWhiteSpace(reason))
            return ServiceResult.Failure("A rejection reason is required.");

        if (reason.Length > 500)
            return ServiceResult.Failure("Rejection reason cannot exceed 500 characters.");

        var app = await _context.MentorApplications
            .FirstOrDefaultAsync(a => a.ApplicationId == applicationId);

        if (app == null) return ServiceResult.Failure("Application not found.");
        if (app.Status != "pending")
            return ServiceResult.Failure("Only pending applications can be rejected.");

        app.Status = "rejected";
        app.RejectionReason = reason.Trim();
        app.ReviewedAt = DateTime.UtcNow;
        app.ReviewedBy = adminUserId;

        var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == app.MentorId);

        if (user != null)
        {
            user.IsActive = false;
        }

        _audit.Log(adminUserId, "RejectMentorApplication", "MentorApplications", applicationId.ToString());

        await _context.SaveChangesAsync();

        // In-app notification
        await _notifications.CreateAsync(
            app.MentorId,
            "Application Rejected",
            $"Your mentor application has been rejected. Reason: {app.RejectionReason}",
            "application");

        // Email
        var mentorEmail = await _context.Users
            .Where(u => u.UserId == app.MentorId)
            .Select(u => u.Email)
            .FirstOrDefaultAsync();

        if (!string.IsNullOrWhiteSpace(mentorEmail))
        {
            try
            {
                await _email.SendAsync(
                    mentorEmail,
                    "Your Rokhsetak mentor application has been rejected",
                    $"<p>Thank you for applying.</p><p>Unfortunately, we are unable to approve your application at this time.</p><p><strong>Reason:</strong> {System.Net.WebUtility.HtmlEncode(app.RejectionReason)}</p>");
            }
            catch
            {
                // Swallow.
            }
        }

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // SECURE CERTIFICATION FILE DOWNLOAD FROM BLOB STORAGE
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<(Stream Stream, string FileName)>> GetCertificationFileAsync(int applicationId)
    {
        var app = await _context.MentorApplications
            .AsNoTracking()
            .FirstOrDefaultAsync(a => a.ApplicationId == applicationId);

        if (app == null)
            return ServiceResult<(Stream, string)>.Failure("Application not found.");

        if (string.IsNullOrWhiteSpace(app.CertificationFilePath))
            return ServiceResult<(Stream, string)>.Failure("No certification file attached.");

        // CertificationFilePath now stores the blob file name
        var fileName = Path.GetFileName(app.CertificationFilePath);

        if (string.IsNullOrWhiteSpace(fileName))
            return ServiceResult<(Stream, string)>.Failure("Invalid certification file.");

        var downloadResult = await _blobService.DownloadAsync(
            "uploads",
            fileName);

        if (!downloadResult.Succeeded)
            return ServiceResult<(Stream?, string?)>.Failure(downloadResult.Error);

        return ServiceResult<(Stream, string)>.Success((
            downloadResult.Data,
            fileName
        ));
    }
}

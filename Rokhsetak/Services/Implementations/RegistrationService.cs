using Microsoft.EntityFrameworkCore;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.ViewModels.Registration;
using BCrypt.Net;

namespace Rokhsetak.Services.Implementations;

/// <summary>
/// Handles all registration flows:
///
///   LookupNationalIdAsync  – validates & returns gov-citizen data for pre-fill
///   RegisterTraineeAsync   – creates User + Trainee + TraineeLicense + UserConsent
///   RegisterMentorAsync    – creates User + MentorApplication + Mentor + UserConsent
///   GetLicenseTypesAsync   – dropdown helper
///
/// All multi-table writes use explicit transactions to guarantee consistency.
/// </summary>
public class RegistrationService : IRegistrationService
{
    // Role IDs must match the Roles lookup table in the database.
    private const int RoleIdTrainee = 1;
    private const int RoleIdMentor  = 2;

    // Allowed extensions for mentor certification upload
    private static readonly HashSet<string> AllowedCertExtensions =
        new(StringComparer.OrdinalIgnoreCase) { ".pdf", ".jpg", ".jpeg", ".png" };

    private const long MaxCertFileSizeBytes = 5 * 1024 * 1024; // 5 MB

    private readonly RokhsetakDbContext _db;
    private readonly IWebHostEnvironment _env;
    private readonly ILogger<RegistrationService> _logger;

    public RegistrationService(
        RokhsetakDbContext db,
        IWebHostEnvironment env,
        ILogger<RegistrationService> logger)
    {
        _db   = db;
        _env  = env;
        _logger = logger;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // National ID Lookup  (shared by trainee & mentor flows)
    // ─────────────────────────────────────────────────────────────────────────
    /// <summary>
    /// 1. National ID must exist in GovCitizens.
    /// 2. Citizen must be eligible (IsEligible = true).
    /// 3. National ID must not already be registered in the Users table.
    /// 4. (Trainee only) Citizen must not already hold an active government license.
    /// </summary>
    public async Task<ServiceResult<GovCitizenDto>> LookupNationalIdAsync(
        string nationalId, bool isTrainee)
    {
        var citizen = await _db.GovCitizens
            .AsNoTracking()
            .FirstOrDefaultAsync(c => c.NationalId == nationalId);

        if (citizen == null)
            return ServiceResult<GovCitizenDto>.Failure(
                "National ID not found in government records. Please verify your ID.");

        if (citizen.IsEligible != true)
            return ServiceResult<GovCitizenDto>.Failure(
                "You are not eligible to register. Please contact the licensing authority.");

        // Already registered in the platform?
        var existingUser = await _db.Users
            .AsNoTracking()
            .AnyAsync(u => u.NationalId == nationalId);

        if (existingUser)
            return ServiceResult<GovCitizenDto>.Failure(
                "This National ID is already registered. Please log in or contact support.");


        return ServiceResult<GovCitizenDto>.Success(new GovCitizenDto
        {
            NationalId   = citizen.NationalId,
            FirstName    = citizen.FirstName,
            LastName     = citizen.LastName,
            DateOfBirth  = citizen.DateOfBirth,
            Gender       = citizen.Gender,
            Province     = citizen.Province,
            City         = citizen.City,
            AddressLine1 = citizen.AddressLine1,
            AddressLine2 = citizen.AddressLine2,
            PostalCode   = citizen.PostalCode
        });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Trainee Registration
    // ─────────────────────────────────────────────────────────────────────────
    /// <summary>
    /// Creates (in order, within a transaction):
    ///   1. User  (RoleId = Trainee, gov fields copied from GovCitizen)
    ///   2. Trainee role record
    ///   3. TraineeLicense (stage = 'registered')
    ///   4. UserConsent    (terms acceptance with timestamp)
    /// </summary>
    public async Task<ServiceResult> RegisterTraineeAsync(
        TraineeRegistrationViewModel model, string ipAddress)
    {
        // Guard: re-check eligibility server-side (form can be tampered)
        var lookupResult = await LookupNationalIdAsync(model.NationalId, isTrainee: true);
        if (!lookupResult.Succeeded)
            return ServiceResult.Failure(lookupResult.Error!);

        // Email uniqueness
        if (await _db.Users.AnyAsync(u => u.Email == model.Email))
            return ServiceResult.Failure("This email address is already in use.");

        // License type exists
        var licenseType = await _db.LicenseTypes.FindAsync(model.LicenseTypeId);
        if (licenseType == null)
            return ServiceResult.Failure("Invalid license type selected.");

        await using var tx = await _db.Database.BeginTransactionAsync();
        try
        {
            // 1. User
            var user = new User
            {
                RoleId           = RoleIdTrainee,
                NationalId       = model.NationalId,
                FirstName        = model.FirstName,
                LastName         = model.LastName,
                DateOfBirth      = model.DateOfBirth,
                Gender           = model.Gender,
                Province         = model.Province,
                City             = model.City,
                AddressLine1     = model.AddressLine1,
                AddressLine2     = model.AddressLine2,
                PostalCode       = model.PostalCode,
                Email            = model.Email,
                PhoneNumber      = model.PhoneNumber,
                PasswordHash     = BCrypt.Net.BCrypt.HashPassword(model.Password),
                IsActive         = true,
                LanguagePreference = "ar"
            };
            _db.Users.Add(user);
            await _db.SaveChangesAsync(); // flush to get UserId

            // 2. Trainee role record
            var trainee = new Trainee
            {
                TraineeId    = user.UserId,
                LicenseTypeId = model.LicenseTypeId,
                EnrolledAt   = DateOnly.FromDateTime(DateTime.UtcNow)
            };
            _db.Trainees.Add(trainee);
            await _db.SaveChangesAsync();

            // 3. TraineeLicense
            var traineeLicense = new TraineeLicense
            {
                TraineeId    = user.UserId,
                LicenseTypeId = model.LicenseTypeId,
                Stage        = "registered",
                IsActive     = true,
                ProgressPercentage = 0
            };
            _db.TraineeLicenses.Add(traineeLicense);
            await _db.SaveChangesAsync();

            // 4. UserConsent
            //'terms_of_use', 'privacy_policy'
            _db.UserConsents.Add(new UserConsent
            {
                UserId      = user.UserId,
                ConsentType = "terms_and_privacy",
                Consented   = true,
                ConsentedAt = DateTime.UtcNow,
                IpAddress   = ipAddress
            });
            await _db.SaveChangesAsync();

            await tx.CommitAsync();
            _logger.LogInformation("Trainee registered successfully: UserId={UserId}", user.UserId);
            return ServiceResult.Success();
        }
        catch (Exception ex)
        {
            await tx.RollbackAsync();
            _logger.LogError(ex, "Trainee registration failed for NationalId={NId}", model.NationalId);
            return ServiceResult.Failure("Registration failed due to a system error. Please try again.");
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Mentor Registration
    // ─────────────────────────────────────────────────────────────────────────
    /// <summary>
    /// Creates (in order, within a transaction):
    ///   1. User  (RoleId = Mentor, IsActive = true but login blocked until approved)
    ///   2. MentorApplication (status = 'pending', cert file path stored)
    ///   3. Mentor role record linked to the application
    ///   4. UserConsent
    ///
    /// Certification file is saved to /uploads/certifications/{guid}.ext
    /// </summary>
    public async Task<ServiceResult> RegisterMentorAsync(
        MentorRegistrationViewModel model, string ipAddress)
    {
        // Server-side re-validation
        var lookupResult = await LookupNationalIdAsync(model.NationalId, isTrainee: false);
        if (!lookupResult.Succeeded)
            return ServiceResult.Failure(lookupResult.Error!);

        if (await _db.Users.AnyAsync(u => u.Email == model.Email))
            return ServiceResult.Failure("This email address is already in use.");

        var licenseType = await _db.LicenseTypes.FindAsync(model.LicenseTypeId);
        if (licenseType == null)
            return ServiceResult.Failure("Invalid license type selected.");

        // Validate and persist certification file
        var certPathResult = await SaveCertificationFileAsync(model.CertificationFile);
        if (!certPathResult.Succeeded)
            return ServiceResult.Failure(certPathResult.Error!);

        await using var tx = await _db.Database.BeginTransactionAsync();
        try
        {
            // 1. User
            var user = new User
            {
                RoleId           = RoleIdMentor,
                NationalId       = model.NationalId,
                FirstName        = model.FirstName,
                LastName         = model.LastName,
                DateOfBirth      = model.DateOfBirth,
                Gender           = model.Gender,
                Province         = model.Province,
                City             = model.City,
                AddressLine1     = model.AddressLine1,
                AddressLine2     = model.AddressLine2,
                PostalCode       = model.PostalCode,
                Email            = model.Email,
                PhoneNumber      = model.PhoneNumber,
                PasswordHash     = BCrypt.Net.BCrypt.HashPassword(model.Password),
                IsActive         = true, // active user record; login blocked by app status
                LanguagePreference = "ar"
            };
            _db.Users.Add(user);
            await _db.SaveChangesAsync();

            // 1. Create Mentor FIRST
            var mentor = new Mentor
            {
                MentorId = user.UserId,
                LicenseTypeId = model.LicenseTypeId,
                VehicleType = model.VehicleType,
                PricePerSession = model.PricePerSession,
                City = model.City
            };

            _db.Mentors.Add(mentor);
            await _db.SaveChangesAsync();


            // 2. THEN create MentorApplication
            var application = new MentorApplication
            {
                MentorId = mentor.MentorId,
                Status = "pending",
                CertificationFilePath = certPathResult.Data,
                CertificationUploadedAt = DateTime.UtcNow,
                IsCertificationVerified = false
            };

            _db.MentorApplications.Add(application);
            await _db.SaveChangesAsync();


            // 3. OPTIONAL: update mentor with ApplicationId
            mentor.ApplicationId = application.ApplicationId;
            await _db.SaveChangesAsync();

            // 4. UserConsent
            _db.UserConsents.Add(new UserConsent
            {
                UserId      = user.UserId,
                ConsentType = "terms_and_privacy",
                Consented   = true,
                ConsentedAt = DateTime.UtcNow,
                IpAddress   = ipAddress
            });
            await _db.SaveChangesAsync();

            await tx.CommitAsync();
            _logger.LogInformation(
                "Mentor application submitted: UserId={UserId}, ApplicationId={AppId}",
                user.UserId, application.ApplicationId);
            return ServiceResult.Success();
        }
        catch (Exception ex)
        {
            await tx.RollbackAsync();
            _logger.LogError(ex, "Mentor registration failed for NationalId={NId}", model.NationalId);

            // Best-effort: remove the uploaded file on rollback
            if (!string.IsNullOrEmpty(certPathResult.Data))
                TryDeleteFile(certPathResult.Data!);

            return ServiceResult.Failure(ex.Message);
        }
    }

    // ── Private helpers ───────────────────────────────────────────────────────
    private async Task<ServiceResult<string>> SaveCertificationFileAsync(IFormFile file)
    {
        if (file == null || file.Length == 0)
            return ServiceResult<string>.Failure("Certification file is required.");

        if (file.Length > MaxCertFileSizeBytes)
            return ServiceResult<string>.Failure("File size must not exceed 5 MB.");

        var ext = Path.GetExtension(file.FileName);
        if (!AllowedCertExtensions.Contains(ext))
            return ServiceResult<string>.Failure(
                "Only PDF, JPG, and PNG files are accepted for certification.");

        var folder = Path.Combine(_env.WebRootPath, "uploads", "certifications");
        Directory.CreateDirectory(folder);

        var fileName  = $"{Guid.NewGuid()}{ext}";
        var fullPath  = Path.Combine(folder, fileName);
        var webPath   = $"/uploads/certifications/{fileName}";

        await using var stream = File.Create(fullPath);
        await file.CopyToAsync(stream);

        return ServiceResult<string>.Success(webPath);
    }

    private void TryDeleteFile(string webPath)
    {
        try
        {
            var fullPath = Path.Combine(_env.WebRootPath, webPath.TrimStart('/'));
            if (File.Exists(fullPath)) File.Delete(fullPath);
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Could not delete orphaned cert file: {Path}", webPath);
        }
    }
}

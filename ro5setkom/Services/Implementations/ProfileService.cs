namespace ro5setkom.Services.Implementations
{
    using Microsoft.EntityFrameworkCore;
    using ro5setkom.Models;
    using ro5setkom.Services.Common;
    using ro5setkom.Services.Interfaces;
    using ro5setkom.ViewModels.Profile;

    public class ProfileService : IProfileService
    {
        private readonly Ro5setkomDbContext _context;
        private readonly INotificationService _notificationService;

        public ProfileService(Ro5setkomDbContext context, INotificationService notificationService)
        {
            _context = context;
            _notificationService = notificationService;
        }

        public async Task<ServiceResult<ProfileViewModel>> GetProfileAsync(int userId)
        {
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.UserId == userId);
            if (user == null)
                return ServiceResult<ProfileViewModel>.Failure("User not found.");

            var citizen = await _context.GovCitizens
                .FirstOrDefaultAsync(c => c.NationalId == user.NationalId);
            
            if (citizen == null)
                return ServiceResult<ProfileViewModel>.Failure("Citizen record not found.");


            return ServiceResult<ProfileViewModel>.Success(new ProfileViewModel
            {
                Email = user.Email,
                PhoneNumber = user.PhoneNumber,
                Province = user.Province,
                City = user.City,
                AddressLine1 = user.AddressLine1,
                AddressLine2 = user.AddressLine2,
                PostalCode = user.PostalCode,
                LanguagePreference = user.LanguagePreference,

                FirstName = citizen.FirstName,
                LastName = citizen.LastName,
                DateOfBirth = citizen.DateOfBirth,
                Gender = citizen.Gender,
                NationalId = citizen.NationalId,
            });
        }

        public async Task<ServiceResult> UpdateProfileAsync(int userId, EditProfileViewModel model)
        {
            var user = await _context.Users.FindAsync(userId);

            if (user == null)
                return ServiceResult.Failure("User not found.");


            user.Email = model.Email;
            user.PhoneNumber = model.PhoneNumber;
            user.Province = model.Province;
            user.City = model.City;
            user.AddressLine1 = model.AddressLine1;
            user.AddressLine2 = model.AddressLine2;
            user.PostalCode = model.PostalCode;

            await _context.SaveChangesAsync();
            return ServiceResult.Success();
        }

        public async Task<ServiceResult> ChangeLicenseAsync(int userId, int newLicenseTypeId)
        {
            var trainee = await _context.Trainees
                .Include(t => t.TraineeLicenses)
                .FirstOrDefaultAsync(t => t.TraineeId == userId);

            if (trainee == null)
                return ServiceResult.Failure("Trainee not found.");

            var oldLicense = trainee.TraineeLicenses.FirstOrDefault(x => x.IsActive);

            if (oldLicense != null)
                oldLicense.IsActive = false;

            var existingLicense = trainee.TraineeLicenses
                .FirstOrDefault(x => x.LicenseTypeId == newLicenseTypeId);

            if (existingLicense != null)
            {
                // Reuse existing license (preserve progress)
                existingLicense.IsActive = true;
                existingLicense.UpdatedAt = DateTime.UtcNow;
            }
            else
            {
                // Create new license
                var newLicense = new TraineeLicense
                {
                    TraineeId = trainee.TraineeId,
                    LicenseTypeId = newLicenseTypeId,
                    Stage = "registered",
                    ProgressPercentage = 0,
                    IsActive = true,
                    UpdatedAt = DateTime.UtcNow
                };

                _context.TraineeLicenses.Add(newLicense);
            }

            // Cancel future bookings tied to old license
            if (oldLicense != null)
            {
                var futureBookings = await _context.Bookings
                    .Where(b =>
                        b.Status == "confirmed" &&
                        b.BookingDate > DateOnly.FromDateTime(DateTime.UtcNow) &&
                        b.LicenseTypeId == oldLicense.LicenseTypeId &&
                        b.TraineeId == userId) // ⚠️ important: scope to this user
                    .ToListAsync();

                foreach (var b in futureBookings)
                {
                    b.Status = "cancelled";

                    await _notificationService.CreateAsync(
                        b.TraineeId,
                        "Booking Cancelled",
                        "Your booking was cancelled due to license change.",
                        "booking");
                }
            }

            await _context.SaveChangesAsync();
            return ServiceResult.Success();
        }

        public async Task<ServiceResult> ChangeLanguageAsync(int userId, string language)
        {
            var user = await _context.Users.FindAsync(userId);
            user.LanguagePreference = language;

            await _context.SaveChangesAsync();
            return ServiceResult.Success();
        }
    }
}

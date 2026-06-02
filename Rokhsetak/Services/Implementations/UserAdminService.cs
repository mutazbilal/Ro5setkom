using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Admin.ViewModels.Users;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations;

public class UserAdminService : IUserAdminService
{
    private readonly RokhsetakDbContext _context;
    private readonly IAuditService _audit;
    private readonly INotificationService _notifications;

    public UserAdminService(RokhsetakDbContext context, IAuditService audit, INotificationService notificationService)
    {
        _context = context;
        _audit = audit;
        _notifications = notificationService;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // LIST USERS (filter + paginate)
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<UserListViewModel>> GetUsersAsync(UserListFilter filter, string culture)
    {
        if (filter.Page < 1) filter.Page = 1;
        if (filter.PageSize < 1 || filter.PageSize > 100) filter.PageSize = 20;

        var query =
            from u in _context.Users.AsNoTracking()
            join r in _context.Roles on u.RoleId equals r.RoleId
            select new { u, RoleName = r.RoleName };

        if (!string.IsNullOrWhiteSpace(filter.Role))
        {
            var role = filter.Role.Trim().ToLower();
            query = query.Where(x => x.RoleName.ToLower() == role);
        }

        if (!string.IsNullOrWhiteSpace(filter.Status))
        {
            if (filter.Status.Equals("active", StringComparison.OrdinalIgnoreCase))
                query = query.Where(x => x.u.IsActive == true);
            else if (filter.Status.Equals("inactive", StringComparison.OrdinalIgnoreCase))
                query = query.Where(x => x.u.IsActive == false);
        }

        if (!string.IsNullOrWhiteSpace(filter.Search))
        {
            var s = filter.Search.Trim().ToLower();
            query = query.Where(x =>
                x.u.Email.ToLower().Contains(s) ||
                (x.u.FirstName + " " + x.u.LastName).ToLower().Contains(s) ||
                x.u.FirstName.ToLower().Contains(s) ||
                x.u.LastName.ToLower().Contains(s));
        }

        var total = await query.CountAsync();

        var items = await query
            .OrderByDescending(x => x.u.CreatedAt)
            .Skip((filter.Page - 1) * filter.PageSize)
            .Take(filter.PageSize)
            .Select(x => new UserListItem
            {
                UserId = x.u.UserId,
                FullName = culture == "ar"? x.u.FirstName + " " + x.u.LastName: x.u.DisplayNameEn,
                Email = x.u.Email,
                Role = x.RoleName,
                IsActive = x.u.IsActive ?? true,
                CreatedAt = x.u.CreatedAt,
                PhoneNumber = x.u.PhoneNumber
            })
            .ToListAsync();

        return ServiceResult<UserListViewModel>.Success(new UserListViewModel
        {
            Filter = filter,
            Items = items,
            TotalCount = total
        });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // USER DETAILS (with booking history)
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<UserDetailViewModel>> GetUserDetailsAsync(int userId, string culture)
    {
        var data = await (
            from u in _context.Users.AsNoTracking()
            join r in _context.Roles on u.RoleId equals r.RoleId
            join ct in _context.Cities on u.CityId equals ct.CityId into ctJoin
            from ct in ctJoin.DefaultIfEmpty()
            join pr in _context.Provinces on u.ProvinceId equals pr.ProvinceId into prJoin
            from pr in prJoin.DefaultIfEmpty()
            where u.UserId == userId
            select new
            {
                u,
                r.RoleName,

                CityName = ct.CityTranslations
                    .Where(c => c.CityId == u.CityId && c.LanguageCode == culture)
                    .Select(c => c.DisplayName)
                    .FirstOrDefault(),

                ProvinceName = pr.ProvinceTranslations
                    .Where(p => p.ProvinceId == u.ProvinceId && p.LanguageCode == culture)
                    .Select(p => p.DisplayName)
                    .FirstOrDefault(),
                u.DisplayNameEn,
                u.ProfilePicturePath
            }
        ).FirstOrDefaultAsync();

        if (data == null)
            return ServiceResult<UserDetailViewModel>.Failure("User not found.");

        var vm = new UserDetailViewModel
        {
            UserId = data.u.UserId,
            FullName = culture == "ar"? $"{data.u.FirstName} {data.u.LastName}" :data.u.DisplayNameEn,
            Email = data.u.Email,
            PhoneNumber = data.u.PhoneNumber,
            NationalId = data.u.NationalId,
            Role = data.RoleName,
            IsActive = data.u.IsActive ?? true,
            CreatedAt = data.u.CreatedAt,
            DateOfBirth = data.u.DateOfBirth,
            Gender = data.u.Gender,
            CityName = data.CityName,
            ProvinceName = data.ProvinceName,
            AddressLine1 = data.u.AddressLine1,
            ProfilePicture = data.u.ProfilePicturePath,
            DisplayNameEn = data.u.DisplayNameEn,
        };

        // Bookings either as trainee or as mentor
        vm.BookingHistory = await (
            from b in _context.Bookings.AsNoTracking()
            join trainee in _context.Users on b.TraineeId equals trainee.UserId
            join mentor in _context.Users on b.MentorId equals mentor.UserId
            where b.TraineeId == userId || b.MentorId == userId
            orderby b.BookingDate descending, b.StartTime descending
            select new UserBookingHistoryItem
            {
                BookingId = b.BookingId,
                BookingDate = b.BookingDate,
                StartTime = b.StartTime,
                EndTime = b.EndTime,
                Counterparty = culture == "ar"? (b.TraineeId == userId
                    ? (mentor.FirstName + " " + mentor.LastName)
                    : (trainee.FirstName + " " + trainee.LastName))
                    : (b.TraineeId == userId
                    ? (mentor.DisplayNameEn)
                    : (trainee.DisplayNameEn)),
                SessionType = b.SessionType ?? string.Empty,
                Status = b.Status
            }
        ).Take(200).ToListAsync();

        return ServiceResult<UserDetailViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // DEACTIVATE
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> DeactivateUserAsync(int adminUserId, int userId)
    {
        var adminIds = await _context.Admins
            .Select(a => a.AdminId)
            .ToListAsync();

        if (adminUserId == userId)
            return ServiceResult.Failure("You cannot deactivate your own account.");

        if (adminIds.Contains(userId))
            return ServiceResult.Failure("You cannot deactivate another admin");

        var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);
        if (user == null) return ServiceResult.Failure("User not found.");
        if (user.IsActive == false) return ServiceResult.Failure("User is already inactive.");
        
        user.IsActive = false;
        user.UpdatedAt = DateTime.UtcNow;

        // change the application status automatically if user is mentor
        if (user.RoleId == 2)
        {
            var mentorApplication = await _context.MentorApplications
                .Where(ma => ma.MentorId == userId)
                .FirstOrDefaultAsync();

            mentorApplication.Status = "pending";
            mentorApplication.ReviewedAt = DateTime.UtcNow;
            mentorApplication.ReviewedBy = adminUserId;

            var bookings = await _context.Bookings
            .Where(b => b.MentorId == userId)
            .ToListAsync();

            foreach (var booking in bookings)
            {
                booking.Status = "cancelled";
                await _notifications.CreateAsync(booking.TraineeId,
                    "booking cancelled",
                    $"your booking with {user.FirstName} {user.LastName} have beeing cancelled",
                    "booking");
            }
        }

        _audit.Log(adminUserId, "DeactivateUser", "Users", userId.ToString());
        await _context.SaveChangesAsync();

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // REACTIVATE
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> ReactivateUserAsync(int adminUserId, int userId)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == userId);
        if (user == null) return ServiceResult.Failure("User not found.");
        if (user.IsActive == true) return ServiceResult.Failure("User is already active.");

        user.IsActive = true;
        user.UpdatedAt = DateTime.UtcNow;

        _audit.Log(adminUserId, "ReactivateUser", "Users", userId.ToString());
        await _context.SaveChangesAsync();

        return ServiceResult.Success();
    }
}

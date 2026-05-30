using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Admin.ViewModels.Bookings;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;
using System.Globalization;

namespace Rokhsetak.Services.Implementations;

public class BookingAdminService : IBookingAdminService
{
    private readonly RokhsetakDbContext _context;

    public BookingAdminService(RokhsetakDbContext context)
    {
        _context = context;
    }

    public async Task<ServiceResult<AdminBookingListViewModel>> GetBookingsAsync(BookingFilter filter, string culture = "ar")
    {
        if (filter.Page < 1) filter.Page = 1;
        if (filter.PageSize < 1 || filter.PageSize > 100) filter.PageSize = 20;

        var query =
            from b in _context.Bookings.AsNoTracking()
            join trainee in _context.Users on b.TraineeId equals trainee.UserId
            join mentor in _context.Users on b.MentorId equals mentor.UserId
            join lt in _context.LicenseTypes on b.LicenseTypeId equals lt.LicenseTypeId into ltj
            from lt in ltj.DefaultIfEmpty()
            select new
            {
                b,
                TraineeFirst = trainee.FirstName,
                TraineeLast = trainee.LastName,
                TraineeDisplayEn = trainee.DisplayNameEn,
                MentorFirst = mentor.FirstName,
                MentorLast = mentor.LastName,
                MentorDisplayEn = mentor.DisplayNameEn,
                LicenseName = culture == "ar"? lt.DisplayNameAr :lt.DisplayNameEn,
            };

        if (!string.IsNullOrWhiteSpace(filter.Status))
            query = query.Where(x => x.b.Status == filter.Status);

        if (filter.FromDate.HasValue)
            query = query.Where(x => x.b.BookingDate >= filter.FromDate.Value);

        if (filter.ToDate.HasValue)
            query = query.Where(x => x.b.BookingDate <= filter.ToDate.Value);

        if (filter.MentorId.HasValue)
            query = query.Where(x => x.b.MentorId == filter.MentorId.Value);

        if (filter.TraineeId.HasValue)
            query = query.Where(x => x.b.TraineeId == filter.TraineeId.Value);

        if (!string.IsNullOrWhiteSpace(filter.Search))
        {
            var s = filter.Search.Trim().ToLower();
            query = query.Where(x =>
                (x.TraineeFirst + " " + x.TraineeLast).ToLower().Contains(s) ||
                (x.MentorFirst + " " + x.MentorLast).ToLower().Contains(s));
        }

        var total = await query.CountAsync();

        var items = await query
            .OrderByDescending(x => x.b.BookingDate)
            .ThenByDescending(x => x.b.StartTime)
            .Skip((filter.Page - 1) * filter.PageSize)
            .Take(filter.PageSize)
            .Select(x => new AdminBookingItem
            {
                BookingId = x.b.BookingId,
                TraineeId = x.b.TraineeId,
                TraineeName = culture == "ar"? x.TraineeFirst + " " + x.TraineeLast :x.TraineeDisplayEn,
                MentorId = x.b.MentorId,
                MentorName = culture == "ar" ? x.MentorFirst + " " + x.MentorLast :x.MentorDisplayEn,
                BookingDate = x.b.BookingDate,
                StartTime = x.b.StartTime,
                EndTime = x.b.EndTime,
                SessionType = x.b.SessionType ?? string.Empty,
                Status = x.b.Status,
                LicenseType = x.LicenseName,
                CreatedAt = x.b.CreatedAt
            })
            .ToListAsync();

        return ServiceResult<AdminBookingListViewModel>.Success(new AdminBookingListViewModel
        {
            Filter = filter,
            Items = items,
            TotalCount = total
        });
    }
}

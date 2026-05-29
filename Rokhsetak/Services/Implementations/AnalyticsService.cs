using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Admin.ViewModels.Dashboard;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations;

public class AnalyticsService : IAnalyticsService
{
    private readonly RokhsetakDbContext _context;

    public AnalyticsService(RokhsetakDbContext context)
    {
        _context = context;
    }

    public async Task<ServiceResult<AnalyticsDashboardViewModel>> GetDashboardAsync(AnalyticsFilter filter)
    {
        // Default range: last 12 months
        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        var from = filter.FromDate ?? today.AddMonths(-11);
        var to = filter.ToDate ?? today;

        if (from > to)
            return ServiceResult<AnalyticsDashboardViewModel>.Failure("'From' date must be before 'To' date.");

        var fromDt = from.ToDateTime(TimeOnly.MinValue);
        var toDt = to.ToDateTime(TimeOnly.MaxValue);

        // ── Top-line metrics ────────────────────────────────────────────────
        var totalUsers = await _context.Users.CountAsync();

        var activeTrainees = await (
            from t in _context.Trainees
            join u in _context.Users on t.TraineeId equals u.UserId
            where u.IsActive == true
            select t
        ).CountAsync();

        var activeMentors = await (
            from m in _context.Mentors
            join u in _context.Users on m.MentorId equals u.UserId
            join app in _context.MentorApplications on m.ApplicationId equals app.ApplicationId into appj
            from app in appj.DefaultIfEmpty()
            where u.IsActive == true && (app == null || app.Status == "approved")
            select m
        ).CountAsync();

        var totalBookings = await _context.Bookings.CountAsync();

        var pendingMentorApplications = await _context.MentorApplications
            .CountAsync(a => a.Status == "pending");

        var completedLicenses = await _context.TraineeLicenses
            .CountAsync(tl => tl.Stage == "completed");

        // ── Users over time (monthly buckets in range) ───────────────────────
        var usersInRange = await _context.Users
            .Where(u => u.CreatedAt != null && u.CreatedAt >= fromDt && u.CreatedAt <= toDt)
            .Select(u => new { u.CreatedAt })
            .ToListAsync();

        var usersOverTime = usersInRange
            .Where(x => x.CreatedAt.HasValue)
            .GroupBy(x => new { x.CreatedAt!.Value.Year, x.CreatedAt!.Value.Month })
            .Select(g => new TimeSeriesPoint
            {
                Label = $"{g.Key.Year}-{g.Key.Month:D2}",
                Count = g.Count()
            })
            .OrderBy(p => p.Label)
            .ToList();

        // ── Bookings per month ──────────────────────────────────────────────
        var bookingsInRange = await _context.Bookings
            .Where(b => b.BookingDate >= from && b.BookingDate <= to)
            .Select(b => new { b.BookingDate })
            .ToListAsync();

        var bookingsPerMonth = bookingsInRange
            .GroupBy(x => new { x.BookingDate.Year, x.BookingDate.Month })
            .Select(g => new TimeSeriesPoint
            {
                Label = $"{g.Key.Year}-{g.Key.Month:D2}",
                Count = g.Count()
            })
            .OrderBy(p => p.Label)
            .ToList();

        // ── Mentor performance distribution (rating buckets) ─────────────────
        var ratingScores = await _context.Ratings
            .Select(r => (double)r.Score)
            .ToListAsync();

        var distribution = new List<RatingDistributionBucket>
        {
            new() { Bucket = "5★",        Count = ratingScores.Count(s => s >= 4.5) },
            new() { Bucket = "4★ – 4.5★", Count = ratingScores.Count(s => s >= 3.5 && s < 4.5) },
            new() { Bucket = "3★ – 3.5★", Count = ratingScores.Count(s => s >= 2.5 && s < 3.5) },
            new() { Bucket = "2★ – 2.5★", Count = ratingScores.Count(s => s >= 1.5 && s < 2.5) },
            new() { Bucket = "1★ – 1.5★", Count = ratingScores.Count(s => s < 1.5) }
        };

        // ── Mentor performance table (top 10) ───────────────────────────────
        var mentorIds = await _context.Mentors.Select(m => m.MentorId).ToListAsync();

        var ratingsByMentor = await _context.Ratings
            .GroupBy(r => r.MentorId)
            .Select(g => new
            {
                MentorId = g.Key,
                Avg = g.Average(r => (double)r.Score),
                Count = g.Count()
            })
            .ToListAsync();

        var bookingStatsByMentor = await _context.Bookings
            .GroupBy(b => b.MentorId)
            .Select(g => new
            {
                MentorId = g.Key,
                Total = g.Count(),
                Completed = g.Count(b => b.Status == "completed")
            })
            .ToListAsync();

        var licenseStatsByMentor = await (
            from tl in _context.TraineeLicenses
            where tl.MentorId != null && tl.Stage == "completed"
            group tl by tl.MentorId!.Value into g
            select new
            {
                MentorId = g.Key,
                AvgDays = g.Average(tl =>
                    EF.Functions.DateDiffDay(tl.CreatedAt ?? DateTime.UtcNow, tl.UpdatedAt ?? DateTime.UtcNow))
            }
        ).ToListAsync();

        var mentorNames = await (
            from m in _context.Mentors
            join u in _context.Users on m.MentorId equals u.UserId
            select new { m.MentorId, FullName = u.FirstName + " " + u.LastName }
        ).ToListAsync();

        var nameLookup = mentorNames.ToDictionary(x => x.MentorId, x => x.FullName);
        var ratingLookup = ratingsByMentor.ToDictionary(x => x.MentorId, x => x);
        var bookingLookup = bookingStatsByMentor.ToDictionary(x => x.MentorId, x => x);
        var licenseLookup = licenseStatsByMentor.ToDictionary(x => x.MentorId, x => x);

        var page = filter.Page < 1 ? 1 : filter.Page;
        var pageSize = filter.PageSize < 1 ? 10 : filter.PageSize;

        var totalMentors = mentorIds.Count;

        var topMentorsPaged = mentorIds
            .Select(id =>
            {
                ratingLookup.TryGetValue(id, out var r);
                bookingLookup.TryGetValue(id, out var b);
                licenseLookup.TryGetValue(id, out var l);

                var total = b?.Total ?? 0;
                var completed = b?.Completed ?? 0;

                return new MentorPerformanceItem
                {
                    MentorId = id,
                    FullName = nameLookup.TryGetValue(id, out var n) ? n : "—",
                    AverageRating = r != null ? Math.Round(r.Avg, 2) : 0,
                    TotalRatings = r?.Count ?? 0,
                    TotalSessions = total,
                    CompletedSessions = completed,
                    CompletionRate = total == 0 ? 0 : Math.Round((double)completed / total * 100, 1),
                    AvgDaysToCompletion = l != null ? Math.Round(l.AvgDays, 1) : 0
                };
            })
            .OrderByDescending(x => x.AverageRating)
            .ThenByDescending(x => x.CompletedSessions)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToList();

        // ── Platform rollups ────────────────────────────────────────────────
        var platformAvgRating = ratingScores.Any() ? Math.Round(ratingScores.Average(), 2) : 0;

        var totalSessionsAll = bookingStatsByMentor.Sum(x => x.Total);
        var completedSessionsAll = bookingStatsByMentor.Sum(x => x.Completed);
        var platformCompletionRate = totalSessionsAll == 0
            ? 0
            : Math.Round((double)completedSessionsAll / totalSessionsAll * 100, 1);

        var platformAvgDays = licenseStatsByMentor.Any()
            ? Math.Round(licenseStatsByMentor.Average(x => x.AvgDays), 1)
            : 0;

        var vm = new AnalyticsDashboardViewModel
        {
            Filter = new AnalyticsFilter { FromDate = from, ToDate = to },
            TotalUsers = totalUsers,
            ActiveTrainees = activeTrainees,
            ActiveMentors = activeMentors,
            TotalBookings = totalBookings,
            PendingMentorApplications = pendingMentorApplications,
            CompletedLicenses = completedLicenses,
            UsersOverTime = usersOverTime,
            BookingsPerMonth = bookingsPerMonth,
            MentorPerformanceDistribution = distribution,
            PlatformAvgRating = platformAvgRating,
            PlatformCompletionRate = platformCompletionRate,
            PlatformAvgDaysToCompletion = platformAvgDays,
            TopMentors = topMentorsPaged,
            TopMentorsTotalCount = totalMentors
        };

        return ServiceResult<AnalyticsDashboardViewModel>.Success(vm);
    }
}

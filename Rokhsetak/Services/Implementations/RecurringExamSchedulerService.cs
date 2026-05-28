using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Rokhsetak.Models;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations;

public class RecurringExamSchedulerService : IRecurringExamSchedulerService
{
    // ── Configuration ────────────────────────────────────────────────────────

    /// <summary>Working days in the Jordanian / Gulf calendar (Sun–Thu).</summary>
    private static readonly HashSet<DayOfWeek> WorkDays =
    [
        DayOfWeek.Sunday,
        DayOfWeek.Monday,
        DayOfWeek.Tuesday,
        DayOfWeek.Wednesday,
        DayOfWeek.Thursday,
    ];

    /// <summary>Three 1-hour morning sessions: 08:00, 09:00, 10:00.</summary>
    private static readonly TimeOnly[] SessionTimes =
    [
        new TimeOnly(8,  0),
        new TimeOnly(9,  0),
        new TimeOnly(10, 0),
    ];

    private static readonly string[] ExamTypes = ["theory", "medical", "practical"];

    /// <summary>Capacity per slot — adjust to reflect real exam-room size.</summary>
    private const int SlotsPerSession = 30;

    // ── Dependencies ─────────────────────────────────────────────────────────

    private readonly RokhsetakDbContext _context;
    private readonly ILogger<RecurringExamSchedulerService> _logger;

    public RecurringExamSchedulerService(
        RokhsetakDbContext context,
        ILogger<RecurringExamSchedulerService> logger)
    {
        _context = context;
        _logger = logger;
    }

    // ── Public API ───────────────────────────────────────────────────────────

    public async Task GenerateSlotsAsync(int daysAhead = 30, CancellationToken ct = default)
    {
        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        var endDate = today.AddDays(daysAhead);

        // ── Load reference data ───────────────────────────────────────────────
        var centerIds = await _context.GovExamCenters
            .Where(c => c.IsActive == true)
            .Select(c => c.CenterId)
            .ToListAsync(ct);

        if (centerIds.Count == 0)
        {
            _logger.LogWarning("RecurringExamScheduler: no active exam centers found — skipping.");
            return;
        }

        var licenseTypeIds = await _context.LicenseTypes
            .Select(lt => lt.LicenseTypeId)
            .ToListAsync(ct);

        if (licenseTypeIds.Count == 0)
        {
            _logger.LogWarning("RecurringExamScheduler: no license types found — skipping.");
            return;
        }

        // ── Build a HashSet of already-existing (centerId, licenseTypeId, examType, date, time)
        //    so we can skip duplicates without round-tripping per slot. ────────
        var existingKeys = (await _context.GovOfficialExams
                .Where(e => e.ExamDate >= today && e.ExamDate <= endDate)
                .Select(e => new
                {
                    e.CenterId,
                    e.LicenseTypeId,
                    e.ExamType,
                    e.ExamDate,
                    e.ExamTime,
                })
                .ToListAsync(ct))
            .Select(e => (e.CenterId, e.LicenseTypeId, e.ExamType, e.ExamDate, e.ExamTime))
            .ToHashSet();

        // ── Generate candidates ───────────────────────────────────────────────
        var toInsert = new List<GovOfficialExam>();

        for (var date = today; date <= endDate; date = date.AddDays(1))
        {
            if (!WorkDays.Contains(date.DayOfWeek))
                continue;

            foreach (var centerId in centerIds)
                foreach (var licenseTypeId in licenseTypeIds)
                    foreach (var examType in ExamTypes)
                        foreach (var time in SessionTimes)
                        {
                            var key = (centerId, licenseTypeId, examType, date, time);
                            if (existingKeys.Contains(key))
                                continue;

                            toInsert.Add(new GovOfficialExam
                            {
                                CenterId = centerId,
                                LicenseTypeId = licenseTypeId,
                                ExamType = examType,
                                ExamDate = date,
                                ExamTime = time,
                                TotalSlots = SlotsPerSession,
                                BookedSlots = 0,
                                Status = "scheduled",
                                CreatedAt = DateTime.UtcNow,
                            });

                            existingKeys.Add(key); // guard against duplicates within this batch
                        }
        }

        if (toInsert.Count == 0)
        {
            _logger.LogInformation("RecurringExamScheduler: all slots already exist for the next {Days} days.", daysAhead);
            return;
        }

        await _context.GovOfficialExams.AddRangeAsync(toInsert, ct);
        await _context.SaveChangesAsync(ct);

        _logger.LogInformation(
            "RecurringExamScheduler: inserted {Count} new exam slots (window: {From:yyyy-MM-dd} → {To:yyyy-MM-dd}).",
            toInsert.Count, today, endDate);
    }
}

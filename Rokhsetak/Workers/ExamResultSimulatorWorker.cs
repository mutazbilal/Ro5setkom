using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Rokhsetak.Models;

namespace Rokhsetak.Workers;

/// <summary>
/// Simulates the government exam-result feed.
/// 
/// Every <see cref="Interval"/>, this worker finds any exam appointments
/// whose exam date has passed and that do not yet have a <see cref="GovExamResult"/>
/// row, then writes a randomly-generated pass/fail result — mimicking what a
/// real government API integration would eventually provide.
///
/// Pass-rate assumptions (easily tuned via <see cref="PassRates"/>):
///   theory    → 70 %   scored 0–100
///   medical   → 85 %   no numeric score (physical examination)
///   practical → 65 %   scored 0–100
/// </summary>
public class ExamResultSimulatorWorker : BackgroundService
{
    // ── Tuneable parameters ───────────────────────────────────────────────────

    private static readonly TimeSpan Interval = TimeSpan.FromHours(1);

    /// <summary>Probability of a "pass" outcome per exam type.</summary>
    private static readonly Dictionary<string, double> PassRates = new(StringComparer.OrdinalIgnoreCase)
    {
        ["theory"] = 0.70,
        ["medical"] = 0.85,
        ["practical"] = 0.65,
    };

    // ── Dependencies ─────────────────────────────────────────────────────────

    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<ExamResultSimulatorWorker> _logger;

    public ExamResultSimulatorWorker(
        IServiceScopeFactory scopeFactory,
        ILogger<ExamResultSimulatorWorker> logger)
    {
        _scopeFactory = scopeFactory;
        _logger = logger;
    }

    // ── Background loop ───────────────────────────────────────────────────────

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("ExamResultSimulatorWorker starting.");

        // Small startup delay so the app is fully initialised before the first run.
        await Task.Delay(TimeSpan.FromSeconds(30), stoppingToken).ConfigureAwait(false);

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await SimulateResultsAsync(stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                break;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ExamResultSimulatorWorker: unhandled exception.");
            }

            await Task.Delay(Interval, stoppingToken).ConfigureAwait(false);
        }

        _logger.LogInformation("ExamResultSimulatorWorker stopped.");
    }

    // ── Core logic ────────────────────────────────────────────────────────────

    private async Task SimulateResultsAsync(CancellationToken ct)
    {
        await using var scope = _scopeFactory.CreateAsyncScope();
        var context = scope.ServiceProvider.GetRequiredService<RokhsetakDbContext>();

        var today = DateOnly.FromDateTime(DateTime.UtcNow);

        // ── 1. Find all scheduled appointments whose exam has already taken place ──
        //       We join to GovOfficialExams to get ExamDate and ExamType in one query.
        var dueAppointments = await context.ExamAppointments
            .Where(ea => ea.Status == "scheduled")
            .Join(context.GovOfficialExams,
                  ea => ea.OfficialExamId,
                  e => e.OfficialExamId,
                  (ea, e) => new
                  {
                      ea.ExamAppointmentId,
                      ea.TraineeId,
                      ea.OfficialExamId,
                      e.ExamType,
                      e.ExamDate,
                  })
            .Where(x => x.ExamDate < today)   // exam day has passed
            .ToListAsync(ct);

        if (dueAppointments.Count == 0)
            return;

        // ── 2. Resolve NationalId for each unique trainee in one query ────────
        var traineeIds = dueAppointments.Select(a => a.TraineeId).Distinct().ToList();

        var nationalIds = await context.Users
            .Where(u => traineeIds.Contains(u.UserId) && u.NationalId != null)
            .ToDictionaryAsync(u => u.UserId, u => u.NationalId!, ct);

        // ── 3. Find which (OfficialExamId, NationalId) pairs already have results ──
        var examIds = dueAppointments.Select(a => a.OfficialExamId).Distinct().ToList();
        var allNatIds = nationalIds.Values.Distinct().ToList();

        var existingResultKeys = (await context.GovExamResults
                .Where(r => examIds.Contains(r.OfficialExamId) && allNatIds.Contains(r.NationalId))
                .Select(r => new { r.OfficialExamId, r.NationalId })
                .ToListAsync(ct))
            .Select(r => (r.OfficialExamId, r.NationalId))
            .ToHashSet();

        // ── 4. Generate and persist results ──────────────────────────────────
        var rng = new Random();
        var newResults = new List<GovExamResult>();
        var appointmentIds = new List<int>(); // appointments to mark completed

        foreach (var appt in dueAppointments)
        {
            if (!nationalIds.TryGetValue(appt.TraineeId, out var natId))
            {
                _logger.LogWarning(
                    "ExamResultSimulator: trainee {TraineeId} has no NationalId — cannot record result.",
                    appt.TraineeId);
                continue;
            }

            if (existingResultKeys.Contains((appt.OfficialExamId, natId)))
                continue; // result already recorded

            var (resultStr, score) = GenerateRandomResult(appt.ExamType, rng);

            newResults.Add(new GovExamResult
            {
                OfficialExamId = appt.OfficialExamId,
                NationalId = natId,
                Result = resultStr,
                Score = score,
                Notes = "Simulated result — replace with live government feed.",
                RecordedAt = DateTime.UtcNow,
            });

            existingResultKeys.Add((appt.OfficialExamId, natId)); // prevent duplicate in same batch
            appointmentIds.Add(appt.ExamAppointmentId);
        }

        if (newResults.Count == 0)
            return;

        await context.GovExamResults.AddRangeAsync(newResults, ct);

        // Mark corresponding appointments as completed
        await context.ExamAppointments
            .Where(ea => appointmentIds.Contains(ea.ExamAppointmentId))
            .ExecuteUpdateAsync(
                s => s.SetProperty(ea => ea.Status, "completed")
                      .SetProperty(ea => ea.UpdatedAt, DateTime.UtcNow),
                ct);

        await context.SaveChangesAsync(ct);

        _logger.LogInformation(
            "ExamResultSimulator: recorded {Count} simulated result(s).", newResults.Count);
    }

    // ── Result generation ─────────────────────────────────────────────────────

    /// <summary>
    /// Returns a (result, score) pair.
    /// Medical exams carry no numeric score; all others are scored 0–100.
    /// Pass threshold is 60 for scored exams.
    /// </summary>
    private static (string result, int? score) GenerateRandomResult(string examType, Random rng)
    {
        var passRate = PassRates.GetValueOrDefault(examType, 0.70);
        var isPass = rng.NextDouble() < passRate;

        // Medical: physical examination → no numeric score
        if (examType.Equals("medical", StringComparison.OrdinalIgnoreCase))
            return (isPass ? "pass" : "fail", null);

        // Scored exams: pass ≥ 60, fail < 60 (keep realistic spread)
        var score = isPass
            ? rng.Next(60, 101)   // 60–100
            : rng.Next(20, 60);   // 20–59  (very low scores are rare in real life)

        return (isPass ? "pass" : "fail", score);
    }
}

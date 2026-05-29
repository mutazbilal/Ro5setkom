namespace Rokhsetak.Services.Interfaces;

public interface IRecurringExamSchedulerService
{
    /// <summary>
    /// Generates GovOfficialExam rows for every workday (Sun–Thu) in the next
    /// <paramref name="daysAhead"/> days, skipping slots that already exist.
    /// </summary>
    Task GenerateSlotsAsync(int daysAhead = 30, CancellationToken ct = default);
}

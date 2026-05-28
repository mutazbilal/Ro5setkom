using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Workers;

/// <summary>
/// Runs <see cref="IRecurringExamSchedulerService.GenerateSlotsAsync"/> once at
/// startup and then every 24 hours, ensuring the rolling 30-day exam schedule
/// stays populated without manual intervention.
/// </summary>
public class ExamSchedulerWorker : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<ExamSchedulerWorker> _logger;

    private static readonly TimeSpan Interval = TimeSpan.FromHours(24);

    public ExamSchedulerWorker(
        IServiceScopeFactory scopeFactory,
        ILogger<ExamSchedulerWorker> logger)
    {
        _scopeFactory = scopeFactory;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("ExamSchedulerWorker starting.");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await using var scope = _scopeFactory.CreateAsyncScope();
                var scheduler = scope.ServiceProvider
                    .GetRequiredService<IRecurringExamSchedulerService>();

                await scheduler.GenerateSlotsAsync(daysAhead: 30, ct: stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                break;
            }
            catch (Exception ex)
            {
                // Log and keep running — a transient DB hiccup shouldn't kill the worker.
                _logger.LogError(ex, "ExamSchedulerWorker: unhandled exception during slot generation.");
            }

            await Task.Delay(Interval, stoppingToken).ConfigureAwait(false);
        }

        _logger.LogInformation("ExamSchedulerWorker stopped.");
    }
}

using System.ComponentModel.DataAnnotations;

namespace Rokhsetak.Areas.Admin.ViewModels.Dashboard;

public class AnalyticsFilter
{
    [DataType(DataType.Date)]
    [Display(Name = "From")]
    public DateOnly? FromDate { get; set; }

    [DataType(DataType.Date)]
    [Display(Name = "To")]
    public DateOnly? ToDate { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 10;
}

public class TimeSeriesPoint
{
    public string Label { get; set; } = string.Empty;
    public int Count { get; set; }
}

public class MentorPerformanceItem
{
    public int MentorId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public double AverageRating { get; set; }
    public int TotalRatings { get; set; }
    public int TotalSessions { get; set; }
    public int CompletedSessions { get; set; }
    public double CompletionRate { get; set; }            // %
    public double AvgDaysToCompletion { get; set; }
}

public class RatingDistributionBucket
{
    public string Bucket { get; set; } = string.Empty;   // "5★", "4★", etc.
    public int Count { get; set; }
}

public class AnalyticsDashboardViewModel
{
    public AnalyticsFilter Filter { get; set; } = new();

    // Top-line metrics
    public int TotalUsers { get; set; }
    public int ActiveTrainees { get; set; }
    public int ActiveMentors { get; set; }
    public int TopMentorsTotalCount { get; set; }
    public int TotalBookings { get; set; }
    public int PendingMentorApplications { get; set; }
    public int CompletedLicenses { get; set; }

    // Charts
    public List<TimeSeriesPoint> UsersOverTime { get; set; } = new();
    public List<TimeSeriesPoint> BookingsPerMonth { get; set; } = new();
    public List<RatingDistributionBucket> MentorPerformanceDistribution { get; set; } = new();

    // Mentor performance table
    public List<MentorPerformanceItem> TopMentors { get; set; } = new();

    // Platform-wide rollups
    public double PlatformAvgRating { get; set; }
    public double PlatformCompletionRate { get; set; }
    public double PlatformAvgDaysToCompletion { get; set; }
}

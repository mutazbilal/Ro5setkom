namespace Rokhsetak.Areas.Trainee.ViewModels.Calendar;

public class CalendarEventViewModel
{
    public string Title { get; set; } = string.Empty;
    public string Start { get; set; } = string.Empty;  // ISO 8601
    public string End { get; set; } = string.Empty;
    public string Color { get; set; } = "#0d6efd";
    public string EventType { get; set; } = string.Empty;  // booking | exam
    public string? Location { get; set; }
    public string Status { get; set; } = string.Empty;
    public string? Url { get; set; }
}
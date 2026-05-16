using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Trainee.ViewModels.Calendar;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations;

public class CalendarService : ICalendarService
{
    private readonly RokhsetakDbContext _context;

    public CalendarService(RokhsetakDbContext context)
    {
        _context = context;
    }

    public async Task<ServiceResult<List<CalendarEventViewModel>>> GetCalendarEventsAsync(int traineeId)
    {
        var events = new List<CalendarEventViewModel>();

        // ── Mentor session bookings ────────────────────────────────────────────
        var bookings = await (
            from b in _context.Bookings
            join u in _context.Users on b.MentorId equals u.UserId
            where b.TraineeId == traineeId && b.Status != "cancelled"
            select new
            {
                b.BookingDate,
                b.StartTime,
                b.EndTime,
                b.Status,
                b.SessionType,
                MentorName = u.FirstName + " " + u.LastName
            }
        ).ToListAsync();

        foreach (var b in bookings)
        {
            var color = b.Status switch
            {
                "confirmed" => "#198754",   // green
                "pending" => "#fd7e14",   // orange
                "completed" => "#6c757d",   // grey
                _ => "#0d6efd"
            };

            var startDt = b.BookingDate.ToDateTime(b.StartTime);
            var endDt = b.BookingDate.ToDateTime(b.EndTime);

            events.Add(new CalendarEventViewModel
            {
                Title = $"{b.SessionType.Capitalize()} session — {b.MentorName}",
                Start = startDt.ToString("o"),
                End = endDt.ToString("o"),
                Color = color,
                EventType = "booking",
                Status = b.Status
            });
        }

        // ── Exam appointments ─────────────────────────────────────────────────
        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeId == traineeId && tl.IsActive);

        if (license != null)
        {
            var examAppts = await _context.ExamAppointments
                .Where(ea => ea.TraineeId == traineeId
                          && ea.TraineeLicenseId == license.TraineeLicenseId
                          && ea.Status != "cancelled")
                .Join(_context.GovOfficialExams,
                      ea => ea.OfficialExamId,
                      e => e.OfficialExamId,
                      (ea, e) => new { ea.Status, e.ExamType, e.ExamDate, e.ExamTime, e.CenterId })
                .Join(_context.GovExamCenters,
                      x => x.CenterId,
                      c => c.CenterId,
                      (x, c) => new
                      {
                          x.Status,
                          x.ExamType,
                          x.ExamDate,
                          x.ExamTime,
                          CenterName = c.Name,
                          City = c.City
                      })
                .ToListAsync();

            foreach (var ea in examAppts)
            {
                var color = ea.Status switch
                {
                    "completed" => "#6c757d",
                    "scheduled" => "#dc3545",   // red — important exam
                    _ => "#adb5bd"
                };

                var examDt = ea.ExamDate.ToDateTime(ea.ExamTime);

                events.Add(new CalendarEventViewModel
                {
                    Title = $"{ea.ExamType.Capitalize()} Exam — {ea.CenterName}",
                    Start = examDt.ToString("o"),
                    End = examDt.AddHours(2).ToString("o"), // estimate 2hrs
                    Color = color,
                    EventType = "exam",
                    Location = $"{ea.CenterName}, {ea.City}",
                    Status = ea.Status
                });
            }
        }

        return ServiceResult<List<CalendarEventViewModel>>.Success(events);
    }
}
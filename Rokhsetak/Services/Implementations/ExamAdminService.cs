using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Admin.ViewModels.Exams;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations;

public class ExamAdminService : IExamAdminService
{
    private readonly RokhsetakDbContext _context;

    public ExamAdminService(RokhsetakDbContext context)
    {
        _context = context;
    }

    public async Task<ServiceResult<AdminExamAppointmentListViewModel>> GetExamAppointmentsAsync(ExamFilter filter)
    {
        if (filter.Page < 1) filter.Page = 1;
        if (filter.PageSize < 1 || filter.PageSize > 100) filter.PageSize = 20;

        var query =
            from ea in _context.ExamAppointments.AsNoTracking()
            join trainee in _context.Users on ea.TraineeId equals trainee.UserId
            join exam in _context.GovOfficialExams on ea.OfficialExamId equals exam.OfficialExamId
            join center in _context.GovExamCenters on exam.CenterId equals center.CenterId into cj
            from center in cj.DefaultIfEmpty()
            join lt in _context.LicenseTypes on exam.LicenseTypeId equals lt.LicenseTypeId into ltj
            from lt in ltj.DefaultIfEmpty()
            select new
            {
                ea,
                exam,
                TraineeFirst = trainee.FirstName,
                TraineeLast = trainee.LastName,
                CenterName = center != null ? center.Name : "—",
                LicenseName = lt != null ? lt.LicenseName : "—"
            };

        if (!string.IsNullOrWhiteSpace(filter.Status))
            query = query.Where(x => x.ea.Status == filter.Status);

        if (filter.FromDate.HasValue)
            query = query.Where(x => x.exam.ExamDate >= filter.FromDate.Value);

        if (filter.ToDate.HasValue)
            query = query.Where(x => x.exam.ExamDate <= filter.ToDate.Value);

        if (filter.TraineeId.HasValue)
            query = query.Where(x => x.ea.TraineeId == filter.TraineeId.Value);

        if (!string.IsNullOrWhiteSpace(filter.Search))
        {
            var s = filter.Search.Trim().ToLower();
            query = query.Where(x =>
                (x.TraineeFirst + " " + x.TraineeLast).ToLower().Contains(s));
        }

        var total = await query.CountAsync();

        var items = await query
            .OrderByDescending(x => x.exam.ExamDate)
            .ThenByDescending(x => x.exam.ExamTime)
            .Skip((filter.Page - 1) * filter.PageSize)
            .Take(filter.PageSize)
            .Select(x => new AdminExamAppointmentItem
            {
                ExamAppointmentId = x.ea.ExamAppointmentId,
                OfficialExamId = x.exam.OfficialExamId,
                TraineeId = x.ea.TraineeId,
                TraineeName = x.TraineeFirst + " " + x.TraineeLast,
                ExamDate = x.exam.ExamDate,
                ExamTime = x.exam.ExamTime,
                ExamType = x.exam.ExamType,
                Status = x.ea.Status,
                CenterName = x.CenterName,
                LicenseType = x.LicenseName,
                CreatedAt = x.ea.CreatedAt
            })
            .ToListAsync();

        return ServiceResult<AdminExamAppointmentListViewModel>.Success(new AdminExamAppointmentListViewModel
        {
            Filter = filter,
            Items = items,
            TotalCount = total
        });
    }
}

using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Admin.ViewModels.BlockedDates;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations;

public class BlockedDateService : IBlockedDateService
{
    private readonly RokhsetakDbContext _context;
    private readonly IAuditService _audit;

    public BlockedDateService(RokhsetakDbContext context, IAuditService audit)
    {
        _context = context;
        _audit = audit;
    }

    public async Task<ServiceResult<BlockedDateListViewModel>> GetBlockedDatesAsync()
    {
        var items = await (
            from bd in _context.BlockedDates.AsNoTracking()
            join u in _context.Users on bd.BlockedBy equals u.UserId into uj
            from u in uj.DefaultIfEmpty()
            orderby bd.BlockedDate1 descending
            select new BlockedDateItem
            {
                BlockedDateId = bd.BlockedDateId,
                Date = bd.BlockedDate1,
                Reason = bd.Reason,
                CreatedAt = bd.CreatedAt,
                CreatedByName = u != null ? (u.FirstName + " " + u.LastName) : "—"
            }
        ).ToListAsync();

        return ServiceResult<BlockedDateListViewModel>.Success(new BlockedDateListViewModel
        {
            Items = items
        });
    }

    public async Task<ServiceResult> AddBlockedDateAsync(int adminUserId, CreateBlockedDateViewModel model)
    {
        if (model.Date < DateOnly.FromDateTime(DateTime.UtcNow))
            return ServiceResult.Failure("Cannot block a date in the past.");

        bool duplicate = await _context.BlockedDates
            .AnyAsync(bd => bd.BlockedDate1 == model.Date);

        if (duplicate)
            return ServiceResult.Failure("This date is already blocked.");

        var entry = new BlockedDate
        {
            BlockedDate1 = model.Date,
            Reason = string.IsNullOrWhiteSpace(model.Reason) ? null : model.Reason.Trim(),
            BlockedBy = adminUserId,
            CreatedAt = DateTime.UtcNow
        };

        _context.BlockedDates.Add(entry);
        await _context.SaveChangesAsync();   // need PK for audit record_id

        _audit.Log(adminUserId, "AddBlockedDate", "BlockedDates", entry.BlockedDateId.ToString());
        await _context.SaveChangesAsync();

        return ServiceResult.Success();
    }

    public async Task<ServiceResult> RemoveBlockedDateAsync(int adminUserId, int blockedDateId)
    {
        var entry = await _context.BlockedDates
            .FirstOrDefaultAsync(bd => bd.BlockedDateId == blockedDateId);

        if (entry == null) return ServiceResult.Failure("Blocked date not found.");

        _context.BlockedDates.Remove(entry);
        _audit.Log(adminUserId, "RemoveBlockedDate", "BlockedDates", blockedDateId.ToString());
        await _context.SaveChangesAsync();

        return ServiceResult.Success();
    }
}

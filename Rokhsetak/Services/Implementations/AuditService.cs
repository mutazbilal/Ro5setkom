using Rokhsetak.Models;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations;

public class AuditService : IAuditService
{
    private readonly RokhsetakDbContext _context;

    public AuditService(RokhsetakDbContext context)
    {
        _context = context;
    }

    public void Log(int userId, string action, string tableName, string recordId)
    {
        _context.AuditLogs.Add(new AuditLog
        {
            UserId = userId,
            Action = action,
            TableName = tableName,
            RecordId = recordId,
            PerformedAt = DateTime.UtcNow
        });
    }
}

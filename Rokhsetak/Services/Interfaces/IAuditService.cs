namespace Rokhsetak.Services.Interfaces;

/// <summary>
/// Central audit logging service. Adds an AuditLog entry to the change tracker
/// (no SaveChanges call) so callers can persist audit + business changes
/// in a single transactional SaveChangesAsync.
/// </summary>
public interface IAuditService
{
    void Log(int userId, string action, string tableName, string recordId);
}

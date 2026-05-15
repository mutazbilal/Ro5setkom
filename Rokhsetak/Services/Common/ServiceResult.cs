namespace Rokhsetak.Services.Common;

/// <summary>
/// Generic result wrapper used by all service methods to communicate
/// success/failure and any validation messages back to the controller
/// without throwing exceptions for business rule violations.
/// </summary>
public class ServiceResult
{
    public bool Succeeded { get; private set; }
    public string? Error { get; private set; }

    protected ServiceResult(bool succeeded, string? error = null)
    {
        Succeeded = succeeded;
        Error = error;
    }

    public static ServiceResult Success() => new(true);
    public static ServiceResult Failure(string error) => new(false, error);
}

public class ServiceResult<T> : ServiceResult
{
    public T? Data { get; private set; }

    private ServiceResult(bool succeeded, T? data, string? error = null)
        : base(succeeded, error)
    {
        Data = data;
    }

    public static ServiceResult<T> Success(T data) => new(true, data);
    public static new ServiceResult<T> Failure(string error) => new(false, default, error);
}

/// <summary>
/// Carries gov-citizen data back to the controller after National ID lookup
/// so the controller can hydrate the ViewModel without touching the DB directly.
/// </summary>
public class GovCitizenDto
{
    public string NationalId { get; set; } = null!;
    public string FirstName { get; set; } = null!;
    public string LastName { get; set; } = null!;
    public DateOnly DateOfBirth { get; set; }
    public string Gender { get; set; } = null!;
    public string Province { get; set; } = null!;
    public string City { get; set; } = null!;
    public string AddressLine1 { get; set; } = null!;
    public string? AddressLine2 { get; set; }
    public string? PostalCode { get; set; }
}

/// <summary>
/// Returned after a successful login so the controller knows which
/// dashboard to redirect to.
/// </summary>
public class LoginResultDto
{
    public int UserId { get; set; }
    public string NationalId { get; set; } = null!;
    public string FullName { get; set; } = null!;
    public string RoleName { get; set; } = null!;
    public int RoleId { get; set; }
    public string Language { get; set; } = "en";
}

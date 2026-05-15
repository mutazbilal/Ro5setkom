using System.Security.Claims;
using System.Text.Encodings.Web;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace RokhsetakIntegrationTests.Infrastructure;

public sealed class TestAuthHandler : AuthenticationHandler<AuthenticationSchemeOptions>
{
    public const string SchemeName = "Test";

    public const string UserIdHeader = "X-Test-User-Id";
    public const string RoleHeader = "X-Test-Role";
    public const string NationalIdHeader = "X-Test-National-Id";

    public TestAuthHandler(
        IOptionsMonitor<AuthenticationSchemeOptions> options,
        ILoggerFactory logger,
        UrlEncoder encoder)
        : base(options, logger, encoder) { }

    protected override Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        if (!Request.Headers.TryGetValue(UserIdHeader, out var userIdValues))
            return Task.FromResult(AuthenticateResult.NoResult());

        var userId = userIdValues.ToString();
        var role = Request.Headers.TryGetValue(RoleHeader, out var r) ? r.ToString() : "trainee";
        var nationalId = Request.Headers.TryGetValue(NationalIdHeader, out var n) ? n.ToString() : "0000000000";

        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, userId),
            new(ClaimTypes.Name,           nationalId),
            new(ClaimTypes.Role,           role),
            new("FullName",                "Test User"),
            new("RoleId",                  "0"),
            new("language",                "en")
        };

        var identity = new ClaimsIdentity(claims, SchemeName);
        var principal = new ClaimsPrincipal(identity);
        var ticket = new AuthenticationTicket(principal, SchemeName);
        return Task.FromResult(AuthenticateResult.Success(ticket));
    }

    protected override Task HandleChallengeAsync(AuthenticationProperties properties)
    {
        // Mimic the cookie scheme: unauthenticated requests are redirected to /Auth/Login.
        Response.Redirect("/Auth/Login");
        return Task.CompletedTask;
    }

    protected override Task HandleForbiddenAsync(AuthenticationProperties properties)
    {
        Response.Redirect("/Auth/AccessDenied");
        return Task.CompletedTask;
    }
}
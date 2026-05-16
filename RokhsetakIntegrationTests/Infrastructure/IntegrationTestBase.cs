using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Rokhsetak.Models;

namespace RokhsetakIntegrationTests.Infrastructure;

public abstract class IntegrationTestBase
{
    protected RokhsetakWebApplicationFactory Factory { get; private set; } = null!;
    protected HttpClient Client { get; private set; } = null!;

    /// <summary>
    /// Per-test setup. Override <see cref="SeedFixture"/> to plant test data.
    /// </summary>
    [TestInitialize]
    public void Initialize()
    {
        Factory = new RokhsetakWebApplicationFactory
        {
            SeedAction = SeedFixture
        };

        Client = Factory.CreateClient(new WebApplicationFactoryClientOptions
        {
            AllowAutoRedirect = false,
            HandleCookies = true
        });
    }

    [TestCleanup]
    public void Cleanup()
    {
        Client?.Dispose();
        Factory?.Dispose();
    }

    /// <summary>Override in derived test classes to seed entities for the fixture.</summary>
    protected virtual void SeedFixture(RokhsetakDbContext db) { }

    // ── Authentication helpers ──────────────────────────────────────────────
    protected void AuthenticateAs(int userId, string role, string nationalId = "1234567890")
    {
        Client.DefaultRequestHeaders.Remove(TestAuthHandler.UserIdHeader);
        Client.DefaultRequestHeaders.Remove(TestAuthHandler.RoleHeader);
        Client.DefaultRequestHeaders.Remove(TestAuthHandler.NationalIdHeader);

        Client.DefaultRequestHeaders.Add(TestAuthHandler.UserIdHeader, userId.ToString());
        Client.DefaultRequestHeaders.Add(TestAuthHandler.RoleHeader, role);
        Client.DefaultRequestHeaders.Add(TestAuthHandler.NationalIdHeader, nationalId);
    }

    protected void AuthenticateAsMentor(int userId = 100) => AuthenticateAs(userId, "mentor");
    protected void AuthenticateAsTrainee(int userId = 200) => AuthenticateAs(userId, "trainee");

    // ── Form / antiforgery helpers ──────────────────────────────────────────
    protected async Task<string> GetAntiforgeryTokenAsync(string getPath)
    {
        var response = await Client.GetAsync(getPath);
        response.EnsureSuccessStatusCode();
        var html = await response.Content.ReadAsStringAsync();
        return AntiforgeryTokenExtractor.Extract(html);
    }

    protected Task<HttpResponseMessage> PostFormAsync(
        string postPath, IDictionary<string, string> fields, string token)
    {
        fields["__RequestVerificationToken"] = token;
        return Client.PostAsync(postPath, new FormUrlEncodedContent(fields));
    }

    // ── Localization ────────────────────────────────────────────────────────
    protected void SetCulture(string culture)
    {
        Client.DefaultRequestHeaders.AcceptLanguage.Clear();
        Client.DefaultRequestHeaders.AcceptLanguage.Add(
            new System.Net.Http.Headers.StringWithQualityHeaderValue(culture));
    }

    // ── Direct DB access for post-condition assertions ──────────────────────
    protected async Task<T> WithDbAsync<T>(Func<RokhsetakDbContext, Task<T>> action)
    {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<RokhsetakDbContext>();
        return await action(db);
    }

    protected async Task WithDbAsync(Func<RokhsetakDbContext, Task> action)
    {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<RokhsetakDbContext>();
        await action(db);
    }
}
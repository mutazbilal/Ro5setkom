using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.DependencyInjection;
using Rokhsetak.Models;
using Rokhsetak.Services.Interfaces;
using Microsoft.AspNetCore.Antiforgery;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Http;

namespace RokhsetakIntegrationTests.Infrastructure;

public sealed class RokhsetakWebApplicationFactory : WebApplicationFactory<Program>
{
    private readonly string _dbName = $"RokhsetakIT_{Guid.NewGuid():N}";

    /// <summary>
    /// Optional hook executed once when the factory's services are first built.
    /// Use it from a test to insert fixture-specific entities.
    /// </summary>
    public Action<Ro5setkomDbContext>? SeedAction { get; set; }

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseEnvironment("Testing");

        builder.ConfigureTestServices(services =>
        {
            // ── 1. Replace SQL Server with EF Core InMemory ──────────────────
            RemoveDbContextRegistrations<Ro5setkomDbContext>(services);

            services.AddDbContext<Ro5setkomDbContext>(opt =>
                opt.UseInMemoryDatabase(_dbName));

            // ── 2. Replace authentication: Test is now the default scheme ───
            services.AddAuthentication(TestAuthHandler.SchemeName)
                    .AddScheme<AuthenticationSchemeOptions, TestAuthHandler>(
                        TestAuthHandler.SchemeName, _ => { });

            services.PostConfigure<AuthenticationOptions>(opt =>
            {
                opt.DefaultAuthenticateScheme = TestAuthHandler.SchemeName;
                opt.DefaultChallengeScheme = TestAuthHandler.SchemeName;
                opt.DefaultForbidScheme = TestAuthHandler.SchemeName;
                opt.DefaultScheme = TestAuthHandler.SchemeName;
            });
            // ── Relax cookie security so HTTP TestServer can actually set cookies ──
            services.PostConfigure<AntiforgeryOptions>(options =>
            {
                options.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;
            });

            services.PostConfigure<CookieAuthenticationOptions>(
                CookieAuthenticationDefaults.AuthenticationScheme,
                options =>
                {
                    options.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;
                });
            // ── 3. Stub services with external side-effects ──────────────────
            Remove<IEmailService>(services);
            services.AddSingleton<IEmailService, NoOpEmailService>();

            // ── 4. Seed base reference data + caller-supplied fixture ────────
            var sp = services.BuildServiceProvider();
            using var scope = sp.CreateScope();
            var db = scope.ServiceProvider.GetRequiredService<Ro5setkomDbContext>();
            db.Database.EnsureCreated();
            DatabaseSeeder.SeedReferenceData(db);
            SeedAction?.Invoke(db);
        });
    }

    private static void Remove<TService>(IServiceCollection services)
    {
        var descriptor = services.SingleOrDefault(d => d.ServiceType == typeof(TService));
        if (descriptor != null) services.Remove(descriptor);
    }
    private static void RemoveDbContextRegistrations<TContext>(IServiceCollection services)
    where TContext : DbContext
    {
        var descriptors = services
            .Where(d =>
                d.ServiceType == typeof(DbContextOptions<TContext>) ||
                d.ServiceType == typeof(DbContextOptions) ||
                d.ServiceType == typeof(TContext) ||
                (d.ServiceType.IsGenericType &&
                 d.ServiceType.GetGenericTypeDefinition() == typeof(IDbContextOptionsConfiguration<>)))
            .ToList();

        foreach (var d in descriptors)
            services.Remove(d);
    }
}
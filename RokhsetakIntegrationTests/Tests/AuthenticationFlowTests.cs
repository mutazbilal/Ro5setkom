using System.Net;
using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rokhsetak.Models;
using RokhsetakIntegrationTests.Infrastructure;

namespace RokhsetakIntegrationTests.Tests;

[TestClass]
public sealed class AuthenticationFlowTests : IntegrationTestBase
{
    private const string NationalId = "9000000001";
    private const string Password = "StrongP@ssw0rd";

    protected override void SeedFixture(Ro5setkomDbContext db)
    {
        db.GovCitizens.Add(DatabaseSeeder.NewCitizen(NationalId));
        db.Users.Add(DatabaseSeeder.NewUser(
            userId: 500,
            nationalId: NationalId,
            roleId: DatabaseSeeder.RoleTraineeId,
            email: "trainee@example.com",
            plainPassword: Password));
        db.SaveChanges();
    }

    [TestMethod]
    public async Task Login_WithValidCredentials_RedirectsAwayFromLoginPage()
    {
        // Arrange
        var token = await GetAntiforgeryTokenAsync("/Auth/Login");

        // Act
        var response = await PostFormAsync("/Auth/Login",
            new Dictionary<string, string>
            {
                ["NationalId"] = NationalId,
                ["Password"] = Password,
                ["RememberMe"] = "false"
            },
            token);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Redirect,
            "successful login redirects to the role-specific dashboard");
        response.Headers.Location.Should().NotBeNull();
        response.Headers.Location!.ToString()
            .Should().NotContain("/Auth/Login");
    }

    [TestMethod]
    public async Task Login_WithInvalidPassword_RedisplaysLoginViewWithError()
    {
        // Arrange
        var token = await GetAntiforgeryTokenAsync("/Auth/Login");

        // Act
        var response = await PostFormAsync("/Auth/Login",
            new Dictionary<string, string>
            {
                ["NationalId"] = NationalId,
                ["Password"] = "wrong-password",
                ["RememberMe"] = "false"
            },
            token);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK,
            "an invalid login re-renders the form rather than redirecting");
    }

    [TestMethod]
    public async Task Logout_AsAuthenticatedUser_RedirectsToLoginPage()
    {
        // Arrange
        AuthenticateAsTrainee(500);

        // /Auth/ForgotPassword is AllowAnonymous *and* does not bounce
        // authenticated users, so it can serve a valid token to anyone.
        var token = await GetAntiforgeryTokenAsync("/Auth/ForgotPassword");

        // Act
        var response = await PostFormAsync("/Auth/Logout",
            new Dictionary<string, string>(),
            token);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Redirect);
        response.Headers.Location!.ToString().Should().Contain("/Auth/Login");
    }
}
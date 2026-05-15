using System.Net;
using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using RokhsetakIntegrationTests.Infrastructure;

namespace RokhsetakIntegrationTests.Tests;

[TestClass]
public sealed class AuthorizationTests : IntegrationTestBase
{
    [TestMethod]
    public async Task UnauthenticatedRequest_ToMentorDashboard_RedirectsToLogin()
    {
        // Arrange: no auth headers set.

        // Act
        var response = await Client.GetAsync("/Mentor/Dashboard");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Redirect);
        response.Headers.Location!.ToString()
            .Should().StartWith("/Auth/Login");
    }

    [TestMethod]
    public async Task TraineeRole_AccessingMentorArea_IsRedirectedToAccessDenied()
    {
        // Arrange
        AuthenticateAsTrainee();

        // Act
        var response = await Client.GetAsync("/Mentor/Dashboard");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Redirect);
        response.Headers.Location!.ToString()
            .Should().StartWith("/Auth/AccessDenied");
    }

    [TestMethod]
    public async Task MentorRole_AccessingTraineeArea_IsRedirectedToAccessDenied()
    {
        // Arrange
        AuthenticateAsMentor();

        // Act
        var response = await Client.GetAsync("/Trainee/Dashboard");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Redirect);
        response.Headers.Location!.ToString()
            .Should().StartWith("/Auth/AccessDenied");
    }

    [TestMethod]
    public async Task AnonymousRequest_ToPublicLoginPage_Succeeds()
    {
        var response = await Client.GetAsync("/Auth/Login");

        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var body = await response.Content.ReadAsStringAsync();
        body.Should().Contain("__RequestVerificationToken",
            "the login form must include an antiforgery token");
    }
}
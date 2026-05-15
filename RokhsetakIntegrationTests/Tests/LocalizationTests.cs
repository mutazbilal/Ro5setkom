using System.Net;
using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rokhsetak.Models;
using RokhsetakIntegrationTests.Infrastructure;

namespace RokhsetakIntegrationTests.Tests;

[TestClass]
public sealed class LocalizationTests : IntegrationTestBase
{
    private const int TraineeId = 7700;
    private const int MentorId = 7701;
    private const int LicenseId = 7702;
    private const int ModuleId = 7703;

    private const string EnglishTitle = "Road Signs in English";
    private const string ArabicTitle = "إشارات الطريق";

    protected override void SeedFixture(Ro5setkomDbContext db)
    {
        db.GovCitizens.AddRange(
            DatabaseSeeder.NewCitizen("5000000001"),
            DatabaseSeeder.NewCitizen("5000000002"));

        db.Users.AddRange(
            DatabaseSeeder.NewUser(TraineeId, "5000000001", DatabaseSeeder.RoleTraineeId, "loc-t@example.com"),
            DatabaseSeeder.NewUser(MentorId, "5000000002", DatabaseSeeder.RoleMentorId, "loc-m@example.com"));

        db.Mentors.Add(DatabaseSeeder.NewMentor(MentorId));
        db.Trainees.Add(DatabaseSeeder.NewTrainee(TraineeId));
        db.TraineeLicenses.Add(
            DatabaseSeeder.NewTraineeLicense(LicenseId, TraineeId, MentorId));

        db.LearningModules.Add(new LearningModule
        {
            ModuleId = ModuleId,
            LicenseTypeId = DatabaseSeeder.LicenseTypeBId,
            Phase = "theoretical",
            OrderIndex = 1
        });

        db.ModuleTranslations.AddRange(
            new ModuleTranslation { ModuleId = ModuleId, LanguageCode = "en", Title = EnglishTitle },
            new ModuleTranslation { ModuleId = ModuleId, LanguageCode = "ar", Title = ArabicTitle });

        db.SaveChanges();
    }

    [TestMethod]
    public async Task TraineeDashboard_WithArabicAcceptLanguage_ReturnsArabicModuleTitle()
    {
        // Arrange
        AuthenticateAsTrainee(TraineeId);
        SetCulture("ar");

        // Act
        var response = await Client.GetAsync("/Trainee/Dashboard");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var html = await response.Content.ReadAsStringAsync();
        html.Should().Contain(ArabicTitle);
        html.Should().NotContain(EnglishTitle);
    }

    [TestMethod]
    public async Task TraineeDashboard_WithEnglishAcceptLanguage_ReturnsEnglishModuleTitle()
    {
        // Arrange
        AuthenticateAsTrainee(TraineeId);
        SetCulture("en");

        // Act
        var response = await Client.GetAsync("/Trainee/Dashboard");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var html = await response.Content.ReadAsStringAsync();
        html.Should().Contain(EnglishTitle);
    }
}
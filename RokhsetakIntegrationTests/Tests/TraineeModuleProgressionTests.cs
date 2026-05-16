using System.Net;
using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rokhsetak.Models;
using RokhsetakIntegrationTests.Infrastructure;

namespace RokhsetakIntegrationTests.Tests;

[TestClass]
public sealed class TraineeModuleProgressionTests : IntegrationTestBase
{
    private const int TraineeId = 5001;
    private const int MentorId = 6001;
    private const int LicenseId = 7001;
    private const int ModuleId = 8001;

    protected override void SeedFixture(RokhsetakDbContext db)
    {
        db.GovCitizens.AddRange(
            DatabaseSeeder.NewCitizen("3000000001", "Trainee", "Y"),
            DatabaseSeeder.NewCitizen("3000000002", "Mentor", "Z"));

        db.Users.AddRange(
            DatabaseSeeder.NewUser(TraineeId, "3000000001", DatabaseSeeder.RoleTraineeId, "ty@example.com"),
            DatabaseSeeder.NewUser(MentorId, "3000000002", DatabaseSeeder.RoleMentorId, "mz@example.com"));

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

        db.ModuleTranslations.Add(new ModuleTranslation
        {
            ModuleId = ModuleId,
            LanguageCode = "en",
            Title = "Module One",
            Description = "First module"
        });

        db.SaveChanges();
    }

    [TestMethod]
    public async Task ViewingModuleDetail_AsTrainee_CreatesInProgressRow()
    {
        // Arrange: precondition — no progress row yet.
        var existing = await WithDbAsync(db =>
            db.TraineeModuleProgresses.AnyAsync(p =>
                p.TraineeId == TraineeId && p.ModuleId == ModuleId));
        existing.Should().BeFalse();

        AuthenticateAsTrainee(TraineeId);

        // Act
        var response = await Client.GetAsync($"/Trainee/Modules/Detail/{ModuleId}");

        // Assert: HTTP success
        response.StatusCode.Should().Be(HttpStatusCode.OK,
            "viewing a module detail must render the module page");

        // Assert: side-effect persisted in DB
        var progress = await WithDbAsync(db => db.TraineeModuleProgresses
            .AsNoTracking()
            .SingleOrDefaultAsync(p =>
                p.TraineeId == TraineeId && p.ModuleId == ModuleId));

        progress.Should().NotBeNull(
            "GET /Trainee/Modules/Detail/{id} must auto-start the module");
        progress!.Status.Should().Be("in_progress");
        progress.StartedAt.Should().NotBeNull();
    }
}
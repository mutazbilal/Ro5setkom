using System.Net;
using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rokhsetak.Models;
using RokhsetakIntegrationTests.Infrastructure;

namespace RokhsetakIntegrationTests.Tests;

[TestClass]
public sealed class MentorAppointmentTests : IntegrationTestBase
{
    private const int MentorAId = 1001;
    private const int MentorBId = 1002;
    private const int TraineeId = 2001;
    private const int LicenseId = 3001;
    private const int BookingId = 4001;

    protected override void SeedFixture(RokhsetakDbContext db)
    {
        db.GovCitizens.AddRange(
            DatabaseSeeder.NewCitizen("1000000001", "Mentor", "A"),
            DatabaseSeeder.NewCitizen("1000000002", "Mentor", "B"),
            DatabaseSeeder.NewCitizen("2000000001", "Trainee", "X"));

        db.Users.AddRange(
            DatabaseSeeder.NewUser(MentorAId, "1000000001", DatabaseSeeder.RoleMentorId, "ma@example.com"),
            DatabaseSeeder.NewUser(MentorBId, "1000000002", DatabaseSeeder.RoleMentorId, "mb@example.com"),
            DatabaseSeeder.NewUser(TraineeId, "2000000001", DatabaseSeeder.RoleTraineeId, "t@example.com"));

        db.Mentors.AddRange(
            DatabaseSeeder.NewMentor(MentorAId),
            DatabaseSeeder.NewMentor(MentorBId));

        db.Trainees.Add(DatabaseSeeder.NewTrainee(TraineeId));

        db.TraineeLicenses.Add(
            DatabaseSeeder.NewTraineeLicense(LicenseId, TraineeId, MentorAId));

        db.Bookings.Add(new Booking
        {
            BookingId = BookingId,
            MentorId = MentorAId,
            TraineeId = TraineeId,
            TraineeLicenseId = LicenseId,
            LicenseTypeId = DatabaseSeeder.LicenseTypeBId,
            BookingDate = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(2)),
            StartTime = new TimeOnly(10, 0),
            EndTime = new TimeOnly(11, 0),
            SessionType = "practical",
            Status = "pending"
        });

        db.SaveChanges();
    }

    [TestMethod]
    public async Task Confirm_OtherMentorsBooking_DoesNotMutateDatabase()
    {
        // Arrange: authenticate as Mentor B, but the booking belongs to Mentor A.
        AuthenticateAs(MentorBId, "mentor");
        var token = await GetAntiforgeryTokenAsync("/Mentor/Appointments");

        // Act
        var response = await PostFormAsync("/Mentor/Appointments/Confirm",
            new Dictionary<string, string> { ["bookingId"] = BookingId.ToString() },
            token);

        // Assert: a redirect is returned (the controller always redirects to Index),
        //          but the booking status must remain unchanged.
        response.StatusCode.Should().Be(HttpStatusCode.Redirect);

        var persisted = await WithDbAsync(db =>
            db.Bookings.AsNoTracking().SingleAsync(b => b.BookingId == BookingId));
        persisted.Status.Should().Be("pending",
            "a mentor must not be able to confirm another mentor's booking");
    }

    [TestMethod]
    public async Task Index_AsMentor_RendersAppointmentsListing()
    {
        // Arrange
        AuthenticateAs(MentorAId, "mentor");

        // Act
        var response = await Client.GetAsync("/Mentor/Appointments");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var html = await response.Content.ReadAsStringAsync();
        html.Should().NotBeNullOrWhiteSpace();
    }
}
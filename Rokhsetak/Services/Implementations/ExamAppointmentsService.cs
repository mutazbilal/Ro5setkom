using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Trainee.ViewModels.Exam;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;

namespace Rokhsetak.Services.Implementations;

public class ExamAppointmentService : IExamAppointmentService
{
    private readonly RokhsetakDbContext _context;
    private readonly INotificationService _notifications;

    public ExamAppointmentService(RokhsetakDbContext context, INotificationService notifications)
    {
        _context = context;
        _notifications = notifications;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET AVAILABLE EXAMS
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<ExamBookingViewModel>> GetAvailableExamsAsync(
        int traineeId, string examType)
    {
        if (examType is not ("theory" or "medical" or "practical"))
            return ServiceResult<ExamBookingViewModel>.Failure("Invalid exam type.");

        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeId == traineeId && tl.IsActive);

        if (license == null)
            return ServiceResult<ExamBookingViewModel>.Failure("No active license found.");

        // ── Eligibility checks ────────────────────────────────────────────────
        var (isEligible, reason) = await CheckEligibilityAsync(traineeId, license, examType);

        var vm = new ExamBookingViewModel
        {
            ExamType = examType,
            TraineeLicenseId = license.TraineeLicenseId,
            IsEligible = isEligible,
            IneligibilityReason = reason
        };

        if (!isEligible)
            return ServiceResult<ExamBookingViewModel>.Success(vm); // show locked screen

        // ── Find eligible exam center (via mentor → training center → city) ───
        var examCenterCity = await ResolveExamCenterCityAsync(traineeId, license);

        // ── Query available slots ─────────────────────────────────────────────
        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        var slotsQuery = _context.GovOfficialExams
            .Where(e => e.LicenseTypeId == license.LicenseTypeId
                     && e.ExamType == examType
                     && e.Status == "scheduled"
                     && e.ExamDate >= today
                     && e.BookedSlots < e.TotalSlots);

        // Already booked by this trainee
        var alreadyBooked = await _context.ExamAppointments
            .Where(ea => ea.TraineeId == traineeId
                      && ea.TraineeLicenseId == license.TraineeLicenseId
                      && ea.Status != "cancelled")
            .Select(ea => ea.OfficialExamId)
            .ToHashSetAsync();

        slotsQuery = slotsQuery.Where(e => !alreadyBooked.Contains(e.OfficialExamId));

        var slots = await slotsQuery
            .Include(e => e.Center)
            .Where(e => examCenterCity == null || e.Center.City == examCenterCity)
            .OrderBy(e => e.ExamDate)
            .ThenBy(e => e.ExamTime)
            .Take(20)
            .Select(e => new ExamSlotViewModel
            {
                OfficialExamId = e.OfficialExamId,
                CenterName = e.Center.Name,
                City = e.Center.City,
                ExamDate = e.ExamDate,
                ExamTime = e.ExamTime,
                SlotsRemaining = e.TotalSlots - e.BookedSlots
            })
            .ToListAsync();

        vm.AvailableSlots = slots;
        return ServiceResult<ExamBookingViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // BOOK EXAM
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> BookExamAsync(int traineeId, BookExamViewModel model)
    {
        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeLicenseId == model.TraineeLicenseId
                                    && tl.TraineeId == traineeId
                                    && tl.IsActive);

        if (license == null)
            return ServiceResult.Failure("Invalid license.");

        // Re-check eligibility
        var (isEligible, reason) = await CheckEligibilityAsync(traineeId, license, model.ExamType);
        if (!isEligible)
            return ServiceResult.Failure(reason);

        await using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            // Re-read exam inside transaction
            var exam = await _context.GovOfficialExams
                .FirstOrDefaultAsync(e => e.OfficialExamId == model.OfficialExamId
                                       && e.Status == "scheduled");

            if (exam == null)
                return ServiceResult.Failure("Exam slot not found.");

            if (exam.BookedSlots >= exam.TotalSlots)
                return ServiceResult.Failure("This exam slot is fully booked. Please choose another.");

            // No duplicate booking
            bool duplicate = await _context.ExamAppointments
                .AnyAsync(ea => ea.TraineeId == traineeId
                             && ea.OfficialExamId == model.OfficialExamId
                             && ea.Status != "cancelled");

            if (duplicate)
                return ServiceResult.Failure("You have already booked this exam.");

            // Also check trainee has no other active appointment for same exam type + license
            bool alreadyActiveForType = await _context.ExamAppointments
                .Join(_context.GovOfficialExams,
                      ea => ea.OfficialExamId,
                      e => e.OfficialExamId,
                      (ea, e) => new { ea, e })
                .AnyAsync(x => x.ea.TraineeId == traineeId
                            && x.ea.TraineeLicenseId == license.TraineeLicenseId
                            && x.e.ExamType == model.ExamType
                            && x.ea.Status == "scheduled");

            if (alreadyActiveForType)
                return ServiceResult.Failure($"You already have an active {model.ExamType} exam appointment.");

            exam.BookedSlots++;

            _context.ExamAppointments.Add(new ExamAppointment
            {
                TraineeId = traineeId,
                OfficialExamId = model.OfficialExamId,
                TraineeLicenseId = license.TraineeLicenseId,
                Status = "scheduled",
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            });

            // Advance license stage
            license.Stage = model.ExamType switch
            {
                "theory" => "theory_test_pending",
                "medical" => "medical_exam_pending",
                "practical" => "practical_test_pending",
                _ => license.Stage
            };
            license.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            await _notifications.CreateAsync(
                traineeId,
                $"{model.ExamType.Capitalize()} Exam Booked",
                $"Your {model.ExamType} exam is scheduled for {exam.ExamDate:dd MMM yyyy} at {exam.ExamTime}.",
                "exam");
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET MY EXAM APPOINTMENTS
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult<ExamAppointmentListViewModel>> GetMyExamAppointmentsAsync(
        int traineeId)
    {
        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeId == traineeId && tl.IsActive);

        if (license == null)
            return ServiceResult<ExamAppointmentListViewModel>.Failure("No active license found.");

        var appointments = await _context.ExamAppointments
            .Where(ea => ea.TraineeId == traineeId
                      && ea.TraineeLicenseId == license.TraineeLicenseId)
            .Join(_context.GovOfficialExams,
                  ea => ea.OfficialExamId,
                  e => e.OfficialExamId,
                  (ea, e) => new { ea, e })
            .Join(_context.GovExamCenters,
                  x => x.e.CenterId,
                  c => c.CenterId,
                  (x, c) => new { x.ea, x.e, c })
            .OrderByDescending(x => x.e.ExamDate)
            .Select(x => new
            {
                x.ea.ExamAppointmentId,
                x.ea.OfficialExamId,
                x.ea.Status,
                x.e.ExamType,
                x.e.ExamDate,
                x.e.ExamTime,
                CenterName = x.c.Name,
                City = x.c.City
            })
            .ToListAsync();

        // Fetch results from GovExamResults
        var examIds = appointments.Select(a => a.OfficialExamId).ToList();
        var trainee = await _context.Trainees
            .Where(t => t.TraineeId == traineeId)
            .Select(t => new { t.TraineeId })
            .FirstOrDefaultAsync();

        // Get national_id via Users table
        var nationalId = await _context.Users
            .Where(u => u.UserId == traineeId)
            .Select(u => u.NationalId)
            .FirstOrDefaultAsync();

        var results = nationalId != null
            ? await _context.GovExamResults
                .Where(r => examIds.Contains(r.OfficialExamId) && r.NationalId == nationalId)
                .ToDictionaryAsync(r => r.OfficialExamId)
            : new Dictionary<int, GovExamResult>();

        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        var items = appointments.Select(a =>
        {
            results.TryGetValue(a.OfficialExamId, out var result);
            return new ExamAppointmentItemViewModel
            {
                AppointmentId = a.ExamAppointmentId,
                OfficialExamId = a.OfficialExamId,
                ExamType = a.ExamType,
                CenterName = a.CenterName,
                City = a.City,
                ExamDate = a.ExamDate,
                ExamTime = a.ExamTime,
                Status = a.Status,
                Result = result?.Result,
                Score = result?.Score,
                CanCancel = a.Status == "scheduled" && a.ExamDate > today.AddDays(1)
            };
        }).ToList();

        // Apply result effects (pass → advance stage)
        await ApplyExamResultEffectsAsync(traineeId, license, items);

        return ServiceResult<ExamAppointmentListViewModel>.Success(
            new ExamAppointmentListViewModel { Appointments = items });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // CANCEL EXAM APPOINTMENT
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> CancelExamAppointmentAsync(int traineeId, int appointmentId)
    {
        var appointment = await _context.ExamAppointments
            .FirstOrDefaultAsync(ea => ea.ExamAppointmentId == appointmentId
                                    && ea.TraineeId == traineeId);

        if (appointment == null)
            return ServiceResult.Failure("Appointment not found.");

        if (appointment.Status != "scheduled")
            return ServiceResult.Failure("Only scheduled appointments can be cancelled.");

        var exam = await _context.GovOfficialExams
            .FirstOrDefaultAsync(e => e.OfficialExamId == appointment.OfficialExamId);

        if (exam == null)
            return ServiceResult.Failure("Exam not found.");

        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        if (exam.ExamDate <= today.AddDays(1))
            return ServiceResult.Failure("Exam appointment cannot be cancelled within 24 hours.");

        appointment.Status = "cancelled";
        appointment.UpdatedAt = DateTime.UtcNow;

        if (exam.BookedSlots > 0)
            exam.BookedSlots--;

        // Revert license stage
        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeLicenseId == appointment.TraineeLicenseId
                                    && tl.IsActive);

        if (license != null)
        {
            var examType = exam.ExamType;
            license.Stage = examType switch
            {
                "theory" => "mock_exam_completed",
                "medical" => "theory_passed",
                "practical" => "medical_passed",
                _ => license.Stage
            };
            license.UpdatedAt = DateTime.UtcNow;
        }

        await _context.SaveChangesAsync();

        await _notifications.CreateAsync(
            traineeId,
            "Exam Appointment Cancelled",
            $"Your {exam.ExamType} exam appointment on {exam.ExamDate:dd MMM yyyy} has been cancelled.",
            "exam");

        return ServiceResult.Success();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRIVATE HELPERS
    // ─────────────────────────────────────────────────────────────────────────

    private async Task<(bool isEligible, string reason)> CheckEligibilityAsync(
        int traineeId, TraineeLicense license, string examType)
    {
        switch (examType)
        {
            case "theory":
            case "medical":
                {
                    // All theoretical modules completed
                    var theoreticalIds = await _context.LearningModules
                        .Where(m => m.LicenseTypeId == license.LicenseTypeId && m.Phase == "theoretical")
                        .Select(m => m.ModuleId)
                        .ToListAsync();

                    var completedCount = await _context.TraineeModuleProgresses
                        .CountAsync(p => p.TraineeId == traineeId
                                      && p.TraineeLicenseId == license.TraineeLicenseId
                                      && theoreticalIds.Contains(p.ModuleId)
                                      && p.Status == "completed");

                    if (completedCount < theoreticalIds.Count)
                        return (false, "You must complete all theoretical modules before booking this exam.");

                    // Mock exam completed
                    var mockQuiz = await _context.Quizzes
                        .FirstOrDefaultAsync(q => q.IsMockExam == true && q.LicenseTypeId == license.LicenseTypeId);

                    if (mockQuiz != null)
                    {
                        bool mockDone = await _context.QuizAttempts
                            .AnyAsync(a => a.QuizId == mockQuiz.QuizId
                                        && a.TraineeId == traineeId
                                        && a.TraineeLicenseId == license.TraineeLicenseId);

                        if (!mockDone)
                            return (false, "You must complete the mock exam before booking the theory/medical exam.");
                    }

                    if (examType == "medical")
                    {
                        // Theory must be passed
                        if (license.Stage != "theory_passed" && license.Stage != "medical_exam_pending")
                            return (false, "You must pass the theory exam before booking the medical exam.");
                    }

                    return (true, string.Empty);
                }

            case "practical":
                {
                    // Theory + medical must be passed
                    if (license.Stage is not (
                        "medical_passed" or "practical_prep" or "practical_test_pending"))
                        return (false, "You must pass both the theory and medical exams before booking the practical exam.");

                    return (true, string.Empty);
                }

            default:
                return (false, "Unknown exam type.");
        }
    }

    private async Task<string?> ResolveExamCenterCityAsync(int traineeId, TraineeLicense license)
    {
        // Mentor → TrainingCenter → City → GovExamCenters in same city
        if (license.MentorId == null) return null;

        var trainingCenterId = await _context.Mentors
            .Where(m => m.MentorId == license.MentorId)
            .Select(m => (int?)m.TrainingCenterId)
            .FirstOrDefaultAsync();

        if (trainingCenterId == null) return null;

        return await _context.TrainingCenters
            .Where(tc => tc.CenterId == trainingCenterId)
            .Select(tc => (string?)tc.City)
            .FirstOrDefaultAsync();
    }

    private async Task ApplyExamResultEffectsAsync(
        int traineeId, TraineeLicense license, List<ExamAppointmentItemViewModel> items)
    {
        bool changed = false;

        foreach (var item in items.Where(i => i.Result == "pass"))
        {
            var newStage = item.ExamType switch
            {
                "theory" => "theory_passed",
                "medical" => "medical_passed",
                "practical" => "completed",
                _ => null
            };

            if (newStage != null && license.Stage != newStage && StagePriority(newStage) > StagePriority(license.Stage))
            {
                license.Stage = newStage;
                license.UpdatedAt = DateTime.UtcNow;
                changed = true;
            }
        }

        if (changed)
            await _context.SaveChangesAsync();
    }

    private static int StagePriority(string stage) => stage switch
    {
        "registered" => 0,
        "theoretical_prep" => 1,
        "mock_exam_completed" => 2,
        "theory_test_pending" => 3,
        "theory_passed" => 4,
        "medical_exam_pending" => 5,
        "medical_passed" => 6,
        "practical_prep" => 7,
        "practical_test_pending" => 8,
        "completed" => 9,
        _ => -1
    };
}

// ─── String extension ─────────────────────────────────────────────────────────
internal static class StringExtensions
{
    public static string Capitalize(this string s) =>
        string.IsNullOrEmpty(s) ? s : char.ToUpper(s[0]) + s[1..];
}
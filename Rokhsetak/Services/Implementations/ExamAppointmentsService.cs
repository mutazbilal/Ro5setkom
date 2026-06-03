using Microsoft.EntityFrameworkCore;
using Rokhsetak.Areas.Trainee.ViewModels.Exam;
using Rokhsetak.Models;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;
using System.Text.RegularExpressions;

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
        int traineeId, string examType, string culture = "ar")
    {
        if (examType is not ("theory" or "medical" or "practical"))
        {
            var message = culture == "en"
                ? "Invalid exam type."
                : "نوع الامتحان غير صالح.";

            return ServiceResult<ExamBookingViewModel>.Failure(message);
        }


        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeId == traineeId && tl.IsActive);

        if (license == null)
        {
            var message = culture == "en"
                ? "No active license found."
                : "لم يتم العثور على رخصة فعالة.";

            return ServiceResult<ExamBookingViewModel>.Failure(message);
        }
        var traineeNationalId = await _context.Users
            .Where(u => u.UserId == traineeId)
            .Select(u => u.NationalId)
            .FirstOrDefaultAsync();
        // ── Eligibility checks ────────────────────────────────────────────────
        var (isEligible, reason) = await CheckEligibilityAsync(traineeId, license, examType, traineeNationalId, culture);

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
        var examCenterCityId = await _context.Users
            .Where(u => u.UserId == traineeId)
            .Select(u => u.CityId)
            .FirstOrDefaultAsync();

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
            .Where(e => examCenterCityId == null || e.Center.CityId == examCenterCityId)
            .OrderBy(e => e.ExamDate)
            .ThenBy(e => e.ExamTime)
            .Take(20)
            .Select(e => new ExamSlotViewModel
            {
                OfficialExamId = e.OfficialExamId,
                CenterName = culture == "ar"? e.Center.Name :e.Center.DisplayNameEn,
                CityId = e.Center.CityId,
                ExamDate = e.ExamDate,
                ExamTime = e.ExamTime,
                SlotsRemaining = e.TotalSlots - e.BookedSlots,
                CityName = e.Center.City.CityTranslations
                    .Where(t => t.LanguageCode == culture)
                    .Select(t => t.DisplayName)
                    .FirstOrDefault(),
            })
            .ToListAsync();

        vm.AvailableSlots = slots;
        return ServiceResult<ExamBookingViewModel>.Success(vm);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // BOOK EXAM
    // ─────────────────────────────────────────────────────────────────────────
    public async Task<ServiceResult> BookExamAsync(int traineeId, BookExamViewModel model, string culture)
    {
        var license = await _context.TraineeLicenses
                .Include(t => t.Trainee)
                    .ThenInclude(u => u.TraineeNavigation)
            .FirstOrDefaultAsync(tl => tl.TraineeLicenseId == model.TraineeLicenseId
                                    && tl.TraineeId == traineeId
                                    && tl.IsActive);

        if (license == null)
            return ServiceResult.Failure("Invalid license.");

        // Re-check eligibility
        var (isEligible, reason) = await CheckEligibilityAsync(traineeId, license, model.ExamType, license.Trainee.TraineeNavigation.NationalId, culture);
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
            {
                var message = culture == "en"
                    ? "Exam slot not found."
                    : "لم يتم العثور على موعد الامتحان.";

                return ServiceResult.Failure(message);
            }

            if (exam.BookedSlots >= exam.TotalSlots)
            {
                var message = culture == "en"
                    ? "This exam slot is fully booked. Please choose another."
                    : "هذا الموعد ممتلئ بالكامل. الرجاء اختيار موعد آخر.";

                return ServiceResult.Failure(message);
            }

            // No duplicate booking
            bool duplicate = await _context.ExamAppointments
                .AnyAsync(ea => ea.TraineeId == traineeId
                             && ea.OfficialExamId == model.OfficialExamId
                             && ea.Status != "cancelled");

            if (duplicate)
            {
                var message = culture == "en"
                    ? "You have already booked this exam."
                    : "لقد قمت بحجز هذا الامتحان مسبقًا.";

                return ServiceResult.Failure(message);
            }

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
            {
                var message = culture == "en"
                    ? "You already have an active exam appointment."
                    : "لديك بالفعل موعد امتحان نشط.";

                return ServiceResult.Failure(message);
            }

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
        int traineeId, string culture)
    {
        var license = await _context.TraineeLicenses
            .FirstOrDefaultAsync(tl => tl.TraineeId == traineeId && tl.IsActive);

        if (license == null)
        {
            var message = culture == "en"
                ? "No active license found."
                : "لم يتم العثور على رخصة فعالة.";

            return ServiceResult<ExamAppointmentListViewModel>.Failure(message);
        }

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
                CenterName = culture == "ar" ? x.c.Name : x.c.DisplayNameEn,
                City = x.c.City.CityTranslations
                    .Where(ct => ct.CityId == x.c.CityId
                           && ct.LanguageCode == culture)
                    .Select(d => new
                    {
                        d.DisplayName,
                        d.CityId
                    })
                    .FirstOrDefault()
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
                CityId = a.City.CityId,
                CityName = a.City.DisplayName,
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
    public async Task<ServiceResult> CancelExamAppointmentAsync(int traineeId, int appointmentId, string culture)
    {
        var appointment = await _context.ExamAppointments
            .FirstOrDefaultAsync(ea => ea.ExamAppointmentId == appointmentId
                                    && ea.TraineeId == traineeId);

        if (appointment == null)
        {
            var message = culture == "en"
                ? "Appointment not found."
                : "لم يتم العثور على الموعد.";

            return ServiceResult.Failure(message);
        }

        if (appointment.Status != "scheduled")
        {
            var message = culture == "en"
                ? "Only scheduled appointments can be cancelled."
                : "يمكن إلغاء المواعيد المجدولة فقط.";

            return ServiceResult.Failure(message);
        }

        var exam = await _context.GovOfficialExams
            .FirstOrDefaultAsync(e => e.OfficialExamId == appointment.OfficialExamId);

        if (exam == null)
        {
            var message = culture == "en"
                ? "Exam not found."
                : "لم يتم العثور على الامتحان.";

            return ServiceResult.Failure(message);
        }

        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        if (exam.ExamDate <= today.AddDays(1))
        {
            var message = culture == "en"
                ? "Exam appointment cannot be cancelled within 24 hours."
                : "لا يمكن إلغاء موعد الامتحان خلال 24 ساعة.";

            return ServiceResult.Failure(message);
        }

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
        int traineeId, TraineeLicense license, string examType, string nationalId, string culture)
    {
        string T(string en, string ar) => culture == "en" ? en : ar;
        switch (examType)
        {
            case "theory":
            case "medical":
                {
                    // All theoretical modules completed
                    var theoreticalIds = await _context.LearningModules
                        .Where(m =>
                            m.Phase == "theoretical" &&
                            m.ProgressScope != null &&
                            m.LicenseTypes.Any(lt =>
                                lt.LicenseTypeId == license.LicenseTypeId))
                        .Select(m => m.ModuleId)
                        .ToListAsync();

                    var completedCount = await _context.TraineeModuleProgresses
                        .CountAsync(p => p.TraineeId == traineeId
                                      && theoreticalIds.Contains(p.ModuleId)
                                      && p.Status == "completed");

                    if (completedCount < theoreticalIds.Count)
                        return (false, T(
                            "You must complete all theoretical modules before booking this exam.",
                            "يجب إكمال جميع الوحدات النظرية قبل حجز هذا الامتحان."));

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
                            return (false, T(
                                "You must complete the mock exam before booking the theory/medical exam.",
                                "يجب إكمال الامتحان التجريبي قبل حجز الامتحان النظري أو الطبي."));
                    }

                    // exam must not be already passed
                    var passedExam = await _context.GovExamResults
                            .Where(e => e.OfficialExam.ExamType == examType
                                    && e.Result == "pass"
                                    && e.NationalId == nationalId
                                    && e.OfficialExam.LicenseTypeId == license.LicenseTypeId)
                            .AnyAsync();
                    if (passedExam)
                        return (false, T(
                            "You already passed this exam.",
                            "لقد اجتزت هذا الامتحان بالفعل."));

                    if (license.Stage != "theory_passed" && license.Stage != "medical_exam_pending" && examType == "medical")
                        return (false, T(
                            "You must pass the theory exam before booking the medical exam.",
                            "يجب اجتياز الامتحان النظري قبل حجز الامتحان الطبي."));

                    return (true, string.Empty);
                }

            case "practical":
                {
                    // Theory + medical must be passed
                    if (license.Stage is not (
                        "medical_passed" or "practical_prep" or "practical_test_pending"))
                        return (false, T(
                            "You must pass both the theory and medical exams before booking the practical exam.",
                            "يجب اجتياز الامتحانين النظري والطبي قبل حجز الامتحان العملي."));

                    return (true, string.Empty);
                }

            default:
                return (false, T(
                    "Unknown exam type.",
                    "نوع الامتحان غير معروف."));
        }
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
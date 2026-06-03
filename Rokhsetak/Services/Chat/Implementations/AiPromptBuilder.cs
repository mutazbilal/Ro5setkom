using Microsoft.AspNetCore.Mvc.RazorPages;
using System.ComponentModel;
using System.Text;

namespace Rokhsetak.Services.Chat.Implementations
{
    // ═══════════════════════════════════════════════════════════════════════
    //  CONTRACT
    // ═══════════════════════════════════════════════════════════════════════

    public interface IAiPromptBuilder
    {
        /// <summary>
        /// Builds a fully-assembled system prompt tailored to the
        /// authenticated user's role and current context.
        /// </summary>
        string Build(AiAssistantContext ctx);
    }

    // ═══════════════════════════════════════════════════════════════════════
    //  ROLE CONSTANTS
    // ═══════════════════════════════════════════════════════════════════════

    internal static class UserRole
    {
        public const string Trainee = "trainee";
        public const string Mentor = "mentor";
    }

    // ═══════════════════════════════════════════════════════════════════════
    //  IMPLEMENTATION
    // ═══════════════════════════════════════════════════════════════════════

    public class AiPromptBuilder : IAiPromptBuilder
    {
        // ── Shared platform identity ─────────────────────────────────────────
        private const string PlatformIdentity = """
            You are the **Rokhsetak Assistant** — the official AI helper embedded inside
            the Rokhsetak (رخصتك) platform, a Jordanian online driving-school system.

            ## Core rules (always apply)
            - Reply in the language preference of the user ONLY (Arabic or English).
            - Be concise and direct. Avoid filler phrases.
            - Never fabricate platform data — only reference what is provided in your context.
            - If you cannot answer a platform-specific question, say so clearly and
              suggest the user contact support.
            - Never write anything in markdown, for example ** for bold. use - for lists
            """;

        // ── Trainee role foundation ──────────────────────────────────────────
        //
        //  This prompt is used when ctx.User.Role == "trainee".
        //  Tone   : supportive driving coach
        //  Focus  : learning, progress, clear next steps
        //  Style  : simple, encouraging, structured explanations
        //
        private const string TraineeRoleFoundation = """
            ## Your role
            You are acting as a **supportive driving coach** for a trainee who is
            working toward their Jordanian driving license on the Rokhsetak platform.

            ### Responsibilities
            - Guide the trainee through every platform feature step by step.
            - Explain Jordanian driving theory and traffic rules clearly.
            - Help the trainee understand their current progress and what to do next.
            - Answer questions about license types, requirements, and the full
              licensing journey.
            - Give precise navigation instructions so the trainee can complete any
              action without confusion.

            ### Tone & style
            - Patient, encouraging, and positive — celebrate small wins.
            - Use simple language. Break complex topics into numbered steps.
            - Always end with a clear "next action" the trainee should take.

            ## Trainee portal — navigation knowledge
            Use the following to give exact navigation guidance:

            | Section        | Purpose & key actions |
            |----------------|-----------------------|
            | Dashboard      | Overview of overall progress and the single most important next step. |
            | Modules        | Theory lessons, quizzes, practical videos, and the mock exam. Trainees must complete all modules and pass all quizzes before they can book the theory exam. The mock exam must be *attempted* (pass not required) to unlock the theory exam booking. |
            | Find Mentor    | Browse and filter available mentors, book driving sessions, and open a chat with a mentor. |
            | My Bookings    | View upcoming and past driving sessions. |
            | Exams          | Three sequential exams: (1) **Theory exam** — requires all modules completed + all quizzes passed + mock exam attempted. (2) **Medical test** — requires theory exam passed. (3) **Practical test** — requires theory exam passed + medical test passed + user readiness confirmed. |
            | Profile        | Edit personal information and preferences. |
            | Chat           | Talk with the AI assistant or with a chosen mentor. |

            ### Milestone progression summary
            Theoretical prep → Mock exam attempted → Theory exam booked → Theory exam passed →
            Medical test → Practical prep → Practical exam booked → License complete.
            """;

        // ── Mentor role foundation ───────────────────────────────────────────
        //
        //  This prompt is used when ctx.User.Role == "mentor".
        //  Tone   : professional colleague / advisor
        //  Focus  : trainee management, scheduling, teaching effectiveness
        //  Style  : concise, technical, collaborative, insightful
        //
        private const string MentorRoleFoundation = """
            ## Your role
            You are acting as a **professional advisor and platform assistant** for an
            experienced driving instructor (mentor) using the Rokhsetak platform.

            ### Responsibilities
            - Help the mentor manage their schedule, availability, and appointments.
            - Provide insight into trainee progress and highlight areas needing attention.
            - Advise on effective teaching strategies for specific trainee weaknesses.
            - Answer questions about the platform's mentor-facing features precisely.
            - Support the mentor in communicating clearly with their trainees.

            ### Tone & style
            - Professional, collegial, and concise.
            - Treat the user as an experienced instructor — skip basic explanations.
            - Be analytical when discussing trainee progress; offer actionable suggestions.
            - Use structured lists or tables where they make information clearer.

            ## Mentor portal — navigation knowledge
            Use the following to give exact navigation guidance:

            | Section        | Purpose & key actions |
            |----------------|-----------------------|
            | Dashboard      | Daily schedule overview: upcoming sessions, pending booking requests, trainee alerts. |
            | Availability   | Manage weekly availability slots. Changes reflect immediately in trainee booking search. |
            | Appointments   | Accept, reschedule, or cancel incoming booking requests. View full appointment history. |
            | Trainees       | Browse assigned trainee list, view individual progress (modules, quizzes, exam status), identify trainees who are stalled or overdue. |
            | Chat           | Message individual trainees. The same AI assistant is available here; when replying to a trainee's chat the AI switches to trainee-facing context automatically. |

            ### Mentoring insight principles
            - A trainee stuck on a module for >7 days likely needs a theory refresher session.
            - Low mock-exam scores in specific rule categories map directly to practical weak spots.
            - Recommend booking practical sessions *after* the theory exam is passed to keep trainee motivation high.
            """;

        // ── Persona style modifiers (applied on top of the role foundation) ──
        private static readonly Dictionary<string, string> PersonaModifiers = new()
        {
            ["tutor"] = "Override style: extra patient and methodical. Explain concepts with relatable everyday examples. Occasionally ask a quick comprehension check.",
            ["examiner"] = "Override style: formal and precise. Present one exam-style question at a time. Wait for the user's answer before providing the correct answer and a full explanation.",
            ["coach"] = "Override style: energetic and motivational. Use short punchy sentences. Celebrate every piece of progress. Keep the energy high.",
            ["custom"] = "", // no modifier — fully controlled by caller
        };

        // ════════════════════════════════════════════════════════════════════
        //  PUBLIC BUILD METHOD
        // ════════════════════════════════════════════════════════════════════

        public string Build(AiAssistantContext ctx)
        {
            var sb = new StringBuilder();

            // 1. Shared platform identity
            sb.AppendLine(PlatformIdentity);

            // 2. Role-specific foundation  ← KEY branching point
            sb.AppendLine();
            sb.AppendLine(ResolveRoleFoundation(ctx.User.Role));

            // 3. Optional persona modifier (sits on top of the role foundation)
            AppendPersonaModifier(sb, ctx.PersonaKey);

            // 4. Current-user section
            AppendUserSection(sb, ctx.User);

            // 5. License section (trainee-relevant, but harmless to include for mentors too)
            if (ctx.License is not null)
                AppendLicenseSection(sb, ctx.License);

            // 6. Learning-progress section
            if (ctx.Learning is not null)
                AppendLearningSection(sb, ctx.Learning);

            // 7. Driving-lessons / bookings section
            if (ctx.Bookings is not null)
                AppendBookingsSection(sb, ctx.Bookings);

            // 8. Current-page / available-actions section
            if (ctx.Page is not null)
                AppendPageSection(sb, ctx.Page);

            return sb.ToString().Trim();
        }

        // ════════════════════════════════════════════════════════════════════
        //  PRIVATE — ROLE RESOLUTION
        // ════════════════════════════════════════════════════════════════════

        /// <summary>
        /// Returns the role-specific foundation block.
        /// Unknown roles fall back to the trainee prompt (safe default).
        /// </summary>
        private static string ResolveRoleFoundation(string role) => role switch
        {
            UserRole.Mentor => MentorRoleFoundation,
            UserRole.Trainee => TraineeRoleFoundation,
            _ => TraineeRoleFoundation,  // safe fallback
        };

        // ════════════════════════════════════════════════════════════════════
        //  PRIVATE — SECTION BUILDERS
        // ════════════════════════════════════════════════════════════════════

        private static void AppendPersonaModifier(StringBuilder sb, string personaKey)
        {
            if (!PersonaModifiers.TryGetValue(personaKey, out var modifier)
                || string.IsNullOrWhiteSpace(modifier))
                return;

            sb.AppendLine();
            sb.AppendLine("## Style override");
            sb.AppendLine(modifier);
        }

        private static void AppendUserSection(StringBuilder sb, UserAiContext user)
        {
            sb.AppendLine();
            sb.AppendLine("## Authenticated user");
            sb.AppendLine($"- Name: {user.Name}");
            sb.AppendLine($"- Role: {user.Role}");
            sb.AppendLine($"- Language preference: {user.Language}");
        }

        private static void AppendLicenseSection(StringBuilder sb, LicenseAiContext license)
        {
            sb.AppendLine();
            sb.AppendLine("## License");
            sb.AppendLine($"- Type: {license.LicenseTypeName}");
            sb.AppendLine($"- Current stage: {FormatStage(license.Stage)}");
        }

        private static void AppendLearningSection(StringBuilder sb, LearningAiContext l)
        {
            sb.AppendLine();
            sb.AppendLine("## Learning progress");
            sb.AppendLine($"- Overall completion: {l.OverallProgressPct}%");
            sb.AppendLine($"- Next milestone: {l.NextMilestone}");
            sb.AppendLine($"- Mock exam available: {l.IsMockExamAvailable}");
            sb.AppendLine($"- Theory exam bookable: {l.IsTheoryExamBookable}");
            sb.AppendLine($"- Completed modules: {l.CompletedModules.Count}");

            if (l.IncompleteModules.Count > 0)
            {
                sb.AppendLine("- Modules still to complete:");
                foreach (var module in l.IncompleteModules)
                {
                    var lockLabel = module.IsLocked ? " *(locked)*" : string.Empty;
                    sb.AppendLine($"  • [{module.Phase}] {module.Title}{lockLabel}");
                }
            }
        }

        private static void AppendBookingsSection(StringBuilder sb, BookingAiContext bookings)
        {
            sb.AppendLine();
            sb.AppendLine("## Driving lessons");
            sb.AppendLine($"- Completed sessions: {bookings.CompletedSessionCount}");

            if (bookings.UpcomingBookings.Count > 0)
            {
                sb.AppendLine("- Upcoming bookings:");
                foreach (var booking in bookings.UpcomingBookings)
                    sb.AppendLine($"  • {booking.Date:dd MMM} at {booking.StartTime:HH:mm} — {booking.SessionType} with {booking.InstructorName}");
            }
            else
            {
                sb.AppendLine("- No upcoming bookings.");
            }
        }

        private static void AppendPageSection(StringBuilder sb, PageAiContext page)
        {
            sb.AppendLine();
            sb.AppendLine("## User's current page");
            sb.AppendLine($"- Page: {page.PageKey}");

            if (page.AvailableActions.Count > 0)
            {
                sb.AppendLine("- Available actions on this page:");
                foreach (var action in page.AvailableActions)
                    sb.AppendLine($"  • {action}");
            }
        }

        // ════════════════════════════════════════════════════════════════════
        //  PRIVATE — HELPERS
        // ════════════════════════════════════════════════════════════════════

        private static string FormatStage(string stage) => stage switch
        {
            "theoretical_prep" => "Completing theoretical modules",
            "mock_exam_completed" => "Mock exam passed — ready to book theory exam",
            "theory_exam_passed" => "Theory exam passed — starting practical phase",
            "practical_prep" => "Completing practical modules",
            "practical_exam_booked" => "Practical exam booked",
            "completed" => "License journey complete",
            _ => stage,
        };
    }
}
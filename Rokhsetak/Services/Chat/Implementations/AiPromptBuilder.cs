using System.Text;

namespace Rokhsetak.Services.Chat.Implementations
{
    public interface IAiPromptBuilder
    {
        string Build(AiAssistantContext ctx);
    }

    public class AiPromptBuilder : IAiPromptBuilder
    {
        // ── Platform foundation — always present ─────────────────────────────
        private const string Foundation = """
        You are the Rokhsetak Assistant — the official AI helper for the Rokhsetak
        platform, a Jordanian online driving-school system.

        Your responsibilities:
        - Guide users through all platform features (dashboard, modules, bookings, exams)
        - Teach Jordanian driving theory and traffic rules
        - Help users understand their progress and what to do next
        - Answer questions about license types, requirements, and the licensing process
        - Assist with navigation: tell users exactly where to go to complete an action

        Rules:
        - Always reply in the same language the user writes in (Arabic or English)
        - Be concise and direct; avoid filler phrases
        - Never make up platform data — only reference what is in your context
        - If you don't know a platform-specific answer, say so and suggest contacting support
        """;

        // ── Persona modifiers — applied on top of foundation ─────────────────
        private static readonly Dictionary<string, string> PersonaModifiers = new()
        {
            ["tutor"] = "Tone: patient and encouraging. Explain concepts with simple examples. Check understanding.",
            ["examiner"] = "Tone: precise and formal. Ask one exam-style question at a time. Wait for answer, then correct it and explain.",
            ["coach"] = "Tone: casual and motivational. Celebrate progress. Keep energy high. Use short sentences.",
            ["custom"] = "",
        };

        public string Build(AiAssistantContext ctx)
        {
            var sb = new StringBuilder();
            sb.AppendLine(Foundation);

            // Persona modifier
            if (PersonaModifiers.TryGetValue(ctx.PersonaKey, out var modifier)
                && !string.IsNullOrEmpty(modifier))
            {
                sb.AppendLine();
                sb.AppendLine("## Your style");
                sb.AppendLine(modifier);
            }

            // User section
            sb.AppendLine();
            sb.AppendLine("## Current user");
            sb.AppendLine($"- Name: {ctx.User.Name}");
            sb.AppendLine($"- Language preference: {ctx.User.Language}");

            // License section
            if (ctx.License is not null)
            {
                sb.AppendLine();
                sb.AppendLine("## License");
                sb.AppendLine($"- Type: {ctx.License.LicenseTypeName}");
                sb.AppendLine($"- Current stage: {FormatStage(ctx.License.Stage)}");
            }

            // Learning section
            if (ctx.Learning is not null)
            {
                var l = ctx.Learning;
                sb.AppendLine();
                sb.AppendLine("## Learning progress");
                sb.AppendLine($"- Overall: {l.OverallProgressPct}% complete");
                sb.AppendLine($"- Next milestone: {l.NextMilestone}");
                sb.AppendLine($"- Mock exam available: {l.IsMockExamAvailable}");
                sb.AppendLine($"- Theory exam bookable: {l.IsTheoryExamBookable}");

                if (l.IncompleteModules.Count > 0)
                {
                    sb.AppendLine($"- Next modules to complete:");
                    foreach (var m in l.IncompleteModules)
                        sb.AppendLine($"  • [{m.Phase}] {m.Title}{(m.IsLocked ? " (locked)" : "")}");
                }

                sb.AppendLine($"- Completed modules: {l.CompletedModules.Count}");
            }

            // Booking section
            if (ctx.Bookings is not null)
            {
                sb.AppendLine();
                sb.AppendLine("## Driving lessons");
                sb.AppendLine($"- Completed sessions: {ctx.Bookings.CompletedSessionCount}");
                if (ctx.Bookings.UpcomingBookings.Count > 0)
                {
                    sb.AppendLine("- Upcoming bookings:");
                    foreach (var b in ctx.Bookings.UpcomingBookings)
                        sb.AppendLine($"  • {b.Date:dd MMM} at {b.StartTime:HH:mm} — {b.SessionType} with {b.InstructorName}");
                }
                else
                {
                    sb.AppendLine("- No upcoming bookings.");
                }
            }

            // Page context section
            if (ctx.Page is not null)
            {
                sb.AppendLine();
                sb.AppendLine("## User's current page");
                sb.AppendLine($"- Page: {ctx.Page.PageKey}");
                if (ctx.Page.AvailableActions.Count > 0)
                {
                    sb.AppendLine("- Available actions on this page:");
                    foreach (var a in ctx.Page.AvailableActions)
                        sb.AppendLine($"  • {a}");
                }
            }

            return sb.ToString().Trim();
        }

        private static string FormatStage(string stage) => stage switch
        {
            "theoretical_prep" => "Completing theoretical modules",
            "mock_exam_completed" => "Mock exam passed — ready to book theory exam",
            "theory_exam_passed" => "Theory exam passed — starting practical phase",
            "practical_prep" => "Completing practical modules",
            "practical_exam_booked" => "Practical exam booked",
            "completed" => "License journey complete",
            _ => stage
        };
    }
}

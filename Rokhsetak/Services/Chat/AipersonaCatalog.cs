namespace Rokhsetak.Services.Chat;

/// <summary>Built-in AI personalities. Edit/extend freely — keys are stored per session.</summary>
public static class AiPersonaCatalog
{
    private const string Guard =
        "You are the Rokhsetak assistant, helping users of a Jordanian online driving-school platform. " +
        "Stay focused on driving theory, Jordanian traffic rules, lessons, exams, and using the platform. " +
        "Reply in the same language the user writes in (Arabic or English). Be clear and concise.";

    public static readonly IReadOnlyList<ChatCreateOption> Options = new[]
    {
        new ChatCreateOption("tutor",    "Patient Tutor",   "Explains rules clearly and encouragingly."),
        new ChatCreateOption("examiner", "Strict Examiner", "Quizzes you exam-style and flags mistakes."),
        new ChatCreateOption("coach",    "Friendly Coach",  "Casual, motivational, keeps you going."),
        new ChatCreateOption("custom",   "Custom",          "Write your own personality."),
    };

    public static string Resolve(string? key) => key switch
    {
        "examiner" => Guard + " Act as a strict driving examiner: ask one mock-exam question at a time, wait for the answer, then correct it precisely and explain why.",
        "coach" => Guard + " Act as a warm, motivational coach: casual tone, lots of encouragement, celebrate progress.",
        "custom" => Guard,
        _ => Guard + " Act as a patient tutor: explain concepts simply, use everyday examples, and check the learner's understanding.",
    };

    public static string Wrap(string? customPrompt) =>
        string.IsNullOrWhiteSpace(customPrompt) ? Resolve("tutor") : Guard + " " + customPrompt.Trim();
}
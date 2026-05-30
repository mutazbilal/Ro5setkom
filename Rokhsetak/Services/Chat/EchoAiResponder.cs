namespace Rokhsetak.Services.Chat;

/// <summary>TEMPORARY stub. Echoes a canned reply so the AI tab is fully wired end-to-end.</summary>
public sealed class EchoAiResponder : IAiResponder
{
    public Task<string> GenerateReplyAsync(IReadOnlyList<ChatTurn> history, CancellationToken ct = default)
    {
        var last = history.LastOrDefault(t => t.Role == "user").Content ?? "";
        var reply = string.IsNullOrWhiteSpace(last)
            ? "Hi! I'm the Rokhsetak assistant. Ask me anything about lessons, exams, or modules."
            : $"(AI preview) You said: \"{last}\". The full assistant is coming soon — I'll be able to help with bookings, theory, and exam prep.";
        return Task.FromResult(reply);
    }
}
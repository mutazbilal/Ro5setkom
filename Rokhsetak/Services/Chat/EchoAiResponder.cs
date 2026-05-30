namespace Rokhsetak.Services.Chat;

/// <summary>TEMPORARY stub. Echoes a canned reply so the AI tab is fully wired end-to-end.</summary>
public sealed class EchoAiResponder : IAiResponder
{
    public Task<string> GenerateReplyAsync(string systemPrompt, IReadOnlyList<ChatTurn> history, CancellationToken ct = default)
    {
        var last = history.LastOrDefault(t => t.Role == "user").Content ?? "";
        return Task.FromResult($"(echo) {last}");
    }
}
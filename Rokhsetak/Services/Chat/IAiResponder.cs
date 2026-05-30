namespace Rokhsetak.Services.Chat;

public readonly record struct ChatTurn(string Role, string Content);

/// <summary>
/// The single integration point for the future AI model. Replace EchoAiResponder
/// with a real implementation (OpenAI/Azure/etc.) — no other code needs to change.
/// </summary>
public interface IAiResponder
{
    Task<string> GenerateReplyAsync(string systemPrompt, IReadOnlyList<ChatTurn> history, CancellationToken ct = default);

}
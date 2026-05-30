using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Options;

namespace Rokhsetak.Services.Chat.Implementations;

public sealed class DeepSeekOptions
{
    public string ApiKey { get; set; } = "";
    public string BaseUrl { get; set; } = "https://api.deepseek.com";
    public string Model { get; set; } = "deepseek-chat";
    public double Temperature { get; set; } = 0.7;
}

/// <summary>Calls DeepSeek's OpenAI-compatible /chat/completions endpoint.</summary>
public sealed class DeepSeekAiResponder : IAiResponder
{
    private readonly HttpClient _http;
    private readonly DeepSeekOptions _opts;
    private readonly ILogger<DeepSeekAiResponder> _logger;

    public DeepSeekAiResponder(HttpClient http, IOptions<DeepSeekOptions> opts, ILogger<DeepSeekAiResponder> logger)
    {
        _http = http;
        _opts = opts.Value;
        _logger = logger;
    }

    public async Task<string> GenerateReplyAsync(string systemPrompt, IReadOnlyList<ChatTurn> history, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(_opts.ApiKey))
            return "⚠️ The AI assistant isn't configured yet (missing API key).";

        var messages = new List<object> { new { role = "system", content = systemPrompt } };
        foreach (var t in history)
            messages.Add(new { role = t.Role == "assistant" ? "assistant" : "user", content = t.Content });

        var payload = new { model = _opts.Model, messages, stream = false, temperature = _opts.Temperature };

        using var req = new HttpRequestMessage(HttpMethod.Post, $"{_opts.BaseUrl.TrimEnd('/')}/chat/completions");
        req.Headers.Authorization = new AuthenticationHeaderValue("Bearer", _opts.ApiKey);
        req.Content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

        try
        {
            using var resp = await _http.SendAsync(req, ct);
            var body = await resp.Content.ReadAsStringAsync(ct);

            if (!resp.IsSuccessStatusCode)
            {
                _logger.LogWarning("DeepSeek error {Status}: {Body}", (int)resp.StatusCode, body);
                return "Sorry — I couldn't reach the AI service just now. Please try again.";
            }

            using var doc = JsonDocument.Parse(body);
            var content = doc.RootElement.GetProperty("choices")[0]
                .GetProperty("message").GetProperty("content").GetString();

            return string.IsNullOrWhiteSpace(content) ? "I didn't get a response. Please try again." : content!.Trim();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "DeepSeek request failed");
            return "Sorry — something went wrong contacting the AI service.";
        }
    }
}
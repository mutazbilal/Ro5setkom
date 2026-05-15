using System.Text.RegularExpressions;

namespace RokhsetakIntegrationTests.Infrastructure;

internal static class AntiforgeryTokenExtractor
{
    private static readonly Regex TokenRegex = new(
        @"name=""__RequestVerificationToken""[^>]*value=""(?<v>[^""]+)""",
        RegexOptions.Compiled | RegexOptions.IgnoreCase);

    public static string Extract(string html)
    {
        var match = TokenRegex.Match(html);
        if (!match.Success)
            throw new InvalidOperationException(
                "Antiforgery token not found in response body.");
        return match.Groups["v"].Value;
    }
}
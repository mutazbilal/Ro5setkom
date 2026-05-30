namespace Rokhsetak.Services.Chat.Implementations.Providers
{
    // PageContextProvider.cs — pure in-memory, no DB needed
    public class PageContextProvider : IPageContextProvider
    {
        private static readonly Dictionary<string, (string Label, string[] Actions)> _pages = new()
        {
            ["dashboard"] = ("Trainee dashboard", ["View learning modules", "Check progress", "Book a lesson", "Take mock exam"]),
            ["modules"] = ("Learning modules page", ["Start a module", "Resume a module", "Take module quiz"]),
            ["bookings"] = ("Bookings page", ["Book a driving lesson", "View upcoming lessons", "Cancel a booking"]),
            ["quiz"] = ("Quiz / exam page", ["Answer a question", "Review results", "Retake quiz"]),
            ["progress"] = ("Progress page", ["View completed modules", "Check exam readiness"]),
            ["theory-exam"] = ("Theory exam booking", ["Book theory exam", "Check exam requirements"]),
        };

        public PageAiContext? Get(string? pageKey)
        {
            if (pageKey is null || !_pages.TryGetValue(pageKey, out var page))
                return null;
            return new PageAiContext(page.Label, page.Actions);
        }
    }
}

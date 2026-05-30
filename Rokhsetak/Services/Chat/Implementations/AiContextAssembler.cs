namespace Rokhsetak.Services.Chat.Implementations
{
    public interface IAiContextAssembler
    {
        Task<AiAssistantContext> AssembleAsync(
            int userId, string personaKey, string? pageKey, CancellationToken ct = default);
    }

    public class AiContextAssembler : IAiContextAssembler
    {
        private readonly IUserContextProvider _user;
        private readonly ILicenseContextProvider _license;
        private readonly ILearningContextProvider _learning;
        private readonly IBookingContextProvider _bookings;
        private readonly IPageContextProvider _page;

        public AiContextAssembler(
            IUserContextProvider user,
            ILicenseContextProvider license,
            ILearningContextProvider learning,
            IBookingContextProvider bookings,
            IPageContextProvider page)
        {
            _user = user; _license = license; _learning = learning;
            _bookings = bookings; _page = page;
        }

        // AiContextAssembler.cs

        public async Task<AiAssistantContext> AssembleAsync(
            int userId, string personaKey, string? pageKey, CancellationToken ct = default)
        {
            var userCtx = await _user.GetAsync(userId, ct);
            var culture = userCtx?.Language ?? "en";

            // Sequential — all providers share the same scoped DbContext instance
            var licCtx = await _license.GetAsync(userId, ct);
            var learnCtx = await _learning.GetAsync(userId, culture, ct);
            var bookCtx = await _bookings.GetAsync(userId, ct);

            return new AiAssistantContext(
                User: userCtx ?? new UserAiContext("Trainee", "trainee", culture, DateOnly.FromDateTime(DateTime.UtcNow)),
                License: licCtx,
                Learning: learnCtx,
                Bookings: bookCtx,
                Page: _page.Get(pageKey),
                PersonaKey: personaKey
            );
        }
    }

    // Small helper to avoid nesting Task.WhenAll manually
    file static class TaskExtensions
    {
        public static async Task<(T1, T2, T3)> WhenAll<T1, T2, T3>(
            this (Task<T1> t1, Task<T2> t2, Task<T3> t3) tasks)
        {
            await Task.WhenAll(tasks.t1, tasks.t2, tasks.t3);
            return (tasks.t1.Result, tasks.t2.Result, tasks.t3.Result);
        }
    }
}

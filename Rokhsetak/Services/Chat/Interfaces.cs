namespace Rokhsetak.Services.Chat
{
    // Interfaces
    public interface IUserContextProvider
    {
        Task<UserAiContext?> GetAsync(int userId, CancellationToken ct = default);
    }

    public interface ILicenseContextProvider
    {
        Task<LicenseAiContext?> GetAsync(int userId, CancellationToken ct = default);
    }

    public interface ILearningContextProvider
    {
        Task<LearningAiContext?> GetAsync(int userId, string culture, CancellationToken ct = default);
    }

    public interface IBookingContextProvider
    {
        Task<BookingAiContext?> GetAsync(int userId, CancellationToken ct = default);
    }

    public interface IPageContextProvider
    {
        PageAiContext? Get(string? pageKey);
    }
}

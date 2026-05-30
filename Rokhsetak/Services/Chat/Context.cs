// Rokhsetak.Services.Chat.Context

public record UserAiContext(
    string Name,
    string Role,           // "trainee" | "mentor" | "admin"
    string Language,       // "ar" | "en"
    DateOnly RegisteredAt
);

public record LicenseAiContext(
    string LicenseTypeName,
    string Stage,          // e.g. "theoretical_prep", "mock_exam_completed"
    int TraineeLicenseId,
    bool IsActive
);

public record LearningAiContext(
    int OverallProgressPct,
    string NextMilestone,
    bool IsMockExamAvailable,
    bool IsMockExamCompleted,
    bool IsTheoryExamBookable,
    IReadOnlyList<ModuleSummary> IncompleteModules,   // max 5, to stay token-efficient
    IReadOnlyList<ModuleSummary> CompletedModules     // count only — no titles needed
);

public record ModuleSummary(string Title, string Phase, bool IsLocked);

public record BookingAiContext(
    IReadOnlyList<UpcomingBooking> UpcomingBookings,
    int CompletedSessionCount
);

public record UpcomingBooking(
    DateOnly Date,
    TimeOnly StartTime,
    string SessionType,    // e.g. "practical"
    string InstructorName
);

public record PageAiContext(
    string PageKey,        // e.g. "dashboard", "modules", "bookings", "quiz"
    IReadOnlyList<string> AvailableActions  // e.g. ["Book a lesson", "Take mock exam"]
);

// The assembled bag passed to the prompt builder
public record AiAssistantContext(
    UserAiContext User,
    LicenseAiContext? License,
    LearningAiContext? Learning,
    BookingAiContext? Bookings,
    PageAiContext? Page,
    string PersonaKey
);
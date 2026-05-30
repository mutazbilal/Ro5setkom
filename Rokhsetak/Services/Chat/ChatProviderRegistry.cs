namespace Rokhsetak.Services.Chat;

public sealed class ChatProviderRegistry : IChatProviderRegistry
{
    private readonly Dictionary<string, IChatProvider> _byKey;
    public IReadOnlyList<ChatProviderDescriptor> Descriptors { get; }

    public ChatProviderRegistry(IEnumerable<IChatProvider> providers)
    {
        var ordered = providers.OrderBy(p => p.SortOrder).ToList();
        _byKey = ordered.ToDictionary(p => p.Key, StringComparer.OrdinalIgnoreCase);
        Descriptors = ordered.Select(p => new ChatProviderDescriptor
        {
            Key = p.Key,
            Label = p.DisplayName,
            Icon = p.Icon,
            SortOrder = p.SortOrder,
            SupportsThreadList = p.SupportsThreadList,
            SupportsUnread = p.SupportsUnread,
            SupportsThreadCreation = p is IThreadConfigurableProvider
        }).ToList();
    }

    public IChatProvider Resolve(string key) => _byKey[key];

    public bool TryResolve(string? key, out IChatProvider provider)
        => _byKey.TryGetValue(key ?? string.Empty, out provider!);
}
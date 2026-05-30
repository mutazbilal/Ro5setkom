namespace Rokhsetak.Services.Chat;

public interface IChatProviderRegistry
{
    IReadOnlyList<ChatProviderDescriptor> Descriptors { get; }
    IChatProvider Resolve(string key);
    bool TryResolve(string? key, out IChatProvider provider);
}
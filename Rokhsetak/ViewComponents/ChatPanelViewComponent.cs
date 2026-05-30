using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Services.Chat;
using Rokhsetak.Utils;

namespace Rokhsetak.ViewComponents;

public class ChatPanelViewComponent : ViewComponent
{
    private readonly IChatProviderRegistry _registry;
    public ChatPanelViewComponent(IChatProviderRegistry registry) => _registry = registry;

    public async Task<IViewComponentResult> InvokeAsync()
    {
        if (User.Identity?.IsAuthenticated != true) return Content(string.Empty);
        if (!(User.IsInRole("trainee") || User.IsInRole("mentor"))) return Content(string.Empty);

        int uid = UserClaimsPrincipal.GetUserId() ?? 0;

        int unread = 0;
        foreach (var d in _registry.Descriptors.Where(d => d.SupportsUnread))
            unread += await _registry.Resolve(d.Key).GetUnreadCountAsync(uid);

        return View(new ChatPanelViewModel
        {
            Providers = _registry.Descriptors,
            InitialUnread = unread,
            CurrentUserId = uid
        });
    }
}
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Services.Chat;
using Rokhsetak.Utils;

namespace Rokhsetak.Controllers;

[Authorize]
public class ChatController : Controller
{
    private readonly IChatProviderRegistry _registry;
    public ChatController(IChatProviderRegistry registry) => _registry = registry;

    private int Uid => User.GetUserId() ?? 0;

    // GET /Chat/UnreadCount
    [HttpGet]
    public async Task<IActionResult> UnreadCount()
    {
        int total = 0;
        foreach (var d in _registry.Descriptors.Where(d => d.SupportsUnread))
            total += await _registry.Resolve(d.Key).GetUnreadCountAsync(Uid);
        return Json(new { count = total });
    }

    // GET /Chat/Threads?provider=human
    [HttpGet]
    public async Task<IActionResult> Threads(string provider)
    {
        if (!_registry.TryResolve(provider, out var p)) return NotFound();
        var threads = await p.GetThreadsAsync(Uid);
        ViewData["Provider"] = p.Key;
        return PartialView("_ChatThreadList", threads);
    }

    // GET /Chat/Open?provider=human&id=5   (id<=0 ⇒ provider's default thread, e.g. AI session)
    [HttpGet]
    public async Task<IActionResult> Open(string provider, int id)
    {
        if (!_registry.TryResolve(provider, out var p)) return NotFound();
        var detail = await p.GetThreadAsync(Uid, id);
        if (detail is null) return NotFound();
        return PartialView("_ChatThread", detail);
    }

    // GET /Chat/Poll?provider=human&threadId=5&lastId=99
    [HttpGet]
    public async Task<IActionResult> Poll(string provider, int threadId, int lastId)
    {
        if (!_registry.TryResolve(provider, out var p)) return NotFound();
        var latest = await p.GetLatestMessageIdAsync(Uid, threadId);
        if (latest is null) return Json(new { hasNew = false, latestId = lastId });
        return Json(new { hasNew = latest.Value > lastId, latestId = latest.Value });
    }

    // POST /Chat/Send
    [HttpPost]
    [ValidateAntiForgeryToken]
    [RequestSizeLimit(11 * 1024 * 1024)]
    public async Task<IActionResult> Send(string provider, int threadId, string? text, IFormFile? file)
    {
        if (!_registry.TryResolve(provider, out var p)) return NotFound();
        var res = await p.SendAsync(Uid, threadId, text, file);
        if (!res.Succeeded) return BadRequest(new { error = res.Error });
        var detail = await p.GetThreadAsync(Uid, res.ThreadId);
        return PartialView("_ChatThread", detail);
    }
}
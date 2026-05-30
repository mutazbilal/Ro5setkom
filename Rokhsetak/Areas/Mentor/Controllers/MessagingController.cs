using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;

namespace Rokhsetak.Areas.Mentor.Controllers;

[Area("Mentor")]
[Authorize(Roles = "mentor")]
public class MessagingController : Controller
{
    private readonly IConversationService _conversations;

    public MessagingController(IConversationService conversations)
    {
        _conversations = conversations;
    }

    // GET /Mentor/Messaging
    // Renders the full chat shell with the conversation list.
    public async Task<IActionResult> Index()
    {
        var mentorId = User.GetUserId().Value;
        var result   = await _conversations.GetMentorConversationsAsync(mentorId);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index", "Dashboard");
        }

        return View(result.Data);
    }

    // GET /Mentor/Messaging/Open/{id}
    // Opens a specific conversation (renders full-page or partial for AJAX).
    public async Task<IActionResult> Open(int id)
    {
        var mentorId = User.GetUserId().Value;
        var result   = await _conversations.GetMentorConversationAsync(id, mentorId);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index");
        }

        // If it's an AJAX/fetch request, return the partial only
        if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            return PartialView("_ConversationThread", result.Data);

        // Full page: pass both list and detail to the view
        var listResult = await _conversations.GetMentorConversationsAsync(mentorId);
        ViewBag.Detail = result.Data;
        return View("Index", listResult.Data);
    }

    // POST /Mentor/Messaging/Send
    [HttpPost]
    [ValidateAntiForgeryToken]
    [RequestSizeLimit(11 * 1024 * 1024)]  // 11 MB ceiling (service enforces 10 MB)
    public async Task<IActionResult> Send(int conversationId, string? text, IFormFile? file)
    {
        var mentorId = User.GetUserId().Value;
        var result   = await _conversations.SendMessageAsMentorAsync(conversationId, mentorId, text, file);

        if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
        {
            if (!result.Succeeded)
                return BadRequest(new { error = result.Error });

            // Return the refreshed thread partial
            var detail = await _conversations.GetMentorConversationAsync(conversationId, mentorId);
            return PartialView("_ConversationThread", detail.Data);
        }

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Message sent." : result.Error;

        return RedirectToAction("Open", new { id = conversationId });
    }
    [HttpGet]
    public async Task<IActionResult> Poll(int conversationId, int lastId)
    {
        var mentorId = User.GetUserId().Value;
        var latestId = await _conversations.GetLatestMessageIdAsync(conversationId, mentorId);

        if (latestId is null)
            return Forbid();

        // Only tell client to refresh if something new arrived
        return Json(new { hasNew = latestId.Value > lastId, latestId = latestId.Value });
    }
}

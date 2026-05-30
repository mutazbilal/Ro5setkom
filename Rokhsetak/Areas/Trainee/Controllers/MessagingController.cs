using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Rokhsetak.Services.Interfaces;
using Rokhsetak.Utils;

namespace Rokhsetak.Areas.Trainee.Controllers;

[Area("Trainee")]
[Authorize(Roles = "trainee")]
public class MessagingController : Controller
{
    private readonly IConversationService _conversations;

    public MessagingController(IConversationService conversations)
    {
        _conversations = conversations;
    }

    // GET /Trainee/Messaging
    public async Task<IActionResult> Index()
    {
        var traineeId = User.GetUserId().Value;
        var result    = await _conversations.GetTraineeConversationsAsync(traineeId);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index", "Dashboard");
        }

        return View(result.Data);
    }

    // GET /Trainee/Messaging/Open/{id}
    public async Task<IActionResult> Open(int id)
    {
        var traineeId = User.GetUserId().Value;
        var result    = await _conversations.GetTraineeConversationAsync(id, traineeId);

        if (!result.Succeeded)
        {
            TempData["Error"] = result.Error;
            return RedirectToAction("Index");
        }

        if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            return PartialView("_ConversationThread", result.Data);

        var listResult = await _conversations.GetTraineeConversationsAsync(traineeId);
        ViewBag.Detail = result.Data;
        return View("Index", listResult.Data);
    }

    // POST /Trainee/Messaging/Send
    [HttpPost]
    [ValidateAntiForgeryToken]
    [RequestSizeLimit(11 * 1024 * 1024)]
    public async Task<IActionResult> Send(int conversationId, string? text, IFormFile? file)
    {
        var traineeId = User.GetUserId().Value;
        var result    = await _conversations.SendMessageAsTraineeAsync(conversationId, traineeId, text, file);

        if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
        {
            if (!result.Succeeded)
                return BadRequest(new { error = result.Error });

            var detail = await _conversations.GetTraineeConversationAsync(conversationId, traineeId);
            return PartialView("_ConversationThread", detail.Data);
        }

        TempData[result.Succeeded ? "Success" : "Error"] =
            result.Succeeded ? "Message sent." : result.Error;

        return RedirectToAction("Open", new { id = conversationId });
    }

    [HttpGet]
    public async Task<IActionResult> Poll(int conversationId, int lastId)
    {
        var traineeId = User.GetUserId().Value;
        var latestId = await _conversations.GetLatestMessageIdAsync(conversationId, traineeId);

        if (latestId is null)
            return Forbid();

        return Json(new { hasNew = latestId.Value > lastId, latestId = latestId.Value });
    }
}

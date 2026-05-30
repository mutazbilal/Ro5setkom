using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Azure.Storage.Sas;
using Rokhsetak.Services.Common;
using Rokhsetak.Services.Interfaces;
using System.ComponentModel;
using Rokhsetak.ViewModels.Messaging;

namespace Rokhsetak.Services.Implementations
{
    public class BlobService : IBlobService
    {
        private static readonly HashSet<string> _allowedChatExtensions =
        new(StringComparer.OrdinalIgnoreCase) { ".pdf", ".png", ".jpg", ".jpeg", ".webp" };

            private static readonly HashSet<string> _allowedChatContentTypes =
                new(StringComparer.OrdinalIgnoreCase)
                {
            "application/pdf",
            "image/png",
            "image/jpeg",
            "image/webp"
                };

        private const long ChatMaxBytes = 10 * 1024 * 1024; // 10 MB
        private readonly BlobServiceClient _client;

        private readonly Dictionary<string, string> _imageMap = new()
    {
        { "eye_examination", "eye-examination.jpg" },
        { "computer-based-theoratical-exam", "computer-based-theoratical-exam.jpg" },
        { "white-and-yellow-road-line-applications", "white-and-yellow-raod-line-applications.jpg" },
        { "solid-center-line", "solid-center-line.jpg" },
        { "stop-line-vs-yield-line", "stop-line-vs-yield-line.jpg" },
        { "zebra-crossing", "zebra-crossing.jpg" },
        { "bicycle-lane", "bicycle-lane.jpg" },
        { "lane-arrows", "lane-arrows.jpg" },
        { "steep-downhill-warning", "steep-downhill-warning.jpg" },
        { "men-working-sign", "men-working-sign.jpg" },
        { "stop-sign", "stop-sign.jpg" },
        { "priority-for-incoming", "priority-for-incoming.jpg" },
        { "priority-over-incoming", "priority-over-incoming.jpg" },
        { "driving-lesson", "driving-lesson.jpg" },
        { "solid-yellow-line", "solid-yellow-line.jpg" },
        { "inverted-triangle", "inverted-triangle.jpg" },
        { "red-up-black-down", "red-up-black-down.jpg" },
        { "yellow-diamond", "yellow-diamond.jpg" },
        { "blue-square", "blue-square.jpg" }
    };

        public BlobService(IConfiguration config)
        {
            var connectionString = config["AzureBlob:ConnectionString"];
            _client = new BlobServiceClient(connectionString);
        }

        // 🔥 reusable container getter
        private BlobContainerClient GetContainer(string containerName)
        {
            return _client.GetBlobContainerClient(containerName);
        }

        // 🔥 main helper you use in your app
        public string GetImageSasUrl(string imageKey, string containerName = "modules")
        {
            if (!_imageMap.TryGetValue(imageKey, out var fileName))
                return "";

            var container = GetContainer(containerName);

            var blobClient = container.GetBlobClient(fileName);

            var sasUri = blobClient.GenerateSasUri(
                BlobSasPermissions.Read,
                DateTimeOffset.UtcNow.AddHours(1)
            );

            return sasUri.ToString();
        }
        public async Task<ServiceResult<string>> UploadAsync(
            string containerName,
            string fileName,
            Stream content,
            string contentType)
        {
            var container = _client.GetBlobContainerClient(containerName);
            await container.CreateIfNotExistsAsync();

            var blob = container.GetBlobClient(fileName);

            var options = new BlobUploadOptions
            {
                HttpHeaders = new BlobHttpHeaders
                {
                    ContentType = contentType
                }
            };

            await blob.UploadAsync(content, options);

            return ServiceResult<string>.Success(blob.Uri.ToString());
        }
        public async Task<ServiceResult<Stream>> DownloadAsync(
            string containerName,
            string fileName)
        {
            try
            {
                var container = _client.GetBlobContainerClient(containerName);

                var blob = container.GetBlobClient(fileName);

                if (!await blob.ExistsAsync())
                {
                    return ServiceResult<Stream>.Failure("File not found.");
                }

                var response = await blob.DownloadStreamingAsync();

                var memoryStream = new MemoryStream();

                await response.Value.Content.CopyToAsync(memoryStream);

                memoryStream.Position = 0;

                return ServiceResult<Stream>.Success(memoryStream);
            }
            catch (Exception ex)
            {
                return ServiceResult<Stream>.Failure(ex.Message);
            }
        }
        public async Task<ServiceResult<ChatUploadResult>> UploadChatAttachmentAsync(IFormFile file)
        {
            // ── Validate ──────────────────────────────────────────────────────────────
            if (file is null || file.Length == 0)
                return ServiceResult<ChatUploadResult>.Failure("No file provided.");

            if (file.Length > ChatMaxBytes)
                return ServiceResult<ChatUploadResult>.Failure("File exceeds the 10 MB limit.");

            var ext = Path.GetExtension(file.FileName);
            if (!_allowedChatExtensions.Contains(ext))
                return ServiceResult<ChatUploadResult>.Failure(
                    "Unsupported file type. Allowed: PDF, PNG, JPG, JPEG, WEBP.");

            if (!_allowedChatContentTypes.Contains(file.ContentType))
                return ServiceResult<ChatUploadResult>.Failure(
                    "Unsupported content type.");

            // ── Upload ────────────────────────────────────────────────────────────────
            // Unique blob name prevents collisions and path traversal
            var blobName = $"{Guid.NewGuid():N}{ext.ToLowerInvariant()}";

            await using var stream = file.OpenReadStream();
            var result = await UploadAsync("chat-attachments", blobName, stream, file.ContentType);

            if (!result.Succeeded)
                return ServiceResult<ChatUploadResult>.Failure(result.Error!);

            return ServiceResult<ChatUploadResult>.Success(
                new ChatUploadResult(
                    Url: result.Data!,
                    OriginalFileName: Path.GetFileName(file.FileName),
                    Extension: ext.TrimStart('.').ToLowerInvariant()
                ));
        }

    }

}
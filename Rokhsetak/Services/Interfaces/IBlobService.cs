using Rokhsetak.Services.Common;

namespace Rokhsetak.Services.Interfaces
{
    public interface IBlobService
    {
        string GetImageSasUrl(string imageKey, string containerName = "modules");
        Task<ServiceResult<string>> UploadAsync(
            string containerName,
            string fileName,
            Stream content,
            string contentType);
        Task<ServiceResult<Stream>> DownloadAsync(
            string containerName,
            string fileName);

    }
}

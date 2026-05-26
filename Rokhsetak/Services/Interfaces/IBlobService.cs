namespace Rokhsetak.Services.Interfaces
{
    public interface IBlobService
    {
        public string GetSasUrl(string blobName);
    }
}

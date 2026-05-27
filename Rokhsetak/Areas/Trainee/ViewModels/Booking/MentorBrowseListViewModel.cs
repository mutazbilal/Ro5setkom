using Rokhsetak.ViewModels.Registration;
namespace Rokhsetak.Areas.Trainee.ViewModels.Booking;

public class MentorBrowseListViewModel
{
    public List<MentorBrowseCardViewModel> Mentors { get; set; } = new();
    public MentorBrowseFilterViewModel Filter { get; set; } = new();
    public int? ActiveMentorId { get; set; }
    public List<CityOption?> Cities { get; set; } = new();
}

public class MentorBrowseCardViewModel
{
    public int MentorId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string CityName { get; set; } = string.Empty;
    public int? CityId { get; set; }
    public string LicenseType { get; set; } = string.Empty;
    public decimal PricePerSession { get; set; }
    public double AverageRating { get; set; }
    public int TotalRatings { get; set; }
    public double CompletionRate { get; set; }   // % trainees who completed license
}

public class MentorBrowseFilterViewModel
{
    public int? CityId { get; set; }
    public decimal? MinPrice { get; set; }
    public decimal? MaxPrice { get; set; }
    public double? MinRating { get; set; }
}
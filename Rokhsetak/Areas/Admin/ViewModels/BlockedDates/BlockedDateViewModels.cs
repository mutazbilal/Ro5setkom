using System.ComponentModel.DataAnnotations;

namespace Rokhsetak.Areas.Admin.ViewModels.BlockedDates;

public class BlockedDateItem
{
    public int BlockedDateId { get; set; }
    public DateOnly Date { get; set; }
    public string? Reason { get; set; }
    public DateTime? CreatedAt { get; set; }
    public string CreatedByName { get; set; } = string.Empty;
}

public class BlockedDateListViewModel
{
    public List<BlockedDateItem> Items { get; set; } = new();
    public CreateBlockedDateViewModel NewBlockedDate { get; set; } = new();
}

public class CreateBlockedDateViewModel
{
    [Required]
    [Display(Name = "Date")]
    [DataType(DataType.Date)]
    public DateOnly Date { get; set; } = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(1));

    [MaxLength(255)]
    [Display(Name = "Reason (optional)")]
    public string? Reason { get; set; }
}

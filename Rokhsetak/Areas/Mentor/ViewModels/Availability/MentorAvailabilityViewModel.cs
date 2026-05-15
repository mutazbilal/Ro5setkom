namespace Rokhsetak.Areas.Mentor.ViewModels.Availability
{
    public class MentorAvailabilityViewModel
    {
        public int Id { get; set; }
        public string DayOfWeek { get; set; }

        public TimeOnly StartTime { get; set; }
        public TimeOnly EndTime { get; set; }

        public bool IsActive { get; set; }
    }
}

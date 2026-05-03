namespace ro5setkom.Services.Implementations
{
    using Microsoft.EntityFrameworkCore;
    using ro5setkom.Models;
    using ro5setkom.Services.Common;
    using ro5setkom.Services.Interfaces;
    using ro5setkom.ViewModels.Mentor;

    public class MentorService : IMentorService
    {
        private readonly Ro5setkomDbContext _context;

        public MentorService(Ro5setkomDbContext context)
        {
            _context = context;
        }

        // ----------------------------
        // ADD SLOT
        // ----------------------------
        public async Task<ServiceResult> AddSlotAsync(int mentorId, MentorAvailabilityViewModel model)
        {
            var mentor = await _context.Mentors
                .Include(m => m.MentorAvailabilities)
                .FirstOrDefaultAsync(m => m.MentorId == mentorId);

            if (mentor == null)
                return ServiceResult.Failure("Mentor not found.");

            // overlap check (STRICT RULE)
            var hasOverlap = await _context.MentorAvailabilities
                .AnyAsync(a =>
                    a.MentorId == mentorId &&
                    a.DayOfWeek == model.DayOfWeek.ToString() &&
                    a.IsActive == true &&
                    (model.StartTime < a.EndTime && model.EndTime > a.StartTime)
                );

            if (hasOverlap)
                return ServiceResult.Failure("Time slot overlaps with an existing slot.");

            var slot = new MentorAvailability
            {
                MentorId = mentorId,
                DayOfWeek = model.DayOfWeek.ToString(),
                StartTime = model.StartTime,
                EndTime = model.EndTime,
                IsActive = true
            };

            _context.MentorAvailabilities.Add(slot);
            await _context.SaveChangesAsync();

            return ServiceResult.Success();
        }

        // ----------------------------
        // EDIT SLOT
        // ----------------------------
        public async Task<ServiceResult> EditSlotAsync(int mentorId, int slotId, MentorAvailabilityViewModel model)
        {
            var slot = await _context.MentorAvailabilities
                .FirstOrDefaultAsync(s => s.AvailabilityId == slotId);

            if (slot == null)
                return ServiceResult.Failure("Slot not found.");

            // 🔐 Ownership check
            if (slot.MentorId != mentorId)
                return ServiceResult.Failure("Unauthorized.");

            // 🔁 Overlap check (excluding current slot)
            var hasOverlap = await _context.MentorAvailabilities
                .AnyAsync(a =>
                    a.MentorId == mentorId &&
                    a.AvailabilityId != slotId &&
                    a.DayOfWeek == model.DayOfWeek.ToString() &&
                    a.IsActive == true &&
                    (model.StartTime < a.EndTime && model.EndTime > a.StartTime)
                );

            if (hasOverlap)
                return ServiceResult.Failure("Slot overlaps with existing slot.");

            slot.DayOfWeek = model.DayOfWeek.ToString();
            slot.StartTime = model.StartTime;
            slot.EndTime = model.EndTime;

            await _context.SaveChangesAsync();
            return ServiceResult.Success();
        }

        // ----------------------------
        // DEACTIVATE SLOT
        // ----------------------------
        public async Task<ServiceResult> DeactivateSlotAsync(int mentorId, int slotId)
        {
            var slot = await _context.MentorAvailabilities
                .FirstOrDefaultAsync(s => s.AvailabilityId == slotId);

            if (slot == null)
                return ServiceResult.Failure("Slot not found.");

            // 🔐 Ownership check
            if (slot.MentorId != mentorId)
                return ServiceResult.Failure("Unauthorized.");

            slot.IsActive = false;

            await _context.SaveChangesAsync();
            return ServiceResult.Success();
        }

        public async Task<List<MentorAvailabilityViewModel>> GetSlotsAsync(int mentorId)
        {
            return await _context.MentorAvailabilities
                .Where(a => a.MentorId == mentorId)
                .OrderBy(a => a.DayOfWeek)
                .ThenBy(a => a.StartTime)
                .Select(a => new MentorAvailabilityViewModel
                {
                    Id = a.AvailabilityId,
                    DayOfWeek = a.DayOfWeek,
                    StartTime = a.StartTime,
                    EndTime = a.EndTime,
                    IsActive = a.IsActive == true
                })
                .ToListAsync();
        }
    }
}

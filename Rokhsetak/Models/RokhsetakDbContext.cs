using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace Rokhsetak.Models;

public partial class RokhsetakDbContext : DbContext
{
    public RokhsetakDbContext()
    {
    }

    public RokhsetakDbContext(DbContextOptions<RokhsetakDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Admin> Admins { get; set; }

    public virtual DbSet<AichatMessage> AichatMessages { get; set; }

    public virtual DbSet<AichatSession> AichatSessions { get; set; }

    public virtual DbSet<AuditLog> AuditLogs { get; set; }

    public virtual DbSet<BlockedDate> BlockedDates { get; set; }

    public virtual DbSet<Booking> Bookings { get; set; }

    public virtual DbSet<City> Cities { get; set; }

    public virtual DbSet<CityTranslation> CityTranslations { get; set; }

    public virtual DbSet<CompletionCertificate> CompletionCertificates { get; set; }

    public virtual DbSet<Conversation> Conversations { get; set; }

    public virtual DbSet<ConversationAttachment> ConversationAttachments { get; set; }

    public virtual DbSet<ExamAppointment> ExamAppointments { get; set; }

    public virtual DbSet<GovCitizen> GovCitizens { get; set; }

    public virtual DbSet<GovExamCenter> GovExamCenters { get; set; }

    public virtual DbSet<GovExamResult> GovExamResults { get; set; }

    public virtual DbSet<GovLicenseRecord> GovLicenseRecords { get; set; }

    public virtual DbSet<GovOfficialExam> GovOfficialExams { get; set; }

    public virtual DbSet<LearningModule> LearningModules { get; set; }

    public virtual DbSet<LicenseType> LicenseTypes { get; set; }

    public virtual DbSet<Mentor> Mentors { get; set; }

    public virtual DbSet<MentorApplication> MentorApplications { get; set; }

    public virtual DbSet<MentorAvailability> MentorAvailabilities { get; set; }

    public virtual DbSet<Message> Messages { get; set; }

    public virtual DbSet<ModuleContent> ModuleContents { get; set; }

    public virtual DbSet<ModuleContentTranslation> ModuleContentTranslations { get; set; }

    public virtual DbSet<ModuleRecommendation> ModuleRecommendations { get; set; }

    public virtual DbSet<ModuleTranslation> ModuleTranslations { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<NotificationPreference> NotificationPreferences { get; set; }

    public virtual DbSet<OptionTranslation> OptionTranslations { get; set; }

    public virtual DbSet<Province> Provinces { get; set; }

    public virtual DbSet<ProvinceTranslation> ProvinceTranslations { get; set; }

    public virtual DbSet<QuestionOption> QuestionOptions { get; set; }

    public virtual DbSet<QuestionTranslation> QuestionTranslations { get; set; }

    public virtual DbSet<Quiz> Quizzes { get; set; }

    public virtual DbSet<QuizAttempt> QuizAttempts { get; set; }

    public virtual DbSet<QuizQuestion> QuizQuestions { get; set; }

    public virtual DbSet<QuizTranslation> QuizTranslations { get; set; }

    public virtual DbSet<Rating> Ratings { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<SecurityPasswordResetToken> SecurityPasswordResetTokens { get; set; }

    public virtual DbSet<SessionFeedback> SessionFeedbacks { get; set; }

    public virtual DbSet<Trainee> Trainees { get; set; }

    public virtual DbSet<TraineeLicense> TraineeLicenses { get; set; }

    public virtual DbSet<TraineeModuleProgress> TraineeModuleProgresses { get; set; }

    public virtual DbSet<TrainingCenter> TrainingCenters { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserConsent> UserConsents { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {   if (!optionsBuilder.IsConfigured)
        {
            optionsBuilder.UseSqlServer("Server=tcp:rokhsetak.database.windows.net,1433;Initial Catalog=RokhsetakDB;Persist Security Info=False;User ID=CloudSAd6acbb36;Password=8GUaFmwkn9U4KmS;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;");
        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Admin>(entity =>
        {
            entity.HasKey(e => e.AdminId).HasName("PK__Admins__43AA414140C6D86A");

            entity.ToTable("Admins", "Roles");

            entity.HasIndex(e => e.BadgeNumber, "UQ__Admins__3E4D103E5176E216").IsUnique();

            entity.Property(e => e.AdminId)
                .ValueGeneratedNever()
                .HasColumnName("admin_id");
            entity.Property(e => e.BadgeNumber)
                .HasMaxLength(100)
                .HasColumnName("badge_number");
            entity.Property(e => e.Department)
                .HasMaxLength(255)
                .HasColumnName("department");

            entity.HasOne(d => d.AdminNavigation).WithOne(p => p.Admin)
                .HasForeignKey<Admin>(d => d.AdminId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Admins__admin_id__41BA5749");
        });

        modelBuilder.Entity<AichatMessage>(entity =>
        {
            entity.HasKey(e => e.MessageId).HasName("PK__AIChatMe__0BBF6EE687F06104");

            entity.ToTable("AIChatMessages", "AI");

            entity.Property(e => e.MessageId).HasColumnName("message_id");
            entity.Property(e => e.Content).HasColumnName("content");
            entity.Property(e => e.Role)
                .HasMaxLength(10)
                .HasColumnName("role");
            entity.Property(e => e.SentAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("sent_at");
            entity.Property(e => e.SessionId).HasColumnName("session_id");

            entity.HasOne(d => d.Session).WithMany(p => p.AichatMessages)
                .HasForeignKey(d => d.SessionId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__AIChatMes__sessi__66B6D1CE");
        });

        modelBuilder.Entity<AichatSession>(entity =>
        {
            entity.HasKey(e => e.SessionId).HasName("PK__AIChatSe__69B13FDCE93C6578");

            entity.ToTable("AIChatSessions", "AI");

            entity.Property(e => e.SessionId).HasColumnName("session_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.EndedAt).HasColumnName("ended_at");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.AichatSessions)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__AIChatSes__user___61F21CB1");
        });

        modelBuilder.Entity<AuditLog>(entity =>
        {
            entity.HasKey(e => e.LogId).HasName("PK__AuditLog__9E2397E06DD85D99");

            entity.ToTable("AuditLogs", "Security");

            entity.Property(e => e.LogId).HasColumnName("log_id");
            entity.Property(e => e.Action)
                .HasMaxLength(255)
                .HasColumnName("action");
            entity.Property(e => e.PerformedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("performed_at");
            entity.Property(e => e.RecordId)
                .HasMaxLength(50)
                .HasColumnName("record_id");
            entity.Property(e => e.TableName)
                .HasMaxLength(100)
                .HasColumnName("table_name");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.AuditLogs)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__AuditLogs__user___7E8E5B5F");
        });

        modelBuilder.Entity<BlockedDate>(entity =>
        {
            entity.HasKey(e => e.BlockedDateId).HasName("PK__BlockedD__9F5620D7C2FEB9FE");

            entity.ToTable("BlockedDates", "Scheduling");

            entity.HasIndex(e => e.BlockedDate1, "UQ__BlockedD__D739C54FF21C4384").IsUnique();

            entity.Property(e => e.BlockedDateId).HasColumnName("blocked_date_id");
            entity.Property(e => e.BlockedBy).HasColumnName("blocked_by");
            entity.Property(e => e.BlockedDate1).HasColumnName("blocked_date");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.Reason)
                .HasMaxLength(255)
                .HasColumnName("reason");

            entity.HasOne(d => d.BlockedByNavigation).WithMany(p => p.BlockedDates)
                .HasForeignKey(d => d.BlockedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__BlockedDa__block__5E5695F7");
        });

        modelBuilder.Entity<Booking>(entity =>
        {
            entity.HasKey(e => e.BookingId).HasName("PK__Bookings__5DE3A5B13C1972F4");

            entity.ToTable("Bookings", "Scheduling");

            entity.HasIndex(e => e.MentorId, "idx_bookings_mentor_id");

            entity.HasIndex(e => e.TraineeId, "idx_bookings_trainee_id");

            entity.Property(e => e.BookingId).HasColumnName("booking_id");
            entity.Property(e => e.BookingDate).HasColumnName("booking_date");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.EndTime).HasColumnName("end_time");
            entity.Property(e => e.LicenseTypeId).HasColumnName("license_type_id");
            entity.Property(e => e.MentorId).HasColumnName("mentor_id");
            entity.Property(e => e.SessionType)
                .HasMaxLength(20)
                .HasColumnName("session_type");
            entity.Property(e => e.StartTime).HasColumnName("start_time");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("pending")
                .HasColumnName("status");
            entity.Property(e => e.TraineeId).HasColumnName("trainee_id");
            entity.Property(e => e.TraineeLicenseId).HasColumnName("trainee_license_id");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.LicenseType).WithMany(p => p.Bookings)
                .HasForeignKey(d => d.LicenseTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Bookings__licens__68D4246A");

            entity.HasOne(d => d.Mentor).WithMany(p => p.Bookings)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Bookings__mentor__67E00031");

            entity.HasOne(d => d.Trainee).WithMany(p => p.Bookings)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Bookings__traine__66EBDBF8");

            entity.HasOne(d => d.TraineeLicense).WithMany(p => p.Bookings)
                .HasForeignKey(d => d.TraineeLicenseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Bookings__traine__69C848A3");
        });

        modelBuilder.Entity<City>(entity =>
        {
            entity.HasKey(e => e.CityId).HasName("PK__Cities__031491A85334F04A");

            entity.ToTable("Cities", "Lookup");

            entity.HasIndex(e => new { e.ProvinceId, e.CityKey }, "UQ__Cities__684B304DBEEA97E3").IsUnique();

            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.CityKey)
                .HasMaxLength(100)
                .HasColumnName("city_key");
            entity.Property(e => e.ProvinceId).HasColumnName("province_id");

            entity.HasOne(d => d.Province).WithMany(p => p.Cities)
                .HasForeignKey(d => d.ProvinceId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Cities__province__7A33BA96");
        });

        modelBuilder.Entity<CityTranslation>(entity =>
        {
            entity.HasKey(e => e.CityTranslationId).HasName("PK__CityTran__ABADED1E936EE375");

            entity.ToTable("CityTranslations", "Lookup");

            entity.HasIndex(e => new { e.CityId, e.LanguageCode }, "UQ__CityTran__B979AB5465AAF677").IsUnique();

            entity.Property(e => e.CityTranslationId).HasColumnName("city_translation_id");
            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.DisplayName)
                .HasMaxLength(100)
                .HasColumnName("display_name");
            entity.Property(e => e.LanguageCode)
                .HasMaxLength(5)
                .HasColumnName("language_code");

            entity.HasOne(d => d.City).WithMany(p => p.CityTranslations)
                .HasForeignKey(d => d.CityId)
                .HasConstraintName("FK__CityTrans__city___7E044B7A");
        });

        modelBuilder.Entity<CompletionCertificate>(entity =>
        {
            entity.HasKey(e => e.CertificateId).HasName("PK__Completi__E2256D3137EF7489");

            entity.ToTable("CompletionCertificates", "Learning");

            entity.HasIndex(e => e.TraineeLicenseId, "UQ__Completi__5F546699C8C18B0B").IsUnique();

            entity.Property(e => e.CertificateId).HasColumnName("certificate_id");
            entity.Property(e => e.CertificatePath)
                .HasMaxLength(500)
                .HasColumnName("certificate_path");
            entity.Property(e => e.IssuedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("issued_at");
            entity.Property(e => e.MentorId).HasColumnName("mentor_id");
            entity.Property(e => e.TraineeId).HasColumnName("trainee_id");
            entity.Property(e => e.TraineeLicenseId).HasColumnName("trainee_license_id");

            entity.HasOne(d => d.Mentor).WithMany(p => p.CompletionCertificates)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Completio__mento__25DD32AA");

            entity.HasOne(d => d.Trainee).WithMany(p => p.CompletionCertificates)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Completio__train__24E90E71");

            entity.HasOne(d => d.TraineeLicense).WithOne(p => p.CompletionCertificate)
                .HasForeignKey<CompletionCertificate>(d => d.TraineeLicenseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Completio__train__26D156E3");
        });

        modelBuilder.Entity<Conversation>(entity =>
        {
            entity.HasKey(e => e.ConversationId).HasName("PK__Conversa__311E7E9AEB6A8DE5");

            entity.ToTable("Conversations", "Messaging");

            entity.HasIndex(e => e.BookingId, "UQ__Conversa__5DE3A5B0AA54893C").IsUnique();

            entity.Property(e => e.ConversationId).HasColumnName("conversation_id");
            entity.Property(e => e.BookingId).HasColumnName("booking_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.MentorId).HasColumnName("mentor_id");
            entity.Property(e => e.TraineeId).HasColumnName("trainee_id");

            entity.HasOne(d => d.Booking).WithOne(p => p.Conversation)
                .HasForeignKey<Conversation>(d => d.BookingId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Conversat__booki__52AFD921");

            entity.HasOne(d => d.Mentor).WithMany(p => p.Conversations)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Conversat__mento__51BBB4E8");

            entity.HasOne(d => d.Trainee).WithMany(p => p.Conversations)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Conversat__train__50C790AF");
        });

        modelBuilder.Entity<ConversationAttachment>(entity =>
        {
            entity.HasKey(e => e.AttachmentId).HasName("PK__Conversa__B74DF4E22C3F7CDE");

            entity.ToTable("ConversationAttachments", "Messaging");

            entity.Property(e => e.AttachmentId).HasColumnName("attachment_id");
            entity.Property(e => e.ConversationId).HasColumnName("conversation_id");
            entity.Property(e => e.FileName)
                .HasMaxLength(255)
                .HasColumnName("file_name");
            entity.Property(e => e.FilePath)
                .HasMaxLength(500)
                .HasColumnName("file_path");
            entity.Property(e => e.FileType)
                .HasMaxLength(10)
                .HasColumnName("file_type");
            entity.Property(e => e.MessageId).HasColumnName("message_id");
            entity.Property(e => e.UploadedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("uploaded_at");
            entity.Property(e => e.UploadedBy).HasColumnName("uploaded_by");

            entity.HasOne(d => d.Conversation).WithMany(p => p.ConversationAttachments)
                .HasForeignKey(d => d.ConversationId)
                .HasConstraintName("FK__Conversat__conve__5D2D6794");

            entity.HasOne(d => d.UploadedByNavigation).WithMany(p => p.ConversationAttachments)
                .HasForeignKey(d => d.UploadedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Conversat__uploa__5E218BCD");
        });

        modelBuilder.Entity<ExamAppointment>(entity =>
        {
            entity.HasKey(e => e.ExamAppointmentId).HasName("PK__ExamAppo__3AFEDC74C828D8D4");

            entity.ToTable("ExamAppointments", "Scheduling");

            entity.HasIndex(e => new { e.TraineeId, e.OfficialExamId }, "UQ__ExamAppo__5D00D9F07404EA16").IsUnique();

            entity.HasIndex(e => e.TraineeLicenseId, "UQ__ExamAppo__5F5466990B2FF573").IsUnique();

            entity.HasIndex(e => e.TraineeId, "idx_examappointments_trainee_id");

            entity.Property(e => e.ExamAppointmentId).HasColumnName("exam_appointment_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.OfficialExamId).HasColumnName("official_exam_id");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("scheduled")
                .HasColumnName("status");
            entity.Property(e => e.TraineeId).HasColumnName("trainee_id");
            entity.Property(e => e.TraineeLicenseId).HasColumnName("trainee_license_id");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.OfficialExam).WithMany(p => p.ExamAppointments)
                .HasForeignKey(d => d.OfficialExamId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ExamAppoi__offic__7351B2DD");

            entity.HasOne(d => d.Trainee).WithMany(p => p.ExamAppointments)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ExamAppoi__train__725D8EA4");

            entity.HasOne(d => d.TraineeLicense).WithOne(p => p.ExamAppointment)
                .HasForeignKey<ExamAppointment>(d => d.TraineeLicenseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ExamAppoi__train__7445D716");
        });

        modelBuilder.Entity<GovCitizen>(entity =>
        {
            entity.HasKey(e => e.NationalId).HasName("PK__GovCitiz__9560E95CD2DD5E38");

            entity.ToTable("GovCitizens", "Gov");

            entity.Property(e => e.NationalId)
                .HasMaxLength(10)
                .HasColumnName("national_id");
            entity.Property(e => e.AddressLine1)
                .HasMaxLength(255)
                .HasColumnName("address_line1");
            entity.Property(e => e.AddressLine2)
                .HasMaxLength(255)
                .HasColumnName("address_line2");
            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.DateOfBirth).HasColumnName("date_of_birth");
            entity.Property(e => e.FirstName)
                .HasMaxLength(100)
                .HasColumnName("first_name");
            entity.Property(e => e.Gender)
                .HasMaxLength(10)
                .HasColumnName("gender");
            entity.Property(e => e.IsEligible)
                .HasDefaultValue(true)
                .HasColumnName("is_eligible");
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .HasColumnName("last_name");
            entity.Property(e => e.PostalCode)
                .HasMaxLength(20)
                .HasColumnName("postal_code");
            entity.Property(e => e.ProvinceId).HasColumnName("province_id");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.City).WithMany(p => p.GovCitizens)
                .HasForeignKey(d => d.CityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovCitize__city___05A56D42");

            entity.HasOne(d => d.Province).WithMany(p => p.GovCitizens)
                .HasForeignKey(d => d.ProvinceId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovCitize__provi__04B14909");
        });

        modelBuilder.Entity<GovExamCenter>(entity =>
        {
            entity.HasKey(e => e.CenterId).HasName("PK__GovExamC__290A28875E30A286");

            entity.ToTable("GovExamCenters", "Gov");

            entity.Property(e => e.CenterId).HasColumnName("center_id");
            entity.Property(e => e.AddressLine1)
                .HasMaxLength(255)
                .HasColumnName("address_line1");
            entity.Property(e => e.AddressLine2)
                .HasMaxLength(255)
                .HasColumnName("address_line2");
            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.Name)
                .HasMaxLength(255)
                .HasColumnName("name");
            entity.Property(e => e.PhoneNumber)
                .HasMaxLength(20)
                .HasColumnName("phone_number");
            entity.Property(e => e.PostalCode)
                .HasMaxLength(20)
                .HasColumnName("postal_code");
            entity.Property(e => e.ProvinceId).HasColumnName("province_id");

            entity.HasOne(d => d.City).WithMany(p => p.GovExamCenters)
                .HasForeignKey(d => d.CityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovExamCe__city___0A6A225F");

            entity.HasOne(d => d.Province).WithMany(p => p.GovExamCenters)
                .HasForeignKey(d => d.ProvinceId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovExamCe__provi__0975FE26");
        });

        modelBuilder.Entity<GovExamResult>(entity =>
        {
            entity.HasKey(e => e.ResultId).HasName("PK__GovExamR__AFB3C31626BD790E");

            entity.ToTable("GovExamResults", "Gov");

            entity.HasIndex(e => new { e.OfficialExamId, e.NationalId }, "UQ__GovExamR__72767A07A95C55EA").IsUnique();

            entity.Property(e => e.ResultId).HasColumnName("result_id");
            entity.Property(e => e.NationalId)
                .HasMaxLength(10)
                .HasColumnName("national_id");
            entity.Property(e => e.Notes)
                .HasMaxLength(500)
                .HasColumnName("notes");
            entity.Property(e => e.OfficialExamId).HasColumnName("official_exam_id");
            entity.Property(e => e.RecordedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("recorded_at");
            entity.Property(e => e.RecordedBy).HasColumnName("recorded_by");
            entity.Property(e => e.Result)
                .HasMaxLength(10)
                .HasColumnName("result");
            entity.Property(e => e.Score).HasColumnName("score");

            entity.HasOne(d => d.National).WithMany(p => p.GovExamResults)
                .HasForeignKey(d => d.NationalId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovExamRe__natio__2059637E");

            entity.HasOne(d => d.OfficialExam).WithMany(p => p.GovExamResults)
                .HasForeignKey(d => d.OfficialExamId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovExamRe__offic__1F653F45");

            entity.HasOne(d => d.RecordedByNavigation).WithMany(p => p.GovExamResults)
                .HasForeignKey(d => d.RecordedBy)
                .HasConstraintName("FK_GovExamResults_Admins");
        });

        modelBuilder.Entity<GovLicenseRecord>(entity =>
        {
            entity.HasKey(e => e.RecordId).HasName("PK__GovLicen__BFCFB4DD48A1F3B3");

            entity.ToTable("GovLicenseRecords", "Gov");

            entity.Property(e => e.RecordId).HasColumnName("record_id");
            entity.Property(e => e.ExpiryDate).HasColumnName("expiry_date");
            entity.Property(e => e.IssuedDate).HasColumnName("issued_date");
            entity.Property(e => e.LicenseTypeId).HasColumnName("license_type_id");
            entity.Property(e => e.NationalId)
                .HasMaxLength(10)
                .HasColumnName("national_id");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasColumnName("status");

            entity.HasOne(d => d.LicenseType).WithMany(p => p.GovLicenseRecords)
                .HasForeignKey(d => d.LicenseTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovLicens__licen__0F2ED77C");

            entity.HasOne(d => d.National).WithMany(p => p.GovLicenseRecords)
                .HasForeignKey(d => d.NationalId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovLicens__natio__0E3AB343");
        });

        modelBuilder.Entity<GovOfficialExam>(entity =>
        {
            entity.HasKey(e => e.OfficialExamId).HasName("PK__GovOffic__AB2074938F0D93B3");

            entity.ToTable("GovOfficialExams", "Gov");

            entity.Property(e => e.OfficialExamId).HasColumnName("official_exam_id");
            entity.Property(e => e.BookedSlots).HasColumnName("booked_slots");
            entity.Property(e => e.CenterId).HasColumnName("center_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.CreatedBy).HasColumnName("created_by");
            entity.Property(e => e.ExamDate).HasColumnName("exam_date");
            entity.Property(e => e.ExamTime).HasColumnName("exam_time");
            entity.Property(e => e.ExamType)
                .HasMaxLength(20)
                .HasColumnName("exam_type");
            entity.Property(e => e.LicenseTypeId).HasColumnName("license_type_id");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("scheduled")
                .HasColumnName("status");
            entity.Property(e => e.TotalSlots)
                .HasDefaultValue(1)
                .HasColumnName("total_slots");

            entity.HasOne(d => d.Center).WithMany(p => p.GovOfficialExams)
                .HasForeignKey(d => d.CenterId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovOffici__cente__18B841B6");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.GovOfficialExams)
                .HasForeignKey(d => d.CreatedBy)
                .HasConstraintName("FK_GovOfficialExams_Admins");

            entity.HasOne(d => d.LicenseType).WithMany(p => p.GovOfficialExams)
                .HasForeignKey(d => d.LicenseTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovOffici__licen__19AC65EF");
        });

        modelBuilder.Entity<LearningModule>(entity =>
        {
            entity.HasKey(e => e.ModuleId).HasName("PK__Learning__1A2D06539BB65CA8");

            entity.ToTable("LearningModules", "Learning");

            entity.HasIndex(e => new { e.LicenseTypeId, e.OrderIndex, e.Phase }, "UQ__Learning__2F46B0C2963C84EC").IsUnique();

            entity.Property(e => e.ModuleId).HasColumnName("module_id");
            entity.Property(e => e.LicenseTypeId).HasColumnName("license_type_id");
            entity.Property(e => e.OrderIndex).HasColumnName("order_index");
            entity.Property(e => e.Phase)
                .HasMaxLength(20)
                .HasColumnName("phase");
            entity.Property(e => e.PrerequisiteModuleId).HasColumnName("prerequisite_module_id");

            entity.HasOne(d => d.LicenseType).WithMany(p => p.LearningModules)
                .HasForeignKey(d => d.LicenseTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LearningM__licen__790A8C33");

            entity.HasOne(d => d.PrerequisiteModule).WithMany(p => p.InversePrerequisiteModule)
                .HasForeignKey(d => d.PrerequisiteModuleId)
                .HasConstraintName("FK__LearningM__prere__79FEB06C");
        });

        modelBuilder.Entity<LicenseType>(entity =>
        {
            entity.HasKey(e => e.LicenseTypeId).HasName("PK__LicenseT__8130CC247DEFA7FE");

            entity.ToTable("LicenseTypes", "Lookup");

            entity.HasIndex(e => e.LicenseName, "UQ__LicenseT__E40D75A84F775B3D").IsUnique();

            entity.Property(e => e.LicenseTypeId).HasColumnName("license_type_id");
            entity.Property(e => e.DescriptionAr)
                .HasMaxLength(255)
                .HasColumnName("description_ar");
            entity.Property(e => e.DescriptionEn)
                .HasMaxLength(255)
                .HasColumnName("description_en");
            entity.Property(e => e.DisplayNameAr)
                .HasMaxLength(100)
                .HasColumnName("display_name_ar");
            entity.Property(e => e.DisplayNameEn)
                .HasMaxLength(100)
                .HasColumnName("display_name_en");
            entity.Property(e => e.LicenseName)
                .HasMaxLength(50)
                .HasColumnName("license_name");
        });

        modelBuilder.Entity<Mentor>(entity =>
        {
            entity.HasKey(e => e.MentorId).HasName("PK__Mentors__E5D27EF3BC96EBA6");

            entity.ToTable("Mentors", "Roles");

            entity.Property(e => e.MentorId)
                .ValueGeneratedNever()
                .HasColumnName("mentor_id");
            entity.Property(e => e.ApplicationId).HasColumnName("application_id");
            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.LicenseTypeId).HasColumnName("license_type_id");
            entity.Property(e => e.PricePerSession)
                .HasColumnType("decimal(10, 2)")
                .HasColumnName("price_per_session");
            entity.Property(e => e.TrainingCenterId).HasColumnName("training_center_id");
            entity.Property(e => e.VehicleType)
                .HasMaxLength(100)
                .HasColumnName("vehicle_type");

            entity.HasOne(d => d.Application).WithMany(p => p.Mentors)
                .HasForeignKey(d => d.ApplicationId)
                .HasConstraintName("FK_Mentors_MentorApplications");

            entity.HasOne(d => d.City).WithMany(p => p.Mentors)
                .HasForeignKey(d => d.CityId)
                .HasConstraintName("FK__Mentors__city_id__4C37E5BC");

            entity.HasOne(d => d.LicenseType).WithMany(p => p.Mentors)
                .HasForeignKey(d => d.LicenseTypeId)
                .HasConstraintName("FK__Mentors__license__4B43C183");

            entity.HasOne(d => d.MentorNavigation).WithOne(p => p.Mentor)
                .HasForeignKey<Mentor>(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Mentors__mentor___4A4F9D4A");

            entity.HasOne(d => d.TrainingCenter).WithMany(p => p.Mentors)
                .HasForeignKey(d => d.TrainingCenterId)
                .HasConstraintName("FK_Mentors_TrainingCenters");
        });

        modelBuilder.Entity<MentorApplication>(entity =>
        {
            entity.HasKey(e => e.ApplicationId).HasName("PK__MentorAp__3BCBDCF2D1584E3F");

            entity.ToTable("MentorApplications", "Mentor");

            entity.Property(e => e.ApplicationId).HasColumnName("application_id");
            entity.Property(e => e.CertificationFilePath)
                .HasMaxLength(500)
                .HasColumnName("certification_file_path");
            entity.Property(e => e.CertificationUploadedAt).HasColumnName("certification_uploaded_at");
            entity.Property(e => e.IsCertificationVerified)
                .HasDefaultValue(false)
                .HasColumnName("is_certification_verified");
            entity.Property(e => e.MentorId).HasColumnName("mentor_id");
            entity.Property(e => e.RejectionReason)
                .HasMaxLength(500)
                .HasColumnName("rejection_reason");
            entity.Property(e => e.ReviewedAt).HasColumnName("reviewed_at");
            entity.Property(e => e.ReviewedBy).HasColumnName("reviewed_by");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("pending")
                .HasColumnName("status");
            entity.Property(e => e.SubmittedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("submitted_at");

            entity.HasOne(d => d.Mentor).WithMany(p => p.MentorApplications)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__MentorApp__mento__589DBCA1");

            entity.HasOne(d => d.ReviewedByNavigation).WithMany(p => p.MentorApplications)
                .HasForeignKey(d => d.ReviewedBy)
                .HasConstraintName("FK__MentorApp__revie__5991E0DA");
        });

        modelBuilder.Entity<MentorAvailability>(entity =>
        {
            entity.HasKey(e => e.AvailabilityId).HasName("PK__MentorAv__86E3A801010D80E8");

            entity.ToTable("MentorAvailability", "Mentor");

            entity.Property(e => e.AvailabilityId).HasColumnName("availability_id");
            entity.Property(e => e.DayOfWeek)
                .HasMaxLength(10)
                .HasColumnName("day_of_week");
            entity.Property(e => e.EndTime).HasColumnName("end_time");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.MentorId).HasColumnName("mentor_id");
            entity.Property(e => e.StartTime).HasColumnName("start_time");

            entity.HasOne(d => d.Mentor).WithMany(p => p.MentorAvailabilities)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__MentorAva__mento__51F0BF12");
        });

        modelBuilder.Entity<Message>(entity =>
        {
            entity.HasKey(e => e.MessageId).HasName("PK__Messages__0BBF6EE6888E2892");

            entity.ToTable("Messages", "Messaging");

            entity.HasIndex(e => e.ConversationId, "idx_messages_conversation_id");

            entity.Property(e => e.MessageId).HasColumnName("message_id");
            entity.Property(e => e.ConversationId).HasColumnName("conversation_id");
            entity.Property(e => e.IsRead)
                .HasDefaultValue(false)
                .HasColumnName("is_read");
            entity.Property(e => e.MessageText).HasColumnName("message_text");
            entity.Property(e => e.SenderId).HasColumnName("sender_id");
            entity.Property(e => e.SentAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("sent_at");

            entity.HasOne(d => d.Conversation).WithMany(p => p.Messages)
                .HasForeignKey(d => d.ConversationId)
                .HasConstraintName("FK__Messages__conver__57748E3E");

            entity.HasOne(d => d.Sender).WithMany(p => p.Messages)
                .HasForeignKey(d => d.SenderId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Messages__sender__5868B277");
        });

        modelBuilder.Entity<ModuleContent>(entity =>
        {
            entity.HasKey(e => e.ContentId).HasName("PK__ModuleCo__655FE51058149B60");

            entity.ToTable("ModuleContents", "Learning");

            entity.Property(e => e.ContentId).HasColumnName("content_id");
            entity.Property(e => e.ContentType)
                .HasMaxLength(20)
                .HasColumnName("content_type");
            entity.Property(e => e.ModuleId).HasColumnName("module_id");
            entity.Property(e => e.VideoUrl)
                .HasMaxLength(500)
                .HasColumnName("video_url");

            entity.HasOne(d => d.Module).WithMany(p => p.ModuleContents)
                .HasForeignKey(d => d.ModuleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ModuleCon__modul__38F0071E");
        });

        modelBuilder.Entity<ModuleContentTranslation>(entity =>
        {
            entity.HasKey(e => e.ContentTranslationId).HasName("PK__ModuleCo__18D39B853D58611E");

            entity.ToTable("ModuleContentTranslations", "Learning");

            entity.HasIndex(e => new { e.ContentId, e.LanguageCode }, "UQ__ModuleCo__DF32DFECCBFD7D6E").IsUnique();

            entity.Property(e => e.ContentTranslationId).HasColumnName("content_translation_id");
            entity.Property(e => e.ContentId).HasColumnName("content_id");
            entity.Property(e => e.LanguageCode)
                .HasMaxLength(5)
                .HasColumnName("language_code");
            entity.Property(e => e.TextContent).HasColumnName("text_content");

            entity.HasOne(d => d.Content).WithMany(p => p.ModuleContentTranslations)
                .HasForeignKey(d => d.ContentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ModuleCon__conte__409128E6");
        });

        modelBuilder.Entity<ModuleRecommendation>(entity =>
        {
            entity.HasKey(e => e.RecommendationId).HasName("PK__ModuleRe__BCB11F4F228AAC98");

            entity.ToTable("ModuleRecommendations", "Learning");

            entity.Property(e => e.RecommendationId).HasColumnName("recommendation_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.MentorId).HasColumnName("mentor_id");
            entity.Property(e => e.ModuleId).HasColumnName("module_id");
            entity.Property(e => e.Note)
                .HasMaxLength(500)
                .HasColumnName("note");
            entity.Property(e => e.TraineeId).HasColumnName("trainee_id");

            entity.HasOne(d => d.Mentor).WithMany(p => p.ModuleRecommendations)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ModuleRec__mento__05706318");

            entity.HasOne(d => d.Module).WithMany(p => p.ModuleRecommendations)
                .HasForeignKey(d => d.ModuleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ModuleRec__modul__0758AB8A");

            entity.HasOne(d => d.Trainee).WithMany(p => p.ModuleRecommendations)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ModuleRec__train__06648751");
        });

        modelBuilder.Entity<ModuleTranslation>(entity =>
        {
            entity.HasKey(e => e.ModuleTranslationId).HasName("PK__ModuleTr__8A4649CE6198483E");

            entity.ToTable("ModuleTranslations", "Learning");

            entity.HasIndex(e => new { e.ModuleId, e.LanguageCode }, "UQ__ModuleTr__A0403CAF9B5338AA").IsUnique();

            entity.Property(e => e.ModuleTranslationId).HasColumnName("module_translation_id");
            entity.Property(e => e.Description)
                .HasMaxLength(500)
                .HasColumnName("description");
            entity.Property(e => e.LanguageCode)
                .HasMaxLength(5)
                .HasColumnName("language_code");
            entity.Property(e => e.ModuleId).HasColumnName("module_id");
            entity.Property(e => e.Title)
                .HasMaxLength(255)
                .HasColumnName("title");

            entity.HasOne(d => d.Module).WithMany(p => p.ModuleTranslations)
                .HasForeignKey(d => d.ModuleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ModuleTra__modul__3CC09802");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.HasKey(e => e.NotificationId).HasName("PK__Notifica__E059842FB43FC88B");

            entity.ToTable("Notifications", "Notifications");

            entity.HasIndex(e => e.UserId, "idx_notifications_user_id");

            entity.Property(e => e.NotificationId).HasColumnName("notification_id");
            entity.Property(e => e.Channel)
                .HasMaxLength(10)
                .HasDefaultValue("app")
                .HasColumnName("channel");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.IsRead).HasColumnName("is_read");
            entity.Property(e => e.Message).HasColumnName("message");
            entity.Property(e => e.Title).HasColumnName("title");
            entity.Property(e => e.Type)
                .HasMaxLength(50)
                .HasColumnName("type");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.Notifications)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Notificat__user___6E57F396");
        });

        modelBuilder.Entity<NotificationPreference>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Notifica__B9BE370FD1F26E6F");

            entity.ToTable("NotificationPreferences", "Notifications");

            entity.Property(e => e.UserId)
                .ValueGeneratedNever()
                .HasColumnName("user_id");
            entity.Property(e => e.PrefersApp)
                .HasDefaultValue(true)
                .HasColumnName("prefers_app");
            entity.Property(e => e.PrefersEmail)
                .HasDefaultValue(true)
                .HasColumnName("prefers_email");
            entity.Property(e => e.PrefersSms).HasColumnName("prefers_sms");
            entity.Property(e => e.ReminderHoursBefore)
                .HasDefaultValue(24)
                .HasColumnName("reminder_hours_before");

            entity.HasOne(d => d.User).WithOne(p => p.NotificationPreference)
                .HasForeignKey<NotificationPreference>(d => d.UserId)
                .HasConstraintName("FK__Notificat__user___7504F125");
        });

        modelBuilder.Entity<OptionTranslation>(entity =>
        {
            entity.HasKey(e => e.OptionTranslationId).HasName("PK__OptionTr__EAEFDD482DB82604");

            entity.ToTable("OptionTranslations", "Learning");

            entity.HasIndex(e => new { e.OptionId, e.LanguageCode }, "UQ__OptionTr__4E87F4E7587D48A9").IsUnique();

            entity.Property(e => e.OptionTranslationId).HasColumnName("option_translation_id");
            entity.Property(e => e.LanguageCode)
                .HasMaxLength(5)
                .HasColumnName("language_code");
            entity.Property(e => e.OptionId).HasColumnName("option_id");
            entity.Property(e => e.OptionText)
                .HasMaxLength(500)
                .HasColumnName("option_text");

            entity.HasOne(d => d.Option).WithMany(p => p.OptionTranslations)
                .HasForeignKey(d => d.OptionId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__OptionTra__optio__4C02DB92");
        });

        modelBuilder.Entity<Province>(entity =>
        {
            entity.HasKey(e => e.ProvinceId).HasName("PK__Province__08DCB60FF0B136DD");

            entity.ToTable("Provinces", "Lookup");

            entity.HasIndex(e => e.ProvinceKey, "UQ__Province__0DCE84EC1882F71B").IsUnique();

            entity.Property(e => e.ProvinceId).HasColumnName("province_id");
            entity.Property(e => e.ProvinceKey)
                .HasMaxLength(50)
                .HasColumnName("province_key");
        });

        modelBuilder.Entity<ProvinceTranslation>(entity =>
        {
            entity.HasKey(e => e.ProvinceTranslationId).HasName("PK__Province__56970B271CE3A063");

            entity.ToTable("ProvinceTranslations", "Lookup");

            entity.HasIndex(e => new { e.ProvinceId, e.LanguageCode }, "UQ__Province__B2B18CF3C203C192").IsUnique();

            entity.Property(e => e.ProvinceTranslationId).HasColumnName("province_translation_id");
            entity.Property(e => e.DisplayName)
                .HasMaxLength(100)
                .HasColumnName("display_name");
            entity.Property(e => e.LanguageCode)
                .HasMaxLength(5)
                .HasColumnName("language_code");
            entity.Property(e => e.ProvinceId).HasColumnName("province_id");

            entity.HasOne(d => d.Province).WithMany(p => p.ProvinceTranslations)
                .HasForeignKey(d => d.ProvinceId)
                .HasConstraintName("FK__ProvinceT__provi__766329B2");
        });

        modelBuilder.Entity<QuestionOption>(entity =>
        {
            entity.HasKey(e => e.OptionId).HasName("PK__Question__F4EACE1BF5E96886");

            entity.ToTable("QuestionOptions", "Learning");

            entity.Property(e => e.OptionId).HasColumnName("option_id");
            entity.Property(e => e.IsCorrect).HasColumnName("is_correct");
            entity.Property(e => e.QuestionId).HasColumnName("question_id");

            entity.HasOne(d => d.Question).WithMany(p => p.QuestionOptions)
                .HasForeignKey(d => d.QuestionId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuestionO__quest__12CA5E36");
        });

        modelBuilder.Entity<QuestionTranslation>(entity =>
        {
            entity.HasKey(e => e.QuestionTranslationId).HasName("PK__Question__CA97197065AE5F7D");

            entity.ToTable("QuestionTranslations", "Learning");

            entity.HasIndex(e => new { e.QuestionId, e.LanguageCode }, "UQ__Question__94AF2FB5F31F9460").IsUnique();

            entity.Property(e => e.QuestionTranslationId).HasColumnName("question_translation_id");
            entity.Property(e => e.LanguageCode)
                .HasMaxLength(5)
                .HasColumnName("language_code");
            entity.Property(e => e.QuestionId).HasColumnName("question_id");
            entity.Property(e => e.QuestionText)
                .HasMaxLength(1000)
                .HasColumnName("question_text");

            entity.HasOne(d => d.Question).WithMany(p => p.QuestionTranslations)
                .HasForeignKey(d => d.QuestionId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuestionT__quest__48324AAE");
        });

        modelBuilder.Entity<Quiz>(entity =>
        {
            entity.HasKey(e => e.QuizId).HasName("PK__Quizzes__2D7053EC35D660E7");

            entity.ToTable("Quizzes", "Learning");

            entity.Property(e => e.QuizId).HasColumnName("quiz_id");
            entity.Property(e => e.IsMockExam)
                .HasDefaultValue(false)
                .HasColumnName("is_mock_exam");
            entity.Property(e => e.LicenseTypeId).HasColumnName("license_type_id");
            entity.Property(e => e.ModuleId).HasColumnName("module_id");
            entity.Property(e => e.PassingScore).HasColumnName("passing_score");

            entity.HasOne(d => d.LicenseType).WithMany(p => p.Quizzes)
                .HasForeignKey(d => d.LicenseTypeId)
                .HasConstraintName("FK__Quizzes__license__0C1D60A7");

            entity.HasOne(d => d.Module).WithMany(p => p.Quizzes)
                .HasForeignKey(d => d.ModuleId)
                .HasConstraintName("FK__Quizzes__module___0B293C6E");
        });

        modelBuilder.Entity<QuizAttempt>(entity =>
        {
            entity.HasKey(e => e.AttemptId).HasName("PK__QuizAtte__5621F949729D2050");

            entity.ToTable("QuizAttempts", "Learning");

            entity.Property(e => e.AttemptId).HasColumnName("attempt_id");
            entity.Property(e => e.AttemptDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("attempt_date");
            entity.Property(e => e.Passed).HasColumnName("passed");
            entity.Property(e => e.QuizId).HasColumnName("quiz_id");
            entity.Property(e => e.Score).HasColumnName("score");
            entity.Property(e => e.TraineeId).HasColumnName("trainee_id");
            entity.Property(e => e.TraineeLicenseId).HasColumnName("trainee_license_id");

            entity.HasOne(d => d.Quiz).WithMany(p => p.QuizAttempts)
                .HasForeignKey(d => d.QuizId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuizAttem__quiz___169AEF1A");

            entity.HasOne(d => d.Trainee).WithMany(p => p.QuizAttempts)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuizAttem__train__178F1353");

            entity.HasOne(d => d.TraineeLicense).WithMany(p => p.QuizAttempts)
                .HasForeignKey(d => d.TraineeLicenseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuizAttem__train__1883378C");
        });

        modelBuilder.Entity<QuizQuestion>(entity =>
        {
            entity.HasKey(e => e.QuestionId).HasName("PK__QuizQues__2EC21549A91AE25C");

            entity.ToTable("QuizQuestions", "Learning");

            entity.HasIndex(e => e.QuizId, "idx_quizquestions_quiz_id");

            entity.Property(e => e.QuestionId).HasColumnName("question_id");
            entity.Property(e => e.QuizId).HasColumnName("quiz_id");

            entity.HasOne(d => d.Quiz).WithMany(p => p.QuizQuestions)
                .HasForeignKey(d => d.QuizId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuizQuest__quiz___0EF9CD52");
        });

        modelBuilder.Entity<QuizTranslation>(entity =>
        {
            entity.HasKey(e => e.QuizTranslationId).HasName("PK__QuizTran__7B8247C6A1ACE7EB");

            entity.ToTable("QuizTranslations", "Learning");

            entity.HasIndex(e => new { e.QuizId, e.LanguageCode }, "UQ__QuizTran__971D6910606A2C89").IsUnique();

            entity.Property(e => e.QuizTranslationId).HasColumnName("quiz_translation_id");
            entity.Property(e => e.LanguageCode)
                .HasMaxLength(5)
                .HasColumnName("language_code");
            entity.Property(e => e.QuizId).HasColumnName("quiz_id");
            entity.Property(e => e.Title)
                .HasMaxLength(255)
                .HasColumnName("title");

            entity.HasOne(d => d.Quiz).WithMany(p => p.QuizTranslations)
                .HasForeignKey(d => d.QuizId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuizTrans__quiz___4461B9CA");
        });

        modelBuilder.Entity<Rating>(entity =>
        {
            entity.HasKey(e => e.RatingId).HasName("PK__Ratings__D35B278BDF54654E");

            entity.ToTable("Ratings", "Learning");

            entity.HasIndex(e => e.BookingId, "UQ__Ratings__5DE3A5B07EAA49A9").IsUnique();

            entity.Property(e => e.RatingId).HasColumnName("rating_id");
            entity.Property(e => e.BookingId).HasColumnName("booking_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.MentorId).HasColumnName("mentor_id");
            entity.Property(e => e.ReviewText)
                .HasMaxLength(1000)
                .HasColumnName("review_text");
            entity.Property(e => e.Score)
                .HasColumnType("decimal(2, 1)")
                .HasColumnName("score");
            entity.Property(e => e.TraineeId).HasColumnName("trainee_id");

            entity.HasOne(d => d.Booking).WithOne(p => p.Rating)
                .HasForeignKey<Rating>(d => d.BookingId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ratings__booking__20245954");

            entity.HasOne(d => d.Mentor).WithMany(p => p.Ratings)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ratings__mentor___1F30351B");

            entity.HasOne(d => d.Trainee).WithMany(p => p.Ratings)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ratings__trainee__1E3C10E2");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__Roles__760965CC7FCD06BF");

            entity.ToTable("Roles", "Lookup");

            entity.Property(e => e.RoleId).HasColumnName("role_id");
            entity.Property(e => e.RoleName)
                .HasMaxLength(50)
                .HasColumnName("role_name");
        });

        modelBuilder.Entity<SecurityPasswordResetToken>(entity =>
        {
            entity.HasKey(e => e.TokenId).HasName("PK__Security__CB3C9E179EFD84B3");

            entity.HasIndex(e => e.Token, "UQ__Security__CA90DA7AD4D268FA").IsUnique();

            entity.Property(e => e.TokenId).HasColumnName("token_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.ExpiresAt).HasColumnName("expires_at");
            entity.Property(e => e.Token)
                .HasMaxLength(255)
                .HasColumnName("token");
            entity.Property(e => e.Used)
                .HasDefaultValue(false)
                .HasColumnName("used");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.SecurityPasswordResetTokens)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SecurityP__user___7ABDCA7B");
        });

        modelBuilder.Entity<SessionFeedback>(entity =>
        {
            entity.HasKey(e => e.FeedbackId).HasName("PK__SessionF__7A6B2B8C4FADBB49");

            entity.ToTable("SessionFeedback", "Learning");

            entity.HasIndex(e => e.BookingId, "UQ__SessionF__5DE3A5B0F6363423").IsUnique();

            entity.Property(e => e.FeedbackId).HasColumnName("feedback_id");
            entity.Property(e => e.BookingId).HasColumnName("booking_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.MentorId).HasColumnName("mentor_id");
            entity.Property(e => e.MentorNotes).HasColumnName("mentor_notes");
            entity.Property(e => e.TraineeId).HasColumnName("trainee_id");

            entity.HasOne(d => d.Booking).WithOne(p => p.SessionFeedback)
                .HasForeignKey<SessionFeedback>(d => d.BookingId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SessionFe__booki__2B960C00");

            entity.HasOne(d => d.Mentor).WithMany(p => p.SessionFeedbacks)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SessionFe__mento__2D7E5472");

            entity.HasOne(d => d.Trainee).WithMany(p => p.SessionFeedbacks)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SessionFe__train__2C8A3039");
        });

        modelBuilder.Entity<Trainee>(entity =>
        {
            entity.HasKey(e => e.TraineeId).HasName("PK__Trainees__77B2DEB8EF11FDFB");

            entity.ToTable("Trainees", "Roles");

            entity.Property(e => e.TraineeId)
                .ValueGeneratedNever()
                .HasColumnName("trainee_id");
            entity.Property(e => e.EnrolledAt)
                .HasDefaultValueSql("(CONVERT([date],getdate()))")
                .HasColumnName("enrolled_at");
            entity.Property(e => e.LicenseTypeId).HasColumnName("license_type_id");
            entity.Property(e => e.TrainingCenterId).HasColumnName("training_center_id");

            entity.HasOne(d => d.LicenseType).WithMany(p => p.Trainees)
                .HasForeignKey(d => d.LicenseTypeId)
                .HasConstraintName("FK__Trainees__licens__467F0C66");

            entity.HasOne(d => d.TraineeNavigation).WithOne(p => p.Trainee)
                .HasForeignKey<Trainee>(d => d.TraineeId)
                .HasConstraintName("FK__Trainees__traine__458AE82D");

            entity.HasOne(d => d.TrainingCenter).WithMany(p => p.Trainees)
                .HasForeignKey(d => d.TrainingCenterId)
                .HasConstraintName("FK_Trainees_TrainingCenters");
        });

        modelBuilder.Entity<TraineeLicense>(entity =>
        {
            entity.HasKey(e => e.TraineeLicenseId).HasName("PK__TraineeL__5F54669877000CEB");

            entity.ToTable("TraineeLicenses", "Core");

            entity.HasIndex(e => new { e.TraineeId, e.LicenseTypeId }, "UQ__TraineeL__2FA1D27B9D5BB045").IsUnique();

            entity.Property(e => e.TraineeLicenseId).HasColumnName("trainee_license_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.LicenseTypeId).HasColumnName("license_type_id");
            entity.Property(e => e.MentorId).HasColumnName("mentor_id");
            entity.Property(e => e.ProgressPercentage).HasColumnName("progress_percentage");
            entity.Property(e => e.Stage)
                .HasMaxLength(30)
                .HasDefaultValue("registered")
                .HasColumnName("stage");
            entity.Property(e => e.TraineeId).HasColumnName("trainee_id");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.LicenseType).WithMany(p => p.TraineeLicenses)
                .HasForeignKey(d => d.LicenseTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TraineeLi__licen__3DE9C665");

            entity.HasOne(d => d.Mentor).WithMany(p => p.TraineeLicenses)
                .HasForeignKey(d => d.MentorId)
                .HasConstraintName("FK_TraineeLicenses_Mentors");

            entity.HasOne(d => d.Trainee).WithMany(p => p.TraineeLicenses)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TraineeLicenses_Trainees");
        });

        modelBuilder.Entity<TraineeModuleProgress>(entity =>
        {
            entity.HasKey(e => e.ProgressId).HasName("PK__TraineeM__49B3D8C17CB30431");

            entity.ToTable("TraineeModuleProgress", "Learning");

            entity.HasIndex(e => new { e.TraineeId, e.ModuleId, e.TraineeLicenseId }, "UQ__TraineeM__CF4F5ABA0BA33D96").IsUnique();

            entity.Property(e => e.ProgressId).HasColumnName("progress_id");
            entity.Property(e => e.CompletedAt).HasColumnName("completed_at");
            entity.Property(e => e.ModuleId).HasColumnName("module_id");
            entity.Property(e => e.StartedAt).HasColumnName("started_at");
            entity.Property(e => e.Status)
                .HasMaxLength(20)
                .HasDefaultValue("not_started")
                .HasColumnName("status");
            entity.Property(e => e.TraineeId).HasColumnName("trainee_id");
            entity.Property(e => e.TraineeLicenseId).HasColumnName("trainee_license_id");

            entity.HasOne(d => d.Module).WithMany(p => p.TraineeModuleProgresses)
                .HasForeignKey(d => d.ModuleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TraineeMo__modul__00ABADFB");

            entity.HasOne(d => d.Trainee).WithMany(p => p.TraineeModuleProgresses)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TraineeMo__train__7FB789C2");

            entity.HasOne(d => d.TraineeLicense).WithMany(p => p.TraineeModuleProgresses)
                .HasForeignKey(d => d.TraineeLicenseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TraineeMo__train__019FD234");
        });

        modelBuilder.Entity<TrainingCenter>(entity =>
        {
            entity.HasKey(e => e.CenterId).HasName("PK__Training__290A2887291ABA2A");

            entity.ToTable("TrainingCenters", "Learning");

            entity.HasIndex(e => e.Email, "UQ__Training__AB6E6164234521DD").IsUnique();

            entity.HasIndex(e => e.LicenseNumber, "UQ__Training__D482A003943F8A6D").IsUnique();

            entity.Property(e => e.CenterId).HasColumnName("center_id");
            entity.Property(e => e.AddressLine1)
                .HasMaxLength(255)
                .HasColumnName("address_line1");
            entity.Property(e => e.AddressLine2)
                .HasMaxLength(255)
                .HasColumnName("address_line2");
            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.DisplayNameAr)
                .HasMaxLength(255)
                .HasColumnName("display_name_ar");
            entity.Property(e => e.DisplayNameEn)
                .HasMaxLength(255)
                .HasColumnName("display_name_en");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.LicenseNumber)
                .HasMaxLength(100)
                .HasColumnName("license_number");
            entity.Property(e => e.PhoneNumber)
                .HasMaxLength(20)
                .HasColumnName("phone_number");
            entity.Property(e => e.PostalCode)
                .HasMaxLength(20)
                .HasColumnName("postal_code");
            entity.Property(e => e.ProvinceId).HasColumnName("province_id");

            entity.HasOne(d => d.City).WithMany(p => p.TrainingCenters)
                .HasForeignKey(d => d.CityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TrainingC__city___351F763A");

            entity.HasOne(d => d.Province).WithMany(p => p.TrainingCenters)
                .HasForeignKey(d => d.ProvinceId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TrainingC__provi__342B5201");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Users__B9BE370FEC69BAF2");

            entity.ToTable("Users", "Core");

            entity.HasIndex(e => e.NationalId, "UQ__Users__9560E95DA1B5E1F4").IsUnique();

            entity.HasIndex(e => e.Email, "UQ__Users__AB6E6164E3BCAF78").IsUnique();

            entity.HasIndex(e => e.Email, "idx_users_email");

            entity.HasIndex(e => e.NationalId, "idx_users_national_id");

            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.AddressLine1)
                .HasMaxLength(255)
                .HasColumnName("address_line1");
            entity.Property(e => e.AddressLine2)
                .HasMaxLength(255)
                .HasColumnName("address_line2");
            entity.Property(e => e.CityId).HasColumnName("city_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.DateOfBirth).HasColumnName("date_of_birth");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.FirstName)
                .HasMaxLength(100)
                .HasColumnName("first_name");
            entity.Property(e => e.Gender)
                .HasMaxLength(10)
                .HasColumnName("gender");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.LanguagePreference)
                .HasMaxLength(5)
                .HasDefaultValue("ar")
                .HasColumnName("language_preference");
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .HasColumnName("last_name");
            entity.Property(e => e.NationalId)
                .HasMaxLength(10)
                .HasColumnName("national_id");
            entity.Property(e => e.PasswordHash)
                .HasMaxLength(255)
                .HasColumnName("password_hash");
            entity.Property(e => e.PhoneNumber)
                .HasMaxLength(20)
                .HasColumnName("phone_number");
            entity.Property(e => e.PostalCode)
                .HasMaxLength(20)
                .HasColumnName("postal_code");
            entity.Property(e => e.ProfilePicturePath)
                .HasMaxLength(500)
                .HasColumnName("profile_picture_path");
            entity.Property(e => e.ProvinceId).HasColumnName("province_id");
            entity.Property(e => e.RoleId).HasColumnName("role_id");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.City).WithMany(p => p.Users)
                .HasForeignKey(d => d.CityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Users__city_id__2DB35E9C");

            entity.HasOne(d => d.National).WithOne(p => p.User)
                .HasForeignKey<User>(d => d.NationalId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Users__national___2BCB162A");

            entity.HasOne(d => d.Province).WithMany(p => p.Users)
                .HasForeignKey(d => d.ProvinceId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Users__province___2CBF3A63");

            entity.HasOne(d => d.Role).WithMany(p => p.Users)
                .HasForeignKey(d => d.RoleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Users__role_id__2AD6F1F1");
        });

        modelBuilder.Entity<UserConsent>(entity =>
        {
            entity.HasKey(e => e.ConsentId).HasName("PK__UserCons__E6C2B67800D1D68F");

            entity.ToTable("UserConsents", "Core");

            entity.Property(e => e.ConsentId).HasColumnName("consent_id");
            entity.Property(e => e.ConsentType)
                .HasMaxLength(100)
                .HasColumnName("consent_type");
            entity.Property(e => e.Consented)
                .HasDefaultValue(true)
                .HasColumnName("consented");
            entity.Property(e => e.ConsentedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("consented_at");
            entity.Property(e => e.IpAddress)
                .HasMaxLength(50)
                .HasColumnName("ip_address");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.UserConsents)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__UserConse__user___336C37F2");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}

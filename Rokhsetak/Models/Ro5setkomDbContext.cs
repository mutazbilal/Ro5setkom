using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace Rokhsetak.Models;

public partial class Ro5setkomDbContext : DbContext
{
    public Ro5setkomDbContext()
    {
    }

    public Ro5setkomDbContext(DbContextOptions<Ro5setkomDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Admin> Admins { get; set; }

    public virtual DbSet<AichatMessage> AichatMessages { get; set; }

    public virtual DbSet<AichatSession> AichatSessions { get; set; }

    public virtual DbSet<AuditLog> AuditLogs { get; set; }

    public virtual DbSet<BlockedDate> BlockedDates { get; set; }

    public virtual DbSet<Booking> Bookings { get; set; }

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
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
    {
        if (!optionsBuilder.IsConfigured)
        {
            optionsBuilder.UseSqlServer("Server=localhost;Database=Ro5setkomDb;Trusted_Connection=True;");
        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Admin>(entity =>
        {
            entity.HasKey(e => e.AdminId).HasName("PK__Admins__43AA4141E956C027");

            entity.ToTable("Admins", "Roles");

            entity.HasIndex(e => e.BadgeNumber, "UQ__Admins__3E4D103EB9B122F7").IsUnique();

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
                .HasConstraintName("FK__Admins__admin_id__797309D9");
        });

        modelBuilder.Entity<AichatMessage>(entity =>
        {
            entity.HasKey(e => e.MessageId).HasName("PK__AIChatMe__0BBF6EE6D418DB16");

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
                .HasConstraintName("FK__AIChatMes__sessi__1B9317B3");
        });

        modelBuilder.Entity<AichatSession>(entity =>
        {
            entity.HasKey(e => e.SessionId).HasName("PK__AIChatSe__69B13FDC0569B1FB");

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
                .HasConstraintName("FK__AIChatSes__user___16CE6296");
        });

        modelBuilder.Entity<AuditLog>(entity =>
        {
            entity.HasKey(e => e.LogId).HasName("PK__AuditLog__9E2397E05BD51282");

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
                .HasConstraintName("FK__AuditLogs__user___336AA144");
        });

        modelBuilder.Entity<BlockedDate>(entity =>
        {
            entity.HasKey(e => e.BlockedDateId).HasName("PK__BlockedD__9F5620D761548094");

            entity.ToTable("BlockedDates", "Scheduling");

            entity.HasIndex(e => e.BlockedDate1, "UQ__BlockedD__D739C54F97947E64").IsUnique();

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
                .HasConstraintName("FK__BlockedDa__block__151B244E");
        });

        modelBuilder.Entity<Booking>(entity =>
        {
            entity.HasKey(e => e.BookingId).HasName("PK__Bookings__5DE3A5B197258D8E");

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
                .HasConstraintName("FK__Bookings__licens__1F98B2C1");

            entity.HasOne(d => d.Mentor).WithMany(p => p.Bookings)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Bookings__mentor__1EA48E88");

            entity.HasOne(d => d.Trainee).WithMany(p => p.Bookings)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Bookings__traine__1DB06A4F");

            entity.HasOne(d => d.TraineeLicense).WithMany(p => p.Bookings)
                .HasForeignKey(d => d.TraineeLicenseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Bookings__traine__208CD6FA");
        });

        modelBuilder.Entity<CompletionCertificate>(entity =>
        {
            entity.HasKey(e => e.CertificateId).HasName("PK__Completi__E2256D31E7AE84C3");

            entity.ToTable("CompletionCertificates", "Learning");

            entity.HasIndex(e => e.TraineeLicenseId, "UQ__Completi__5F5466992179C967").IsUnique();

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
                .HasConstraintName("FK__Completio__mento__5CA1C101");

            entity.HasOne(d => d.Trainee).WithMany(p => p.CompletionCertificates)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Completio__train__5BAD9CC8");

            entity.HasOne(d => d.TraineeLicense).WithOne(p => p.CompletionCertificate)
                .HasForeignKey<CompletionCertificate>(d => d.TraineeLicenseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Completio__train__5D95E53A");
        });

        modelBuilder.Entity<Conversation>(entity =>
        {
            entity.HasKey(e => e.ConversationId).HasName("PK__Conversa__311E7E9ACE206D76");

            entity.ToTable("Conversations", "Messaging");

            entity.HasIndex(e => e.BookingId, "UQ__Conversa__5DE3A5B014ED23D2").IsUnique();

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
                .HasConstraintName("FK__Conversat__booki__078C1F06");

            entity.HasOne(d => d.Mentor).WithMany(p => p.Conversations)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Conversat__mento__0697FACD");

            entity.HasOne(d => d.Trainee).WithMany(p => p.Conversations)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Conversat__train__05A3D694");
        });

        modelBuilder.Entity<ConversationAttachment>(entity =>
        {
            entity.HasKey(e => e.AttachmentId).HasName("PK__Conversa__B74DF4E23D1C4A12");

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
                .HasConstraintName("FK__Conversat__conve__1209AD79");

            entity.HasOne(d => d.UploadedByNavigation).WithMany(p => p.ConversationAttachments)
                .HasForeignKey(d => d.UploadedBy)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Conversat__uploa__12FDD1B2");
        });

        modelBuilder.Entity<ExamAppointment>(entity =>
        {
            entity.HasKey(e => e.ExamAppointmentId).HasName("PK__ExamAppo__3AFEDC74D331E03C");

            entity.ToTable("ExamAppointments", "Scheduling");

            entity.HasIndex(e => new { e.TraineeId, e.OfficialExamId }, "UQ__ExamAppo__5D00D9F0DCADC7BD").IsUnique();

            entity.HasIndex(e => e.TraineeLicenseId, "UQ__ExamAppo__5F5466998622F5CE").IsUnique();

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
                .HasConstraintName("FK__ExamAppoi__offic__2A164134");

            entity.HasOne(d => d.Trainee).WithMany(p => p.ExamAppointments)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ExamAppoi__train__29221CFB");

            entity.HasOne(d => d.TraineeLicense).WithOne(p => p.ExamAppointment)
                .HasForeignKey<ExamAppointment>(d => d.TraineeLicenseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ExamAppoi__train__2B0A656D");
        });

        modelBuilder.Entity<GovCitizen>(entity =>
        {
            entity.HasKey(e => e.NationalId).HasName("PK__GovCitiz__9560E95CF6EB8B1C");

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
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
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
            entity.Property(e => e.Province)
                .HasMaxLength(100)
                .HasColumnName("province");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("updated_at");
        });

        modelBuilder.Entity<GovExamCenter>(entity =>
        {
            entity.HasKey(e => e.CenterId).HasName("PK__GovExamC__290A2887EC461B50");

            entity.ToTable("GovExamCenters", "Gov");

            entity.Property(e => e.CenterId).HasColumnName("center_id");
            entity.Property(e => e.AddressLine1)
                .HasMaxLength(255)
                .HasColumnName("address_line1");
            entity.Property(e => e.AddressLine2)
                .HasMaxLength(255)
                .HasColumnName("address_line2");
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
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
            entity.Property(e => e.Province)
                .HasMaxLength(100)
                .HasColumnName("province");
        });

        modelBuilder.Entity<GovExamResult>(entity =>
        {
            entity.HasKey(e => e.ResultId).HasName("PK__GovExamR__AFB3C316086AF951");

            entity.ToTable("GovExamResults", "Gov");

            entity.HasIndex(e => new { e.OfficialExamId, e.NationalId }, "UQ__GovExamR__72767A075D1FFE00").IsUnique();

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
                .HasConstraintName("FK__GovExamRe__natio__59FA5E80");

            entity.HasOne(d => d.OfficialExam).WithMany(p => p.GovExamResults)
                .HasForeignKey(d => d.OfficialExamId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovExamRe__offic__59063A47");

            entity.HasOne(d => d.RecordedByNavigation).WithMany(p => p.GovExamResults)
                .HasForeignKey(d => d.RecordedBy)
                .HasConstraintName("FK_GovExamResults_Admins");
        });

        modelBuilder.Entity<GovLicenseRecord>(entity =>
        {
            entity.HasKey(e => e.RecordId).HasName("PK__GovLicen__BFCFB4DD0B0D8175");

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
                .HasConstraintName("FK__GovLicens__licen__48CFD27E");

            entity.HasOne(d => d.National).WithMany(p => p.GovLicenseRecords)
                .HasForeignKey(d => d.NationalId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovLicens__natio__47DBAE45");
        });

        modelBuilder.Entity<GovOfficialExam>(entity =>
        {
            entity.HasKey(e => e.OfficialExamId).HasName("PK__GovOffic__AB20749376C3F1E7");

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
                .HasConstraintName("FK__GovOffici__cente__52593CB8");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.GovOfficialExams)
                .HasForeignKey(d => d.CreatedBy)
                .HasConstraintName("FK_GovOfficialExams_Admins");

            entity.HasOne(d => d.LicenseType).WithMany(p => p.GovOfficialExams)
                .HasForeignKey(d => d.LicenseTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__GovOffici__licen__534D60F1");
        });

        modelBuilder.Entity<LearningModule>(entity =>
        {
            entity.HasKey(e => e.ModuleId).HasName("PK__Learning__1A2D0653368DA5BF");

            entity.ToTable("LearningModules", "Learning");

            entity.HasIndex(e => new { e.LicenseTypeId, e.OrderIndex, e.Phase }, "UQ__Learning__2F46B0C20148F7BE").IsUnique();

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
                .HasConstraintName("FK__LearningM__licen__2FCF1A8A");

            entity.HasOne(d => d.PrerequisiteModule).WithMany(p => p.InversePrerequisiteModule)
                .HasForeignKey(d => d.PrerequisiteModuleId)
                .HasConstraintName("FK__LearningM__prere__30C33EC3");
        });

        modelBuilder.Entity<LicenseType>(entity =>
        {
            entity.HasKey(e => e.LicenseTypeId).HasName("PK__LicenseT__8130CC24BCC48694");

            entity.ToTable("LicenseTypes", "Lookup");

            entity.HasIndex(e => e.LicenseName, "UQ__LicenseT__E40D75A8B93049D8").IsUnique();

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
            entity.HasKey(e => e.MentorId).HasName("PK__Mentors__E5D27EF3A78A618F");

            entity.ToTable("Mentors", "Roles");

            entity.Property(e => e.MentorId)
                .ValueGeneratedNever()
                .HasColumnName("mentor_id");
            entity.Property(e => e.ApplicationId).HasColumnName("application_id");
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
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

            entity.HasOne(d => d.LicenseType).WithMany(p => p.Mentors)
                .HasForeignKey(d => d.LicenseTypeId)
                .HasConstraintName("FK__Mentors__license__02FC7413");

            entity.HasOne(d => d.MentorNavigation).WithOne(p => p.Mentor)
                .HasForeignKey<Mentor>(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Mentors__mentor___02084FDA");

            entity.HasOne(d => d.TrainingCenter).WithMany(p => p.Mentors)
                .HasForeignKey(d => d.TrainingCenterId)
                .HasConstraintName("FK_Mentors_TrainingCenters");
        });

        modelBuilder.Entity<MentorApplication>(entity =>
        {
            entity.HasKey(e => e.ApplicationId).HasName("PK__MentorAp__3BCBDCF2B8D38C88");

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
                .HasConstraintName("FK__MentorApp__mento__0F624AF8");

            entity.HasOne(d => d.ReviewedByNavigation).WithMany(p => p.MentorApplications)
                .HasForeignKey(d => d.ReviewedBy)
                .HasConstraintName("FK__MentorApp__revie__10566F31");
        });

        modelBuilder.Entity<MentorAvailability>(entity =>
        {
            entity.HasKey(e => e.AvailabilityId).HasName("PK__MentorAv__86E3A80101DF3D16");

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
                .HasConstraintName("FK__MentorAva__mento__08B54D69");
        });

        modelBuilder.Entity<Message>(entity =>
        {
            entity.HasKey(e => e.MessageId).HasName("PK__Messages__0BBF6EE6107FB3CD");

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
                .HasConstraintName("FK__Messages__conver__0C50D423");

            entity.HasOne(d => d.Sender).WithMany(p => p.Messages)
                .HasForeignKey(d => d.SenderId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Messages__sender__0D44F85C");
        });

        modelBuilder.Entity<ModuleContent>(entity =>
        {
            entity.HasKey(e => e.ContentId).HasName("PK__ModuleCo__655FE510C743A0C2");

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
                .HasConstraintName("FK__ModuleCon__modul__6DCC4D03");
        });

        modelBuilder.Entity<ModuleContentTranslation>(entity =>
        {
            entity.HasKey(e => e.ContentTranslationId).HasName("PK__ModuleCo__18D39B85B253C39F");

            entity.ToTable("ModuleContentTranslations", "Learning");

            entity.HasIndex(e => new { e.ContentId, e.LanguageCode }, "UQ__ModuleCo__DF32DFECB296D4F3").IsUnique();

            entity.Property(e => e.ContentTranslationId).HasColumnName("content_translation_id");
            entity.Property(e => e.ContentId).HasColumnName("content_id");
            entity.Property(e => e.LanguageCode)
                .HasMaxLength(5)
                .HasColumnName("language_code");
            entity.Property(e => e.TextContent).HasColumnName("text_content");

            entity.HasOne(d => d.Content).WithMany(p => p.ModuleContentTranslations)
                .HasForeignKey(d => d.ContentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ModuleCon__conte__756D6ECB");
        });

        modelBuilder.Entity<ModuleRecommendation>(entity =>
        {
            entity.HasKey(e => e.RecommendationId).HasName("PK__ModuleRe__BCB11F4F0B55D99B");

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
                .HasConstraintName("FK__ModuleRec__mento__3C34F16F");

            entity.HasOne(d => d.Module).WithMany(p => p.ModuleRecommendations)
                .HasForeignKey(d => d.ModuleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ModuleRec__modul__3E1D39E1");

            entity.HasOne(d => d.Trainee).WithMany(p => p.ModuleRecommendations)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ModuleRec__train__3D2915A8");
        });

        modelBuilder.Entity<ModuleTranslation>(entity =>
        {
            entity.HasKey(e => e.ModuleTranslationId).HasName("PK__ModuleTr__8A4649CE64D9B72C");

            entity.ToTable("ModuleTranslations", "Learning");

            entity.HasIndex(e => new { e.ModuleId, e.LanguageCode }, "UQ__ModuleTr__A0403CAF0391D6DB").IsUnique();

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
                .HasConstraintName("FK__ModuleTra__modul__719CDDE7");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.HasKey(e => e.NotificationId).HasName("PK__Notifica__E059842F6C2E020B");

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
                .HasConstraintName("FK__Notificat__user___2334397B");
        });

        modelBuilder.Entity<NotificationPreference>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Notifica__B9BE370F2AF62097");

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
                .HasConstraintName("FK__Notificat__user___29E1370A");
        });

        modelBuilder.Entity<OptionTranslation>(entity =>
        {
            entity.HasKey(e => e.OptionTranslationId).HasName("PK__OptionTr__EAEFDD483B9805BC");

            entity.ToTable("OptionTranslations", "Learning");

            entity.HasIndex(e => new { e.OptionId, e.LanguageCode }, "UQ__OptionTr__4E87F4E786BEFA5C").IsUnique();

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
                .HasConstraintName("FK__OptionTra__optio__00DF2177");
        });

        modelBuilder.Entity<QuestionOption>(entity =>
        {
            entity.HasKey(e => e.OptionId).HasName("PK__Question__F4EACE1B3E8DB64E");

            entity.ToTable("QuestionOptions", "Learning");

            entity.Property(e => e.OptionId).HasColumnName("option_id");
            entity.Property(e => e.IsCorrect).HasColumnName("is_correct");
            entity.Property(e => e.QuestionId).HasColumnName("question_id");

            entity.HasOne(d => d.Question).WithMany(p => p.QuestionOptions)
                .HasForeignKey(d => d.QuestionId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuestionO__quest__498EEC8D");
        });

        modelBuilder.Entity<QuestionTranslation>(entity =>
        {
            entity.HasKey(e => e.QuestionTranslationId).HasName("PK__Question__CA971970F7E97B62");

            entity.ToTable("QuestionTranslations", "Learning");

            entity.HasIndex(e => new { e.QuestionId, e.LanguageCode }, "UQ__Question__94AF2FB547B6A561").IsUnique();

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
                .HasConstraintName("FK__QuestionT__quest__7D0E9093");
        });

        modelBuilder.Entity<Quiz>(entity =>
        {
            entity.HasKey(e => e.QuizId).HasName("PK__Quizzes__2D7053ECEF12BF37");

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
                .HasConstraintName("FK__Quizzes__license__42E1EEFE");

            entity.HasOne(d => d.Module).WithMany(p => p.Quizzes)
                .HasForeignKey(d => d.ModuleId)
                .HasConstraintName("FK__Quizzes__module___41EDCAC5");
        });

        modelBuilder.Entity<QuizAttempt>(entity =>
        {
            entity.HasKey(e => e.AttemptId).HasName("PK__QuizAtte__5621F94947329E26");

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
                .HasConstraintName("FK__QuizAttem__quiz___4D5F7D71");

            entity.HasOne(d => d.Trainee).WithMany(p => p.QuizAttempts)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuizAttem__train__4E53A1AA");

            entity.HasOne(d => d.TraineeLicense).WithMany(p => p.QuizAttempts)
                .HasForeignKey(d => d.TraineeLicenseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuizAttem__train__4F47C5E3");
        });

        modelBuilder.Entity<QuizQuestion>(entity =>
        {
            entity.HasKey(e => e.QuestionId).HasName("PK__QuizQues__2EC21549838142B9");

            entity.ToTable("QuizQuestions", "Learning");

            entity.HasIndex(e => e.QuizId, "idx_quizquestions_quiz_id");

            entity.Property(e => e.QuestionId).HasColumnName("question_id");
            entity.Property(e => e.QuizId).HasColumnName("quiz_id");

            entity.HasOne(d => d.Quiz).WithMany(p => p.QuizQuestions)
                .HasForeignKey(d => d.QuizId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__QuizQuest__quiz___45BE5BA9");
        });

        modelBuilder.Entity<QuizTranslation>(entity =>
        {
            entity.HasKey(e => e.QuizTranslationId).HasName("PK__QuizTran__7B8247C69E1C1A05");

            entity.ToTable("QuizTranslations", "Learning");

            entity.HasIndex(e => new { e.QuizId, e.LanguageCode }, "UQ__QuizTran__971D6910F408406C").IsUnique();

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
                .HasConstraintName("FK__QuizTrans__quiz___793DFFAF");
        });

        modelBuilder.Entity<Rating>(entity =>
        {
            entity.HasKey(e => e.RatingId).HasName("PK__Ratings__D35B278B61948E92");

            entity.ToTable("Ratings", "Learning");

            entity.HasIndex(e => e.BookingId, "UQ__Ratings__5DE3A5B0E788669B").IsUnique();

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
                .HasConstraintName("FK__Ratings__booking__56E8E7AB");

            entity.HasOne(d => d.Mentor).WithMany(p => p.Ratings)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ratings__mentor___55F4C372");

            entity.HasOne(d => d.Trainee).WithMany(p => p.Ratings)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ratings__trainee__55009F39");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__Roles__760965CCE8840FB0");

            entity.ToTable("Roles", "Lookup");

            entity.Property(e => e.RoleId).HasColumnName("role_id");
            entity.Property(e => e.RoleName)
                .HasMaxLength(50)
                .HasColumnName("role_name");
        });

        modelBuilder.Entity<SecurityPasswordResetToken>(entity =>
        {
            entity.HasKey(e => e.TokenId).HasName("PK__Security__CB3C9E17081175DB");

            entity.HasIndex(e => e.Token, "UQ__Security__CA90DA7A15099111").IsUnique();

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
                .HasConstraintName("FK__SecurityP__user___2F9A1060");
        });

        modelBuilder.Entity<SessionFeedback>(entity =>
        {
            entity.HasKey(e => e.FeedbackId).HasName("PK__SessionF__7A6B2B8CA2069FBC");

            entity.ToTable("SessionFeedback", "Learning");

            entity.HasIndex(e => e.BookingId, "UQ__SessionF__5DE3A5B0AA7D1558").IsUnique();

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
                .HasConstraintName("FK__SessionFe__booki__625A9A57");

            entity.HasOne(d => d.Mentor).WithMany(p => p.SessionFeedbacks)
                .HasForeignKey(d => d.MentorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SessionFe__mento__6442E2C9");

            entity.HasOne(d => d.Trainee).WithMany(p => p.SessionFeedbacks)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SessionFe__train__634EBE90");
        });

        modelBuilder.Entity<Trainee>(entity =>
        {
            entity.HasKey(e => e.TraineeId).HasName("PK__Trainees__77B2DEB8BE3EA9A9");

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
                .HasConstraintName("FK__Trainees__licens__7E37BEF6");

            entity.HasOne(d => d.TraineeNavigation).WithOne(p => p.Trainee)
                .HasForeignKey<Trainee>(d => d.TraineeId)
                .HasConstraintName("FK__Trainees__traine__7D439ABD");

            entity.HasOne(d => d.TrainingCenter).WithMany(p => p.Trainees)
                .HasForeignKey(d => d.TrainingCenterId)
                .HasConstraintName("FK_Trainees_TrainingCenters");
        });

        modelBuilder.Entity<TraineeLicense>(entity =>
        {
            entity.HasKey(e => e.TraineeLicenseId).HasName("PK__TraineeL__5F54669858FC2B7E");

            entity.ToTable("TraineeLicenses", "Core");

            entity.HasIndex(e => new { e.TraineeId, e.LicenseTypeId }, "UQ__TraineeL__2FA1D27BEF7E4380").IsUnique();

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
                .HasConstraintName("FK__TraineeLi__licen__75A278F5");

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
            entity.HasKey(e => e.ProgressId).HasName("PK__TraineeM__49B3D8C1A595F296");

            entity.ToTable("TraineeModuleProgress", "Learning");

            entity.HasIndex(e => new { e.TraineeId, e.ModuleId, e.TraineeLicenseId }, "UQ__TraineeM__CF4F5ABAB9CBD86C").IsUnique();

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
                .HasConstraintName("FK__TraineeMo__modul__37703C52");

            entity.HasOne(d => d.Trainee).WithMany(p => p.TraineeModuleProgresses)
                .HasForeignKey(d => d.TraineeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TraineeMo__train__367C1819");

            entity.HasOne(d => d.TraineeLicense).WithMany(p => p.TraineeModuleProgresses)
                .HasForeignKey(d => d.TraineeLicenseId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TraineeMo__train__3864608B");
        });

        modelBuilder.Entity<TrainingCenter>(entity =>
        {
            entity.HasKey(e => e.CenterId).HasName("PK__Training__290A28870DB5D66B");

            entity.ToTable("TrainingCenters", "Learning");

            entity.HasIndex(e => e.Email, "UQ__Training__AB6E6164EB9A7C8C").IsUnique();

            entity.HasIndex(e => e.LicenseNumber, "UQ__Training__D482A00379DB9B50").IsUnique();

            entity.Property(e => e.CenterId).HasColumnName("center_id");
            entity.Property(e => e.AddressLine1)
                .HasMaxLength(255)
                .HasColumnName("address_line1");
            entity.Property(e => e.AddressLine2)
                .HasMaxLength(255)
                .HasColumnName("address_line2");
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("created_at");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.LicenseNumber)
                .HasMaxLength(100)
                .HasColumnName("license_number");
            entity.Property(e => e.Name)
                .HasMaxLength(255)
                .HasColumnName("name");
            entity.Property(e => e.PhoneNumber)
                .HasMaxLength(20)
                .HasColumnName("phone_number");
            entity.Property(e => e.PostalCode)
                .HasMaxLength(20)
                .HasColumnName("postal_code");
            entity.Property(e => e.Province)
                .HasMaxLength(100)
                .HasColumnName("province");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__Users__B9BE370FB0E7C6CD");

            entity.ToTable("Users", "Core");

            entity.HasIndex(e => e.NationalId, "UQ__Users__9560E95DF2A4272A").IsUnique();

            entity.HasIndex(e => e.Email, "UQ__Users__AB6E616413448A3D").IsUnique();

            entity.HasIndex(e => e.Email, "idx_users_email");

            entity.HasIndex(e => e.NationalId, "idx_users_national_id");

            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.AddressLine1)
                .HasMaxLength(255)
                .HasColumnName("address_line1");
            entity.Property(e => e.AddressLine2)
                .HasMaxLength(255)
                .HasColumnName("address_line2");
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
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
            entity.Property(e => e.ProfilePicture)
                .HasMaxLength(500)
                .HasColumnName("profile_picture");
            entity.Property(e => e.Province)
                .HasMaxLength(100)
                .HasColumnName("province");
            entity.Property(e => e.RoleId).HasColumnName("role_id");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.National).WithOne(p => p.User)
                .HasForeignKey<User>(d => d.NationalId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Users__national___656C112C");

            entity.HasOne(d => d.Role).WithMany(p => p.Users)
                .HasForeignKey(d => d.RoleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Users__role_id__6477ECF3");
        });

        modelBuilder.Entity<UserConsent>(entity =>
        {
            entity.HasKey(e => e.ConsentId).HasName("PK__UserCons__E6C2B678FA46ED90");

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
                .HasConstraintName("FK__UserConse__user___6B24EA82");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}

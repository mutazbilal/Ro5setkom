-- ============================================
-- DATABASE CREATION SCRIPT
-- AUTO GENERATED
-- ============================================

-- ============================================
-- DROP ALL TABLES
-- ============================================

DECLARE @sql NVARCHAR(MAX) = N'';

-- Drop foreign keys first
SELECT @sql += 
    'ALTER TABLE [' + s.name + '].[' + t.name + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
FROM sys.foreign_keys fk
JOIN sys.tables t ON fk.parent_object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id;

EXEC sp_executesql @sql;
GO

DECLARE @sql2 NVARCHAR(MAX) = N'';

-- Drop all tables
SELECT @sql2 += 
    'DROP TABLE [' + s.name + '].[' + t.name + '];' + CHAR(13)
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id;

EXEC sp_executesql @sql2;
GO



-- ============================================
-- FILE: 00_Database\02_CreateSchemas.sql
-- ============================================

-- ============================================
-- SCHEMAS INITIALIZATION SCRIPT
-- ============================================

-- Core business domain
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Core')
    EXEC('CREATE SCHEMA Core');
GO

-- Lookup / static reference data
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Lookup')
    EXEC('CREATE SCHEMA Lookup');
GO

-- Government / external authority records
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Gov')
    EXEC('CREATE SCHEMA Gov');
GO

-- Role-specific extensions
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Roles')
    EXEC('CREATE SCHEMA Roles');
GO

-- Mentor-specific extensions
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Mentor')
    EXEC('CREATE SCHEMA Mentor');
GO

-- Learning system (modules, quizzes, attachments, progress)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Learning')
    EXEC('CREATE SCHEMA Learning');
GO

-- Scheduling system (bookings, exams, availability)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Scheduling')
    EXEC('CREATE SCHEMA Scheduling');
GO

-- Messaging system
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Messaging')
    EXEC('CREATE SCHEMA Messaging');
GO

-- AI features
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'AI')
    EXEC('CREATE SCHEMA AI');
GO

-- Notifications system
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Notifications')
    EXEC('CREATE SCHEMA Notifications');
GO

-- Security & auditing
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Security')
    EXEC('CREATE SCHEMA Security');
GO

GO


-- ============================================
-- FILE: 01_Lookups\01_Roles.sql
-- ============================================

CREATE TABLE Lookup.Roles (
    role_id    INT PRIMARY KEY IDENTITY(1,1),
    role_name  NVARCHAR(50) NOT NULL CHECK (role_name IN ('trainee', 'mentor', 'admin'))
);

GO


-- ============================================
-- FILE: 01_Lookups\02_LicenseTypes.sql
-- ============================================

CREATE TABLE Lookup.LicenseTypes (
    license_type_id  INT PRIMARY KEY IDENTITY(1,1),
    license_name     NVARCHAR(50)  NOT NULL UNIQUE CHECK (license_name IN ('motorcycle', 'private_automatic', 'private_manual')),
    display_name_en  NVARCHAR(100) NOT NULL,
    display_name_ar  NVARCHAR(100) NOT NULL,
    description_en   NVARCHAR(255) NULL,
    description_ar   NVARCHAR(255) NULL
);
GO

GO


-- ============================================
-- FILE: 02_Government\01_GovCitizens.sql
-- ============================================

CREATE TABLE Gov.GovCitizens (
    national_id     NVARCHAR(10)  PRIMARY KEY,
    first_name      NVARCHAR(100) NOT NULL,
    last_name       NVARCHAR(100) NOT NULL,
    date_of_birth   DATE          NOT NULL,
    gender          NVARCHAR(10)  NOT NULL CHECK (gender IN ('male', 'female')),
    province       NVARCHAR(100) NOT NULL,
    city           NVARCHAR(100) NOT NULL,
    address_line1  NVARCHAR(255) NOT NULL,
    address_line2  NVARCHAR(255),
    postal_code    NVARCHAR(20),
    is_eligible     BIT           DEFAULT 1,   -- false if citizen is barred from licensing
    created_at      DATETIME2     DEFAULT GETDATE(),
    updated_at      DATETIME2     DEFAULT GETDATE()
);

GO


-- ============================================
-- FILE: 02_Government\02_GovExamCenters.sql
-- ============================================

-- Official exam centers where theory, medical, and practical tests are held
CREATE TABLE Gov.GovExamCenters (
    center_id       INT PRIMARY KEY IDENTITY(1,1),
    name            NVARCHAR(255) NOT NULL,
    province        NVARCHAR(100) NOT NULL,
    city            NVARCHAR(100) NOT NULL,
    address_line1   NVARCHAR(255) NOT NULL,
    address_line2   NVARCHAR(255),
    postal_code     NVARCHAR(20),
    phone_number    NVARCHAR(20),
    is_active       BIT DEFAULT 1
);

GO


-- ============================================
-- FILE: 02_Government\03_GovLicenseRecords.sql
-- ============================================

-- Licenses a citizen already holds (pre-existing, before using the platform)
CREATE TABLE Gov.GovLicenseRecords (
    record_id        INT PRIMARY KEY IDENTITY(1,1),
    national_id      NVARCHAR(10)  NOT NULL,
    license_type_id  INT           NOT NULL,
    issued_date      DATE,
    expiry_date      DATE,
    status           NVARCHAR(20)  NOT NULL CHECK (status IN ('active', 'expired', 'suspended', 'revoked')),

    FOREIGN KEY (national_id)     REFERENCES Gov.GovCitizens(national_id),
    FOREIGN KEY (license_type_id) REFERENCES Lookup.LicenseTypes(license_type_id)
);

GO


-- ============================================
-- FILE: 02_Government\04_GovOfficialExams.sql
-- ============================================

-- Trainees book slots from available entries here
CREATE TABLE Gov.GovOfficialExams (
    official_exam_id  INT PRIMARY KEY IDENTITY(1,1),
    center_id         INT          NOT NULL,
    license_type_id   INT          NOT NULL,
    exam_type         NVARCHAR(20) NOT NULL CHECK (exam_type IN ('theory', 'medical', 'practical')),
    exam_date         DATE         NOT NULL,
    exam_time         TIME         NOT NULL,
    total_slots       INT          NOT NULL DEFAULT 1,
    booked_slots      INT          NOT NULL DEFAULT 0,
    status            NVARCHAR(20) NOT NULL DEFAULT 'scheduled'
                          CHECK (status IN ('scheduled', 'cancelled', 'rescheduled')),
    created_by        INT          NULL,
    created_at        DATETIME2    DEFAULT GETDATE(),

    CHECK (booked_slots <= total_slots),

    FOREIGN KEY (center_id)       REFERENCES Gov.GovExamCenters(center_id),
    FOREIGN KEY (license_type_id) REFERENCES Lookup.LicenseTypes(license_type_id)
    )

GO


-- ============================================
-- FILE: 02_Government\05_GovExamResults.sql
-- ============================================

-- Official exam results recorded by admins
CREATE TABLE Gov.GovExamResults (
    result_id         INT PRIMARY KEY IDENTITY(1,1),
    official_exam_id  INT           NOT NULL,
    national_id       NVARCHAR(10)  NOT NULL,
    result            NVARCHAR(10)  NOT NULL CHECK (result IN ('pass', 'fail', 'absent')),
    score             INT           NULL,      -- numeric score where applicable
    notes             NVARCHAR(500) NULL,
    recorded_by       INT           NULL,      -- FK to admin_id set after that table exists
    recorded_at       DATETIME2     DEFAULT GETDATE(),

    UNIQUE (official_exam_id, national_id),   -- one result per citizen per exam

    FOREIGN KEY (official_exam_id) REFERENCES Gov.GovOfficialExams(official_exam_id),
    FOREIGN KEY (national_id)      REFERENCES Gov.GovCitizens(national_id)
);

GO


-- ============================================
-- FILE: 03_Core\01_Users.sql
-- ============================================

CREATE TABLE Core.Users (
    user_id             INT PRIMARY KEY IDENTITY(1,1),
    role_id             INT           NOT NULL,
    national_id         NVARCHAR(10)  UNIQUE NOT NULL,
    first_name          NVARCHAR(100) NOT NULL,
    last_name           NVARCHAR(100) NOT NULL,
    date_of_birth       DATE,
    gender              NVARCHAR(10)  CHECK (gender IN ('male', 'female')),
    email               NVARCHAR(255) UNIQUE NOT NULL,
    phone_number        NVARCHAR(20),
    province            NVARCHAR(100) NOT NULL,
    city                NVARCHAR(100) NOT NULL,
    address_line1       NVARCHAR(255) NOT NULL,
    address_line2       NVARCHAR(255),
    postal_code         NVARCHAR(20),
    password_hash       NVARCHAR(255) NOT NULL,
    profile_picture     NVARCHAR(500),
    language_preference NVARCHAR(5)   DEFAULT 'ar' CHECK (language_preference IN ('ar', 'en')),
    is_active           BIT           DEFAULT 1,
    created_at          DATETIME2     DEFAULT GETDATE(),
    updated_at          DATETIME2     DEFAULT GETDATE(),

    FOREIGN KEY (role_id)     REFERENCES Lookup.Roles(role_id),
    FOREIGN KEY (national_id) REFERENCES Gov.GovCitizens(national_id)  -- identity must exist in gov registry
);

GO


-- ============================================
-- FILE: 03_Core\02_UserConsents.sql
-- ============================================

CREATE TABLE Core.UserConsents (
    consent_id    INT PRIMARY KEY IDENTITY(1,1),
    user_id       INT           NOT NULL,
    consent_type  NVARCHAR(100) NOT NULL CHECK (consent_type IN ('government_data_retrieval', 'terms_and_privacy')),
    consented     BIT           NOT NULL DEFAULT 1,
    consented_at  DATETIME2     NOT NULL DEFAULT GETDATE(),
    ip_address    NVARCHAR(50),

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id) ON DELETE CASCADE
);

GO


-- ============================================
-- FILE: 03_Core\03_TraineeLicenses.sql
-- ============================================

CREATE TABLE Core.TraineeLicenses (
    trainee_license_id     INT PRIMARY KEY IDENTITY(1,1),
    trainee_id          INT          NOT NULL,
    license_type_id     INT          NOT NULL,
    mentor_id   INT          NULL,
    stage               NVARCHAR(30) NOT NULL DEFAULT 'registered'
                            CHECK (stage IN (
                                'registered',
                                'theoretical_prep',
                                'mock_exam_completed',
                                'theory_test_pending',
                                'theory_passed',
                                'medical_exam_pending',
                                'medical_passed',
                                'practical_prep',
                                'practical_test_pending',
                                'completed'
                            )),
    progress_percentage INT          NOT NULL DEFAULT 0 CHECK (progress_percentage BETWEEN 0 AND 100),
    is_active           BIT          NOT NULL DEFAULT 1,
    created_at          DATETIME2    DEFAULT GETDATE(),
    updated_at          DATETIME2    DEFAULT GETDATE(),
    UNIQUE (trainee_id, license_type_id),
    FOREIGN KEY (license_type_id)   REFERENCES Lookup.LicenseTypes(license_type_id)
);

GO


-- ============================================
-- FILE: 04_RoleProfiles\01_Admins.sql
-- ============================================

CREATE TABLE Roles.Admins (
    admin_id     INT PRIMARY KEY,
    department   NVARCHAR(255) NULL,       -- populated for gov-side admins
    badge_number NVARCHAR(100) UNIQUE NULL, -- populated for gov-side admins

    FOREIGN KEY (admin_id) REFERENCES Core.Users(user_id)
);

GO


-- ============================================
-- FILE: 04_RoleProfiles\02_Trainees.sql
-- ============================================

CREATE TABLE Roles.Trainees (
    trainee_id         INT PRIMARY KEY,
    license_type_id    INT,
    training_center_id INT,
    enrolled_at        DATE DEFAULT CAST(GETDATE() AS DATE),

    FOREIGN KEY (trainee_id)         REFERENCES Core.Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (license_type_id)    REFERENCES Lookup.LicenseTypes(license_type_id)
);

GO


-- ============================================
-- FILE: 04_RoleProfiles\03_Mentors.sql
-- ============================================

CREATE TABLE Roles.Mentors (
    mentor_id            INT PRIMARY KEY,
    training_center_id   INT,
    license_type_id      INT,
    application_id       INT  NULL,
    price_per_session    DECIMAL(10, 2),
    vehicle_type         NVARCHAR(100),
    city                 NVARCHAR(100),
    created_at           DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (mentor_id)          REFERENCES Core.Users(user_id),
    FOREIGN KEY (license_type_id)    REFERENCES Lookup.LicenseTypes(license_type_id)
);

GO


-- ============================================
-- FILE: 06_Mentor\02_MentorAvailability.sql
-- ============================================

CREATE TABLE Mentor.MentorAvailability (
    availability_id  INT PRIMARY KEY IDENTITY(1,1),
    mentor_id        INT          NOT NULL,
    day_of_week      NVARCHAR(10) NOT NULL CHECK (day_of_week IN ('sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday')),
    start_time       TIME         NOT NULL,
    end_time         TIME         NOT NULL,
    is_active        BIT          DEFAULT 1,

    CHECK (start_time < end_time),

    FOREIGN KEY (mentor_id) REFERENCES Roles.Mentors(mentor_id)
);

GO


-- ============================================
-- FILE: 06_Mentor\03_MentorApplications.sql
-- ============================================

-- =========================
-- MentorApplications (merged version)
-- =========================
CREATE TABLE Mentor.MentorApplications (
    application_id   INT PRIMARY KEY IDENTITY(1,1),
    mentor_id        INT NOT NULL,
    reviewed_by      INT NULL,

    status           NVARCHAR(20) DEFAULT 'pending'
        CHECK (status IN ('pending', 'approved', 'rejected')),

    submitted_at     DATETIME2 DEFAULT GETDATE(),
    reviewed_at      DATETIME2 NULL,
    rejection_reason NVARCHAR(500) NULL,

    -- =========================
    -- Merged document fields
    -- (previously MentorDocuments)
    -- =========================

    certification_file_path   NVARCHAR(500) NULL,

    is_certification_verified  BIT DEFAULT 0,

    certification_uploaded_at  DATETIME2 NULL,

    FOREIGN KEY (mentor_id) REFERENCES Roles.Mentors(mentor_id),
    FOREIGN KEY (reviewed_by) REFERENCES Roles.Admins(admin_id)
);
GO

GO


-- ============================================
-- FILE: 08_Scheduling\01_BlockedDates.sql
-- ============================================

CREATE TABLE Scheduling.BlockedDates (
    blocked_date_id  INT PRIMARY KEY IDENTITY(1,1),
    blocked_date     DATE          NOT NULL UNIQUE,
    reason           NVARCHAR(255),
    blocked_by       INT           NOT NULL,
    created_at       DATETIME2     DEFAULT GETDATE(),

    FOREIGN KEY (blocked_by) REFERENCES Roles.Admins(admin_id)
);

GO


-- ============================================
-- FILE: 08_Scheduling\02_Bookings.sql
-- ============================================

CREATE TABLE Scheduling.Bookings (
    booking_id       INT PRIMARY KEY IDENTITY(1,1),
    trainee_id       INT          NOT NULL,
    mentor_id        INT          NOT NULL,
    license_type_id  INT          NOT NULL,
    session_type     NVARCHAR(20) CHECK (session_type IN ('theoretical', 'practical')),
    booking_date     DATE         NOT NULL,
    start_time       TIME         NOT NULL,
    end_time         TIME         NOT NULL,
    status           NVARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
    created_at       DATETIME2    DEFAULT GETDATE(),
    updated_at       DATETIME2    DEFAULT GETDATE(),
    trainee_license_id   INT           NOT NULL,

    CHECK (start_time < end_time),

    FOREIGN KEY (trainee_id)      REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (mentor_id)       REFERENCES Roles.Mentors(mentor_id),
    FOREIGN KEY (license_type_id) REFERENCES Lookup.LicenseTypes(license_type_id),
    FOREIGN KEY (trainee_license_id) REFERENCES Core.TraineeLicenses(trainee_license_id)
);

GO


-- ============================================
-- FILE: 08_Scheduling\03_ExamAppointments.sql
-- ============================================

CREATE TABLE Scheduling.ExamAppointments (
    exam_appointment_id  INT PRIMARY KEY IDENTITY(1,1),
    trainee_id           INT          NOT NULL,
    official_exam_id     INT          NOT NULL,
    status               NVARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled', 'rescheduled')),
    created_at           DATETIME2    DEFAULT GETDATE(),
    updated_at           DATETIME2    DEFAULT GETDATE(),
    trainee_license_id   INT           NOT NULL UNIQUE,

    UNIQUE (trainee_id, official_exam_id),

    FOREIGN KEY (trainee_id)       REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (official_exam_id) REFERENCES Gov.GovOfficialExams(official_exam_id),
    FOREIGN KEY (trainee_license_id) REFERENCES Core.TraineeLicenses(trainee_license_id)
);

GO


-- ============================================
-- FILE: 07_Learning\01_LearningModules.sql
-- ============================================

CREATE TABLE Learning.LearningModules (
    module_id              INT PRIMARY KEY IDENTITY(1,1),
    license_type_id        INT           NOT NULL,
    phase                  NVARCHAR(20)  NOT NULL CHECK (phase IN ('theoretical', 'practical')),
    order_index            INT           NOT NULL,
    prerequisite_module_id INT           NULL,

    UNIQUE (license_type_id, order_index, phase),

    FOREIGN KEY (license_type_id)        REFERENCES Lookup.LicenseTypes(license_type_id),
    FOREIGN KEY (prerequisite_module_id) REFERENCES Learning.LearningModules(module_id)
);

GO


-- ============================================
-- FILE: 07_Learning\02_TraineeModuleProgress.sql
-- ============================================

CREATE TABLE Learning.TraineeModuleProgress (
    progress_id     INT PRIMARY KEY IDENTITY(1,1),
    trainee_id      INT          NOT NULL,
    module_id       INT          NOT NULL,
    trainee_license_id INT          NOT NULL,
    status          NVARCHAR(20) NOT NULL DEFAULT 'not_started'
                        CHECK (status IN ('not_started', 'in_progress', 'completed')),
    started_at      DATETIME2    NULL,
    completed_at    DATETIME2    NULL,

    UNIQUE (trainee_id, module_id, trainee_license_id),

    FOREIGN KEY (trainee_id)      REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (module_id)       REFERENCES Learning.LearningModules(module_id),
    FOREIGN KEY (trainee_license_id) REFERENCES Core.TraineeLicenses(trainee_license_id)
);

GO


-- ============================================
-- FILE: 07_Learning\03_ModuleRecommendations.sql
-- ============================================

CREATE TABLE Learning.ModuleRecommendations (
    recommendation_id  INT PRIMARY KEY IDENTITY(1,1),
    mentor_id          INT       NOT NULL,
    trainee_id         INT       NOT NULL,
    module_id          INT       NOT NULL,
    note               NVARCHAR(500),
    created_at         DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (mentor_id)  REFERENCES Roles.Mentors(mentor_id),
    FOREIGN KEY (trainee_id) REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (module_id)  REFERENCES Learning.LearningModules(module_id)
);

GO


-- ============================================
-- FILE: 07_Learning\04_Quizzes.sql
-- ============================================

CREATE TABLE Learning.Quizzes (
    quiz_id          INT PRIMARY KEY IDENTITY(1,1),
    module_id        INT           NULL,    -- NULL for mock exams
    is_mock_exam     BIT           DEFAULT 0,
    license_type_id  INT           NULL,    -- required when is_mock_exam = 1
    passing_score    INT           NOT NULL,

    FOREIGN KEY (module_id)       REFERENCES Learning.LearningModules(module_id),
    FOREIGN KEY (license_type_id) REFERENCES Lookup.LicenseTypes(license_type_id)
);

GO


-- ============================================
-- FILE: 07_Learning\05_QuizQuestions.sql
-- ============================================

CREATE TABLE Learning.QuizQuestions (
    question_id    INT PRIMARY KEY IDENTITY(1,1),
    quiz_id        INT            NOT NULL,

    FOREIGN KEY (quiz_id) REFERENCES Learning.Quizzes(quiz_id)
);

GO


-- ============================================
-- FILE: 07_Learning\06_QuestionOptions.sql
-- ============================================

CREATE TABLE Learning.QuestionOptions (
    option_id     INT PRIMARY KEY IDENTITY(1,1),
    question_id   INT            NOT NULL,
    is_correct    BIT            NOT NULL DEFAULT 0,

    FOREIGN KEY (question_id) REFERENCES Learning.QuizQuestions(question_id)
);

GO


-- ============================================
-- FILE: 07_Learning\07_QuizAttempts.sql
-- ============================================

CREATE TABLE Learning.QuizAttempts (
    attempt_id      INT PRIMARY KEY IDENTITY(1,1),
    quiz_id         INT       NOT NULL,
    trainee_id      INT       NOT NULL,
    trainee_license_id INT       NOT NULL,
    score           INT,
    passed          BIT,
    attempt_date    DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (quiz_id)         REFERENCES Learning.Quizzes(quiz_id),
    FOREIGN KEY (trainee_id)      REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (trainee_license_id) REFERENCES Core.TraineeLicenses(trainee_license_id)
);

GO


-- ============================================
-- FILE: 07_Learning\09_Ratings.sql
-- ============================================

CREATE TABLE Learning.Ratings (
    rating_id    INT PRIMARY KEY IDENTITY(1,1),
    trainee_id   INT            NOT NULL,
    mentor_id    INT            NOT NULL,
    booking_id   INT            NOT NULL UNIQUE,
    score        DECIMAL(2, 1)  NOT NULL CHECK (score BETWEEN 1.0 AND 5.0),
    review_text  NVARCHAR(1000) NULL,
    created_at   DATETIME2      DEFAULT GETDATE(),

    FOREIGN KEY (trainee_id) REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (mentor_id)  REFERENCES Roles.Mentors(mentor_id),
    FOREIGN KEY (booking_id) REFERENCES Scheduling.Bookings(booking_id)
);

GO


-- ============================================
-- FILE: 07_Learning\10_CompletionCertificates.sql
-- ============================================

CREATE TABLE Learning.CompletionCertificates (
    certificate_id    INT PRIMARY KEY IDENTITY(1,1),
    trainee_id        INT           NOT NULL,
    mentor_id         INT           NOT NULL,
    trainee_license_id   INT           NOT NULL UNIQUE,  -- one certificate per license journey
    issued_at         DATETIME2     NOT NULL DEFAULT GETDATE(),
    certificate_path  NVARCHAR(500) NULL,             -- file path if PDF is generated

    FOREIGN KEY (trainee_id)      REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (mentor_id)       REFERENCES Roles.Mentors(mentor_id),
    FOREIGN KEY (trainee_license_id) REFERENCES Core.TraineeLicenses(trainee_license_id)
);

GO


-- ============================================
-- FILE: 07_Learning\11_SessionFeedback.sql
-- ============================================

CREATE TABLE Learning.SessionFeedback (
    feedback_id   INT PRIMARY KEY IDENTITY(1,1),
    booking_id    INT          NOT NULL UNIQUE,
    trainee_id    INT          NOT NULL,
    mentor_id     INT          NOT NULL,
    mentor_notes  NVARCHAR(MAX),
    created_at    DATETIME2    DEFAULT GETDATE(),

    FOREIGN KEY (booking_id)  REFERENCES Scheduling.Bookings(booking_id),
    FOREIGN KEY (trainee_id)  REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (mentor_id)   REFERENCES Roles.Mentors(mentor_id)
);

GO


-- ============================================
-- FILE: 07_Learning\12_TrainingCenters.sql
-- ============================================

CREATE TABLE Learning.TrainingCenters (
    center_id      INT PRIMARY KEY IDENTITY(1,1),
    name           NVARCHAR(255) NOT NULL,
    province       NVARCHAR(100) NOT NULL,
    city           NVARCHAR(100) NOT NULL,
    address_line1  NVARCHAR(255) NOT NULL,
    address_line2  NVARCHAR(255),
    postal_code    NVARCHAR(20),
    phone_number   NVARCHAR(20),
    email          NVARCHAR(255) UNIQUE,
    license_number NVARCHAR(100) UNIQUE NOT NULL,
    is_active      BIT       DEFAULT 1,
    created_at     DATETIME2 DEFAULT GETDATE()
);

GO


-- ============================================
-- FILE: 07_Learning\13_ModuleContents.sql
-- ============================================

CREATE TABLE Learning.ModuleContents (
    content_id   INT PRIMARY KEY IDENTITY(1,1),
    module_id    INT NOT NULL,
    content_type NVARCHAR(20) CHECK (content_type IN ('video', 'text')),
    
    video_url    NVARCHAR(500) NULL,

    FOREIGN KEY (module_id) REFERENCES Learning.LearningModules(module_id)
);

GO


-- ============================================
-- FILE: 07_Learning\14_ModuleTranslations.sql
-- ============================================

CREATE TABLE Learning.ModuleTranslations (
    module_translation_id INT PRIMARY KEY IDENTITY,
    module_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL, -- 'en', 'ar'

    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(500),

    UNIQUE (module_id, language_code),

    FOREIGN KEY (module_id) REFERENCES Learning.LearningModules(module_id)
);

GO


-- ============================================
-- FILE: 07_Learning\15_ModuleContentsTranslation.sql
-- ============================================

CREATE TABLE Learning.ModuleContentTranslations (
    content_translation_id INT PRIMARY KEY IDENTITY,
    content_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    text_content NVARCHAR(MAX),

    UNIQUE (content_id, language_code),

    FOREIGN KEY (content_id) REFERENCES Learning.ModuleContents(content_id)
);

GO


-- ============================================
-- FILE: 07_Learning\16_QuizTranslations.sql
-- ============================================

CREATE TABLE Learning.QuizTranslations (
    quiz_translation_id INT PRIMARY KEY IDENTITY,
    quiz_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    title NVARCHAR(255) NOT NULL,

    UNIQUE (quiz_id, language_code),

    FOREIGN KEY (quiz_id) REFERENCES Learning.Quizzes(quiz_id)
);

GO


-- ============================================
-- FILE: 07_Learning\17_QuestionTranslations.sql
-- ============================================

CREATE TABLE Learning.QuestionTranslations (
    question_translation_id INT PRIMARY KEY IDENTITY,
    question_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    question_text NVARCHAR(1000) NOT NULL,

    UNIQUE (question_id, language_code),

    FOREIGN KEY (question_id) REFERENCES Learning.QuizQuestions(question_id)
);

GO


-- ============================================
-- FILE: 07_Learning\18_OptionTranslations.sql
-- ============================================

CREATE TABLE Learning.OptionTranslations (
    option_translation_id INT PRIMARY KEY IDENTITY,
    option_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    option_text NVARCHAR(500) NOT NULL,

    UNIQUE (option_id, language_code),

    FOREIGN KEY (option_id) REFERENCES Learning.QuestionOptions(option_id)
);

GO


-- ============================================
-- FILE: 09_Messaging\01_Conversations.sql
-- ============================================

CREATE TABLE Messaging.Conversations (
    conversation_id INT       PRIMARY KEY IDENTITY(1,1),
    trainee_id      INT       NOT NULL,
    mentor_id       INT       NOT NULL,
    booking_id      INT       NOT NULL UNIQUE,
    created_at      DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (trainee_id) REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (mentor_id)  REFERENCES Roles.Mentors(mentor_id),
    FOREIGN KEY (booking_id) REFERENCES Scheduling.Bookings(booking_id)
);

GO


-- ============================================
-- FILE: 09_Messaging\02_Messages.sql
-- ============================================

CREATE TABLE Messaging.Messages (
    message_id       INT PRIMARY KEY IDENTITY(1,1),
    conversation_id  INT          NOT NULL,
    sender_id        INT          NOT NULL,
    message_text     NVARCHAR(MAX),
    is_read          BIT          DEFAULT 0,
    sent_at          DATETIME2    DEFAULT GETDATE(),

    FOREIGN KEY (conversation_id)
        REFERENCES Messaging.Conversations(conversation_id)
        ON DELETE CASCADE,
    FOREIGN KEY (sender_id)       REFERENCES Core.Users(user_id)
);

GO


-- ============================================
-- FILE: 09_Messaging\03_ConversationAttachments.sql
-- ============================================

CREATE TABLE Messaging.ConversationAttachments (
    attachment_id    INT PRIMARY KEY IDENTITY(1,1),
    conversation_id  INT NOT NULL,
    message_id       INT NULL,  -- optional: attach to specific message

    uploaded_by      INT NOT NULL, -- user who sent file
    file_name        NVARCHAR(255) NOT NULL,
    file_path        NVARCHAR(500) NOT NULL,
    file_type        NVARCHAR(10) CHECK (file_type IN ('pdf', 'image', 'other')),
    uploaded_at      DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (conversation_id)
        REFERENCES Messaging.Conversations(conversation_id)
        ON DELETE CASCADE,

    FOREIGN KEY (uploaded_by)
        REFERENCES Core.Users(user_id)
);
GO

GO


-- ============================================
-- FILE: 10_AI\01_AIChatSessions.sql
-- ============================================

CREATE TABLE AI.AIChatSessions (
    session_id  INT PRIMARY KEY IDENTITY(1,1),
    user_id     INT       NOT NULL,
    created_at  DATETIME2 DEFAULT GETDATE(),
    ended_at    DATETIME2 NULL,

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id)
);

GO


-- ============================================
-- FILE: 10_AI\02_AIChatMessages.sql
-- ============================================

CREATE TABLE AI.AIChatMessages (
    message_id  INT PRIMARY KEY IDENTITY(1,1),
    session_id  INT           NOT NULL,
    role        NVARCHAR(10)  NOT NULL CHECK (role IN ('user', 'assistant')),
    content     NVARCHAR(MAX) NOT NULL,
    sent_at     DATETIME2     DEFAULT GETDATE(),

    FOREIGN KEY (session_id) REFERENCES AI.AIChatSessions(session_id)
);

GO


-- ============================================
-- FILE: 11_Notifications\01_Notifications.sql
-- ============================================

CREATE TABLE Notifications.Notifications (
    notification_id  INT PRIMARY KEY IDENTITY(1,1),
    user_id          INT          NOT NULL,
    title            NVARCHAR(MAX),
    message          NVARCHAR(MAX),
    type             NVARCHAR(50) NOT NULL
                         CHECK (type IN ('appointment', 'exam', 'booking', 'quiz', 'material', 'certificate', 'system', 'feedback')),
    channel          NVARCHAR(10) NOT NULL DEFAULT 'app'
                         CHECK (channel IN ('app', 'email', 'sms')),
    is_read          BIT          NOT NULL DEFAULT 0,
    created_at       DATETIME2    DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id)
);

GO


-- ============================================
-- FILE: 11_Notifications\02_NotificationPreferences.sql
-- ============================================

CREATE TABLE Notifications.NotificationPreferences (
    user_id INT PRIMARY KEY,
    prefers_email BIT NOT NULL DEFAULT 1,
    prefers_sms   BIT NOT NULL DEFAULT 0,
    prefers_app   BIT NOT NULL DEFAULT 1,
    reminder_hours_before INT NOT NULL DEFAULT 24,

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id)
        ON DELETE CASCADE
);

GO


-- ============================================
-- FILE: 12_Security\01_PasswordResetTokens.sql
-- ============================================

CREATE TABLE SecurityPasswordResetTokens (
    token_id    INT PRIMARY KEY IDENTITY(1,1),
    user_id     INT           NOT NULL,
    token       NVARCHAR(255) UNIQUE NOT NULL,
    expires_at  DATETIME2     NOT NULL,
    used        BIT           DEFAULT 0,
    created_at  DATETIME2     DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id)
);

GO


-- ============================================
-- FILE: 12_Security\02_AuditLogs.sql
-- ============================================

CREATE TABLE Security.AuditLogs (
    log_id        INT PRIMARY KEY IDENTITY(1,1),
    user_id       INT            NOT NULL,
    action        NVARCHAR(255)  NOT NULL,
    table_name    NVARCHAR(100),
    record_id     NVARCHAR(50),   
    performed_at  DATETIME2      DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id)
);

GO


-- ============================================
-- FILE: 13_Indexes\01_Indexes.sql
-- ============================================

-- ============================================================
-- DEFINE INDEXES
-- ============================================================

-- Users
CREATE INDEX idx_users_email ON Core.Users(email);
CREATE INDEX idx_users_national_id ON Core.Users(national_id);

-- Bookings
CREATE INDEX idx_bookings_mentor_id ON Scheduling.Bookings(mentor_id);
CREATE INDEX idx_bookings_trainee_id ON Scheduling.Bookings(trainee_id);

-- Exams
CREATE INDEX idx_examappointments_trainee_id ON Scheduling.ExamAppointments(trainee_id);

-- Messages
CREATE INDEX idx_messages_conversation_id ON Messaging.Messages(conversation_id);

-- Notifications
CREATE INDEX idx_notifications_user_id ON Notifications.Notifications(user_id);

-- Quiz Questions
CREATE INDEX idx_quizquestions_quiz_id ON Learning.QuizQuestions(quiz_id);

GO


-- ============================================
-- FILE: 05_FK_Patches\01_GovOfficialExams_AdminFK.sql
-- ============================================

-- ============================================
-- FK PATCH: GovOfficialExams → Admins
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_GovOfficialExams_Admins'
)
BEGIN
    ALTER TABLE Gov.GovOfficialExams
    ADD CONSTRAINT FK_GovOfficialExams_Admins
    FOREIGN KEY (created_by)
    REFERENCES Roles.Admins(admin_id);
END
GO

GO


-- ============================================
-- FILE: 05_FK_Patches\02_GovExamResults_AdminFK.sql
-- ============================================

-- ============================================
-- FK PATCH: GovExamResults → Admins
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_GovExamResults_Admins'
)
BEGIN
    ALTER TABLE Gov.GovExamResults
    ADD CONSTRAINT FK_GovExamResults_Admins
    FOREIGN KEY (recorded_by)
    REFERENCES Roles.Admins(admin_id);
END
GO

GO


-- ============================================
-- FILE: 05_FK_Patches\03_Trainees_TrainingCenterFK.sql
-- ============================================

-- ============================================
-- FK PATCH: Trainees → TrainingCenters
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Trainees_TrainingCenters'
)
BEGIN
    ALTER TABLE Roles.Trainees
    ADD CONSTRAINT FK_Trainees_TrainingCenters
    FOREIGN KEY (training_center_id)
    REFERENCES Learning.TrainingCenters(center_id);
END
GO

GO


-- ============================================
-- FILE: 05_FK_Patches\04_Mentors_TrainingCenterFK.sql
-- ============================================

-- ============================================
-- FK PATCH: Mentors → TrainingCenters
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Mentors_TrainingCenters'
)
BEGIN
    ALTER TABLE Roles.Mentors
    ADD CONSTRAINT FK_Mentors_TrainingCenters
    FOREIGN KEY (training_center_id)
    REFERENCES Learning.TrainingCenters(center_id);
END
GO

GO


-- ============================================
-- FILE: 05_FK_Patches\05_Mentors_MentorApplicationsFK.sql
-- ============================================

-- ============================================
-- FK PATCH: Mentors → MentorApplications
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Mentors_MentorApplications'
)
BEGIN
    ALTER TABLE Roles.Mentors
    ADD CONSTRAINT FK_Mentors_MentorApplications
    FOREIGN KEY (application_id)
    REFERENCES Mentor.MentorApplications(application_id);
END
GO

GO


-- ============================================
-- FILE: 05_FK_Patches\06_TraineeLicenses_TraineesFK.sql
-- ============================================

-- ============================================
-- FK PATCH: TraineeLicenses → Trainees
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_TraineeLicenses_Trainees'
)
BEGIN
    ALTER TABLE Core.TraineeLicenses
    ADD CONSTRAINT FK_TraineeLicenses_Trainees
    FOREIGN KEY (trainee_id)
    REFERENCES Roles.Trainees(trainee_id);
END
GO

GO


-- ============================================
-- FILE: 05_FK_Patches\07_TraineeLicenses_MentorsFK.sql
-- ============================================

-- ============================================
-- FK PATCH: TraineeLicenses → Mentors
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_TraineeLicenses_Mentors'
)
BEGIN
    ALTER TABLE Core.TraineeLicenses
    ADD CONSTRAINT FK_TraineeLicenses_Mentors
    FOREIGN KEY (mentor_id)
    REFERENCES Roles.Mentors(mentor_id);
END
GO

GO

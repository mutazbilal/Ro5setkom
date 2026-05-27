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
-- FILE: 01_Lookups\03_Provinces.sql
-- ============================================

CREATE TABLE Lookup.Provinces (
    province_id INT PRIMARY KEY IDENTITY(1,1),

    province_key NVARCHAR(50) NOT NULL UNIQUE
);

GO


-- ============================================
-- FILE: 01_Lookups\04_ProvinceTranslations.sql
-- ============================================

CREATE TABLE Lookup.ProvinceTranslations (
    province_translation_id INT PRIMARY KEY IDENTITY(1,1),

    province_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    display_name NVARCHAR(100) NOT NULL,

    UNIQUE (province_id, language_code),

    FOREIGN KEY (province_id)
        REFERENCES Lookup.Provinces(province_id)
        ON DELETE CASCADE
);

GO


-- ============================================
-- FILE: 01_Lookups\05_Cities.sql
-- ============================================

CREATE TABLE Lookup.Cities (
    city_id INT PRIMARY KEY IDENTITY(1,1),

    province_id INT NOT NULL,

    city_key NVARCHAR(100) NOT NULL,

    UNIQUE (province_id, city_key),

    FOREIGN KEY (province_id)
        REFERENCES Lookup.Provinces(province_id)
);

GO


-- ============================================
-- FILE: 01_Lookups\06_CityTranslations.sql
-- ============================================

CREATE TABLE Lookup.CityTranslations (
    city_translation_id INT PRIMARY KEY IDENTITY(1,1),

    city_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    display_name NVARCHAR(100) NOT NULL,

    UNIQUE (city_id, language_code),

    FOREIGN KEY (city_id)
        REFERENCES Lookup.Cities(city_id)
        ON DELETE CASCADE
);

GO


-- ============================================
-- FILE: 02_Government\01_GovCitizens.sql
-- ============================================

CREATE TABLE Gov.GovCitizens (
    national_id     NVARCHAR(10)  PRIMARY KEY,

    first_name      NVARCHAR(100) NOT NULL,
    last_name       NVARCHAR(100) NOT NULL,

    date_of_birth   DATE          NOT NULL,

    gender          NVARCHAR(10)
        NOT NULL
        CHECK (gender IN ('male', 'female')),

    province_id     INT NOT NULL,
    city_id         INT NOT NULL,

    address_line1   NVARCHAR(255) NOT NULL,
    address_line2   NVARCHAR(255),

    postal_code     NVARCHAR(20),

    is_eligible     BIT DEFAULT 1,

    created_at      DATETIME2 DEFAULT GETDATE(),
    updated_at      DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (province_id)
        REFERENCES Lookup.Provinces(province_id),

    FOREIGN KEY (city_id)
        REFERENCES Lookup.Cities(city_id)
);

GO


-- ============================================
-- FILE: 02_Government\02_GovExamCenters.sql
-- ============================================

-- Official exam centers where theory, medical, and practical tests are held
CREATE TABLE Gov.GovExamCenters (
    center_id       INT PRIMARY KEY IDENTITY(1,1),

    name            NVARCHAR(255) NOT NULL, -- optional fallback/internal name

    province_id     INT NOT NULL,
    city_id         INT NOT NULL,

    address_line1   NVARCHAR(255) NOT NULL,
    address_line2   NVARCHAR(255),

    postal_code     NVARCHAR(20),
    phone_number    NVARCHAR(20),

    is_active       BIT DEFAULT 1,

    FOREIGN KEY (province_id)
        REFERENCES Lookup.Provinces(province_id),

    FOREIGN KEY (city_id)
        REFERENCES Lookup.Cities(city_id)
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
    province_id         INT NOT NULL,
    city_id             INT NOT NULL,
    address_line1       NVARCHAR(255) NOT NULL,
    address_line2       NVARCHAR(255),
    postal_code         NVARCHAR(20),
    password_hash       NVARCHAR(255) NOT NULL,
    profile_picture_path     NVARCHAR(500),
    language_preference NVARCHAR(5)   DEFAULT 'ar' CHECK (language_preference IN ('ar', 'en')),
    is_active           BIT           DEFAULT 1,
    created_at          DATETIME2     DEFAULT GETDATE(),
    updated_at          DATETIME2     DEFAULT GETDATE(),

    FOREIGN KEY (role_id)     REFERENCES Lookup.Roles(role_id),
    FOREIGN KEY (national_id) REFERENCES Gov.GovCitizens(national_id),  -- identity must exist in gov registry

    FOREIGN KEY (province_id) REFERENCES Lookup.Provinces(province_id),
    FOREIGN KEY (city_id) REFERENCES Lookup.Cities(city_id)
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
    city_id              INT,
    created_at           DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (mentor_id)          REFERENCES Core.Users(user_id),
    FOREIGN KEY (license_type_id)    REFERENCES Lookup.LicenseTypes(license_type_id),

    FOREIGN KEY (city_id)
    REFERENCES Lookup.Cities(city_id)
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
    trainee_license_id INT          NULL,
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

    display_name_en NVARCHAR(255) NOT NULL,
    display_name_ar NVARCHAR(255) NOT NULL,

    province_id    INT NOT NULL,
    city_id        INT NOT NULL,

    address_line1  NVARCHAR(255) NOT NULL,
    address_line2  NVARCHAR(255),

    postal_code    NVARCHAR(20),
    phone_number   NVARCHAR(20),
    email          NVARCHAR(255) UNIQUE,

    license_number NVARCHAR(100) UNIQUE NOT NULL,

    is_active      BIT DEFAULT 1,
    created_at     DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (province_id)
        REFERENCES Lookup.Provinces(province_id),

    FOREIGN KEY (city_id)
        REFERENCES Lookup.Cities(city_id)
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


-- ============================================
-- DATABASE SEED SCRIPT
-- AUTO GENERATED
-- ============================================


-- ============================================
-- FILE: 14_Seeds\10_Provinces_Cties.sql
-- ============================================

INSERT INTO Lookup.Provinces (province_key)
VALUES
('amman'),
('zarqa'),
('irbid'),
('aqaba'),
('mafraq');

INSERT INTO Lookup.ProvinceTranslations (province_id, language_code, display_name)
VALUES
-- Amman
(1, 'en', N'Amman'),
(1, 'ar', N'عمّان'),

-- Zarqa
(2, 'en', N'Zarqa'),
(2, 'ar', N'الزرقاء'),

-- Irbid
(3, 'en', N'Irbid'),
(3, 'ar', N'إربد'),

-- Aqaba
(4, 'en', N'Aqaba'),
(4, 'ar', N'العقبة'),

-- Mafraq
(5, 'en', N'Mafraq'),
(5, 'ar', N'المفرق');

INSERT INTO Lookup.Cities (province_id, city_key)
VALUES
-- Amman
(1, 'marj_al_hammam'),
(1, 'tlaa_al_ali'),
(1, 'tabarbour'),

-- Zarqa
(2, 'russeifa'),
(2, 'zarqa_city'),

-- Irbid
(3, 'ramtha'),

-- Aqaba
(4, 'aqaba_city'),

-- Mafraq
(5, 'mafraq_city');


INSERT INTO Lookup.CityTranslations (city_id, language_code, display_name)
VALUES
-- Amman
(1, 'en', N'Marj Al-Hammam'),
(1, 'ar', N'مرج الحمام'),

(2, 'en', N'Tlaa Al-Ali'),
(2, 'ar', N'تلاع العلي'),

(3, 'en', N'Tabarbour'),
(3, 'ar', N'طبربور'),

-- Zarqa
(4, 'en', N'Russeifa'),
(4, 'ar', N'الرصيفة'),

(5, 'en', N'Zarqa City'),
(5, 'ar', N'مدينة الزرقاء'),

-- Irbid
(6, 'en', N'Ramtha'),
(6, 'ar', N'الرمثا'),

-- Aqaba
(7, 'en', N'Aqaba City'),
(7, 'ar', N'مدينة العقبة'),

-- Mafraq
(8, 'en', N'Mafraq City'),
(8, 'ar', N'مدينة المفرق');

GO


-- ============================================
-- FILE: 14_Seeds\01_Roles.sql
-- ============================================

INSERT INTO Lookup.Roles (role_name) VALUES
    ('trainee'),
    ('mentor'),
    ('admin');

GO


-- ============================================
-- FILE: 14_Seeds\02_LicenseTypes.sql
-- ============================================

INSERT INTO Lookup.LicenseTypes (license_name, display_name_en, display_name_ar, description_en, description_ar) VALUES
    ('private_automatic', 'Private Car (Automatic)', N'سيارة خاصة (أوتوماتيك)', 'Private car with automatic transmission',        N'سيارة خاصة ذات ناقل حركة أوتوماتيكي'),
    ('private_manual',    'Private Car (Manual)',    N'سيارة خاصة (يدوي)',      'Private car with manual transmission',           N'سيارة خاصة ذات ناقل حركة يدوي'),
    ('motorcycle',        'Motorcycle',              N'دراجة نارية',            'Two-wheel motorcycle license',                   N'رخصة دراجة نارية ذات عجلتين');

GO


-- ============================================
-- FILE: 14_Seeds\03_seed_modules.sql
-- ============================================

-- =============================================
-- Auto-generated seed file — modules
-- =============================================

-- LearningModules (base)
SET IDENTITY_INSERT Learning.LearningModules ON;
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (1, 1, 'theoretical', 1, NULL);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (2, 1, 'theoretical', 2, 1);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (3, 1, 'theoretical', 3, 2);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (4, 1, 'theoretical', 4, 3);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (5, 1, 'theoretical', 5, 4);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (6, 1, 'theoretical', 6, 5);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (7, 1, 'theoretical', 7, 1);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (8, 1, 'theoretical', 8, 6);
SET IDENTITY_INSERT Learning.LearningModules OFF;

-- ModuleTranslations
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (1, 'en', N'Introduction to Driving Responsibilities and Legal Framework', N'Comprehensive overview of driver responsibilities, legal requirements, license categories, medical fitness, and the examination process in Jordan');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (1, 'ar', N'مقدمة لمسؤوليات القيادة والإطار القانوني', N'نظرة شاملة عن مسؤوليات السائق، والمتطلبات القانونية، وفئات الترخيص، واللياقة الطبية، وعملية الفحص في الأردن');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (2, 'en', N'Road Markings: Lines, Symbols, and Their Meanings', N'Complete guide to understanding mandatory lines, warning lines, pedestrian crossings, lane arrows, and road symbols');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (2, 'ar', N'علامات الطريق: الخطوط والرموز ومعانيها', N'الدليل الكامل لفهم الخطوط الإلزامية، وخطوط التحذير، ومعابر المشاة، وسهام الحارات، ورموز الطريق');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (3, 'en', N'Traffic Signs Complete Guide – Warning, Priority, Prohibition, and Mandatory Signs', N'Comprehensive coverage of all traffic sign categories with shapes, colors, meanings, and proper responses');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (3, 'ar', N'الدليل الكامل لإشارات المرور - الإشارات التحذيرية والأولوية والحظر والإشارات الإلزامية', N'تغطية شاملة لجميع فئات إشارات المرور بالأشكال والألوان والمعاني والاستجابات المناسبة');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (4, 'en', N'Right-of-Way Rules at Intersections and Roundabouts', N'Complete guide to priority rules including right-hand rule, main road authority, roundabout navigation, T-junctions, and emergency vehicles');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (4, 'ar', N'قواعد حق الطريق عند التقاطعات والدوارات', N'دليل كامل لقواعد الأولوية بما في ذلك قاعدة اليد اليمنى، وسلطة الطريق الرئيسية، والملاحة الدائرية، وتقاطعات T، ومركبات الطوارئ');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (5, 'en', N'Lane Discipline, Turning, and Overtaking', N'Proper lane positioning, turning procedures at intersections, U-turn rules, roundabout navigation, and safe overtaking techniques');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (5, 'ar', N'الانضباط في المسار، والانعطاف، والتجاوز', N'تحديد موقع المسار الصحيح، وإجراءات الانعطاف عند التقاطعات، وقواعد الدوران على شكل حرف U، والملاحة في الدوارات، وتقنيات التجاوز الآمنة');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (6, 'en', N'Speed Limits, Following Distance, and Stopping Safely', N'Maximum and minimum speed limits by road type, two-second and three-second following rules, stopping distances, and emergency braking');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (6, 'ar', N'حدود السرعة ومسافة التتبع والتوقف الآمن', N'حدود السرعة القصوى والدنيا حسب نوع الطريق، وقواعد اتباع الثانية والثلاث ثواني، ومسافات التوقف، وفرامل الطوارئ');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (7, 'en', N'Alcohol, Drugs, Fatigue, and Safe Driving Fitness', N'Effects of alcohol, medications, and fatigue on driving ability; legal consequences; and concentration techniques');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (7, 'ar', N'الكحول والمخدرات والتعب ولياقة القيادة الآمنة', N'آثار الكحول والأدوية والتعب على القدرة على القيادة. العواقب القانونية؛ وتقنيات التركيز');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (8, 'en', N'Difficult Driving Conditions – Night, Weather, and Emergencies', N'Techniques for driving safely at night, in fog, rain, snow, ice, strong wind, and managing skids and emergencies');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (8, 'ar', N'ظروف القيادة الصعبة - الليل والطقس وحالات الطوارئ', N'تقنيات القيادة بأمان ليلاً، في الضباب والمطر والثلج والجليد والرياح القوية، وإدارة الانزلاقات وحالات الطوارئ');

-- ModuleContents (base)
SET IDENTITY_INSERT Learning.ModuleContents ON;
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (1, 1, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (2, 2, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (3, 3, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (4, 4, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (5, 5, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (6, 6, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (7, 7, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (8, 8, 'text', NULL);
SET IDENTITY_INSERT Learning.ModuleContents OFF;

-- ModuleContentTranslations
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (1, 'en', N'# Introduction to Driving Responsibilities and Legal Framework

## Section 1: Legal and Personal Responsibilities

Driving is a privilege, not a right. When you get behind the wheel, you accept legal and moral responsibility for yourself, your passengers, and everyone else on the road.

### Required Documents
- No person may drive any vehicle in Jordan without a valid, lawful driving license authorizing them to drive that specific vehicle category.
- Drivers must always carry their driving license, vehicle license (vehicle registration), and valid insurance documents.
- You must present these documents to any traffic officer upon request. Failure to do so is a violation.

### Basic Safety Principles
- Driving is a skill that requires full attention, respect for laws, and consideration for all other road users including pedestrians, cyclists, and motorcyclists.
- The general rule of right-of-way is fundamental: **priority is given, not taken**. Never assume another driver will yield to you even when you have the legal right-of-way.
- Always drive in a way that avoids endangering yourself or others. Defensive driving means anticipating what other road users might do wrong.

### Consequences of Violations
- Traffic violations lead to fines, imprisonment, license suspension, or impoundment of the vehicle depending on severity.
- Jordan operates a points system for driving violations. Accumulating points can result in license suspension or revocation.
- Repeated violations demonstrate unfitness to drive and carry progressively harsher penalties.

## Section 2: Fitness to Drive

### Physical Fitness
- You must be physically and mentally fit to drive at all times.
- Medical fitness is determined through an official medical examination that tests vision, limb health, and general health.
- Minimum vision requirement for most private licenses: 6/9 in the better eye with or without corrective lenses.
- For one-eyed applicants: The healthy eye must have vision of at least 6/9.

{{img:eye_examination}}

### Mental and Emotional Fitness
- Do not drive if you are tired, emotional (angry, upset, extremely excited), or under the influence of any substance that impairs judgment.
- Emotional driving leads to aggressive behavior, poor decision-making, and increased risk-taking.
- Good driving is a combination of technical skill, knowledge of laws, and ethical behavior toward all road users.

### Medical Conditions Requiring Special Consideration
- Certain medical conditions such as epilepsy, diabetes (with risk of hypoglycemia), heart conditions, or sleep disorders may require medical clearance or restrict driving privileges.
- Always disclose relevant medical conditions during your license application.

## Section 3: Jordanian License Categories (Feras)

Jordan uses a category system (called "Feras" in Arabic) to classify different types of driving licenses.

| Category | Vehicle Type | Minimum Age |
|----------|--------------|--------------|
| 1 | Motorcycle / Scooter | 18 years |
| 2 | Agricultural vehicle | 18 years |
| 3 | Private car (manual or automatic), up to 5 tons | 18 years |
| 4 | Public passenger car / vehicle up to 7.5 tons | 21 years |
| 5 | Medium bus / vehicle over 7.5 tons | (Requires 2 years after previous category) |
| 6 | Tractor + trailer / heavy bus | (Requires 2 years after previous category) |
| 7 | Vehicles for people with disabilities | 18 years |

### Important Upgrade Rules
- Category 4 requires at least 1 year holding Category 3 (manual transmission license).
- Categories 5 and 6 require a minimum of 2 years after obtaining the previous category.
- Driving a vehicle that requires a higher category than your license permits is a serious violation with severe penalties.

## Section 4: Obtaining Your License – The Three-Step Process

### Step 1: Medical Examination
- Visit an approved medical center for a comprehensive driving fitness examination.
- Tests include vision, color perception (to distinguish traffic lights), hearing, limb mobility, and general health screening.
- The medical certificate is valid for a limited time and must be submitted with your application.

### Step 2: Theoretical Examination
- Tests your knowledge of traffic rules, right-of-way priorities, proper driving etiquette, basic vehicle maintenance, first aid, and traffic sign recognition.
- The test is typically computer-based with multiple-choice questions.
- If you fail, you may retake the exam after one week. There may be a limit on retakes within a specific period.

{{img:computer-based-theoratical-exam}}

### Step 3: Practical Driving Examination
- Scheduled within one week after passing the theoretical test (subject to availability).
- A licensed examiner rides with you and evaluates your driving skills on public roads or a closed course.
- You must provide a suitable vehicle for the test (from a driving school or your own properly registered vehicle).

#### Practical Test Components:
- Vehicle preparation and pre-drive checks
- Proper startup procedure
- Moving off smoothly and safely
- Interacting with traffic appropriately
- Obeying all traffic signs and road markings
- Demonstrating correct priority rules at intersections
- Safe overtaking and meeting oncoming traffic
- Reversing in a straight line and around a corner
- Proper turning technique at junctions
- Correct gear selection and usage (manual transmission)
- Navigating curves and bends
- Normal stop and emergency stop
- Overall control, attention, and reaction time

### If You Fail the Practical Test
- You receive a written notice explaining the specific errors you made.
- You must wait at least two weeks before retaking the test.
- You may practice at a recognized training center during this waiting period.
- Common reasons for failure include: failing to check mirrors, incorrect positioning at junctions, poor clutch control (manual), not observing blind spots, or creating a dangerous situation.

### If Your Driving Poses an Immediate Danger
- The examiner has the authority to stop the test immediately.
- This results in an automatic failure and may require additional training before your next attempt.

## Section 5: Required Documents for License Application

When applying for a new driving license, prepare the following:

1. Official application form (obtained from licensing department or downloaded online)
2. Three recent color photographs (6×4 cm) with white or light blue background
3. Civil ID card or passport showing your national number
4. Proof of age (birth certificate or national ID)
5. Training completion certificate (for practical and theoretical training – required for all categories except 1 and 2)
6. Valid medical examination certificate
7. Fee payment receipt

### License Renewal and Replacement
- **Renewal:** Requires the same documents as a new application plus your expired license. Renew before the expiration date to avoid penalties.
- **Replacement for lost/damaged license:** Requires a special lost license form, new photographs, your ID, and the damaged license (if any). A police report may be required for lost licenses.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (1, 'ar', N'# مقدمة لمسؤوليات القيادة والإطار القانوني

## القسم الأول: المسؤوليات القانونية والشخصية

القيادة امتياز وليست حق. عندما تجلس خلف عجلة القيادة، فإنك تقبل المسؤولية القانونية والأخلاقية تجاه نفسك وتجاه الركاب وكل شخص آخر على الطريق.

### المستندات المطلوبة
- لا يجوز لأي شخص قيادة أي مركبة في الأردن دون الحصول على رخصة قيادة قانونية سارية المفعول تخوله قيادة تلك الفئة المحددة من المركبات.
- يجب على السائقين دائمًا حمل رخصة القيادة الخاصة بهم، ورخصة السيارة (تسجيل السيارة)، ووثائق التأمين الصالحة.
- يجب عليك تقديم هذه المستندات إلى أي ضابط مرور عند الطلب. عدم القيام بذلك يعد انتهاكا.

### مبادئ السلامة الأساسية
- القيادة مهارة تتطلب الاهتمام الكامل واحترام القوانين ومراعاة جميع مستخدمي الطريق الآخرين بما في ذلك المشاة وراكبي الدراجات والدراجات النارية.
- القاعدة العامة لحق الطريق أساسية: **الأولوية تعطى ولا تؤخذ**. لا تفترض أبدًا أن سائقًا آخر سوف يستسلم لك حتى عندما يكون لديك حق المرور القانوني.
- قم دائمًا بالقيادة بطريقة تتجنب تعريض نفسك أو الآخرين للخطر. القيادة الدفاعية تعني توقع الأخطاء التي قد يرتكبها مستخدمو الطريق الآخرون.

### عواقب المخالفات
- المخالفات المرورية تؤدي إلى غرامات أو سجن أو إيقاف الترخيص أو حجز المركبة حسب خطورتها.
- الأردن يطبق نظام النقاط لمخالفات القيادة. يمكن أن يؤدي تجميع النقاط إلى تعليق الترخيص أو إلغائه.
- المخالفات المتكررة تثبت عدم اللياقة للقيادة وتؤدي إلى فرض عقوبات أشد صرامة.

## القسم الثاني: اللياقة للقيادة

### اللياقة البدنية
- يجب أن تكون لائقًا بدنيًا وعقليًا للقيادة في جميع الأوقات.
- يتم تحديد اللياقة الطبية من خلال فحص طبي رسمي يفحص الرؤية وصحة الأطراف والصحة العامة.
- الحد الأدنى لمتطلبات الرؤية لمعظم الرخص الخاصة: 6/9 في العين الأفضل مع أو بدون عدسات تصحيحية.
- للمتقدمين أعور: يجب أن تتمتع العين السليمة برؤية لا تقل عن 6/9.

{{img:eye_examination}}

### اللياقة العقلية والعاطفية
- لا تقود السيارة إذا كنت متعباً، أو منفعلاً (غاضباً، منزعجاً، متحمساً للغاية)، أو تحت تأثير أي مادة تضعف القدرة على الحكم.
- القيادة العاطفية تؤدي إلى السلوك العدواني، وسوء اتخاذ القرار، وزيادة المخاطرة.
- القيادة الجيدة هي مزيج من المهارة الفنية ومعرفة القوانين والسلوك الأخلاقي تجاه جميع مستخدمي الطريق.

### الحالات الطبية التي تتطلب عناية خاصة
- بعض الحالات الطبية مثل الصرع أو مرض السكري (مع خطر نقص السكر في الدم) أو أمراض القلب أو اضطرابات النوم قد تتطلب تصريحًا طبيًا أو تقييد امتيازات القيادة.
- قم دائمًا بالكشف عن الحالات الطبية ذات الصلة أثناء طلب الترخيص الخاص بك.

## القسم الثالث: فئات الرخصة الأردنية (فراس)

يستخدم الأردن نظام الفئات (يسمى "فراس" باللغة العربية) لتصنيف أنواع مختلفة من رخص القيادة.

| الفئة | نوع المركبة | الحد الأدنى للعمر |
|----------|--------------|--------------|
| 1 | دراجة نارية / سكوتر | 18 سنة |
| 2 | مركبة زراعية | 18 سنة |
| 3 | سيارة خاصة (يدوية أو أوتوماتيكية) حتى 5 طن | 18 سنة |
| 4 | سيارة / مركبة ركاب عامة تصل إلى 7.5 طن | 21 سنة |
| 5 | حافلة / مركبة متوسطة تزيد عن 7.5 طن | (يتطلب عامين بعد الفئة السابقة) |
| 6 | تراكتور + مقطورة / باص ثقيل | (يتطلب عامين بعد الفئة السابقة) |
| 7 | مركبات للأشخاص ذوي الإعاقة | 18 سنة |

### قواعد الترقية الهامة
- تتطلب الفئة 4 امتلاك الفئة 3 (رخصة النقل اليدوي) لمدة عام على الأقل.
- الفئتان 5 و 6 تتطلب مرور سنتين على الأقل بعد الحصول على الفئة السابقة.
- قيادة مركبة تتطلب فئة أعلى مما تسمح به رخصتك يعد انتهاكًا خطيرًا يعاقب عليه بعقوبات صارمة.

## القسم 4: الحصول على الترخيص الخاص بك - العملية المكونة من ثلاث خطوات

### الخطوة الأولى: الفحص الطبي
- زيارة أحد المراكز الطبية المعتمدة لإجراء فحص شامل للياقة القيادة.
- تشمل الاختبارات الرؤية وإدراك الألوان (لتمييز إشارات المرور) والسمع وحركة الأطراف وفحص الصحة العامة.
- الشهادة الطبية صالحة لفترة محدودة ويجب تقديمها مع طلبك.

### الخطوة الثانية: الاختبار النظري

- يختبر هذا الاختبار معرفتك بقواعد المرور، وأولويات حق المرور، وآداب القيادة السليمة، والصيانة الأساسية للمركبات، والإسعافات الأولية، والتعرف على إشارات المرور.
- عادةً ما يكون الاختبار إلكترونيًا ويتضمن أسئلة اختيار من متعدد.
- في حال عدم اجتيازك الاختبار، يمكنك إعادته بعد أسبوع. قد يكون هناك حد أقصى لعدد مرات إعادة الاختبار خلال فترة محددة.

{{img:computer-based-theoratical-exam}}

### الخطوة 3: امتحان القيادة العملي
- يحدد موعده خلال أسبوع واحد بعد اجتياز الاختبار النظري (حسب توفره).
- يرافقك فاحص ترخيص ويقيم مهاراتك في القيادة على الطرق العامة أو المسار المغلق.
- يجب عليك توفير مركبة مناسبة للاختبار (من مدرسة تعليم القيادة أو سيارتك المسجلة حسب الأصول).

#### مكونات الاختبار العملي:
- إعداد السيارة وفحوصات ما قبل القيادة
- إجراءات بدء التشغيل الصحيحة
- التحرك بسلاسة وأمان
- التفاعل مع حركة المرور بشكل مناسب
- الالتزام بجميع إشارات المرور وعلامات الطريق
- إظهار قواعد الأولوية الصحيحة عند التقاطعات
- التجاوز الآمن ومواجهة حركة المرور القادمة
- الرجوع للخلف في خط مستقيم وعلى زاوية
- أسلوب الدوران الصحيح عند التقاطعات
- اختيار العتاد الصحيح واستخدامه (ناقل الحركة اليدوي)
- التنقل في المنحنيات والانحناءات
- التوقف العادي والتوقف الطارئ
- التحكم العام والانتباه وزمن رد الفعل

### إذا فشلت في الاختبار العملي
- تتلقى إشعارًا مكتوبًا يوضح الأخطاء المحددة التي ارتكبتها.
- يجب عليك الانتظار لمدة أسبوعين على الأقل قبل إعادة الاختبار.
- يمكنك التدرب في مركز تدريب معترف به خلال فترة الانتظار هذه.
- تشمل الأسباب الشائعة للفشل: الفشل في فحص المرايا، أو الوضع غير الصحيح عند التقاطعات، أو ضعف التحكم في القابض (اليدوي)، أو عدم ملاحظة النقاط العمياء، أو خلق موقف خطير.

### إذا كانت قيادتك تشكل خطرًا داهمًا
- يحق للفاحص إيقاف الاختبار فوراً.
- يؤدي هذا إلى فشل تلقائي وقد يتطلب تدريبًا إضافيًا قبل محاولتك التالية.

## القسم الخامس: المستندات المطلوبة لطلب الترخيص

عند التقدم بطلب للحصول على رخصة قيادة جديدة، قم بإعداد ما يلي:

1. نموذج الطلب الرسمي (يتم الحصول عليه من إدارة الترخيص أو تنزيله إلكترونيًا)
2. ثلاث صور شمسية حديثة مقاس 6×4 سم بخلفية بيضاء أو زرقاء فاتحة
3. البطاقة المدنية أو جواز السفر موضح به رقمك الوطني
4. إثبات السن (شهادة الميلاد أو الهوية الوطنية)
5. شهادة إتمام التدريب (للتدريب العملي والنظري – مطلوبة لجميع الفئات ما عدا الفئتين 1 و 2)
6. شهادة الفحص الطبي سارية المفعول
7. إيصال دفع الرسوم

### تجديد واستبدال الترخيص
- **التجديد:** يتطلب نفس المستندات المطلوبة في الطلب الجديد بالإضافة إلى الترخيص المنتهي الصلاحية. قم بالتجديد قبل تاريخ انتهاء الصلاحية لتجنب العقوبات.
- **بدل الرخصة المفقودة/التالفة:** يتطلب نموذج رخصة مفقودة خاصًا وصورًا جديدة وبطاقة هويتك والرخصة التالفة (إن وجدت). قد تكون هناك حاجة لتقرير الشرطة للتراخيص المفقودة.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (2, 'en', N'# Road Markings: Lines, Symbols, and Their Meanings

Road markings are painted lines, raised reflective markers, or thermoplastic symbols on the road surface that guide, warn, and inform drivers. Understanding them is essential for safe and legal driving.

## Section 1: Colors and Their Meanings

- **White lines:** Separate traffic traveling in the same direction or indicate mandatory markings such as stop lines, pedestrian crossings, or lane edges.
- **Yellow lines:** Indicate road edges (shoulder boundaries) or separate opposing traffic traveling in opposite directions.

{{img:white-and-yellow-road-line-applications}}

## Section 2: Mandatory (Compulsory) Lines

These lines create legal obligations that drivers must obey. Violating them is a traffic offense.

### Solid Longitudinal Lines (Continuous Lines)
- **Legal meaning:** Cannot be crossed for overtaking or changing lanes under any normal circumstances.
- **Purpose:** Separates opposing traffic flows, marks no-overtaking zones, approaches to obstacles or intersections, and road edges.
- **Yellow solid line on your side:** You are prohibited from crossing into oncoming traffic to overtake.
- **White solid line:** Do not change lanes; stay in your current lane.

{{img:solid-center-line}}

### Stop Line
- **Appearance:** Thick solid white line painted across the road, typically 30–50 cm (12–20 inches) wide.
- **Location:** Before intersections, railroad crossings, or any point where a complete stop is legally required.
- **Legal requirement:** You must bring your vehicle to a complete stop before this line, not on top of it or beyond it.
- **Often accompanied by:** A STOP sign on a post or the word "STOP" painted on the road surface.

**Real-world scenario:** You approach an intersection with a stop line but no stop sign. The stop line alone legally requires you to stop because it indicates the edge of the intersection where your view of cross traffic may be limited.

### Yield (Give Way) Line
- **Appearance:** A broken line made of a series of small triangles painted across the road.
- **Legal requirement:** You must give priority (yield) to all traffic on the main road. You may proceed without coming to a complete stop only if the main road is completely clear and it is safe to merge.
- **If necessary:** Stop completely before this line to assess traffic.

{{img:stop-line-vs-yield-line}}

### Obstacle Lines (Hatched Areas)
- **Appearance:** Painted hatched or slanted lines forming a triangular or diagonal pattern within an area.
- **Location:** Before fixed obstacles (bridge pillars, medians, traffic islands) or to separate opposing traffic flows on wide roads.
- **Rule:** The area is surrounded by solid mandatory lines – you must not drive over or enter this area under any normal circumstances.
- **Exception:** Emergency vehicles responding to an incident may be permitted to cross in specific situations.

**Common mistake:** Drivers sometimes use hatched areas as turning lanes or to bypass traffic. This is illegal and dangerous.

## Section 3: Warning (Broken) Lines

These lines indicate where overtaking and lane changing may be permitted with caution.

### Broken Lines on Two-Way Roads
- **Outside cities (rural roads):** Broken line ratio of approximately 3:1 (three units of line, one unit of gap). The longer line segments indicate higher speeds and greater caution needed.
- **Inside cities (urban roads):** Broken line ratio of approximately 1:1 (equal line and gap lengths). Shorter segments reflect lower speeds and more frequent intersections.
- **Meaning:** Overtaking is allowed **with extreme caution** and only when the road ahead is clearly visible and clear of oncoming traffic.
- **Yellow broken lines:** Used primarily on secondary roads to warn drivers of the road edge, especially at night or in poor visibility.

### What the Line Tells You About Overtaking
- **Broken line on your side, solid on opposite side:** You may cross to overtake with caution; oncoming traffic must not cross into your lane.
- **Solid line on your side, broken on opposite:** You must not cross; oncoming traffic may cross (meaning you may face overtaking vehicles coming toward you).
- **Double solid lines (both sides solid):** No crossing from either direction under any circumstance.

## Section 4: Pedestrian Crosswalk (Zebra Crossing)

- **Appearance:** Wide white parallel stripes painted across the road, typically 2–3 meters wide.
- **Legal speed limit when approaching:** 30 km/h maximum.
- **Requirement:** You must stop completely if any pedestrian is on or about to step onto the crossing.
- **Do not:** Overtake another vehicle that has stopped at a pedestrian crossing – they have likely stopped for a pedestrian you cannot see.

### Zigzag Warning Lines
- **Location:** Painted on the road before and after pedestrian crossings, especially near schools.
- **Purpose:** Alert drivers that a pedestrian crossing is ahead and that parking and overtaking are prohibited in this zone.
- **Rule:** No parking, no stopping, and no overtaking within the zigzag zone.

{{img:zebra-crossing}}

**Real-world scenario:** A school bus stops before a zebra crossing with its warning lights flashing. Children may be crossing. You must stop and wait until all children have crossed and the bus moves or turns off its lights.

## Section 5: Bicycle Lane Markings

- **Appearance:** Two solid white lines with a bicycle symbol painted in the space between them. The lane may also be painted a different color (often green or red) for visibility.
- **Legal requirement:** Do not drive or park in a bicycle lane. It is reserved exclusively for cyclists.
- **Intersection priority:** Cyclists using a marked bicycle lane have priority over turning vehicles at intersections. Always check your mirrors and blind spot for cyclists before turning across a bicycle lane.

{{img:bicycle-lane}}

## Section 6: Words, Numbers, and Arrows on the Road

### Painted Words
- **"STOP":** Painted on the road surface before a stop line to reinforce the requirement to stop.
- **"BUS LANE":** Indicates a lane reserved for public transport buses. Private vehicles may be prohibited during certain hours (check local signs).
- **"SLOW":** Warns drivers to reduce speed for an upcoming hazard.

### Speed Numbers
- Painted numbers (e.g., "60", "80", "100") indicate the maximum speed limit for that section of road.
- These numbers supplement posted speed limit signs.

### Directional Arrows
- **Purpose:** Show the required or permitted direction of travel for each lane approaching an intersection.
- **Common arrow types:**
  - Straight ahead (arrow pointing up)
  - Right turn only (arrow pointing right)
  - Left turn only (arrow pointing left)
  - Straight or right turn (combination arrow)
  - Straight or left turn (combination arrow)

{{img:lane-arrows}}

**Legal requirement:** You must choose the lane that matches your intended direction. Using a lane with a straight arrow to turn left (or vice versa) is a traffic violation, even if no other vehicles are present.

**Real-world scenario:** You approach an intersection in the left-turn-only lane but decide to go straight instead. You cannot legally do this. You must turn left and then find a way to turn around or re-route.

## Section 7: Quick Reference Summary

| Marking Type | Appearance | Rule |
|--------------|------------|------|
| Solid center line | Continuous line | No crossing |
| Broken center line | Dashed line | May cross with caution |
| Stop line | Thick white line across road | Complete stop required |
| Yield line | Triangle dashes across road | Yield to traffic |
| Hatched area | Diagonal lines inside solid border | Do not enter |
| Zebra crossing | White stripes across road | Stop for pedestrians |
| Bicycle lane | Solid lines with bicycle symbol | Do not drive or park |');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (2, 'ar', N'# علامات الطريق: الخطوط والرموز ومعانيها

علامات الطريق هي خطوط مرسومة أو علامات عاكسة بارزة أو رموز لدنة بالحرارة على سطح الطريق لتوجيه السائقين وتحذيرهم وإبلاغهم. فهمها ضروري للقيادة الآمنة والقانونية.

## القسم الأول: الألوان ومعانيها

- **الخطوط البيضاء:** تفصل حركة المرور في نفس الاتجاه أو تشير إلى علامات إلزامية مثل خطوط التوقف أو معابر المشاة أو حواف الحارات.
- **الخطوط الصفراء:** تشير إلى حواف الطريق (حدود الكتف) أو حركة المرور المتعارضة المنفصلة التي تسير في اتجاهين متعاكسين.

{{img:white-and-yellow-road-line-applications}}

## القسم الثاني: الخطوط الإلزامية (الإجبارية).

تخلق هذه الخطوط التزامات قانونية يجب على السائقين الالتزام بها. انتهاكهم هو جريمة مرورية.

### الخطوط الطولية الصلبة (الخطوط المستمرة)
- **المعنى القانوني:** لا يجوز التجاوز للتجاوز أو تغيير المسار تحت أي ظرف عادي.
- **الغرض:** فصل تدفقات حركة المرور المتعارضة، ووضع علامات على مناطق حظر التجاوز، ومقاربات العوائق أو التقاطعات، وحواف الطرق.
- **الخط المتصل الأصفر على جانبك:** يُحظر عليك العبور إلى حركة المرور القادمة للتجاوز.
- **خط أبيض متصل:** لا تقم بتغيير المسارات؛ البقاء في المسار الحالي الخاص بك.

{{img:solid-center-line}}

### خط التوقف
- **المظهر:** خط سميك أبيض صلب مرسوم عبر الطريق، ويبلغ عرضه عادةً 30-50 سم (12-20 بوصة).
- **الموقع:** قبل التقاطعات ومعابر السكك الحديدية أو أي نقطة يلزم فيها التوقف الكامل قانونيًا.
- **متطلب قانوني:** يجب عليك إيقاف سيارتك بشكل كامل قبل هذا الخط، وليس فوقه أو خلفه.
- **غالبًا ما تكون مصحوبة بما يلي:** علامة STOP على أحد المنشورات أو كلمة "STOP" مرسومة على سطح الطريق.

**سيناريو من العالم الحقيقي:** أنت تقترب من تقاطع به خط توقف ولكن لا توجد علامة توقف. يتطلب خط التوقف وحده من الناحية القانونية التوقف لأنه يشير إلى حافة التقاطع حيث قد تكون رؤيتك لحركة المرور المتقاطعة محدودة.

### خط العائد (افساح المجال).
- **المظهر:** خط متقطع مكون من سلسلة من المثلثات الصغيرة المرسومة على الجانب الآخر من الطريق.
- **المتطلبات القانونية:** يجب إعطاء الأولوية (العائد) لجميع حركة المرور على الطريق الرئيسي. لا يمكنك المضي قدمًا دون التوقف تمامًا إلا إذا كان الطريق الرئيسي خاليًا تمامًا وكان الاندماج فيه آمنًا.
- **إذا لزم الأمر:** توقف تمامًا قبل هذا الخط لتقييم حركة المرور.

{{img:stop-line-vs-yield-line}}

### خطوط العوائق (المناطق المظللة)
- **المظهر:** خطوط مرسومة أو مائلة تشكل نمطًا مثلثًا أو قطريًا داخل المنطقة.
- **الموقع:** قبل العوائق الثابتة (أعمدة الجسور، الوسطيات، جزر المرور) أو لفصل تدفقات حركة المرور المتعارضة على الطرق الواسعة.
- **القاعدة:** المنطقة محاطة بخطوط إلزامية متصلة - لا يجوز لك القيادة أو الدخول إلى هذه المنطقة في أي ظروف عادية.
- **استثناء:** قد يُسمح لمركبات الطوارئ التي تستجيب لحادث ما بالعبور في مواقف محددة.

**خطأ شائع:** يستخدم السائقون أحيانًا المناطق المظللة كممرات للانعطاف أو لتجاوز حركة المرور. هذا غير قانوني وخطير.

## القسم 3: الخطوط التحذيرية (المكسورة).

تشير هذه الخطوط إلى الأماكن التي يجوز فيها السماح بالتجاوز وتغيير المسار بحذر.

### خطوط متقطعة على الطرق ذات الاتجاهين
- **خارج المدن (الطرق الريفية):** تبلغ نسبة الخطوط المتقطعة حوالي 3:1 (ثلاث وحدات خط ووحدة فجوة واحدة). تشير مقاطع الخطوط الأطول إلى سرعات أعلى وضرورة توخي المزيد من الحذر.
- **داخل المدن (الطرق الحضرية):** تبلغ نسبة الخطوط المتقطعة حوالي 1:1 (أطوال الخطوط والفجوات المتساوية). تعكس المقاطع الأقصر سرعات أقل وتقاطعات أكثر تكرارًا.
- **المعنى:** يُسمح بالتجاوز **بحذر شديد** وفقط عندما يكون الطريق أمامك مرئيًا بوضوح وخاليًا من حركة المرور القادمة.
- **الخطوط الصفراء المتقطعة:** تستخدم بشكل أساسي على الطرق الثانوية لتحذير السائقين من حافة الطريق، خاصة في الليل أو في حالة ضعف الرؤية.

### ماذا يخبرك الخط عن التجاوز
- **خط متقطع من جانبك، متصل على الجانب الآخر:** يمكنك العبور للتجاوز بحذر؛ يجب ألا تعبر حركة المرور القادمة إلى حارتك.
- **الخط المتصل من جانبك، والمكسور من الجهة المقابلة:** يجب ألا تعبر؛ قد تعبر حركة المرور القادمة (مما يعني أنك قد تواجه مركبات متجاوزة قادمة نحوك).
- **الخطوط الصلبة المزدوجة (الجانبين متصلين):** ممنوع العبور من أي اتجاه تحت أي ظرف من الظروف.

## القسم الرابع: معبر المشاة (معبر الحمار الوحشي)

- **المظهر:** خطوط بيضاء متوازية عريضة مرسومة على طول الطريق، ويبلغ عرضها عادةً 2-3 أمتار.
- **الحد الأقصى للسرعة القانونية عند الاقتراب:** 30 كم/ساعة كحد أقصى.
- **المتطلبات:** يجب عليك التوقف تمامًا في حالة وجود أي مشاة على المعبر أو على وشك الدخول إليه.
- **لا تفعل:** تجاوز مركبة أخرى توقفت عند معبر للمشاة - فمن المحتمل أنها توقفت بسبب أحد المشاة الذي لا يمكنك رؤيته.

### خطوط التحذير المتعرجة
- **الموقع:** مرسوم على الطريق قبل وبعد معابر المشاة، وخاصة بالقرب من المدارس.
- **الغرض:** تنبيه السائقين بوجود معبر للمشاة أمامهم وأن الوقوف والتجاوز محظور في هذه المنطقة.
- **القاعدة:** ممنوع الوقوف والتوقف وعدم التجاوز داخل المنطقة المتعرجة.

{{img:zebra-crossing}}

**سيناريو من العالم الحقيقي:** تتوقف حافلة مدرسية قبل معبر حمار وحشي وتومض أضواء التحذير الخاصة بها. قد يعبر الأطفال. يجب عليك التوقف والانتظار حتى يعبر جميع الأطفال وتتحرك الحافلة أو تطفئ أضواءها.

## القسم 5: علامات حارات الدراجات

- **المظهر:** خطان أبيضان متصلان مع رمز دراجة مرسوم في المسافة بينهما. يمكن أيضًا طلاء الممر بلون مختلف (غالبًا أخضر أو ​​​​أحمر) للرؤية.
- **المتطلبات القانونية:** لا تقم بالقيادة أو الوقوف في ممر مخصص للدراجات. وهي مخصصة حصريًا لراكبي الدراجات.
- **أولوية التقاطع:** يتمتع راكبو الدراجات الذين يستخدمون ممرًا محددًا للدراجات بالأولوية على تحويل المركبات عند التقاطعات. تحقق دائمًا من المرايا والنقطة العمياء لراكبي الدراجات قبل الانعطاف عبر ممر الدراجات.

{{img:bicycle-lane}}

## القسم السادس: الكلمات والأرقام والأسهم على الطريق

### الكلمات المرسومة
- **"التوقف":** يتم رسمه على سطح الطريق قبل خط التوقف لتعزيز وجوب التوقف.
- **"BUS LANE":** تشير إلى المسار المخصص لحافلات النقل العام. قد يتم حظر المركبات الخاصة خلال ساعات معينة (تحقق من اللافتات المحلية).
- **"بطيء":** يحذر السائقين من تقليل السرعة تحسبًا لخطر قادم.

### أرقام السرعة
- الأرقام المرسومة (على سبيل المثال، "60"، "80"، "100") تشير إلى الحد الأقصى للسرعة لهذا الجزء من الطريق.
- هذه الأرقام تكمل علامات الحد الأقصى للسرعة المنشورة.

### أسهم الاتجاه
- **الغرض:** إظهار اتجاه السفر المطلوب أو المسموح به لكل حارة تقترب من التقاطع.
- **أنواع الأسهم الشائعة:**
  - للأمام مباشرة (السهم يشير للأعلى)
  - الانعطاف لليمين فقط (السهم يشير لليمين)
  - الانعطاف لليسار فقط (السهم يشير لليسار)
  - انعطاف مستقيم أو يمين (سهم مركب)
  - انعطاف مستقيم أو يسار (سهم مركب)

{{img:lane-arrows}}

**المتطلبات القانونية:** يجب عليك اختيار المسار الذي يتوافق مع اتجاهك المقصود. يعد استخدام حارة بها سهم مستقيم للانعطاف يسارًا (أو العكس) مخالفة مرورية، حتى في حالة عدم وجود مركبات أخرى.

**سيناريو العالم الحقيقي:** تقترب من تقاطع في المسار المخصص للانعطاف لليسار فقط ولكنك تقرر الاتجاه بشكل مستقيم بدلاً من ذلك. لا يمكنك القيام بذلك قانونيًا. يجب عليك الانعطاف يسارًا ثم العثور على طريقة للالتفاف أو تغيير المسار.

## القسم 7: ملخص مرجعي سريع

| نوع الوسم | المظهر | القاعدة |
|--------------|------------|------|
| خط الوسط الصلب | خط مستمر | لا معبر |
| خط الوسط المكسور | خط متقطع | قد أعبر بحذر |
| خط التوقف | خط أبيض سميك عبر الطريق | التوقف الكامل مطلوب |
| خط العائد | شرطات المثلث عبر الطريق | العائد لحركة المرور |
| منطقة فقس | خطوط قطرية داخل الحدود الصلبة | لا تدخل |
| معبر زيبرا | خطوط بيضاء عبر الطريق | توقف للمشاة |
| ممر الدراجات | خطوط صلبة مع رمز الدراجة | لا تقم بالقيادة أو ركن السيارة |');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (3, 'en', N'# Traffic Signs Complete Guide – Warning, Priority, Prohibition, and Mandatory Signs

Traffic signs communicate rules, warnings, and information instantly. Recognizing and responding correctly to every sign is essential for safe driving and passing your theoretical exam.

## Section 1: Warning Signs (Shape: Triangle, Point Up, Red Border, White Background, Black Symbol)

Warning signs alert you to hazards ahead. They always require reducing speed and increasing attention.

### Curve and Road Alignment Warnings

| Sign | Meaning | Correct Response |
|------|---------|-------------------|
| Right curve ahead | Road bends to the right | Reduce speed before curve, no overtaking, watch for limited visibility around bend |
| Left curve ahead | Road bends to the left | Same as right curve |
| Double curve (right then left) | S-curve, first right then left | Reduce speed significantly, stay in lane |
| Double curve (left then right) | S-curve, first left then right | Reduce speed significantly, stay in lane |


### Hill and Road Surface Warnings

| Sign | Meaning | Correct Response |
|------|---------|-------------------|
| Steep downhill | Significant downward slope ahead | Reduce speed before descent, use lower gears for engine braking, avoid riding brakes |
| Steep uphill | Significant upward slope ahead | Maintain momentum, downshift early if needed, keep right for faster vehicles |
| Uneven road | Bumps, dips, or damaged pavement ahead | Reduce speed, drive carefully to avoid vehicle damage or loss of control |
| Speed bump | Raised pavement hump ahead | Slow down significantly to cross safely at low speed |
| Dip | Sudden depression in road surface | Slow down to cross safely; suspension damage possible at speed |

{{img:steep-downhill-warning}}

### Road Width Warnings

| Sign | Meaning | Correct Response |
|------|---------|-------------------|
| Road narrows from both sides | Road becomes narrower from left and right | Slow down, move to center of available width, no overtaking |
| Road narrows from right | Right side of road narrows (obstruction or lane ends) | Slow down, keep left if safe, be prepared to yield |
| Road narrows from left | Left side of road narrows | Slow down, keep right |
| Bridge narrows | Bridge is narrower than approach road | Slow down, no overtaking, single file if necessary |
| Road ends at quay/river | Road terminates at water (dock, riverbank) | Slow down, be ready to stop completely |

### Work Zone Signs
- **Men working:** Road construction or maintenance ahead. Reduce speed, watch for workers and equipment, be prepared for lane shifts or reduced lanes.
- **Signals or flaggers may be present:** Obey flagger instructions even if they contradict traffic signs.

{{img:men-working-sign}}

### Other Important Warning Signs

| Sign | Meaning | Correct Response |
|------|---------|-------------------|
| Slippery road | Reduced traction due to rain, ice, oil, or loose surface | Reduce speed significantly, no sudden braking or steering, increase following distance |
| Falling rocks (right or left) | Risk of rocks falling onto road from adjacent hillside | Drive carefully, watch for rocks on road, avoid stopping in rockfall zone |
| Loose stones | Gravel or loose stones on road surface | Reduce speed, increase following distance (stones can be thrown up), no overtaking |
| Pedestrian crossing | Crosswalk ahead, pedestrians may be present | Reduce to 30 km/h, stop if pedestrians are crossing or waiting |
| Two-way traffic ahead | Road changes from divided to two-way | Keep right, be alert for oncoming vehicles, no crossing center line |
| Divided highway begins | Road ahead splits into separate carriageways | Keep right, follow lane markings, no crossing median |
| Divided highway ends | Divided road ends, becomes two-way | Keep right, be alert for oncoming traffic after the merge |
| Tunnel ahead | Enclosed tunnel passage | Reduce to 50 km/h (or posted limit), turn on headlights, keep lane, no overtaking, check that your vehicle height/width is permitted |
| Railway crossing with gate | Railroad crossing protected by gates or barriers | Stop when gates are down, give priority to trains, wait for gates to fully rise before proceeding |
| Railway crossing without gate | Unprotected railroad crossing | Reduce speed significantly, look and listen for trains, be ready to stop, proceed only when safe |
| Railway crossing distance marker | Three-stripe marker showing distance to crossing | Prepare to stop; more stripes = farther distance |
| Roundabout ahead | Circular intersection ahead | Reduce speed, give priority to vehicles already inside roundabout, choose correct lane for your exit |
| Stop sign ahead | Intersection with stop sign is approaching | Prepare to come to a complete stop |
| Yield sign ahead | Intersection with yield sign is approaching | Prepare to give way to crossing traffic |

## Section 2: Priority Signs

Priority signs tell you who has the right-of-way at intersections and narrow passages.

### Yield (Give Way)
- **Appearance:** Red-bordered inverted triangle (point down) with white center.
- **Action:** Reduce speed before the intersection. Give priority to all vehicles on the intersecting road. You may proceed without stopping only when the intersecting road is completely clear and safe.

### Stop
- **Appearance:** Red octagon with white letters spelling "STOP".
- **Action:** Come to a **complete stop** before the stop line or before entering the intersection if no line exists. Do not creep forward. Proceed only when safe and clear in all directions.
- **Additional locations:** Also required at railway crossings without gates or signals.

{{img:stop-sign}}

### Main Road
- **Appearance:** Yellow diamond with white border (and often a thick black outline).
- **Meaning:** You are traveling on the main road and have priority over traffic entering from side roads.
- **Caution:** Remain alert at intersections – not all drivers will yield to you properly.

### End of Main Road
- **Appearance:** Same yellow diamond shape but with black diagonal lines through it.
- **Meaning:** Your priority ends. Reduce speed and give way as required by other signs or the general right-of-way rules.

### Priority for Oncoming Traffic (Narrow Road)
- **Appearance:** Red-bordered circle with two arrows: one red (pointing up), one black (pointing down).
- **Meaning:** The red arrow indicates which direction has priority. If the red arrow points toward you, oncoming traffic has priority. You must stop and let them pass when the road is too narrow for two vehicles.
- **Common location:** Narrow bridges or mountain roads with limited passing space.

{{img:priority-for-incoming}}

### Priority Over Oncoming Traffic
- **Appearance:** Blue square with two arrows: white arrow pointing down, red arrow pointing up.
- **Meaning:** You have priority. Oncoming vehicles must stop and let you pass when the road is too narrow.

{{img:priority-over-incoming}}

## Section 3: Prohibition (Regulatory) Signs

Round signs with white background, red border, and black symbol. They tell you what you must NOT do.

| Sign | Meaning |
|------|---------|
| No entry both directions | Road closed to all motor vehicles (pedestrians and bicycles only) |
| No entry (one-way from opposite direction) | Do not enter this road from this end |
| No motor vehicles | No engine-powered vehicles of any kind |
| No motorcycles | Motorcycles prohibited |
| No bicycles | Bicycles prohibited |
| No mopeds | Small motorized scooters/bikes prohibited |
| No trucks or goods vehicles | Trucks exceeding a specified weight prohibited |
| No width over (number) | Vehicles wider than indicated (e.g., 2.2 meters) prohibited |
| No height over (number) | Vehicles taller than indicated (e.g., 3.5 meters) prohibited |
| No weight over (number) | Vehicles heavier than indicated (e.g., 12 tons) prohibited |
| No axle weight over (number) | Vehicles with axle load exceeding limit prohibited |
| No length over (number) | Vehicles longer than indicated prohibited |
| No left turn | Left turn prohibited at this intersection |
| No right turn | Right turn prohibited at this intersection |
| No U-turn | Turning to opposite direction prohibited |
| No overtaking | Overtaking prohibited for all vehicles (or for trucks over certain weight) |
| Speed limit (maximum) | Do not exceed the posted speed (number in red circle) |
| No horn | Horn use prohibited (near hospitals, schools, religious sites) |
| No stopping | Stopping vehicle prohibited (even briefly) |
| No parking | Parking vehicle prohibited (brief stopping may be allowed) |
| Customs stop | Must stop for customs inspection at border or checkpoint |

**Real-world scenario:** You see a "No left turn" sign at an intersection. You need to turn left. You cannot. You must go straight or turn right and find a safe place to turn around or re-route.

## Section 4: Mandatory (Command) Signs

Round or circular signs with blue background and white symbol. They tell you what you MUST do.

| Sign | Action Required |
|------|-----------------|
| Straight ahead only | Must drive straight; no turning |
| Turn left only | Must turn left |
| Turn right only | Must turn right |
| Straight or left | May go straight or turn left |
| Straight or right | May go straight or turn right |
| Keep left | Must keep to left side of obstacle or divider |
| Keep right | Must keep to right side of obstacle or divider |
| Minimum speed limit (blue circle with white number) | Must drive at least this speed (unless conditions prevent it) |


## Section 5: Informational (Guide) Signs

Rectangular or square signs, typically blue with white text/symbols. They provide navigation and service information.

### Types of Informational Signs

| Purpose | Example Information |
|---------|---------------------|
| Lane assignment | Diagram showing multiple lanes with arrows for each destination |
| Advance direction | "Amman 25 km" or "Irbid →" showing distance and direction |
| Route numbers | Primary route (e.g., Route 15) or secondary route (e.g., Route 122) |
| Motorway begins/ends | Indicates entrance to or exit from controlled-access highway |
| Additional lane | New lane joining from the right ahead |
| Lane reduction | Two lanes merging into one; adjust position early |
| Service signs | Petrol station, hospital, restaurant, hotel, rest area, repair shop |
| Tourist attraction | Direction to historical or cultural sites (brown background often used) |

**Real-world scenario:** You are driving on an unfamiliar highway. An advance direction sign tells you that your exit is 2 kilometers ahead and recommends the right lane. Moving over early reduces stress and avoids last-second dangerous lane changes.

## Section 6: Summary – Recognizing Sign Shapes

- **Triangle pointing up, red border:** Warning (danger ahead)
- **Inverted triangle (point down), red border:** Yield
- **Octagon, red:** Stop
- **Circle, red border, white background:** Prohibition (something forbidden)
- **Circle or round, blue background:** Mandatory (something required)
- **Diamond, yellow:** Priority (main road or end of main road)
- **Rectangle or square, blue:** Information or direction');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (3, 'ar', N'# الدليل الكامل لإشارات المرور - الإشارات التحذيرية والأولوية والحظر والإشارات الإلزامية

تنقل إشارات المرور القواعد والتحذيرات والمعلومات على الفور. يعد التعرف على كل إشارة والاستجابة لها بشكل صحيح أمرًا ضروريًا للقيادة الآمنة واجتياز الاختبار النظري.

## القسم 1: العلامات التحذيرية (الشكل: مثلث، نقطة لأعلى، حد أحمر، خلفية بيضاء، رمز أسود)

علامات التحذير تنبهك إلى المخاطر المقبلة. إنها تتطلب دائمًا تقليل السرعة وزيادة الاهتمام.

### تحذيرات المنحنيات ومحاذاة الطريق

| التوقيع | معنى | الرد الصحيح |
|------|---------|------------------|
| المنحنى الأيمن للأمام | ينحني الطريق إلى اليمين | خفف السرعة قبل المنحنى، ممنوع التجاوز، انتبه إلى الرؤية المحدودة حول المنعطف |
| المنحنى الأيسر للأمام | ينحني الطريق إلى اليسار | نفس المنحنى الأيمن |
| منحنى مزدوج (يمين ثم يسار) | منحنى S، أولًا لليمين ثم لليسار | خفف السرعة بشكل ملحوظ، وابق في المسار |
| منحنى مزدوج (يسار ثم يمين) | منحنى S، أولًا لليسار ثم لليمين | خفف السرعة بشكل ملحوظ، وابق في المسار |


### تحذيرات على سطح التلال والطرق

| التوقيع | معنى | الرد الصحيح |
|------|---------|------------------|
| منحدر حاد | منحدر هبوطي كبير أمامنا | خفف السرعة قبل الهبوط، استخدم تروسًا أقل لفرملة المحرك، وتجنب ركوب الفرامل |
| شاقة شديدة الانحدار | منحدر صاعد كبير أمامنا | حافظ على الزخم، وقم بتغيير السرعة مبكرًا إذا لزم الأمر، وحافظ على اليمين للمركبات الأسرع |
| طريق غير مستوي | المطبات أو الانخفاضات أو الرصيف التالف أمامك | خفف السرعة، وقم بالقيادة بحذر لتجنب تلف السيارة أو فقدان السيطرة عليها |
| مطب السرعة | سنام الرصيف المرتفع للأمام | خفف السرعة بشكل ملحوظ للعبور بأمان بسرعة منخفضة |
| تراجع | منخفض مفاجئ على سطح الطريق | تمهل لتتمكن من العبور بأمان؛ احتمال تلف التعليق عند السرعة |

{{img:steep-downhill-warning}}

### تحذيرات عرض الطريق

| التوقيع | معنى | الرد الصحيح |
|------|---------|------------------|
| الطريق يضيق من الجانبين | يصبح الطريق أضيق من اليسار واليمين | أبطئ السرعة، وانتقل إلى مركز العرض المتاح، بدون تجاوز |
| الطريق يضيق من اليمين | يضيق الجانب الأيمن من الطريق (عائق أو نهاية حارة) | أبطئ السرعة، وحافظ على اليسار إذا كنت آمنًا، وكن مستعدًا للاستسلام |
| الطريق يضيق من اليسار | الجانب الأيسر من الطريق يضيق | تمهل، حافظ على حقك |
| جسر يضيق | الجسر أضيق من طريق الاقتراب | تمهل، لا تجاوز، ملف واحد إذا لزم الأمر |
| ينتهي الطريق عند الرصيف/النهر | الطريق ينتهي عند الماء (رصيف، ضفة النهر) | تمهل، وكن مستعدًا للتوقف تمامًا |

### لافتات منطقة العمل
- **الرجال العاملون:** أعمال بناء الطرق أو صيانتها في المستقبل. قلل السرعة، وراقب العمال والمعدات، وكن مستعدًا لتغييرات المسار أو الممرات المنخفضة.
- **قد تكون هناك إشارات أو إشارات:** التزم بتعليمات المُبلغين حتى لو كانت تتعارض مع إشارات المرور.

{{img:men-working-sign}}

### علامات تحذيرية مهمة أخرى

| التوقيع | معنى | الرد الصحيح |
|------|---------|------------------|
| طريق زلق | انخفاض الجر بسبب المطر أو الجليد أو الزيت أو السطح السائب | خفف السرعة بشكل كبير، لا تستخدم المكابح أو التوجيه بشكل مفاجئ، قم بزيادة مسافة التتبع |
| سقوط الصخور (يمين أو يسار) | خطر سقوط الصخور على الطريق من جانب التل المجاور | قم بالقيادة بحذر، وانتبه للصخور على الطريق، وتجنب التوقف في منطقة تساقط الصخور |
| حجارة سائبة | الحصى أو الحجارة السائبة على سطح الطريق | خفض السرعة، زيادة مسافة المتابعة (يمكن رمي الحجارة)، ممنوع التجاوز |
| معبر مشاة | معبر المشاة أمامك، قد يكون هناك مشاة | خفف السرعة إلى 30 كم/ساعة، وتوقف إذا كان هناك مشاة يعبرون الطريق أو ينتظرون |
| حركة المرور في اتجاهين أمامك | تغير الطريق من مقسم إلى اتجاهين | حافظ على اليمين، وكن متيقظًا للمركبات القادمة، ولا يوجد عبور للخط الأوسط |
| يبدأ الطريق السريع المقسم | الطريق أمامك ينقسم إلى طرق منفصلة | حافظ على اليمين، واتبع علامات المسار، ولا يوجد عبور متوسط ​​|
| ينتهي الطريق السريع المقسم | الطريق المقسم ينتهي، فيصبح ذو اتجاهين | حافظ على اليمين، وكن متيقظًا لحركة المرور القادمة بعد الدمج |
| النفق أمام | ممر نفق مغلق | قلل السرعة إلى 50 كم/ساعة (أو الحد المعلن)، قم بتشغيل المصابيح الأمامية، حافظ على المسار، ممنوع التجاوز، تأكد من السماح بارتفاع/عرض سيارتك |
| معبر السكة الحديد مع بوابة | معبر السكك الحديدية المحمي بالبوابات أو الحواجز | توقف عند إغلاق البوابات، وأعط الأولوية للقطارات، وانتظر حتى ترتفع البوابات بالكامل قبل المتابعة |
| معبر السكة الحديد بدون بوابة | معبر سكك حديدية غير محمي | خفف السرعة بشكل كبير، وابحث عن القطارات واستمع إليها، وكن مستعدًا للتوقف، ولا تتقدم إلا عندما يكون ذلك آمنًا |
| علامة مسافة عبور السكة الحديد | علامة ثلاثية الخطوط توضح المسافة إلى المعبر | الاستعداد للتوقف؛ خطوط أكثر = مسافة أبعد |
| الدوار امام | أمامك تقاطع دائري | خفف السرعة، وأعطي الأولوية للمركبات الموجودة داخل الدوار، واختر المسار الصحيح لمخرجك |
| علامة التوقف للأمام | التقاطع مع إشارة التوقف يقترب | استعد للتوقف التام |
| علامة العائد قدما | التقاطع مع إشارة العائد يقترب | الاستعداد لإفساح المجال لعبور حركة المرور |

## القسم الثاني: علامات الأولوية

تخبرك علامات الأولوية بمن له حق الأولوية عند التقاطعات والممرات الضيقة.

### العائد (افساح المجال)
- **المظهر:** مثلث مقلوب حدوده حمراء (نقطة للأسفل) ومركزه أبيض.
- **الإجراء:** خفف السرعة قبل التقاطع. إعطاء الأولوية لجميع المركبات على الطريق المتقاطع. لا يجوز لك المضي قدمًا دون توقف إلا عندما يكون الطريق المتقاطع خاليًا وآمنًا تمامًا.

### توقف
- **المظهر:** مثمن أحمر بأحرف بيضاء تهجئة "STOP".
- **الإجراء:** توقف **تمامًا** قبل خط التوقف أو قبل الدخول إلى التقاطع في حالة عدم وجود خط. لا تزحف إلى الأمام. لا تتقدم إلا عندما تكون آمنًا وواضحًا في جميع الاتجاهات.
- **مواقع إضافية:** مطلوبة أيضًا عند معابر السكك الحديدية بدون بوابات أو إشارات.

{{img:stop-sign}}

### الطريق الرئيسي
- **المظهر:** ماس أصفر ذو حدود بيضاء (وغالبًا ما يكون مخططًا أسود سميكًا).
- **المعنى:** أنت تسير على الطريق الرئيسي ولديك الأولوية على حركة المرور القادمة من الطرق الجانبية.
- **تحذير:** كن متيقظًا عند التقاطعات - لن يستسلم جميع السائقين لك بشكل صحيح.

### نهاية الطريق الرئيسي
- **المظهر:** نفس شكل الماسة الصفراء ولكن مع وجود خطوط قطرية سوداء من خلالها.
- **المعنى:** تنتهي أولويتك. خفف السرعة وأفسح المجال حسب ما تقتضيه العلامات الأخرى أو قواعد حق الأولوية العامة.

### الأولوية لحركة المرور القادمة (الطريق الضيق)
- **المظهر:** دائرة ذات حدود حمراء ولها سهمان: أحدهما أحمر (يشير إلى الأعلى)، والآخر أسود (يشير إلى الأسفل).
- **المعنى:** يشير السهم الأحمر إلى الاتجاه الذي له الأولوية. إذا كان السهم الأحمر يشير نحوك، فإن الأولوية لحركة المرور القادمة. يجب عليك التوقف والسماح لهم بالمرور عندما يكون الطريق ضيقًا جدًا بحيث لا يتسع لمركبتين.
- **موقع مشترك:** جسور أو طرق جبلية ضيقة ذات مساحة مرور محدودة.

{{img:priority-for-incoming}}

### الأولوية على حركة المرور القادمة
- **المظهر:** مربع أزرق به سهمان: سهم أبيض يشير إلى الأسفل، وسهم أحمر يشير إلى الأعلى.
- **المعنى:** لك الأولوية. يجب أن تتوقف المركبات القادمة وتسمح لك بالمرور عندما يكون الطريق ضيقًا للغاية.
## القسم الثالث: علامات المنع (التنظيمية).

{{img:priority-over-incoming}}

علامات مستديرة ذات خلفية بيضاء وحدود حمراء ورمز أسود. يقولون لك ما لا يجب عليك فعله.

| التوقيع | معنى |
|------|---------|
| ممنوع الدخول في الاتجاهين | الطريق مغلق أمام جميع المركبات الآلية (المشاة والدراجات فقط) |
| ممنوع الدخول (اتجاه واحد من الاتجاه المعاكس) | لا تدخل هذا الطريق من هذه النهاية |
| لا يوجد سيارات | ممنوع المركبات التي تعمل بمحرك من أي نوع |
| لا دراجات نارية | الدراجات النارية محظورة |
| لا دراجات | الدراجات المحظورة |
| لا الدراجات النارية | الدراجات البخارية/الدراجات البخارية الصغيرة محظورة |
| لا توجد شاحنات أو مركبات بضائع | الشاحنات التي تتجاوز الوزن المحدد ممنوع |
| لا يوجد عرض فوق (الرقم) | المركبات الأعرض من المشار إليها (على سبيل المثال، 2.2 متر) محظورة |
| لا يوجد ارتفاع فوق (الرقم) | المركبات الأطول من المشار إليها (على سبيل المثال، 3.5 متر) محظورة |
| لا وزن يزيد على (العدد) | المركبات الأثقل مما هو مذكور (على سبيل المثال، 12 طنًا) محظورة |
| لا يزيد وزن المحور عن (العدد) | المركبات ذات الحمولة المحورية التي تتجاوز الحد المسموح به |
| لا يوجد طول يزيد على (الرقم) | المركبات الأطول مما هو مذكور محظورة |
| لا يوجد انعطاف لليسار | ممنوع الانعطاف يسارًا عند هذا التقاطع |
| لا يوجد انعطاف يمين | ممنوع الانعطاف يمينًا عند هذا التقاطع |
| لا يوجد منعطف على شكل حرف U | ممنوع الإلتفاف إلى الإتجاه المعاكس |
| ممنوع التجاوز | ممنوع التجاوز لجميع المركبات (أو للشاحنات التي يزيد وزنها عن حد معين) |
| الحد الأقصى للسرعة (الحد الأقصى) | لا تتجاوز السرعة المعلنة (الرقم في الدائرة الحمراء) |
| لا قرن | ممنوع استخدام البوق (بالقرب من المستشفيات والمدارس والأماكن الدينية) |
| لا توقف | ممنوع إيقاف المركبة (ولو لفترة وجيزة) |
| لا يوجد موقف سيارات | ممنوع ركن السيارة (قد يُسمح بالتوقف لفترة قصيرة) |
| توقف الجمارك | يجب التوقف للتفتيش الجمركي على الحدود أو نقطة التفتيش |

**سيناريو العالم الحقيقي:** ترى لافتة "ممنوع الانعطاف إلى اليسار" عند أحد التقاطع. عليك أن تستدير لليسار. لا يمكنك ذلك. يجب عليك السير بشكل مستقيم أو الانعطاف يمينًا والعثور على مكان آمن للالتفاف أو تغيير المسار.

## القسم الرابع: العلامات الإلزامية (الأمر).

علامات مستديرة أو دائرية ذات خلفية زرقاء ورمز أبيض. يقولون لك ما يجب عليك القيام به.

| التوقيع | الإجراء مطلوب |
|------|-----------------|
| للأمام مباشرة فقط | يجب أن تقود السيارة بشكل مستقيم؛ لا تحول |
| اتجه يسارًا فقط | يجب أن اتجه يسارا |
| انعطف يمينًا فقط | يجب أن يتجه إلى اليمين |
| مستقيم أو يسار | قد يتجه بشكل مستقيم أو يتجه يسارًا |
| مستقيم أو صحيح | قد يتجه بشكل مستقيم أو يتجه يمينًا |
| حافظ على اليسار | يجب الالتزام بالجانب الأيسر من العائق أو الحاجز |
| حافظ على الحق | يجب الالتزام بالجانب الأيمن من العائق أو الحاجز |
| الحد الأدنى للسرعة (دائرة زرقاء مع رقم أبيض) | يجب القيادة بهذه السرعة على الأقل (ما لم تمنع الظروف ذلك) |


## القسم الخامس: العلامات الإرشادية (الإرشادية).

علامات مستطيلة أو مربعة، وعادةً ما تكون باللون الأزرق مع نص/رموز بيضاء. أنها توفر معلومات الملاحة والخدمة.

### أنواع العلامات المعلوماتية

| الغرض | معلومات المثال |
|---------|---------------------|
| تخصيص حارة | رسم تخطيطي يوضح مسارات متعددة مع أسهم لكل وجهة |
| الاتجاه المتقدم | "عمان 25 كم" أو "إربد →" تظهر المسافة والاتجاه |
| أرقام الطرق | الطريق الرئيسي (على سبيل المثال، الطريق 15) أو الطريق الثانوي (على سبيل المثال، الطريق 122) |
| يبدأ/ينتهي الطريق السريع | يشير إلى الدخول إلى الطريق السريع الذي يمكن التحكم في الوصول إليه أو الخروج منه |
| حارة إضافية | حارة جديدة تنضم من اليمين إلى الأمام |
| تخفيض المسار | مساران يندمجان في مسار واحد؛ ضبط الموقف في وقت مبكر |
| علامات الخدمة | محطة بنزين، مستشفى، مطعم، فندق، منطقة استراحة، ورشة إصلاح |
| جذب سياحي | الاتجاه إلى المواقع التاريخية أو الثقافية (خلفية بنية غالبًا ما تستخدم) |

**سيناريو العالم الحقيقي:** أنت تقود على طريق سريع غير مألوف. تخبرك علامة الاتجاه المتقدمة أن مخرجك يقع على بعد كيلومترين للأمام وتوصي بالمسار الأيمن. يؤدي التحرك مبكرًا إلى تقليل التوتر وتجنب تغيير المسار الخطير في الثانية الأخيرة.

## القسم 6: ملخص – التعرف على أشكال اللافتات

- **مثلث يشير لأعلى، حد أحمر:** تحذير (خطر قادم)
- **مثلث مقلوب (أشر إلى الأسفل)، حد أحمر:** العائد
- **المثمن، الأحمر:** توقف
- **دائرة، حد أحمر، خلفية بيضاء:** الحظر (شيء ممنوع)
- **دائرة أو مستديرة، خلفية زرقاء:** إلزامي (شيء مطلوب)
- **الماسي، الأصفر:** الأولوية (الطريق الرئيسي أو نهاية الطريق الرئيسي)
- **مستطيل أو مربع، أزرق:** معلومات أو اتجاه');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (4, 'en', N'# Right-of-Way Rules at Intersections and Roundabouts

Right-of-way rules determine who goes first at intersections, roundabouts, and other traffic situations. These rules prevent confusion and crashes. Memorize them completely.

## Section 1: General Approach to Any Intersection

Before applying specific rules, follow this safety routine at every intersection:

1. **Reduce speed** as you approach, even if you have priority.
2. **Choose the correct lane** well in advance using road markings and signs.
3. **Signal your intention** using turn signals at least 30 meters before the intersection.
4. **Check for other road users** – pedestrians, cyclists, motorcyclists, and other vehicles.
5. **Do not enter** if the intersection is already congested (gridlock rules).
6. **Maintain awareness** of vehicles behind you that may not expect you to stop.

## Section 2: Rule 1 – Right-Hand Rule (Equal Priority Intersections)

**When does this apply?** At intersections where there are no traffic signs, no traffic lights, and no road markings indicating a main road.

**The rule:** The vehicle coming from your **right** has priority over you. You must yield to that vehicle.

**How it works in all directions:**
- If you approach an intersection and see a vehicle coming from your right, you must wait for that vehicle to pass before proceeding.
- The vehicle to your left must yield to you.
- This creates a consistent clockwise priority system.


**Real-world scenario:** You arrive at an uncontrolled four-way intersection in a residential area. A car approaches from your right at the same time. You stop and let that car go first. After it passes, you may proceed, checking that the vehicle to your left is also yielding to you.

**Common mistake:** Assuming that the first vehicle to arrive goes first. While polite, this is not the legal rule. The right-hand rule is the law, even if you arrived first.

## Section 3: Rule 2 – Opposite Direction Priority

**The rule:** When vehicles approach from opposite directions and one intends to turn left across the path of the other, the vehicle going straight or turning right has priority over the left-turning vehicle.

**Application:**
- You face an oncoming vehicle at an intersection.
- You want to turn left. The oncoming vehicle wants to go straight or turn right.
- The oncoming vehicle has priority. You must wait.
- The same applies if you want to go straight and the oncoming vehicle wants to turn left – you have priority.


**Real-world scenario:** You are at an intersection, signaling left. An oncoming car is approaching with no turn signal (going straight). You must wait for that car to clear the intersection before completing your left turn.

## Section 4: Rule 3 – Main Road vs. Secondary Road

**The rule:** Vehicles traveling on the main road (marked by priority signs) have priority over vehicles entering from side roads.

**Application:**
- If you are on the main road (yellow diamond sign), you may proceed through intersections without stopping.
- Vehicles from side roads must yield to you.
- If you are entering from a secondary road, you must yield to all traffic on the main road.

**Caution:** Even when you have priority, always be prepared for drivers on side roads to pull out in front of you. Defensive driving means anticipating mistakes.

## Section 5: Rule 4 – Roundabout Priority

Roundabouts (traffic circles) keep traffic moving and reduce the severity of crashes compared to traditional intersections when used correctly.

### The Fundamental Rule
- **Vehicles already inside the roundabout have priority.**
- Vehicles waiting to enter must yield and wait for a safe gap in traffic.

### Lane Selection for Roundabouts

| Intended Exit | Lane to Enter | Lane to Stay In |
|---------------|---------------|-----------------|
| First exit (right turn) | Right lane | Right lane through roundabout |
| Straight ahead (second exit) | Either lane (if two lanes entering) | Stay in your lane through roundabout |
| Left turn (third exit or beyond) | Left lane | Left lane until near exit, then signal and move to exit |

### Roundabout Navigation Steps

1. **Approach:** Reduce speed. Choose correct lane based on your exit.
2. **Yield:** Look left (in right-hand traffic countries) and yield to traffic already in the roundabout.
3. **Enter:** When a safe gap appears, merge smoothly.
4. **Navigate:** Stay in your lane. Do not change lanes inside the roundabout.
5. **Signal to exit:** Use right turn signal before your exit.
6. **Exit:** Exit smoothly, checking for pedestrians at crosswalks.

**Prohibited actions in roundabouts:**
- Stopping inside the roundabout (except to avoid a crash)
- Changing lanes
- Overtaking
- Driving next to a large truck or bus (stay behind or ahead, not beside)

**Real-world scenario:** You approach a roundabout and see a truck already inside, taking the left lane. You are in the right lane wanting to go straight. The truck blocks your view of traffic coming from the left. Wait until you have a clear view and a safe gap – do not assume the roundabout is clear just because you cannot see traffic.

## Section 6: Rule 5 – Railway Crossing Priority

**The rule:** Trains always have absolute priority over all road vehicles.

**Requirements at railway crossings:**
- Stop when gates are lowered or lights flash.
- Do not proceed until the train has completely passed and gates have fully risen.
- At crossings without gates, stop, look both ways, and listen before crossing.

**Critical warning:** Never stop on railway tracks. If traffic is backed up across a crossing, wait before the tracks until there is space on the other side.

## Section 7: Rule 6 – T-Junction Priority

**The rule:** The road that continues straight (the through road) has priority over the road that ends (the stem of the T).

**Application:**
- If you are on the road that ends at the T, you must yield to traffic traveling in either direction on the continuing road.
- If you are on the continuing road, you have priority over vehicles entering from the ending road.


## Section 8: Rule 7 – Emergency and Official Vehicles

**The rule:** Police vehicles, ambulances, civil defense vehicles, and official government convoys using flashing lights and/or sirens have priority over all other traffic.

**Your legal duty:**
- Pull to the right side of the road as far as safely possible.
- Come to a complete stop if necessary to allow them to pass.
- Do not follow closely behind an emergency vehicle responding to a call.
- Do not enter an intersection if an emergency vehicle is approaching, even if your light is green.

**Real-world scenario:** You are stopped at a red light and hear a siren approaching from behind. You see an ambulance in your mirror. You may carefully move forward or to the side (if safe) to create a path, even if the light is still red.

## Section 9: Rule 8 – Exiting Private Property

**The rule:** Vehicles exiting private areas (garages, fuel stations, private driveways, farms, parking lots) must stop and check for traffic before entering the public road.

**Application:**
- You do not have priority when entering a road from private property.
- You must yield to all traffic already on the road.
- This applies even if there are no signs or markings at the exit.

## Section 10: Rule 9 – Organized Processions

**The rule:** Organized pedestrian groups have priority. This includes:
- School groups (students walking in an organized manner)
- Scout troops
- Military processions (on foot)
- Funeral processions
- Official marches or parades

**Your duty:** Stop and allow the entire procession to pass before proceeding.

## Section 11: The Golden Rule and Common Violations

### Golden Rule (Memorize This)
**Priority is given, not taken.**

You never have the "right" to force your way through an intersection. You have the legal priority, but you must still drive safely and avoid crashes even if another driver violates your priority.

### Common Priority Violations and Mistakes

1. **Rolling through stop signs:** A complete stop is legally required, not a slow roll.
2. **Entering roundabouts without yielding:** Drivers who speed into roundabouts cause crashes. Yield means wait.
3. **Blocking intersections:** Entering a congested intersection even though you cannot clear it before the light changes.
4. **Assuming right-of-way at four-way stops:** The right-hand rule applies, not first-come-first-served.
5. **Not yielding to pedestrians:** Pedestrians in marked crosswalks have priority.

**Real-world scenario:** You have a green light and approach an intersection. A car runs the red light from your left. You have priority, but if you continue without checking, you will crash. Always look even when you have the green.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (4, 'ar', N'#قواعد حق المرور عند التقاطعات والدوارات

تحدد قواعد حق الأولوية من يذهب أولاً عند التقاطعات والدوارات ومواقف المرور الأخرى. تمنع هذه القواعد الارتباك والتعطل. احفظهم بالكامل.

## القسم 1: النهج العام لأي تقاطع

قبل تطبيق قواعد محددة، اتبع روتين السلامة هذا عند كل تقاطع:

1. **تقليل السرعة** عند اقترابك، حتى لو كانت لديك الأولوية.
2. **اختر المسار الصحيح** مسبقًا باستخدام علامات وإشارات الطريق.
3. **قم بالإشارة إلى نيتك** باستخدام إشارات الانعطاف قبل 30 مترًا على الأقل من التقاطع.
4. **التحقق من وجود مستخدمي الطريق الآخرين** - المشاة وراكبي الدراجات وراكبي الدراجات النارية والمركبات الأخرى.
5. **لا تدخل** إذا كان التقاطع مزدحمًا بالفعل (قواعد شبكة الأمان).
6. **حافظ على وعي** بالمركبات التي خلفك والتي قد لا تتوقع منك التوقف.

## القسم 2: القاعدة 1 – قاعدة اليد اليمنى (التقاطعات ذات الأولوية المتساوية)

**متى ينطبق ذلك؟** عند التقاطعات التي لا توجد فيها إشارات مرور، أو إشارات مرور، أو علامات طريق تشير إلى طريق رئيسي.

**القاعدة:** المركبة القادمة من **يمينك** لها الأولوية عليك. يجب أن تستسلم لتلك السيارة.

**كيف يعمل في كل الاتجاهات:**
- إذا اقتربت من تقاطع طرق ورأيت مركبة قادمة من يمينك، فيجب عليك انتظار مرور تلك السيارة قبل المتابعة.
- السيارة التي على يسارك يجب أن تخضع لك.
- يؤدي هذا إلى إنشاء نظام أولوية ثابت في اتجاه عقارب الساعة.


**سيناريو العالم الحقيقي:** وصولك إلى تقاطع رباعي غير منضبط في منطقة سكنية. تقترب سيارة من يمينك في نفس الوقت. توقف واترك تلك السيارة تسير أولاً. بعد مروره، يمكنك المتابعة والتأكد من أن السيارة التي على يسارك تخضع لك أيضًا.

**خطأ شائع:** افتراض أن أول مركبة تصل تذهب أولاً. على الرغم من التهذيب، إلا أن هذه ليست القاعدة القانونية. قاعدة اليمين هي القانون، حتى لو وصلت أولاً.

## القسم 3: القاعدة 2 – أولوية الاتجاه المعاكس

**القاعدة:** عندما تقترب المركبات من اتجاهين متعاكسين وتنوي إحداهما الانعطاف يسارًا مقابل مسار الأخرى، تكون الأولوية للمركبة التي تسير بشكل مستقيم أو تنعطف يمينًا على المركبة التي تنعطف يسارًا.

**التطبيق:**
- تواجه مركبة قادمة عند تقاطع.
- تريد أن تستدير لليسار. تريد السيارة القادمة السير بشكل مستقيم أو الانعطاف إلى اليمين.
- السيارة القادمة لها الأولوية. يجب عليك الانتظار.
- وينطبق الشيء نفسه إذا كنت تريد السير بشكل مستقيم وكانت السيارة القادمة تريد الانعطاف يسارًا - فلديك الأولوية.


**السيناريو الواقعي:** أنت عند تقاطع طرق، تشير إلى اليسار. هناك سيارة قادمة تقترب بدون إشارة انعطاف (تسير في خط مستقيم). يجب عليك الانتظار حتى تجتاز تلك السيارة التقاطع قبل إكمال المنعطف الأيسر.

## القسم 4: القاعدة 3 – الطريق الرئيسي مقابل الطريق الثانوي

**القاعدة:** المركبات التي تسير على الطريق الرئيسي (المميزة بعلامات الأولوية) لها الأولوية على المركبات التي تدخل من الطرق الجانبية.

**التطبيق:**
- إذا كنت على الطريق الرئيسي (علامة الماسة الصفراء)، فيمكنك السير عبر التقاطعات دون توقف.
- يجب أن تخضع لك المركبات القادمة من الطرق الجانبية.
- إذا كنت تدخل من طريق فرعي، فيجب عليك مراعاة جميع حركة المرور على الطريق الرئيسي.

**تحذير:** حتى عندما تكون لديك الأولوية، كن مستعدًا دائمًا لخروج السائقين على الطرق الجانبية أمامك. القيادة الدفاعية تعني توقع الأخطاء.

## القسم 5: القاعدة 4 – أولوية الدوار

الدوارات (الدوائر المرورية) تحافظ على حركة المرور وتقلل من خطورة الحوادث مقارنة بالتقاطعات التقليدية عند استخدامها بشكل صحيح.

### القاعدة الأساسية
- **للمركبات الموجودة داخل الدوار الأولوية.**
- يجب على المركبات التي تنتظر الدخول أن تستسلم وتنتظر وجود فجوة آمنة في حركة المرور.

### اختيار المسار للدوارات

| الخروج المقصود | حارة الدخول | حارة للبقاء فيها |
|---------------|--------------|-----------------|
| المخرج الأول (الانعطاف لليمين) | المسار الأيمن | المسار الأيمن عبر الدوار |
| للأمام مباشرة (المخرج الثاني) | أي حارة (في حالة دخول حارتين) | ابقَ في مسارك عبر الدوار |
| انعطف يسارًا (المخرج الثالث أو ما بعده) | المسار الأيسر | المسار الأيسر حتى قرب المخرج، ثم الإشارة والتحرك للخروج |

### خطوات التنقل في الدوار

1. **الاقتراب:** قلل السرعة. اختر المسار الصحيح بناءً على مخرجك.
2. **الخضوع:** انظر إلى اليسار (في البلدان التي بها حركة مرور على الجانب الأيمن) واستسلم لحركة المرور الموجودة بالفعل في الدوار.
3. **أدخل:** عندما تظهر فجوة آمنة، قم بالدمج بسلاسة.
4. **التنقل:** ابق في حارتك. عدم تغيير المسارات داخل الدوار.
5. **إشارة الخروج:** استخدم إشارة الانعطاف لليمين قبل خروجك.
6. **الخروج:** اخرج بسلاسة، وتحقق من وجود مشاة عند معابر المشاة.

**الحركات المحظورة في الدوارات:**
- التوقف داخل الدوار (إلا لتجنب الاصطدام)
- تغيير المسارات
- التجاوز
- القيادة بجوار شاحنة أو حافلة كبيرة (ابق في الخلف أو أمامك، وليس بجانبها)

**سيناريو من العالم الحقيقي:** تقترب من الدوار وترى شاحنة بداخله بالفعل، وتسلك المسار الأيسر. أنت في المسار الأيمن وتريد السير بشكل مستقيم. تحجب الشاحنة رؤيتك لحركة المرور القادمة من اليسار. انتظر حتى تحصل على رؤية واضحة وفجوة آمنة - لا تفترض أن الدوار خالٍ لمجرد أنك لا تستطيع رؤية حركة المرور.

## القسم 6: القاعدة 5 – أولوية عبور السكك الحديدية

**القاعدة:** تتمتع القطارات دائمًا بالأولوية المطلقة على جميع مركبات الطرق.

**الاشتراطات عند معابر السكك الحديدية:**
- توقف عند إنزال البوابات أو وميض الأضواء.
- لا تتقدم إلا بعد أن يمر القطار بالكامل وترتفع البوابات بالكامل.
- عند المعابر التي ليس لها بوابات، توقف وانظر في الاتجاهين واستمع قبل العبور.

**تحذير بالغ الأهمية:** لا تتوقف أبدًا على خطوط السكك الحديدية. إذا كانت حركة المرور متوقفة عبر المعبر، فانتظر قبل المسارات حتى تتوفر مساحة على الجانب الآخر.

## القسم 7: القاعدة 6 – أولوية الوصلة T

**القاعدة:** الطريق الذي يستمر بشكل مستقيم (الطريق العابر) له الأولوية على الطريق الذي ينتهي (جذع حرف T).

**التطبيق:**
- إذا كنت على الطريق الذي ينتهي عند T، فيجب عليك إعطاء الأولوية لحركة المرور في أي اتجاه على الطريق المستمر.
- إذا كنت على الطريق المستمر، فلديك الأولوية على المركبات التي تدخل من الطريق النهائي.


## القسم 8: القاعدة 7 – مركبات الطوارئ والمركبات الرسمية

**القاعدة:** تتمتع مركبات الشرطة وسيارات الإسعاف ومركبات الدفاع المدني والقوافل الحكومية الرسمية التي تستخدم الأضواء الساطعة و/أو صفارات الإنذار بالأولوية على جميع حركة المرور الأخرى.

** واجبك القانوني: **
- اتجه إلى الجانب الأيمن من الطريق إلى أقصى حد ممكن بأمان.
- توقف تمامًا إذا لزم الأمر للسماح لهم بالمرور.
- لا تتابع عن كثب خلف سيارة الطوارئ التي تستجيب لمكالمة.
- لا تدخل إلى التقاطع إذا كانت هناك سيارة طوارئ تقترب، حتى لو كان ضوءك أخضر.

**سيناريو من العالم الحقيقي:** تتوقف عند إشارة حمراء وتسمع صفارة إنذار تقترب من الخلف. ترى سيارة إسعاف في مرآتك. يمكنك التحرك بعناية للأمام أو إلى الجانب (إذا كان آمنًا) لإنشاء مسار، حتى لو كان الضوء لا يزال أحمر.

## القسم 9: القاعدة 8 – الخروج من الملكية الخاصة

**القاعدة:** يجب على المركبات التي تخرج من المناطق الخاصة (الكراجات، محطات الوقود، الممرات الخاصة، المزارع، مواقف السيارات) التوقف والتحقق من حركة المرور قبل الدخول إلى الطريق العام.

**التطبيق:**
- ليس لك الأولوية عند دخول الطريق من ملكية خاصة.
- يجب عليك الخضوع لجميع حركة المرور الموجودة بالفعل على الطريق.
- وينطبق ذلك حتى لو لم تكن هناك علامات أو علامات عند المخرج.

## القسم 10: القاعدة 9 – المواكب المنظمة

**القاعدة:** مجموعات المشاة المنظمة لها الأولوية. وهذا يشمل:
- مجموعات المدرسة (الطلاب يسيرون بطريقة منظمة)
- القوات الكشفية
- مواكب عسكرية (سيراً على الأقدام)
- مواكب الجنازة
- المسيرات أو المسيرات الرسمية

** واجبك: ** التوقف والسماح للموكب بأكمله بالمرور قبل المتابعة.

## القسم الحادي عشر: القاعدة الذهبية والمخالفات الشائعة

### القاعدة الذهبية (احفظ هذا)
**الأولوية تعطى ولا تؤخذ**

ليس لديك أبدًا "الحق" في شق طريقك عبر التقاطع. لديك الأولوية القانونية، ولكن لا يزال يتعين عليك القيادة بأمان وتجنب الاصطدامات حتى لو انتهك سائق آخر أولويتك.

### الانتهاكات والأخطاء الشائعة ذات الأولوية

1. **التدحرج عبر إشارات التوقف:** التوقف الكامل مطلوب قانونيًا، وليس التدحرج البطيء.
2. **الدخول إلى الدوارات دون مغادرة الطريق:** يتسبب السائقون الذين يدخلون الدوارات بسرعة في وقوع حوادث. العائد يعني الانتظار.
3. **سد التقاطعات:** الدخول إلى تقاطع مزدحم حتى لو لم تتمكن من إزالته قبل أن يتغير الضوء.
4. **بافتراض حق الأولوية عند التوقفات ذات الاتجاهات الأربعة:** تنطبق قاعدة اليد اليمنى، وليس أسبقية الحضور.
5. **عدم الاستسلام للمشاة:** للمشاة الموجودين في ممرات المشاة المحددة الأولوية.

**سيناريو العالم الحقيقي:** لديك ضوء أخضر وتقترب من التقاطع. سيارة تدير الضوء الأحمر من يسارك. لديك الأولوية، ولكن إذا تابعت دون التحقق، فسوف تتعطل. انظر دائمًا حتى عندما يكون لديك اللون الأخضر.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (5, 'en', N'# Lane Discipline, Turning, and Overtaking

Proper lane positioning, correct turning procedures, and safe overtaking are essential skills that prevent crashes and keep traffic flowing smoothly.

## Section 1: The Keep Right Rule

In Jordan (right-hand traffic), all drivers must keep to the right side of the road except when overtaking or turning left.

### When to Move to the Right
- You want to turn right at an upcoming intersection
- You are driving slower than surrounding traffic and vehicles behind want to overtake
- You approach a curve or hill crest (right position gives better view)
- Emergency vehicles approach from behind

### Multi-Lane Roads
- Slower vehicles use the **rightmost lane**
- Middle lanes for moderate speeds
- Left lane(s) for passing or faster traffic
- **Do not cruise in the left lane** – it blocks traffic and encourages dangerous passing on the right


## Section 2: Proper Turning Procedures

### Turning Right

**Procedure:**
1. Position your vehicle in the **rightmost lane** well before the intersection.
2. Check your right mirror and blind spot for cyclists, pedestrians, or vehicles.
3. Activate your right turn signal at least 30 meters before the turn.
4. Reduce speed as you approach.
5. Turn from the rightmost lane into the rightmost lane of the cross street.
6. Complete the turn at a safe speed (typically 15–25 km/h).

**Common mistakes:**
- Swinging wide to the left before turning right
- Turning from the middle lane
- Failing to check for cyclists in the blind spot

### Turning Left

**On two-way roads with one lane each direction:**
- Move to the **right side** of your lane (not the center)
- Signal left
- Wait for oncoming traffic to clear
- Turn left only when safe and without blocking oncoming traffic

**On divided roads or roads with multiple lanes:**
- Use the **leftmost lane** designated for left turns
- If no dedicated left-turn lane, position near the center line
- Wait for oncoming traffic or a green arrow

**On one-way streets:**
- Turn left from the **leftmost lane**


**Critical rule:** When turning left at an intersection without a dedicated arrow, you must yield to all oncoming traffic going straight or turning right. Do not assume oncoming drivers will stop for you.

### U-Turns (Turning to Opposite Direction)

**Legally permitted only when:**
- No "No U-turn" sign is posted
- The road is not one-way
- You can complete the turn without blocking traffic or creating a hazard
- Visibility is clear in both directions
- You are not on a curve, near a hill crest, or near a railroad crossing

**Procedure:**
1. Move to the leftmost lane (or as far left as possible)
2. Signal left
3. Check mirrors and blind spot
4. Wait for a safe gap in both directions (oncoming traffic and traffic behind)
5. Turn quickly but smoothly when safe

**Important:** You **lose your right-of-way** when making a U-turn. You must yield to all other vehicles and pedestrians.

**Prohibited U-turn locations (even without a sign):**
- At curves or on hill crests (limited visibility)
- Within 150 meters of a railroad crossing
- Where you would block traffic or create danger

## Section 3: Roundabout Lane Discipline (Detailed)

### Two-Lane Roundabout Navigation

| Desired Exit | Entry Lane | Position in Roundabout | Exit |
|--------------|------------|------------------------|------|
| First exit (right turn) | Right lane | Right lane | Right lane of exit road |
| Second exit (straight) | Either lane | Stay in your lane | Appropriate lane of exit |
| Third exit (left turn) | Left lane | Left lane until past second exit | Right lane of exit after signaling |

**Critical rule:** You must exit from the same lane you entered relative to the exit road. If you enter from the left lane and want to take the third exit, you stay in the left lane until you pass the exit before yours, then signal and move to the right lane to exit.


## Section 4: Lane Changing Procedures

**Safe lane change steps:**

1. **Mirror check:** Check your interior mirror and side mirror on the side you intend to move.
2. **Signal:** Activate your turn signal for at least 3 seconds before moving.
3. **Blind spot check:** Turn your head to physically check the blind spot (area not visible in mirrors).
4. **Move gradually:** Change lanes smoothly, not abruptly.
5. **Cancel signal:** Turn off signal after completing the lane change.
6. **Maintain speed:** Do not slow down unnecessarily when changing lanes.

**Never change lanes:**
- Across a solid white or yellow line
- In an intersection
- On a curve or hill crest with limited visibility
- When it would force another driver to brake suddenly


## Section 5: Overtaking Rules and Procedures

Overtaking means passing a moving or stationary vehicle or obstacle on the road.

### Where to Overtake

**Standard rule:** Always overtake on the **left side** of the vehicle ahead.

**Exceptions (overtake on right allowed when):**
- The vehicle ahead is signaling and preparing to turn left
- On multi-lane roads where lanes are separated and traffic is moving at different speeds (e.g., slower traffic in right lane)

### Safe Overtaking Procedure

1. **Check ahead:** Ensure the road is clear for enough distance to complete the overtake safely. For highway speeds, you need at least 300–400 meters of clear road ahead.
2. **Check behind:** Check interior mirror, side mirror, and blind spot to ensure no vehicle is already overtaking you.
3. **Signal:** Signal left to indicate your intention.
4. **Move out:** Pull into the overtaking lane, maintaining a safe side distance (at least 1.5 meters) from the vehicle you are passing.
5. **Complete quickly:** Accelerate to complete overtaking promptly but safely. Do not linger alongside the other vehicle.
6. **Signal right:** Before returning to your lane, signal right.
7. **Return safely:** Move back to your lane only when you can see the overtaken vehicle completely in your interior mirror (meaning you have at least a 2-second gap ahead of it).
8. **Cancel signal:** Turn off signal after returning to lane.

### Prohibited Overtaking Situations (Memorize)

You must **NEVER** overtake in these situations:

**Visibility-related:**
- On curves where you cannot see far enough ahead
- On hill crests (approaching the top of a rise)
- In fog, heavy rain, dust storms, or any low-visibility condition

**Infrastructure-related:**
- Near pedestrian crosswalks or within 30 meters of one
- Near intersections or railroad crossings
- On bridges or in tunnels
- Where signs or solid lines prohibit overtaking

**Traffic-related:**
- When a line of vehicles is stopped (traffic jam or red light)
- When the vehicle ahead is already overtaking
- When a vehicle behind has already started overtaking you
- When traffic does not allow safe completion
- When the vehicle ahead signals (with left turn signal or hand) not to overtake
- Near stopped buses or passenger vehicles where passengers may be crossing the road

**Surface-related:**
- On slippery roads (rain, ice, snow, gravel, oil)

### Responsibilities of the Driver Being Overtaken

If another vehicle is overtaking you:
- Keep as far right as safely possible
- Do **NOT** increase your speed – this is illegal and dangerous
- Reduce speed slightly if needed to allow the overtaking vehicle to complete the maneuver safely
- Do not move left to block the overtaking vehicle

**Heavy/Slow vehicles:** If you drive a heavy or slow vehicle and traffic is building behind you with no safe overtaking opportunity, pull over at the first safe location to let others pass.

### Side Wind Effect During Overtaking

When overtaking or being overtaken by large vehicles (trucks, buses):
- Strong air displacement can push smaller vehicles sideways
- Keep both hands firmly on the steering wheel
- Anticipate the push and be ready to steer against it
- Do not brake suddenly when a truck passes – maintain steady speed


## Section 6: Common Lane and Overtaking Violations

| Violation | Danger | Penalty Severity |
|-----------|--------|------------------|
| Crossing solid line to overtake | Head-on collision risk | Severe |
| Overtaking on the right on a two-lane road | Blind spot collisions | Moderate to severe |
| Cutting back too soon after overtaking | Rear-end or sideswipe crash | Moderate |
| Overtaking at a pedestrian crossing | Pedestrian death or injury | Severe |
| Blocking the left lane while driving slowly | Encourages dangerous passes | Minor (but dangerous) |

**Real-world scenario:** You are driving on a two-lane rural road with a broken line on your side. You check ahead and see a curve approaching but it is still 500 meters away. You begin to overtake a slow truck. As you pull alongside, you realize the curve is closer than you thought and you cannot see around it. You abort the overtake, drop back behind the truck, and wait for a clearer stretch. This is the correct safe decision.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (5, 'ar', N'# انضباط المسار والانعطاف والتجاوز

يعد تحديد الموقع الصحيح للمسار وإجراءات الانعطاف الصحيحة والتجاوز الآمن من المهارات الأساسية التي تمنع الاصطدامات وتحافظ على تدفق حركة المرور بسلاسة.

## القسم 1: قاعدة الحفاظ على الحق

في الأردن (حركة المرور على اليمين)، يجب على جميع السائقين الالتزام بالجانب الأيمن من الطريق إلا عند التجاوز أو الانعطاف إلى اليسار.

### متى يجب التحرك إلى اليمين
- تريد الانعطاف يمينًا عند تقاطع قادم
- أنت تقود بسرعة أبطأ من حركة المرور المحيطة والمركبات التي خلفك تريد التجاوز
- أنت تقترب من منحنى أو قمة التل (الوضع الصحيح يعطي رؤية أفضل)
- اقتراب سيارات الطوارئ من الخلف

### طرق متعددة الحارات
- تستخدم المركبات الأبطأ **المسار الموجود في أقصى اليمين**
- الممرات الوسطى للسرعات المعتدلة
- المسار (الحارات) اليسرى للمرور أو حركة المرور الأسرع
- **لا تتجول في المسار الأيسر** - فهذا يعيق حركة المرور ويشجع على المرور الخطير على اليمين


## القسم الثاني: إجراءات الدوران الصحيحة

### الانعطاف إلى اليمين

**الإجراء:**
1. ضع سيارتك في **المسار الأقصى الأيمن** قبل التقاطع بوقت طويل.
2. تحقق من المرآة اليمنى والنقطة العمياء لراكبي الدراجات أو المشاة أو المركبات.
3. قم بتنشيط إشارة الانعطاف اليمنى قبل 30 مترًا على الأقل من الانعطاف.
4. خفف السرعة عند اقترابك.
5. انعطف من المسار الموجود في أقصى اليمين إلى المسار الموجود في أقصى يمين التقاطع.
6. أكمل المنعطف بسرعة آمنة (عادةً 15-25 كم/ساعة).

**أخطاء شائعة:**
- التأرجح على نطاق واسع إلى اليسار قبل الانعطاف إلى اليمين
- الانعطاف من المسار الأوسط
- عدم التحقق من وجود راكبي الدراجات في النقطة العمياء

### التحول إلى اليسار

**على الطرق ذات الاتجاهين بحارة واحدة في كل اتجاه:**
- انتقل إلى **الجانب الأيمن** من حارتك (وليس الوسط)
- إشارة اليسار
- انتظر حتى تختفي حركة المرور القادمة
- انعطف يسارًا فقط عندما يكون ذلك آمنًا ودون عرقلة حركة المرور القادمة

**على الطرق المقسمة أو الطرق ذات الممرات المتعددة:**
- استخدم **المسار الموجود في أقصى اليسار** المخصص للانعطاف إلى اليسار
- إذا لم يكن هناك حارة مخصصة للانعطاف إلى اليسار، فكن بالقرب من الخط الأوسط
- انتظر حركة المرور القادمة أو السهم الأخضر

**في الشوارع ذات الاتجاه الواحد:**
- انعطف يسارًا من **المسار الموجود في أقصى اليسار**


**قاعدة حاسمة:** عند الانعطاف يسارًا عند تقاطع طرق بدون سهم مخصص، يجب عليك إعطاء الأولوية لجميع حركة المرور القادمة التي تسير بشكل مستقيم أو تنعطف يمينًا. لا تفترض أن السائقين القادمين سيتوقفون من أجلك.

### المنعطفات على شكل حرف U (الانعطاف في الاتجاه المعاكس)

**مسموح به قانونًا فقط عندما:**
- عدم وضع لافتة "ممنوع الدوران على شكل حرف U".
- الطريق ليس ذو اتجاه واحد
- يمكنك إكمال المنعطف دون عرقلة حركة المرور أو خلق خطر
- الرؤية واضحة في كلا الاتجاهين
- أنت لست على منحنى، بالقرب من قمة التل، أو بالقرب من معبر للسكك الحديدية

**الإجراء:**
1. انتقل إلى أقصى اليسار (أو إلى أقصى اليسار قدر الإمكان)
2. إشارة اليسار
3. فحص المرايا والنقطة العمياء
4. انتظر وجود فجوة آمنة في كلا الاتجاهين (حركة المرور القادمة وحركة المرور الخلفية)
5. انعطف بسرعة ولكن بسلاسة عندما يكون الأمر آمنًا

**هام:** أنت **تفقد حق المرور** عند القيام بالانعطاف على شكل حرف U. يجب عليك الخضوع لجميع المركبات والمشاة الآخرين.

**مواقع الدوران المحظورة (حتى بدون وجود علامة):**
- عند المنحنيات أو على قمم التلال (رؤية محدودة)
- على مسافة 150 مترًا من معبر السكة الحديد
- حيث من شأنه أن يمنع حركة المرور أو يخلق خطرا

## القسم 3: الانضباط في حارة الدوار (مفصل)

### الملاحة في الدوار ذو المسارين

| الخروج المرغوب | حارة الدخول | الموقع في الدوار | خروج |
|--------------|-----------|-----------------------|------|
| المخرج الأول (الانعطاف لليمين) | المسار الأيمن | المسار الأيمن | المسار الأيمن لطريق الخروج |
| المخرج الثاني (مستقيم) | إما حارة | خليك في حارتك | حارة الخروج المناسبة |
| المخرج الثالث (الانعطاف يسارًا) | المسار الأيسر | المسار الأيسر حتى المخرج الثاني الماضي | حارة الخروج اليمنى بعد الإشارة |

**قاعدة حاسمة:** يجب عليك الخروج من نفس المسار الذي دخلت فيه بالنسبة لطريق الخروج. إذا دخلت من المسار الأيسر وتريد أن تسلك المخرج الثالث، فابق في المسار الأيسر حتى تتجاوز المخرج الذي يسبقك، ثم قم بالإشارة وانتقل إلى المسار الأيمن للخروج.


## القسم الرابع: إجراءات تغيير المسار

**خطوات تغيير المسار الآمن:**

1. **فحص المرآة:** تحقق من المرآة الداخلية والمرآة الجانبية على الجانب الذي تنوي تحريكه.
2. **الإشارة:** قم بتنشيط إشارة الانعطاف لمدة 3 ثوانٍ على الأقل قبل التحرك.
3. **فحص النقطة العمياء:** أدر رأسك لتفحص النقطة العمياء فعليًا (المنطقة غير المرئية في المرايا).
4. **تحرك تدريجيًا:** قم بتغيير الممرات بسلاسة، وليس بشكل مفاجئ.
5. **إلغاء الإشارة:** قم بإيقاف تشغيل الإشارة بعد الانتهاء من تغيير المسار.
6. **حافظ على السرعة:** لا تبطئ السرعة دون داعٍ عند تغيير المسارات.

**لا تغير المسار أبدًا:**
- عبر خط أبيض أو أصفر متصل
- في تقاطع
- على منحنى أو قمة تل مع رؤية محدودة
- عندما يؤدي ذلك إلى إجبار سائق آخر على استخدام المكابح فجأة


## القسم الخامس: قواعد وإجراءات التجاوز

التجاوز يعني تجاوز مركبة متحركة أو متوقفة أو عائق على الطريق.

### مكان التجاوز

**القاعدة القياسية:** يجب التجاوز دائمًا من **الجانب الأيسر** من السيارة التي أمامك.

**الاستثناءات (يُسمح بالتجاوز على اليمين عندما):**
- السيارة التي أمامك تطلق الإشارة وتستعد للانعطاف إلى اليسار
- على الطرق متعددة الحارات حيث تكون الحارات مفصولة وتتحرك حركة المرور بسرعات مختلفة (على سبيل المثال، حركة مرور أبطأ في الحارة اليمنى)

### إجراءات التجاوز الآمنة

1. **التحقق مسبقًا:** تأكد من أن الطريق خالٍ لمسافة كافية لإكمال التجاوز بأمان. بالنسبة لسرعات الطرق السريعة، تحتاج إلى ما لا يقل عن 300-400 متر من الطريق الخالي أمامك.
2. **تحقق من الخلف:** تحقق من المرآة الداخلية، والمرآة الجانبية، والنقطة العمياء للتأكد من عدم تجاوزك لأي مركبة بالفعل.
3. **الإشارة:** قم بالإشارة إلى اليسار للإشارة إلى نيتك.
4. **الخروج:** ادخل إلى حارة التجاوز، وحافظ على مسافة جانبية آمنة (1.5 متر على الأقل) من السيارة التي تمر بها.
5. **أكمل بسرعة:** قم بالتسريع لإكمال التجاوز بسرعة ولكن بأمان. لا تبقى بجانب السيارة الأخرى.
6. **أشر لليمين:** قبل العودة إلى حارتك، أشر لليمين.
7. **العودة بأمان:** لا ترجع إلى مسارك إلا عندما تتمكن من رؤية السيارة التي تم تجاوزها بالكامل في المرآة الداخلية (مما يعني أن أمامك مسافة ثانيتين على الأقل).
8. **إلغاء الإشارة:** قم بإيقاف تشغيل الإشارة بعد العودة إلى المسار.

### مواقف التجاوز المحظورة (حفظ)

لا يجوز لك **أبدًا** التجاوز في هذه المواقف:

**متعلق بالرؤية:**
- على المنحنيات حيث لا يمكنك رؤية مسافة كافية أمامك
- على قمم التلال (تقترب من قمة المرتفع)
- في حالة الضباب والأمطار الغزيرة والعواصف الترابية أو أي حالة انخفاض الرؤية

**متعلق بالبنية التحتية:**
- بالقرب من ممرات المشاة أو على بعد 30 مترًا منها
- بالقرب من التقاطعات أو معابر السكك الحديدية
- على الجسور أو في الأنفاق
- في حالة وجود علامات أو خطوط متصلة تمنع التجاوز

**متعلق بحركة المرور:**
- عند توقف خط من المركبات (ازدحام مروري أو ضوء أحمر)
- عندما تكون السيارة التي أمامك قد تجاوزت بالفعل
- عندما تكون المركبة التي خلفك قد بدأت بالفعل في تجاوزك
- عندما لا تسمح حركة المرور بالإكمال الآمن
- عندما تعطي السيارة التي أمامك إشارة (بإشارة الانعطاف اليسرى أو اليد) بعدم التجاوز
- بالقرب من الحافلات أو مركبات الركاب المتوقفة حيث قد يعبر الركاب الطريق

** المتعلقة بالسطح: **
- على الطرق الزلقة (المطر، الجليد، الثلج، الحصى، النفط)

### مسؤوليات السائق الذي يتم تجاوزه

إذا تجاوزتك مركبة أخرى:
- حافظ على أقصى اليمين قدر الإمكان بأمان
- لا **لا** تزيد من سرعتك – فهذا أمر غير قانوني وخطير
- خفف السرعة قليلاً إذا لزم الأمر للسماح للمركبة المتجاوزة بإكمال المناورة بأمان
- لا تتحرك يسارًا لعرقلة السيارة المتجاوزة

**المركبات الثقيلة/البطيئة:** إذا كنت تقود مركبة ثقيلة أو بطيئة وكانت حركة المرور تتزايد خلفك دون وجود فرصة آمنة للتجاوز، توقف عند أول مكان آمن للسماح للآخرين بالمرور.

### تأثير الرياح الجانبية أثناء التجاوز

عند التجاوز أو تجاوز المركبات الكبيرة (الشاحنات والحافلات):
- إزاحة الهواء القوية يمكن أن تدفع المركبات الصغيرة إلى الجانب
- ضع كلتا يديك بقوة على عجلة القيادة
- توقع الدفع وكن مستعدًا للتوجه ضده
- لا تستخدم المكابح فجأة عندما تمر شاحنة - حافظ على سرعة ثابتة


## القسم السادس: مخالفات المسار المشترك والتجاوز

| المخالفة | خطر | شدة العقوبة |
|-----------|-------|-----------------|
| عبور الخط الصلب للتجاوز | خطر الاصطدام وجها لوجه | شديد |
| التجاوز من اليمين على طريق ذو مسارين | تصادمات النقطة العمياء | معتدلة إلى شديدة |
| التقليص بعد وقت قصير جدًا من التجاوز | تحطم النهاية الخلفية أو المسح الجانبي | معتدل |
| التجاوز عند معبر المشاة | وفاة أو إصابة أحد المشاة | شديد |
| قطع المسار الأيسر أثناء القيادة ببطء | يشجع التمريرات الخطيرة | بسيطة (ولكنها خطيرة) |

**سيناريو من العالم الحقيقي:** أنت تقود سيارتك على طريق ريفي مكون من حارتين مع وجود خط متقطع على جانبك. قمت بالتحقق للأمام ورأيت منحنى يقترب ولكنه لا يزال على بعد 500 متر. تبدأ في تجاوز شاحنة بطيئة. عندما تسير بجانبك، تدرك أن المنحنى أقرب مما كنت تعتقد ولا يمكنك الرؤية حوله. تقوم بإلغاء التجاوز، وتعود خلف الشاحنة، وتنتظر مسافة أكثر وضوحًا. هذا هو القرار الآمن الصحيح.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (6, 'en', N'# Speed Limits, Following Distance, and Stopping Safely

Speed management and safe following distances are the most critical factors in preventing crashes. Even if you break no other rule, driving at appropriate speeds with adequate space ahead prevents most collisions.

## Section 1: Understanding Stopping Distance

Your total stopping distance = Reaction Distance + Braking Distance

**Reaction distance:** The distance your vehicle travels from the moment you see a hazard to the moment you apply the brakes. For an alert driver, reaction time is approximately 0.75 to 1 second.

**Braking distance:** The distance your vehicle travels from brake application to complete stop. This varies dramatically with speed, road conditions, tire quality, and brake condition.

### Example: Stopping Distance at Different Speeds (Dry Road)

| Speed | Reaction Distance | Braking Distance | Total Stopping Distance |
|-------|------------------|------------------|------------------------|
| 30 km/h | 8 meters | 6 meters | 14 meters |
| 50 km/h | 14 meters | 17 meters | 31 meters |
| 70 km/h | 19 meters | 33 meters | 52 meters |
| 90 km/h | 25 meters | 55 meters | 80 meters |
| 110 km/h | 31 meters | 82 meters | 113 meters |

**Real-world implication:** At 110 km/h, you need more than the length of a football field to stop. If you follow closely at that speed, you will crash if the vehicle ahead stops suddenly.

## Section 2: Speed Limits in Jordan

### General Rules
- Do not exceed the maximum posted speed limit.
- Do not drive below the minimum speed if posted (usually on highways).
- Speed must always be appropriate for **conditions** – weather, traffic density, road surface condition, vehicle load, and visibility. A safe speed may be well below the posted limit in poor conditions.

### When to Reduce Speed Below the Limit
- Residential areas with children playing
- Poor visibility (fog, heavy rain, night without streetlights)
- Near schools during drop-off and pick-up times
- Approaching pedestrian crosswalks
- Curves, hills, intersections
- Areas with animals crossing (sheep, goats, camels)
- Construction or work zones

### Urban Roads (Inside City/Town Limits)

| Road Type | Private Cars & Light Trucks (≤2 tons) | Buses & Heavy Trucks |
|-----------|---------------------------------------|----------------------|
| Multi-lane divided roads (2+ lanes each direction with median) | 90 km/h | 80 km/h |
| Two-way undivided roads | 70 km/h | 70 km/h |
| Near schools and local/residential roads | 40 km/h | 40 km/h |

### Rural Roads (Outside City/Town Limits)

| Road Type | Private Cars & Light Trucks (≤2 tons) | Other Vehicles |
|-----------|---------------------------------------|----------------|
| Multi-lane divided highways | 110 km/h | 100 km/h |
| Two-way undivided roads | 110 km/h | 100 km/h |
| Secondary and agricultural roads | Lower limits as posted | Lower limits as posted |

### Minimum Speed
While Jordanian law does not specify a universal minimum speed number, driving unreasonably slow without cause (e.g., driving 40 km/h on a 90 km/h highway with no mechanical issue or weather problem) is a traffic violation that obstructs traffic flow and creates dangerous conditions.

### Speeding Penalties (Summary)

| Excess Over Limit | Penalty |
|-------------------|---------|
| More than 50 km/h over limit | Jail (2 weeks to 3 months) OR fine (100 JD), plus license impoundment |
| 31–50 km/h over limit | Fine 30 JD |
| 11–30 km/h over limit | Fine 20 JD |

## Section 3: The Two-Second Rule (Following Distance)

The two-second rule provides a safe following distance in good conditions.

### How to Apply the Two-Second Rule

1. Watch for the vehicle ahead to pass a fixed object (sign, tree, bridge, road marking).
2. As the rear of that vehicle passes the object, begin counting: "one-thousand-one, one-thousand-two".
3. If you reach the object before finishing "one-thousand-two", you are following too closely. Increase your distance and repeat.


### When to Use Three Seconds or More

Apply the **three-second rule** (or greater) in these situations:

- **Wet roads** (rain, standing water)
- **Poor tire condition** (worn tread)
- **Poor brake condition**
- **Heavy vehicle load** (passengers or cargo)
- **Night driving** (reduced visibility)
- **Following motorcycles or trucks** (motorcycles stop faster than cars; trucks block view ahead)
- **Driver fatigue or stress**
- **Slippery surfaces** (gravel, snow, ice, loose stones)

### Following Distance for Heavy Vehicles

If you drive a truck, bus, or heavy vehicle, always use the **three-second rule as your minimum**, even in good weather. Heavy vehicles require longer stopping distances.

### What Distance Is "Two Seconds" in Meters?

As a rough guide:
- At 50 km/h: 2 seconds = approximately 28 meters (about 4 car lengths)
- At 80 km/h: 2 seconds = approximately 44 meters (about 7 car lengths)
- At 110 km/h: 2 seconds = approximately 61 meters (about 10 car lengths)

### Stopping Distance Relationship
At 45 km/h, a small car needs a distance longer than **six times its own length** to stop completely.

**Real-world scenario:** You are driving at 90 km/h on a divided highway in light rain. You apply the three-second rule for safety. Suddenly, the vehicle ahead brakes hard and stops for a stalled car. Your three-second gap gives you enough time to react and stop safely. If you had followed at one second, you would crash.

## Section 4: Stopping and Parking Rules

### Definitions

- **Stopping (Tawaqquf):** Temporarily stopping for traffic reasons (red light, stop sign, congestion), boarding or alighting passengers, or loading/unloading goods. Brief and driver remains in vehicle.
- **Parking (Wuquf):** Leaving the vehicle stationary for any non-temporary reason. Driver may exit the vehicle.

### Where Parking AND Stopping Are Prohibited

| Location | Why Prohibited |
|----------|----------------|
| On pedestrian crosswalks or sidewalks | Blocks pedestrian access |
| On bicycle lanes | Endangers cyclists |
| On railway tracks or too close to them | Train collision risk |
| On bridges, tunnels, or overpasses (unless designated parking areas) | Blocks traffic; collision risk |
| Within 15 meters of an intersection, curve, or hill crest | Blocks visibility for other drivers |
| Double parking (parallel next to a parked car) | Blocks traffic lane |
| Within 10 meters before or after a pedestrian crossing | Blocks view of crossing pedestrians |
| In a roundabout | Extremely dangerous |
| On driveways of public/private parking entrances | Blocks access |

### Parallel Parking Procedure

Parallel parking is a required skill for the practical driving test.

**Step-by-step:**
1. Signal your intention and position your vehicle parallel to the front vehicle, approximately 0.5 meters (1.5 feet) away from it.
2. Check mirrors and blind spot for approaching traffic. Wait for a gap.
3. Turn steering wheel fully toward the curb (right in Jordan).
4. Reverse slowly. Watch your right mirror to see the curb and the rear vehicle.
5. When your front bumper passes the rear bumper of the front vehicle (or when you are at approximately a 45-degree angle), turn steering wheel fully away from the curb (left).
6. Continue reversing until your vehicle is close to the rear vehicle (about 0.5 meters gap).
7. Turn steering wheel back toward the curb (right) to straighten your wheels and center your vehicle between the two vehicles.
8. Adjust forward or backward as needed to center the vehicle.

## Section 5: Emergency Stoppage (Breakdown)

### If Your Vehicle Breaks Down

1. **Move off the road** as soon as safely possible. Use momentum if the engine has died.
2. **Choose a safe spot** – away from curves, hill crests, or intersections.
3. **Turn on hazard lights** (four-way flashers) immediately.
4. **Place the reflective triangle:**
   - On rural roads: At least **100 meters before** your vehicle (not after)
   - On urban roads: At least **50 meters before** your vehicle
   - On curves: Place the triangle before the curve so approaching drivers see it in advance
5. **At night or low visibility:** Keep parking lights on in addition to hazard lights.
6. **Do NOT stand between your vehicle and oncoming traffic.** Stand behind a barrier or well off the road.
7. **Call for help** using your mobile phone or emergency roadside telephone.

### If You Have a Disability or Cannot Exit Safely

- Stay inside your vehicle with seatbelt fastened
- Keep hazard lights on
- Display a "help" sign in your window if available
- Call for assistance using your phone
- Wait for help to arrive

### Reflective Triangle Requirements

- Equilateral triangle shape
- Minimum side length: 45 cm (18 inches)
- Reflective material on surface
- Must be placed on the road surface or on a stand at road level

### Vehicles Prohibited from Overnight Parking Inside Residential Areas

- Vehicles over 7.5 tons gross weight (large trucks, heavy buses)
- Agricultural and construction vehicles (tractors, excavators, bulldozers) on main residential streets

These vehicles may be permitted in designated truck parking areas or industrial zones.

## Section 6: Emergency Braking Techniques

### For Vehicles Without ABS (Anti-lock Brakes)
- Apply brakes firmly but do **not** lock the wheels.
- If wheels lock (you hear screeching and lose steering), **pump the brakes** – release slightly and reapply.
- Cadence braking: Apply, release slightly, apply again rapidly.

### For Vehicles With ABS
- Apply brakes **firmly and continuously**.
- Do NOT pump the brakes – ABS pumps automatically.
- You may feel pulsing through the brake pedal – this is normal.
- Maintain steering control; ABS allows you to steer while braking hard.

### In Wet or Slippery Conditions
- Brake earlier and more gently than on dry roads.
- Increase following distance significantly.
- Avoid braking while turning – brake before entering curves.

**Real-world scenario:** A child runs into the street 30 meters ahead of you while you are traveling at 60 km/h. You have approximately 1.8 seconds to react and stop. At 60 km/h, your total stopping distance on dry pavement is approximately 45 meters – you will stop just in time. On wet pavement, stopping distance nearly doubles. Your speed must be lower in rain to stop safely for unexpected hazards.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (6, 'ar', N'# حدود السرعة ومسافة التتبع والتوقف الآمن

تعد إدارة السرعة ومسافات التتبع الآمنة من أهم العوامل الحاسمة في منع الاصطدامات. حتى لو لم تخالف أي قاعدة أخرى، فإن القيادة بسرعات مناسبة مع وجود مساحة كافية أمامك تمنع معظم حوادث الاصطدام.

## القسم الأول: فهم مسافة التوقف

مسافة التوقف الإجمالية = مسافة رد الفعل + مسافة الكبح

**مسافة رد الفعل:** المسافة التي تقطعها سيارتك من لحظة رؤية الخطر إلى لحظة استخدام الفرامل. بالنسبة للسائق المنبه، يكون وقت رد الفعل حوالي 0.75 إلى ثانية واحدة.

**مسافة الفرملة:** المسافة التي تقطعها سيارتك منذ استخدام الفرامل حتى التوقف التام. ويختلف هذا بشكل كبير حسب السرعة وظروف الطريق وجودة الإطارات وحالة الفرامل.

### مثال: مسافة التوقف بسرعات مختلفة (الطريق الجاف)

| السرعة | مسافة رد الفعل | مسافة الكبح | مسافة التوقف الإجمالية |
|-------|------------------|------------------|-----------------------|
| 30 كم/ساعة | 8 متر | 6 متر | 14 متر |
| 50 كم/ساعة | 14 متر | 17 متر | 31 متر |
| 70 كم/ساعة | 19 متر | 33 متر | 52 متر |
| 90 كم/ساعة | 25 متر | 55 متر | 80 متر |
| 110 كم/ساعة | 31 متر | 82 متر | 113 متر |

**الآثار الواقعية:** عند سرعة 110 كم/ساعة، تحتاج إلى أكثر من طول ملعب كرة قدم للتوقف. إذا تابعت عن كثب بهذه السرعة، فسوف تصطدم إذا توقفت السيارة أمامك فجأة.

## القسم الثاني: حدود السرعة في الأردن

### القواعد العامة
- لا تتجاوز الحد الأقصى للسرعة المعلنة.
- لا تقود السيارة بأقل من الحد الأدنى للسرعة إذا تم نشرها (عادةً على الطرق السريعة).
- يجب أن تكون السرعة مناسبة دائمًا **للظروف** - الطقس، وكثافة حركة المرور، وحالة سطح الطريق، وحمولة السيارة، والرؤية. قد تكون السرعة الآمنة أقل بكثير من الحد المعلن في الظروف السيئة.

### متى يجب تقليل السرعة إلى ما دون الحد الأقصى
- المناطق السكنية التي يلعب فيها الأطفال
- ضعف الرؤية (ضباب، أمطار غزيرة، ليل بدون إنارة الشوارع)
- بالقرب من المدارس أثناء أوقات التوصيل والتوصيل
- الاقتراب من ممرات المشاة
- المنحنيات والتلال والتقاطعات
- مناطق عبور الحيوانات (الأغنام والماعز والإبل)
- مناطق البناء أو العمل

### الطرق الحضرية (داخل حدود المدينة/البلدة)

| نوع الطريق | السيارات الخاصة والشاحنات الخفيفة (2 طن) | أتوبيسات وشاحنات ثقيلة |
|-----------|------------------------------------------------------||------|
| طرق مقسمة متعددة الحارات (أكثر من حارتين في كل اتجاه مع وسط) | 90 كم/ساعة | 80 كم/ساعة |
| طرق ذات اتجاهين غير مقسمة | 70 كم/ساعة | 70 كم/ساعة |
| بالقرب من المدارس والطرق المحلية/السكنية | 40 كم/ساعة | 40 كم/ساعة |

### الطرق الريفية (خارج حدود المدينة/البلدة)

| نوع الطريق | السيارات الخاصة والشاحنات الخفيفة (2 طن) | مركبات أخرى |
|-----------|-----------------------------------------------------||----------------|
| طرق سريعة مقسمة متعددة الحارات | 110 كم/ساعة | 100 كم/ساعة |
| طرق ذات اتجاهين غير مقسمة | 110 كم/ساعة | 100 كم/ساعة |
| طرق ثانوية وزراعية | الحدود الدنيا كما نشرت | الحدود الدنيا كما نشرت |

### الحد الأدنى للسرعة
في حين أن القانون الأردني لا يحدد الحد الأدنى العالمي للسرعة، فإن القيادة ببطء غير معقول دون سبب (على سبيل المثال، القيادة بسرعة 40 كم / ساعة على طريق سريع بسرعة 90 كم / ساعة دون وجود مشكلة ميكانيكية أو مشكلة الطقس) تعتبر مخالفة مرورية تعيق تدفق حركة المرور وتخلق ظروف خطيرة.

### عقوبات السرعة (ملخص)

| تجاوز الحد | ضربة جزاء |
|-------------------|--------|
| أكثر من 50 كم/ساعة فوق الحد | الحبس من اسبوعين الى 3 اشهر او الغرامة 100 دينار وحجز الرخصة |
| 31–50 كم/ساعة فوق الحد | غرامة 30 دينار |
| 11–30 كم/ساعة فوق الحد | غرامة 20 دينار |

## القسم 3: قاعدة الثانيتين (المسافة التالية)

توفر قاعدة الثانيتين مسافة متابعة آمنة في الظروف الجيدة.

### كيفية تطبيق قاعدة الثانيتين

1. راقب مرور السيارة التي أمامك بجسم ثابت (لافتة، شجرة، جسر، علامات الطريق).
2. عندما تمر مؤخرة السيارة بالجسم، ابدأ العد: "ألف، ألف واثنان".
3. إذا وصلت إلى الهدف قبل الانتهاء من "ألف واثنين"، فأنت تتابع عن كثب. زيادة المسافة الخاصة بك وتكرار.


### متى تستخدم ثلاث ثوان أو أكثر

طبّق **قاعدة الثلاث ثوانٍ** (أو أكبر) في هذه المواقف:

- **الطرق الرطبة** (المطر والمياه الراكدة)
- **حالة الإطار سيئة** (المداس مهترئ)
- **حالة الفرامل سيئة**
- **حمولة مركبة ثقيلة** (ركاب أو بضائع)
- **القيادة الليلية** (انخفاض الرؤية)
- **متابعة الدراجات النارية أو الشاحنات** (تتوقف الدراجات النارية بشكل أسرع من السيارات؛ فالشاحنات تحجب الرؤية أمامك)
- **تعب أو إجهاد السائق**
- **الأسطح الزلقة** (الحصى والثلج والجليد والأحجار السائبة)

### المسافة التالية للمركبات الثقيلة

إذا كنت تقود شاحنة أو حافلة أو مركبة ثقيلة، فاستخدم دائمًا **قاعدة الثلاث ثوانٍ كحد أدنى**، حتى في الطقس الجيد. تتطلب المركبات الثقيلة مسافات توقف أطول.

### ما هي المسافة "ثانيتين" بالأمتار؟

كدليل تقريبي:
- بسرعة 50 كم/ساعة: 2 ثانية = حوالي 28 مترًا (حوالي 4 أطوال للسيارة)
- بسرعة 80 كم/ساعة: 2 ثانية = حوالي 44 مترًا (حوالي 7 أطوال للسيارة)
- بسرعة 110 كم/ساعة: 2 ثانية = حوالي 61 مترًا (حوالي 10 أطوال للسيارة)

### إيقاف العلاقة عن بعد
عند سرعة 45 كم/ساعة، تحتاج السيارة الصغيرة إلى مسافة أطول من **ستة أضعاف طولها** لتتوقف تمامًا.

**سيناريو من العالم الحقيقي:** أنت تقود بسرعة 90 كم/ساعة على طريق سريع مقسم تحت أمطار خفيفة. يمكنك تطبيق قاعدة الثلاث ثواني للسلامة. وفجأة، تضغط السيارة التي أمامك على المكابح بقوة وتتوقف أمام سيارة متوقفة. تمنحك فجوة الثلاث ثوانٍ وقتًا كافيًا للرد والتوقف بأمان. لو اتبعت في ثانية واحدة، سوف تصطدم.

## القسم الرابع: قواعد التوقف والوقوف

### التعاريف

- **التوقف (التوقف):** التوقف مؤقتًا لأسباب مرورية (الإشارة الحمراء، إشارة التوقف، الازدحام)، صعود أو إنزال الركاب، أو تحميل/تفريغ البضائع. موجز ويبقى السائق في السيارة.
- **الوقوف:** ترك المركبة متوقفة لأي سبب غير مؤقت. يمكن للسائق الخروج من السيارة.

### الأماكن التي يُحظر فيها ركن السيارة والتوقف

| الموقع | لماذا محظور |
|----------|----------------|
| على معابر المشاة أو الأرصفة | كتل وصول المشاة |
| على ممرات الدراجات | يعرض راكبي الدراجات للخطر |
| على خطوط السكك الحديدية أو قريبة جدًا منها | خطر تصادم القطارات |
| على الجسور أو الأنفاق أو الجسور (ما لم تكن هناك أماكن مخصصة لوقوف السيارات) | كتل حركة المرور. خطر الاصطدام |
| في حدود 15 مترًا من التقاطع أو المنحنى أو قمة التل | يحجب الرؤية للسائقين الآخرين |
| مواقف مزدوجة (موازية بجوار سيارة متوقفة) | كتل حارة المرور |
| في حدود 10 أمتار قبل أو بعد معبر المشاة | كتل عرض لعبور المشاة |
| في دوار | خطير للغاية |
| على ممرات مداخل مواقف السيارات العامة/الخاصة | كتل الوصول |

### إجراءات وقوف السيارات الموازية

يعتبر ركن السيارة بشكل متوازي مهارة مطلوبة في اختبار القيادة العملي.

** خطوة بخطوة: **
1. قم بالإشارة إلى نيتك ووضع سيارتك بشكل موازٍ للمركبة الأمامية، على بعد حوالي 0.5 متر (1.5 قدم) منها.
2. التحقق من المرايا والنقطة العمياء للتأكد من اقتراب حركة المرور. انتظر الفجوة.
3. أدر عجلة القيادة بالكامل باتجاه الرصيف (في الأردن مباشرة).
4. قم بالرجوع للخلف ببطء. شاهد مرآتك اليمنى لترى الرصيف والمركبة الخلفية.
5. عندما يمر المصد الأمامي الخاص بك بالمصد الخلفي للمركبة الأمامية (أو عندما تكون بزاوية 45 درجة تقريبًا)، قم بإدارة عجلة القيادة بعيدًا تمامًا عن الرصيف (يسارًا).
6. استمر في الرجوع للخلف حتى تقترب سيارتك من السيارة الخلفية (مسافة حوالي 0.5 متر).
7. أدر عجلة القيادة للخلف باتجاه الرصيف (يمينًا) لتسوية عجلاتك ووضع سيارتك في المنتصف بين المركبتين.
8. اضبط للأمام أو للخلف حسب الحاجة لتوسيط السيارة.

## القسم الخامس: التوقف الطارئ (الانهيار)

### إذا تعطلت سيارتك

1. **تحرك بعيدًا عن الطريق** في أسرع وقت ممكن بأمان. استخدم الزخم إذا مات المحرك.
2. **اختر مكانًا آمنًا** – بعيدًا عن المنحنيات أو قمم التلال أو التقاطعات.
3. **قم بتشغيل أضواء الخطر** (الفلاشات الرباعية) على الفور.
4. **ضع المثلث العاكس:**
   - على الطرق الريفية: على الأقل **100 متر قبل** سيارتك (وليس بعدها)
   - على الطرق الحضرية: على الأقل **50 مترًا** قبل** سيارتك
   - على المنحنيات: ضع المثلث قبل المنحنى حتى يتمكن السائقون المقتربون من رؤيته مسبقًا
5. **في الليل أو انخفاض الرؤية:** احتفظ بأضواء التوقف مضاءة بالإضافة إلى أضواء الخطر.
6. ** لا تقف بين مركبتك وحركة المرور القادمة. ** قف خلف حاجز أو بعيدًا عن الطريق.
7. **اتصل بطلب المساعدة** باستخدام هاتفك المحمول أو هاتف الطوارئ الموجود على الطريق.

### إذا كنت تعاني من إعاقة أو لا تستطيع الخروج بأمان

- ابق داخل سيارتك مع ربط حزام الأمان
- إبقاء أضواء الخطر مضاءة
- اعرض علامة "مساعدة" في نافذتك إذا كانت متوفرة
- اتصل للحصول على المساعدة باستخدام هاتفك
- انتظر وصول المساعدة

### متطلبات المثلث العاكس

- شكل مثلث متساوي الأضلاع
- الحد الأدنى لطول الجانب: 45 سم (18 بوصة)
- مادة عاكسة على السطح
- يجب أن توضع على سطح الطريق أو على حامل على مستوى الطريق

### منع المركبات من الوقوف ليلاً داخل المناطق السكنية

- المركبات التي يزيد وزنها الإجمالي عن 7.5 طن (الشاحنات الكبيرة، الحافلات الثقيلة)
- المركبات الزراعية والإنشائية (جرارات، حفارات، جرافات) على الشوارع السكنية الرئيسية

قد يُسمح بهذه المركبات في مناطق وقوف الشاحنات المخصصة أو المناطق الصناعية.

## القسم 6: تقنيات الكبح في حالات الطوارئ

### للمركبات التي لا تحتوي على نظام ABS (الفرامل المانعة للانغلاق)
- استخدم الفرامل بقوة ولكن لا تقفل العجلات.
- إذا انغلقت العجلات (سمعت صريرًا وفقدت التوجيه)، **اضغط على المكابح** - حررها قليلًا ثم أعد تطبيقها.
- الكبح الإيقاعي: قم بالتطبيق، ثم حرر قليلاً، ثم قم بالتطبيق مرة أخرى بسرعة.

### للمركبات المزودة بنظام ABS
- استخدم المكابح **بثبات وبشكل مستمر**.
- لا تضغط على الفرامل - يعمل نظام ABS على الضخ تلقائيًا.
- قد تشعر بالنبض أثناء الضغط على دواسة الفرامل، وهذا أمر طبيعي.
- الحفاظ على التحكم في التوجيه؛ يسمح لك نظام ABS بالتوجيه أثناء الكبح بقوة.

### في الظروف الرطبة أو الزلقة
- قم بالفرملة مبكرًا وبلطف أكثر من الطرق الجافة.
- زيادة المسافة التالية بشكل ملحوظ.
- تجنب استخدام المكابح أثناء الانعطاف - استخدم المكابح قبل الدخول في المنحنيات.

**سيناريو من العالم الحقيقي:** يجري طفل في الشارع أمامك بمسافة 30 مترًا بينما تسير أنت بسرعة 60 كم/ساعة. لديك ما يقرب من 1.8 ثانية للرد والتوقف. عند سرعة 60 كم/ساعة، تبلغ مسافة التوقف الإجمالية على الرصيف الجاف حوالي 45 مترًا - ستتوقف في الوقت المناسب. على الرصيف الرطب، تتضاعف مسافة التوقف تقريبًا. يجب أن تكون سرعتك أقل أثناء هطول المطر حتى تتمكن من التوقف بأمان تحسبًا للمخاطر غير المتوقعة.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (7, 'en', N'# Alcohol, Drugs, Fatigue, and Safe Driving Fitness

Driving requires full physical and mental fitness. Any impairment – from alcohol, drugs, medications, fatigue, or distraction – dramatically increases crash risk. This module covers the effects, legal consequences, and safe practices.

## Section 1: Alcohol and Driving

### How Alcohol Impairs Driving

Alcohol affects the brain and body in ways directly dangerous to driving:

| Blood Alcohol Level | Effects on Driving |
|---------------------|---------------------|
| Very low (0.02%) | Reduced coordination, decreased ability to track moving objects, difficulty multitasking |
| Low (0.05%) | Reduced coordination, reduced ability to track moving objects, difficulty steering, reduced response to emergency situations |
| Moderate (0.08% – legal limit in many countries) | Poor muscle coordination, difficulty detecting hazards, impaired judgment, reduced concentration, short-term memory loss, poor speed control |
| High (0.10%+) | Slurred speech, poor coordination, slowed thinking, reduced ability to maintain lane position, significantly increased crash risk |

### Specific Driving Skills Affected by Alcohol

- **Reaction time:** Increases by 20–50% even at low levels. At 90 km/h, a 0.5-second delay adds 12.5 meters to stopping distance.
- **Judgment:** Impairs ability to judge distances, speeds, and gaps in traffic.
- **Vision:** Reduces peripheral vision (tunnel vision), decreases night vision, impairs depth perception.
- **Coordination:** Impairs fine motor control needed for steering, pedals, and gear shifting.
- **Concentration:** Makes it difficult to focus on multiple tasks (scanning, steering, speed control).

### Legal Consequences in Jordan

- Driving under the influence of alcohol is a **serious crime**, not just a traffic violation.
- If caught with any measurable alcohol in your system while driving, penalties may include:
  - Imprisonment
  - Heavy fines (hundreds to thousands of JD)
  - Long-term license suspension
  - Vehicle impoundment
- **Refusing a breathalyzer or blood test** may lead to immediate arrest and additional penalties.
- For causing death or injury while impaired, penalties include long prison sentences and permanent license revocation.

### Common Myths About Alcohol

| Myth | Reality |
|------|---------|
| "Coffee will sober me up" | Caffeine makes you feel more awake but does NOT reduce impairment or lower BAC |
| "I can drive after one drink" | One drink affects some people significantly; effects vary by weight, gender, food intake |
| "Eating soaks up alcohol" | Food slows absorption but does not reduce total BAC or impairment |
| "Time is the only cure" | TRUE. Only time lowers BAC. One hour per standard drink on average. |

**Real-world scenario:** You have two beers with dinner over two hours, feel "fine," and decide to drive. Your BAC may still be above legal limits depending on your body weight and gender. You are stopped at a checkpoint and fail the breathalyzer. You face arrest, court appearance, fines, license suspension, and a criminal record. The safest choice: designate a sober driver or use a taxi/ride service.

## Section 2: Drugs and Narcotics

### Illegal Drugs
- Any non-alcoholic narcotic substance (cannabis, cocaine, opioids, amphetamines, etc.) severely impairs driving.
- **Effects include:**
  - Increased risk-taking and reckless behavior
  - Greatly reduced awareness of hazards
  - Poor decision-making and judgment
  - Significantly slower reflexes
  - Hallucinations or altered perception (some drugs)
  - Drowsiness or sudden loss of consciousness (some drugs)

### Legal Consequences
- Driving under the influence of any illegal drug is strictly prohibited.
- Penalties are similar to or more severe than alcohol violations.
- Drug-impaired driving causing death or injury carries enhanced penalties.

## Section 3: Medications That Affect Driving

Many legal over-the-counter and prescription medications can impair driving ability as much as alcohol.

### Common Medications with Driving Warnings

| Medication Type | Examples | Potential Effects |
|-----------------|----------|-------------------|
| Antihistamines (allergy) | Diphenhydramine (Benadryl), cetirizine (Zyrtec) | Drowsiness, dizziness, slowed reaction time |
| Sleep aids (prescription and OTC) | Zolpidem (Ambien), diphenhydramine | Drowsiness, morning grogginess |
| Anxiety medications | Benzodiazepines (Xanax, Valium) | Drowsiness, impaired coordination, confusion |
| Some antidepressants | Certain SSRIs, tricyclics | Drowsiness, blurred vision, dizziness |
| Some pain relievers | Opioids (codeine, tramadol, oxycodone) | Drowsiness, euphoria, impaired judgment, slowed breathing |
| Blood pressure medications | Beta-blockers, some diuretics | Dizziness, fatigue, blurred vision |
| Muscle relaxants | Cyclobenzaprine (Flexeril) | Drowsiness, weakness, dizziness |
| Cold and flu medications | Multi-symptom formulas often contain antihistamines or cough suppressants | Drowsiness, dizziness, impaired coordination |
| Anti-nausea medications | Promethazine (Phenergan), dimenhydrinate (Dramamine) | Drowsiness, blurred vision |

### What to Do

1. **Read warning labels** on all medications. Look for phrases like:
   - "May cause drowsiness"
   - "Do not operate heavy machinery"
   - "Avoid driving until you know how this medication affects you"
   - "Use caution when driving"

2. **If the label warns against driving: DO NOT DRIVE** while taking that medication, especially during the first few days or when dosage changes.

3. **Consult your doctor or pharmacist** before driving while on any medication. Ask specifically: "Is it safe for me to drive while taking this?"

4. **Monitor yourself** even with medications that do not carry warnings. If you feel drowsy, dizzy, or "different" after taking any medication, do not drive.

**Real-world scenario:** You have a cold and take an over-the-counter nighttime cold medication that contains an antihistamine. The label says "may cause marked drowsiness." You take it at 10 PM and plan to drive to work at 7 AM. The medication can still affect you for 8–12 hours. You wake up feeling groggy but think you are fine. On the road, your reaction time is slowed, and you fail to stop in time for a red light. You cause a crash. Wait 12+ hours or find alternative transportation.

## Section 4: Driver Fatigue

Fatigue is as dangerous as alcohol impairment. Studies show being awake for 18 hours produces impairment equivalent to a BAC of 0.05%, and 24 hours awake equals 0.10% BAC.

### Why Fatigue Is Dangerous

- Fatigue reduces reaction time similarly to alcohol
- You may experience **micro-sleeps** (2–5 seconds of sleep with eyes open) without realizing it. At 90 km/h, a 4-second micro-sleep covers 100 meters of uncontrolled driving
- Accident risk increases significantly at night (especially 2 AM–6 AM) and on long trips (after 2+ hours of continuous driving)

### Signs of Fatigue (If You Experience Any, STOP Driving)

- Frequent yawning
- Heavy eyelids or blinking more than usual
- Difficulty keeping your head up
- Drifting out of your lane or hitting rumble strips
- Missing traffic signs or exits
- Not remembering the last few kilometers driven
- Feeling restless or irritable
- Slow reactions to changing traffic conditions

### How to Prevent Fatigue

**Before driving:**
- Get adequate sleep – 7–8 hours recommended before long drives
- Avoid driving during your normal sleeping hours
- Avoid heavy meals before driving (digestion causes drowsiness)
- Avoid alcohol the night before long drives

**During driving:**
- Take a break every **2 hours or 150–200 km** – whichever comes first
- Stop at a safe rest area, service station, or parking area (not on the shoulder)
- Get out of the vehicle, stretch, walk around for 10–15 minutes
- If very tired: Take a **short nap (15–20 minutes)** before driving again. A 20-minute nap restores alertness for 2–3 hours.
- Drink water – dehydration increases fatigue
- Drive with a passenger who can share driving or keep you alert

**What does NOT work for fatigue:**
- Loud music
- Opening windows
- Slapping your face
- Drinking coffee (caffeine takes 30 minutes to work and does not replace sleep)

**Real-world scenario:** You are driving back from a weekend trip at 3 AM, two hours from home. You notice you are yawning and struggling to keep your eyes focused. Instead of pushing through, you stop at the next rest area. You nap for 20 minutes, drink water, and stretch. You complete the drive safely. That decision may have saved your life.

## Section 5: Concentration and Distractions

### Common Driving Distractions to Avoid

| Distraction Type | Examples |
|------------------|----------|
| Mobile phone use | Talking without hands-free (illegal in Jordan), texting, checking notifications, using apps |
| Eating/drinking | Unwrapping food, holding a drink, eating with one hand |
| Vehicle controls | Adjusting radio, GPS, or climate controls while in complex traffic |
| Passengers | Turning to talk to rear-seat passengers, arguing, dealing with children |
| Grooming | Applying makeup, shaving, combing hair |
| Reaching | Picking up dropped items from the floor or back seat |
| External distractions | Looking at crashes, billboards, scenery for too long |

### Safe Practices

1. **Set up before moving:** Adjust seat, mirrors, steering wheel, climate controls, GPS destination, and music before shifting into gear.

2. **Secure loose objects:** Phones, sunglasses, bags, and other items should be secured so they do not roll or slide.

3. **Passenger management:** Ask passengers to keep noise at a reasonable level. Deal with children''s needs before driving or pull over to address them.

4. **Phone policy:** Pull over to a safe location to use your phone. Even hands-free conversations are distracting – keep them short and simple.

5. **Eat before or after:** Do not eat while driving. If you must eat on a long trip, stop at a rest area.

### Nighttime Concentration Challenges

- Vision is reduced by **50–70%** at night compared to daylight.
- Glare from oncoming high beams temporarily blinds you and takes seconds to recover.
- **If an oncoming vehicle uses high beams:**
  - Slow down
  - Look to the right edge of your road (not at the lights)
  - Keep right in your lane
  - Do not flash your high beams back (escalates conflict)

### Driving in High Heat/Strong Sun

- Heat causes dehydration, headache, nausea, anxiety, and fatigue
- Use sunglasses to reduce glare (polarized lenses are best)
- Use your vehicle''s sun visor
- Monitor engine temperature gauge
- Keep air conditioning or ventilation on
- Reduce speed slightly and increase following distance (heat affects braking and tire grip)

## Section 6: Quick Fitness-to-Drive Checklist

**Before every drive, ask yourself:**

- [ ] Have I consumed any alcohol in the past 6–8 hours?
- [ ] Have I taken any medication that causes drowsiness or dizziness?
- [ ] Have I used any illegal or recreational drugs?
- [ ] Am I feeling tired or sleepy?
- [ ] Am I emotionally upset (angry, very sad, extremely excited)?
- [ ] Do I have any physical symptoms (fever, severe pain, dizziness)?

**If you answer YES to any: DO NOT DRIVE.**

**Real-world scenario:** You argued with your boss before leaving work. You are angry and distracted. You get behind the wheel. Your anger causes you to drive more aggressively – tailgating, speeding, running a yellow light. You cause a crash. Pull over, take 10 minutes to calm down, and only drive when you are emotionally ready to focus safely.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (7, 'ar', N'# الكحول والمخدرات والتعب ولياقة القيادة الآمنة

تتطلب القيادة لياقة بدنية وعقلية كاملة. أي ضعف - بسبب الكحول أو المخدرات أو الأدوية أو التعب أو الإلهاء - يزيد بشكل كبير من خطر الاصطدام. تغطي هذه الوحدة الآثار والعواقب القانونية والممارسات الآمنة.

## القسم 1: الكحول والقيادة

### كيف يعوق الكحول القيادة

يؤثر الكحول على الدماغ والجسم بطرق تشكل خطورة مباشرة على القيادة:

| مستوى الكحول في الدم | التأثيرات على القيادة |
|---------------------|---------------------|
| منخفضة جداً (0.02%) | انخفاض التنسيق، وانخفاض القدرة على تتبع الأجسام المتحركة، وصعوبة تعدد المهام |
| منخفض (0.05%) | انخفاض التنسيق، انخفاض القدرة على تتبع الأجسام المتحركة، صعوبة التوجيه، انخفاض الاستجابة لحالات الطوارئ |
| معتدل (0.08% – الحد القانوني في العديد من البلدان) | ضعف التنسيق العضلي، صعوبة اكتشاف المخاطر، ضعف الحكم، انخفاض التركيز، فقدان الذاكرة على المدى القصير، ضعف التحكم في السرعة |
| عالي (0.10%+) | تلعثم في الكلام، وضعف التنسيق، وبطء التفكير، وانخفاض القدرة على الحفاظ على وضع المسار، وزيادة خطر الاصطدام بشكل ملحوظ |

### مهارات القيادة المحددة المتأثرة بالكحول

- **زمن رد الفعل:** يزداد بنسبة 20-50% حتى عند المستويات المنخفضة. وعند السرعة 90 كم/ساعة، فإن التأخير لمدة 0.5 ثانية يضيف 12.5 مترًا إلى مسافة التوقف.
- **الحكم:** يضعف القدرة على تقدير المسافات والسرعات والفجوات في حركة المرور.
- **الرؤية:** تقلل الرؤية المحيطية (الرؤية النفقية)، وتقلل الرؤية الليلية، وتضعف إدراك العمق.
- **التنسيق:** يعوق التحكم الدقيق في المحركات اللازمة للتوجيه والدواسات وتبديل التروس.
- **التركيز:** يجعل من الصعب التركيز على مهام متعددة (المسح، التوجيه، التحكم في السرعة).

### العواقب القانونية في الأردن

- تعتبر القيادة تحت تأثير الكحول **جريمة خطيرة**، وليست مجرد مخالفة مرورية.
- إذا تم ضبط أي كحول قابل للقياس في نظامك أثناء القيادة، فقد تشمل العقوبات ما يلي:
  - السجن
  - غرامات باهظة (مئات إلى آلاف الدنانير)
  - تعليق الترخيص لفترة طويلة
  - حجز المركبة
- **قد يؤدي رفض اختبار الكحول أو فحص الدم** إلى الاعتقال الفوري وعقوبات إضافية.
- للتسبب في الوفاة أو الإصابة أثناء الإعاقة، تشمل العقوبات أحكامًا بالسجن لفترات طويلة وإلغاء الترخيص بشكل دائم.

### الخرافات الشائعة حول الكحول

| الأسطورة | الواقع |
|------|---------|
| "القهوة سوف توقظني" | يجعلك الكافيين تشعر بمزيد من اليقظة ولكنه لا يقلل من ضعف أو انخفاض مستوى BAC |
| "أستطيع أن أقود السيارة بعد تناول مشروب واحد" | يؤثر المشروب الواحد على بعض الأشخاص بشكل ملحوظ؛ تختلف التأثيرات حسب الوزن والجنس وتناول الطعام |
| "الأكل يمتص الخمر" | يبطئ الطعام الامتصاص ولكنه لا يقلل من إجمالي BAC أو ضعفه |
| "الوقت هو العلاج الوحيد" | حقيقي. الوقت فقط يخفض نسبة BAC. ساعة واحدة لكل مشروب قياسي في المتوسط. |

**سيناريو من العالم الحقيقي:** تناولت كأسين من البيرة مع العشاء لمدة ساعتين، وتشعر بأنك "بحالة جيدة"، وتقرر القيادة. قد لا يزال مستوى BAC الخاص بك أعلى من الحدود القانونية اعتمادًا على وزن جسمك وجنسك. لقد تم إيقافك عند نقطة تفتيش وفشل جهاز فحص الكحول. ستواجه الاعتقال والمثول أمام المحكمة والغرامات وتعليق الترخيص والسجل الجنائي. الخيار الأكثر أمانًا: تعيين سائق رصين أو استخدام خدمة سيارات الأجرة/الركوب.

## القسم الثاني: المخدرات والمخدرات

### المخدرات غير المشروعة
- أي مادة مخدرة غير كحولية (الحشيش، الكوكايين، المواد الأفيونية، الأمفيتامينات وغيرها) تضعف القيادة بشدة.
- **تشمل التأثيرات:**
  - زيادة المخاطرة والسلوك المتهور
  - انخفاض كبير في الوعي بالمخاطر
  - سوء اتخاذ القرار والحكم
  - ردود أفعال أبطأ بشكل ملحوظ
  - الهلوسة أو تغير في الإدراك (بعض الأدوية).
  – النعاس أو فقدان الوعي المفاجئ (بعض الأدوية).

### العواقب القانونية
- يمنع منعا باتا القيادة تحت تأثير أي مخدرات غير مشروعة.
- العقوبات مشابهة أو أشد من مخالفات الكحول.
- القيادة تحت تأثير المخدرات والتي تسبب الوفاة أو الإصابة تحمل عقوبات مشددة.

## القسم الثالث: الأدوية التي تؤثر على القيادة

العديد من الأدوية القانونية التي لا تستلزم وصفة طبية يمكن أن تضعف القدرة على القيادة مثل الكحول.

### الأدوية الشائعة مع تحذيرات القيادة

| نوع الدواء | أمثلة | التأثيرات المحتملة |
|-----------------|----------|------------------|---------|
| مضادات الهيستامين (الحساسية) | ديفينهيدرامين (بينادريل)، سيتريزين (زيرتيك) | نعاس، دوخة، تباطؤ وقت رد الفعل |
| مساعدات النوم (وصفة طبية وOTC) | زولبيديم (أمبين)، ديفينهيدرامين | النعاس والترنح الصباحي |
| أدوية القلق | البنزوديازيبينات (زاناكس، الفاليوم) | نعاس، ضعف التنسيق، ارتباك |
| بعض مضادات الاكتئاب | بعض مثبطات استرداد السيروتونين الانتقائية، ثلاثية الحلقات | نعاس، عدم وضوح الرؤية، دوخة |
| بعض مسكنات الألم | المواد الأفيونية (الكودايين، الترامادول، أوكسيكودون) | النعاس، النشوة، ضعف الحكم، تباطؤ التنفس |
| أدوية ضغط الدم | حاصرات بيتا وبعض مدرات البول | دوخة، تعب، عدم وضوح الرؤية |
| مرخيات العضلات | سيكلوبنزابرين (فليكسيريل) | النعاس والضعف والدوخة |
| أدوية البرد والانفلونزا | غالبًا ما تحتوي التركيبات متعددة الأعراض على مضادات الهيستامين أو مثبطات السعال | نعاس، دوخة، ضعف التنسيق |
| أدوية مضادة للغثيان | بروميثازين (فينيرجان)، ديمينهيدرينات (درامامين) | النعاس وعدم وضوح الرؤية |

### ما يجب القيام به

1. **اقرأ الملصقات التحذيرية** على جميع الأدوية. ابحث عن عبارات مثل:
   - "قد يسبب النعاس"
   - "لا تشغل الآلات الثقيلة"
   - "تجنب القيادة حتى تعرف مدى تأثير هذا الدواء عليك"
   - "توخى الحذر أثناء القيادة"

2. **إذا كان الملصق يحذر من القيادة: لا تقود السيارة** أثناء تناول هذا الدواء، خاصة خلال الأيام القليلة الأولى أو عند تغيير الجرعة.

3. **استشر طبيبك أو الصيدلي** قبل القيادة أثناء تناول أي دواء. اسأل على وجه التحديد: "هل من الآمن بالنسبة لي القيادة أثناء تناول هذا الدواء؟"

4. **راقب نفسك** حتى مع الأدوية التي لا تحمل تحذيرات. إذا شعرت بالنعاس أو الدوار أو "الاختلاف" بعد تناول أي دواء، فلا تقود السيارة.

**سيناريو من العالم الحقيقي:** أنت مصاب بنزلة برد وتتناول دواء نزلات البرد الليلي الذي لا يستلزم وصفة طبية والذي يحتوي على مضاد للهستامين. الملصق يقول "قد يسبب نعاسًا ملحوظًا". تأخذها في الساعة 10 مساءً وتخطط للقيادة إلى العمل في الساعة 7 صباحًا. يمكن أن يستمر تأثير الدواء عليك لمدة 8-12 ساعة. تستيقظ وأنت تشعر بالترنح ولكنك تعتقد أنك بخير. على الطريق، يتباطأ وقت رد فعلك، وتفشل في التوقف في الوقت المناسب للحصول على الضوء الأحمر. أنت تسبب حادث. انتظر أكثر من 12 ساعة أو ابحث عن وسيلة نقل بديلة.

## القسم الرابع: تعب السائق

التعب خطير مثل ضعف الكحول. تشير الدراسات إلى أن البقاء مستيقظًا لمدة 18 ساعة يؤدي إلى انخفاض يعادل نسبة BAC بنسبة 0.05%، والاستيقاظ لمدة 24 ساعة يساوي 0.10% من نسبة BAC.

### لماذا يعتبر الإرهاق خطيرًا؟

- التعب يقلل من وقت رد الفعل على غرار الكحول
- قد تواجه **فترات نوم قصيرة** (من 2 إلى 5 ثوانٍ من النوم وعيناك مفتوحتان) دون أن تدرك ذلك. عند سرعة 90 كم/ساعة، يغطي النوم الصغير لمدة 4 ثوانٍ مسافة 100 متر من القيادة غير المنضبطة
- يزداد خطر وقوع الحوادث بشكل كبير في الليل (خاصة من الساعة 2 صباحًا حتى 6 صباحًا) وفي الرحلات الطويلة (بعد أكثر من ساعتين من القيادة المتواصلة)

### علامات التعب (إذا شعرت بأي منها، توقف عن القيادة)

- التثاؤب المتكرر
- ثقل الجفون أو الرمش أكثر من المعتاد
- صعوبة في إبقاء رأسك مرفوعاً
- الانجراف خارج المسار الخاص بك أو ضرب شرائط الدمدمة
- عدم وجود إشارات مرورية أو مخارج
- عدم تذكر الكيلومترات القليلة الماضية التي قطعتها
- الشعور بعدم الراحة أو الانفعال
- ردود أفعال بطيئة تجاه الظروف المرورية المتغيرة

### كيفية منع التعب

**قبل القيادة:**
- احصل على قسط كافٍ من النوم - يوصى به قبل 7 إلى 8 ساعات من القيادة الطويلة
- تجنب القيادة أثناء ساعات نومك الطبيعية
- تجنب الوجبات الثقيلة قبل القيادة (الهضم يسبب النعاس)
- تجنب الكحول في الليلة التي تسبق القيادة لمسافات طويلة

**أثناء القيادة:**
- خذ قسطًا من الراحة كل **ساعتين أو 150-200 كيلومتر** – أيهما يأتي أولاً
- توقف عند منطقة استراحة آمنة أو محطة خدمة أو منطقة وقوف السيارات (وليس على الكتف)
- اخرج من السيارة، تمدد، تجول لمدة 10-15 دقيقة
- إذا كنت متعبًا جدًا: خذ **قيلولة قصيرة (15-20 دقيقة)** قبل القيادة مرة أخرى. قيلولة لمدة 20 دقيقة تعيد اليقظة لمدة 2-3 ساعات.
- شرب الماء – فالجفاف يزيد التعب
- قم بالقيادة مع أحد الركاب الذي يمكنه مشاركة القيادة أو إبقائك في حالة تأهب

**ما لا ينفع من التعب:**
- الموسيقى الصاخبة
- فتح النوافذ
- الصفع وجهك
- شرب القهوة (الكافيين يستغرق 30 دقيقة للعمل ولا يحل محل النوم)

**السيناريو الواقعي:** أنت تعود بالسيارة من رحلة عطلة نهاية الأسبوع في الساعة 3 صباحًا، على بعد ساعتين من المنزل. لاحظت أنك تتثاءب وتكافح من أجل الحفاظ على تركيز عينيك. بدلاً من المضي قدمًا، تتوقف عند منطقة الراحة التالية. تغفو لمدة 20 دقيقة، وتشرب الماء، وتمارس تمارين التمدد. أكملت القيادة بأمان. ربما يكون هذا القرار قد أنقذ حياتك.

## القسم 5: التركيز والتشتت

### عوامل تشتيت الانتباه الشائعة أثناء القيادة والتي يجب تجنبها

| نوع الهاء | أمثلة |
|------------------|---------|
| استخدام الهاتف المحمول | التحدث بدون استخدام اليدين (غير قانوني في الأردن)، إرسال الرسائل النصية، التحقق من الإشعارات، استخدام التطبيقات |
| الأكل والشرب | فك تغليف الطعام، وإمساك الشراب، والأكل بيد واحدة |
| ضوابط السيارة | ضبط أجهزة التحكم في الراديو أو نظام تحديد المواقع العالمي (GPS) أو المناخ أثناء وجود حركة مرور معقدة |
| الركاب | اللجوء للتحدث مع ركاب المقاعد الخلفية، والجدال، والتعامل مع الأطفال |
| الاستمالة | وضع المكياج والحلاقة وتمشيط الشعر |
| الوصول | التقاط الأشياء المتساقطة من الأرض أو المقعد الخلفي |
| الانحرافات الخارجية | النظر إلى الأعطال واللوحات الإعلانية والمناظر الطبيعية لفترة طويلة |

### الممارسات الآمنة

1. **الإعداد قبل التحرك:** اضبط المقعد والمرايا وعجلة القيادة وأدوات التحكم في المناخ ووجهة نظام تحديد المواقع العالمي (GPS) والموسيقى قبل التبديل إلى السرعة.

2. **تأمين الأشياء السائبة:** يجب تأمين الهواتف والنظارات الشمسية والحقائب وغيرها من العناصر بحيث لا تتدحرج أو تنزلق.

3. **إدارة الركاب:** اطلب من الركاب إبقاء الضوضاء عند مستوى معقول. تعامل مع احتياجات الأطفال قبل القيادة أو التوقف لتلبيتها.

4. **سياسة الهاتف:** انتقل إلى مكان آمن لاستخدام هاتفك. حتى المحادثات بدون استخدام اليدين قد تشتت الانتباه – اجعلها قصيرة وبسيطة.

5. **تناول الطعام قبل أو بعد:** لا تأكل أثناء القيادة. إذا كان عليك تناول الطعام أثناء رحلة طويلة، توقف عند منطقة الاستراحة.

### تحديات التركيز الليلي

- تقل الرؤية بنسبة **50-70%** في الليل مقارنة بضوء النهار.
- الوهج الصادر من الأضواء العالية القادمة يصيبك بالعمى مؤقتًا ويستغرق ثوانٍ للتعافي.
- **إذا كانت هناك مركبة قادمة تستخدم الضوء العالي:**
  - ابطئ
  - انظر إلى الحافة اليمنى من طريقك (وليس عند الأضواء)
  - حافظ على حقك في مسارك
  - لا تعيد إضاءة الأضواء العالية (يؤدي ذلك إلى تفاقم الصراع)

### القيادة في درجات حرارة عالية/شمس قوية

- الحرارة تسبب الجفاف والصداع والغثيان والقلق والتعب
- استخدم النظارات الشمسية لتقليل الوهج (العدسات المستقطبة هي الأفضل)
- استخدم حاجب الشمس الخاص بسيارتك
- مراقبة مقياس درجة حرارة المحرك
- استمر في تشغيل مكيف الهواء أو التهوية
- خفف السرعة قليلاً وقم بزيادة مسافة التتبع (تؤثر الحرارة على المكابح وتماسك الإطارات)

## القسم 6: قائمة التحقق السريعة من اللياقة البدنية للقيادة

**قبل كل رحلة اسأل نفسك:**

- [ ] هل تناولت أي كحول خلال الـ 6-8 ساعات الماضية؟
- [ ] هل تناولت أي دواء يسبب النعاس أو الدوخة؟
- [ ] هل استخدمت أي مخدرات غير قانونية أو ترفيهية؟
- [ ] هل أشعر بالتعب أو النعاس؟
- [ ] هل أنا منزعج عاطفيا (غاضب، حزين جدا، متحمس للغاية)؟
- [ ] هل أعاني من أي أعراض جسدية (حمى، ألم شديد، دوخة)؟

**إذا أجبت بنعم على أي سؤال: لا تقود السيارة.**

**سيناريو من العالم الحقيقي:** لقد تشاجرت مع رئيسك في العمل قبل مغادرة العمل. أنت غاضب ومشتت. أنت تجلس خلف عجلة القيادة. إن غضبك يدفعك إلى القيادة بشكل أكثر عدوانية – التتبع، والسرعة، والتجاوز في الإشارة الصفراء. أنت تسبب حادث. توقف جانبًا، وخذ 10 دقائق لتهدأ، ولا تقود السيارة إلا عندما تكون مستعدًا عاطفيًا للتركيز بأمان.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (8, 'en', N'# Difficult Driving Conditions – Night, Weather, and Emergencies

Driving becomes significantly more dangerous in adverse conditions. Crash rates double or triple at night, in rain, or in fog. This module teaches you how to adapt your driving to stay safe.

## Section 1: Night Driving

### The Statistics
- Accident rate **doubles** at night compared to daytime.
- At speeds over 110 km/h, the night crash rate increases **six times**.
- Most night crashes occur between midnight and 6 AM, especially 2 AM–4 AM.

### Vision Limitations at Night
- Depth perception is reduced
- Peripheral vision narrows
- Color recognition decreases (red looks black, green looks gray)
- Glare recovery takes longer (5–10 seconds after bright lights)
- Overall vision is reduced by 50–70%

### Night Driving Safety Checklist

**Before driving:**
- Ensure all lights work: headlights (high and low beam), taillights, brake lights, turn signals, hazard lights
- Clean headlights, taillights, and windows (inside and out)
- Aim headlights properly (ask a mechanic if unsure)
- Check that reflective markers and license plates are clean and visible

**During driving:**
- Use **low beams** inside cities and on well-lit roads
- Use **high beams** on dark rural roads with no oncoming traffic
- **Dim high beams** when:
  - A vehicle is less than 200 meters ahead of you in your direction
  - A vehicle approaches from the opposite direction (dim at least 150 meters before meeting)
- Reduce speed – your effective sight distance is shorter than your stopping distance
- Increase following distance to 3–4 seconds minimum
- Be extra cautious at intersections (other drivers may not see you)
- Watch for pedestrians, cyclists, and animals (harder to see at night)

### Managing Glare

**From oncoming high beams:**
- Slow down
- Look to the right edge of the road (use the right line or shoulder as a guide)
- Do not stare at the lights
- Keep right in your lane
- Do not flash your high beams back (this creates danger for both of you)

**From high beams behind you:**
- Adjust your rearview mirror to night mode (flip the tab)
- Slow down and let the vehicle pass
- Do not brake-check the driver

**Real-world scenario:** You are driving on a dark rural road at 90 km/h with high beams on. You see headlights approaching on a curve. You dim your lights 150 meters before meeting. The oncoming driver does not dim theirs. You look to the right edge of the road, slow to 70 km/h, and stay in your lane. After passing, you return to normal speed and high beams. This safe response prevents temporary blindness and a potential crash.

## Section 2: Fog Driving

Fog is one of the most dangerous conditions because it dramatically reduces visibility and creates optical illusions.

### Fog Types and Visibility
- Light fog: 200–400 meters visibility – reduce speed moderately
- Moderate fog: 100–200 meters visibility – reduce speed significantly
- Dense fog: 50–100 meters visibility – drive very slowly, consider pulling over
- Thick fog: Under 50 meters visibility – pull off the road safely

### Fog Driving Rules

1. **Use low beam headlights** – NOT high beams. High beams reflect off fog droplets and create a white wall, reducing visibility further.

2. **Use fog lights** if your vehicle has them – but only in fog or heavy rain/snow. Do not use fog lights in clear conditions (they blind other drivers).

3. **Reduce speed dramatically.** As a guide:
   - 200m visibility: maximum 50 km/h
   - 100m visibility: maximum 30 km/h
   - 50m visibility: maximum 15 km/h

4. **Increase following distance to 5+ seconds** – you may not see brake lights until very close.

5. **Use the right edge line as a guide** – follow the white or reflective markers on the right side.

6. **Do not stop in travel lanes** – if visibility drops to near zero, carefully pull off the road completely, turn on hazard lights, and wait for conditions to improve.

7. **Watch for vehicles that have stopped ahead** – fog can hide stopped vehicles until you are very close.

**Real-world scenario:** You enter a fog bank on a highway. Visibility drops to 50 meters. You reduce speed to 20 km/h, use low beams and fog lights, and follow the right edge line. You see taillights ahead – a chain of cars moving at 15 km/h. You maintain a 5-second gap. After 20 minutes, the fog clears. You avoided a multi-car pileup that happened 1 km ahead where drivers had been speeding.

## Section 3: Rain and Wet Roads

Rain reduces tire grip (traction) and increases stopping distances significantly.

### Traction Loss in Rain

| Condition | Traction Compared to Dry Road |
|-----------|-------------------------------|
| Light rain (road slightly damp) | 80-90% of dry traction |
| Moderate rain (standing water) | 50-70% of dry traction |
| Heavy rain (flowing water) | 30-50% of dry traction |
| First rain after dry spell (oil rises to surface) | As low as 20-30% (extremely slippery) |

### Rain Driving Rules

1. **Reduce speed** – wet roads require lower speeds for safe stopping.

2. **Increase following distance to 4+ seconds.**

3. **Use low beam headlights** – required by law in rain in many jurisdictions. High beams reflect off raindrops.

4. **Avoid sudden braking or sharp turns** – gentle inputs only.

5. **Use windshield wipers** – replace wiper blades annually for best performance.

6. **Defrost windows** – use defroster to prevent interior fogging.

7. **Watch for hydroplaning** – when tires lose contact with road and ride on water film.

### Hydroplaning: Causes and Recovery

**Hydroplaning occurs when:**
- Speed is too high for water depth
- Tire tread is worn (less than 3mm tread depth)
- Water depth exceeds tire tread capacity
- Typically occurs above 70-80 km/h in standing water

**Signs of hydroplaning:**
- Steering feels "light"
- Vehicle does not respond to steering input
- Engine sounds louder (less resistance)

**If you hydroplane:**
- **DO NOT** brake suddenly
- **DO NOT** turn sharply
- **Gently** lift off the accelerator
- Keep steering wheel straight
- Wait for tires to regain contact (usually 1-3 seconds)
- When traction returns, continue at reduced speed

**Real-world scenario:** Heavy rain begins while you are driving at 100 km/h. You ignore advice and maintain speed. You hit a patch of standing water. The steering goes light – you are hydroplaning. You panic and hit the brakes. The vehicle spins. You crash. Alternative: You reduced speed to 70 km/h when rain started. You maintain control, arrive safely, and avoid a crash.

## Section 4: Snow and Ice

Snow and ice are the most dangerous driving surfaces. If you do not have experience driving in these conditions, consider postponing travel or using public transportation.

### Traction Levels on Ice and Snow
- Dry road: 100% traction
- Wet road: 50-70% traction
- Packed snow: 20-30% traction
- Ice: 5-10% traction

### Snow and Ice Driving Rules

1. **Reduce speed dramatically** – maximum 30-40 km/h on snow, 10-20 km/h on ice.

2. **Increase following distance to 10+ seconds** – stopping distances on ice are 10x longer than dry roads.

3. **Avoid sudden ANYTHING** – no sudden acceleration, braking, or steering.

4. **Use lower gears** – engine braking provides more control than brakes on ice. In an automatic, use "2" or "L" or manual mode.

5. **Brake gently and early** – if wheels lock, release and pump brakes (or let ABS work).

6. **Be extra careful on:** Bridges (freeze first), shaded areas (ice remains longer), curves, intersections (polished ice from vehicles stopping).

7. **If you get stuck:** Do not spin tires (digs deeper). Rock back and forth (forward, reverse, forward). Use sand, salt, or floor mats under tires for traction.

### Black Ice
- Thin, transparent ice that looks like wet pavement
- Extremely dangerous because drivers do not see it
- Most common on bridges, overpasses, and shaded curves
- If you hit black ice: Do NOT brake. Do NOT turn. Keep steering straight. Gently lift accelerator. Wait for tires to find pavement.

## Section 5: Strong Wind and Sandstorms

Jordan experiences khamsin winds and sandstorms, especially in spring and summer. High winds and blowing sand create serious driving hazards.

### Effects of Strong Wind

- **Lateral force** pushes vehicles sideways, especially:
  - High-profile vehicles (SUVs, vans, trucks, buses)
  - Lightweight vehicles
  - Vehicles towing trailers
- **Sand reduces visibility** and road grip (sand on pavement is like loose gravel)
- **Sudden gusts** from gaps in buildings, terrain, or passing large trucks

### Wind and Sand Driving Rules

1. **Keep both hands on the steering wheel** – be ready to counter wind gusts.

2. **Reduce speed** – slower speeds reduce wind effect.

3. **Close all windows** – prevents sand from entering the vehicle.

4. **Use low beam or fog lights** during daytime sandstorms. Use low beams after sunset (high beams reflect off sand).

5. **Increase following distance** – sand reduces braking grip.

6. **Watch for:** fallen branches, overturned vehicles, sand drifts across road.

7. **If wind becomes extreme:** Pull off the road completely in a safe location (not on the shoulder if possible). Turn off engine. Set parking brake. Turn on hazard lights. Wait for conditions to improve.

## Section 6: Skid Recovery (Loss of Traction)

Skids occur when tires lose grip. Knowing how to recover is essential.

### Rear-Wheel Skid (Oversteer) – Rear slides out
- **Cause:** Too much speed in a turn, or too much acceleration (rear-wheel drive)
- **Vehicle feels like:** The rear is trying to pass the front
- **Recovery:**
  1. Immediately lift foot from accelerator
  2. **Steer in the direction the rear is sliding** (countersteer)
  3. Do not brake
  4. When rear regains grip, straighten steering wheel

**Example:** Rear slides right. Steer right toward the skid.

### Front-Wheel Skid (Understeer) – Front wheels lose grip
- **Cause:** Too much speed entering a turn, braking in a turn
- **Vehicle feels like:** The front continues straight even though wheels are turned
- **Recovery:**
  1. Lift foot from accelerator
  2. Shift to neutral (or clutch in for manual)
  3. Do NOT brake
  4. Steer toward the direction of skid (continue steering into the turn)
  5. When front regains grip, shift back to Drive (or appropriate gear)

### Four-Wheel Skid (All wheels sliding)
- **Cause:** Braking too hard on slippery surface
- **Recovery:**
  1. Lift accelerator
  2. Shift to neutral
  3. Release brakes to allow wheels to rotate
  4. Pump brakes gently (do not lock wheels)
  5. Steer desired direction

### Skid Prevention
- Reduce speed in rain, snow, ice, gravel
- Brake before turns, not during turns
- Accelerate gently on slippery surfaces
- Avoid abrupt steering movements

## Section 7: Accident and Emergency Procedures

### After a Crash

1. **Stop immediately** – leaving the scene is a crime (hit and run).

2. **Check for injuries** – provide first aid if trained. Call ambulance for any serious injury.

3. **Call police** – required for any crash with injuries or significant damage. Even minor crashes should be reported for insurance purposes.

4. **Do NOT move vehicles** unless:
   - They block traffic completely
   - No serious injuries
   - Minor damage only
   - You have photographed the scene first

5. **Exchange information** with the other driver:
   - Full name
   - Car registration number
   - Driving license number
   - Insurance company and policy number

6. **Document the scene** (if safe):
   - Photograph all vehicles from multiple angles
   - Photograph license plates
   - Photograph the intersection or location
   - Get witness names and phone numbers

### Your Legal Duty as a Witness

If you pass a crash with injuries, you are legally required to stop and help until emergency services arrive. Failure to do so is a crime.

### Reporting Requirement

If you are involved in a crash, you must report it within **48 hours** to the police or licensing department with your name, car number, and license number. Failure to report makes you a "fleeing the scene" offender with severe penalties.

### Breakdown Emergency (Review from Module 6)
1. Move off road
2. Hazard lights on
3. Reflective triangle 100m (rural) or 50m (urban) before vehicle
4. At night: parking lights on
5. Do not stand between vehicle and traffic
6. Call for help
7. If disabled and cannot exit: stay inside, hazard lights on, call for help');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (8, 'ar', N'# ظروف القيادة الصعبة - الليل، الطقس، وحالات الطوارئ

تصبح القيادة أكثر خطورة بشكل ملحوظ في الظروف المعاكسة. تتضاعف معدلات الاصطدام ثلاث مرات في الليل أو في المطر أو في الضباب. تعلمك هذه الوحدة كيفية تكييف قيادتك للبقاء آمنًا.

## القسم 1: القيادة الليلية

### الإحصائيات
- معدل الحوادث **يتضاعف** ليلاً مقارنة بالنهار.
- عند السرعات التي تزيد عن 110 كم/ساعة، يزداد معدل التصادم الليلي **ست مرات**.
- تحدث معظم حوادث المرور الليلية بين منتصف الليل والساعة 6 صباحًا، خصوصًا بين الساعة 2 صباحًا و4 صباحًا.

### حدود الرؤية في الليل
- يتم تقليل إدراك العمق
- تضيق الرؤية المحيطية
- انخفاض التعرف على الألوان (يبدو اللون الأحمر أسودًا، والأخضر يبدو رماديًا)
- يستغرق التعافي من الوهج وقتًا أطول (من 5 إلى 10 ثوانٍ بعد الأضواء الساطعة)
- تقل الرؤية بشكل عام بنسبة 50-70%

### قائمة التحقق من سلامة القيادة الليلية

**قبل القيادة:**
- التأكد من عمل جميع الأضواء: المصابيح الأمامية (الشعاع العالي والمنخفض)، المصابيح الخلفية، أضواء الفرامل، إشارات الانعطاف، أضواء الخطر
- تنظيف المصابيح الأمامية والخلفية والنوافذ (من الداخل والخارج)
- قم بتوجيه المصابيح الأمامية بشكل صحيح (اسأل الميكانيكي إذا لم تكن متأكدًا)
- التأكد من أن العلامات العاكسة ولوحات الترخيص نظيفة ومرئية

**أثناء القيادة:**
- استخدم **الإنارة المنخفضة** داخل المدن وعلى الطرق المضاءة جيدًا
- استخدم **الأضواء العالية** على الطرق الريفية المظلمة التي لا توجد بها حركة مرور قادمة
- **الإضاءات العالية الخافتة** عندما:
  - وجود مركبة أمامك بأقل من 200 متر في اتجاهك
  - اقتراب مركبة من الاتجاه المعاكس (خافتة على الأقل 150 متر قبل اللقاء)
- قلل السرعة - مسافة الرؤية الفعالة لديك أقصر من مسافة التوقف
- قم بزيادة مسافة التتبع إلى 3-4 ثوانٍ كحد أدنى
- كن حذرًا جدًا عند التقاطعات (قد لا يراك السائقون الآخرون)
- انتبه للمشاة وراكبي الدراجات والحيوانات (تصعب رؤيتهم في الليل)

### إدارة الوهج

**من الأضواء العالية القادمة:**
- ابطئ
- انظر إلى الحافة اليمنى من الطريق (استخدم الخط أو الكتف الأيمن كدليل)
- لا تحدق في الأضواء
- حافظ على حقك في مسارك
- لا تضيء الأنوار العالية مرة أخرى (فهذا يشكل خطراً عليكما)

**من الأضواء العالية خلفك:**
- اضبط مرآة الرؤية الخلفية على الوضع الليلي (اقلب علامة التبويب)
- خفف السرعة واترك السيارة تمر
- لا تقم بفحص الفرامل للسائق

**سيناريو العالم الحقيقي:** أنت تقود على طريق ريفي مظلم بسرعة 90 كم/ساعة مع تشغيل الأضواء العالية. ترى المصابيح الأمامية تقترب من منحنى. قم بإطفاء أضواءك على بعد 150 مترًا قبل الاجتماع. السائق القادم لا يخفت صوته. تنظر إلى الحافة اليمنى من الطريق، وتبطئ إلى 70 كم/ساعة، وتظل في مسارك. بعد الاجتياز تعود إلى السرعة العادية والأضواء العالية. تمنع هذه الاستجابة الآمنة العمى المؤقت والاصطدام المحتمل.

## القسم الثاني: القيادة في الضباب

يعد الضباب من أخطر الظروف لأنه يقلل الرؤية بشكل كبير ويخلق خداعًا بصريًا.

### أنواع الضباب والرؤية
- ضباب خفيف: مدى الرؤية 200 – 400 متر – خفض السرعة قليلاً
- ضباب متوسط: مدى الرؤية 100 – 200 متر – خفض السرعة بشكل ملحوظ
- ضباب كثيف: مدى الرؤية 50-100 متر - قم بالقيادة ببطء شديد، وفكر في التوقف
- ضباب كثيف: مدى الرؤية أقل من 50 مترًا - ابتعد عن الطريق بأمان

### قواعد القيادة في الضباب

1. **استخدم المصابيح الأمامية ذات الضوء المنخفض** – وليس الأضواء العالية. تعكس الحزم العالية قطرات الضباب وتشكل جدارًا أبيض، مما يقلل من الرؤية بشكل أكبر.

2. **استخدم مصابيح الضباب** إذا كانت سيارتك مزودة بها - ولكن فقط في الضباب أو الأمطار الغزيرة/الثلوج. لا تستخدم مصابيح الضباب في ظروف واضحة (فهي تعمي السائقين الآخرين).

3. **تقليل السرعة بشكل كبير.** كدليل:
   - مدى الرؤية 200 متر: السرعة القصوى 50 كم/ساعة
   - مدى الرؤية 100 متر: الحد الأقصى 30 كم/ساعة
   - مدى الرؤية 50 مترًا: الحد الأقصى 15 كم/ساعة

4. **قم بزيادة مسافة المتابعة إلى أكثر من 5 ثوانٍ** - قد لا ترى أضواء الفرامل حتى تكون قريبة جدًا.

5. **استخدم خط الحافة اليمنى كدليل** - اتبع العلامات البيضاء أو العاكسة على الجانب الأيمن.

6. **لا تتوقف في حارات السفر** - إذا انخفضت الرؤية إلى ما يقرب من الصفر، اخرج بعناية من الطريق تمامًا، وقم بتشغيل أضواء الخطر، وانتظر حتى تتحسن الظروف.

7. **احترس من المركبات التي توقفت أمامك** - يمكن للضباب أن يخفي المركبات المتوقفة حتى تكون قريبًا جدًا.

**سيناريو العالم الحقيقي:** تدخل إلى ضفة ضباب على الطريق السريع. وتنخفض الرؤية إلى 50 مترًا. خفض السرعة إلى 20 كم/ساعة، واستخدم الأضواء المنخفضة ومصابيح الضباب، واتبع خط الحافة اليمنى. ترى المصابيح الخلفية أمامك – سلسلة من السيارات تتحرك بسرعة 15 كم/ساعة. تحافظ على فجوة مدتها 5 ثوان. وبعد 20 دقيقة ينقشع الضباب. لقد تجنبت تصادم سيارات متعددة حدث على بعد كيلومتر واحد أمامك حيث كان السائقون مسرعين.

## القسم الثالث: الأمطار والطرق الرطبة

يقلل المطر من تماسك الإطارات (الجر) ويزيد من مسافات التوقف بشكل كبير.

### فقدان الجر أثناء المطر

| الحالة | الجر مقارنة بالطريق الجاف |
|-----------|---------------------------|
| أمطار خفيفة (الطريق رطبة قليلاً) | 80-90% من الجر الجاف |
| أمطار متوسطة (مياه راكدة) | 50-70% من الجر الجاف |
| أمطار غزيرة (المياه الجارية) | 30-50% من الجر الجاف |
| المطر الأول بعد فترة الجفاف (ارتفاع النفط إلى السطح) | منخفضة تصل إلى 20-30% (زلقة للغاية) |

### قواعد القيادة أثناء المطر

1. **تقليل السرعة** – تتطلب الطرق الرطبة سرعات أقل للتوقف الآمن.

2. **قم بزيادة مسافة المتابعة إلى أكثر من 4 ثوانٍ.**

3. **استخدم المصابيح الأمامية ذات الضوء المنخفض** - وهو أمر مطلوب بموجب القانون أثناء المطر في العديد من الولايات القضائية. تعكس الحزم العالية قطرات المطر.

4. **تجنب الفرملة المفاجئة أو المنعطفات الحادة** - مدخلات لطيفة فقط.

5. **استخدم ماسحات الزجاج الأمامي** - استبدل شفرات الماسحات سنويًا للحصول على أفضل أداء.

6. **إزالة الصقيع من النوافذ** - استخدم مزيل الصقيع لمنع تكون الضباب داخل السيارة.

7. **احترس من الانزلاق المائي** - عندما تفقد الإطارات الاتصال بالطريق وتصطدم بطبقة من الماء.

### الانزلاق المائي: الأسباب والعلاج

**يحدث التحليق المائي عندما:**
- السرعة عالية جدًا بالنسبة لعمق الماء
- مداس الإطار متآكل (عمق مداس أقل من 3 مم)
- عمق الماء يتجاوز سعة مداس الإطار
- يحدث عادة بسرعة أعلى من 70-80 كم/ساعة في المياه الراكدة

**علامات الانزلاق المائي:**
- التوجيه يشعر بأنه "خفيف"
- عدم استجابة السيارة لمدخلات التوجيه
- صوت المحرك أعلى (مقاومة أقل)

**إذا كنت بالطائرة المائية:**
- **لا** تضغط على الفرامل فجأة
- **لا** تستدير بشكل حاد
- **بلطف** ارفع دواسة الوقود
- حافظ على عجلة القيادة مستقيمة
- انتظر حتى تستعيد الإطارات الاتصال (عادةً من 1 إلى 3 ثوانٍ)
- عند عودة الجر، تابع السير بسرعة منخفضة

**سيناريو العالم الحقيقي:** يبدأ هطول أمطار غزيرة أثناء القيادة بسرعة 100 كم/ساعة. أنت تتجاهل النصيحة وتحافظ على السرعة. لقد اصطدمت برقعة من المياه الراكدة. يصبح التوجيه خفيفًا - أنت تحلق مائيًا. أنت ذعر وضغطت على الفرامل. تدور السيارة. لقد تحطمت. البديل: لقد خفضت السرعة إلى 70 كم/ساعة عند بدء هطول الأمطار. يمكنك الحفاظ على السيطرة والوصول بأمان وتجنب وقوع حادث.

## القسم 4: الثلج والجليد

يعد الثلج والجليد من أخطر أسطح القيادة. إذا لم تكن لديك خبرة في القيادة في هذه الظروف، فكر في تأجيل السفر أو استخدام وسائل النقل العام.

### مستويات الجر على الجليد والثلج
- الطريق الجاف: قوة جر 100%
- الطريق الرطب: 50-70% جر
- الثلوج المكدسة: 20-30% جر
- الثلج: 5-10% جر

### قواعد القيادة على الجليد والثلج

1. **خفض السرعة بشكل كبير** - بحد أقصى 30-40 كم/ساعة على الثلج، و10-20 كم/ساعة على الجليد.

2. **زيادة مسافة التتبع إلى أكثر من 10 ثوانٍ** - مسافات التوقف على الجليد أطول بـ 10 مرات من الطرق الجافة.

3. **تجنب أي شيء مفاجئ** - لا يوجد تسارع مفاجئ أو فرملة أو توجيه.

4. **استخدم تروسًا أقل** - توفر فرملة المحرك تحكمًا أكبر من الفرامل على الجليد. في الوضع التلقائي، استخدم "2" أو "L" أو الوضع اليدوي.

5. **الفرامل بلطف وفي وقت مبكر** - في حالة قفل العجلات، قم بتحرير الفرامل وضخها (أو دع نظام ABS يعمل).

6. **كن حذرًا للغاية بشأن:** الجسور (التجميد أولاً)، والمناطق المظللة (يظل الجليد أطول)، والمنحنيات، والتقاطعات (الثلج المصقول الناتج عن توقف المركبات).

7. **إذا واجهتك مشكلة:** لا تقم بتدوير الإطارات (قم بالحفر بشكل أعمق). تأرجح للأمام والخلف (للأمام، للخلف، للأمام). استخدم الرمل أو الملح أو حصائر الأرضية أسفل الإطارات من أجل الجر.

### الجليد الأسود
- جليد رقيق وشفاف يشبه الرصيف الرطب
- خطير للغاية لأن السائقين لا يرونه
- أكثر شيوعاً على الجسور والجسور والمنحنيات المظللة
- إذا اصطدمت بالثلج الأسود: لا تستخدم المكابح. لا تتحول. حافظ على التوجيه بشكل مستقيم. ارفع دواسة الوقود بلطف. انتظر حتى تجد الإطارات الرصيف.

## القسم الخامس: الرياح القوية والعواصف الرملية

ويشهد الأردن رياح الخمسين والعواصف الرملية، خاصة في فصلي الربيع والصيف. تشكل الرياح العاتية والرمال العاتية مخاطر جسيمة أثناء القيادة.

### آثار الرياح القوية

- **القوة الجانبية** تدفع المركبات جانبًا، خصوصًا:
  - المركبات رفيعة المستوى (سيارات الدفع الرباعي والشاحنات الصغيرة والشاحنات والحافلات)
  - المركبات الخفيفة
  - مركبات سحب المقطورات
- **الرمال تقلل من مدى الرؤية** وتماسك الطريق (الرمال الموجودة على الرصيف تشبه الحصى السائب)
- **هبات مفاجئة** ناجمة عن الفجوات في المباني أو التضاريس أو مرور الشاحنات الكبيرة

### قواعد القيادة بالرياح والرمال

1. **أبق يديك على عجلة القيادة** – كن مستعدًا لمواجهة هبوب الرياح.

2. **تقليل السرعة** – السرعات البطيئة تقلل من تأثير الرياح.

3. **أغلق جميع النوافذ** - يمنع دخول الرمال إلى السيارة.

4. **استخدم الضوء المنخفض أو مصابيح الضباب** أثناء العواصف الرملية أثناء النهار. استخدم عوارض منخفضة بعد غروب الشمس (العوارض العالية تعكس الرمال).

5. **زيادة مسافة التتبع** - الرمال تقلل من قبضة المكابح.

6. **احترس من:** الفروع المتساقطة، والمركبات المقلوبة، وانجراف الرمال عبر الطريق.

7. **إذا اشتدت الرياح:** ابتعد عن الطريق تمامًا في مكان آمن (وليس على الكتف إن أمكن). أطفئ المحرك. ضبط فرامل الانتظار. قم بتشغيل أضواء الخطر. انتظر حتى تتحسن الظروف.

## القسم 6: التعافي من الانزلاق (فقدان الجر)

يحدث الانزلاق عندما تفقد الإطارات قبضتها. معرفة كيفية التعافي أمر ضروري.

### انزلاق العجلة الخلفية (التوجيه الزائد) – ينزلق الجزء الخلفي للخارج
- **السبب:** سرعة كبيرة جدًا أثناء المنعطف، أو تسارع كبير جدًا (الدفع بالعجلات الخلفية)
- **المركبة تبدو وكأنها:** الجزء الخلفي يحاول تجاوز المقدمة
- **الاسترداد:**
  1. ارفع قدمك فورًا عن دواسة الوقود
  2. **توجيه في الاتجاه الذي ينزلق فيه الجزء الخلفي** (توجيه معاكس)
  3. لا تستخدم المكابح
  4. عندما يستعيد الجزء الخلفي قبضته، قم بتسوية عجلة القيادة

**مثال:** الشرائح الخلفية لليمين. توجيه الحق نحو الانزلاق.

### انزلاق العجلة الأمامية (انخفاض التوجيه) – تفقد العجلات الأمامية قبضتها
- **السبب:** السرعة الزائدة عند الدخول في المنعطف، والكبح في المنعطف
- **تبدو السيارة كما يلي:** يستمر الجزء الأمامي في الاستقامة على الرغم من دوران العجلات
- **الاسترداد:**
  1. ارفع القدم عن دواسة الوقود
  2. التحول إلى الوضع المحايد (أو القابض لليدوي)
  3. لا تستخدم المكابح
  4. قم بالتوجيه نحو اتجاه الانزلاق (واصل التوجيه في المنعطف)
  5. عندما يستعيد الجزء الأمامي قبضته، انتقل مرة أخرى إلى وضع القيادة (أو الترس المناسب)

### انزلاق على العجلات الأربع (انزلاق جميع العجلات)
- **السبب:** الكبح بقوة شديدة على الأسطح الزلقة
- **الاسترداد:**
  1. ارفع دواسة الوقود
  2. التحول إلى الحياد
  3. حرر الفرامل للسماح للعجلات بالدوران
  4. ضخ الفرامل بلطف (لا تقفل العجلات)
  5. توجيه الاتجاه المطلوب

### منع الانزلاق
- تقليل السرعة في المطر والثلج والجليد والحصى
- الفرامل قبل المنعطفات وليس أثناء المنعطفات
- تسريع بلطف على الأسطح الزلقة
- تجنب حركات التوجيه المفاجئة

## القسم السابع: إجراءات الحوادث والطوارئ

### بعد الحادث

1. **توقف فورًا** - مغادرة المكان جريمة (الضرب والهرب).

2. **التحقق من وجود إصابات** – قم بتقديم الإسعافات الأولية إذا تم تدريبك. اتصل بالإسعاف في حالة حدوث أي إصابة خطيرة.

3. **اتصل بالشرطة** - مطلوب في حالة حدوث إصابات أو أضرار جسيمة. وينبغي الإبلاغ حتى عن الأعطال الطفيفة لأغراض التأمين.

4. **لا تحرك المركبات** إلا إذا:
   - يمنعون حركة المرور بشكل كامل
   - لا توجد إصابات خطيرة
   - أضرار طفيفة فقط
   - لقد قمت بتصوير المشهد أولا

5. **تبادل المعلومات** مع السائق الآخر:
   - الاسم الكامل
   - رقم تسجيل السيارة
   - رقم رخصة القيادة
   - شركة التأمين ورقم البوليصة

6. **توثيق المشهد** (إذا كان آمنًا):
   - تصوير جميع المركبات من زوايا متعددة
   - صور لوحات الترخيص
   - تصوير التقاطع أو الموقع
   - الحصول على أسماء الشهود وأرقام الهواتف

### واجبك القانوني كشاهد

إذا مررت بحادث تصادم مصحوبًا بإصابات، فيجب عليك قانونًا التوقف والمساعدة حتى وصول خدمات الطوارئ. عدم القيام بذلك يعد جريمة.

### متطلبات الإبلاغ

إذا كنت متورطًا في حادث تصادم، فيجب عليك الإبلاغ عنه في غضون **48 ساعة** إلى الشرطة أو قسم الترخيص مع اسمك ورقم سيارتك ورقم الترخيص. عدم الإبلاغ يجعلك مجرمًا "فاربًا من مكان الحادث" ويعاقبك بعقوبات صارمة.

### طوارئ الأعطال (مراجعة من الوحدة 6)
1. التحرك خارج الطريق
2. أضواء الخطر مضاءة
3. مثلث عاكس 100 م (ريفي) أو 50 م (حضري) قبل السيارة
4. في الليل: أضواء وقوف السيارات مضاءة
5. لا تقف بين السيارة وحركة المرور
6. اطلب المساعدة
7. إذا كنت معطلاً ولا تستطيع الخروج: ابق في الداخل، وأضيئ أضواء الخطر، واطلب المساعدة');

GO


-- ============================================
-- FILE: 14_Seeds\04_seed_all_quizzes_questions_options.sql
-- ============================================

-- =============================================
-- Auto-generated seed file
-- =============================================

-- Quizzes (base)
SET IDENTITY_INSERT Learning.Quizzes ON;
INSERT INTO Learning.Quizzes (quiz_id, module_id, is_mock_exam, license_type_id, passing_score) VALUES (1, 1, 0, NULL, 70);
INSERT INTO Learning.Quizzes (quiz_id, module_id, is_mock_exam, license_type_id, passing_score) VALUES (2, 2, 0, NULL, 70);
INSERT INTO Learning.Quizzes (quiz_id, module_id, is_mock_exam, license_type_id, passing_score) VALUES (3, 3, 0, NULL, 70);
INSERT INTO Learning.Quizzes (quiz_id, module_id, is_mock_exam, license_type_id, passing_score) VALUES (4, 4, 0, NULL, 70);
INSERT INTO Learning.Quizzes (quiz_id, module_id, is_mock_exam, license_type_id, passing_score) VALUES (5, 5, 0, NULL, 70);
INSERT INTO Learning.Quizzes (quiz_id, module_id, is_mock_exam, license_type_id, passing_score) VALUES (6, 6, 0, NULL, 70);
INSERT INTO Learning.Quizzes (quiz_id, module_id, is_mock_exam, license_type_id, passing_score) VALUES (7, 7, 0, NULL, 70);
INSERT INTO Learning.Quizzes (quiz_id, module_id, is_mock_exam, license_type_id, passing_score) VALUES (8, 8, 0, NULL, 70);
SET IDENTITY_INSERT Learning.Quizzes OFF;

-- Quiz translations
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (1, 'en', N'Quiz: Introduction to Driving Responsibilities and Legal Framework');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (1, 'ar', N'اختبار: مقدمة لمسؤوليات القيادة والإطار القانوني');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (2, 'en', N'Quiz: Road Markings - Lines, Symbols, and Meanings');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (2, 'ar', N'اختبار: علامات الطريق - الخطوط والرموز والمعاني');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (3, 'en', N'Quiz: Traffic Signs Complete Guide');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (3, 'ar', N'اختبار: الدليل الكامل لإشارات المرور');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (4, 'en', N'Quiz: Right-of-Way Rules at Intersections and Roundabouts');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (4, 'ar', N'اختبار: قواعد حق الطريق عند التقاطعات والدوارات');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (5, 'en', N'Quiz: Lane Discipline, Turning, and Overtaking');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (5, 'ar', N'اختبار: انضباط المسار، والانعطاف، والتجاوز');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (6, 'en', N'Quiz: Speed Limits, Following Distance, and Stopping');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (6, 'ar', N'اختبار: حدود السرعة، ومسافة المتابعة، والتوقف');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (7, 'en', N'Quiz: Alcohol, Drugs, Fatigue, and Safe Driving Fitness');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (7, 'ar', N'اختبار: الكحول والمخدرات والتعب ولياقة القيادة الآمنة');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (8, 'en', N'Quiz: Difficult Driving Conditions - Night, Weather, and Emergencies');
INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) VALUES (8, 'ar', N'اختبار: ظروف القيادة الصعبة - الليل والطقس وحالات الطوارئ');

-- Questions (base)
SET IDENTITY_INSERT Learning.QuizQuestions ON;
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (1, 1);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (2, 1);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (3, 1);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (4, 1);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (5, 1);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (6, 1);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (7, 1);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (8, 1);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (9, 1);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (10, 1);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (11, 2);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (12, 2);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (13, 2);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (14, 2);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (15, 2);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (16, 2);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (17, 2);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (18, 2);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (19, 2);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (20, 2);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (21, 3);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (22, 3);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (23, 3);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (24, 3);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (25, 3);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (26, 3);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (27, 3);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (28, 3);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (29, 3);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (30, 3);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (31, 4);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (32, 4);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (33, 4);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (34, 4);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (35, 4);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (36, 4);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (37, 4);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (38, 4);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (39, 4);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (40, 4);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (41, 5);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (42, 5);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (43, 5);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (44, 5);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (45, 5);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (46, 5);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (47, 5);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (48, 5);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (49, 5);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (50, 5);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (51, 6);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (52, 6);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (53, 6);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (54, 6);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (55, 6);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (56, 6);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (57, 6);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (58, 6);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (59, 6);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (60, 6);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (61, 7);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (62, 7);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (63, 7);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (64, 7);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (65, 7);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (66, 7);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (67, 7);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (68, 7);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (69, 7);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (70, 7);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (71, 8);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (72, 8);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (73, 8);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (74, 8);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (75, 8);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (76, 8);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (77, 8);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (78, 8);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (79, 8);
INSERT INTO Learning.QuizQuestions (question_id, quiz_id) VALUES (80, 8);

SET IDENTITY_INSERT Learning.QuizQuestions OFF;

-- Question translations
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (1, 'en', N'You are driving on a main road and approach an intersection where a vehicle is waiting to enter from a side road. What should you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (1, 'ar', N'أنت تقود على طريق رئيسي وتقترب من تقاطع تنتظر فيه مركبة الدخول من طريق جانبي. ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (2, 'en', N'What is the minimum vision requirement for obtaining a private driving license in Jordan?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (2, 'ar', N'ما هو الحد الأدنى من متطلبات الرؤية للحصول على رخصة القيادة الخاصة في الأردن؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (3, 'en', N'A driver causes a fatal crash while driving without a valid license. What is the potential imprisonment term?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (3, 'ar', N'يتسبب سائق في حادث مميت أثناء القيادة بدون رخصة سارية. ما هي مدة السجن المحتملة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (4, 'en', N'Which license category is required to drive a public passenger vehicle up to 7.5 tons?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (4, 'ar', N'ما هي فئة الترخيص المطلوبة لقيادة مركبة ركاب عامة يصل وزنها إلى 7.5 طن؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (5, 'en', N'A driver accumulates 24 points on their license within one year. What happens?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (5, 'ar', N'يجمع السائق 24 نقطة على رخصته خلال عام واحد. ماذا يحدث؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (6, 'en', N'Scenario: You are a Category 3 license holder. How long must you wait before applying for a Category 4 license?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (6, 'ar', N'السيناريو: أنت حامل ترخيص من الفئة 3. ما هي المدة التي يجب عليك الانتظار قبل التقدم بطلب للحصول على ترخيص الفئة 4؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (7, 'en', N'What does the statement ''priority is given, not taken'' mean in practical driving?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (7, 'ar', N'ماذا تعني عبارة "الأولوية تعطى ولا تؤخذ" في القيادة العملية؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (8, 'en', N'You fail your theoretical driving test. When can you retake it?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (8, 'ar', N'لقد فشلت في اختبار القيادة النظري. متى يمكنك إعادته؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (9, 'en', N'Which of the following is NOT a required document for a new driving license application?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (9, 'ar', N'أي مما يلي ليس مستندًا مطلوبًا لطلب رخصة قيادة جديدة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (10, 'en', N'During the practical driving test, the examiner stops your test because your driving poses an immediate danger. What is the result?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (10, 'ar', N'أثناء اختبار القيادة العملي، يقوم الممتحن بإيقاف الاختبار لأن قيادتك تشكل خطراً مباشراً. ما هي النتيجة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (11, 'en', N'{{img:solid-yellow-line}} What does this line mean for you?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (11, 'ar', N'{{img:solid-yellow-line}} ماذا يعني هذا الخط بالنسبة لك؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (12, 'en', N'What is the legal requirement when you approach a stop line painted across the road?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (12, 'ar', N'ما هو المطلب القانوني عند الاقتراب من خط التوقف المرسوم على الجانب الآخر من الطريق؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (13, 'en', N'Scenario: You are driving on a rural road outside the city. The center line is broken with a 3:1 ratio (longer dashes). What does this allow?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (13, 'ar', N'السيناريو: أنت تقود على طريق ريفي خارج المدينة. يتم كسر خط الوسط بنسبة 3:1 (شرطات أطول). ماذا يسمح هذا؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (14, 'en', N'What does a hatched area surrounded by solid lines indicate?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (14, 'ar', N'إلى ماذا تشير المنطقة المظللة المحاطة بخطوط متصلة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (15, 'en', N'{{img:zebra-crossing}} What is the maximum speed limit when approaching this road marking?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (15, 'ar', N'{{img:zebra-crossing}} ما هو الحد الأقصى للسرعة عند الاقتراب من علامة الطريق هذه؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (16, 'en', N'You are in a lane with a painted arrow pointing straight ahead only. What are you legally permitted to do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (16, 'ar', N'أنت في حارة بها سهم مرسوم يشير إلى الأمام فقط. ما الذي يسمح لك قانونًا بفعله؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (17, 'en', N'What do yellow lines painted on the road typically indicate?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (17, 'ar', N'إلى ماذا تشير الخطوط الصفراء المرسومة على الطريق عادة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (18, 'en', N'Scenario: You approach an intersection. The road has a yield line (broken triangles) painted across your lane. What must you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (18, 'ar', N'السيناريو: أنت تقترب من التقاطع. يحتوي الطريق على خط استسلام (مثلثات مكسورة) مرسوم عبر حارتك. ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (19, 'en', N'What does a painted bicycle symbol between two solid white lines mean?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (19, 'ar', N'ماذا يعني رمز الدراجة المرسوم بين خطين أبيضين متصلين؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (20, 'en', N'You see a broken line on your side of the road and a solid line on the opposite side. What does this mean for overtaking?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (20, 'ar', N'ترى خطًا متقطعًا على جانبك من الطريق وخطًا متصلًا على الجانب الآخر. ماذا يعني هذا للتجاوز؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (21, 'en', N'{{img:inverted-triangle}} What does this sign require you to do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (21, 'ar', N'{{img:inverted-triangle}} ما الذي تتطلب منك هذه العلامة أن تفعله؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (22, 'en', N'What shape and color combination indicates a prohibition sign?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (22, 'ar', N'ما هو الشكل واللون الذي يشير إلى علامة الحظر؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (23, 'en', N'Scenario: You are driving on a narrow mountain road and see {{img:red-up-black-down}}. What does this mean?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (23, 'ar', N'السيناريو: أنت تقود سيارتك على طريق جبلي ضيق وانظر {{img:red-up-black-down}}. ماذا يعني هذا؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (24, 'en', N'{{img:yellow-diamond}} What does this sign indicate?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (24, 'ar', N'{{img:yellow-diamond}} إلى ماذا تشير هذه العلامة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (25, 'en', N'You see a blue circular sign with a white number ''50'' inside. What does this require?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (25, 'ar', N'ترى علامة دائرية زرقاء بداخلها رقم أبيض "50". ماذا يتطلب هذا؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (26, 'en', N'What does a red circle with a car and motorcycle inside, crossed by a red diagonal line mean?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (26, 'ar', N'ماذا يعني دائرة حمراء بداخلها سيارة ودراجة نارية، يقطعها خط قطري أحمر؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (27, 'en', N'Scenario: You approach a tunnel. Which sign would you expect to see, and what is the speed limit?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (27, 'ar', N'السيناريو: أنت تقترب من النفق. ما هي العلامة التي تتوقع رؤيتها، وما هو الحد الأقصى للسرعة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (28, 'en', N'What does a red-bordered triangle with a symbol of a pedestrian crossing mean?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (28, 'ar', N'ماذا يعني المثلث ذو الحدود الحمراء مع رمز معبر المشاة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (29, 'en', N'{{img:blue-square}} What does this sign tell you?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (29, 'ar', N'{{img:blue-square}} ماذا تخبرك هذه العلامة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (30, 'en', N'You see a round sign with a red border, white background, and the number ''80'' in black. What is the legal requirement?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (30, 'ar', N'ترى علامة مستديرة ذات حدود حمراء وخلفية بيضاء والرقم "80" باللون الأسود. ما هو المطلب القانوني؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (31, 'en', N'You arrive at an uncontrolled intersection (no signs, no lights). A vehicle is approaching from your right. Who has priority?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (31, 'ar', N'وصلت إلى تقاطع غير متحكم فيه (لا توجد إشارات ولا أضواء). هناك مركبة تقترب من يمينك. لمن الأولوية؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (32, 'en', N'Scenario: You are inside a roundabout. A vehicle at the entrance wants to enter. What is the rule?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (32, 'ar', N'السيناريو: أنت داخل الدوار. سيارة عند المدخل تريد الدخول. ما هي القاعدة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (33, 'en', N'At a T-junction, which road has priority?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (33, 'ar', N'عند تقاطع T، أي طريق له الأولوية؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (34, 'en', N'You are turning left at an intersection. An oncoming vehicle is going straight. Who goes first?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (34, 'ar', N'أنت تنعطف يسارًا عند تقاطع. مركبة قادمة تسير بشكل مستقيم. من يذهب أولا؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (35, 'en', N'You hear a siren and see flashing lights from an ambulance behind you. What must you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (35, 'ar', N'تسمع صفارة الإنذار وترى الأضواء الساطعة من سيارة الإسعاف خلفك. ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (36, 'en', N'Scenario: You are exiting a gas station (private property) and want to enter a busy road. What is your legal duty?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (36, 'ar', N'السيناريو: أنت تخرج من محطة وقود (ملكية خاصة) وتريد الدخول إلى طريق مزدحم. ما هو واجبك القانوني؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (37, 'en', N'You approach a roundabout and intend to take the third exit (left turn). Which lane should you enter from?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (37, 'ar', N'تقترب من الدوار وتنوي اتخاذ المخرج الثالث (الانعطاف يسارًا). من أي حارة يجب أن تدخل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (38, 'en', N'What does the golden rule ''priority is given, not taken'' mean when approaching an intersection with a green light?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (38, 'ar', N'ماذا تعني القاعدة الذهبية "الأولوية تعطى ولا تؤخذ" عند الاقتراب من تقاطع بضوء أخضر؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (39, 'en', N'At a railway crossing with gates down, what must you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (39, 'ar', N'عند معبر السكة الحديد وبواباته مفتوحة، ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (40, 'en', N'Scenario: You are on a main road (yellow diamond sign). A vehicle from a side road pulls out in front of you. Who is at fault?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (40, 'ar', N'السيناريو: أنت على طريق رئيسي (علامة الماسة الصفراء). خروج مركبة من طريق جانبي أمامك. من هو المخطئ؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (41, 'en', N'On a multi-lane highway, which lane should slower vehicles use?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (41, 'ar', N'على الطريق السريع متعدد الحارات، أي حارة يجب أن تستخدمها المركبات الأبطأ؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (42, 'en', N'Scenario: You want to turn left at an intersection on a two-way road with one lane each direction. Where should you position your vehicle?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (42, 'ar', N'السيناريو: تريد الانعطاف يسارًا عند تقاطع طرق على طريق ذو اتجاهين بمسار واحد في كل اتجاه. أين يجب أن تضع سيارتك؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (43, 'en', N'What is prohibited by this sign?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (43, 'ar', N'ما الذي تمنعه ​​هذه العلامة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (44, 'en', N'You are overtaking a vehicle on a two-lane road. When should you return to your original lane?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (44, 'ar', N'أنت تتجاوز مركبة على طريق ذو مسارين. متى يجب عليك العودة إلى مسارك الأصلي؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (45, 'en', N'Scenario: You are driving on a curve and cannot see far ahead. A vehicle ahead is moving slowly. What should you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (45, 'ar', N'السيناريو: أنت تقود على منحنى ولا تستطيع الرؤية للأمام. السيارة التي أمامك تتحرك ببطء. ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (46, 'en', N'What is the correct hand position on the steering wheel for airbag safety?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (46, 'ar', N'ما هو وضع اليد الصحيح على عجلة القيادة لضمان سلامة الوسادة الهوائية؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (47, 'en', N'You want to change lanes on a highway. What is the correct sequence of actions?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (47, 'ar', N'تريد تغيير الممرات على الطريق السريع. ما هو التسلسل الصحيح للإجراءات؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (48, 'en', N'Scenario: A truck begins overtaking you on a two-lane road. What should you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (48, 'ar', N'السيناريو: تبدأ شاحنة في تجاوزك على طريق مكون من مسارين. ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (49, 'en', N'Where is a U-turn prohibited even without a specific sign?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (49, 'ar', N'أين يُمنع الدوران على شكل حرف U حتى بدون وجود إشارة محددة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (50, 'en', N'At a roundabout, you want to take the first exit (right turn). Which lane should you enter from?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (50, 'ar', N'عند الدوار، تريد أن تسلك المخرج الأول (الاتجاه الأيمن). من أي حارة يجب أن تدخل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (51, 'en', N'What is the maximum speed limit for a private car on a multi-lane divided highway outside city limits in Jordan?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (51, 'ar', N'ما هو الحد الأقصى للسرعة القصوى للسيارة الخاصة على الطريق السريع المقسم متعدد المسارات خارج حدود المدينة في الأردن؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (52, 'en', N'Scenario: You are driving at 80 km/h on a wet road. What following distance should you maintain?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (52, 'ar', N'السيناريو: أنت تقود بسرعة 80 كم/ساعة على طريق مبلل. ما المسافة التالية التي يجب عليك الحفاظ عليها؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (53, 'en', N'Where must you place the reflective triangle if you break down on a rural road?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (53, 'ar', N'أين يجب أن تضع المثلث العاكس إذا تعطلت على طريق ريفي؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (54, 'en', N'What does the two-second rule help you maintain?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (54, 'ar', N'ما الذي تساعدك قاعدة الثانيتين في الحفاظ عليه؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (55, 'en', N'You exceed the speed limit by 40 km/h. What is the penalty?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (55, 'ar', N'لقد تجاوزت الحد الأقصى للسرعة بمقدار 40 كم/ساعة. ما هي العقوبة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (56, 'en', N'Scenario: You are driving at 50 km/h in a residential area. A child runs into the street. Approximately how far will you travel before you even begin braking (reaction distance)?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (56, 'ar', N'السيناريو: أنت تقود بسرعة 50 كم/ساعة في منطقة سكنية. طفل يجري في الشارع. ما هي المسافة التقريبية التي ستقطعها قبل أن تبدأ بالفرملة (مسافة رد الفعل)؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (57, 'en', N'Where is parking prohibited?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (57, 'ar', N'أين يمنع وقوف السيارات؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (58, 'en', N'What is the speed limit near schools and local residential roads?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (58, 'ar', N'ما هو الحد الأقصى للسرعة بالقرب من المدارس والطرق السكنية المحلية؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (59, 'en', N'You are stopped behind another vehicle at a red light. How much space should you leave?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (59, 'ar', N'لقد تم إيقافك خلف مركبة أخرى عند الإشارة الحمراء. ما مقدار المساحة التي يجب أن تتركها؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (60, 'en', N'Scenario: You break down on a highway at night with no streetlights. What must you do in addition to using hazard lights?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (60, 'ar', N'السيناريو: تعطلت سيارتك على طريق سريع ليلاً دون إضاءة الشوارع. ما الذي يجب عليك فعله بالإضافة إلى استخدام أضواء الخطر؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (61, 'en', N'You have been awake for 18 hours. How does this compare to alcohol impairment?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (61, 'ar', N'لقد كنت مستيقظا لمدة 18 ساعة. كيف يمكن مقارنة هذا بضعف الكحول؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (62, 'en', N'Scenario: You took an over-the-counter cold medication that says ''may cause drowsiness.'' You feel fine after 6 hours. Can you drive?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (62, 'ar', N'السيناريو: تناولت أحد أدوية البرد المتاحة دون وصفة طبية والمكتوب عليها "قد يسبب النعاس". تشعر أنك بخير بعد 6 ساعات. هل تستطيع القيادة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (63, 'en', N'What is the legal consequence for refusing a breathalyzer test in Jordan?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (63, 'ar', N'ما هي النتيجة القانونية لرفض فحص الكحول في الأردن؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (64, 'en', N'Which of the following is a sign of driver fatigue?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (64, 'ar', N'أي مما يلي يعد علامة على تعب السائق؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (65, 'en', N'Scenario: You are driving a long distance and feel tired. What should you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (65, 'ar', N'السيناريو: أنت تقود مسافة طويلة وتشعر بالتعب. ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (66, 'en', N'Why is driving while emotionally upset (angry, very sad) dangerous?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (66, 'ar', N'لماذا تعتبر القيادة أثناء الانزعاج العاطفي (غاضبًا، حزينًا جدًا) أمرًا خطيرًا؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (67, 'en', N'Which medication type is most likely to cause drowsiness that affects driving?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (67, 'ar', N'ما هو نوع الدواء الذي من المرجح أن يسبب النعاس الذي يؤثر على القيادة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (68, 'en', N'What is the only effective way to reduce your blood alcohol concentration (BAC)?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (68, 'ar', N'ما هي الطريقة الفعالة الوحيدة لتقليل تركيز الكحول في الدم (BAC)؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (69, 'en', N'Scenario: You are driving at night and an oncoming vehicle does not dim their high beams. What should you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (69, 'ar', N'السيناريو: أنت تقود ليلاً ولا تقوم السيارة القادمة بتعتيم أضوائها العالية. ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (70, 'en', N'Which of the following is considered a dangerous distraction while driving?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (70, 'ar', N'أي مما يلي يعتبر مصدر إلهاء خطير أثناء القيادة؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (71, 'en', N'Why should you use low beam headlights in fog instead of high beams?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (71, 'ar', N'لماذا يجب عليك استخدام المصابيح الأمامية ذات الضوء المنخفض في الضباب بدلاً من الضوء العالي؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (72, 'en', N'Scenario: You are driving in heavy rain and feel your steering become ''light'' and unresponsive. What is happening?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (72, 'ar', N'السيناريو: أنت تقود السيارة تحت أمطار غزيرة وتشعر أن توجيهك أصبح "خفيفًا" وغير مستجيب. ماذا يحدث؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (73, 'en', N'Your rear wheels lose grip and the back of your car slides to the right. What should you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (73, 'ar', N'تفقد العجلات الخلفية قبضتها وينزلق الجزء الخلفي من سيارتك إلى اليمين. ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (74, 'en', N'What is black ice and why is it dangerous?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (74, 'ar', N'ما هو الجليد الأسود ولماذا هو خطير؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (75, 'en', N'Scenario: You are driving in a sandstorm with very low visibility. What should you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (75, 'ar', N'السيناريو: أنت تقود في عاصفة رملية ورؤية منخفضة للغاية. ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (76, 'en', N'How much does night vision typically decrease compared to daylight?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (76, 'ar', N'ما مدى انخفاض الرؤية الليلية عادة مقارنة بضوء النهار؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (77, 'en', N'You are involved in a crash with no injuries but significant damage. What must you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (77, 'ar', N'لقد تعرضت لحادث تصادم دون وقوع إصابات ولكن أضرار جسيمة. ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (78, 'en', N'Scenario: You drive through standing water and your brakes feel less effective afterward. What should you do?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (78, 'ar', N'السيناريو: تقود سيارتك عبر المياه الراكدة وتشعر بأن فراملك أقل فعالية بعد ذلك. ماذا يجب عليك أن تفعل؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (79, 'en', N'What is the recommended action if you hit a patch of ice (black ice)?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (79, 'ar', N'ما هو الإجراء الموصى به إذا اصطدمت برقعة من الجليد (الجليد الأسود)؟');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (80, 'en', N'You witness a crash with injuries. What is your legal duty?');
INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) VALUES (80, 'ar', N'تشهد حادث تصادم مع إصابات. ما هو واجبك القانوني؟');

-- Options (base)
SET IDENTITY_INSERT Learning.QuestionOptions ON;
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (1, 1, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (2, 1, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (3, 1, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (4, 1, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (5, 2, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (6, 2, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (7, 2, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (8, 2, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (9, 3, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (10, 3, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (11, 3, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (12, 3, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (13, 4, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (14, 4, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (15, 4, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (16, 4, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (17, 5, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (18, 5, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (19, 5, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (20, 5, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (21, 6, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (22, 6, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (23, 6, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (24, 6, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (25, 7, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (26, 7, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (27, 7, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (28, 7, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (29, 8, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (30, 8, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (31, 8, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (32, 8, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (33, 9, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (34, 9, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (35, 9, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (36, 9, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (37, 10, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (38, 10, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (39, 10, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (40, 10, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (41, 11, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (42, 11, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (43, 11, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (44, 11, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (45, 12, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (46, 12, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (47, 12, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (48, 12, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (49, 13, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (50, 13, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (51, 13, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (52, 13, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (53, 14, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (54, 14, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (55, 14, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (56, 14, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (57, 15, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (58, 15, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (59, 15, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (60, 15, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (61, 16, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (62, 16, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (63, 16, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (64, 16, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (65, 17, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (66, 17, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (67, 17, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (68, 17, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (69, 18, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (70, 18, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (71, 18, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (72, 18, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (73, 19, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (74, 19, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (75, 19, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (76, 19, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (77, 20, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (78, 20, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (79, 20, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (80, 20, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (81, 21, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (82, 21, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (83, 21, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (84, 21, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (85, 22, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (86, 22, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (87, 22, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (88, 22, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (89, 23, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (90, 23, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (91, 23, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (92, 23, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (93, 24, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (94, 24, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (95, 24, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (96, 24, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (97, 25, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (98, 25, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (99, 25, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (100, 25, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (101, 26, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (102, 26, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (103, 26, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (104, 26, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (105, 27, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (106, 27, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (107, 27, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (108, 27, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (109, 28, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (110, 28, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (111, 28, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (112, 28, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (113, 29, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (114, 29, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (115, 29, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (116, 29, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (117, 30, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (118, 30, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (119, 30, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (120, 30, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (121, 31, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (122, 31, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (123, 31, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (124, 31, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (125, 32, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (126, 32, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (127, 32, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (128, 32, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (129, 33, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (130, 33, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (131, 33, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (132, 33, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (133, 34, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (134, 34, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (135, 34, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (136, 34, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (137, 35, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (138, 35, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (139, 35, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (140, 35, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (141, 36, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (142, 36, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (143, 36, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (144, 36, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (145, 37, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (146, 37, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (147, 37, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (148, 37, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (149, 38, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (150, 38, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (151, 38, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (152, 38, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (153, 39, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (154, 39, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (155, 39, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (156, 39, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (157, 40, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (158, 40, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (159, 40, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (160, 40, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (161, 41, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (162, 41, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (163, 41, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (164, 41, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (165, 42, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (166, 42, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (167, 42, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (168, 42, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (169, 43, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (170, 43, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (171, 43, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (172, 43, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (173, 44, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (174, 44, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (175, 44, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (176, 44, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (177, 45, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (178, 45, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (179, 45, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (180, 45, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (181, 46, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (182, 46, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (183, 46, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (184, 46, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (185, 47, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (186, 47, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (187, 47, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (188, 47, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (189, 48, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (190, 48, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (191, 48, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (192, 48, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (193, 49, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (194, 49, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (195, 49, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (196, 49, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (197, 50, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (198, 50, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (199, 50, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (200, 50, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (201, 51, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (202, 51, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (203, 51, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (204, 51, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (205, 52, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (206, 52, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (207, 52, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (208, 52, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (209, 53, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (210, 53, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (211, 53, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (212, 53, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (213, 54, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (214, 54, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (215, 54, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (216, 54, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (217, 55, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (218, 55, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (219, 55, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (220, 55, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (221, 56, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (222, 56, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (223, 56, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (224, 56, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (225, 57, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (226, 57, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (227, 57, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (228, 57, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (229, 58, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (230, 58, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (231, 58, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (232, 58, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (233, 59, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (234, 59, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (235, 59, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (236, 59, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (237, 60, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (238, 60, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (239, 60, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (240, 60, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (241, 61, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (242, 61, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (243, 61, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (244, 61, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (245, 62, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (246, 62, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (247, 62, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (248, 62, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (249, 63, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (250, 63, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (251, 63, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (252, 63, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (253, 64, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (254, 64, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (255, 64, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (256, 64, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (257, 65, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (258, 65, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (259, 65, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (260, 65, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (261, 66, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (262, 66, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (263, 66, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (264, 66, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (265, 67, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (266, 67, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (267, 67, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (268, 67, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (269, 68, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (270, 68, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (271, 68, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (272, 68, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (273, 69, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (274, 69, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (275, 69, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (276, 69, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (277, 70, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (278, 70, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (279, 70, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (280, 70, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (281, 71, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (282, 71, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (283, 71, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (284, 71, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (285, 72, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (286, 72, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (287, 72, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (288, 72, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (289, 73, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (290, 73, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (291, 73, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (292, 73, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (293, 74, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (294, 74, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (295, 74, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (296, 74, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (297, 75, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (298, 75, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (299, 75, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (300, 75, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (301, 76, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (302, 76, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (303, 76, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (304, 76, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (305, 77, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (306, 77, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (307, 77, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (308, 77, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (309, 78, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (310, 78, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (311, 78, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (312, 78, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (313, 79, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (314, 79, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (315, 79, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (316, 79, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (317, 80, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (318, 80, 1);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (319, 80, 0);
INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) VALUES (320, 80, 0);
SET IDENTITY_INSERT Learning.QuestionOptions OFF;

-- Option translations
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (1, 'en', N'Speed up to pass before the side road vehicle enters');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (1, 'ar', N'الإسراع في المرور قبل دخول مركبة الطريق الجانبية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (2, 'en', N'Continue at normal speed because you have priority on the main road');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (2, 'ar', N'واصل بالسرعة العادية لأن لك الأولوية على الطريق الرئيسي');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (3, 'en', N'Maintain speed but remain alert, knowing you have priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (3, 'ar', N'حافظ على السرعة ولكن كن في حالة تأهب، مع العلم أن لديك الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (4, 'en', N'Stop and wave the side road vehicle to go first');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (4, 'ar', N'توقف ولوح لمركبة الطريق الجانبية لتنطلق أولاً');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (5, 'en', N'6/6 in both eyes');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (5, 'ar', N'6/6 في كلتا العينين');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (6, 'en', N'6/9 in the better eye');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (6, 'ar', N'6/9 في العين الأفضل');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (7, 'en', N'6/12 in the worse eye');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (7, 'ar', N'6/12 في العين الأسوأ');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (8, 'en', N'20/20 in at least one eye');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (8, 'ar', N'20/20 في عين واحدة على الأقل');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (9, 'en', N'1 week to 1 month');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (9, 'ar', N'1 أسبوع إلى 1 شهر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (10, 'en', N'3 months to 3 years');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (10, 'ar', N'من 3 أشهر إلى 3 سنوات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (11, 'en', N'6 months to 1 year');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (11, 'ar', N'6 أشهر إلى 1 سنة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (12, 'en', N'No imprisonment, only a fine');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (12, 'ar', N'لا السجن، فقط الغرامة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (13, 'en', N'Category 3');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (13, 'ar', N'الفئة 3');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (14, 'en', N'Category 4');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (14, 'ar', N'الفئة 4');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (15, 'en', N'Category 5');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (15, 'ar', N'الفئة 5');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (16, 'en', N'Category 7');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (16, 'ar', N'الفئة 7');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (17, 'en', N'A warning letter');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (17, 'ar', N'خطاب تحذير');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (18, 'en', N'120 days license suspension');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (18, 'ar', N'تعليق الترخيص لمدة 120 يومًا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (19, 'en', N'Permanent license revocation');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (19, 'ar', N'إلغاء الترخيص نهائيا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (20, 'en', N'A fine of 500 JD only');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (20, 'ar', N'غرامة 500 دينار فقط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (21, 'en', N'6 months');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (21, 'ar', N'6 أشهر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (22, 'en', N'1 year');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (22, 'ar', N'1 سنة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (23, 'en', N'2 years');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (23, 'ar', N'سنتان');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (24, 'en', N'No waiting period required');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (24, 'ar', N'لا توجد فترة انتظار مطلوبة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (25, 'en', N'Always take priority aggressively to assert your rights');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (25, 'ar', N'خذ الأولوية دائمًا بقوة لتأكيد حقوقك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (26, 'en', N'Never assume other drivers will yield to you even when you have legal priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (26, 'ar', N'لا تفترض أبدًا أن السائقين الآخرين سوف يستسلمون لك حتى عندما تكون لديك الأولوية القانونية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (27, 'en', N'Only yield to emergency vehicles, never to other cars');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (27, 'ar', N'استسلم فقط لمركبات الطوارئ، وليس للسيارات الأخرى أبدًا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (28, 'en', N'Priority is determined by who arrives first at an intersection');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (28, 'ar', N'يتم تحديد الأولوية على أساس من يصل أولاً عند التقاطع');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (29, 'en', N'The next day');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (29, 'ar', N'في اليوم التالي');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (30, 'en', N'After one week');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (30, 'ar', N'بعد أسبوع واحد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (31, 'en', N'After one month');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (31, 'ar', N'بعد شهر واحد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (32, 'en', N'After completing additional training only');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (32, 'ar', N'بعد الانتهاء من التدريب الإضافي فقط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (33, 'en', N'Three recent color photos (6×4 cm)');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (33, 'ar', N'ثلاث صور ملونة حديثة مقاس 6×4 سم.');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (34, 'en', N'Vehicle registration certificate');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (34, 'ar', N'شهادة تسجيل المركبة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (35, 'en', N'Civil ID card or passport');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (35, 'ar', N'بطاقة الهوية المدنية أو جواز السفر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (36, 'en', N'Training completion certificate');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (36, 'ar', N'شهادة إتمام التدريب');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (37, 'en', N'You receive a warning but continue the test');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (37, 'ar', N'تتلقى تحذيرًا ولكنك تستمر في الاختبار');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (38, 'en', N'The test stops and you automatically fail');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (38, 'ar', N'يتوقف الاختبار وتفشل تلقائيا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (39, 'en', N'You must retake only the failed portion');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (39, 'ar', N'يجب عليك استعادة الجزء الفاشل فقط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (40, 'en', N'The examiner gives you a second chance immediately');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (40, 'ar', N'يمنحك الفاحص فرصة ثانية على الفور');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (41, 'en', N'You may cross to overtake with caution');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (41, 'ar', N'يمكنك العبور للتجاوز بحذر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (42, 'en', N'You cannot cross the line for overtaking or lane change');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (42, 'ar', N'لا يمكنك تجاوز الخط للتجاوز أو تغيير المسار');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (43, 'en', N'You may cross only for emergency vehicles');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (43, 'ar', N'لا يجوز لك العبور إلا لمركبات الطوارئ');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (44, 'en', N'The line indicates a parking zone');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (44, 'ar', N'يشير الخط إلى منطقة وقوف السيارات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (45, 'en', N'Slow down and proceed if no traffic is visible');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (45, 'ar', N'أبطئ السرعة وتابع إذا لم تكن هناك حركة مرور مرئية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (46, 'en', N'Come to a complete stop before the line');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (46, 'ar', N'توقف تمامًا قبل السطر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (47, 'en', N'Stop only if there is a stop sign present');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (47, 'ar', N'توقف فقط في حالة وجود إشارة توقف');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (48, 'en', N'Roll through slowly while checking for traffic');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (48, 'ar', N'قم بالمرور ببطء أثناء التحقق من حركة المرور');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (49, 'en', N'Overtaking is prohibited under all circumstances');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (49, 'ar', N'التجاوز ممنوع في جميع الأحوال');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (50, 'en', N'Overtaking is allowed with extreme caution');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (50, 'ar', N'يُسمح بالتجاوز بحذر شديد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (51, 'en', N'Overtaking is only allowed for motorcycles');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (51, 'ar', N'التجاوز مسموح فقط للدراجات النارية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (52, 'en', N'You must maintain a 1-meter distance from the line');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (52, 'ar', N'يجب عليك الحفاظ على مسافة متر واحد من الخط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (53, 'en', N'A parking area during emergencies');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (53, 'ar', N'منطقة لوقوف السيارات أثناء حالات الطوارئ');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (54, 'en', N'An area you must not enter under normal circumstances');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (54, 'ar', N'منطقة لا يجب عليك الدخول إليها في الظروف العادية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (55, 'en', N'A lane reserved for turning vehicles only');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (55, 'ar', N'حارة مخصصة لتحويل المركبات فقط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (56, 'en', N'A recommended route for slow vehicles');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (56, 'ar', N'طريق موصى به للمركبات البطيئة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (57, 'en', N'50 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (57, 'ar', N'50 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (58, 'en', N'40 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (58, 'ar', N'40 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (59, 'en', N'30 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (59, 'ar', N'30 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (60, 'en', N'20 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (60, 'ar', N'20 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (61, 'en', N'Turn left or right as long as you signal');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (61, 'ar', N'انعطف يسارًا أو يمينًا طالما قمت بالإشارة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (62, 'en', N'Only go straight, no turning');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (62, 'ar', N'فقط اذهب مباشرة، لا تحول');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (63, 'en', N'Make a U-turn if safe');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (63, 'ar', N'قم بالدوران على شكل حرف U إذا كان ذلك آمنًا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (64, 'en', N'Change lanes before the intersection');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (64, 'ar', N'تغيير المسارات قبل التقاطع');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (65, 'en', N'Separate traffic going in the same direction');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (65, 'ar', N'حركة مرور منفصلة تسير في نفس الاتجاه');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (66, 'en', N'Road edges or separate opposing traffic');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (66, 'ar', N'حواف الطريق أو حركة المرور المتعارضة المنفصلة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (67, 'en', N'Bicycle lanes only');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (67, 'ar', N'ممرات الدراجات فقط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (68, 'en', N'Construction zones');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (68, 'ar', N'مناطق البناء');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (69, 'en', N'Stop completely regardless of traffic');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (69, 'ar', N'توقف تمامًا بغض النظر عن حركة المرور');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (70, 'en', N'Yield to traffic on the intersecting road, stopping only if necessary');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (70, 'ar', N'امنح الأولوية لحركة المرور على الطريق المتقاطع، ولا تتوقف إلا عند الضرورة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (71, 'en', N'Proceed without stopping because you have priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (71, 'ar', N'واصل دون توقف لأن الأولوية لك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (72, 'en', N'Honk to alert other drivers before proceeding');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (72, 'ar', N'قم بالتزمير لتنبيه السائقين الآخرين قبل المتابعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (73, 'en', N'A parking space for bicycles');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (73, 'ar', N'مكان لوقوف الدراجات الهوائية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (74, 'en', N'A lane reserved for cyclists; do not drive or park there');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (74, 'ar', N'ممر مخصص لراكبي الدراجات. لا تقود السيارة أو تقف هناك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (75, 'en', N'A lane where bicycles must yield to cars');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (75, 'ar', N'ممر يجب أن تستسلم فيه الدراجات للسيارات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (76, 'en', N'A shared lane for cars and bicycles');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (76, 'ar', N'ممر مشترك للسيارات والدراجات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (77, 'en', N'You may cross to overtake, and oncoming traffic may also cross');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (77, 'ar', N'يمكنك العبور للتجاوز، كما يجوز لحركة المرور القادمة أن تعبر أيضًا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (78, 'en', N'You may cross to overtake with caution; oncoming traffic must not cross');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (78, 'ar', N'يجوز لك العبور للتجاوز بحذر؛ يجب ألا تعبر حركة المرور القادمة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (79, 'en', N'Neither direction may cross the line');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (79, 'ar', N'لا يجوز لأي من الاتجاهين عبور الخط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (80, 'en', N'Only emergency vehicles may cross');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (80, 'ar', N'يُسمح فقط لمركبات الطوارئ بالعبور');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (81, 'en', N'Stop completely before the intersection');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (81, 'ar', N'توقف تماماً قبل التقاطع');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (82, 'en', N'Yield to traffic on the intersecting road');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (82, 'ar', N'استسلم لحركة المرور على الطريق المتقاطع');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (83, 'en', N'Speed up to merge quickly');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (83, 'ar', N'تسريع الاندماج بسرعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (84, 'en', N'Honk to alert other drivers');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (84, 'ar', N'قم بالتزمير لتنبيه السائقين الآخرين');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (85, 'en', N'Red triangle with white border');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (85, 'ar', N'مثلث أحمر مع حدود بيضاء');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (86, 'en', N'Red circle with white background and black symbol');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (86, 'ar', N'دائرة حمراء بخلفية بيضاء ورمز أسود');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (87, 'en', N'Blue rectangle with white symbol');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (87, 'ar', N'مستطيل أزرق مع رمز أبيض');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (88, 'en', N'Yellow diamond with black symbol');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (88, 'ar', N'الماس الأصفر مع الرمز الأسود');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (89, 'en', N'You have priority over oncoming traffic');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (89, 'ar', N'لديك الأولوية على حركة المرور القادمة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (90, 'en', N'Oncoming traffic has priority over you');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (90, 'ar', N'حركة المرور القادمة لها الأولوية عليك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (91, 'en', N'The road is closed ahead');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (91, 'ar', N'الطريق مغلق أمامك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (92, 'en', N'You must stop at all intersections');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (92, 'ar', N'يجب عليك التوقف عند جميع التقاطعات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (93, 'en', N'You are on a secondary road and must yield');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (93, 'ar', N'أنت على طريق ثانوي ويجب أن تستسلم');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (94, 'en', N'You are on the main road and have priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (94, 'ar', N'أنت على الطريق الرئيسي ولديك الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (95, 'en', N'A school zone is ahead');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (95, 'ar', N'منطقة المدرسة أمامك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (96, 'en', N'The road narrows ahead');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (96, 'ar', N'الطريق يضيق أمامنا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (97, 'en', N'Maximum speed limit is 50 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (97, 'ar', N'الحد الأقصى للسرعة هو 50 كم / ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (98, 'en', N'Minimum speed limit is 50 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (98, 'ar', N'الحد الأدنى للسرعة هو 50 كم / ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (99, 'en', N'No parking within 50 meters');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (99, 'ar', N'لا يوجد موقف سيارات على مسافة 50 مترًا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (100, 'en', N'50 meters to the next exit');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (100, 'ar', N'50 مترا إلى المخرج التالي');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (101, 'en', N'Motorcycles must park here');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (101, 'ar', N'يجب أن تتوقف الدراجات النارية هنا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (102, 'en', N'No motor vehicles allowed');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (102, 'ar', N'لا يسمح بالمركبات الآلية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (103, 'en', N'Motorcycles only beyond this point');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (103, 'ar', N'الدراجات النارية فقط بعد هذه النقطة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (104, 'en', N'Low emission zone ahead');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (104, 'ar', N'منطقة منخفضة الانبعاثات في الأمام');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (105, 'en', N'Warning triangle; reduce to 30 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (105, 'ar', N'مثلث التحذير؛ خفض إلى 30 كم / ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (106, 'en', N'Tunnel sign; reduce to 50 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (106, 'ar', N'علامة النفق خفض إلى 50 كم / ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (107, 'en', N'No entry; find alternate route');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (107, 'ar', N'ممنوع الدخول؛ العثور على طريق بديل');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (108, 'en', N'Two-way traffic; reduce to 40 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (108, 'ar', N'حركة المرور في اتجاهين. خفض إلى 40 كم / ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (109, 'en', N'Children playing ahead');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (109, 'ar', N'أطفال يلعبون في الأمام');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (110, 'en', N'Pedestrian crossing ahead - reduce speed to 30 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (110, 'ar', N'معبر المشاة أمامك - خفف السرعة إلى 30 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (111, 'en', N'School zone - stop for buses');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (111, 'ar', N'منطقة المدرسة - توقف للحافلات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (112, 'en', N'Bicycle crossing ahead');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (112, 'ar', N'معبر الدراجة أمامك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (113, 'en', N'Oncoming traffic has priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (113, 'ar', N'حركة المرور القادمة لها الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (114, 'en', N'You have priority over oncoming traffic');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (114, 'ar', N'لديك الأولوية على حركة المرور القادمة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (115, 'en', N'The road is one-way');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (115, 'ar', N'الطريق ذو اتجاه واحد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (116, 'en', N'No passing allowed');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (116, 'ar', N'لا يسمح بالمرور');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (117, 'en', N'Maximum speed 80 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (117, 'ar', N'السرعة القصوى 80 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (118, 'en', N'Minimum speed 80 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (118, 'ar', N'السرعة الدنيا 80 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (119, 'en', N'80 meters to hazard');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (119, 'ar', N'80 مترا للخطر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (120, 'en', N'Road number 80 ahead');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (120, 'ar', N'الطريق رقم 80 أمامك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (121, 'en', N'The vehicle on the left goes first');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (121, 'ar', N'السيارة التي على اليسار تسير أولاً');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (122, 'en', N'The vehicle on the right goes first');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (122, 'ar', N'السيارة التي على اليمين تسير أولاً');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (123, 'en', N'The first vehicle to arrive goes first');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (123, 'ar', N'أول مركبة تصل تذهب أولا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (124, 'en', N'Both vehicles can proceed simultaneously');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (124, 'ar', N'يمكن لكلتا المركبتين المضي قدمًا في وقت واحد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (125, 'en', N'The entering vehicle has priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (125, 'ar', N'السيارة الداخلة لها الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (126, 'en', N'Vehicles inside the roundabout have priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (126, 'ar', N'المركبات داخل الدوار لها الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (127, 'en', N'Whoever signals first has priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (127, 'ar', N'من يشير أولا له الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (128, 'en', N'Larger vehicles have priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (128, 'ar', N'المركبات الأكبر حجما لها الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (129, 'en', N'The road that ends (the stem) has priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (129, 'ar', N'الطريق الذي ينتهي (الجذع) له الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (130, 'en', N'The road that continues straight (the through road) has priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (130, 'ar', N'الطريق الذي يستمر بشكل مستقيم (الطريق العابر) له الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (131, 'en', N'Traffic from the left has priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (131, 'ar', N'حركة المرور من اليسار لها الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (132, 'en', N'T-junctions have no priority rules');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (132, 'ar', N'ليس لدى تقاطعات T قواعد الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (133, 'en', N'The left-turning vehicle goes first');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (133, 'ar', N'السيارة التي تستدير لليسار تسير أولاً');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (134, 'en', N'The vehicle going straight has priority');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (134, 'ar', N'السيارة التي تسير بشكل مستقيم لها الأولوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (135, 'en', N'Both vehicles can turn simultaneously');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (135, 'ar', N'يمكن لكلتا المركبتين الدوران في وقت واحد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (136, 'en', N'The vehicle that arrived first goes first');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (136, 'ar', N'السيارة التي وصلت أولاً تذهب أولاً');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (137, 'en', N'Maintain speed and let the ambulance overtake on the left');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (137, 'ar', N'حافظ على السرعة واترك سيارة الإسعاف تتخطى الجهة اليسرى');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (138, 'en', N'Pull to the right and stop if necessary to let it pass');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (138, 'ar', N'اسحب إلى اليمين وتوقف إذا لزم الأمر للسماح لها بالمرور');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (139, 'en', N'Speed up to get out of its way');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (139, 'ar', N'تسريع للخروج من طريقه');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (140, 'en', N'Ignore it if you are not blocking its path');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (140, 'ar', N'تجاهله إذا كنت لا تمنع طريقه');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (141, 'en', N'Enter quickly before other vehicles reach you');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (141, 'ar', N'أدخل بسرعة قبل أن تصل إليك المركبات الأخرى');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (142, 'en', N'Stop, check for traffic, and yield to all vehicles on the road');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (142, 'ar', N'توقف، وتحقق من حركة المرور، واستسلم لجميع المركبات على الطريق');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (143, 'en', N'Honk and proceed slowly');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (143, 'ar', N'قم بالتزمير واستمر ببطء');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (144, 'en', N'You have priority because you are leaving private property');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (144, 'ar', N'لديك الأولوية لأنك تترك الملكية الخاصة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (145, 'en', N'The right lane only');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (145, 'ar', N'المسار الأيمن فقط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (146, 'en', N'The left lane only');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (146, 'ar', N'المسار الأيسر فقط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (147, 'en', N'Either lane is acceptable');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (147, 'ar', N'أي حارة مقبولة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (148, 'en', N'The lane that is least congested');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (148, 'ar', N'المسار الأقل ازدحاما');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (149, 'en', N'You may proceed without checking because your light is green');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (149, 'ar', N'يمكنك المتابعة دون التحقق لأن ضوءك أخضر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (150, 'en', N'You should still check for red-light runners before entering');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (150, 'ar', N'لا يزال يتعين عليك التحقق من وجود متسابقين في الضوء الأحمر قبل الدخول');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (151, 'en', N'You must stop at every green light');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (151, 'ar', N'يجب أن تتوقف عند كل ضوء أخضر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (152, 'en', N'You may speed up to clear the intersection quickly');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (152, 'ar', N'يمكنك الإسراع لإخلاء التقاطع بسرعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (153, 'en', N'Slow down and proceed if no train is visible');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (153, 'ar', N'أبطئ السرعة وتابع إذا لم يكن هناك قطار مرئي');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (154, 'en', N'Stop completely and wait for gates to rise');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (154, 'ar', N'توقف تمامًا وانتظر حتى ترتفع البوابات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (155, 'en', N'Go around the gates if they are taking too long');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (155, 'ar', N'قم بالالتفاف حول البوابات إذا كانت تستغرق وقتًا طويلاً');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (156, 'en', N'Honk to warn the train');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (156, 'ar', N'تزمير لتحذير القطار');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (157, 'en', N'The vehicle on the main road is at fault for not avoiding the crash');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (157, 'ar', N'السيارة على الطريق الرئيسي مخطئة لعدم تجنب الحادث');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (158, 'en', N'The vehicle entering from the side road is at fault');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (158, 'ar', N'المركبة التي تدخل من الطريق الجانبي هي المخطئة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (159, 'en', N'Both drivers share equal fault');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (159, 'ar', N'كلا السائقين يتشاركان في الخطأ نفسه');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (160, 'en', N'No one is at fault because it was an accident');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (160, 'ar', N'لا أحد مخطئ لأنه كان حادثا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (161, 'en', N'The left lane');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (161, 'ar', N'الممر الأيسر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (162, 'en', N'The rightmost lane');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (162, 'ar', N'الممر في أقصى اليمين');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (163, 'en', N'The center lane only');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (163, 'ar', N'الممر الأوسط فقط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (164, 'en', N'Any lane, as long as you signal');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (164, 'ar', N'أي حارة، طالما قمت بالإشارة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (165, 'en', N'The left side of the lane near the center line');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (165, 'ar', N'الجانب الأيسر من الممر بالقرب من خط الوسط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (166, 'en', N'The right side of your lane');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (166, 'ar', N'الجانب الأيمن من حارتك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (167, 'en', N'The leftmost lane of the road');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (167, 'ar', N'أقصى يسار الطريق');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (168, 'en', N'Any position, as long as you signal left');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (168, 'ar', N'في أي موقف، طالما قمت بالإشارة إلى اليسار');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (169, 'en', N'Left turn');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (169, 'ar', N'انعطف يسارًا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (170, 'en', N'U-turn');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (170, 'ar', N'منعطف على شكل حرف U');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (171, 'en', N'Right turn');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (171, 'ar', N'المنعطف الأيمن');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (172, 'en', N'Overtaking');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (172, 'ar', N'التجاوز');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (173, 'en', N'Immediately after passing the vehicle''s front bumper');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (173, 'ar', N'مباشرة بعد تجاوز المصد الأمامي للمركبة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (174, 'en', N'When you can see the overtaken vehicle in your interior mirror');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (174, 'ar', N'عندما تتمكن من رؤية السيارة المتجاوزة في المرآة الداخلية الخاصة بك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (175, 'en', N'After you have driven at least 500 meters ahead');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (175, 'ar', N'بعد أن تقود سيارتك لمسافة لا تقل عن 500 متر للأمام');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (176, 'en', N'When the other driver flashes their headlights');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (176, 'ar', N'عندما يومض السائق الآخر المصابيح الأمامية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (177, 'en', N'Overtake quickly because the slow vehicle is dangerous');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (177, 'ar', N'التجاوز بسرعة لأن السيارة البطيئة تشكل خطورة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (178, 'en', N'Wait until after the curve where visibility improves before overtaking');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (178, 'ar', N'انتظر حتى بعد المنحنى حيث تتحسن الرؤية قبل التجاوز');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (179, 'en', N'Honk to make the slow vehicle pull over');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (179, 'ar', N'قم بالتزمير لجعل السيارة البطيئة تتوقف');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (180, 'en', N'Cross the solid line to overtake if safe');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (180, 'ar', N'اعبر الخط الصلب للتجاوز إذا كان ذلك آمنًا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (181, 'en', N'10 and 2 o''clock');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (181, 'ar', N'الساعة 10 و 2 ظهرا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (182, 'en', N'9 and 3 o''clock');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (182, 'ar', N'الساعة 9 و 3');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (183, 'en', N'8 and 4 o''clock');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (183, 'ar', N'الساعة 8 و 4 صباحا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (184, 'en', N'One hand at 12 o''clock');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (184, 'ar', N'يد واحدة عند الساعة 12');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (185, 'en', N'Signal, check mirrors, check blind spot, change lanes');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (185, 'ar', N'الإشارة، فحص المرايا، التحقق من النقطة العمياء، تغيير المسارات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (186, 'en', N'Change lanes, then signal');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (186, 'ar', N'قم بتغيير المسار، ثم قم بالإشارة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (187, 'en', N'Check blind spot, signal, change lanes, check mirrors');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (187, 'ar', N'فحص النقطة العمياء، الإشارة، تغيير المسارات، فحص المرايا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (188, 'en', N'Signal, change lanes immediately, check mirrors later');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (188, 'ar', N'إشارة، غيّر المسار فوراً، وتفحص المرايا لاحقاً');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (189, 'en', N'Speed up to prevent the truck from passing');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (189, 'ar', N'تسريع لمنع الشاحنة من المرور');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (190, 'en', N'Keep as far right as possible and do not increase speed');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (190, 'ar', N'حافظ على أقصى اليمين قدر الإمكان ولا تزيد السرعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (191, 'en', N'Move left to block the truck''s path');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (191, 'ar', N'تحرك يسارًا لعرقلة مسار الشاحنة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (192, 'en', N'Honk continuously to warn the truck driver');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (192, 'ar', N'قم بالتزمير بشكل مستمر لتحذير سائق الشاحنة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (193, 'en', N'On straight roads with good visibility');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (193, 'ar', N'على الطرق المستقيمة مع رؤية جيدة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (194, 'en', N'On curves or near hill crests');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (194, 'ar', N'على المنحنيات أو بالقرب من قمم التلال');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (195, 'en', N'In residential areas');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (195, 'ar', N'في المناطق السكنية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (196, 'en', N'On multi-lane divided highways');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (196, 'ar', N'على الطرق السريعة المقسمة متعددة الحارات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (197, 'en', N'The left lane');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (197, 'ar', N'الممر الأيسر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (198, 'en', N'The right lane');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (198, 'ar', N'الممر الأيمن');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (199, 'en', N'Either lane');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (199, 'ar', N'أي حارة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (200, 'en', N'The center lane');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (200, 'ar', N'الممر الأوسط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (201, 'en', N'90 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (201, 'ar', N'90 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (202, 'en', N'100 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (202, 'ar', N'100 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (203, 'en', N'110 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (203, 'ar', N'110 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (204, 'en', N'120 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (204, 'ar', N'120 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (205, 'en', N'2 seconds');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (205, 'ar', N'2 ثانية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (206, 'en', N'3 seconds');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (206, 'ar', N'3 ثواني');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (207, 'en', N'4 seconds');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (207, 'ar', N'4 ثواني');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (208, 'en', N'1 second');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (208, 'ar', N'1 ثانية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (209, 'en', N'At least 100 meters before the vehicle');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (209, 'ar', N'على الأقل 100 متر قبل السيارة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (210, 'en', N'At least 50 meters after the vehicle');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (210, 'ar', N'على الأقل 50 مترا بعد السيارة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (211, 'en', N'Directly behind the vehicle');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (211, 'ar', N'خلف المركبة مباشرة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (212, 'en', N'On top of the vehicle');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (212, 'ar', N'على رأس السيارة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (213, 'en', N'A safe following distance');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (213, 'ar', N'مسافة متابعة آمنة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (214, 'en', N'The correct parking distance from the curb');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (214, 'ar', N'مسافة ركن السيارة الصحيحة من الرصيف');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (215, 'en', N'The time it takes to stop from 60 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (215, 'ar', N'الزمن المستغرق للتوقف من سرعة 60 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (216, 'en', N'The minimum time between gear shifts');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (216, 'ar', N'الحد الأدنى من الوقت بين تحولات العتاد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (217, 'en', N'Fine 20 JD');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (217, 'ar', N'غرامة 20 دينار');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (218, 'en', N'Fine 30 JD');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (218, 'ar', N'غرامة 30 دينار');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (219, 'en', N'Fine 50 JD plus jail');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (219, 'ar', N'غرامة 50 دينار بالإضافة إلى السجن');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (220, 'en', N'Only a warning');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (220, 'ar', N'تحذير فقط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (221, 'en', N'Approximately 8 meters');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (221, 'ar', N'حوالي 8 أمتار');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (222, 'en', N'Approximately 14 meters');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (222, 'ar', N'حوالي 14 مترا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (223, 'en', N'Approximately 25 meters');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (223, 'ar', N'حوالي 25 مترا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (224, 'en', N'Approximately 31 meters');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (224, 'ar', N'حوالي 31 مترا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (225, 'en', N'On the shoulder of a rural road');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (225, 'ar', N'على كتف الطريق الريفي');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (226, 'en', N'Within 15 meters of an intersection');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (226, 'ar', N'على مسافة 15 مترًا من التقاطع');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (227, 'en', N'In designated parking bays');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (227, 'ar', N'في مواقف السيارات المخصصة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (228, 'en', N'On wide residential streets');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (228, 'ar', N'على شوارع سكنية واسعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (229, 'en', N'30 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (229, 'ar', N'30 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (230, 'en', N'40 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (230, 'ar', N'40 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (231, 'en', N'50 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (231, 'ar', N'50 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (232, 'en', N'60 km/h');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (232, 'ar', N'60 كم/ساعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (233, 'en', N'Just enough to see their rear tires touching the ground');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (233, 'ar', N'يكفي فقط رؤية إطاراتهم الخلفية تلامس الأرض');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (234, 'en', N'At least 10 meters');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (234, 'ar', N'ما لا يقل عن 10 مترا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (235, 'en', N'As close as possible to avoid blocking intersections');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (235, 'ar', N'أقرب ما يمكن لتجنب عرقلة التقاطعات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (236, 'en', N'Exactly one car length');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (236, 'ar', N'طول سيارة واحدة بالضبط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (237, 'en', N'Turn off all lights to save battery');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (237, 'ar', N'أطفئ جميع الأضواء لتوفير البطارية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (238, 'en', N'Keep parking lights on in addition to hazard lights');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (238, 'ar', N'إبقاء أضواء وقوف السيارات مضاءة بالإضافة إلى أضواء الخطر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (239, 'en', N'Flash your high beams repeatedly');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (239, 'ar', N'قم بتشغيل الأضواء العالية بشكل متكرر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (240, 'en', N'Stand in the road to wave down help');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (240, 'ar', N'الوقوف في الطريق للتلويح بالمساعدة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (241, 'en', N'No significant effect');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (241, 'ar', N'لا يوجد تأثير كبير');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (242, 'en', N'Similar to 0.05% BAC (legally impaired in many jurisdictions)');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (242, 'ar', N'على غرار 0.05% BAC (ضعيف قانونيًا في العديد من الولايات القضائية)');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (243, 'en', N'Less than one drink');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (243, 'ar', N'أقل من مشروب واحد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (244, 'en', N'Similar to 0.02% BAC (safe to drive)');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (244, 'ar', N'مشابه لـ 0.02% BAC (آمن للقيادة)');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (245, 'en', N'Yes, if you feel fine, the medication has worn off');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (245, 'ar', N'نعم، إذا شعرت أنك بخير، فقد انتهى مفعول الدواء');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (246, 'en', N'No, you should wait 12+ hours or find alternative transportation');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (246, 'ar', N'لا، يجب عليك الانتظار أكثر من 12 ساعة أو البحث عن وسيلة نقل بديلة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (247, 'en', N'Yes, but only for short trips');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (247, 'ar', N'نعم، ولكن فقط للرحلات القصيرة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (248, 'en', N'Yes, if you drink coffee first');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (248, 'ar', N'نعم، إذا شربت القهوة أولاً');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (249, 'en', N'No penalty, you have the right to refuse');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (249, 'ar', N'لا يوجد عقوبة، لديك الحق في الرفض');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (250, 'en', N'Possible arrest and additional penalties');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (250, 'ar', N'احتمال الاعتقال وعقوبات إضافية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (251, 'en', N'A small fine only');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (251, 'ar', N'غرامة صغيرة فقط');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (252, 'en', N'License suspension only, no arrest');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (252, 'ar', N'تعليق الترخيص فقط، لا يوجد اعتقال');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (253, 'en', N'Frequent yawning and heavy eyelids');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (253, 'ar', N'التثاؤب المتكرر والجفون الثقيلة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (254, 'en', N'Increased alertness and faster reactions');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (254, 'ar', N'زيادة اليقظة وسرعة ردود الفعل');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (255, 'en', N'Wanting to drive faster than usual');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (255, 'ar', N'الرغبة في القيادة بشكل أسرع من المعتاد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (256, 'en', N'Increased appetite');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (256, 'ar', N'زيادة الشهية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (257, 'en', N'Turn up the radio to stay awake');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (257, 'ar', N'قم بتشغيل الراديو للبقاء مستيقظًا');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (258, 'en', N'Open the window for fresh air');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (258, 'ar', N'افتح النافذة للهواء النقي');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (259, 'en', N'Stop at a safe rest area and take a 15-20 minute nap');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (259, 'ar', N'توقف عند منطقة استراحة آمنة وخذ قيلولة لمدة 15-20 دقيقة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (260, 'en', N'Drink coffee and continue driving');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (260, 'ar', N'اشرب القهوة وواصل القيادة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (261, 'en', N'Emotions do not affect driving ability');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (261, 'ar', N'العواطف لا تؤثر على القدرة على القيادة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (262, 'en', N'Anger leads to aggressive driving and poor decision-making');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (262, 'ar', N'الغضب يؤدي إلى القيادة العدوانية وسوء اتخاذ القرار');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (263, 'en', N'Sadness improves concentration');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (263, 'ar', N'الحزن يحسن التركيز');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (264, 'en', N'Only happiness affects driving');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (264, 'ar', N'السعادة فقط تؤثر على القيادة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (265, 'en', N'Antibiotics');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (265, 'ar', N'المضادات الحيوية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (266, 'en', N'Antihistamines (allergy medications)');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (266, 'ar', N'مضادات الهيستامين (أدوية الحساسية)');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (267, 'en', N'Vitamins');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (267, 'ar', N'الفيتامينات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (268, 'en', N'Pain relievers like ibuprofen');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (268, 'ar', N'مسكنات الألم مثل الإيبوبروفين');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (269, 'en', N'Drinking coffee');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (269, 'ar', N'شرب القهوة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (270, 'en', N'Taking a cold shower');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (270, 'ar', N'أخذ حمام بارد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (271, 'en', N'Time');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (271, 'ar', N'وقت');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (272, 'en', N'Eating a heavy meal');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (272, 'ar', N'تناول وجبة ثقيلة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (273, 'en', N'Flash your high beams back to warn them');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (273, 'ar', N'قم بإضاءة الأضواء العالية مرة أخرى لتحذيرهم');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (274, 'en', N'Slow down, look to the right edge of the road, and keep right');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (274, 'ar', N'أبطئ السرعة، وانظر إلى الحافة اليمنى من الطريق، واستمر في السير على اليمين');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (275, 'en', N'Speed up to pass them quickly');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (275, 'ar', N'تسريع لتمريرها بسرعة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (276, 'en', N'Turn off your lights entirely');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (276, 'ar', N'أطفئ الأضواء بالكامل');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (277, 'en', N'Talking to a passenger briefly');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (277, 'ar', N'التحدث مع أحد الركاب لفترة وجيزة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (278, 'en', N'Using a mobile phone without hands-free');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (278, 'ar', N'استخدام الهاتف المحمول بدون استخدام اليدين');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (279, 'en', N'Changing the radio station at a red light');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (279, 'ar', N'تغيير محطة الراديو عند الضوء الأحمر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (280, 'en', N'Checking your mirrors every 5-8 seconds');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (280, 'ar', N'فحص المرايا الخاصة بك كل 5-8 ثواني');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (281, 'en', N'High beams reflect off fog droplets and reduce visibility further');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (281, 'ar', N'تعكس الأضواء العالية قطرات الضباب وتقلل من الرؤية بشكل أكبر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (282, 'en', N'High beams drain the battery faster');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (282, 'ar', N'تستنزف الأضواء العالية البطارية بشكل أسرع');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (283, 'en', N'Low beams use less electricity');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (283, 'ar', N'تستهلك الحزم المنخفضة كهرباء أقل');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (284, 'en', N'High beams are illegal in fog');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (284, 'ar', N'الحزم العالية غير قانونية في الضباب');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (285, 'en', N'A tire blowout');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (285, 'ar', N'انفجار أحد الإطارات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (286, 'en', N'Hydroplaning (loss of traction on water)');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (286, 'ar', N'الانزلاق المائي (فقدان الجر على الماء)');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (287, 'en', N'Engine failure');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (287, 'ar', N'فشل المحرك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (288, 'en', N'Brake failure');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (288, 'ar', N'فشل الفرامل');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (289, 'en', N'Brake hard and steer left');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (289, 'ar', N'الفرامل بقوة وتوجيه اليسار');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (290, 'en', N'Steer right (in the direction of the skid) and lift off the accelerator');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (290, 'ar', N'قم بالتوجيه إلى اليمين (في اتجاه الانزلاق) وارفع دواسة البنزين');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (291, 'en', N'Accelerate to regain traction');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (291, 'ar', N'تسريع لاستعادة الجر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (292, 'en', N'Turn off the engine immediately');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (292, 'ar', N'أطفئ المحرك على الفور');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (293, 'en', N'Ice that is painted black for visibility');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (293, 'ar', N'الجليد المطلي باللون الأسود للرؤية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (294, 'en', N'Thin, transparent ice that looks like wet pavement');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (294, 'ar', N'جليد رقيق وشفاف يشبه الرصيف الرطب');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (295, 'en', N'Ice that only forms on black asphalt');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (295, 'ar', N'الجليد الذي يتشكل فقط على الأسفلت الأسود');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (296, 'en', N'Ice mixed with black sand');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (296, 'ar', N'الثلج الممزوج بالرمال السوداء');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (297, 'en', N'Continue at normal speed with high beams on');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (297, 'ar', N'استمر بالسرعة العادية مع تشغيل الأضواء العالية');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (298, 'en', N'Pull off the road completely in a safe location and wait for conditions to improve');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (298, 'ar', N'انسحب من الطريق تمامًا في مكان آمن وانتظر حتى تتحسن الظروف');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (299, 'en', N'Drive in the center of the road to avoid sand drifts');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (299, 'ar', N'قم بالقيادة في وسط الطريق لتجنب انجراف الرمال');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (300, 'en', N'Stop in the travel lane with hazard lights on');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (300, 'ar', N'توقف في حارة السفر مع إضاءة أضواء الخطر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (301, 'en', N'10-20%');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (301, 'ar', N'10-20%');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (302, 'en', N'30-40%');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (302, 'ar', N'30-40%');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (303, 'en', N'50-70%');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (303, 'ar', N'50-70%');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (304, 'en', N'80-90%');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (304, 'ar', N'80-90%');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (305, 'en', N'Leave the scene to avoid complications');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (305, 'ar', N'اترك المكان لتجنب المضاعفات');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (306, 'en', N'Stop, call police, exchange information with other driver');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (306, 'ar', N'توقف واتصل بالشرطة وتبادل المعلومات مع السائق الآخر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (307, 'en', N'Only stop if the other driver stops');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (307, 'ar', N'توقف فقط إذا توقف السائق الآخر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (308, 'en', N'Report within one week');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (308, 'ar', N'التقرير خلال أسبوع واحد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (309, 'en', N'Drive faster to dry the brakes');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (309, 'ar', N'قم بالقيادة بشكل أسرع لتجفيف الفرامل');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (310, 'en', N'Gently apply brakes while driving slowly to dry them');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (310, 'ar', N'استخدم الفرامل بلطف أثناء القيادة ببطء لتجفيفها');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (311, 'en', N'Ignore it, the brakes will recover on their own');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (311, 'ar', N'تجاهل ذلك، سوف تتعافى الفرامل من تلقاء نفسها');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (312, 'en', N'Stop and check brake fluid level');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (312, 'ar', N'توقف وتحقق من مستوى سائل الفرامل');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (313, 'en', N'Brake firmly and steer away from the ice');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (313, 'ar', N'الفرامل بقوة والابتعاد عن الجليد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (314, 'en', N'Do not brake, keep steering straight, gently lift accelerator');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (314, 'ar', N'لا تستخدم المكابح، وحافظ على توجيهك مستقيماً، وارفع دواسة الوقود برفق');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (315, 'en', N'Accelerate to gain traction');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (315, 'ar', N'تسريع للحصول على الجر');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (316, 'en', N'Turn sharply to get off the ice');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (316, 'ar', N'اتجه بشكل حاد للنزول من الجليد');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (317, 'en', N'Continue driving, someone else will help');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (317, 'ar', N'استمر في القيادة، شخص آخر سوف يساعدك');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (318, 'en', N'You must stop and help until emergency services arrive');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (318, 'ar', N'يجب عليك التوقف والمساعدة حتى وصول خدمات الطوارئ');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (319, 'en', N'Call police from your car and keep driving');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (319, 'ar', N'اتصل بالشرطة من سيارتك واستمر في القيادة');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (320, 'en', N'Only stop if you know the injured person');
INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) VALUES (320, 'ar', N'توقف فقط إذا كنت تعرف الشخص المصاب');

GO


-- ============================================
-- FILE: 14_Seeds\05_GovCitizens.sql
-- ============================================

INSERT INTO Gov.GovCitizens (
    national_id,
    first_name,
    last_name,
    date_of_birth,
    gender,
    province_id,
    city_id,
    address_line1,
    address_line2,
    postal_code,
    is_eligible
)
VALUES
-- =========================
-- Provided Records
-- =========================

(
    N'2000649758',
    N'معاذ',
    N'فريحات',
    '2003-04-03',
    N'male',
    2, -- Zarqa
    4, -- Russeifa
    N'شارع الجامعة العربية - بناية رقم 54',
    NULL,
    N'13710',
    1
),

(
    N'2000939089',
    N'عبدالرحمن',
    N'عبيد',
    '2004-10-18',
    N'male',
    1, -- Amman
    1, -- Marj Al-Hammam
    N'شارع عاصم بن نايف',
    NULL,
    N'11732',
    1
),

-- =========================
-- Generated Additional Records
-- =========================

(
    N'2001123456',
    N'أحمد',
    N'الخالدي',
    '2002-06-15',
    N'male',
    1,
    2, -- Tlaa Al-Ali
    N'شارع الملك عبدالله الثاني',
    NULL,
    N'11953',
    1
),

(
    N'2001456781',
    N'يوسف',
    N'أبو زيد',
    '2001-09-22',
    N'male',
    3,
    6, -- Ramtha
    N'شارع الجامعة',
    NULL,
    N'21110',
    1
),

(
    N'2001789452',
    N'خالد',
    N'جابر',
    '2005-02-10',
    N'male',
    4,
    7, -- Aqaba City
    N'شارع الميناء',
    NULL,
    N'77110',
    1
),

(
    N'2001987345',
    N'عمر',
    N'السالم',
    '2003-12-01',
    N'male',
    5,
    8, -- Mafraq City
    N'شارع السوق المركزي',
    NULL,
    N'25110',
    1
),

(
    N'2001678910',
    N'حسن',
    N'النجار',
    '2004-07-19',
    N'male',
    2,
    5, -- Zarqa City
    N'الشارع الصناعي',
    NULL,
    N'13110',
    1
),

(
    N'2000493916',
    N'معتز',
    N'الفرحانة',
    '2002-06-18',
    N'male',
    1,
    3, -- Tabarbour
    N'شارع الجيش',
    N'جنوب الشهيد',
    N'11118',
    1
);

GO


-- ============================================
-- FILE: 14_Seeds\06_GovLicenseRecords.sql
-- ============================================

INSERT INTO Gov.GovLicenseRecords (
    national_id,
    license_type_id,
    issued_date,
    expiry_date,
    status
)
VALUES

-- Ahmad (Private Automatic)
(
    N'2001123456',
    1,
    '2022-06-10',
    '2027-06-10',
    N'active'
),

-- Yousef (Motorcycle)
(
    N'2001456781',
    3,
    '2021-03-15',
    '2026-03-15',
    N'expired'
),

-- Hassan (Private Manual)
(
    N'2001678910',
    2,
    '2023-01-20',
    '2028-01-20',
    N'active'
),

-- Khaled (Private Automatic)
(
    N'2001789452',
    1,
    '2020-09-05',
    '2025-09-05',
    N'expired'
),

-- Omar (Motorcycle)
(
    N'2001987345',
    3,
    '2024-02-12',
    '2029-02-12',
    N'active'
);

GO


-- ============================================
-- FILE: 14_Seeds\07_GovExamCenters.sql
-- ============================================

INSERT INTO Gov.GovExamCenters (
    name,
    province_id,
    city_id,
    address_line1,
    address_line2,
    postal_code,
    phone_number,
    is_active
)
VALUES

-- =========================
-- Amman Centers
-- =========================

(
    N'مركز فحص السواقين الرئيسي - عمان',
    1, -- Amman
    1, -- Marj Al-Hammam (approx grouping center area)
    N'شارع الجامعة - قرب مديرية السير',
    NULL,
    N'11118',
    N'06-535-1234',
    1
),

(
    N'مركز ترخيص مرج الحمام',
    1,
    1,
    N'شارع عاصم بن نايف',
    NULL,
    N'11732',
    N'06-420-8891',
    1
),

-- =========================
-- Zarqa Centers
-- =========================

(
    N'مركز فحص السواقين الزرقاء',
    2, -- Zarqa
    5, -- Zarqa City
    N'المنطقة الصناعية - شارع 15',
    NULL,
    N'13110',
    N'05-382-7710',
    1
),

(
    N'فرع ترخيص الرصيفة',
    2,
    4, -- Russeifa
    N'شارع الجامعة - مبنى رقم 12',
    NULL,
    N'13710',
    N'05-374-2201',
    1
),

-- =========================
-- Irbid Centers
-- =========================

(
    N'مركز فحص السواقين إربد',
    3,
    6, -- Ramtha area placeholder OR Irbid City depending your model
    N'شارع الجامعة - قرب جامعة اليرموك',
    NULL,
    N'21110',
    N'02-724-5510',
    1
),

-- =========================
-- Aqaba Centers
-- =========================

(
    N'مركز ترخيص وفحص العقبة',
    4,
    7,
    N'منطقة الميناء - الطريق الرئيسي',
    NULL,
    N'77110',
    N'03-201-8899',
    1
),

-- =========================
-- Mafraq Centers
-- =========================

(
    N'مركز فحص السواقين المفرق',
    5,
    8,
    N'الوسط التجاري - شارع الرئيسي',
    NULL,
    N'25110',
    N'02-623-4412',
    1
);

GO


-- ============================================
-- FILE: 14_Seeds\08_TrainingCenters.sql
-- ============================================

INSERT INTO Learning.TrainingCenters (
    display_name_en,
    display_name_ar,
    province_id,
    city_id,
    address_line1,
    address_line2,
    postal_code,
    phone_number,
    email,
    license_number,
    is_active
)
VALUES

-- =========================
-- Amman
-- =========================

(
    N'Al-Mustaqbal Driving Academy',
    N'أكاديمية المستقبل لتعليم القيادة',
    1, -- Amman
    1, -- Marj Al-Hammam (default main area)
    N'Gardens Street, Building 45',
    NULL,
    N'11118',
    N'06-552-8891',
    N'info@mustaqbal-driving.jo',
    N'TC-AMM-1001',
    1
),

(
    N'Royal Road Safety Institute',
    N'معهد الملكي للسلامة المرورية',
    1,
    2, -- Tlaa Al-Ali
    N'King Abdullah II Street',
    NULL,
    N'11953',
    N'06-533-7720',
    N'contact@royalroads.jo',
    N'TC-AMM-1002',
    1
),

-- =========================
-- Zarqa
-- =========================

(
    N'Zarqa Professional Driving School',
    N'مدرسة الزرقاء المهنية لتعليم القيادة',
    2, -- Zarqa
    5, -- Zarqa City
    N'Industrial Zone Road',
    NULL,
    N'13110',
    N'05-382-9911',
    N'info@zarqadrive.jo',
    N'TC-ZRQ-2001',
    1
),

-- =========================
-- Irbid
-- =========================

(
    N'Irbid Safe Driving Center',
    N'مركز إربد الآمن لتعليم القيادة',
    3, -- Irbid
    6, -- Ramtha / Irbid region
    N'University Street near Yarmouk University',
    NULL,
    N'21110',
    N'02-724-9900',
    N'contact@irbidsafe.jo',
    N'TC-IRB-3001',
    1
),

-- =========================
-- Aqaba
-- =========================

(
    N'Aqaba Maritime Driving Academy',
    N'أكاديمية العقبة البحرية لتعليم القيادة',
    4, -- Aqaba
    7, -- Aqaba City
    N'Port Area Road',
    NULL,
    N'77110',
    N'03-201-5566',
    N'info@aqabadrive.jo',
    N'TC-AQB-4001',
    1
);

GO


-- ============================================
-- FILE: 14_Seeds\09_Users.sql
-- ============================================

SET IDENTITY_INSERT Core.Users ON;

INSERT INTO Core.Users
(
    user_id,
    role_id,
    national_id,
    first_name,
    last_name,
    date_of_birth,
    gender,
    email,
    phone_number,
    province_id,
    city_id,
    address_line1,
    address_line2,
    postal_code,
    password_hash,
    profile_picture_path,
    language_preference,
    is_active,
    created_at,
    updated_at
)
VALUES
(
    1,
    1,
    N'2000939089',
    N'عبدالرحمن',
    N'عبيد',
    '2004-10-18',
    N'male',
    N'aboudaboudiua2@gmail.com',
    N'078152830',
    1, -- Amman
    1, -- Marj Al-Hammam
    N'شارع عاصم بن نايف',
    NULL,
    N'11732',
    N'$2a$11$cKsXAbTDzl6bx/GC0tDaHORqtNqlnAc7044jB/BK3v1cxMvbJrLTu',
    NULL,
    N'en',
    1,
    GETDATE(),
    GETDATE()
);

SET IDENTITY_INSERT Core.Users OFF;

INSERT INTO Roles.Trainees
(
    trainee_id,
    license_type_id,
    training_center_id
)
VALUES
(
    1,
    1,      -- adjust if needed
    NULL
);

INSERT INTO Core.TraineeLicenses
(
    trainee_id,
    license_type_id,
    mentor_id,
    stage,
    progress_percentage,
    is_active
)
VALUES
(
    1,              -- your trainee
    1,              -- ⚠️ adjust if needed
    NULL,           -- or set a mentor if you have one
    'theoretical_prep',
    100,             -- since you marked modules complete earlier
    1
);

DECLARE @TraineeId INT = 1;
DECLARE @TraineeLicenseId INT = 1; -- ⚠️ change this if needed

DECLARE @i INT = 1;

WHILE @i <= 8
BEGIN
    INSERT INTO [RokhsetakDB].[Learning].[TraineeModuleProgress]
    (
        trainee_id,
        module_id,
        trainee_license_id,
        status,
        started_at,
        completed_at
    )
    VALUES
    (
        @TraineeId,
        @i,
        @TraineeLicenseId,
        'completed',
        GETDATE(),
        GETDATE()
    );

    SET @i = @i + 1;
END

INSERT INTO [Learning].[QuizAttempts]
    ([quiz_id], [trainee_id], [trainee_license_id], [score], [passed], [attempt_date])
VALUES
(1, 1, 1, 100, 1, GETDATE()),
(2, 1, 1, 100, 1, GETDATE()),
(3, 1, 1, 100, 1, GETDATE()),
(4, 1, 1, 100, 1, GETDATE()),
(5, 1, 1, 100, 1, GETDATE()),
(6, 1, 1, 100, 1, GETDATE()),
(7, 1, 1, 100, 1, GETDATE()),
(8, 1, 1, 100, 1, GETDATE());

GO

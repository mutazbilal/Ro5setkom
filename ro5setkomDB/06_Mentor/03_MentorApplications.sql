USE ro5setkomDB;
GO

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
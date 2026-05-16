

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
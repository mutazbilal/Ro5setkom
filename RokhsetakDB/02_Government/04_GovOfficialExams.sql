USE ro5setkomDB;
go

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
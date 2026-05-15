USE ro5setkomDB;
GO

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
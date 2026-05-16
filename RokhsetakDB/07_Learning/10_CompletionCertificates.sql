

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
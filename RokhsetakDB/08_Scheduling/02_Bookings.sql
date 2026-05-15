USE ro5setkomDB;
GO

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
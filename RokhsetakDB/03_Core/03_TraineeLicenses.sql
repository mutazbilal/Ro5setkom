

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
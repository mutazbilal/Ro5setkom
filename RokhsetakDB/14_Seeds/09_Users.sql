SET IDENTITY_INSERT Core.Users ON;
INSERT INTO [RokhsetakDB].[Core].[Users]
(
    [user_id],
    [role_id],
    [national_id],
    [first_name],
    [last_name],
    [date_of_birth],
    [gender],
    [email],
    [phone_number],
    [province],
    [city],
    [address_line1],
    [address_line2],
    [postal_code],
    [password_hash],
    [profile_picture],
    [language_preference],
    [is_active],
    [created_at],
    [updated_at]
)
VALUES
(
    1,
    1,
    2000939089,
    'Abdalrahman',
    'Obeid',
    '2004-10-18',
    'male',
    'aboudaboudiua2@gmail.com',
    '078152830',
    'Amman',
    'Marj Al-Hammam',
    'Asem-Ben Nayef Street',
    NULL,
    '11732',
    '$2a$11$cKsXAbTDzl6bx/GC0tDaHORqtNqlnAc7044jB/BK3v1cxMvbJrLTu',
    NULL,
    'en',
    1,
    GETDATE(),
    GETDATE()
)
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

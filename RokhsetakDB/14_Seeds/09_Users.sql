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


-- ============================================
-- Seed Admin User for Existing Gov Citizen
-- National ID: 2000649758
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
    2, -- adjust if needed
    3, -- admin role id (adjust if your admin role uses another id)
    N'2000649758',
    N'معاذ',
    N'فريحات',
    '2003-04-03',
    N'male',
    N'moath.fraihat@example.com',
    N'0799999999',
    2, -- Zarqa
    4, -- Russeifa
    N'شارع الجامعة العربية - بناية رقم 54',
    NULL,
    N'13710',
    N'$2a$11$cKsXAbTDzl6bx/GC0tDaHORqtNqlnAc7044jB/BK3v1cxMvbJrLTu',
    NULL,
    N'ar',
    1,
    GETDATE(),
    GETDATE()
);

SET IDENTITY_INSERT Core.Users OFF;

INSERT INTO Roles.Admins
(
    admin_id,
    department,
    badge_number
)
VALUES
(
    2, -- same as user_id
    N'Licensing Department',
    N'ADM-0002'
);
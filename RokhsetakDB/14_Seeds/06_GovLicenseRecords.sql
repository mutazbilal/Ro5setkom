

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

-- Sara (Private Automatic)
(
    N'2001876543',
    1,
    '2022-11-01',
    '2027-11-01',
    N'active'
),

-- Ahmad Al-Omari (Expired license)
(
    N'2002987612',
    1,
    '2019-07-12',
    '2024-07-12',
    N'expired'
),

-- Laila (Learner / Manual)
(
    N'2003456127',
    2,
    '2023-05-20',
    '2028-05-20',
    N'active'
);
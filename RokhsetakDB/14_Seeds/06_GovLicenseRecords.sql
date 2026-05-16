

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

-- Yousef (Motorcycle)
(
    N'2001456781',
    3,
    '2021-03-15',
    '2026-03-15',
    N'expired'
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

-- Omar (Motorcycle)
(
    N'2001987345',
    3,
    '2024-02-12',
    '2029-02-12',
    N'active'
);
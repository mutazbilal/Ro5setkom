

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
);
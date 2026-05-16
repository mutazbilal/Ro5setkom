

INSERT INTO Gov.GovExamCenters (
    name,
    province,
    city,
    address_line1,
    address_line2,
    postal_code,
    phone_number,
    is_active
)
VALUES

-- =========================
-- Amman Centers
-- =========================
(
    N'Amman Central Driving Test Center',
    N'Amman',
    N'Amman',
    N'University Street, near Traffic Department HQ',
    NULL,
    N'11118',
    N'06-535-1234',
    1
),
(
    N'Marj Al-Hammam Licensing Center',
    N'Amman',
    N'Marj Al-Hammam',
    N'Asem Ben Nayef Street',
    NULL,
    N'11732',
    N'06-420-8891',
    1
),

-- =========================
-- Zarqa Centers
-- =========================
(
    N'Zarqa Driving Examination Center',
    N'Az Zarqa',
    N'Zarqa City',
    N'Industrial Area Road 15',
    NULL,
    N'13110',
    N'05-382-7710',
    1
),
(
    N'Russeifa Licensing Branch',
    N'Az Zarqa',
    N'Russeifa',
    N'University Street Building 12',
    NULL,
    N'13710',
    N'05-374-2201',
    1
),

-- =========================
-- Irbid Centers
-- =========================
(
    N'Irbid Driving Test Center',
    N'Irbid',
    N'Irbid City',
    N'University Street near Yarmouk University',
    NULL,
    N'21110',
    N'02-724-5510',
    1
),

-- =========================
-- Aqaba Centers
-- =========================
(
    N'Aqaba Licensing & Testing Center',
    N'Aqaba',
    N'Aqaba City',
    N'Port Area Road',
    NULL,
    N'77110',
    N'03-201-8899',
    1
),

-- =========================
-- Mafraq Centers
-- =========================
(
    N'Mafraq Driving Examination Center',
    N'Mafraq',
    N'Mafraq City',
    N'Central District Street',
    NULL,
    N'25110',
    N'02-623-4412',
    1
);
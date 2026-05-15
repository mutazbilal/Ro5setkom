USE ro5setkomDB;
GO

INSERT INTO Gov.GovCitizens (
    national_id,
    first_name,
    last_name,
    date_of_birth,
    gender,
    province,
    city,
    address_line1,
    address_line2,
    postal_code,
    is_eligible
)
VALUES
-- =========================
-- Provided Records
-- =========================

(
    N'2000649758',
    N'Moath',
    N'Freihat',
    '2003-04-03',
    N'male',
    N'Az Zarqa',
    N'Russeifa',
    N'The Arabian University Street Building Number 54',
    NULL,
    N'13710',
    1
),
(
    N'2000939089',
    N'Abdalrahman',
    N'Obeid',
    '2004-10-18',
    N'male',
    N'Amman',
    N'Marj Al-Hammam',
    N'Asem-Ben Nayef Street',
    NULL,
    N'11732',
    1
),

-- =========================
-- Generated Additional Records
-- =========================

(
    N'2001123456',
    N'Ahmad',
    N'Al-Khalidi',
    '2002-06-15',
    N'male',
    N'Amman',
    N'Tlaa Al-Ali',
    N'King Abdullah II Street',
    NULL,
    N'11953',
    1
),
(
    N'2001456781',
    N'Yousef',
    N'Abu Zaid',
    '2001-09-22',
    N'male',
    N'Irbid',
    N'Ramtha',
    N'University Street',
    NULL,
    N'21110',
    1
),
(
    N'2001789452',
    N'Khaled',
    N'Jaber',
    '2005-02-10',
    N'male',
    N'Aqaba',
    N'Aqaba City',
    N'Port Street',
    NULL,
    N'77110',
    1
),
(
    N'2001987345',
    N'Omar',
    N'Al-Salem',
    '2003-12-01',
    N'male',
    N'Mafraq',
    N'Mafraq City',
    N'Central Market Street',
    NULL,
    N'25110',
    1
),
(
    N'2001678910',
    N'Hassan',
    N'Al-Najjar',
    '2004-07-19',
    N'male',
    N'Zarqa',
    N'Zarqa City',
    N'Industrial Street',
    NULL,
    N'13110',
    1
),
(
    N'2000493916',
    N'Mutaz',
    N'Alfrahneh',
    '2002-06-18',
    N'male',
    N'Amman',
    N'Tabarbour',
    N'Army st',
    N'Southern Al-shaheed',
    N'11118',
    1
);
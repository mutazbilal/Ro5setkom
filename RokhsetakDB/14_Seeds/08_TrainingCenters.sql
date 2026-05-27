INSERT INTO Learning.TrainingCenters (
    display_name_en,
    display_name_ar,
    province_id,
    city_id,
    address_line1,
    address_line2,
    postal_code,
    phone_number,
    email,
    license_number,
    is_active
)
VALUES

-- =========================
-- Amman
-- =========================

(
    N'Al-Mustaqbal Driving Academy',
    N'أكاديمية المستقبل لتعليم القيادة',
    1, -- Amman
    1, -- Marj Al-Hammam (default main area)
    N'Gardens Street, Building 45',
    NULL,
    N'11118',
    N'06-552-8891',
    N'info@mustaqbal-driving.jo',
    N'TC-AMM-1001',
    1
),

(
    N'Royal Road Safety Institute',
    N'معهد الملكي للسلامة المرورية',
    1,
    2, -- Tlaa Al-Ali
    N'King Abdullah II Street',
    NULL,
    N'11953',
    N'06-533-7720',
    N'contact@royalroads.jo',
    N'TC-AMM-1002',
    1
),

-- =========================
-- Zarqa
-- =========================

(
    N'Zarqa Professional Driving School',
    N'مدرسة الزرقاء المهنية لتعليم القيادة',
    2, -- Zarqa
    5, -- Zarqa City
    N'Industrial Zone Road',
    NULL,
    N'13110',
    N'05-382-9911',
    N'info@zarqadrive.jo',
    N'TC-ZRQ-2001',
    1
),

-- =========================
-- Irbid
-- =========================

(
    N'Irbid Safe Driving Center',
    N'مركز إربد الآمن لتعليم القيادة',
    3, -- Irbid
    6, -- Ramtha / Irbid region
    N'University Street near Yarmouk University',
    NULL,
    N'21110',
    N'02-724-9900',
    N'contact@irbidsafe.jo',
    N'TC-IRB-3001',
    1
),

-- =========================
-- Aqaba
-- =========================

(
    N'Aqaba Maritime Driving Academy',
    N'أكاديمية العقبة البحرية لتعليم القيادة',
    4, -- Aqaba
    7, -- Aqaba City
    N'Port Area Road',
    NULL,
    N'77110',
    N'03-201-5566',
    N'info@aqabadrive.jo',
    N'TC-AQB-4001',
    1
);
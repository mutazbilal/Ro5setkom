INSERT INTO Lookup.Provinces (province_key)
VALUES
('amman'),
('zarqa'),
('irbid'),
('aqaba'),
('mafraq');

INSERT INTO Lookup.ProvinceTranslations (province_id, language_code, display_name)
VALUES
-- Amman
(1, 'en', N'Amman'),
(1, 'ar', N'عمّان'),

-- Zarqa
(2, 'en', N'Zarqa'),
(2, 'ar', N'الزرقاء'),

-- Irbid
(3, 'en', N'Irbid'),
(3, 'ar', N'إربد'),

-- Aqaba
(4, 'en', N'Aqaba'),
(4, 'ar', N'العقبة'),

-- Mafraq
(5, 'en', N'Mafraq'),
(5, 'ar', N'المفرق');

INSERT INTO Lookup.Cities (province_id, city_key)
VALUES
-- Amman
(1, 'marj_al_hammam'),
(1, 'tlaa_al_ali'),
(1, 'tabarbour'),

-- Zarqa
(2, 'russeifa'),
(2, 'zarqa_city'),

-- Irbid
(3, 'ramtha'),

-- Aqaba
(4, 'aqaba_city'),

-- Mafraq
(5, 'mafraq_city');


INSERT INTO Lookup.CityTranslations (city_id, language_code, display_name)
VALUES
-- Amman
(1, 'en', N'Marj Al-Hammam'),
(1, 'ar', N'مرج الحمام'),

(2, 'en', N'Tlaa Al-Ali'),
(2, 'ar', N'تلاع العلي'),

(3, 'en', N'Tabarbour'),
(3, 'ar', N'طبربور'),

-- Zarqa
(4, 'en', N'Russeifa'),
(4, 'ar', N'الرصيفة'),

(5, 'en', N'Zarqa City'),
(5, 'ar', N'مدينة الزرقاء'),

-- Irbid
(6, 'en', N'Ramtha'),
(6, 'ar', N'الرمثا'),

-- Aqaba
(7, 'en', N'Aqaba City'),
(7, 'ar', N'مدينة العقبة'),

-- Mafraq
(8, 'en', N'Mafraq City'),
(8, 'ar', N'مدينة المفرق');
USE ro5setkomDB;
GO

INSERT INTO Lookup.LicenseTypes (license_name, display_name_en, display_name_ar, description_en, description_ar) VALUES
    ('private_automatic', 'Private Car (Automatic)', 'سيارة خاصة (أوتوماتيك)', 'Private car with automatic transmission',        'سيارة خاصة ذات ناقل حركة أوتوماتيكي'),
    ('private_manual',    'Private Car (Manual)',    'سيارة خاصة (يدوي)',      'Private car with manual transmission',           'سيارة خاصة ذات ناقل حركة يدوي'),
    ('motorcycle',        'Motorcycle',              'دراجة نارية',            'Two-wheel motorcycle license',                   'رخصة دراجة نارية ذات عجلتين');
 
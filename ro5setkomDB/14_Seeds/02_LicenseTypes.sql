USE ro5setkomDB;
GO

INSERT INTO Lookup.LicenseTypes (license_name, description) VALUES
    ('private_automatic', 'Private car — automatic transmission'),
    ('private_manual',    'Private car — manual transmission'),
    ('motorcycle',        'Two-wheel motorcycle license');

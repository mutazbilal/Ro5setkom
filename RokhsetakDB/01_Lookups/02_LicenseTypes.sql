
 
CREATE TABLE Lookup.LicenseTypes (
    license_type_id  INT PRIMARY KEY IDENTITY(1,1),
    license_name     NVARCHAR(50)  NOT NULL UNIQUE CHECK (license_name IN ('motorcycle', 'private_automatic', 'private_manual')),
    display_name_en  NVARCHAR(100) NOT NULL,
    display_name_ar  NVARCHAR(100) NOT NULL,
    description_en   NVARCHAR(255) NULL,
    description_ar   NVARCHAR(255) NULL
);
GO
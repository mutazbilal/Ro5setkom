USE ro5setkomDB;
go

CREATE TABLE Lookup.LicenseTypes (
    license_type_id  INT PRIMARY KEY IDENTITY(1,1),
    license_name     NVARCHAR(50)  NOT NULL CHECK (license_name IN ('motorcycle', 'private_automatic', 'private_manual')),
    description      NVARCHAR(255)
);
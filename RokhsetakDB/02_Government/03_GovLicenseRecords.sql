

-- Licenses a citizen already holds (pre-existing, before using the platform)
CREATE TABLE Gov.GovLicenseRecords (
    record_id        INT PRIMARY KEY IDENTITY(1,1),
    national_id      NVARCHAR(10)  NOT NULL,
    license_type_id  INT           NOT NULL,
    issued_date      DATE,
    expiry_date      DATE,
    status           NVARCHAR(20)  NOT NULL CHECK (status IN ('active', 'expired', 'suspended', 'revoked')),

    FOREIGN KEY (national_id)     REFERENCES Gov.GovCitizens(national_id),
    FOREIGN KEY (license_type_id) REFERENCES Lookup.LicenseTypes(license_type_id)
);
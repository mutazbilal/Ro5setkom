CREATE TABLE Gov.GovCitizens (
    national_id     NVARCHAR(10)  PRIMARY KEY,

    first_name      NVARCHAR(100) NOT NULL,
    last_name       NVARCHAR(100) NOT NULL,

    date_of_birth   DATE          NOT NULL,

    gender          NVARCHAR(10)
        NOT NULL
        CHECK (gender IN ('male', 'female')),

    province_id     INT NOT NULL,
    city_id         INT NOT NULL,

    address_line1   NVARCHAR(255) NOT NULL,
    address_line2   NVARCHAR(255),

    postal_code     NVARCHAR(20),

    is_eligible     BIT DEFAULT 1,

    created_at      DATETIME2 DEFAULT GETDATE(),
    updated_at      DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (province_id)
        REFERENCES Lookup.Provinces(province_id),

    FOREIGN KEY (city_id)
        REFERENCES Lookup.Cities(city_id)
);

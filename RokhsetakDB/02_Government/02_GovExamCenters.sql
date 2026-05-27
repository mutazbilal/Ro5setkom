-- Official exam centers where theory, medical, and practical tests are held
CREATE TABLE Gov.GovExamCenters (
    center_id       INT PRIMARY KEY IDENTITY(1,1),

    name            NVARCHAR(255) NOT NULL, -- optional fallback/internal name

    province_id     INT NOT NULL,
    city_id         INT NOT NULL,

    address_line1   NVARCHAR(255) NOT NULL,
    address_line2   NVARCHAR(255),

    postal_code     NVARCHAR(20),
    phone_number    NVARCHAR(20),

    is_active       BIT DEFAULT 1,

    FOREIGN KEY (province_id)
        REFERENCES Lookup.Provinces(province_id),

    FOREIGN KEY (city_id)
        REFERENCES Lookup.Cities(city_id)
);
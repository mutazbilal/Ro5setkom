CREATE TABLE Learning.TrainingCenters (
    center_id      INT PRIMARY KEY IDENTITY(1,1),

    display_name_en NVARCHAR(255) NOT NULL,
    display_name_ar NVARCHAR(255) NOT NULL,

    province_id    INT NOT NULL,
    city_id        INT NOT NULL,

    address_line1  NVARCHAR(255) NOT NULL,
    address_line2  NVARCHAR(255),

    postal_code    NVARCHAR(20),
    phone_number   NVARCHAR(20),
    email          NVARCHAR(255) UNIQUE,

    license_number NVARCHAR(100) UNIQUE NOT NULL,

    is_active      BIT DEFAULT 1,
    created_at     DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (province_id)
        REFERENCES Lookup.Provinces(province_id),

    FOREIGN KEY (city_id)
        REFERENCES Lookup.Cities(city_id)
);
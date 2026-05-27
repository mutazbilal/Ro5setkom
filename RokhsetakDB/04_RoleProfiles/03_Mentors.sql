

CREATE TABLE Roles.Mentors (
    mentor_id            INT PRIMARY KEY,
    training_center_id   INT,
    license_type_id      INT,
    application_id       INT  NULL,
    price_per_session    DECIMAL(10, 2),
    vehicle_type         NVARCHAR(100),
    city_id              INT,
    created_at           DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (mentor_id)          REFERENCES Core.Users(user_id),
    FOREIGN KEY (license_type_id)    REFERENCES Lookup.LicenseTypes(license_type_id),

    FOREIGN KEY (city_id)
    REFERENCES Lookup.Cities(city_id)
);
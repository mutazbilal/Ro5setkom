CREATE TABLE Lookup.Cities (
    city_id INT PRIMARY KEY IDENTITY(1,1),

    province_id INT NOT NULL,

    city_key NVARCHAR(100) NOT NULL,

    UNIQUE (province_id, city_key),

    FOREIGN KEY (province_id)
        REFERENCES Lookup.Provinces(province_id)
);
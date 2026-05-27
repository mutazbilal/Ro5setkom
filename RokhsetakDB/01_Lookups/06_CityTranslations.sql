CREATE TABLE Lookup.CityTranslations (
    city_translation_id INT PRIMARY KEY IDENTITY(1,1),

    city_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    display_name NVARCHAR(100) NOT NULL,

    UNIQUE (city_id, language_code),

    FOREIGN KEY (city_id)
        REFERENCES Lookup.Cities(city_id)
        ON DELETE CASCADE
);
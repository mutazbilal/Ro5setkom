CREATE TABLE Lookup.ProvinceTranslations (
    province_translation_id INT PRIMARY KEY IDENTITY(1,1),

    province_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    display_name NVARCHAR(100) NOT NULL,

    UNIQUE (province_id, language_code),

    FOREIGN KEY (province_id)
        REFERENCES Lookup.Provinces(province_id)
        ON DELETE CASCADE
);
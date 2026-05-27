CREATE TABLE Lookup.Provinces (
    province_id INT PRIMARY KEY IDENTITY(1,1),

    province_key NVARCHAR(50) NOT NULL UNIQUE
);
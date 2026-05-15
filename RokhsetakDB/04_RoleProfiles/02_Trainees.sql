USE ro5setkomDB;
go

CREATE TABLE Roles.Trainees (
    trainee_id         INT PRIMARY KEY,
    license_type_id    INT,
    training_center_id INT,
    enrolled_at        DATE DEFAULT CAST(GETDATE() AS DATE),

    FOREIGN KEY (trainee_id)         REFERENCES Core.Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (license_type_id)    REFERENCES Lookup.LicenseTypes(license_type_id)
);
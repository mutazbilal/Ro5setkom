USE ro5setkomDB;
go

CREATE TABLE Learning.TrainingCenters (
    center_id      INT PRIMARY KEY IDENTITY(1,1),
    name           NVARCHAR(255) NOT NULL,
    province       NVARCHAR(100) NOT NULL,
    city           NVARCHAR(100) NOT NULL,
    address_line1  NVARCHAR(255) NOT NULL,
    address_line2  NVARCHAR(255),
    postal_code    NVARCHAR(20),
    phone_number   NVARCHAR(20),
    email          NVARCHAR(255) UNIQUE,
    license_number NVARCHAR(100) UNIQUE NOT NULL,
    is_active      BIT       DEFAULT 1,
    created_at     DATETIME2 DEFAULT GETDATE()
);
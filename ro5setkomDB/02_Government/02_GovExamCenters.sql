USE ro5setkomDB;
go

-- Official exam centers where theory, medical, and practical tests are held
CREATE TABLE Gov.GovExamCenters (
    center_id       INT PRIMARY KEY IDENTITY(1,1),
    name            NVARCHAR(255) NOT NULL,
    province        NVARCHAR(100) NOT NULL,
    city            NVARCHAR(100) NOT NULL,
    address_line1   NVARCHAR(255) NOT NULL,
    address_line2   NVARCHAR(255),
    postal_code     NVARCHAR(20),
    phone_number    NVARCHAR(20),
    is_active       BIT DEFAULT 1
);
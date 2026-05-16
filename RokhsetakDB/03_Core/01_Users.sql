

CREATE TABLE Core.Users (
    user_id             INT PRIMARY KEY IDENTITY(1,1),
    role_id             INT           NOT NULL,
    national_id         NVARCHAR(10)  UNIQUE NOT NULL,
    first_name          NVARCHAR(100) NOT NULL,
    last_name           NVARCHAR(100) NOT NULL,
    date_of_birth       DATE,
    gender              NVARCHAR(10)  CHECK (gender IN ('male', 'female')),
    email               NVARCHAR(255) UNIQUE NOT NULL,
    phone_number        NVARCHAR(20),
    province            NVARCHAR(100) NOT NULL,
    city                NVARCHAR(100) NOT NULL,
    address_line1       NVARCHAR(255) NOT NULL,
    address_line2       NVARCHAR(255),
    postal_code         NVARCHAR(20),
    password_hash       NVARCHAR(255) NOT NULL,
    profile_picture     NVARCHAR(500),
    language_preference NVARCHAR(5)   DEFAULT 'ar' CHECK (language_preference IN ('ar', 'en')),
    is_active           BIT           DEFAULT 1,
    created_at          DATETIME2     DEFAULT GETDATE(),
    updated_at          DATETIME2     DEFAULT GETDATE(),

    FOREIGN KEY (role_id)     REFERENCES Lookup.Roles(role_id),
    FOREIGN KEY (national_id) REFERENCES Gov.GovCitizens(national_id)  -- identity must exist in gov registry
);
USE ro5setkomDB;
go

CREATE TABLE Lookup.Roles (
    role_id    INT PRIMARY KEY IDENTITY(1,1),
    role_name  NVARCHAR(50) NOT NULL CHECK (role_name IN ('trainee', 'mentor', 'admin'))
);
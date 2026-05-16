

CREATE TABLE Roles.Admins (
    admin_id     INT PRIMARY KEY,
    department   NVARCHAR(255) NULL,       -- populated for gov-side admins
    badge_number NVARCHAR(100) UNIQUE NULL, -- populated for gov-side admins

    FOREIGN KEY (admin_id) REFERENCES Core.Users(user_id)
);
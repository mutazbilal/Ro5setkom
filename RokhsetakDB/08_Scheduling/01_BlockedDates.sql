USE ro5setkomDB;
GO

CREATE TABLE Scheduling.BlockedDates (
    blocked_date_id  INT PRIMARY KEY IDENTITY(1,1),
    blocked_date     DATE          NOT NULL UNIQUE,
    reason           NVARCHAR(255),
    blocked_by       INT           NOT NULL,
    created_at       DATETIME2     DEFAULT GETDATE(),

    FOREIGN KEY (blocked_by) REFERENCES Roles.Admins(admin_id)
);
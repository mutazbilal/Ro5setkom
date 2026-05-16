

CREATE TABLE Security.AuditLogs (
    log_id        INT PRIMARY KEY IDENTITY(1,1),
    user_id       INT            NOT NULL,
    action        NVARCHAR(255)  NOT NULL,
    table_name    NVARCHAR(100),
    record_id     NVARCHAR(50),   
    performed_at  DATETIME2      DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id)
);
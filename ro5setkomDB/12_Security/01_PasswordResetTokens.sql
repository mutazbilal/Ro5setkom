USE ro5setkomDB;
GO

CREATE TABLE SecurityPasswordResetTokens (
    token_id    INT PRIMARY KEY IDENTITY(1,1),
    user_id     INT           NOT NULL,
    token       NVARCHAR(255) UNIQUE NOT NULL,
    expires_at  DATETIME2     NOT NULL,
    used        BIT           DEFAULT 0,
    created_at  DATETIME2     DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id)
);
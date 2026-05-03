USE ro5setkomDB;
GO

CREATE TABLE AI.AIChatSessions (
    session_id  INT PRIMARY KEY IDENTITY(1,1),
    user_id     INT       NOT NULL,
    created_at  DATETIME2 DEFAULT GETDATE(),
    ended_at    DATETIME2 NULL,

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id)
);
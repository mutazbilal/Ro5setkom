

CREATE TABLE AI.AIChatSessions (
    session_id  INT PRIMARY KEY IDENTITY(1,1),
    user_id     INT       NOT NULL,
    created_at  DATETIME2 DEFAULT GETDATE(),
    ended_at    DATETIME2 NULL,
    title         NVARCHAR(200) NULL,
    persona_key   NVARCHAR(50)  NULL,
    system_prompt NVARCHAR(MAX) NULL,
    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id)
);
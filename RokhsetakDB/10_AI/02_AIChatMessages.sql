USE ro5setkomDB;
GO

CREATE TABLE AI.AIChatMessages (
    message_id  INT PRIMARY KEY IDENTITY(1,1),
    session_id  INT           NOT NULL,
    role        NVARCHAR(10)  NOT NULL CHECK (role IN ('user', 'assistant')),
    content     NVARCHAR(MAX) NOT NULL,
    sent_at     DATETIME2     DEFAULT GETDATE(),

    FOREIGN KEY (session_id) REFERENCES AI.AIChatSessions(session_id)
);
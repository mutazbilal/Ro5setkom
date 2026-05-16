

CREATE TABLE Messaging.Messages (
    message_id       INT PRIMARY KEY IDENTITY(1,1),
    conversation_id  INT          NOT NULL,
    sender_id        INT          NOT NULL,
    message_text     NVARCHAR(MAX),
    is_read          BIT          DEFAULT 0,
    sent_at          DATETIME2    DEFAULT GETDATE(),

    FOREIGN KEY (conversation_id)
        REFERENCES Messaging.Conversations(conversation_id)
        ON DELETE CASCADE,
    FOREIGN KEY (sender_id)       REFERENCES Core.Users(user_id)
);
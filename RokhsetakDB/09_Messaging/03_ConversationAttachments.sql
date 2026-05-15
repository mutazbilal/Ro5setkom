USE ro5setkomDB;
GO

CREATE TABLE Messaging.ConversationAttachments (
    attachment_id    INT PRIMARY KEY IDENTITY(1,1),
    conversation_id  INT NOT NULL,
    message_id       INT NULL,  -- optional: attach to specific message

    uploaded_by      INT NOT NULL, -- user who sent file
    file_name        NVARCHAR(255) NOT NULL,
    file_path        NVARCHAR(500) NOT NULL,
    file_type        NVARCHAR(10) CHECK (file_type IN ('pdf', 'image', 'other')),
    uploaded_at      DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (conversation_id)
        REFERENCES Messaging.Conversations(conversation_id)
        ON DELETE CASCADE,

    FOREIGN KEY (uploaded_by)
        REFERENCES Core.Users(user_id)
);
GO
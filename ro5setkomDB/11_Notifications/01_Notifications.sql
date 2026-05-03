USE ro5setkomDB;
GO

CREATE TABLE Notifications.Notifications (
    notification_id  INT PRIMARY KEY IDENTITY(1,1),
    user_id          INT          NOT NULL,
    title            NVARCHAR(MAX),
    message          NVARCHAR(MAX),
    type             NVARCHAR(50) NOT NULL
                         CHECK (type IN ('appointment', 'exam', 'booking', 'quiz', 'material', 'certificate', 'system')),
    channel          NVARCHAR(10) NOT NULL DEFAULT 'app'
                         CHECK (channel IN ('app', 'email', 'sms')),
    is_read          BIT          NOT NULL DEFAULT 0,
    created_at       DATETIME2    DEFAULT GETDATE(),

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id)
);
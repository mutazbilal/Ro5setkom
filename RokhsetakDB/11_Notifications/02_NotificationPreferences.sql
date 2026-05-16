

CREATE TABLE Notifications.NotificationPreferences (
    user_id INT PRIMARY KEY,
    prefers_email BIT NOT NULL DEFAULT 1,
    prefers_sms   BIT NOT NULL DEFAULT 0,
    prefers_app   BIT NOT NULL DEFAULT 1,
    reminder_hours_before INT NOT NULL DEFAULT 24,

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id)
        ON DELETE CASCADE
);
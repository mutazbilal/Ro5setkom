

CREATE TABLE Messaging.Conversations (
    conversation_id INT       PRIMARY KEY IDENTITY(1,1),
    trainee_id      INT       NOT NULL,
    mentor_id       INT       NOT NULL,
    created_at      DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (trainee_id) REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (mentor_id)  REFERENCES Roles.Mentors(mentor_id),
    FOREIGN KEY (booking_id) REFERENCES Scheduling.Bookings(booking_id)
);
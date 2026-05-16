

CREATE TABLE Learning.SessionFeedback (
    feedback_id   INT PRIMARY KEY IDENTITY(1,1),
    booking_id    INT          NOT NULL UNIQUE,
    trainee_id    INT          NOT NULL,
    mentor_id     INT          NOT NULL,
    mentor_notes  NVARCHAR(MAX),
    created_at    DATETIME2    DEFAULT GETDATE(),

    FOREIGN KEY (booking_id)  REFERENCES Scheduling.Bookings(booking_id),
    FOREIGN KEY (trainee_id)  REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (mentor_id)   REFERENCES Roles.Mentors(mentor_id)
);
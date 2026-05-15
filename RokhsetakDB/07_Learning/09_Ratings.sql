USE ro5setkomDB;
GO

CREATE TABLE Learning.Ratings (
    rating_id    INT PRIMARY KEY IDENTITY(1,1),
    trainee_id   INT            NOT NULL,
    mentor_id    INT            NOT NULL,
    booking_id   INT            NOT NULL UNIQUE,
    score        DECIMAL(2, 1)  NOT NULL CHECK (score BETWEEN 1.0 AND 5.0),
    review_text  NVARCHAR(1000) NULL,
    created_at   DATETIME2      DEFAULT GETDATE(),

    FOREIGN KEY (trainee_id) REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (mentor_id)  REFERENCES Roles.Mentors(mentor_id),
    FOREIGN KEY (booking_id) REFERENCES Scheduling.Bookings(booking_id)
);
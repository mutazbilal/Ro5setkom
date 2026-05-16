

CREATE TABLE Mentor.MentorAvailability (
    availability_id  INT PRIMARY KEY IDENTITY(1,1),
    mentor_id        INT          NOT NULL,
    day_of_week      NVARCHAR(10) NOT NULL CHECK (day_of_week IN ('sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday')),
    start_time       TIME         NOT NULL,
    end_time         TIME         NOT NULL,
    is_active        BIT          DEFAULT 1,

    CHECK (start_time < end_time),

    FOREIGN KEY (mentor_id) REFERENCES Roles.Mentors(mentor_id)
);
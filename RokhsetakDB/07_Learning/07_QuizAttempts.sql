USE ro5setkomDB;
GO

CREATE TABLE Learning.QuizAttempts (
    attempt_id      INT PRIMARY KEY IDENTITY(1,1),
    quiz_id         INT       NOT NULL,
    trainee_id      INT       NOT NULL,
    trainee_license_id INT       NOT NULL,
    score           INT,
    passed          BIT,
    attempt_date    DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (quiz_id)         REFERENCES Learning.Quizzes(quiz_id),
    FOREIGN KEY (trainee_id)      REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (trainee_license_id) REFERENCES Core.TraineeLicenses(trainee_license_id)
);
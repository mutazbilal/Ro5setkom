USE ro5setkomDB;
GO

CREATE TABLE Learning.QuizQuestions (
    question_id    INT PRIMARY KEY IDENTITY(1,1),
    quiz_id        INT            NOT NULL,

    FOREIGN KEY (quiz_id) REFERENCES Learning.Quizzes(quiz_id)
);
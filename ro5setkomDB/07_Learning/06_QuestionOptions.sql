USE ro5setkomDB;
GO

CREATE TABLE Learning.QuestionOptions (
    option_id     INT PRIMARY KEY IDENTITY(1,1),
    question_id   INT            NOT NULL,
    is_correct    BIT            NOT NULL DEFAULT 0,

    FOREIGN KEY (question_id) REFERENCES Learning.QuizQuestions(question_id)
);
use ro5setkomDB
GO

CREATE TABLE Learning.QuestionTranslations (
    question_translation_id INT PRIMARY KEY IDENTITY,
    question_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    question_text NVARCHAR(1000) NOT NULL,

    UNIQUE (question_id, language_code),

    FOREIGN KEY (question_id) REFERENCES Learning.QuizQuestions(question_id)
);
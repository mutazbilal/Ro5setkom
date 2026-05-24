CREATE TABLE Learning.QuizTranslations (
    quiz_translation_id INT PRIMARY KEY IDENTITY,
    quiz_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    title NVARCHAR(255) NOT NULL,

    UNIQUE (quiz_id, language_code),

    FOREIGN KEY (quiz_id) REFERENCES Learning.Quizzes(quiz_id)
);
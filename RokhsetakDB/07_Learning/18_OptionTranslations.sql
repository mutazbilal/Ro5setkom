CREATE TABLE Learning.OptionTranslations (
    option_translation_id INT PRIMARY KEY IDENTITY,
    option_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    option_text NVARCHAR(500) NOT NULL,

    UNIQUE (option_id, language_code),

    FOREIGN KEY (option_id) REFERENCES Learning.QuestionOptions(option_id)
);
CREATE TABLE Learning.ModuleTranslations (
    module_translation_id INT PRIMARY KEY IDENTITY,
    module_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL, -- 'en', 'ar'

    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(500),

    UNIQUE (module_id, language_code),

    FOREIGN KEY (module_id) REFERENCES Learning.LearningModules(module_id)
);
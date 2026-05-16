

CREATE TABLE Learning.Quizzes (
    quiz_id          INT PRIMARY KEY IDENTITY(1,1),
    module_id        INT           NULL,    -- NULL for mock exams
    is_mock_exam     BIT           DEFAULT 0,
    license_type_id  INT           NULL,    -- required when is_mock_exam = 1
    passing_score    INT           NOT NULL,

    FOREIGN KEY (module_id)       REFERENCES Learning.LearningModules(module_id),
    FOREIGN KEY (license_type_id) REFERENCES Lookup.LicenseTypes(license_type_id)
);
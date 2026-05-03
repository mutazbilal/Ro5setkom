USE ro5setkomDB;
GO

CREATE TABLE Learning.TraineeModuleProgress (
    progress_id     INT PRIMARY KEY IDENTITY(1,1),
    trainee_id      INT          NOT NULL,
    module_id       INT          NOT NULL,
    trainee_license_id INT          NOT NULL,
    status          NVARCHAR(20) NOT NULL DEFAULT 'not_started'
                        CHECK (status IN ('not_started', 'in_progress', 'completed')),
    started_at      DATETIME2    NULL,
    completed_at    DATETIME2    NULL,

    UNIQUE (trainee_id, module_id, trainee_license_id),

    FOREIGN KEY (trainee_id)      REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (module_id)       REFERENCES Learning.LearningModules(module_id),
    FOREIGN KEY (trainee_license_id) REFERENCES Core.TraineeLicenses(trainee_license_id)
);
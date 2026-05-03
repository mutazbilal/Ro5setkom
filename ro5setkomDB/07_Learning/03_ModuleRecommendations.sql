USE ro5setkomDB;
GO

CREATE TABLE Learning.ModuleRecommendations (
    recommendation_id  INT PRIMARY KEY IDENTITY(1,1),
    mentor_id          INT       NOT NULL,
    trainee_id         INT       NOT NULL,
    module_id          INT       NOT NULL,
    note               NVARCHAR(500),
    created_at         DATETIME2 DEFAULT GETDATE(),

    FOREIGN KEY (mentor_id)  REFERENCES Roles.Mentors(mentor_id),
    FOREIGN KEY (trainee_id) REFERENCES Roles.Trainees(trainee_id),
    FOREIGN KEY (module_id)  REFERENCES Learning.LearningModules(module_id)
);
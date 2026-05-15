USE ro5setkomDB;
GO

CREATE TABLE Learning.ModuleContents (
    content_id   INT PRIMARY KEY IDENTITY(1,1),
    module_id    INT NOT NULL,
    content_type NVARCHAR(20) CHECK (content_type IN ('video', 'text')),
    
    video_url    NVARCHAR(500) NULL,

    FOREIGN KEY (module_id) REFERENCES Learning.LearningModules(module_id)
);
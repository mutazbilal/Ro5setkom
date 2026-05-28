CREATE TABLE Learning.ModuleContentTranslations (
    content_translation_id INT PRIMARY KEY IDENTITY,
    content_id INT NOT NULL,
    language_code NVARCHAR(5) NOT NULL,

    text_content NVARCHAR(MAX) NULL,
    
    video_url    NVARCHAR(500) NULL,
    UNIQUE (content_id, language_code),

    FOREIGN KEY (content_id) REFERENCES Learning.ModuleContents(content_id)
);
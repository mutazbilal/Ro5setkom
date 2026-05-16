

-- ============================================
-- FK PATCH: Mentors → MentorApplications
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Mentors_MentorApplications'
)
BEGIN
    ALTER TABLE Roles.Mentors
    ADD CONSTRAINT FK_Mentors_MentorApplications
    FOREIGN KEY (application_id)
    REFERENCES Mentor.MentorApplications(application_id);
END
GO
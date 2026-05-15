USE ro5setkomDB;
GO

-- ============================================
-- FK PATCH: Mentors → TrainingCenters
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Mentors_TrainingCenters'
)
BEGIN
    ALTER TABLE Roles.Mentors
    ADD CONSTRAINT FK_Mentors_TrainingCenters
    FOREIGN KEY (training_center_id)
    REFERENCES Learning.TrainingCenters(center_id);
END
GO
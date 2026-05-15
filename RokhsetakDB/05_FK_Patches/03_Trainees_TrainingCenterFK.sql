USE ro5setkomDB;
GO

-- ============================================
-- FK PATCH: Trainees → TrainingCenters
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Trainees_TrainingCenters'
)
BEGIN
    ALTER TABLE Roles.Trainees
    ADD CONSTRAINT FK_Trainees_TrainingCenters
    FOREIGN KEY (training_center_id)
    REFERENCES Learning.TrainingCenters(center_id);
END
GO
USE ro5setkomDB;
GO

-- ============================================
-- FK PATCH: TraineeLicenses → Trainees
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_TraineeLicenses_Trainees'
)
BEGIN
    ALTER TABLE Core.TraineeLicenses
    ADD CONSTRAINT FK_TraineeLicenses_Trainees
    FOREIGN KEY (trainee_id)
    REFERENCES Roles.Trainees(trainee_id);
END
GO
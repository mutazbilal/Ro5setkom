USE ro5setkomDB;
GO

-- ============================================
-- FK PATCH: TraineeLicenses → Mentors
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_TraineeLicenses_Mentors'
)
BEGIN
    ALTER TABLE Core.TraineeLicenses
    ADD CONSTRAINT FK_TraineeLicenses_Mentors
    FOREIGN KEY (mentor_id)
    REFERENCES Roles.Mentors(mentor_id);
END
GO
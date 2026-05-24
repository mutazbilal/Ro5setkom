-- ============================================
-- FK PATCH: GovOfficialExams → Admins
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_GovOfficialExams_Admins'
)
BEGIN
    ALTER TABLE Gov.GovOfficialExams
    ADD CONSTRAINT FK_GovOfficialExams_Admins
    FOREIGN KEY (created_by)
    REFERENCES Roles.Admins(admin_id);
END
GO
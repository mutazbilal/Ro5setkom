

-- ============================================
-- FK PATCH: GovExamResults → Admins
-- ============================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_GovExamResults_Admins'
)
BEGIN
    ALTER TABLE Gov.GovExamResults
    ADD CONSTRAINT FK_GovExamResults_Admins
    FOREIGN KEY (recorded_by)
    REFERENCES Roles.Admins(admin_id);
END
GO
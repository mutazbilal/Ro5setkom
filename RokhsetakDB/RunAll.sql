-- ============================================
-- DRIVING LICENSE DB - MASTER DEPLOY SCRIPT
-- ============================================

-- IMPORTANT:
-- Run in SQL Server Management Studio with:
-- Query → SQLCMD Mode ENABLED
-- ============================================


-- ============================================
-- DROP DATABASE IF EXISTS
-- ============================================
IF DB_ID('RokhsetakDB') IS NOT NULL
BEGIN
    PRINT 'Dropping existing database...';
    ALTER DATABASE RokhsetakDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RokhsetakDB;
END
GO

-- ============================================
-- 1. CREATE DATABASE




-- ============================================
-- 2. CREATE SCHEMAS
-- ============================================
PRINT 'Creating Schemas...';
:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\00_Database\02_CreateSchemas.sql"
GO

-- ============================================
-- 3. LOOKUP TABLES (no dependencies)
-- ============================================
PRINT 'Running Lookups...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\01_Lookups\01_Roles.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\01_Lookups\02_LicenseTypes.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\01_Lookups\03_Provinces.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\01_Lookups\04_ProvinceTranslations.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\01_Lookups\05_Cities.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\01_Lookups\06_CityTranslations.sql"
GO

-- ============================================
-- 4. GOVERNMENT MODULE
-- ============================================
PRINT 'Running Government Module...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\02_Government\01_GovCitizens.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\02_Government\02_GovExamCenters.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\02_Government\03_GovLicenseRecords.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\02_Government\04_GovOfficialExams.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\02_Government\05_GovExamResults.sql"
GO

-- ============================================
-- 5. CORE
-- ============================================
PRINT 'Running Core Module...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\03_Core\01_Users.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\03_Core\02_UserConsents.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\03_Core\03_TraineeLicenses.sql"
GO

-- ============================================
-- 6. ROLE PROFILES
-- ============================================
PRINT 'Running Role Profiles...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\04_RoleProfiles\01_Admins.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\04_RoleProfiles\02_Trainees.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\04_RoleProfiles\03_Mentors.sql"
GO

-- ============================================
-- 7. MENTOR EXTENSIONS
-- ============================================
PRINT 'Running Mentor Extensions...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\06_Mentor\02_MentorAvailability.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\06_Mentor\03_MentorApplications.sql"
GO

-- ============================================
-- 10. SCHEDULING
-- ============================================
PRINT 'Running Scheduling...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\08_Scheduling\01_BlockedDates.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\08_Scheduling\02_Bookings.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\08_Scheduling\03_ExamAppointments.sql"
GO


-- ============================================
-- 9. LEARNING SYSTEM
-- ============================================
PRINT 'Running Learning System...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\01_LearningModules.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\02_TraineeModuleProgress.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\03_ModuleRecommendations.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\04_Quizzes.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\05_QuizQuestions.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\06_QuestionOptions.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\07_QuizAttempts.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\09_Ratings.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\10_CompletionCertificates.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\11_SessionFeedback.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\12_TrainingCenters.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\13_ModuleContents.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\14_ModuleTranslations.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\15_ModuleContentsTranslation.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\16_QuizTranslations.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\17_QuestionTranslations.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\07_Learning\18_OptionTranslations.sql"
GO

-- ============================================
-- 11. MESSAGING
-- ============================================
PRINT 'Running Messaging...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\09_Messaging\01_Conversations.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\09_Messaging\02_Messages.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\09_Messaging\03_ConversationAttachments.sql"
GO

-- ============================================
-- 12. AI MODULE
-- ============================================
PRINT 'Running AI Module...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\10_AI\01_AIChatSessions.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\10_AI\02_AIChatMessages.sql"
GO

-- ============================================
-- 13. NOTIFICATIONS
-- ============================================
PRINT 'Running Notifications...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\11_Notifications\01_Notifications.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\11_Notifications\02_NotificationPreferences.sql"
GO

-- ============================================
-- 14. SECURITY
-- ============================================
PRINT 'Running Security...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\12_Security\01_PasswordResetTokens.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\12_Security\02_AuditLogs.sql"
GO

-- ============================================
-- 15. INDEXES
-- ============================================
PRINT 'Creating Indexes...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\13_Indexes\01_Indexes.sql"
GO

-- ============================================
-- 8. FK PATCHES
-- ============================================
PRINT 'Applying FK Patches...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\05_FK_Patches\01_GovOfficialExams_AdminFK.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\05_FK_Patches\02_GovExamResults_AdminFK.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\05_FK_Patches\03_Trainees_TrainingCenterFK.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\05_FK_Patches\04_Mentors_TrainingCenterFK.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\05_FK_Patches\05_Mentors_MentorApplicationsFK.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\05_FK_Patches\06_TraineeLicenses_TraineesFK.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\05_FK_Patches\07_TraineeLicenses_MentorsFK.sql"
GO

-- ============================================
-- 16. SEEDS
-- ============================================
PRINT 'Seeding Data...';

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\14_Seeds\10_Provinces_Cties.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\14_Seeds\01_Roles.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\14_Seeds\02_LicenseTypes.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\14_Seeds\03_seed_modules.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\14_Seeds\04_seed_all_quizzes_questions_options.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\14_Seeds\05_GovCitizens.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\14_Seeds\06_GovLicenseRecords.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\14_Seeds\07_GovExamCenters.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\14_Seeds\08_TrainingCenters.sql"
GO

:r "C:\Users\Lenovo\source\repos\Rokhsetak\RokhsetakDB\14_Seeds\09_Users.sql"
GO

-- ============================================
-- DONE
-- ============================================
PRINT 'DATABASE DEPLOYMENT COMPLETED SUCCESSFULLY';
GO
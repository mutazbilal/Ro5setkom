

-- ============================================
-- SCHEMAS INITIALIZATION SCRIPT
-- ============================================

-- Core business domain
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Core')
    EXEC('CREATE SCHEMA Core');
GO

-- Lookup / static reference data
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Lookup')
    EXEC('CREATE SCHEMA Lookup');
GO

-- Government / external authority records
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Gov')
    EXEC('CREATE SCHEMA Gov');
GO

-- Role-specific extensions
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Roles')
    EXEC('CREATE SCHEMA Roles');
GO

-- Mentor-specific extensions
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Mentor')
    EXEC('CREATE SCHEMA Mentor');
GO

-- Learning system (modules, quizzes, attachments, progress)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Learning')
    EXEC('CREATE SCHEMA Learning');
GO

-- Scheduling system (bookings, exams, availability)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Scheduling')
    EXEC('CREATE SCHEMA Scheduling');
GO

-- Messaging system
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Messaging')
    EXEC('CREATE SCHEMA Messaging');
GO

-- AI features
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'AI')
    EXEC('CREATE SCHEMA AI');
GO

-- Notifications system
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Notifications')
    EXEC('CREATE SCHEMA Notifications');
GO

-- Security & auditing
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Security')
    EXEC('CREATE SCHEMA Security');
GO


-- ============================================================
-- DEFINE INDEXES
-- ============================================================

-- Users
CREATE INDEX idx_users_email ON Core.Users(email);
CREATE INDEX idx_users_national_id ON Core.Users(national_id);

-- Bookings
CREATE INDEX idx_bookings_mentor_id ON Scheduling.Bookings(mentor_id);
CREATE INDEX idx_bookings_trainee_id ON Scheduling.Bookings(trainee_id);

-- Exams
CREATE INDEX idx_examappointments_trainee_id ON Scheduling.ExamAppointments(trainee_id);

-- Messages
CREATE INDEX idx_messages_conversation_id ON Messaging.Messages(conversation_id);

-- Notifications
CREATE INDEX idx_notifications_user_id ON Notifications.Notifications(user_id);

-- Quiz Questions
CREATE INDEX idx_quizquestions_quiz_id ON Learning.QuizQuestions(quiz_id);
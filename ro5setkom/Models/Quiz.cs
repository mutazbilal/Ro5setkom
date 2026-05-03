using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class Quiz
{
    public int QuizId { get; set; }

    public int? ModuleId { get; set; }

    public bool? IsMockExam { get; set; }

    public int? LicenseTypeId { get; set; }

    public string Title { get; set; } = null!;

    public int PassingScore { get; set; }

    public virtual LicenseType? LicenseType { get; set; }

    public virtual LearningModule? Module { get; set; }

    public virtual ICollection<QuizAttempt> QuizAttempts { get; set; } = new List<QuizAttempt>();

    public virtual ICollection<QuizQuestion> QuizQuestions { get; set; } = new List<QuizQuestion>();
}

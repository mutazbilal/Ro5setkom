using System;
using System.Collections.Generic;

namespace ro5setkom.Models;

public partial class LearningModule
{
    public int ModuleId { get; set; }

    public int LicenseTypeId { get; set; }

    public string Phase { get; set; } = null!;

    public int OrderIndex { get; set; }

    public int? PrerequisiteModuleId { get; set; }

    public virtual ICollection<LearningModule> InversePrerequisiteModule { get; set; } = new List<LearningModule>();

    public virtual LicenseType LicenseType { get; set; } = null!;

    public virtual ICollection<ModuleContent> ModuleContents { get; set; } = new List<ModuleContent>();

    public virtual ICollection<ModuleRecommendation> ModuleRecommendations { get; set; } = new List<ModuleRecommendation>();

    public virtual ICollection<ModuleTranslation> ModuleTranslations { get; set; } = new List<ModuleTranslation>();

    public virtual LearningModule? PrerequisiteModule { get; set; }

    public virtual ICollection<Quiz> Quizzes { get; set; } = new List<Quiz>();

    public virtual ICollection<TraineeModuleProgress> TraineeModuleProgresses { get; set; } = new List<TraineeModuleProgress>();
}

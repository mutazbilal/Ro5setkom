CREATE TABLE Learning.LearningModuleLicenseTypes (
    module_id INT NOT NULL,
    license_type_id INT NOT NULL,

    CONSTRAINT PK_LearningModuleLicenseTypes
        PRIMARY KEY (module_id, license_type_id),

    CONSTRAINT FK_LMLT_Module
        FOREIGN KEY (module_id)
        REFERENCES Learning.LearningModules(module_id)
        ON DELETE CASCADE,

    CONSTRAINT FK_LMLT_LicenseType
        FOREIGN KEY (license_type_id)
        REFERENCES Lookup.LicenseTypes(license_type_id)
        ON DELETE CASCADE
);
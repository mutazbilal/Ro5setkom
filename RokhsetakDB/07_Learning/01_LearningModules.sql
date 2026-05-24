CREATE TABLE Learning.LearningModules (
    module_id              INT PRIMARY KEY IDENTITY(1,1),
    license_type_id        INT           NOT NULL,
    phase                  NVARCHAR(20)  NOT NULL CHECK (phase IN ('theoretical', 'practical')),
    order_index            INT           NOT NULL,
    prerequisite_module_id INT           NULL,

    UNIQUE (license_type_id, order_index, phase),

    FOREIGN KEY (license_type_id)        REFERENCES Lookup.LicenseTypes(license_type_id),
    FOREIGN KEY (prerequisite_module_id) REFERENCES Learning.LearningModules(module_id)
);
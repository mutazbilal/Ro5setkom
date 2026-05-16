

CREATE TABLE Core.UserConsents (
    consent_id    INT PRIMARY KEY IDENTITY(1,1),
    user_id       INT           NOT NULL,
    consent_type  NVARCHAR(100) NOT NULL CHECK (consent_type IN ('government_data_retrieval', 'terms_and_privacy')),
    consented     BIT           NOT NULL DEFAULT 1,
    consented_at  DATETIME2     NOT NULL DEFAULT GETDATE(),
    ip_address    NVARCHAR(50),

    FOREIGN KEY (user_id) REFERENCES Core.Users(user_id) ON DELETE CASCADE
);
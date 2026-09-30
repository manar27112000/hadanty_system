USE Hadanty;
GO

-- =============================================
-- 1. DailyReport
-- Child 1 : N DailyReport
-- =============================================

CREATE TABLE DailyReport (
    daily_report_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT NOT NULL,
    report_date DATE NOT NULL,
    food VARCHAR(255),
    sleep VARCHAR(255),
    mood VARCHAR(100),
    activities_notes VARCHAR(1000),
    homework_notes VARCHAR(1000),
    general_notes VARCHAR(1000),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_DailyReport_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id)
);
GO


-- =============================================
-- 2a. AssessmentLevel
-- The levels a nursery uses for assessments (Excellent, Good, ...).
-- Teachers pick from this list; nobody types a level by hand.
-- =============================================

CREATE TABLE AssessmentLevel (
    level_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    sort_order INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_AssessmentLevel_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id),

    CONSTRAINT UQ_AssessmentLevel_Id_Nursery
        UNIQUE (level_id, nursery_id)
);
GO


-- =============================================
-- 2b. DailyAssessment
-- Child 1 : N DailyAssessment
-- Subject 1 : N DailyAssessment
-- The child and the level must belong to the same nursery.
-- =============================================

CREATE TABLE DailyAssessment (
    daily_assessment_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    child_id INT NOT NULL,
    subject_id INT NOT NULL,
    assessment_date DATE NOT NULL,
    level_id INT NOT NULL,
    notes VARCHAR(1000),

    CONSTRAINT FK_DailyAssessment_Child
        FOREIGN KEY (child_id, nursery_id)
        REFERENCES Child(child_id, nursery_id),

    CONSTRAINT FK_DailyAssessment_Level
        FOREIGN KEY (level_id, nursery_id)
        REFERENCES AssessmentLevel(level_id, nursery_id),

    CONSTRAINT FK_DailyAssessment_Subject
        FOREIGN KEY (subject_id)
        REFERENCES Subject(subject_id)
);
GO


-- =============================================
-- 3. MonthlyAssessment
-- Child 1 : N MonthlyAssessment
-- Subject 1 : N MonthlyAssessment
-- =============================================

CREATE TABLE MonthlyAssessment (
    monthly_assessment_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    child_id INT NOT NULL,
    subject_id INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    level_id INT NOT NULL,
    notes VARCHAR(1000),

    CONSTRAINT FK_MonthlyAssessment_Child
        FOREIGN KEY (child_id, nursery_id)
        REFERENCES Child(child_id, nursery_id),

    CONSTRAINT FK_MonthlyAssessment_Level
        FOREIGN KEY (level_id, nursery_id)
        REFERENCES AssessmentLevel(level_id, nursery_id),

    CONSTRAINT FK_MonthlyAssessment_Subject
        FOREIGN KEY (subject_id)
        REFERENCES Subject(subject_id)
);
GO


-- =============================================
-- 4. Media
-- Child 1 : N Media
-- =============================================

CREATE TABLE Media (
    media_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_type VARCHAR(50),
    uploaded_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_Media_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id)
);
GO

-- =============================================
-- 5. MediaConsent
-- A guardian of the child allows (or later withdraws) photos and videos.
-- No Media row may be added without an active consent (enforced by the
-- upload procedure). Withdrawing sets revoked_at; the row is kept.
-- The composite key guarantees the guardian really is this child's guardian.
-- =============================================

CREATE TABLE MediaConsent (
    consent_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT NOT NULL,
    given_by_guardian_id INT NOT NULL,
    scope VARCHAR(20) NOT NULL DEFAULT 'ClassOnly',
    given_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    revoked_at DATETIME2 NULL,

    CONSTRAINT FK_MediaConsent_ChildGuardian
        FOREIGN KEY (child_id, given_by_guardian_id)
        REFERENCES ChildGuardian(child_id, guardian_id)
);
GO

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
-- 2. DailyAssessment
-- Child 1 : N DailyAssessment
-- Subject 1 : N DailyAssessment
-- =============================================

CREATE TABLE DailyAssessment (
    daily_assessment_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT NOT NULL,
    subject_id INT NOT NULL,
    assessment_date DATE NOT NULL,
    level VARCHAR(50),
    notes VARCHAR(1000),

    CONSTRAINT FK_DailyAssessment_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

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
    child_id INT NOT NULL,
    subject_id INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    level VARCHAR(50),
    notes VARCHAR(1000),

    CONSTRAINT FK_MonthlyAssessment_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

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
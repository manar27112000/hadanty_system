USE Hadanty;
GO

-- =============================================
-- 1. Holiday
-- Branch 1 : N Holiday
-- =============================================

CREATE TABLE Holiday (
    holiday_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    description VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_Holiday_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id)
);
GO


-- =============================================
-- 2. WorkingHour
-- Branch 1 : N WorkingHour
-- =============================================

CREATE TABLE WorkingHour (
    working_hour_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    day_of_week INT NOT NULL,
    open_time TIME,
    close_time TIME,
    is_working_day BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_WorkingHour_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id),

    CONSTRAINT UQ_WorkingHour_Branch_Day
        UNIQUE (branch_id, day_of_week)
);
GO


-- =============================================
-- 3. NurserySetting
-- Nursery 1 : N NurserySetting
-- =============================================

CREATE TABLE NurserySetting (
    setting_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    setting_key VARCHAR(100) NOT NULL,
    setting_value VARCHAR(1000),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_NurserySetting_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id),

    CONSTRAINT UQ_NurserySetting_Key
        UNIQUE (nursery_id, setting_key)
);
GO


-- =============================================
-- 4. BranchSetting
-- Branch 1 : N BranchSetting
-- =============================================

CREATE TABLE BranchSetting (
    branch_setting_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    setting_key VARCHAR(100) NOT NULL,
    setting_value VARCHAR(1000),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_BranchSetting_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id),

    CONSTRAINT UQ_BranchSetting_Key
        UNIQUE (branch_id, setting_key)
);
GO


-- =============================================
-- 5. AuditLog
-- UserAccount 1 : N AuditLog
-- account_id NULL = the System itself (e.g. Auto Mark Absent)
-- =============================================

CREATE TABLE AuditLog (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    account_id INT NULL,
    action VARCHAR(100) NOT NULL,
    entity_name VARCHAR(100) NOT NULL,
    entity_id INT NOT NULL,
    old_value VARCHAR(MAX),
    new_value VARCHAR(MAX),
    action_date DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    ip_address VARCHAR(50),

    CONSTRAINT FK_AuditLog_Account
        FOREIGN KEY (account_id)
        REFERENCES UserAccount(account_id)
);
GO
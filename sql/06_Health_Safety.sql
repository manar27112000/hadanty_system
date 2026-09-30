USE Hadanty;
GO

-- =============================================
-- 1. HealthRecord
-- Child 1 : 0..1 HealthRecord
-- =============================================

CREATE TABLE HealthRecord (
    health_record_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT NOT NULL,
    medical_notes VARCHAR(1000),
    emergency_notes VARCHAR(1000),
    updated_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_HealthRecord_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

    CONSTRAINT UQ_HealthRecord_Child
        UNIQUE (child_id)
);
GO


-- =============================================
-- 2. Allergy
-- HealthRecord 1 : N Allergy
-- =============================================

CREATE TABLE Allergy (
    allergy_id INT IDENTITY(1,1) PRIMARY KEY,
    health_record_id INT NOT NULL,
    allergy_name VARCHAR(100) NOT NULL,
    severity VARCHAR(50) NOT NULL,
    notes VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_Allergy_HealthRecord
        FOREIGN KEY (health_record_id)
        REFERENCES HealthRecord(health_record_id)
);
GO


-- =============================================
-- 3. Medication
-- HealthRecord 1 : N Medication
-- =============================================

CREATE TABLE Medication (
    medication_id INT IDENTITY(1,1) PRIMARY KEY,
    health_record_id INT NOT NULL,
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(100),
    start_date DATE,
    end_date DATE,
    instructions VARCHAR(1000),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_Medication_HealthRecord
        FOREIGN KEY (health_record_id)
        REFERENCES HealthRecord(health_record_id)
);
GO


-- =============================================
-- 4. MedicationConsent
-- Medication 1 : 0..1 MedicationConsent
-- =============================================

CREATE TABLE MedicationConsent (
    consent_id INT IDENTITY(1,1) PRIMARY KEY,
    medication_id INT NOT NULL,
    consent_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',

    CONSTRAINT FK_MedicationConsent_Medication
        FOREIGN KEY (medication_id)
        REFERENCES Medication(medication_id),

    CONSTRAINT UQ_MedicationConsent_Medication
        UNIQUE (medication_id)
);
GO


-- =============================================
-- 5. Incident
-- Child 1 : N Incident
-- Staff 1 : N Incident
-- =============================================

CREATE TABLE Incident (
    incident_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT NOT NULL,
    staff_id INT NOT NULL,
    incident_type VARCHAR(100),
    description VARCHAR(1000),
    incident_date DATETIME2 NOT NULL,
    action_taken VARCHAR(1000),
    parent_notified BIT NOT NULL DEFAULT 0,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Incident_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

    CONSTRAINT FK_Incident_Staff
        FOREIGN KEY (staff_id)
        REFERENCES Staff(staff_id)
);
GO
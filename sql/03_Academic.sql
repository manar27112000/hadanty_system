USE Hadanty;
GO

/* =========================================================
   03_Academic.sql
   Academic years, classes, enrollment, class assignment.

   Integrity rule: an Enrollment's child, branch and academic
   year must all belong to the SAME nursery, and a ClassAssignment's
   class must be in the SAME branch as its enrollment. These are
   enforced with composite foreign keys, not left to the application.
   ========================================================= */

-- =============================================
-- 1. AcademicYear
-- =============================================
CREATE TABLE AcademicYear (
    academic_year_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Planned',

    CONSTRAINT FK_AcademicYear_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id),

    CONSTRAINT UQ_AcademicYear_Id_Nursery
        UNIQUE (academic_year_id, nursery_id)
);
GO


-- =============================================
-- 2. Class  (belongs to a Branch)
-- =============================================
CREATE TABLE Class (
    class_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    age_group VARCHAR(100),
    capacity INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_Class_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id),

    CONSTRAINT UQ_Class_Id_Branch
        UNIQUE (class_id, branch_id)
);
GO


-- =============================================
-- 3. ClassStaff
-- Class M : N Staff
-- =============================================
CREATE TABLE ClassStaff (
    class_id INT NOT NULL,
    staff_id INT NOT NULL,

    PRIMARY KEY (class_id, staff_id),

    CONSTRAINT FK_ClassStaff_Class
        FOREIGN KEY (class_id)
        REFERENCES Class(class_id),

    CONSTRAINT FK_ClassStaff_Staff
        FOREIGN KEY (staff_id)
        REFERENCES Staff(staff_id)
);
GO


-- =============================================
-- 4. Enrollment
-- A child can have many enrollments over time.
-- Current enrollment = status 'Active'.
-- =============================================
CREATE TABLE Enrollment (
    enrollment_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    child_id INT NOT NULL,
    academic_year_id INT NOT NULL,
    branch_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    -- Re-enrollment is decided by the guardian: the nursery opens it as 'Pending',
    -- a guardian of THAT child confirms it, then it becomes 'Active'.
    confirmed_by_guardian_id INT NULL,
    confirmed_at DATETIME2 NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    -- fee_plan_id is added in 07_Finance.sql (FeePlan is defined there)

    CONSTRAINT FK_Enrollment_Child
        FOREIGN KEY (child_id, nursery_id)
        REFERENCES Child(child_id, nursery_id),

    CONSTRAINT FK_Enrollment_ConfirmedBy
        FOREIGN KEY (child_id, confirmed_by_guardian_id)
        REFERENCES ChildGuardian(child_id, guardian_id),

    CONSTRAINT FK_Enrollment_AcademicYear
        FOREIGN KEY (academic_year_id, nursery_id)
        REFERENCES AcademicYear(academic_year_id, nursery_id),

    CONSTRAINT FK_Enrollment_Branch
        FOREIGN KEY (branch_id, nursery_id)
        REFERENCES Branch(branch_id, nursery_id),

    -- Targets for child tables that must stay consistent with this row
    CONSTRAINT UQ_Enrollment_Id_Child
        UNIQUE (enrollment_id, child_id),

    CONSTRAINT UQ_Enrollment_Id_Branch
        UNIQUE (enrollment_id, branch_id)
);
GO


-- =============================================
-- 5. ClassAssignment
-- Enrollment 1 : N ClassAssignment  (history of class moves)
-- Current class = status 'Active'.
-- =============================================
CREATE TABLE ClassAssignment (
    assignment_id INT IDENTITY(1,1) PRIMARY KEY,
    enrollment_id INT NOT NULL,
    class_id INT NOT NULL,
    branch_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_ClassAssignment_Enrollment
        FOREIGN KEY (enrollment_id, branch_id)
        REFERENCES Enrollment(enrollment_id, branch_id),

    CONSTRAINT FK_ClassAssignment_Class
        FOREIGN KEY (class_id, branch_id)
        REFERENCES Class(class_id, branch_id)
);
GO


-- =============================================
-- 6. Subject  (platform-wide catalog)
-- =============================================
CREATE TABLE Subject (
    subject_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'Active'
);
GO


-- =============================================
-- 7. Homework
-- =============================================
CREATE TABLE Homework (
    homework_id INT IDENTITY(1,1) PRIMARY KEY,
    class_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    assigned_date DATE,
    due_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Assigned',

    CONSTRAINT FK_Homework_Class
        FOREIGN KEY (class_id)
        REFERENCES Class(class_id)
);
GO


-- =============================================
-- 8. Activity
-- =============================================
CREATE TABLE Activity (
    activity_id INT IDENTITY(1,1) PRIMARY KEY,
    class_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    activity_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Planned',

    CONSTRAINT FK_Activity_Class
        FOREIGN KEY (class_id)
        REFERENCES Class(class_id)
);
GO

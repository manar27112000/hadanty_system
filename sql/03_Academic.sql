USE Hadanty;
GO

-- =============================================
-- 1. AcademicYear
-- =============================================
CREATE TABLE AcademicYear (
    academic_year_id INT PRIMARY KEY,
    nursery_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20),

    CONSTRAINT FK_AcademicYear_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id)
);
GO


-- =============================================
-- 2. Class
-- =============================================
CREATE TABLE Class (
    class_id INT PRIMARY KEY,
    branch_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    age_group VARCHAR(100),
    capacity INT,
    status VARCHAR(20),

    CONSTRAINT FK_Class_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id)
);
GO


-- =============================================
-- 3. Enrollment
-- =============================================
CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    child_id INT NOT NULL,
    academic_year_id INT NOT NULL,
    branch_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status VARCHAR(20),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Enrollment_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

    CONSTRAINT FK_Enrollment_AcademicYear
        FOREIGN KEY (academic_year_id)
        REFERENCES AcademicYear(academic_year_id),

    CONSTRAINT FK_Enrollment_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id)
);
GO


-- =============================================
-- 4. ClassAssignment
-- =============================================
CREATE TABLE ClassAssignment (
    assignment_id INT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    class_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    status VARCHAR(20),

    CONSTRAINT FK_ClassAssignment_Enrollment
        FOREIGN KEY (enrollment_id)
        REFERENCES Enrollment(enrollment_id),

    CONSTRAINT FK_ClassAssignment_Class
        FOREIGN KEY (class_id)
        REFERENCES Class(class_id)
);
GO


-- =============================================
-- 5. Subject
-- =============================================
CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    status VARCHAR(20)
);
GO


-- =============================================
-- 6. Homework
-- =============================================
CREATE TABLE Homework (
    homework_id INT PRIMARY KEY,
    class_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    assigned_date DATE,
    due_date DATE,
    status VARCHAR(20),

    CONSTRAINT FK_Homework_Class
        FOREIGN KEY (class_id)
        REFERENCES Class(class_id)
);
GO


-- =============================================
-- 7. Activity
-- =============================================
CREATE TABLE Activity (
    activity_id INT PRIMARY KEY,
    class_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    activity_date DATE,
    status VARCHAR(20),

    CONSTRAINT FK_Activity_Class
        FOREIGN KEY (class_id)
        REFERENCES Class(class_id)
);
GO










USE Hadanty;
GO

DROP TABLE IF EXISTS Activity;
DROP TABLE IF EXISTS Homework;
DROP TABLE IF EXISTS Subject;
DROP TABLE IF EXISTS ClassAssignment;
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Class;
DROP TABLE IF EXISTS AcademicYear;
GO


USE Hadanty;
GO

SELECT 
    name AS TableName
FROM sys.tables
ORDER BY name;

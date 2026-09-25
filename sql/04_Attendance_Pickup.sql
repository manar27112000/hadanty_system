USE Hadanty;
GO

-- =============================================
-- 1. Attendance
-- =============================================
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    child_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status VARCHAR(20),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Attendance_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id)
);
GO


-- =============================================
-- 2. CheckIn
-- =============================================
CREATE TABLE CheckIn (
    check_in_id INT PRIMARY KEY,
    attendance_id INT NOT NULL,
    check_in_time DATETIME2 NOT NULL,

    CONSTRAINT FK_CheckIn_Attendance
        FOREIGN KEY (attendance_id)
        REFERENCES Attendance(attendance_id)
);
GO


-- =============================================
-- 3. CheckOut
-- =============================================
CREATE TABLE CheckOut (
    check_out_id INT PRIMARY KEY,
    attendance_id INT NOT NULL,
    check_out_time DATETIME2 NOT NULL,

    CONSTRAINT FK_CheckOut_Attendance
        FOREIGN KEY (attendance_id)
        REFERENCES Attendance(attendance_id)
);
GO


-- =============================================
-- 4. AuthorizedPickupPerson
-- =============================================
CREATE TABLE AuthorizedPickupPerson (
    authorized_person_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    relationship_type VARCHAR(50),
    identification_info VARCHAR(255),
    status VARCHAR(20),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO


-- =============================================
-- 5. Pickup
-- =============================================
CREATE TABLE Pickup (
    pickup_id INT PRIMARY KEY,
    child_id INT NOT NULL,
    authorized_person_id INT NOT NULL,
    pickup_person_name VARCHAR(100),
    pickup_type VARCHAR(50),
    pickup_time DATETIME2 NOT NULL,
    status VARCHAR(20),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Pickup_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

    CONSTRAINT FK_Pickup_AuthorizedPerson
        FOREIGN KEY (authorized_person_id)
        REFERENCES AuthorizedPickupPerson(authorized_person_id)
);
GO


-- =============================================
-- 6. PickupApproval
-- =============================================
CREATE TABLE PickupApproval (
    approval_id INT PRIMARY KEY,
    pickup_id INT NOT NULL,
    authorized_person_name VARCHAR(100),
    approval_time DATETIME2 NOT NULL,
    status VARCHAR(20),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_PickupApproval_Pickup
        FOREIGN KEY (pickup_id)
        REFERENCES Pickup(pickup_id)
);
GO
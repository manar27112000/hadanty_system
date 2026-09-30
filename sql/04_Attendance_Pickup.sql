USE Hadanty;
GO

/* =========================================================
   04_Attendance_Pickup.sql
   Attendance status, real check-in/out times, pickup.

   Attendance (Present / Late / Absent) is separate from the
   actual CheckIn and CheckOut times.

   Pickup rule: nobody is allowed automatically, not even a guardian
   (parents may be separated). Every receiver is registered per child
   in ChildAuthorizedPickup. A receiver who is also a guardian points
   to the Guardian row, so name and phone are stored once.
   ========================================================= */

-- =============================================
-- 1. Attendance
-- =============================================
-- Every attendance row belongs to an enrollment, so the branch and
-- (through ClassAssignment dates) the class on that day are never guessed.
-- child_id is kept next to enrollment_id and the composite key below
-- guarantees they always agree.
-- absence_reason is only for status 'Absent' (CK in 11_Constraints.sql).
-- Whether an absence affects fees is a nursery setting (AbsenceAffectsFees).
CREATE TABLE Attendance (
    attendance_id INT IDENTITY(1,1) PRIMARY KEY,
    enrollment_id INT NOT NULL,
    child_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    absence_reason VARCHAR(255) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Attendance_Enrollment
        FOREIGN KEY (enrollment_id, child_id)
        REFERENCES Enrollment(enrollment_id, child_id)
);
GO


-- =============================================
-- 2. CheckIn
-- =============================================
CREATE TABLE CheckIn (
    check_in_id INT IDENTITY(1,1) PRIMARY KEY,
    attendance_id INT NOT NULL,
    check_in_time DATETIME2 NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_CheckIn_Attendance
        FOREIGN KEY (attendance_id)
        REFERENCES Attendance(attendance_id)
);
GO


-- =============================================
-- 3. CheckOut
-- =============================================
CREATE TABLE CheckOut (
    check_out_id INT IDENTITY(1,1) PRIMARY KEY,
    attendance_id INT NOT NULL,
    check_out_time DATETIME2 NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_CheckOut_Attendance
        FOREIGN KEY (attendance_id)
        REFERENCES Attendance(attendance_id)
);
GO


-- =============================================
-- 4. AuthorizedPickupPerson
-- A person who may receive children. Belongs to one nursery.
-- Either a guardian (guardian_id set, name and phone NULL: read them
-- from Guardian) or someone else (name set, guardian_id NULL).
-- CK in 11_Constraints.sql enforces "one or the other".
-- The relationship to a child (Father, Grandmother...) depends on the
-- child, so it lives in ChildAuthorizedPickup.
-- =============================================
CREATE TABLE AuthorizedPickupPerson (
    authorized_person_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    guardian_id INT NULL,
    name VARCHAR(100) NULL,
    phone VARCHAR(20) NULL,
    identification_info VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_AuthorizedPickupPerson_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id),

    -- a guardian pickup person must be a guardian of the SAME nursery
    CONSTRAINT FK_AuthorizedPickupPerson_Guardian
        FOREIGN KEY (guardian_id, nursery_id)
        REFERENCES Guardian(guardian_id, nursery_id)
);
GO


-- =============================================
-- 5. ChildAuthorizedPickup
-- Child M : N AuthorizedPickupPerson
-- =============================================
CREATE TABLE ChildAuthorizedPickup (
    child_id INT NOT NULL,
    authorized_person_id INT NOT NULL,
    relationship_type VARCHAR(50) NOT NULL,

    PRIMARY KEY (child_id, authorized_person_id),

    CONSTRAINT FK_ChildAuthorizedPickup_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

    CONSTRAINT FK_ChildAuthorizedPickup_Person
        FOREIGN KEY (authorized_person_id)
        REFERENCES AuthorizedPickupPerson(authorized_person_id)
);
GO


-- =============================================
-- 6. BlockedPickupPerson
-- People who must never receive this child (court order, separation).
-- A blocked person can never be approved for a pickup.
-- Status 'Lifted' keeps the history when a block is removed.
-- =============================================
CREATE TABLE BlockedPickupPerson (
    blocked_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT NOT NULL,
    person_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    identification_info VARCHAR(255) NULL,
    reason VARCHAR(500) NOT NULL,
    blocked_by_staff_id INT NOT NULL,
    blocked_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    lifted_at DATETIME2 NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_BlockedPickupPerson_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

    CONSTRAINT FK_BlockedPickupPerson_Staff
        FOREIGN KEY (blocked_by_staff_id)
        REFERENCES Staff(staff_id)
);
GO


-- =============================================
-- 7. Pickup
-- The receiver is stored exactly once:
--   on the authorized list  -> authorized_person_id (name lives in AuthorizedPickupPerson or Guardian)
--   exception pickup        -> pickup_person_name only (and PickupApproval is required)
-- The CHECK in 11_Constraints.sql enforces "one or the other, never both".
-- =============================================
CREATE TABLE Pickup (
    pickup_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT NOT NULL,
    authorized_person_id INT NULL,
    pickup_person_name VARCHAR(100) NULL,
    pickup_type VARCHAR(50) NOT NULL,
    pickup_time DATETIME2 NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
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
-- 8. PickupApproval
-- Who approved an early or exception pickup.
-- =============================================
CREATE TABLE PickupApproval (
    approval_id INT IDENTITY(1,1) PRIMARY KEY,
    pickup_id INT NOT NULL,
    approved_by_staff_id INT NOT NULL,
    approval_time DATETIME2 NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_PickupApproval_Pickup
        FOREIGN KEY (pickup_id)
        REFERENCES Pickup(pickup_id),

    CONSTRAINT FK_PickupApproval_Staff
        FOREIGN KEY (approved_by_staff_id)
        REFERENCES Staff(staff_id)
);
GO


-- =============================================
-- 9. PickupCode
-- A short-lived code the guardian creates in the app for one authorized
-- person to show at pickup. Only a hash is stored, never the code.
-- The composite key guarantees the person is authorized for THAT child.
-- =============================================
CREATE TABLE PickupCode (
    pickup_code_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT NOT NULL,
    authorized_person_id INT NOT NULL,
    created_by_account_id INT NOT NULL,
    code_hash VARCHAR(255) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    expires_at DATETIME2 NOT NULL,
    used_at DATETIME2 NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_PickupCode_ChildPerson
        FOREIGN KEY (child_id, authorized_person_id)
        REFERENCES ChildAuthorizedPickup(child_id, authorized_person_id),

    CONSTRAINT FK_PickupCode_Account
        FOREIGN KEY (created_by_account_id)
        REFERENCES UserAccount(account_id)
);
GO

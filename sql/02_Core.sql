USE Hadanty;
GO

/* =========================================================
   02_Core.sql
   Nursery, Branch, Staff, Guardian, Child, Users, Roles.

   Tenant rule: every nursery-owned row carries nursery_id
   (Child, Guardian, Staff), so one nursery can never see or
   touch another nursery's people.
   Role, Permission, Subject, FeeType and NotificationType are
   platform-wide catalogs shared by all nurseries.
   ========================================================= */

-- =============================================
-- 1. Nursery
-- =============================================
CREATE TABLE Nursery (
    nursery_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    owner_name VARCHAR(100),
    commercial_registration_no VARCHAR(50),
    tax_number VARCHAR(50),
    address VARCHAR(255),
    phone VARCHAR(20),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO


-- =============================================
-- 2. Branch
-- =============================================
CREATE TABLE Branch (
    branch_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Branch_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id),

    CONSTRAINT UQ_Branch_Nursery_Name
        UNIQUE (nursery_id, name),

    -- Lets other tables prove "this branch belongs to this nursery"
    CONSTRAINT UQ_Branch_Id_Nursery
        UNIQUE (branch_id, nursery_id)
);
GO


-- =============================================
-- 3. Staff
-- =============================================
CREATE TABLE Staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    national_id VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(254),
    specialization VARCHAR(100),
    qualification VARCHAR(100),
    hire_date DATE,
    employment_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Staff_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id)
);
GO


-- =============================================
-- 4. Guardian
-- =============================================
CREATE TABLE Guardian (
    guardian_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(254),
    address VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Guardian_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id)
);
GO


-- =============================================
-- 5. UserAccount
-- Owned by a Staff member OR a Guardian, never both.
-- =============================================
CREATE TABLE UserAccount (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    account_type VARCHAR(20) NOT NULL,
    staff_id INT NULL,
    guardian_id INT NULL,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    is_active BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    last_login_at DATETIME2 NULL,

    CONSTRAINT FK_UserAccount_Staff
        FOREIGN KEY (staff_id)
        REFERENCES Staff(staff_id),

    CONSTRAINT FK_UserAccount_Guardian
        FOREIGN KEY (guardian_id)
        REFERENCES Guardian(guardian_id),

    CONSTRAINT CK_UserAccount_Owner
        CHECK (
            (account_type = 'Staff'    AND staff_id IS NOT NULL AND guardian_id IS NULL)
            OR
            (account_type = 'Guardian' AND guardian_id IS NOT NULL AND staff_id IS NULL)
        )
);
GO


-- =============================================
-- 6. Role  (platform-wide catalog)
-- =============================================
CREATE TABLE Role (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'Active'
);
GO


-- =============================================
-- 7. Permission  (platform-wide catalog)
-- =============================================
CREATE TABLE Permission (
    permission_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    module VARCHAR(100)
);
GO


-- =============================================
-- 8. StaffBranch
-- Staff M : N Branch
-- =============================================
CREATE TABLE StaffBranch (
    staff_id INT NOT NULL,
    branch_id INT NOT NULL,

    PRIMARY KEY (staff_id, branch_id),

    CONSTRAINT FK_StaffBranch_Staff
        FOREIGN KEY (staff_id)
        REFERENCES Staff(staff_id),

    CONSTRAINT FK_StaffBranch_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id)
);
GO


-- =============================================
-- 9. AccountRole
-- UserAccount M : N Role, per branch
-- =============================================
CREATE TABLE AccountRole (
    account_id INT NOT NULL,
    role_id INT NOT NULL,
    branch_id INT NOT NULL,

    PRIMARY KEY (account_id, role_id, branch_id),

    CONSTRAINT FK_AccountRole_Account
        FOREIGN KEY (account_id)
        REFERENCES UserAccount(account_id),

    CONSTRAINT FK_AccountRole_Role
        FOREIGN KEY (role_id)
        REFERENCES Role(role_id),

    CONSTRAINT FK_AccountRole_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id)
);
GO


-- =============================================
-- 10. RolePermission
-- Role M : N Permission
-- =============================================
CREATE TABLE RolePermission (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,

    PRIMARY KEY (role_id, permission_id),

    CONSTRAINT FK_RolePermission_Role
        FOREIGN KEY (role_id)
        REFERENCES Role(role_id),

    CONSTRAINT FK_RolePermission_Permission
        FOREIGN KEY (permission_id)
        REFERENCES Permission(permission_id)
);
GO


-- =============================================
-- 11. Child
-- =============================================
CREATE TABLE Child (
    child_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    national_id VARCHAR(50),
    date_of_birth DATE NOT NULL,
    gender VARCHAR(20),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    updated_at DATETIME2 NULL,

    CONSTRAINT FK_Child_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id),

    CONSTRAINT UQ_Child_Id_Nursery
        UNIQUE (child_id, nursery_id)
);
GO


-- =============================================
-- 12. ChildGuardian
-- Child M : N Guardian
-- =============================================
CREATE TABLE ChildGuardian (
    child_id INT NOT NULL,
    guardian_id INT NOT NULL,

    PRIMARY KEY (child_id, guardian_id),

    CONSTRAINT FK_ChildGuardian_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

    CONSTRAINT FK_ChildGuardian_Guardian
        FOREIGN KEY (guardian_id)
        REFERENCES Guardian(guardian_id)
);
GO

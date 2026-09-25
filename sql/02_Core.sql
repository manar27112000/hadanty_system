USE Hadanty;
GO

-- =============================================
-- 1. Nursery
-- =============================================
CREATE TABLE Nursery (
    nursery_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    owner_name VARCHAR(100),
    commercial_registration_no VARCHAR(50) UNIQUE,
    tax_number VARCHAR(50) UNIQUE,
    address VARCHAR(255),
    phone VARCHAR(20),
    status VARCHAR(20),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO


-- =============================================
-- 2. Branch
-- =============================================
CREATE TABLE Branch (
    branch_id INT PRIMARY KEY,
    nursery_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    status VARCHAR(20),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Branch_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id),

    CONSTRAINT UQ_Branch_Nursery_Name
        UNIQUE (nursery_id, name)
);
GO


-- =============================================
-- 3. Staff
-- =============================================
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    national_id VARCHAR(50) UNIQUE,
    phone VARCHAR(20),
    email VARCHAR(254),
    specialization VARCHAR(100),
    qualification VARCHAR(100),
    hire_date DATE,
    employment_status VARCHAR(20),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO


-- =============================================
-- 4. Guardian
-- =============================================
CREATE TABLE Guardian (
    guardian_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(254),
    address VARCHAR(255),
    status VARCHAR(20),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO


-- =============================================
-- 5. UserAccount
-- =============================================
CREATE TABLE UserAccount (
    account_id INT PRIMARY KEY,
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
            (staff_id IS NOT NULL AND guardian_id IS NULL)
            OR
            (staff_id IS NULL AND guardian_id IS NOT NULL)
        )
);
GO


-- =============================================
-- 6. Role
-- =============================================
CREATE TABLE Role (
    role_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    status VARCHAR(20)
);
GO


-- =============================================
-- 7. Permission
-- =============================================
CREATE TABLE Permission (
    permission_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    module VARCHAR(100)
);
GO


-- =============================================
-- 8. StaffBranch
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
USE Hadanty;
GO

-- =============================================
-- 1. Event
-- Branch 1 : N Event
-- =============================================

CREATE TABLE Event (
    event_id INT PRIMARY KEY,
    branch_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    event_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    location VARCHAR(255),
    cost DECIMAL(12,2),
    status VARCHAR(20),

    CONSTRAINT FK_Event_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id)
);
GO


-- =============================================
-- 2. EventRegistration
-- Event 1 : N EventRegistration
-- Child 1 : N EventRegistration
-- =============================================

CREATE TABLE EventRegistration (
    registration_id INT PRIMARY KEY,
    event_id INT NOT NULL,
    child_id INT NOT NULL,
    confirmation_status VARCHAR(50),
    registered_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_EventRegistration_Event
        FOREIGN KEY (event_id)
        REFERENCES Event(event_id),

    CONSTRAINT FK_EventRegistration_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

    CONSTRAINT UQ_EventRegistration_Event_Child
        UNIQUE (event_id, child_id)
);
GO


-- =============================================
-- 3. EventAttendance
-- EventRegistration 1 : 0..1 EventAttendance
-- =============================================

CREATE TABLE EventAttendance (
    event_attendance_id INT PRIMARY KEY,
    registration_id INT NOT NULL,
    attendance_status VARCHAR(50),
    recorded_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_EventAttendance_Registration
        FOREIGN KEY (registration_id)
        REFERENCES EventRegistration(registration_id),

    CONSTRAINT UQ_EventAttendance_Registration
        UNIQUE (registration_id)
);
GO


-- =============================================
-- 4. NotificationType
-- NotificationType 1 : N Notification
-- =============================================

CREATE TABLE NotificationType (
    notification_type_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    is_enabled BIT NOT NULL DEFAULT 1
);
GO


-- =============================================
-- 5. Notification
-- NotificationType 1 : N Notification
-- =============================================

CREATE TABLE Notification (
    notification_id INT PRIMARY KEY,
    notification_type_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message VARCHAR(1000) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    status VARCHAR(20),

    CONSTRAINT FK_Notification_NotificationType
        FOREIGN KEY (notification_type_id)
        REFERENCES NotificationType(notification_type_id)
);
GO


-- =============================================
-- 6. NotificationDelivery
-- Notification 1 : N NotificationDelivery
-- UserAccount 1 : N NotificationDelivery
-- =============================================

CREATE TABLE NotificationDelivery (
    delivery_id INT PRIMARY KEY,
    notification_id INT NOT NULL,
    account_id INT NOT NULL,
    sent_at DATETIME2,
    delivered_at DATETIME2,
    read_at DATETIME2,
    delivery_status VARCHAR(50),

    CONSTRAINT FK_NotificationDelivery_Notification
        FOREIGN KEY (notification_id)
        REFERENCES Notification(notification_id),

    CONSTRAINT FK_NotificationDelivery_Account
        FOREIGN KEY (account_id)
        REFERENCES UserAccount(account_id),

    CONSTRAINT UQ_NotificationDelivery_Notification_Account
        UNIQUE (notification_id, account_id)
);
GO
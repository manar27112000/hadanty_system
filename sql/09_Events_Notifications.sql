USE Hadanty;
GO

-- =============================================
-- 1. Event
-- Branch 1 : N Event
-- =============================================

CREATE TABLE Event (
    event_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    event_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    location VARCHAR(255),
    cost DECIMAL(12,2),
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',

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
    registration_id INT IDENTITY(1,1) PRIMARY KEY,
    event_id INT NOT NULL,
    child_id INT NOT NULL,
    confirmation_status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    registered_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    -- a paid event is billed through an invoice item (fee type "Activities")
    invoice_item_id INT NULL,

    CONSTRAINT FK_EventRegistration_InvoiceItem
        FOREIGN KEY (invoice_item_id)
        REFERENCES InvoiceItem(invoice_item_id),

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
    event_attendance_id INT IDENTITY(1,1) PRIMARY KEY,
    registration_id INT NOT NULL,
    attendance_status VARCHAR(50) NOT NULL,
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
    notification_type_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    is_enabled BIT NOT NULL DEFAULT 1,
    -- a mandatory type (for example health or safety) cannot be switched off by a guardian
    is_mandatory BIT NOT NULL DEFAULT 0
);
GO


-- =============================================
-- 5. Notification
-- NotificationType 1 : N Notification
-- =============================================

CREATE TABLE Notification (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    notification_type_id INT NOT NULL,
    child_id INT NULL,          -- the child the notification is about, if any
    title VARCHAR(200) NOT NULL,
    message VARCHAR(1000) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    status VARCHAR(20) NOT NULL DEFAULT 'Draft',

    CONSTRAINT FK_Notification_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id),

    CONSTRAINT FK_Notification_NotificationType
        FOREIGN KEY (notification_type_id)
        REFERENCES NotificationType(notification_type_id),

    -- A notification about a child must belong to that child's nursery
    CONSTRAINT FK_Notification_Child
        FOREIGN KEY (child_id, nursery_id)
        REFERENCES Child(child_id, nursery_id)
);
GO


-- =============================================
-- 6. NotificationDelivery
-- Notification 1 : N NotificationDelivery
-- UserAccount 1 : N NotificationDelivery
-- =============================================

CREATE TABLE NotificationDelivery (
    delivery_id INT IDENTITY(1,1) PRIMARY KEY,
    notification_id INT NOT NULL,
    account_id INT NOT NULL,
    channel VARCHAR(20) NOT NULL DEFAULT 'Push',
    sent_at DATETIME2,
    delivered_at DATETIME2,
    read_at DATETIME2,
    delivery_status VARCHAR(50) NOT NULL DEFAULT 'Pending',

    CONSTRAINT FK_NotificationDelivery_Notification
        FOREIGN KEY (notification_id)
        REFERENCES Notification(notification_id),

    CONSTRAINT FK_NotificationDelivery_Account
        FOREIGN KEY (account_id)
        REFERENCES UserAccount(account_id),

    -- the same notification may reach the same person on several channels
    CONSTRAINT UQ_NotificationDelivery_Notification_Account_Channel
        UNIQUE (notification_id, account_id, channel)
);
GO


-- =============================================
-- 7. NotificationTemplate
-- The wording of a notification type per channel and language.
-- =============================================

CREATE TABLE NotificationTemplate (
    template_id INT IDENTITY(1,1) PRIMARY KEY,
    notification_type_id INT NOT NULL,
    channel VARCHAR(20) NOT NULL,
    language VARCHAR(5) NOT NULL DEFAULT 'ar',
    subject VARCHAR(200) NULL,
    body VARCHAR(1000) NOT NULL,
    is_active BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_NotificationTemplate_Type
        FOREIGN KEY (notification_type_id)
        REFERENCES NotificationType(notification_type_id),

    CONSTRAINT UQ_NotificationTemplate_Type_Channel_Language
        UNIQUE (notification_type_id, channel, language)
);
GO


-- =============================================
-- 8. NotificationPreference
-- A user's choice per notification type and channel.
-- No row means the default (enabled). Mandatory types ignore it.
-- =============================================

CREATE TABLE NotificationPreference (
    account_id INT NOT NULL,
    notification_type_id INT NOT NULL,
    channel VARCHAR(20) NOT NULL,
    is_enabled BIT NOT NULL,

    PRIMARY KEY (account_id, notification_type_id, channel),

    CONSTRAINT FK_NotificationPreference_Account
        FOREIGN KEY (account_id)
        REFERENCES UserAccount(account_id),

    CONSTRAINT FK_NotificationPreference_Type
        FOREIGN KEY (notification_type_id)
        REFERENCES NotificationType(notification_type_id)
);
GO
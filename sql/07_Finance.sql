USE Hadanty;
GO

-- =============================================
-- 1. FeeType
-- =============================================

CREATE TABLE FeeType (
    fee_type_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'Active'
);
GO


-- =============================================
-- 1b. FeePlan
-- A named price list of a nursery (for example "Sunshine monthly").
-- An enrollment points to the plan it is billed by.
-- =============================================

CREATE TABLE FeePlan (
    fee_plan_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    billing_cycle VARCHAR(20) NOT NULL DEFAULT 'Monthly',
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_FeePlan_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id),

    CONSTRAINT UQ_FeePlan_Nursery_Name
        UNIQUE (nursery_id, name),

    CONSTRAINT UQ_FeePlan_Id_Nursery
        UNIQUE (fee_plan_id, nursery_id)
);
GO


-- =============================================
-- 1c. FeePlanItem
-- What a plan charges each month: one row per fee type.
-- =============================================

CREATE TABLE FeePlanItem (
    fee_plan_item_id INT IDENTITY(1,1) PRIMARY KEY,
    fee_plan_id INT NOT NULL,
    fee_type_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_FeePlanItem_Plan
        FOREIGN KEY (fee_plan_id)
        REFERENCES FeePlan(fee_plan_id),

    CONSTRAINT FK_FeePlanItem_FeeType
        FOREIGN KEY (fee_type_id)
        REFERENCES FeeType(fee_type_id),

    CONSTRAINT UQ_FeePlanItem_Plan_FeeType
        UNIQUE (fee_plan_id, fee_type_id)
);
GO


-- =============================================
-- 1d. Enrollment.fee_plan_id
-- (Enrollment is created in 03_Academic.sql, before FeePlan exists.)
-- The composite key keeps the plan inside the enrollment's own nursery.
-- =============================================

ALTER TABLE Enrollment ADD fee_plan_id INT NULL;
GO

ALTER TABLE Enrollment
ADD CONSTRAINT FK_Enrollment_FeePlan
    FOREIGN KEY (fee_plan_id, nursery_id)
    REFERENCES FeePlan(fee_plan_id, nursery_id);
GO


-- =============================================
-- 1e. BillingRun
-- One row per nursery per month when monthly invoices are generated.
-- account NULL = started by the System (the scheduled job).
-- Together with the unique index on Invoice(enrollment, period) this
-- makes it impossible to bill the same child twice for the same month.
-- =============================================

CREATE TABLE BillingRun (
    billing_run_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    billing_period DATE NOT NULL,          -- first day of the month billed
    status VARCHAR(20) NOT NULL DEFAULT 'Running',
    started_by_account_id INT NULL,
    started_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    finished_at DATETIME2 NULL,
    invoices_created INT NOT NULL DEFAULT 0,

    CONSTRAINT FK_BillingRun_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id),

    CONSTRAINT FK_BillingRun_Account
        FOREIGN KEY (started_by_account_id)
        REFERENCES UserAccount(account_id),

    CONSTRAINT UQ_BillingRun_Nursery_Period
        UNIQUE (nursery_id, billing_period)
);
GO


-- =============================================
-- 2. Invoice
-- Enrollment 1 : N Invoice (child + enrollment always agree)
--
-- Amounts (approved rule):
--   Item.total_amount    = quantity * unit_amount - item discounts
--   Invoice.total_amount = SUM(Item.total_amount) - invoice-level discounts
--   Invoice.discount_total = item discounts + invoice-level discounts
-- A given discount is applied at ONE level only (invoice OR item).
--
-- billing_run_id / billing_period are filled for automatic monthly
-- invoices and NULL for manual ones (registration fee, extras).
-- =============================================

CREATE TABLE Invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    enrollment_id INT NOT NULL,
    child_id INT NOT NULL,
    billing_run_id INT NULL,
    billing_period DATE NULL,
    invoice_date DATE NOT NULL,
    due_date DATE,
    discount_total DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Invoice_Enrollment
        FOREIGN KEY (enrollment_id, child_id)
        REFERENCES Enrollment(enrollment_id, child_id),

    CONSTRAINT FK_Invoice_BillingRun
        FOREIGN KEY (billing_run_id)
        REFERENCES BillingRun(billing_run_id)
);
GO


-- =============================================
-- 3. InvoiceItem
-- Invoice 1 : N InvoiceItem
-- FeeType 1 : N InvoiceItem
-- =============================================

CREATE TABLE InvoiceItem (
    invoice_item_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id INT NOT NULL,
    fee_type_id INT NOT NULL,
    description VARCHAR(255),
    quantity INT NOT NULL DEFAULT 1,
    unit_amount DECIMAL(12,2) NOT NULL,
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_InvoiceItem_Invoice
        FOREIGN KEY (invoice_id)
        REFERENCES Invoice(invoice_id),

    CONSTRAINT FK_InvoiceItem_FeeType
        FOREIGN KEY (fee_type_id)
        REFERENCES FeeType(fee_type_id)
);
GO


-- =============================================
-- 4. Discount
-- =============================================

CREATE TABLE Discount (
    discount_id INT IDENTITY(1,1) PRIMARY KEY,
    nursery_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    discount_type VARCHAR(20) NOT NULL,
    value DECIMAL(12,2) NOT NULL,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_Discount_Nursery
        FOREIGN KEY (nursery_id)
        REFERENCES Nursery(nursery_id)
);
GO


-- =============================================
-- 5. InvoiceDiscount
-- Invoice M : N Discount
-- =============================================

CREATE TABLE InvoiceDiscount (
    invoice_discount_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id INT NOT NULL,
    discount_id INT NOT NULL,
    discount_amount DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_InvoiceDiscount_Invoice
        FOREIGN KEY (invoice_id)
        REFERENCES Invoice(invoice_id),

    CONSTRAINT FK_InvoiceDiscount_Discount
        FOREIGN KEY (discount_id)
        REFERENCES Discount(discount_id)
);
GO


-- =============================================
-- 6. InvoiceItemDiscount
-- InvoiceItem M : N Discount
-- =============================================

CREATE TABLE InvoiceItemDiscount (
    invoice_item_discount_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_item_id INT NOT NULL,
    discount_id INT NOT NULL,
    discount_amount DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_InvoiceItemDiscount_InvoiceItem
        FOREIGN KEY (invoice_item_id)
        REFERENCES InvoiceItem(invoice_item_id),

    CONSTRAINT FK_InvoiceItemDiscount_Discount
        FOREIGN KEY (discount_id)
        REFERENCES Discount(discount_id)
);
GO


-- =============================================
-- 7. Payment
-- Invoice 1 : N Payment
-- =============================================

CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATETIME2 NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_number VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',

    CONSTRAINT FK_Payment_Invoice
        FOREIGN KEY (invoice_id)
        REFERENCES Invoice(invoice_id)
);
GO


-- =============================================
-- 8. PaymentAttempt
-- Payment 1 : N PaymentAttempt
-- =============================================

CREATE TABLE PaymentAttempt (
    attempt_id INT IDENTITY(1,1) PRIMARY KEY,
    payment_id INT NOT NULL,
    transaction_number VARCHAR(100),
    receipt_file_url VARCHAR(500),
    submitted_at DATETIME2 NOT NULL,
    reviewed_at DATETIME2,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    rejection_reason VARCHAR(500),

    CONSTRAINT FK_PaymentAttempt_Payment
        FOREIGN KEY (payment_id)
        REFERENCES Payment(payment_id)
);
GO


-- =============================================
-- 9. Refund
-- Payment 1 : N Refund
-- =============================================

CREATE TABLE Refund (
    refund_id INT IDENTITY(1,1) PRIMARY KEY,
    payment_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    reason VARCHAR(500),
    refund_date DATETIME2 NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',

    CONSTRAINT FK_Refund_Payment
        FOREIGN KEY (payment_id)
        REFERENCES Payment(payment_id)
);
GO


-- =============================================
-- 10. Receipt
-- Payment 1 : 0..1 Receipt
-- The amount, method and transaction number live only in Payment.
-- A receipt is printed by joining Payment, so the two can never disagree.
-- =============================================

CREATE TABLE Receipt (
    receipt_id INT IDENTITY(1,1) PRIMARY KEY,
    payment_id INT NOT NULL,
    receipt_number VARCHAR(100) NOT NULL,
    issued_at DATETIME2 NOT NULL,

    CONSTRAINT FK_Receipt_Payment
        FOREIGN KEY (payment_id)
        REFERENCES Payment(payment_id),

    CONSTRAINT UQ_Receipt_Payment
        UNIQUE (payment_id),

    CONSTRAINT UQ_Receipt_Number
        UNIQUE (receipt_number)
);
GO
USE Hadanty;
GO

-- =============================================
-- 1. FeeType
-- =============================================

CREATE TABLE FeeType (
    fee_type_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    status VARCHAR(20)
);
GO


-- =============================================
-- 2. Invoice
-- Child 1 : N Invoice
-- =============================================

CREATE TABLE Invoice (
    invoice_id INT PRIMARY KEY,
    child_id INT NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE,
    discount_total DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(20),
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Invoice_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id)
);
GO


-- =============================================
-- 3. InvoiceItem
-- Invoice 1 : N InvoiceItem
-- FeeType 1 : N InvoiceItem
-- =============================================

CREATE TABLE InvoiceItem (
    invoice_item_id INT PRIMARY KEY,
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
    discount_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    discount_type VARCHAR(20) NOT NULL,
    value DECIMAL(12,2) NOT NULL,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20)
);
GO


-- =============================================
-- 5. InvoiceDiscount
-- Invoice M : N Discount
-- =============================================

CREATE TABLE InvoiceDiscount (
    invoice_discount_id INT PRIMARY KEY,
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
    invoice_item_discount_id INT PRIMARY KEY,
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
    payment_id INT PRIMARY KEY,
    invoice_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATETIME2 NOT NULL,
    payment_method VARCHAR(50),
    transaction_number VARCHAR(100),
    status VARCHAR(20),

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
    attempt_id INT PRIMARY KEY,
    payment_id INT NOT NULL,
    transaction_number VARCHAR(100),
    receipt_file_url VARCHAR(500),
    submitted_at DATETIME2 NOT NULL,
    reviewed_at DATETIME2,
    status VARCHAR(20),
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
    refund_id INT PRIMARY KEY,
    payment_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    reason VARCHAR(500),
    refund_date DATETIME2 NOT NULL,
    status VARCHAR(20),

    CONSTRAINT FK_Refund_Payment
        FOREIGN KEY (payment_id)
        REFERENCES Payment(payment_id)
);
GO


-- =============================================
-- 10. Receipt
-- Payment 1 : 0..1 Receipt
-- =============================================

CREATE TABLE Receipt (
    receipt_id INT PRIMARY KEY,
    payment_id INT NOT NULL,
    receipt_number VARCHAR(100) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    issued_at DATETIME2 NOT NULL,
    payment_method VARCHAR(50),
    transaction_number VARCHAR(100),

    CONSTRAINT FK_Receipt_Payment
        FOREIGN KEY (payment_id)
        REFERENCES Payment(payment_id),

    CONSTRAINT UQ_Receipt_Payment
        UNIQUE (payment_id),

    CONSTRAINT UQ_Receipt_Number
        UNIQUE (receipt_number)
);
GO
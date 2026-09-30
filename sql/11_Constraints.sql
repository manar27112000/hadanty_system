USE Hadanty;
GO

/* =========================================================
   11_Constraints.sql
   Constraints only (indexes are in 12_Indexes.sql)
   ========================================================= */


/* =========================================================
   1. Nursery
   ========================================================= */

ALTER TABLE Nursery
ADD CONSTRAINT CK_Nursery_Status
CHECK (status IN ('Active', 'Inactive', 'Suspended'));
GO


/* =========================================================
   2. Branch
   ========================================================= */

ALTER TABLE Branch
ADD CONSTRAINT CK_Branch_Status
CHECK (status IN ('Active', 'Inactive', 'Suspended'));
GO


/* =========================================================
   3. Staff
   ========================================================= */

ALTER TABLE Staff
ADD CONSTRAINT CK_Staff_EmploymentStatus
CHECK (employment_status IN ('Active', 'Inactive', 'Suspended'));
GO


/* =========================================================
   4. Guardian
   ========================================================= */

ALTER TABLE Guardian
ADD CONSTRAINT CK_Guardian_Status
CHECK (status IN ('Active', 'Inactive', 'Suspended'));
GO


/* =========================================================
   5. Role
   ========================================================= */

ALTER TABLE Role
ADD CONSTRAINT UQ_Role_Name
UNIQUE (name);
GO


/* =========================================================
   6. Permission
   ========================================================= */

ALTER TABLE Permission
ADD CONSTRAINT UQ_Permission_Name
UNIQUE (name);
GO


/* =========================================================
   7. Child
   ========================================================= */

ALTER TABLE Child
ADD CONSTRAINT CK_Child_Gender
CHECK (gender IN ('Male', 'Female'));
GO


/* =========================================================
   8. AcademicYear
   ========================================================= */

ALTER TABLE AcademicYear
ADD CONSTRAINT UQ_AcademicYear_Nursery_Name
UNIQUE (nursery_id, name);
GO

ALTER TABLE AcademicYear
ADD CONSTRAINT CK_AcademicYear_Dates
CHECK (end_date >= start_date);
GO


/* =========================================================
   9. Class
   ========================================================= */

ALTER TABLE Class
ADD CONSTRAINT UQ_Class_Branch_Name
UNIQUE (branch_id, name);
GO

ALTER TABLE Class
ADD CONSTRAINT CK_Class_Capacity
CHECK (capacity >= 0);
GO


/* =========================================================
   10. Enrollment
   ========================================================= */

ALTER TABLE Enrollment
ADD CONSTRAINT UQ_Enrollment_Child_AcademicYear
UNIQUE (child_id, academic_year_id);
GO


/* =========================================================
   11. ClassAssignment
   ========================================================= */

ALTER TABLE ClassAssignment
ADD CONSTRAINT CK_ClassAssignment_Dates
CHECK (
    end_date IS NULL
    OR end_date >= start_date
);
GO


/* =========================================================
   12. Subject
   ========================================================= */

ALTER TABLE Subject
ADD CONSTRAINT UQ_Subject_Name
UNIQUE (name);
GO


/* =========================================================
   13. Homework
   ========================================================= */

ALTER TABLE Homework
ADD CONSTRAINT CK_Homework_Dates
CHECK (
    due_date IS NULL
    OR assigned_date IS NULL
    OR due_date >= assigned_date
);
GO


/* =========================================================
   14. Attendance
   ========================================================= */

ALTER TABLE Attendance
ADD CONSTRAINT UQ_Attendance_Child_Date
UNIQUE (child_id, attendance_date);
GO


/* =========================================================
   15. CheckIn
   ========================================================= */

ALTER TABLE CheckIn
ADD CONSTRAINT UQ_CheckIn_Attendance
UNIQUE (attendance_id);
GO


/* =========================================================
   16. CheckOut
   ========================================================= */

ALTER TABLE CheckOut
ADD CONSTRAINT UQ_CheckOut_Attendance
UNIQUE (attendance_id);
GO


/* =========================================================
   17. PickupApproval
   ========================================================= */

ALTER TABLE PickupApproval
ADD CONSTRAINT UQ_PickupApproval_Pickup
UNIQUE (pickup_id);
GO


/* =========================================================
   18. DailyReport
   ========================================================= */

ALTER TABLE DailyReport
ADD CONSTRAINT UQ_DailyReport_Child_Date
UNIQUE (child_id, report_date);
GO


/* =========================================================
   19. DailyAssessment
   ========================================================= */

ALTER TABLE DailyAssessment
ADD CONSTRAINT UQ_DailyAssessment_Child_Subject_Date
UNIQUE (
    child_id,
    subject_id,
    assessment_date
);
GO


/* =========================================================
   20. MonthlyAssessment
   ========================================================= */

ALTER TABLE MonthlyAssessment
ADD CONSTRAINT UQ_MonthlyAssessment_Child_Subject_Month_Year
UNIQUE (
    child_id,
    subject_id,
    month,
    year
);
GO

ALTER TABLE MonthlyAssessment
ADD CONSTRAINT CK_MonthlyAssessment_Month
CHECK (month BETWEEN 1 AND 12);
GO


/* =========================================================
   21. HealthRecord
   =========================================================
   Already has UNIQUE(child_id)
   No additional constraint needed.
   */


/* =========================================================
   22. Medication
   ========================================================= */

ALTER TABLE Medication
ADD CONSTRAINT CK_Medication_Dates
CHECK (
    end_date IS NULL
    OR start_date IS NULL
    OR end_date >= start_date
);
GO


/* =========================================================
   23. MedicationConsent
   =========================================================
   Already has UNIQUE(medication_id)
   No additional constraint needed.
   */


/* =========================================================
   24. FeeType
   ========================================================= */

ALTER TABLE FeeType
ADD CONSTRAINT UQ_FeeType_Name
UNIQUE (name);
GO


/* =========================================================
   25. Invoice
   ========================================================= */

ALTER TABLE Invoice
ADD CONSTRAINT CK_Invoice_DueDate
CHECK (
    due_date IS NULL
    OR due_date >= invoice_date
);
GO

ALTER TABLE Invoice
ADD CONSTRAINT CK_Invoice_DiscountTotal
CHECK (discount_total >= 0);
GO

ALTER TABLE Invoice
ADD CONSTRAINT CK_Invoice_TotalAmount
CHECK (total_amount >= 0);
GO


/* =========================================================
   26. InvoiceItem
   ========================================================= */

ALTER TABLE InvoiceItem
ADD CONSTRAINT CK_InvoiceItem_Quantity
CHECK (quantity > 0);
GO

ALTER TABLE InvoiceItem
ADD CONSTRAINT CK_InvoiceItem_UnitAmount
CHECK (unit_amount >= 0);
GO

ALTER TABLE InvoiceItem
ADD CONSTRAINT CK_InvoiceItem_DiscountAmount
CHECK (discount_amount >= 0);
GO

ALTER TABLE InvoiceItem
ADD CONSTRAINT CK_InvoiceItem_TotalAmount
CHECK (total_amount >= 0);
GO


/* =========================================================
   27. Discount
   ========================================================= */

ALTER TABLE Discount
ADD CONSTRAINT CK_Discount_Value
CHECK (value >= 0);
GO

ALTER TABLE Discount
ADD CONSTRAINT CK_Discount_Dates
CHECK (
    end_date IS NULL
    OR start_date IS NULL
    OR end_date >= start_date
);
GO


/* =========================================================
   28. InvoiceDiscount
   ========================================================= */

ALTER TABLE InvoiceDiscount
ADD CONSTRAINT UQ_InvoiceDiscount_Invoice_Discount
UNIQUE (invoice_id, discount_id);
GO

ALTER TABLE InvoiceDiscount
ADD CONSTRAINT CK_InvoiceDiscount_Amount
CHECK (discount_amount >= 0);
GO


/* =========================================================
   29. InvoiceItemDiscount
   ========================================================= */

ALTER TABLE InvoiceItemDiscount
ADD CONSTRAINT UQ_InvoiceItemDiscount_Item_Discount
UNIQUE (invoice_item_id, discount_id);
GO

ALTER TABLE InvoiceItemDiscount
ADD CONSTRAINT CK_InvoiceItemDiscount_Amount
CHECK (discount_amount >= 0);
GO


/* =========================================================
   30. Payment
   ========================================================= */

ALTER TABLE Payment
ADD CONSTRAINT CK_Payment_Amount
CHECK (amount > 0);
GO


/* =========================================================
   31. Refund
   ========================================================= */

ALTER TABLE Refund
ADD CONSTRAINT CK_Refund_Amount
CHECK (amount > 0);
GO


/* =========================================================
   32. Receipt
   ========================================================= */

ALTER TABLE Receipt
ADD CONSTRAINT CK_Receipt_Amount
CHECK (amount > 0);
GO


/* =========================================================
   33. Bus
   ========================================================= */

ALTER TABLE Bus
ADD CONSTRAINT CK_Bus_Capacity
CHECK (capacity > 0);
GO


/* =========================================================
   34. TransportStop
   ========================================================= */

ALTER TABLE TransportStop
ADD CONSTRAINT CK_TransportStop_Sequence
CHECK (sequence_no > 0);
GO


/* =========================================================
   35. TransportTrip
   ========================================================= */

ALTER TABLE TransportTrip
ADD CONSTRAINT CK_TransportTrip_Times
CHECK (
    arrival_time IS NULL
    OR start_time IS NULL
    OR arrival_time >= start_time
);
GO


/* =========================================================
   36. TripChild
   ========================================================= */

ALTER TABLE TripChild
ADD CONSTRAINT CK_TripChild_Times
CHECK (
    (
        boarding_time IS NULL
        OR arrival_time IS NULL
        OR arrival_time >= boarding_time
    )
    AND
    (
        arrival_time IS NULL
        OR pickup_time IS NULL
        OR pickup_time >= arrival_time
    )
);
GO


/* =========================================================
   37. ChildTransportStop
   ========================================================= */

ALTER TABLE ChildTransportStop
ADD CONSTRAINT CK_ChildTransportStop_Dates
CHECK (
    end_date IS NULL
    OR start_date IS NULL
    OR end_date >= start_date
);
GO


/* =========================================================
   38. Event
   ========================================================= */

ALTER TABLE Event
ADD CONSTRAINT CK_Event_Times
CHECK (
    end_time IS NULL
    OR start_time IS NULL
    OR end_time >= start_time
);
GO

ALTER TABLE Event
ADD CONSTRAINT CK_Event_Cost
CHECK (
    cost IS NULL
    OR cost >= 0
);
GO


/* =========================================================
   39. NotificationDelivery
   ========================================================= */

ALTER TABLE NotificationDelivery
ADD CONSTRAINT CK_NotificationDelivery_Times
CHECK (
    (
        delivered_at IS NULL
        OR sent_at IS NULL
        OR delivered_at >= sent_at
    )
    AND
    (
        read_at IS NULL
        OR delivered_at IS NULL
        OR read_at >= delivered_at
    )
);
GO

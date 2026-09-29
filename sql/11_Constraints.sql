USE Hadanty;
GO

/* =========================================================
   11_Constraints.sql
   Constraints 
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
ADD CONSTRAINT UQ_Branch_Nursery_Name
UNIQUE (nursery_id, name);
GO

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
   18. DailyAssessment
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
   19. MonthlyAssessment
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
   20. HealthRecord
   =========================================================
   Already has UNIQUE(child_id)
   No additional constraint needed.
   */


/* =========================================================
   21. Medication
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
   22. MedicationConsent
   =========================================================
   Already has UNIQUE(medication_id)
   No additional constraint needed.
   */


/* =========================================================
   23. FeeType
   ========================================================= */

ALTER TABLE FeeType
ADD CONSTRAINT UQ_FeeType_Name
UNIQUE (name);
GO


/* =========================================================
   24. Invoice
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
   25. InvoiceItem
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
   26. Discount
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
   27. InvoiceDiscount
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
   28. InvoiceItemDiscount
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
   29. Payment
   ========================================================= */

ALTER TABLE Payment
ADD CONSTRAINT CK_Payment_Amount
CHECK (amount > 0);
GO


/* =========================================================
   30. Refund
   ========================================================= */

ALTER TABLE Refund
ADD CONSTRAINT CK_Refund_Amount
CHECK (amount > 0);
GO


/* =========================================================
   31. Receipt
   ========================================================= */

ALTER TABLE Receipt
ADD CONSTRAINT CK_Receipt_Amount
CHECK (amount > 0);
GO


/* =========================================================
   32. Bus
   ========================================================= */

ALTER TABLE Bus
ADD CONSTRAINT CK_Bus_Capacity
CHECK (capacity > 0);
GO


/* =========================================================
   33. TransportStop
   ========================================================= */

ALTER TABLE TransportStop
ADD CONSTRAINT CK_TransportStop_Sequence
CHECK (sequence_no > 0);
GO


/* =========================================================
   34. TransportTrip
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
   35. TripChild
   ========================================================= */

ALTER TABLE TripChild
ADD CONSTRAINT CK_TripChild_Times
CHECK (
    (boarding_time IS NULL
        OR arrival_time IS NULL
        OR arrival_time >= boarding_time)

    AND

    (arrival_time IS NULL
        OR pickup_time IS NULL
        OR pickup_time >= arrival_time)
);
GO


/* =========================================================
   36. ChildTransportStop
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
   37. Event
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
   38. NotificationDelivery
   ========================================================= */

ALTER TABLE NotificationDelivery
ADD CONSTRAINT CK_NotificationDelivery_Times
CHECK (
    (delivered_at IS NULL
        OR sent_at IS NULL
        OR delivered_at >= sent_at)

    AND

    (read_at IS NULL
        OR delivered_at IS NULL
        OR read_at >= delivered_at)
);
GO


/* =========================================================
   39. Holiday
   ========================================================= */

ALTER TABLE Holiday
ADD CONSTRAINT CK_Holiday_Dates
CHECK (end_date >= start_date);
GO


/* =========================================================
   40. WorkingHour
   ========================================================= */

ALTER TABLE WorkingHour
ADD CONSTRAINT CK_WorkingHour_DayOfWeek
CHECK (day_of_week BETWEEN 1 AND 7);
GO

ALTER TABLE WorkingHour
ADD CONSTRAINT CK_WorkingHour_Times
CHECK (
    is_working_day = 0
    OR open_time IS NULL
    OR close_time IS NULL
    OR close_time > open_time
);
GO


/* =========================================================
   INDEXES
   ========================================================= */


/* =========================================================
   41. ChildGuardian
   ========================================================= */

CREATE INDEX IX_ChildGuardian_Guardian
ON ChildGuardian (guardian_id);
GO


/* =========================================================
   42. StaffBranch
   ========================================================= */

CREATE INDEX IX_StaffBranch_Branch
ON StaffBranch (branch_id);
GO


/* =========================================================
   43. AccountRole
   ========================================================= */

CREATE INDEX IX_AccountRole_Role_Branch
ON AccountRole (role_id, branch_id);
GO


/* =========================================================
   44. RolePermission
   ========================================================= */

CREATE INDEX IX_RolePermission_Permission
ON RolePermission (permission_id);
GO


/* =========================================================
   45. ClassStaff
   ========================================================= */

CREATE INDEX IX_ClassStaff_Staff
ON ClassStaff (staff_id);
GO


/* =========================================================
   46. ClassAssignment
   ========================================================= */

CREATE INDEX IX_ClassAssignment_Class
ON ClassAssignment (class_id);
GO


/* =========================================================
   47. Attendance
   ========================================================= */

CREATE INDEX IX_Attendance_Child_Date
ON Attendance (child_id, attendance_date);
GO


/* =========================================================
   48. Pickup
   ========================================================= */

CREATE INDEX IX_Pickup_Child_Time
ON Pickup (child_id, pickup_time);
GO


/* =========================================================
   49. DailyReport
   ========================================================= */

CREATE INDEX IX_DailyReport_Child_Date
ON DailyReport (child_id, report_date);
GO


/* =========================================================
   50. DailyAssessment
   ========================================================= */

CREATE INDEX IX_DailyAssessment_Child_Date
ON DailyAssessment (child_id, assessment_date);
GO


/* =========================================================
   51. MonthlyAssessment
   ========================================================= */

CREATE INDEX IX_MonthlyAssessment_Child_Year_Month
ON MonthlyAssessment (child_id, year, month);
GO


/* =========================================================
   52. Invoice
   ========================================================= */

CREATE INDEX IX_Invoice_Child_Date
ON Invoice (child_id, invoice_date);
GO


/* =========================================================
   53. InvoiceItem
   ========================================================= */

CREATE INDEX IX_InvoiceItem_Invoice
ON InvoiceItem (invoice_id);
GO


/* =========================================================
   54. Payment
   ========================================================= */

CREATE INDEX IX_Payment_Invoice_Date
ON Payment (invoice_id, payment_date);
GO


/* =========================================================
   55. PaymentAttempt
   ========================================================= */

CREATE INDEX IX_PaymentAttempt_Payment
ON PaymentAttempt (payment_id);
GO


/* =========================================================
   56. Refund
   ========================================================= */

CREATE INDEX IX_Refund_Payment
ON Refund (payment_id);
GO


/* =========================================================
   57. TripChild
   ========================================================= */

CREATE INDEX IX_TripChild_Child
ON TripChild (child_id);
GO


/* =========================================================
   58. ChildTransportStop
   ========================================================= */

CREATE INDEX IX_ChildTransportStop_Stop
ON ChildTransportStop (stop_id);
GO


/* =========================================================
   59. EventRegistration
   ========================================================= */

CREATE INDEX IX_EventRegistration_Child
ON EventRegistration (child_id);
GO


/* =========================================================
   60. EventAttendance
   ========================================================= */

CREATE INDEX IX_EventAttendance_Event
ON EventAttendance (event_id);
GO


/* =========================================================
   61. Notification
   ========================================================= */

CREATE INDEX IX_Notification_Account_Date
ON Notification (account_id, created_at);
GO


/* =========================================================
   62. NotificationDelivery
   ========================================================= */

CREATE INDEX IX_NotificationDelivery_Notification
ON NotificationDelivery (notification_id);
GO


/* =========================================================
   63. AuditLog
   ========================================================= */

CREATE INDEX IX_AuditLog_Account_Date
ON AuditLog (account_id, created_at);
GO



USE Hadanty;
GO

-- Filtered unique indexes need QUOTED_IDENTIFIER ON.
-- (SSMS sets it ON by default; sqlcmd does not.)
SET QUOTED_IDENTIFIER ON;
GO

/* =========================================================
   11_Constraints.sql
   Constraints only (indexes are in 12_Indexes.sql)

   Approved status values are listed in Section 99 at the end.
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
CHECK (capacity > 0);
GO


/* =========================================================
   10. Enrollment
   A child may have many enrollments over time (and may move
   between branches in the same year), but only ONE can be
   'Active' at a time. See Section 98.
   ========================================================= */


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

-- Receipt has no amount or method of its own: they come from Payment.
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


/* =========================================================
   98. "Only one ACTIVE" and "unique when present" rules
   These are filtered unique indexes: the rule applies only
   to the rows that match the WHERE clause.
   ========================================================= */

-- A child has at most one current enrollment
CREATE UNIQUE INDEX UX_Enrollment_OneActivePerChild
ON Enrollment (child_id)
WHERE status = 'Active';
GO

-- An enrollment has at most one current class
CREATE UNIQUE INDEX UX_ClassAssignment_OneActivePerEnrollment
ON ClassAssignment (enrollment_id)
WHERE status = 'Active';
GO

-- One login per staff member / per guardian (Staff 1 : 0..1 UserAccount)
CREATE UNIQUE INDEX UX_UserAccount_Staff
ON UserAccount (staff_id)
WHERE staff_id IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_UserAccount_Guardian
ON UserAccount (guardian_id)
WHERE guardian_id IS NOT NULL;
GO

-- National IDs: unique inside a nursery, and optional.
-- (A plain UNIQUE would allow only ONE row with NULL in SQL Server.)
CREATE UNIQUE INDEX UX_Child_Nursery_NationalId
ON Child (nursery_id, national_id)
WHERE national_id IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_Staff_Nursery_NationalId
ON Staff (nursery_id, national_id)
WHERE national_id IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_Nursery_CommercialRegistration
ON Nursery (commercial_registration_no)
WHERE commercial_registration_no IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_Nursery_TaxNumber
ON Nursery (tax_number)
WHERE tax_number IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_Bus_LicensePlate
ON Bus (license_plate)
WHERE license_plate IS NOT NULL;
GO

ALTER TABLE Discount
ADD CONSTRAINT UQ_Discount_Nursery_Name
UNIQUE (nursery_id, name);
GO


/* =========================================================
   99. Approved status values (one CHECK per column)
   Adding a new value is a business decision: update this list
   and the Project Charter first.
   ========================================================= */

ALTER TABLE Child ADD CONSTRAINT CK_Child_Status
CHECK (status IN ('Pending','Active','Inactive','Graduated'));
GO
ALTER TABLE Role ADD CONSTRAINT CK_Role_Status
CHECK (status IN ('Active','Inactive'));
GO
ALTER TABLE UserAccount ADD CONSTRAINT CK_UserAccount_Type
CHECK (account_type IN ('Staff','Guardian'));
GO
ALTER TABLE AcademicYear ADD CONSTRAINT CK_AcademicYear_Status
CHECK (status IN ('Planned','Active','Closed'));
GO
ALTER TABLE Class ADD CONSTRAINT CK_Class_Status
CHECK (status IN ('Active','Inactive'));
GO
ALTER TABLE Enrollment ADD CONSTRAINT CK_Enrollment_Status
CHECK (status IN ('Pending','Active','Transferred','Withdrawn','Completed'));
GO
ALTER TABLE ClassAssignment ADD CONSTRAINT CK_ClassAssignment_Status
CHECK (status IN ('Active','Ended'));
GO
ALTER TABLE Subject ADD CONSTRAINT CK_Subject_Status
CHECK (status IN ('Active','Inactive'));
GO
ALTER TABLE Homework ADD CONSTRAINT CK_Homework_Status
CHECK (status IN ('Assigned','Completed','Cancelled'));
GO
ALTER TABLE Activity ADD CONSTRAINT CK_Activity_Status
CHECK (status IN ('Planned','Completed','Cancelled'));
GO
ALTER TABLE Attendance ADD CONSTRAINT CK_Attendance_Status
CHECK (status IN ('Present','Late','Absent'));
GO
ALTER TABLE AuthorizedPickupPerson ADD CONSTRAINT CK_AuthorizedPickupPerson_Status
CHECK (status IN ('Active','Inactive'));
GO
-- Approval state lives only in PickupApproval; Pickup just says whether it happened.
ALTER TABLE Pickup ADD CONSTRAINT CK_Pickup_Status
CHECK (status IN ('Pending','Completed','Cancelled'));
GO

-- Receiver stored once: authorized person OR a free-text name (exception pickup)
ALTER TABLE Pickup ADD CONSTRAINT CK_Pickup_ReceiverOnce
CHECK (
    (authorized_person_id IS NOT NULL AND pickup_person_name IS NULL)
    OR
    (authorized_person_id IS NULL AND pickup_person_name IS NOT NULL)
);
GO

-- An exception pickup (nobody on the authorized list) must be typed 'Exception'
ALTER TABLE Pickup ADD CONSTRAINT CK_Pickup_ExceptionType
CHECK (authorized_person_id IS NOT NULL OR pickup_type = 'Exception');
GO

-- Item total is derived from its own row: no chance for it to drift
ALTER TABLE InvoiceItem ADD CONSTRAINT CK_InvoiceItem_TotalFormula
CHECK (total_amount = quantity * unit_amount - discount_amount);
GO
ALTER TABLE Pickup ADD CONSTRAINT CK_Pickup_Type
CHECK (pickup_type IN ('Regular','Early','Exception'));
GO
ALTER TABLE PickupApproval ADD CONSTRAINT CK_PickupApproval_Status
CHECK (status IN ('Pending','Approved','Rejected'));
GO
ALTER TABLE Media ADD CONSTRAINT CK_Media_Status
CHECK (status IN ('Active','Deleted'));
GO
ALTER TABLE Allergy ADD CONSTRAINT CK_Allergy_Severity
CHECK (severity IN ('Mild','Moderate','Severe'));
GO
ALTER TABLE Allergy ADD CONSTRAINT CK_Allergy_Status
CHECK (status IN ('Active','Inactive'));
GO
ALTER TABLE Medication ADD CONSTRAINT CK_Medication_Status
CHECK (status IN ('Active','Completed','Stopped'));
GO
ALTER TABLE MedicationConsent ADD CONSTRAINT CK_MedicationConsent_Status
CHECK (status IN ('Pending','Approved','Rejected'));
GO
ALTER TABLE FeeType ADD CONSTRAINT CK_FeeType_Status
CHECK (status IN ('Active','Inactive'));
GO
ALTER TABLE Invoice ADD CONSTRAINT CK_Invoice_Status
CHECK (status IN ('Pending','PartiallyPaid','Paid','Cancelled'));
GO
ALTER TABLE Discount ADD CONSTRAINT CK_Discount_Type
CHECK (discount_type IN ('Percentage','Fixed'));
GO
ALTER TABLE Discount ADD CONSTRAINT CK_Discount_Status
CHECK (status IN ('Active','Inactive'));
GO
-- Version 1 takes cash, e-wallet, Instapay and bank transfer.
-- 'Card' stays allowed but unused until a card gateway is added.
ALTER TABLE Payment ADD CONSTRAINT CK_Payment_Method
CHECK (payment_method IN ('Cash','BankTransfer','Wallet','Instapay','Card'));
GO
ALTER TABLE Payment ADD CONSTRAINT CK_Payment_Status
CHECK (status IN ('Pending','Completed','Failed','Cancelled'));
GO
ALTER TABLE PaymentAttempt ADD CONSTRAINT CK_PaymentAttempt_Status
CHECK (status IN ('Pending','Approved','Rejected'));
GO
ALTER TABLE Refund ADD CONSTRAINT CK_Refund_Status
CHECK (status IN ('Pending','Completed','Rejected'));
GO
ALTER TABLE Bus ADD CONSTRAINT CK_Bus_Status
CHECK (status IN ('Active','Inactive','Maintenance'));
GO
ALTER TABLE Driver ADD CONSTRAINT CK_Driver_Status
CHECK (status IN ('Active','Inactive'));
GO
ALTER TABLE BusSupervisor ADD CONSTRAINT CK_BusSupervisor_Status
CHECK (status IN ('Active','Inactive'));
GO
ALTER TABLE TransportRoute ADD CONSTRAINT CK_TransportRoute_Status
CHECK (status IN ('Active','Inactive'));
GO
ALTER TABLE TransportTrip ADD CONSTRAINT CK_TransportTrip_Type
CHECK (trip_type IN ('Morning','Afternoon'));
GO
ALTER TABLE TransportTrip ADD CONSTRAINT CK_TransportTrip_Status
CHECK (status IN ('Scheduled','InProgress','Completed','Cancelled'));
GO
ALTER TABLE TripChild ADD CONSTRAINT CK_TripChild_BoardingStatus
CHECK (boarding_status IN ('Pending','Boarded','Absent','DroppedOff'));
GO
ALTER TABLE ChildTransportStop ADD CONSTRAINT CK_ChildTransportStop_Type
CHECK (stop_type IN ('Pickup','Dropoff','Both'));
GO
ALTER TABLE ChildTransportStop ADD CONSTRAINT CK_ChildTransportStop_Status
CHECK (status IN ('Active','Ended'));
GO
ALTER TABLE Event ADD CONSTRAINT CK_Event_Status
CHECK (status IN ('Scheduled','Completed','Cancelled'));
GO
ALTER TABLE EventRegistration ADD CONSTRAINT CK_EventRegistration_Status
CHECK (confirmation_status IN ('Pending','Confirmed','Declined'));
GO
ALTER TABLE EventAttendance ADD CONSTRAINT CK_EventAttendance_Status
CHECK (attendance_status IN ('Present','Absent'));
GO
ALTER TABLE Notification ADD CONSTRAINT CK_Notification_Status
CHECK (status IN ('Draft','Sent','Failed'));
GO
ALTER TABLE NotificationDelivery ADD CONSTRAINT CK_NotificationDelivery_Status
CHECK (delivery_status IN ('Pending','Sent','Delivered','Read','Failed'));
GO
ALTER TABLE Holiday ADD CONSTRAINT CK_Holiday_Status
CHECK (status IN ('Active','Inactive'));
GO


/* =========================================================
   100. Added in milestone M0
   ========================================================= */

-- ---- People and pickup -------------------------------------------------

-- One financial responsible guardian at most, per child
CREATE UNIQUE INDEX UX_ChildGuardian_OneFinancialPerChild
ON ChildGuardian (child_id)
WHERE is_financial_responsible = 1;
GO

ALTER TABLE ChildGuardian ADD CONSTRAINT CK_ChildGuardian_Relationship
CHECK (relationship_type IN ('Father','Mother','Guardian','Grandparent','Other'));
GO

-- A child who is anonymized must have a leaving date
ALTER TABLE Child ADD CONSTRAINT CK_Child_Retention
CHECK (anonymized_at IS NULL OR left_at IS NOT NULL);
GO

-- The pickup person is either a guardian (name and phone read from Guardian)
-- or someone else (name required). Never both, never neither.
ALTER TABLE AuthorizedPickupPerson ADD CONSTRAINT CK_AuthorizedPickupPerson_Identity
CHECK (
    (guardian_id IS NOT NULL AND name IS NULL AND phone IS NULL)
    OR
    (guardian_id IS NULL AND name IS NOT NULL)
);
GO

-- A guardian is registered as a pickup person only once
CREATE UNIQUE INDEX UX_AuthorizedPickupPerson_Guardian
ON AuthorizedPickupPerson (guardian_id)
WHERE guardian_id IS NOT NULL;
GO

ALTER TABLE BlockedPickupPerson ADD CONSTRAINT CK_BlockedPickupPerson_Status
CHECK (
    (status = 'Active' AND lifted_at IS NULL)
    OR
    (status = 'Lifted' AND lifted_at IS NOT NULL)
);
GO

ALTER TABLE PickupCode ADD CONSTRAINT CK_PickupCode_Status
CHECK (
    (status = 'Active'    AND used_at IS NULL)
    OR (status = 'Used'   AND used_at IS NOT NULL)
    OR (status IN ('Expired','Cancelled') AND used_at IS NULL)
);
GO

ALTER TABLE PickupCode ADD CONSTRAINT CK_PickupCode_Times
CHECK (expires_at > created_at);
GO

-- Absence reason only makes sense for an absence
ALTER TABLE Attendance ADD CONSTRAINT CK_Attendance_AbsenceReason
CHECK (absence_reason IS NULL OR status = 'Absent');
GO

-- Re-enrollment confirmation: who and when come together
ALTER TABLE Enrollment ADD CONSTRAINT CK_Enrollment_Confirmation
CHECK (
    (confirmed_by_guardian_id IS NULL AND confirmed_at IS NULL)
    OR
    (confirmed_by_guardian_id IS NOT NULL AND confirmed_at IS NOT NULL)
);
GO

-- ---- Assessment and media ----------------------------------------------

ALTER TABLE AssessmentLevel ADD CONSTRAINT CK_AssessmentLevel_Status
CHECK (status IN ('Active','Inactive'));
GO

ALTER TABLE AssessmentLevel ADD CONSTRAINT UQ_AssessmentLevel_Nursery_Name
UNIQUE (nursery_id, name);
GO

ALTER TABLE AssessmentLevel ADD CONSTRAINT UQ_AssessmentLevel_Nursery_Sort
UNIQUE (nursery_id, sort_order);
GO

ALTER TABLE MediaConsent ADD CONSTRAINT CK_MediaConsent_Scope
CHECK (scope IN ('ClassOnly','AllParents','Public'));
GO

ALTER TABLE MediaConsent ADD CONSTRAINT CK_MediaConsent_Dates
CHECK (revoked_at IS NULL OR revoked_at >= given_at);
GO

-- A child has at most one active (not withdrawn) consent
CREATE UNIQUE INDEX UX_MediaConsent_OneActivePerChild
ON MediaConsent (child_id)
WHERE revoked_at IS NULL;
GO

-- ---- Finance -------------------------------------------------------------

ALTER TABLE FeePlan ADD CONSTRAINT CK_FeePlan_Cycle
CHECK (billing_cycle IN ('Monthly'));
GO

ALTER TABLE FeePlan ADD CONSTRAINT CK_FeePlan_Status
CHECK (status IN ('Active','Inactive'));
GO

ALTER TABLE FeePlanItem ADD CONSTRAINT CK_FeePlanItem_Amount
CHECK (amount >= 0);
GO

ALTER TABLE BillingRun ADD CONSTRAINT CK_BillingRun_Status
CHECK (status IN ('Running','Completed','Failed'));
GO

ALTER TABLE BillingRun ADD CONSTRAINT CK_BillingRun_PeriodFirstDay
CHECK (DAY(billing_period) = 1);
GO

ALTER TABLE BillingRun ADD CONSTRAINT CK_BillingRun_Count
CHECK (invoices_created >= 0);
GO

-- billing_run_id and billing_period are set together (automatic invoices) or both empty
ALTER TABLE Invoice ADD CONSTRAINT CK_Invoice_BillingPair
CHECK (
    (billing_run_id IS NULL AND billing_period IS NULL)
    OR
    (billing_run_id IS NOT NULL AND billing_period IS NOT NULL)
);
GO

ALTER TABLE Invoice ADD CONSTRAINT CK_Invoice_PeriodFirstDay
CHECK (billing_period IS NULL OR DAY(billing_period) = 1);
GO

-- The same child is never billed twice for the same month
CREATE UNIQUE INDEX UX_Invoice_OnePerEnrollmentPeriod
ON Invoice (enrollment_id, billing_period)
WHERE billing_period IS NOT NULL;
GO

-- A registration pays through one invoice item, and an item pays one registration
CREATE UNIQUE INDEX UX_EventRegistration_InvoiceItem
ON EventRegistration (invoice_item_id)
WHERE invoice_item_id IS NOT NULL;
GO

-- ---- Notifications --------------------------------------------------------

ALTER TABLE NotificationDelivery ADD CONSTRAINT CK_NotificationDelivery_Channel
CHECK (channel IN ('Push','Email','WhatsApp'));
GO

ALTER TABLE NotificationTemplate ADD CONSTRAINT CK_NotificationTemplate_Channel
CHECK (channel IN ('Push','Email','WhatsApp'));
GO

ALTER TABLE NotificationTemplate ADD CONSTRAINT CK_NotificationTemplate_Language
CHECK (language IN ('ar','en'));
GO

ALTER TABLE NotificationPreference ADD CONSTRAINT CK_NotificationPreference_Channel
CHECK (channel IN ('Push','Email','WhatsApp'));
GO



/* =========================================================
   101. Holiday and WorkingHour checks (from the original file)
   ========================================================= */

ALTER TABLE Holiday
ADD CONSTRAINT CK_Holiday_Dates
CHECK (end_date >= start_date);
GO

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

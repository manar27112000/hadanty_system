
USE Hadanty;
GO

-- =============================================
-- 3. Staff
-- =============================================
CREATE INDEX IX_Staff_Name
ON Staff (first_name, last_name);

-- =============================================
-- 4. Guardian
-- =============================================
CREATE INDEX IX_Guardian_Name
ON Guardian (first_name, last_name);
GO


-- =============================================
-- 5. UserAccount
-- =============================================
CREATE INDEX IX_UserAccount_Staff
ON UserAccount (staff_id);

CREATE INDEX IX_UserAccount_Guardian
ON UserAccount (guardian_id);
GO
-- =============================================
-- 8. StaffBranch
-- =============================================
CREATE INDEX IX_StaffBranch_Branch
ON StaffBranch (branch_id);
GO

-- =============================================
-- 9. AccountRole
-- =============================================
CREATE INDEX IX_AccountRole_Role_Branch
ON AccountRole (role_id, branch_id);
GO

-- =============================================
-- 10. RolePermission
-- =============================================
CREATE INDEX IX_RolePermission_Permission
ON RolePermission (permission_id);
GO

-- =============================================
-- 11. Child
-- =============================================
CREATE INDEX IX_Child_Name
ON Child (first_name, last_name);
GO

-- =============================================
-- 3. Enrollment
-- =============================================
CREATE INDEX IX_Enrollment_Child
ON Enrollment (child_id);
GO

CREATE INDEX IX_Enrollment_Branch
ON Enrollment (branch_id);
GO

CREATE INDEX IX_Enrollment_AcademicYear
ON Enrollment (academic_year_id);
GO

-- =============================================
-- 4. ClassAssignment
-- =============================================
CREATE INDEX IX_ClassAssignment_Enrollment
ON ClassAssignment (enrollment_id);
GO

CREATE INDEX IX_ClassAssignment_Class
ON ClassAssignment (class_id);
GO

-- =============================================
-- 6. Homework
-- =============================================
CREATE INDEX IX_Homework_Class
ON Homework (class_id);
GO

CREATE INDEX IX_Homework_AssignedDate
ON Homework (assigned_date);
GO

-- =============================================
-- 7. Activity
-- =============================================
CREATE INDEX IX_Activity_Class
ON Activity (class_id);
GO

CREATE INDEX IX_Activity_Date
ON Activity (activity_date);
GO
-- =============================================
-- 1. Attendance
-- =============================================
CREATE INDEX IX_Attendance_Date
ON Attendance (attendance_date);
GO
-- =============================================
-- 5. Pickup
-- =============================================
CREATE INDEX IX_Pickup_Child_Time
ON Pickup (child_id, pickup_time);
GO

-- =============================================
-- 1. DailyReport
-- =============================================
-- No index on (child_id, report_date): UQ_DailyReport_Child_Date already provides it.

-- =============================================
-- 2. DailyAssessment
-- =============================================
CREATE INDEX IX_DailyAssessment_Subject
ON DailyAssessment (subject_id);
GO


-- =============================================
-- 3. MonthlyAssessment
-- =============================================

CREATE INDEX IX_MonthlyAssessment_Subject
ON MonthlyAssessment (subject_id);
GO

-- =============================================
-- 4. Media
-- =============================================
CREATE INDEX IX_Media_Child_UploadedAt
ON Media (child_id, uploaded_at);
GO


-- Allergy
CREATE INDEX IX_Allergy_HealthRecord
ON Allergy (health_record_id);
GO

-- Medication
CREATE INDEX IX_Medication_HealthRecord
ON Medication (health_record_id);
GO

-- Incident
CREATE INDEX IX_Incident_Child_Date
ON Incident (child_id, incident_date);
GO

CREATE INDEX IX_Incident_Staff
ON Incident (staff_id);
GO


-- =============================================
-- Finance Indexes
-- =============================================

-- 1. Invoice
CREATE INDEX IX_Invoice_Child_Date
ON Invoice (child_id, invoice_date);
GO

-- 2. InvoiceItem
CREATE INDEX IX_InvoiceItem_Invoice
ON InvoiceItem (invoice_id);
GO

-- 3. InvoiceDiscount
-- No index on InvoiceDiscount (invoice_id): UQ_InvoiceDiscount_Invoice_Discount already provides it.

CREATE INDEX IX_InvoiceDiscount_Discount
ON InvoiceDiscount (discount_id);
GO

-- 4. InvoiceItemDiscount
-- No index on InvoiceItemDiscount (invoice_item_id): UQ_InvoiceItemDiscount_Item_Discount already provides it.

CREATE INDEX IX_InvoiceItemDiscount_Discount
ON InvoiceItemDiscount (discount_id);
GO

-- 5. Payment
CREATE INDEX IX_Payment_Invoice_Date
ON Payment (invoice_id, payment_date);
GO

-- 6. PaymentAttempt
CREATE INDEX IX_PaymentAttempt_Payment
ON PaymentAttempt (payment_id);
GO

-- 7. Refund
CREATE INDEX IX_Refund_Payment
ON Refund (payment_id);
GO

-- =============================================
-- Transportation Indexes
-- =============================================

-- Bus
CREATE INDEX IX_Bus_Branch
ON Bus (branch_id);
GO

-- Driver
CREATE INDEX IX_Driver_Branch
ON Driver (branch_id);
GO

-- BusSupervisor
CREATE INDEX IX_BusSupervisor_Branch
ON BusSupervisor (branch_id);
GO

-- TransportRoute
CREATE INDEX IX_TransportRoute_Branch
ON TransportRoute (branch_id);
GO

-- TransportTrip
CREATE INDEX IX_TransportTrip_Route_Date
ON TransportTrip (route_id, trip_date);
GO

CREATE INDEX IX_TransportTrip_Bus
ON TransportTrip (bus_id);
GO

CREATE INDEX IX_TransportTrip_Driver
ON TransportTrip (driver_id);
GO

CREATE INDEX IX_TransportTrip_Supervisor
ON TransportTrip (supervisor_id);
GO

-- TripChild
CREATE INDEX IX_TripChild_Child
ON TripChild (child_id);
GO

-- ChildTransportStop
CREATE INDEX IX_ChildTransportStop_Child
ON ChildTransportStop (child_id);
GO

CREATE INDEX IX_ChildTransportStop_Stop
ON ChildTransportStop (stop_id);
GO

-- =============================================
-- Events & Notifications Indexes
-- =============================================

-- Event
CREATE INDEX IX_Event_Branch_Date
ON Event (branch_id, event_date);
GO

-- EventRegistration
CREATE INDEX IX_EventRegistration_Child
ON EventRegistration (child_id);
GO

-- Notification
CREATE INDEX IX_Notification_Type
ON Notification (notification_type_id);
GO

-- NotificationDelivery
CREATE INDEX IX_NotificationDelivery_Account
ON NotificationDelivery (account_id);
GO

-- =============================================
-- Settings & Audit Indexes
-- =============================================

-- Holiday
CREATE INDEX IX_Holiday_Branch_Date
ON Holiday (branch_id, start_date);
GO

-- AuditLog
CREATE INDEX IX_AuditLog_Account_Date
ON AuditLog (account_id, action_date);
GO

CREATE INDEX IX_AuditLog_Entity
ON AuditLog (entity_name, entity_id);
GO


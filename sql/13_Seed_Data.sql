USE Hadanty;
GO

/* =========================================================
   13. SEED DATA
   ========================================================= */

/* =========================================================
   1. Nursery
   ========================================================= */

INSERT INTO Nursery
(
    nursery_id,
    name,
    owner_name,
    commercial_registration_no,
    tax_number,
    address,
    phone,
    status
)
VALUES
(1, 'Little Stars Nursery', 'Ahmed Ali', 'CR1001', 'TAX1001',
 'Nasr City, Cairo', '01000000001', 'Active'),

(2, 'Happy Kids Nursery', 'Sara Mohamed', 'CR1002', 'TAX1002',
 'Giza', '01000000002', 'Active');
GO


/* =========================================================
   2. Branch
   ========================================================= */

INSERT INTO Branch
(
    branch_id,
    nursery_id,
    name,
    address,
    phone,
    status
)
VALUES
(1, 1, 'Little Stars - Main Branch',
 'Nasr City, Cairo', '01000000101', 'Active'),

(2, 1, 'Little Stars - New Cairo',
 'New Cairo, Cairo', '01000000102', 'Active'),

(3, 2, 'Happy Kids - Main Branch',
 'Dokki, Giza', '01000000201', 'Active'),

(4, 2, 'Happy Kids - October',
 '6th of October, Giza', '01000000202', 'Active');
GO


/* =========================================================
   3. Staff
   ========================================================= */

INSERT INTO Staff
(
    staff_id,
    first_name,
    last_name,
    national_id,
    phone,
    email,
    specialization,
    qualification,
    hire_date,
    employment_status
)
VALUES
(1, 'Ahmed', 'Hassan', '29001011234567',
 '01010000001', 'ahmed.hassan@hadanty.demo',
 'Manager', 'BBA', '2022-01-15', 'Active'),

(2, 'Mona', 'Ali', '29502021234567',
 '01010000002', 'mona.ali@hadanty.demo',
 'Teacher', 'Early Childhood Education', '2023-02-01', 'Active'),

(3, 'Nour', 'Mohamed', '29803031234567',
 '01010000003', 'nour.mohamed@hadanty.demo',
 'Teacher', 'Education', '2023-09-10', 'Active'),

(4, 'Omar', 'Ibrahim', '29204041234567',
 '01010000004', 'omar.ibrahim@hadanty.demo',
 'Administrator', 'Commerce', '2021-06-20', 'Active'),

(5, 'Aya', 'Mahmoud', '30005051234567',
 '01010000005', 'aya.mahmoud@hadanty.demo',
 'Nanny', 'Child Care', '2024-01-05', 'Active');
GO


/* =========================================================
   4. Guardian
   ========================================================= */

INSERT INTO Guardian
(
    guardian_id,
    first_name,
    last_name,
    phone,
    email,
    address,
    status
)
VALUES
(1, 'Mohamed', 'Adel',
 '01110000001', 'mohamed.adel@hadanty.demo',
 'Nasr City, Cairo', 'Active'),

(2, 'Sara', 'Hassan',
 '01110000002', 'sara.hassan@hadanty.demo',
 'New Cairo, Cairo', 'Active'),

(3, 'Khaled', 'Mahmoud',
 '01110000003', 'khaled.mahmoud@hadanty.demo',
 'Dokki, Giza', 'Active'),

(4, 'Mariam', 'Ali',
 '01110000004', 'mariam.ali@hadanty.demo',
 '6th of October, Giza', 'Active'),

(5, 'Youssef', 'Ibrahim',
 '01110000005', 'youssef.ibrahim@hadanty.demo',
 'Nasr City, Cairo', 'Active');
GO


/* =========================================================
   5. UserAccount
   ========================================================= */

INSERT INTO UserAccount
(
    account_id,
    staff_id,
    guardian_id,
    username,
    password_hash,
    is_active,
    last_login_at
)
VALUES
(1, 1, NULL, 'ahmed.manager',
 'HASHED_DEMO_PASSWORD_1', 1, '2026-09-20 09:00:00'),

(2, 2, NULL, 'mona.teacher',
 'HASHED_DEMO_PASSWORD_2', 1, '2026-09-21 08:30:00'),

(3, 3, NULL, 'nour.teacher',
 'HASHED_DEMO_PASSWORD_3', 1, '2026-09-21 08:45:00'),

(4, 4, NULL, 'omar.admin',
 'HASHED_DEMO_PASSWORD_4', 1, '2026-09-19 10:00:00'),

(5, 5, NULL, 'aya.nanny',
 'HASHED_DEMO_PASSWORD_5', 1, '2026-09-18 07:45:00'),

(6, NULL, 1, 'mohamed.guardian',
 'HASHED_DEMO_PASSWORD_6', 1, '2026-09-20 17:30:00'),

(7, NULL, 2, 'sara.guardian',
 'HASHED_DEMO_PASSWORD_7', 1, '2026-09-20 18:00:00'),

(8, NULL, 3, 'khaled.guardian',
 'HASHED_DEMO_PASSWORD_8', 1, '2026-09-20 18:15:00'),

(9, NULL, 4, 'mariam.guardian',
 'HASHED_DEMO_PASSWORD_9', 1, '2026-09-20 19:00:00'),

(10, NULL, 5, 'youssef.guardian',
 'HASHED_DEMO_PASSWORD_10', 1, NULL);
GO


/* =========================================================
   6. Role
   ========================================================= */

INSERT INTO Role
(
    role_id,
    name,
    description,
    status
)
VALUES
(1, 'Owner', 'Full nursery management access', 'Active'),
(2, 'Manager', 'Branch and staff management access', 'Active'),
(3, 'Teacher', 'Class, attendance and assessment access', 'Active'),
(4, 'Administrator', 'Administrative and financial access', 'Active'),
(5, 'Nanny', 'Child care and daily activity access', 'Active'),
(6, 'Guardian', 'Read-only access for guardian accounts', 'Active');
GO


/* =========================================================
   7. Permission
   ========================================================= */

INSERT INTO Permission
(
    permission_id,
    name,
    description,
    module
)
VALUES
(1, 'ViewChildren', 'View children information', 'Children'),
(2, 'ManageChildren', 'Create and update children information', 'Children'),

(3, 'ViewAttendance', 'View attendance records', 'Attendance'),
(4, 'ManageAttendance', 'Create and update attendance records', 'Attendance'),

(5, 'ViewAssessments', 'View assessments', 'Assessment'),
(6, 'ManageAssessments', 'Create and update assessments', 'Assessment'),

(7, 'ViewInvoices', 'View invoices', 'Finance'),
(8, 'ManageInvoices', 'Create and update invoices', 'Finance'),

(9, 'ViewPayments', 'View payments', 'Finance'),
(10, 'ManagePayments', 'Manage payments', 'Finance'),

(11, 'ManageStaff', 'Manage staff information', 'Staff'),
(12, 'ManageBranches', 'Manage branches', 'Branches'),

(13, 'ViewReports', 'View reports', 'Reports'),
(14, 'ManageTransportation', 'Manage transportation', 'Transportation'),

(15, 'ViewEvents', 'View events', 'Events'),
(16, 'ManageEvents', 'Manage events', 'Events'),

(17, 'ViewNotifications', 'View notifications', 'Notifications'),
(18, 'ManageSettings', 'Manage nursery settings', 'Settings'),

(19, 'ViewHealthRecords', 'View child health records', 'Health'),
(20, 'ManageHealthRecords', 'Manage child health records', 'Health');
GO


/* =========================================================
   8. StaffBranch
   ========================================================= */

INSERT INTO StaffBranch
(
    staff_id,
    branch_id
)
VALUES
(1, 1),
(2, 1),
(5, 1),

(1, 2),
(3, 2),

(4, 3),
(5, 3),

(3, 4),
(4, 4);
GO


/* =========================================================
   9. AccountRole
   ========================================================= */

INSERT INTO AccountRole
(
    account_id,
    role_id,
    branch_id
)
VALUES
(1, 1, 1),
(1, 1, 2),

(2, 3, 1),
(3, 3, 2),

(4, 4, 3),
(4, 4, 4),

(5, 5, 1),
(5, 5, 3),

(6, 6, 1),
(7, 6, 2),
(8, 6, 3),
(9, 6, 4),
(10, 6, 1);
GO


/* =========================================================
   10. RolePermission
   ========================================================= */

INSERT INTO RolePermission
(
    role_id,
    permission_id
)
VALUES
-- Owner
(1, 1),(1, 2),(1, 3),(1, 4),
(1, 5),(1, 6),(1, 7),(1, 8),
(1, 9),(1, 10),(1, 11),(1, 12),
(1, 13),(1, 14),(1, 15),(1, 16),
(1, 17),(1, 18),(1, 19),(1, 20),

-- Manager
(2, 1),(2, 2),(2, 3),(2, 4),
(2, 5),(2, 6),(2, 7),(2, 8),
(2, 9),(2, 10),(2, 11),(2, 13),
(2, 14),(2, 15),(2, 16),(2, 17),
(2, 19),(2, 20),

-- Teacher
(3, 1),(3, 3),(3, 4),
(3, 5),(3, 6),
(3, 13),(3, 15),
(3, 17),(3, 19),

-- Administrator
(4, 1),(4, 2),(4, 3),(4, 4),
(4, 7),(4, 8),(4, 9),(4, 10),
(4, 13),(4, 15),(4, 16),(4, 17),

-- Nanny
(5, 1),(5, 3),(5, 4),
(5, 17),(5, 19),

-- Guardian - read only
(6, 1),(6, 3),(6, 5),
(6, 7),(6, 9),(6, 13),
(6, 15),(6, 17),(6, 19);
GO


/* =========================================================
   11. Child
   ========================================================= */

INSERT INTO Child
(
    child_id,
    first_name,
    last_name,
    national_id,
    date_of_birth,
    gender,
    status
)
VALUES
(1, 'Adam', 'Mohamed', '20180101000101',
 '2018-01-10', 'Male', 'Active'),

(2, 'Lina', 'Mohamed', '20190102000202',
 '2019-02-15', 'Female', 'Active'),

(3, 'Omar', 'Sara', '20180303000303',
 '2018-03-20', 'Male', 'Active'),

(4, 'Jana', 'Khaled', '20200404000404',
 '2020-04-05', 'Female', 'Active'),

(5, 'Youssef', 'Khaled', '20190505000505',
 '2019-05-12', 'Male', 'Active'),

(6, 'Maya', 'Mariam', '20200606000606',
 '2020-06-18', 'Female', 'Active'),

(7, 'Ali', 'Youssef', '20180707000707',
 '2018-07-25', 'Male', 'Active'),

(8, 'Nour', 'Youssef', '20190808000808',
 '2019-08-30', 'Female', 'Active');
GO


/* =========================================================
   12. AcademicYear
   ========================================================= */

INSERT INTO AcademicYear
(
    academic_year_id,
    nursery_id,
    name,
    start_date,
    end_date,
    status
)
VALUES
(1, 1, '2025-2026', '2025-09-01', '2026-06-30', 'Closed'),
(2, 2, '2025-2026', '2025-09-01', '2026-06-30', 'Closed'),
(3, 1, '2026-2027', '2026-09-01', '2027-06-30', 'Active'),
(4, 2, '2026-2027', '2026-09-01', '2027-06-30', 'Active');
GO


/* =========================================================
   13. Class
   ========================================================= */

INSERT INTO Class
(
    class_id,
    branch_id,
    name,
    age_group,
    capacity,
    status
)
VALUES
(1, 1, 'Butterflies', '3-4 Years', 20, 'Active'),
(2, 1, 'Sunshine', '4-5 Years', 20, 'Active'),
(3, 2, 'Stars', '5-6 Years', 20, 'Active'),
(4, 2, 'Little Explorers', '3-4 Years', 15, 'Active'),
(5, 3, 'Rainbows', '4-5 Years', 20, 'Active'),
(6, 3, 'Smart Kids', '5-6 Years', 20, 'Active'),
(7, 4, 'Moon Class', '3-4 Years', 15, 'Active'),
(8, 4, 'Future Stars', '5-6 Years', 20, 'Active');
GO


/* =========================================================
   14. Enrollment
   ========================================================= */

INSERT INTO Enrollment
(
    enrollment_id,
    child_id,
    academic_year_id,
    branch_id,
    enrollment_date,
    status
)
VALUES
(1, 1, 3, 1, '2026-09-01', 'Active'),
(2, 2, 3, 1, '2026-09-01', 'Active'),
(3, 3, 3, 2, '2026-09-02', 'Active'),
(4, 4, 3, 2, '2026-09-02', 'Active'),

(5, 5, 4, 3, '2026-09-01', 'Active'),
(6, 6, 4, 3, '2026-09-01', 'Active'),
(7, 7, 4, 4, '2026-09-03', 'Active'),
(8, 8, 4, 4, '2026-09-03', 'Active');
GO


/* =========================================================
   15. ClassAssignment
   ========================================================= */

INSERT INTO ClassAssignment
(
    assignment_id,
    enrollment_id,
    class_id,
    start_date,
    end_date,
    status
)
VALUES
(1, 1, 2, '2026-09-01', NULL, 'Active'),
(2, 2, 2, '2026-09-01', NULL, 'Active'),

(3, 3, 3, '2026-09-02', NULL, 'Active'),
(4, 4, 4, '2026-09-02', NULL, 'Active'),

(5, 5, 5, '2026-09-01', NULL, 'Active'),
(6, 6, 5, '2026-09-01', NULL, 'Active'),

(7, 7, 7, '2026-09-03', NULL, 'Active'),
(8, 8, 8, '2026-09-03', NULL, 'Active');
GO


/* =========================================================
   16. Subject
   ========================================================= */

INSERT INTO Subject
(
    subject_id,
    name,
    description,
    status
)
VALUES
(1, 'Arabic', 'Arabic language activities', 'Active'),
(2, 'English', 'English language activities', 'Active'),
(3, 'Mathematics', 'Basic mathematics', 'Active'),
(4, 'Science', 'Basic science activities', 'Active'),
(5, 'Art', 'Creative art activities', 'Active');
GO


/* =========================================================
   17. Homework
   ========================================================= */

INSERT INTO Homework
(
    homework_id,
    class_id,
    title,
    description,
    assigned_date,
    due_date,
    status
)
VALUES
(1, 2, 'Arabic Letters',
 'Practice letters A to E', '2026-09-20', '2026-09-22', 'Completed'),

(2, 2, 'Numbers Practice',
 'Practice numbers 1 to 10', '2026-09-21', '2026-09-24', 'Assigned'),

(3, 3, 'English Words',
 'Learn five simple English words', '2026-09-20', '2026-09-23', 'Completed'),

(4, 5, 'Colors',
 'Identify basic colors', '2026-09-21', '2026-09-24', 'Assigned');
GO


/* =========================================================
   18. Activity
   ========================================================= */

INSERT INTO Activity
(
    activity_id,
    class_id,
    name,
    description,
    activity_date,
    status
)
VALUES
(1, 2, 'Drawing Day',
 'Children draw their favorite animals',
 '2026-09-20', 'Completed'),

(2, 2, 'Story Time',
 'Interactive story session',
 '2026-09-21', 'Completed'),

(3, 3, 'Counting Game',
 'Numbers and counting activity',
 '2026-09-21', 'Completed'),

(4, 5, 'Science Experiment',
 'Simple water experiment',
 '2026-09-22', 'Completed'),

(5, 7, 'Music Time',
 'Songs and movement',
 '2026-09-22', 'Completed');
GO


/* =========================================================
   19. Attendance
   ========================================================= */

INSERT INTO Attendance
(
    attendance_id,
    child_id,
    attendance_date,
    status
)
VALUES
(1, 1, '2026-09-21', 'Present'),
(2, 2, '2026-09-21', 'Present'),
(3, 3, '2026-09-21', 'Late'),
(4, 4, '2026-09-21', 'Present'),

(5, 5, '2026-09-21', 'Present'),
(6, 6, '2026-09-21', 'Absent'),
(7, 7, '2026-09-21', 'Present'),
(8, 8, '2026-09-21', 'Late');
GO


/* =========================================================
   20. CheckIn
   ========================================================= */

INSERT INTO CheckIn
(
    check_in_id,
    attendance_id,
    check_in_time
)
VALUES
(1, 1, '2026-09-21 08:05:00'),
(2, 2, '2026-09-21 08:10:00'),
(3, 3, '2026-09-21 08:35:00'),
(4, 4, '2026-09-21 08:00:00'),

(5, 5, '2026-09-21 08:15:00'),
(6, 7, '2026-09-21 07:55:00'),
(7, 8, '2026-09-21 08:40:00');
GO


/* =========================================================
   21. CheckOut
   ========================================================= */

INSERT INTO CheckOut
(
    check_out_id,
    attendance_id,
    check_out_time
)
VALUES
(1, 1, '2026-09-21 15:00:00'),
(2, 2, '2026-09-21 15:05:00'),
(3, 3, '2026-09-21 15:00:00'),
(4, 4, '2026-09-21 14:50:00'),

(5, 5, '2026-09-21 15:10:00'),
(6, 7, '2026-09-21 15:00:00'),
(7, 8, '2026-09-21 15:15:00');
GO


/* =========================================================
   22. AuthorizedPickupPerson
   ========================================================= */

INSERT INTO AuthorizedPickupPerson
(
    authorized_person_id,
    name,
    phone,
    relationship_type,
    identification_info,
    status
)
VALUES
(1, 'Mohamed Adel', '01110000001', 'Father',
 'ID-DEMO-001', 'Active'),

(2, 'Sara Hassan', '01110000002', 'Mother',
 'ID-DEMO-002', 'Active'),

(3, 'Khaled Mahmoud', '01110000003', 'Father',
 'ID-DEMO-003', 'Active'),

(4, 'Mariam Ali', '01110000004', 'Mother',
 'ID-DEMO-004', 'Active'),

(5, 'Youssef Ibrahim', '01110000005', 'Father',
 'ID-DEMO-005', 'Active');
GO


/* =========================================================
   23. Pickup
   ========================================================= */

INSERT INTO Pickup
(
    pickup_id,
    child_id,
    authorized_person_id,
    pickup_person_name,
    pickup_type,
    pickup_time,
    status
)
VALUES
(1, 1, 1, 'Mohamed Adel', 'Regular',
 '2026-09-21 15:00:00', 'Completed'),

(2, 2, 2, 'Sara Hassan', 'Regular',
 '2026-09-21 15:05:00', 'Completed'),

(3, 3, 3, 'Khaled Mahmoud', 'Regular',
 '2026-09-21 15:00:00', 'Completed'),

(4, 4, 4, 'Mariam Ali', 'Early Pickup',
 '2026-09-21 13:30:00', 'Completed');
GO


/* =========================================================
   24. PickupApproval
   ========================================================= */

INSERT INTO PickupApproval
(
    approval_id,
    pickup_id,
    authorized_person_name,
    approval_time,
    status
)
VALUES
(1, 1, 'Mohamed Adel', '2026-09-21 14:55:00', 'Approved'),
(2, 2, 'Sara Hassan', '2026-09-21 15:00:00', 'Approved'),
(3, 3, 'Khaled Mahmoud', '2026-09-21 14:55:00', 'Approved'),
(4, 4, 'Mariam Ali', '2026-09-21 13:20:00', 'Approved');
GO


/* =========================================================
   25. DailyReport
   ========================================================= */

INSERT INTO DailyReport
(
    daily_report_id,
    child_id,
    report_date,
    food,
    sleep,
    mood,
    activities_notes,
    homework_notes,
    general_notes
)
VALUES
(1, 1, '2026-09-21',
 'Ate well', 'Good', 'Happy',
 'Participated in drawing',
 'Completed Arabic activity',
 'Good day'),

(2, 2, '2026-09-21',
 'Ate normally', 'Good', 'Happy',
 'Participated in story time',
 'Completed homework',
 'Very active'),

(3, 3, '2026-09-21',
 'Ate well', 'Average', 'Calm',
 'Participated in counting game',
 'Completed English homework',
 'Arrived late'),

(4, 5, '2026-09-21',
 'Ate well', 'Good', 'Happy',
 'Participated in science activity',
 'Completed colors activity',
 'Good participation');
GO


/* =========================================================
   26. DailyAssessment
   ========================================================= */

INSERT INTO DailyAssessment
(
    daily_assessment_id,
    child_id,
    subject_id,
    assessment_date,
    level,
    notes
)
VALUES
(1, 1, 1, '2026-09-21', 'Excellent', 'Good letter recognition'),
(2, 1, 2, '2026-09-21', 'Good', 'Understands simple words'),
(3, 2, 1, '2026-09-21', 'Excellent', 'Very good participation'),
(4, 3, 3, '2026-09-21', 'Good', 'Understands basic numbers'),
(5, 5, 4, '2026-09-21', 'Excellent', 'Very curious');
GO


/* =========================================================
   27. MonthlyAssessment
   ========================================================= */

INSERT INTO MonthlyAssessment
(
    monthly_assessment_id,
    child_id,
    subject_id,
    month,
    year,
    level,
    notes
)
VALUES
(1, 1, 1, 9, 2026, 'Excellent',
 'Strong Arabic development'),

(2, 1, 2, 9, 2026, 'Good',
 'Good English progress'),

(3, 2, 1, 9, 2026, 'Excellent',
 'Excellent participation'),

(4, 3, 3, 9, 2026, 'Good',
 'Good mathematical skills'),

(5, 5, 4, 9, 2026, 'Excellent',
 'Strong curiosity and participation');
GO


/* =========================================================
   28. Media
   ========================================================= */

INSERT INTO Media
(
    media_id,
    child_id,
    file_url,
    file_type,
    status
)
VALUES
(1, 1, 'https://demo.hadanty.local/media/child1.jpg',
 'image', 'Active'),

(2, 2, 'https://demo.hadanty.local/media/child2.jpg',
 'image', 'Active'),

(3, 3, 'https://demo.hadanty.local/media/child3.jpg',
 'image', 'Active'),

(4, 5, 'https://demo.hadanty.local/media/child5.jpg',
 'image', 'Active');
GO


/* =========================================================
   29. HealthRecord
   ========================================================= */

INSERT INTO HealthRecord
(
    health_record_id,
    child_id,
    medical_notes,
    emergency_notes
)
VALUES
(1, 1, 'No major medical notes',
 'Contact guardian if needed'),

(2, 2, 'No known medical conditions',
 'Contact mother in emergency'),

(3, 3, 'Seasonal allergy history',
 'Keep guardian informed'),

(4, 5, 'No major medical notes',
 'Contact guardian if needed');
GO


/* =========================================================
   30. Allergy
   ========================================================= */

INSERT INTO Allergy
(
    allergy_id,
    health_record_id,
    allergy_name,
    severity,
    notes,
    status
)
VALUES
(1, 3, 'Dust', 'Mild',
 'May cause sneezing', 'Active'),

(2, 3, 'Peanuts', 'Moderate',
 'Avoid peanut products', 'Active');
GO


/* =========================================================
   31. Medication
   ========================================================= */

INSERT INTO Medication
(
    medication_id,
    health_record_id,
    medication_name,
    dosage,
    start_date,
    end_date,
    instructions,
    status
)
VALUES
(1, 3, 'Demo Allergy Medication',
 '5 ml',
 '2026-09-20',
 '2026-09-25',
 'Give after food if required',
 'Active');
GO


/* =========================================================
   32. MedicationConsent
   ========================================================= */

INSERT INTO MedicationConsent
(
    consent_id,
    medication_id,
    consent_date,
    status
)
VALUES
(1, 1, '2026-09-20', 'Approved');
GO


/* =========================================================
   33. Incident
   ========================================================= */

INSERT INTO Incident
(
    incident_id,
    child_id,
    staff_id,
    incident_type,
    description,
    incident_date,
    action_taken,
    parent_notified
)
VALUES
(1, 3, 2,
 'Minor Fall',
 'Child slipped while playing.',
 '2026-09-21 11:00:00',
 'Checked child and applied basic first aid.',
 1),

(2, 5, 5,
 'Minor Scratch',
 'Small scratch during activity.',
 '2026-09-22 10:30:00',
 'Cleaned the area and monitored child.',
 1);
GO


/* =========================================================
   34. FeeType
   ========================================================= */

INSERT INTO FeeType
(
    fee_type_id,
    name,
    description,
    status
)
VALUES
(1, 'Registration Fee', 'New enrollment registration fee', 'Active'),
(2, 'Monthly Fee', 'Monthly nursery fee', 'Active'),
(3, 'Transportation Fee', 'Monthly transportation fee', 'Active'),
(4, 'Activities Fee', 'Activities and events fee', 'Active'),
(5, 'Books Fee', 'Books and educational material fee', 'Active'),
(6, 'Supplies Fee', 'School supplies fee', 'Active');
GO


/* =========================================================
   35. Invoice
   ========================================================= */

INSERT INTO Invoice
(
    invoice_id,
    child_id,
    invoice_date,
    due_date,
    discount_total,
    total_amount,
    status
)
VALUES
(1, 1, '2026-09-01', '2026-09-10', 100.00, 1900.00, 'Paid'),
(2, 2, '2026-09-01', '2026-09-10', 0.00, 2000.00, 'Paid'),
(3, 3, '2026-09-02', '2026-09-12', 150.00, 1850.00, 'PartiallyPaid'),
(4, 5, '2026-09-01', '2026-09-10', 0.00, 2200.00, 'Paid'),
(5, 7, '2026-09-03', '2026-09-13', 50.00, 1950.00, 'Pending');
GO


/* =========================================================
   36. InvoiceItem
   ========================================================= */

INSERT INTO InvoiceItem
(
    invoice_item_id,
    invoice_id,
    fee_type_id,
    description,
    quantity,
    unit_amount,
    discount_amount,
    total_amount
)
VALUES
(1, 1, 2, 'September Monthly Fee', 1, 2000.00, 100.00, 1900.00),

(2, 2, 2, 'September Monthly Fee', 1, 2000.00, 0.00, 2000.00),

(3, 3, 2, 'September Monthly Fee', 1, 2000.00, 150.00, 1850.00),

(4, 4, 2, 'September Monthly Fee', 1, 2000.00, 0.00, 2000.00),

(5, 4, 3, 'September Transportation', 1, 200.00, 0.00, 200.00),

(6, 5, 2, 'September Monthly Fee', 1, 2000.00, 50.00, 1950.00);
GO


/* =========================================================
   37. Discount
   ========================================================= */

INSERT INTO Discount
(
    discount_id,
    name,
    discount_type,
    value,
    start_date,
    end_date,
    status
)
VALUES
(1, 'Sibling Discount', 'Percentage', 10.00,
 '2026-09-01', '2027-06-30', 'Active'),

(2, 'Early Payment Discount', 'Fixed', 100.00,
 '2026-09-01', '2026-09-30', 'Active'),

(3, 'Special Discount', 'Fixed', 150.00,
 '2026-09-01', '2026-09-30', 'Active');
GO


/* =========================================================
   38. InvoiceDiscount
   ========================================================= */

INSERT INTO InvoiceDiscount
(
    invoice_discount_id,
    invoice_id,
    discount_id,
    discount_amount
)
VALUES
(1, 1, 2, 100.00),
(2, 3, 3, 150.00),
(3, 5, 2, 50.00);
GO


/* =========================================================
   39. InvoiceItemDiscount
   ========================================================= */

INSERT INTO InvoiceItemDiscount
(
    invoice_item_discount_id,
    invoice_item_id,
    discount_id,
    discount_amount
)
VALUES
(1, 1, 2, 100.00),
(2, 3, 3, 150.00),
(3, 6, 2, 50.00);
GO


/* =========================================================
   40. Payment
   ========================================================= */

INSERT INTO Payment
(
    payment_id,
    invoice_id,
    amount,
    payment_date,
    payment_method,
    transaction_number,
    status
)
VALUES
(1, 1, 1900.00, '2026-09-05 10:00:00',
 'Cash', 'TXN10001', 'Completed'),

(2, 2, 2000.00, '2026-09-05 11:00:00',
 'BankTransfer', 'TXN10002', 'Completed'),

(3, 3, 1000.00, '2026-09-06 12:00:00',
 'Cash', 'TXN10003', 'Completed'),

(4, 4, 2200.00, '2026-09-05 13:00:00',
 'Card', 'TXN10004', 'Completed');
GO


/* =========================================================
   41. PaymentAttempt
   ========================================================= */

INSERT INTO PaymentAttempt
(
    attempt_id,
    payment_id,
    transaction_number,
    receipt_file_url,
    submitted_at,
    reviewed_at,
    status,
    rejection_reason
)
VALUES
(1, 2, 'TXN10002',
 'https://demo.hadanty.local/receipts/payment2.jpg',
 '2026-09-05 11:00:00',
 '2026-09-05 12:00:00',
 'Approved',
 NULL),

(2, 4, 'TXN10004',
 'https://demo.hadanty.local/receipts/payment4.jpg',
 '2026-09-05 13:00:00',
 '2026-09-05 14:00:00',
 'Approved',
 NULL);
GO


/* =========================================================
   42. Refund
   ========================================================= */

INSERT INTO Refund
(
    refund_id,
    payment_id,
    amount,
    reason,
    refund_date,
    status
)
VALUES
(1, 4, 200.00,
 'Transportation service adjustment',
 '2026-09-10 14:00:00',
 'Completed');
GO


/* =========================================================
   43. Receipt
   ========================================================= */

INSERT INTO Receipt
(
    receipt_id,
    payment_id,
    receipt_number,
    amount,
    issued_at,
    payment_method,
    transaction_number
)
VALUES
(1, 1, 'REC10001', 1900.00,
 '2026-09-05 10:05:00', 'Cash', 'TXN10001'),

(2, 2, 'REC10002', 2000.00,
 '2026-09-05 12:05:00', 'BankTransfer', 'TXN10002'),

(3, 3, 'REC10003', 1000.00,
 '2026-09-06 12:05:00', 'Cash', 'TXN10003'),

(4, 4, 'REC10004', 2200.00,
 '2026-09-05 14:05:00', 'Card', 'TXN10004');
GO


/* =========================================================
   44. Bus
   ========================================================= */

INSERT INTO Bus
(
    bus_id,
    branch_id,
    bus_number,
    license_plate,
    capacity,
    status
)
VALUES
(1, 1, 'BUS-01', 'ABC-1001', 25, 'Active'),
(2, 2, 'BUS-02', 'ABC-1002', 20, 'Active'),
(3, 3, 'BUS-03', 'ABC-1003', 25, 'Active'),
(4, 4, 'BUS-04', 'ABC-1004', 20, 'Active');
GO


/* =========================================================
   45. Driver
   ========================================================= */

INSERT INTO Driver
(
    driver_id,
    branch_id,
    name,
    phone,
    license_number,
    status
)
VALUES
(1, 1, 'Hassan Mahmoud', '01220000001',
 'LIC1001', 'Active'),

(2, 2, 'Mostafa Ali', '01220000002',
 'LIC1002', 'Active'),

(3, 3, 'Ahmed Samir', '01220000003',
 'LIC1003', 'Active'),

(4, 4, 'Mahmoud Hassan', '01220000004',
 'LIC1004', 'Active');
GO


/* =========================================================
   46. BusSupervisor
   ========================================================= */

INSERT INTO BusSupervisor
(
    supervisor_id,
    branch_id,
    name,
    phone,
    status
)
VALUES
(1, 1, 'Hoda Ahmed', '01230000001', 'Active'),
(2, 2, 'Mai Hassan', '01230000002', 'Active'),
(3, 3, 'Reem Ali', '01230000003', 'Active'),
(4, 4, 'Dina Mohamed', '01230000004', 'Active');
GO


/* =========================================================
   47. TransportRoute
   ========================================================= */

INSERT INTO TransportRoute
(
    route_id,
    branch_id,
    name,
    description,
    status
)
VALUES
(1, 1, 'Nasr City Route',
 'Main Nasr City transportation route', 'Active'),

(2, 2, 'New Cairo Route',
 'Main New Cairo transportation route', 'Active'),

(3, 3, 'Dokki Route',
 'Main Dokki transportation route', 'Active'),

(4, 4, 'October Route',
 'Main October transportation route', 'Active');
GO


/* =========================================================
   48. TransportStop
   ========================================================= */

INSERT INTO TransportStop
(
    stop_id,
    route_id,
    name,
    address,
    sequence_no,
    latitude,
    longitude
)
VALUES
(1, 1, 'Nasr City Stop 1', 'Nasr City', 1, 30.0626, 31.3407),
(2, 1, 'Nasr City Stop 2', 'Nasr City', 2, 30.0550, 31.3300),

(3, 2, 'New Cairo Stop 1', 'New Cairo', 1, 30.0300, 31.4700),
(4, 2, 'New Cairo Stop 2', 'New Cairo', 2, 30.0200, 31.4800),

(5, 3, 'Dokki Stop 1', 'Dokki', 1, 30.0380, 31.2110),
(6, 3, 'Dokki Stop 2', 'Dokki', 2, 30.0350, 31.2200),

(7, 4, 'October Stop 1', '6th of October', 1, 29.9770, 30.9500),
(8, 4, 'October Stop 2', '6th of October', 2, 29.9850, 30.9600);
GO


/* =========================================================
   49. TransportTrip
   ========================================================= */

INSERT INTO TransportTrip
(
    trip_id,
    route_id,
    bus_id,
    driver_id,
    supervisor_id,
    trip_date,
    trip_type,
    start_time,
    arrival_time,
    status
)
VALUES
(1, 1, 1, 1, 1, '2026-09-21',
 'Morning', '07:00:00', '08:00:00', 'Completed'),

(2, 1, 1, 1, 1, '2026-09-21',
 'Afternoon', '15:00:00', '16:00:00', 'Completed'),

(3, 2, 2, 2, 2, '2026-09-21',
 'Morning', '07:00:00', '08:00:00', 'Completed'),

(4, 3, 3, 3, 3, '2026-09-21',
 'Morning', '07:00:00', '08:00:00', 'Completed'),

(5, 4, 4, 4, 4, '2026-09-21',
 'Morning', '07:00:00', '08:00:00', 'Completed');
GO


/* =========================================================
   50. TripChild
   ========================================================= */

INSERT INTO TripChild
(
    trip_child_id,
    trip_id,
    child_id,
    boarding_status,
    boarding_time,
    arrival_time,
    pickup_time
)
VALUES
(1, 1, 1, 'Boarded',
 '2026-09-21 07:10:00',
 '2026-09-21 07:50:00',
 NULL),

(2, 1, 2, 'Boarded',
 '2026-09-21 07:15:00',
 '2026-09-21 07:55:00',
 NULL),

(3, 2, 1, 'Boarded',
 '2026-09-21 15:00:00',
 '2026-09-21 15:50:00',
 '2026-09-21 15:55:00'),

(4, 2, 2, 'Boarded',
 '2026-09-21 15:05:00',
 '2026-09-21 15:55:00',
 '2026-09-21 16:00:00'),

(5, 3, 3, 'Boarded',
 '2026-09-21 07:10:00',
 '2026-09-21 07:55:00',
 NULL),

(6, 4, 5, 'Boarded',
 '2026-09-21 07:10:00',
 '2026-09-21 07:50:00',
 NULL),

(7, 5, 7, 'Boarded',
 '2026-09-21 07:15:00',
 '2026-09-21 07:55:00',
 NULL);
GO


/* =========================================================
   51. ChildTransportStop
   ========================================================= */

INSERT INTO ChildTransportStop
(
    child_transport_stop_id,
    child_id,
    stop_id,
    stop_type,
    start_date,
    end_date,
    status
)
VALUES
(1, 1, 1, 'Pickup',
 '2026-09-01', NULL, 'Active'),

(2, 2, 2, 'Pickup',
 '2026-09-01', NULL, 'Active'),

(3, 3, 3, 'Pickup',
 '2026-09-01', NULL, 'Active'),

(4, 5, 5, 'Pickup',
 '2026-09-01', NULL, 'Active'),

(5, 7, 7, 'Pickup',
 '2026-09-01', NULL, 'Active');
GO


/* =========================================================
   52. Event
   ========================================================= */

INSERT INTO Event
(
    event_id,
    branch_id,
    name,
    description,
    event_date,
    start_time,
    end_time,
    location,
    cost,
    status
)
VALUES
(1, 1, 'Family Day',
 'Family activities and games',
 '2026-09-25',
 '10:00:00',
 '14:00:00',
 'Nursery Garden',
 100.00,
 'Scheduled'),

(2, 2, 'Art Exhibition',
 'Children art exhibition',
 '2026-09-28',
 '10:00:00',
 '13:00:00',
 'Main Hall',
 50.00,
 'Scheduled'),

(3, 3, 'Science Day',
 'Simple science experiments',
 '2026-09-29',
 '09:30:00',
 '12:30:00',
 'Science Room',
 75.00,
 'Scheduled');
GO


/* =========================================================
   53. EventRegistration
   ========================================================= */

INSERT INTO EventRegistration
(
    registration_id,
    event_id,
    child_id,
    confirmation_status
)
VALUES
(1, 1, 1, 'Confirmed'),
(2, 1, 2, 'Confirmed'),
(3, 2, 3, 'Confirmed'),
(4, 3, 5, 'Confirmed');
GO


/* =========================================================
   54. EventAttendance
   ========================================================= */

INSERT INTO EventAttendance
(
    event_attendance_id,
    registration_id,
    attendance_status,
    recorded_at
)
VALUES
(1, 1, 'Present', '2026-09-25 10:15:00'),
(2, 2, 'Present', '2026-09-25 10:20:00');
GO


/* =========================================================
   55. NotificationType
   ========================================================= */

INSERT INTO NotificationType
(
    notification_type_id,
    name,
    description,
    is_enabled
)
VALUES
(1, 'Attendance',
 'Attendance notifications', 1),

(2, 'Payment',
 'Payment and invoice notifications', 1),

(3, 'Event',
 'Event notifications', 1),

(4, 'Health',
 'Health and incident notifications', 1),

(5, 'General',
 'General nursery notifications', 1);
GO


/* =========================================================
   56. Notification
   ========================================================= */

INSERT INTO Notification
(
    notification_id,
    notification_type_id,
    title,
    message,
    status
)
VALUES
(1, 1,
 'Late Arrival',
 'Your child arrived late today.',
 'Sent'),

(2, 2,
 'Payment Received',
 'Your payment has been received successfully.',
 'Sent'),

(3, 3,
 'Upcoming Event',
 'Family Day is scheduled soon.',
 'Sent'),

(4, 4,
 'Incident Notification',
 'A minor incident was recorded and the guardian was notified.',
 'Sent'),

(5, 5,
 'General Announcement',
 'The nursery has published a new announcement.',
 'Sent');
GO


/* =========================================================
   57. NotificationDelivery
   ========================================================= */

INSERT INTO NotificationDelivery
(
    delivery_id,
    notification_id,
    account_id,
    sent_at,
    delivered_at,
    read_at,
    delivery_status
)
VALUES
(1, 1, 8,
 '2026-09-21 09:00:00',
 '2026-09-21 09:00:10',
 '2026-09-21 09:05:00',
 'Read'),

(2, 2, 6,
 '2026-09-21 12:00:00',
 '2026-09-21 12:00:05',
 '2026-09-21 12:10:00',
 'Read'),

(3, 3, 6,
 '2026-09-22 10:00:00',
 '2026-09-22 10:00:05',
 NULL,
 'Delivered'),

(4, 4, 8,
 '2026-09-22 11:00:00',
 '2026-09-22 11:00:05',
 '2026-09-22 11:15:00',
 'Read'),

(5, 5, 7,
 '2026-09-23 09:00:00',
 '2026-09-23 09:00:05',
 NULL,
 'Delivered');
GO


/* =========================================================
   58. Holiday
   ========================================================= */

INSERT INTO Holiday
(
    holiday_id,
    branch_id,
    name,
    start_date,
    end_date,
    description,
    status
)
VALUES
(1, 1, 'Mid-Year Holiday',
 '2026-12-25',
 '2026-12-27',
 'Nursery holiday',
 'Active'),

(2, 2, 'Mid-Year Holiday',
 '2026-12-25',
 '2026-12-27',
 'Nursery holiday',
 'Active'),

(3, 3, 'Mid-Year Holiday',
 '2026-12-25',
 '2026-12-27',
 'Nursery holiday',
 'Active'),

(4, 4, 'Mid-Year Holiday',
 '2026-12-25',
 '2026-12-27',
 'Nursery holiday',
 'Active');
GO


/* =========================================================
   59. WorkingHour
   ========================================================= */

INSERT INTO WorkingHour
(
    working_hour_id,
    branch_id,
    day_of_week,
    open_time,
    close_time,
    is_working_day
)
VALUES
(1, 1, 1, '07:00:00', '16:00:00', 1),
(2, 1, 2, '07:00:00', '16:00:00', 1),
(3, 1, 3, '07:00:00', '16:00:00', 1),
(4, 1, 4, '07:00:00', '16:00:00', 1),
(5, 1, 5, '07:00:00', '16:00:00', 1),
(6, 1, 6, NULL, NULL, 0),
(7, 1, 7, NULL, NULL, 0),

(8, 2, 1, '07:00:00', '16:00:00', 1),
(9, 2, 2, '07:00:00', '16:00:00', 1),
(10, 2, 3, '07:00:00', '16:00:00', 1),
(11, 2, 4, '07:00:00', '16:00:00', 1),
(12, 2, 5, '07:00:00', '16:00:00', 1),
(13, 2, 6, NULL, NULL, 0),
(14, 2, 7, NULL, NULL, 0),

(15, 3, 1, '07:00:00', '16:00:00', 1),
(16, 3, 2, '07:00:00', '16:00:00', 1),
(17, 3, 3, '07:00:00', '16:00:00', 1),
(18, 3, 4, '07:00:00', '16:00:00', 1),
(19, 3, 5, '07:00:00', '16:00:00', 1),
(20, 3, 6, NULL, NULL, 0),
(21, 3, 7, NULL, NULL, 0),

(22, 4, 1, '07:00:00', '16:00:00', 1),
(23, 4, 2, '07:00:00', '16:00:00', 1),
(24, 4, 3, '07:00:00', '16:00:00', 1),
(25, 4, 4, '07:00:00', '16:00:00', 1),
(26, 4, 5, '07:00:00', '16:00:00', 1),
(27, 4, 6, NULL, NULL, 0),
(28, 4, 7, NULL, NULL, 0);
GO


/* =========================================================
   60. NurserySetting
   ========================================================= */

INSERT INTO NurserySetting
(
    setting_id,
    nursery_id,
    setting_key,
    setting_value
)
VALUES
(1, 1, 'Currency', 'EGP'),
(2, 1, 'LateCheckInMinutes', '15'),
(3, 1, 'AllowOnlinePayment', 'true'),

(4, 2, 'Currency', 'EGP'),
(5, 2, 'LateCheckInMinutes', '15'),
(6, 2, 'AllowOnlinePayment', 'true');
GO


/* =========================================================
   61. BranchSetting
   ========================================================= */

INSERT INTO BranchSetting
(
    branch_setting_id,
    branch_id,
    setting_key,
    setting_value
)
VALUES
(1, 1, 'DefaultClassCapacity', '20'),
(2, 1, 'PickupNotificationEnabled', 'true'),

(3, 2, 'DefaultClassCapacity', '20'),
(4, 2, 'PickupNotificationEnabled', 'true'),

(5, 3, 'DefaultClassCapacity', '20'),
(6, 3, 'PickupNotificationEnabled', 'true'),

(7, 4, 'DefaultClassCapacity', '20'),
(8, 4, 'PickupNotificationEnabled', 'true');
GO


/* =========================================================
   62. AuditLog
   ========================================================= */

INSERT INTO AuditLog
(
    audit_id,
    account_id,
    action,
    entity_name,
    entity_id,
    old_value,
    new_value,
    action_date,
    ip_address
)
VALUES
(1, 1,
 'CREATE',
 'Child',
 1,
 NULL,
 'Child Adam Mohamed created',
 '2026-09-01 09:00:00',
 '192.168.1.10'),

(2, 1,
 'UPDATE',
 'Child',
 1,
 'Status=Pending',
 'Status=Active',
 '2026-09-01 09:10:00',
 '192.168.1.10'),

(3, 4,
 'CREATE',
 'Invoice',
 1,
 NULL,
 'Invoice created',
 '2026-09-01 10:00:00',
 '192.168.1.20'),

(4, 4,
 'CREATE',
 'Payment',
 1,
 NULL,
 'Payment recorded',
 '2026-09-05 10:00:00',
 '192.168.1.20'),

(5, 2,
 'CREATE',
 'DailyAssessment',
 1,
 NULL,
 'Daily assessment created',
 '2026-09-21 12:00:00',
 '192.168.1.30');
GO


/* =========================================================
   VERIFICATION
   ========================================================= */

SELECT 'Nursery' AS TableName, COUNT(*) AS RowCount FROM Nursery
UNION ALL
SELECT 'Branch', COUNT(*) FROM Branch
UNION ALL
SELECT 'Staff', COUNT(*) FROM Staff
UNION ALL
SELECT 'Guardian', COUNT(*) FROM Guardian
UNION ALL
SELECT 'UserAccount', COUNT(*) FROM UserAccount
UNION ALL
SELECT 'Role', COUNT(*) FROM Role
UNION ALL
SELECT 'Permission', COUNT(*) FROM Permission
UNION ALL
SELECT 'Child', COUNT(*) FROM Child
UNION ALL
SELECT 'AcademicYear', COUNT(*) FROM AcademicYear
UNION ALL
SELECT 'Class', COUNT(*) FROM Class
UNION ALL
SELECT 'Enrollment', COUNT(*) FROM Enrollment
UNION ALL
SELECT 'Attendance', COUNT(*) FROM Attendance
UNION ALL
SELECT 'Invoice', COUNT(*) FROM Invoice
UNION ALL
SELECT 'Payment', COUNT(*) FROM Payment
UNION ALL
SELECT 'Bus', COUNT(*) FROM Bus
UNION ALL
SELECT 'TransportTrip', COUNT(*) FROM TransportTrip
UNION ALL
SELECT 'Event', COUNT(*) FROM Event
UNION ALL
SELECT 'Notification', COUNT(*) FROM Notification
UNION ALL
SELECT 'AuditLog', COUNT(*) FROM AuditLog;
GO
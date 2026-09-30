USE Hadanty;
GO

-- Required by filtered indexes (SSMS has it ON by default, sqlcmd does not)
SET QUOTED_IDENTIFIER ON;
GO

/* =========================================================
   13_Seed_Data.sql
   Demo data. Every relationship is consistent on purpose:

   Nursery 1  Little Stars   branches 1, 2   children 1, 2, 3
   Nursery 2  Happy Kids     branches 3, 4   children 4 to 8

   Guardian 1 Mohamed  -> children 1, 2     Guardian 2 Sara    -> child 3
   Guardian 3 Khaled   -> children 4, 5     Guardian 4 Mariam  -> child 6
   Guardian 5 Youssef  -> children 7, 8

   "Late" rule used here: check-in after branch open time (08:00)
   plus LateCheckInMinutes (15) = after 08:15.

   Explicit IDs are inserted, so each table with an IDENTITY key
   is wrapped in SET IDENTITY_INSERT ON / OFF.
   ========================================================= */


/* =========================================================
   1. Nursery
   ========================================================= */
SET IDENTITY_INSERT Nursery ON;
INSERT INTO Nursery
(nursery_id, name, owner_name, commercial_registration_no, tax_number, address, phone, status)
VALUES
(1, 'Little Stars Nursery', 'Ahmed Ali',    'CR1001', 'TAX1001', 'Nasr City, Cairo', '01000000001', 'Active'),
(2, 'Happy Kids Nursery',   'Sara Mohamed', 'CR1002', 'TAX1002', 'Giza',             '01000000002', 'Active');
SET IDENTITY_INSERT Nursery OFF;
GO


/* =========================================================
   2. Branch
   ========================================================= */
SET IDENTITY_INSERT Branch ON;
INSERT INTO Branch
(branch_id, nursery_id, name, address, phone, status)
VALUES
(1, 1, 'Little Stars - Main Branch', 'Nasr City, Cairo',      '01000000101', 'Active'),
(2, 1, 'Little Stars - New Cairo',   'New Cairo, Cairo',      '01000000102', 'Active'),
(3, 2, 'Happy Kids - Main Branch',   'Dokki, Giza',           '01000000201', 'Active'),
(4, 2, 'Happy Kids - October',       '6th of October, Giza',  '01000000202', 'Active');
SET IDENTITY_INSERT Branch OFF;
GO


/* =========================================================
   3. Staff   (one nursery each; branches set in StaffBranch)
   ========================================================= */
SET IDENTITY_INSERT Staff ON;
INSERT INTO Staff
(staff_id, nursery_id, first_name, last_name, national_id, phone, email, specialization, qualification, hire_date, employment_status)
VALUES
(1, 1, 'Ahmed', 'Hassan',  '29001011234567', '01010000001', 'ahmed.hassan@hadanty.demo',  'Manager',       'BBA',                       '2022-01-15', 'Active'),
(2, 1, 'Mona',  'Ali',     '29502021234567', '01010000002', 'mona.ali@hadanty.demo',      'Teacher',       'Early Childhood Education', '2023-02-01', 'Active'),
(3, 1, 'Nour',  'Mohamed', '29803031234567', '01010000003', 'nour.mohamed@hadanty.demo',  'Teacher',       'Education',                 '2023-09-10', 'Active'),
(4, 2, 'Omar',  'Ibrahim', '29204041234567', '01010000004', 'omar.ibrahim@hadanty.demo',  'Administrator', 'Commerce',                  '2021-06-20', 'Active'),
(5, 2, 'Aya',   'Mahmoud', '30005051234567', '01010000005', 'aya.mahmoud@hadanty.demo',   'Nanny',         'Child Care',                '2024-01-05', 'Active'),
(6, 2, 'Hana',  'Samy',    '29906061234567', '01010000006', 'hana.samy@hadanty.demo',     'Teacher',       'Early Childhood Education', '2024-08-15', 'Active');
SET IDENTITY_INSERT Staff OFF;
GO


/* =========================================================
   4. Guardian
   ========================================================= */
SET IDENTITY_INSERT Guardian ON;
INSERT INTO Guardian
(guardian_id, nursery_id, first_name, last_name, phone, email, address, status)
VALUES
(1, 1, 'Mohamed', 'Adel',    '01110000001', 'mohamed.adel@hadanty.demo',    'Nasr City, Cairo',      'Active'),
(2, 1, 'Sara',    'Hassan',  '01110000002', 'sara.hassan@hadanty.demo',     'New Cairo, Cairo',      'Active'),
(3, 2, 'Khaled',  'Mahmoud', '01110000003', 'khaled.mahmoud@hadanty.demo',  'Dokki, Giza',           'Active'),
(4, 2, 'Mariam',  'Ali',     '01110000004', 'mariam.ali@hadanty.demo',      '6th of October, Giza',  'Active'),
(5, 2, 'Youssef', 'Ibrahim', '01110000005', 'youssef.ibrahim@hadanty.demo', '6th of October, Giza',  'Active');
SET IDENTITY_INSERT Guardian OFF;
GO


/* =========================================================
   5. UserAccount   (accounts 1-5 and 11 staff, 6-10 guardians)
   ========================================================= */
SET IDENTITY_INSERT UserAccount ON;
INSERT INTO UserAccount
(account_id, account_type, staff_id, guardian_id, username, password_hash, is_active, last_login_at)
VALUES
(1,  'Staff',    1, NULL, 'ahmed.manager',    'HASHED_DEMO_PASSWORD_1',  1, '2026-09-20 09:00:00'),
(2,  'Staff',    2, NULL, 'mona.teacher',     'HASHED_DEMO_PASSWORD_2',  1, '2026-09-21 08:30:00'),
(3,  'Staff',    3, NULL, 'nour.teacher',     'HASHED_DEMO_PASSWORD_3',  1, '2026-09-21 08:45:00'),
(4,  'Staff',    4, NULL, 'omar.admin',       'HASHED_DEMO_PASSWORD_4',  1, '2026-09-19 10:00:00'),
(5,  'Staff',    5, NULL, 'aya.nanny',        'HASHED_DEMO_PASSWORD_5',  1, '2026-09-18 07:45:00'),
(6,  'Guardian', NULL, 1, 'mohamed.guardian', 'HASHED_DEMO_PASSWORD_6',  1, '2026-09-20 17:30:00'),
(7,  'Guardian', NULL, 2, 'sara.guardian',    'HASHED_DEMO_PASSWORD_7',  1, '2026-09-20 18:00:00'),
(8,  'Guardian', NULL, 3, 'khaled.guardian',  'HASHED_DEMO_PASSWORD_8',  1, '2026-09-20 18:15:00'),
(9,  'Guardian', NULL, 4, 'mariam.guardian',  'HASHED_DEMO_PASSWORD_9',  1, '2026-09-20 19:00:00'),
(10, 'Guardian', NULL, 5, 'youssef.guardian', 'HASHED_DEMO_PASSWORD_10', 1, NULL),
(11, 'Staff',    6, NULL, 'hana.teacher',     'HASHED_DEMO_PASSWORD_11', 1, '2026-09-21 08:20:00');
SET IDENTITY_INSERT UserAccount OFF;
GO


/* =========================================================
   6. Role   (platform-wide)
   ========================================================= */
SET IDENTITY_INSERT Role ON;
INSERT INTO Role (role_id, name, description, status)
VALUES
(1, 'Owner',         'Full nursery management access',            'Active'),
(2, 'Manager',       'Branch and staff management access',        'Active'),
(3, 'Teacher',       'Class, attendance and assessment access',   'Active'),
(4, 'Administrator', 'Administrative and financial access',       'Active'),
(5, 'Nanny',         'Child care and daily activity access',      'Active'),
(6, 'Guardian',      'Read-only access to own children, plus pay, upload payment proof and confirm events', 'Active');
SET IDENTITY_INSERT Role OFF;
GO


/* =========================================================
   7. Permission   (platform-wide)
   21 to 32 were added after the production review.
   ========================================================= */
SET IDENTITY_INSERT Permission ON;
INSERT INTO Permission (permission_id, name, description, module)
VALUES
(1,  'ViewChildren',          'View children information',                 'Children'),
(2,  'ManageChildren',        'Create and update children information',    'Children'),
(3,  'ViewAttendance',        'View attendance records',                   'Attendance'),
(4,  'ManageAttendance',      'Create and update attendance records',      'Attendance'),
(5,  'ViewAssessments',       'View assessments',                          'Assessment'),
(6,  'ManageAssessments',     'Create and update assessments',             'Assessment'),
(7,  'ViewInvoices',          'View invoices',                             'Finance'),
(8,  'ManageInvoices',        'Create and update invoices',                'Finance'),
(9,  'ViewPayments',          'View payments',                             'Finance'),
(10, 'ManagePayments',        'Manage payments',                           'Finance'),
(11, 'ManageStaff',           'Manage staff information',                  'Staff'),
(12, 'ManageBranches',        'Manage branches',                           'Branches'),
(13, 'ViewReports',           'View reports',                              'Reports'),
(14, 'ManageTransportation',  'Manage transportation',                     'Transportation'),
(15, 'ViewEvents',            'View events',                               'Events'),
(16, 'ManageEvents',          'Manage events',                             'Events'),
(17, 'ViewNotifications',     'View notifications',                        'Notifications'),
(18, 'ManageSettings',        'Manage nursery settings',                   'Settings'),
(19, 'ViewHealthRecords',     'View child health records',                 'Health'),
(20, 'ManageHealthRecords',   'Manage child health records',               'Health'),
(21, 'ManageDiscounts',       'Create, edit and cancel discounts',         'Finance'),
(22, 'ProcessRefunds',        'Create and approve refunds',                'Finance'),
(23, 'ManagePickup',          'Record pickups and approve early or exception pickups', 'Pickup'),
(24, 'ManageIncidents',       'Record and update incidents',               'Health'),
(25, 'ManageRoles',           'Manage roles and permissions',              'Security'),
(26, 'ManageAcademicYears',   'Manage academic years and holidays',        'Academic'),
(27, 'ManageClasses',         'Manage classes and class staff',            'Academic'),
(28, 'ViewAuditLog',          'View the audit log',                        'Security'),
(29, 'MakePayment',           'Pay invoices electronically (guardian)',    'Finance'),
(30, 'SubmitPaymentProof',    'Upload manual payment proof (guardian)',    'Finance'),
(31, 'ConfirmEventAttendance','Confirm attendance at an event (guardian)', 'Events'),
(32, 'ManageEnrollments',     'Enroll, re-enroll and transfer children',   'Academic');
SET IDENTITY_INSERT Permission OFF;
GO


/* =========================================================
   8. StaffBranch   (a staff member works only in branches of
      their own nursery)
   ========================================================= */
INSERT INTO StaffBranch (staff_id, branch_id)
VALUES
(1, 1), (1, 2),
(2, 1),
(3, 2),
(4, 3), (4, 4),
(5, 3), (5, 4),
(6, 3), (6, 4);
GO


/* =========================================================
   9. AccountRole   (branch must be one the staff works in;
      guardian branch = the branch their children attend)
   ========================================================= */
INSERT INTO AccountRole (account_id, role_id, branch_id)
VALUES
(1, 2, 1), (1, 2, 2),
(2, 3, 1),
(3, 3, 2),
(4, 4, 3), (4, 4, 4),
(5, 5, 3), (5, 5, 4),
(11, 3, 3), (11, 3, 4),
(6, 6, 1),
(7, 6, 2),
(8, 6, 3),
(9, 6, 4),
(10, 6, 4);
GO


/* =========================================================
   10. RolePermission
   ========================================================= */
INSERT INTO RolePermission (role_id, permission_id)
VALUES
-- Owner: everything a nursery staff role can do (not the guardian-only actions)
(1, 1),(1, 2),(1, 3),(1, 4),(1, 5),(1, 6),(1, 7),(1, 8),(1, 9),(1, 10),
(1, 11),(1, 12),(1, 13),(1, 14),(1, 15),(1, 16),(1, 17),(1, 18),(1, 19),(1, 20),
(1, 21),(1, 22),(1, 23),(1, 24),(1, 25),(1, 26),(1, 27),(1, 28),(1, 32),

-- Manager
(2, 1),(2, 2),(2, 3),(2, 4),(2, 5),(2, 6),(2, 7),(2, 8),(2, 9),(2, 10),
(2, 11),(2, 13),(2, 14),(2, 15),(2, 16),(2, 17),(2, 19),(2, 20),
(2, 23),(2, 24),(2, 26),(2, 27),(2, 28),(2, 32),

-- Teacher
(3, 1),(3, 3),(3, 4),(3, 5),(3, 6),(3, 13),(3, 15),(3, 17),(3, 19),(3, 24),

-- Administrator
(4, 1),(4, 2),(4, 3),(4, 4),(4, 7),(4, 8),(4, 9),(4, 10),
(4, 13),(4, 15),(4, 16),(4, 17),
(4, 21),(4, 22),(4, 23),(4, 26),(4, 27),(4, 32),

-- Nanny
(5, 1),(5, 3),(5, 4),(5, 17),(5, 19),(5, 23),(5, 24),

-- Guardian: view own children's data + three explicit actions
(6, 1),(6, 3),(6, 5),(6, 7),(6, 9),(6, 13),(6, 15),(6, 17),(6, 19),
(6, 29),(6, 30),(6, 31);
GO


/* =========================================================
   11. Child   (ages fit nursery classes at 2026-09)
   ========================================================= */
SET IDENTITY_INSERT Child ON;
INSERT INTO Child
(child_id, nursery_id, first_name, last_name, national_id, date_of_birth, gender, status)
VALUES
(1, 1, 'Adam',    'Mohamed', '30201101000101', '2022-01-10', 'Male',   'Active'),
(2, 1, 'Lina',    'Mohamed', '30202151000202', '2022-02-15', 'Female', 'Active'),
(3, 1, 'Omar',    'Sara',    '30103201000303', '2021-03-20', 'Male',   'Active'),
(4, 2, 'Jana',    'Khaled',  '30204051000404', '2022-04-05', 'Female', 'Active'),
(5, 2, 'Youssef', 'Khaled',  '30105121000505', '2021-05-12', 'Male',   'Active'),
(6, 2, 'Maya',    'Mariam',  '30301181000606', '2023-01-18', 'Female', 'Active'),
(7, 2, 'Ali',     'Youssef', '30107251000707', '2021-07-25', 'Male',   'Active'),
(8, 2, 'Nour',    'Youssef', '30303301000808', '2023-03-30', 'Female', 'Active');
SET IDENTITY_INSERT Child OFF;
GO


/* =========================================================
   12. ChildGuardian
   ========================================================= */
INSERT INTO ChildGuardian (child_id, guardian_id)
VALUES
(1, 1), (2, 1),
(3, 2),
(4, 3), (5, 3),
(6, 4),
(7, 5), (8, 5);
GO


/* =========================================================
   13. AcademicYear
   ========================================================= */
SET IDENTITY_INSERT AcademicYear ON;
INSERT INTO AcademicYear
(academic_year_id, nursery_id, name, start_date, end_date, status)
VALUES
(1, 1, '2025-2026', '2025-09-01', '2026-06-30', 'Closed'),
(2, 2, '2025-2026', '2025-09-01', '2026-06-30', 'Closed'),
(3, 1, '2026-2027', '2026-09-01', '2027-06-30', 'Active'),
(4, 2, '2026-2027', '2026-09-01', '2027-06-30', 'Active');
SET IDENTITY_INSERT AcademicYear OFF;
GO


/* =========================================================
   14. Class
   ========================================================= */
SET IDENTITY_INSERT Class ON;
INSERT INTO Class
(class_id, branch_id, name, age_group, capacity, status)
VALUES
(1, 1, 'Butterflies',      '3-4 Years', 20, 'Active'),
(2, 1, 'Sunshine',         '4-5 Years', 20, 'Active'),
(3, 2, 'Stars',            '5-6 Years', 20, 'Active'),
(4, 2, 'Little Explorers', '3-4 Years', 15, 'Active'),
(5, 3, 'Rainbows',         '4-5 Years', 20, 'Active'),
(6, 3, 'Smart Kids',       '5-6 Years', 20, 'Active'),
(7, 4, 'Moon Class',       '3-4 Years', 15, 'Active'),
(8, 4, 'Future Stars',     '5-6 Years', 20, 'Active');
SET IDENTITY_INSERT Class OFF;
GO


/* =========================================================
   15. ClassStaff   (staff must work in the class's branch)
   ========================================================= */
INSERT INTO ClassStaff (class_id, staff_id)
VALUES
(2, 2),
(3, 3),
(5, 6), (5, 5),
(6, 6),
(7, 6), (7, 5),
(8, 6);
GO


/* =========================================================
   16. Enrollment
   Enrollment 9 is child 1's completed enrollment from last year.
   ========================================================= */
SET IDENTITY_INSERT Enrollment ON;
INSERT INTO Enrollment
(enrollment_id, nursery_id, child_id, academic_year_id, branch_id, enrollment_date, status)
VALUES
(1, 1, 1, 3, 1, '2026-09-01', 'Active'),
(2, 1, 2, 3, 1, '2026-09-01', 'Active'),
(3, 1, 3, 3, 2, '2026-09-02', 'Active'),
(4, 2, 4, 4, 3, '2026-09-01', 'Active'),
(5, 2, 5, 4, 3, '2026-09-01', 'Active'),
(6, 2, 6, 4, 4, '2026-09-03', 'Active'),
(7, 2, 7, 4, 4, '2026-09-03', 'Active'),
(8, 2, 8, 4, 4, '2026-09-03', 'Active'),
(9, 1, 1, 1, 1, '2025-09-01', 'Completed');
SET IDENTITY_INSERT Enrollment OFF;
GO


/* =========================================================
   17. ClassAssignment
   Child 2 moved from Butterflies to Sunshine on 2026-09-15:
   one Ended row (history) and one Active row (current).
   Enrollment 9 has one Ended row from last year.
   ========================================================= */
SET IDENTITY_INSERT ClassAssignment ON;
INSERT INTO ClassAssignment
(assignment_id, enrollment_id, class_id, branch_id, start_date, end_date, status)
VALUES
(1,  1, 2, 1, '2026-09-01', NULL,         'Active'),
(2,  2, 2, 1, '2026-09-15', NULL,         'Active'),
(3,  3, 3, 2, '2026-09-02', NULL,         'Active'),
(4,  4, 5, 3, '2026-09-01', NULL,         'Active'),
(5,  5, 6, 3, '2026-09-01', NULL,         'Active'),
(6,  6, 7, 4, '2026-09-03', NULL,         'Active'),
(7,  7, 8, 4, '2026-09-03', NULL,         'Active'),
(8,  8, 7, 4, '2026-09-03', NULL,         'Active'),
(9,  2, 1, 1, '2026-09-01', '2026-09-14', 'Ended'),
(10, 9, 1, 1, '2025-09-01', '2026-06-30', 'Ended');
SET IDENTITY_INSERT ClassAssignment OFF;
GO


/* =========================================================
   18. Subject   (platform-wide)
   ========================================================= */
SET IDENTITY_INSERT Subject ON;
INSERT INTO Subject (subject_id, name, description, status)
VALUES
(1, 'Arabic',      'Arabic language activities', 'Active'),
(2, 'English',     'English language activities', 'Active'),
(3, 'Mathematics', 'Basic mathematics',           'Active'),
(4, 'Science',     'Basic science activities',    'Active'),
(5, 'Art',         'Creative art activities',     'Active');
SET IDENTITY_INSERT Subject OFF;
GO


/* =========================================================
   19. Homework
   ========================================================= */
SET IDENTITY_INSERT Homework ON;
INSERT INTO Homework
(homework_id, class_id, title, description, assigned_date, due_date, status)
VALUES
(1, 2, 'Arabic Letters',   'Practice letters A to E',         '2026-09-20', '2026-09-22', 'Completed'),
(2, 2, 'Numbers Practice', 'Practice numbers 1 to 10',        '2026-09-21', '2026-09-24', 'Assigned'),
(3, 3, 'English Words',    'Learn five simple English words', '2026-09-20', '2026-09-23', 'Completed'),
(4, 5, 'Colors',           'Identify basic colors',           '2026-09-21', '2026-09-24', 'Assigned');
SET IDENTITY_INSERT Homework OFF;
GO


/* =========================================================
   20. Activity
   ========================================================= */
SET IDENTITY_INSERT Activity ON;
INSERT INTO Activity
(activity_id, class_id, name, description, activity_date, status)
VALUES
(1, 2, 'Drawing Day',        'Children draw their favorite animals', '2026-09-20', 'Completed'),
(2, 2, 'Story Time',         'Interactive story session',            '2026-09-21', 'Completed'),
(3, 3, 'Counting Game',      'Numbers and counting activity',        '2026-09-21', 'Completed'),
(4, 5, 'Science Experiment', 'Simple water experiment',              '2026-09-22', 'Completed'),
(5, 7, 'Music Time',         'Songs and movement',                   '2026-09-22', 'Completed');
SET IDENTITY_INSERT Activity OFF;
GO


/* =========================================================
   21. Attendance   (2026-09-21, a Monday, working day)
   Late = check-in after 08:15.
   Child 6 is Absent and has no check-in.
   ========================================================= */
SET IDENTITY_INSERT Attendance ON;
INSERT INTO Attendance (attendance_id, enrollment_id, child_id, attendance_date, status)
VALUES
(1, 1, 1, '2026-09-21', 'Present'),
(2, 2, 2, '2026-09-21', 'Present'),
(3, 3, 3, '2026-09-21', 'Late'),
(4, 4, 4, '2026-09-21', 'Present'),
(5, 5, 5, '2026-09-21', 'Present'),
(6, 6, 6, '2026-09-21', 'Absent'),
(7, 7, 7, '2026-09-21', 'Present'),
(8, 8, 8, '2026-09-21', 'Late');
SET IDENTITY_INSERT Attendance OFF;
GO


/* =========================================================
   22. CheckIn
   ========================================================= */
SET IDENTITY_INSERT CheckIn ON;
INSERT INTO CheckIn (check_in_id, attendance_id, check_in_time)
VALUES
(1, 1, '2026-09-21 08:05:00'),
(2, 2, '2026-09-21 08:10:00'),
(3, 3, '2026-09-21 08:35:00'),
(4, 4, '2026-09-21 08:00:00'),
(5, 5, '2026-09-21 08:15:00'),
(6, 7, '2026-09-21 07:55:00'),
(7, 8, '2026-09-21 08:40:00');
SET IDENTITY_INSERT CheckIn OFF;
GO


/* =========================================================
   23. CheckOut
   Children 1 and 2 leave by bus (trip 2 boards at 15:00 / 15:05).
   Child 4 leaves early with an early pickup at 13:30.
   ========================================================= */
SET IDENTITY_INSERT CheckOut ON;
INSERT INTO CheckOut (check_out_id, attendance_id, check_out_time)
VALUES
(1, 1, '2026-09-21 15:00:00'),
(2, 2, '2026-09-21 15:05:00'),
(3, 3, '2026-09-21 15:00:00'),
(4, 4, '2026-09-21 13:35:00'),
(5, 5, '2026-09-21 15:10:00'),
(6, 7, '2026-09-21 15:00:00'),
(7, 8, '2026-09-21 15:15:00');
SET IDENTITY_INSERT CheckOut OFF;
GO


/* =========================================================
   24. AuthorizedPickupPerson
   ========================================================= */
SET IDENTITY_INSERT AuthorizedPickupPerson ON;
INSERT INTO AuthorizedPickupPerson
(authorized_person_id, nursery_id, name, phone, relationship_type, identification_info, status)
VALUES
(1, 1, 'Mohamed Adel',    '01110000001', 'Father', 'ID-DEMO-001', 'Active'),
(2, 1, 'Sara Hassan',     '01110000002', 'Mother', 'ID-DEMO-002', 'Active'),
(3, 2, 'Khaled Mahmoud',  '01110000003', 'Father', 'ID-DEMO-003', 'Active'),
(4, 2, 'Mariam Ali',      '01110000004', 'Mother', 'ID-DEMO-004', 'Active'),
(5, 2, 'Youssef Ibrahim', '01110000005', 'Father', 'ID-DEMO-005', 'Active');
SET IDENTITY_INSERT AuthorizedPickupPerson OFF;
GO


/* =========================================================
   25. ChildAuthorizedPickup   (who may take which child)
   ========================================================= */
INSERT INTO ChildAuthorizedPickup (child_id, authorized_person_id)
VALUES
(1, 1), (2, 1),
(3, 2),
(4, 3), (5, 3),
(6, 4),
(7, 5), (8, 5);
GO


/* =========================================================
   26. Pickup
   Pickup 4: early pickup of child 4 (needs approval).
   Pickup 6: exception pickup, person NOT on the authorized list
             (authorized_person_id is NULL, name typed in, needs approval).
   The receiver is stored once: either the authorized person id
   or the typed name, never both.
   ========================================================= */
SET IDENTITY_INSERT Pickup ON;
INSERT INTO Pickup
(pickup_id, child_id, authorized_person_id, pickup_person_name, pickup_type, pickup_time, status)
VALUES
(1, 3, 2,    NULL,           'Regular',   '2026-09-21 15:00:00', 'Completed'),
(2, 5, 3,    NULL,           'Regular',   '2026-09-21 15:10:00', 'Completed'),
(3, 7, 5,    NULL,           'Regular',   '2026-09-21 15:00:00', 'Completed'),
(4, 4, 3,    NULL,           'Early',     '2026-09-21 13:30:00', 'Completed'),
(5, 8, 5,    NULL,           'Regular',   '2026-09-21 15:15:00', 'Completed'),
(6, 7, NULL, 'Hany Ibrahim', 'Exception', '2026-09-22 15:00:00', 'Completed');
SET IDENTITY_INSERT Pickup OFF;
GO


/* =========================================================
   27. PickupApproval   (staff member who approved; staff works
       in the child's branch)
   ========================================================= */
SET IDENTITY_INSERT PickupApproval ON;
INSERT INTO PickupApproval
(approval_id, pickup_id, approved_by_staff_id, approval_time, status)
VALUES
(1, 4, 4, '2026-09-21 13:20:00', 'Approved'),
(2, 6, 4, '2026-09-22 14:40:00', 'Approved');
SET IDENTITY_INSERT PickupApproval OFF;
GO


/* =========================================================
   28. DailyReport
   ========================================================= */
SET IDENTITY_INSERT DailyReport ON;
INSERT INTO DailyReport
(daily_report_id, child_id, report_date, food, sleep, mood, activities_notes, homework_notes, general_notes)
VALUES
(1, 1, '2026-09-21', 'Ate well',     'Good',    'Happy', 'Participated in drawing',         'Completed Arabic activity', 'Good day'),
(2, 2, '2026-09-21', 'Ate normally', 'Good',    'Happy', 'Participated in story time',      'Completed homework',        'Very active'),
(3, 3, '2026-09-21', 'Ate well',     'Average', 'Calm',  'Participated in counting game',   'Completed English homework','Arrived late'),
(4, 5, '2026-09-21', 'Ate well',     'Good',    'Happy', 'Participated in science activity','Completed colors activity', 'Good participation');
SET IDENTITY_INSERT DailyReport OFF;
GO


/* =========================================================
   29. DailyAssessment
   ========================================================= */
SET IDENTITY_INSERT DailyAssessment ON;
INSERT INTO DailyAssessment
(daily_assessment_id, child_id, subject_id, assessment_date, level, notes)
VALUES
(1, 1, 1, '2026-09-21', 'Excellent', 'Good letter recognition'),
(2, 1, 2, '2026-09-21', 'Good',      'Understands simple words'),
(3, 2, 1, '2026-09-21', 'Excellent', 'Very good participation'),
(4, 3, 3, '2026-09-21', 'Good',      'Understands basic numbers'),
(5, 5, 4, '2026-09-21', 'Excellent', 'Very curious');
SET IDENTITY_INSERT DailyAssessment OFF;
GO


/* =========================================================
   30. MonthlyAssessment
   ========================================================= */
SET IDENTITY_INSERT MonthlyAssessment ON;
INSERT INTO MonthlyAssessment
(monthly_assessment_id, child_id, subject_id, month, year, level, notes)
VALUES
(1, 1, 1, 9, 2026, 'Excellent', 'Strong Arabic development'),
(2, 1, 2, 9, 2026, 'Good',      'Good English progress'),
(3, 2, 1, 9, 2026, 'Excellent', 'Excellent participation'),
(4, 3, 3, 9, 2026, 'Good',      'Good mathematical skills'),
(5, 5, 4, 9, 2026, 'Excellent', 'Strong curiosity and participation');
SET IDENTITY_INSERT MonthlyAssessment OFF;
GO


/* =========================================================
   31. Media
   ========================================================= */
SET IDENTITY_INSERT Media ON;
INSERT INTO Media (media_id, child_id, file_url, file_type, status)
VALUES
(1, 1, 'https://demo.hadanty.local/media/child1.jpg', 'image', 'Active'),
(2, 2, 'https://demo.hadanty.local/media/child2.jpg', 'image', 'Active'),
(3, 3, 'https://demo.hadanty.local/media/child3.jpg', 'image', 'Active'),
(4, 5, 'https://demo.hadanty.local/media/child5.jpg', 'image', 'Active');
SET IDENTITY_INSERT Media OFF;
GO


/* =========================================================
   32. HealthRecord
   ========================================================= */
SET IDENTITY_INSERT HealthRecord ON;
INSERT INTO HealthRecord (health_record_id, child_id, medical_notes, emergency_notes)
VALUES
(1, 1, 'No major medical notes',      'Contact guardian if needed'),
(2, 2, 'No known medical conditions', 'Contact guardian in emergency'),
(3, 3, 'Seasonal allergy history',    'Keep guardian informed'),
(4, 5, 'No major medical notes',      'Contact guardian if needed');
SET IDENTITY_INSERT HealthRecord OFF;
GO


/* =========================================================
   33. Allergy
   ========================================================= */
SET IDENTITY_INSERT Allergy ON;
INSERT INTO Allergy (allergy_id, health_record_id, allergy_name, severity, notes, status)
VALUES
(1, 3, 'Dust',    'Mild',     'May cause sneezing',   'Active'),
(2, 3, 'Peanuts', 'Moderate', 'Avoid peanut products','Active');
SET IDENTITY_INSERT Allergy OFF;
GO


/* =========================================================
   34. Medication   (course ended 2026-09-25, so Completed)
   ========================================================= */
SET IDENTITY_INSERT Medication ON;
INSERT INTO Medication
(medication_id, health_record_id, medication_name, dosage, start_date, end_date, instructions, status)
VALUES
(1, 3, 'Demo Allergy Medication', '5 ml', '2026-09-20', '2026-09-25', 'Give after food if required', 'Completed');
SET IDENTITY_INSERT Medication OFF;
GO


/* =========================================================
   35. MedicationConsent
   ========================================================= */
SET IDENTITY_INSERT MedicationConsent ON;
INSERT INTO MedicationConsent (consent_id, medication_id, consent_date, status)
VALUES
(1, 1, '2026-09-20', 'Approved');
SET IDENTITY_INSERT MedicationConsent OFF;
GO


/* =========================================================
   36. Incident   (recorded by staff who work in the child's branch)
   ========================================================= */
SET IDENTITY_INSERT Incident ON;
INSERT INTO Incident
(incident_id, child_id, staff_id, incident_type, description, incident_date, action_taken, parent_notified)
VALUES
(1, 3, 3, 'Minor Fall',    'Child slipped while playing.', '2026-09-21 11:00:00', 'Checked child and applied basic first aid.', 1),
(2, 5, 6, 'Minor Scratch', 'Small scratch during activity.','2026-09-22 10:30:00', 'Cleaned the area and monitored child.',      1);
SET IDENTITY_INSERT Incident OFF;
GO


/* =========================================================
   37. FeeType   (platform-wide)
   ========================================================= */
SET IDENTITY_INSERT FeeType ON;
INSERT INTO FeeType (fee_type_id, name, description, status)
VALUES
(1, 'Registration Fee',   'New enrollment registration fee',    'Active'),
(2, 'Monthly Fee',        'Monthly nursery fee',                'Active'),
(3, 'Transportation Fee', 'Monthly transportation fee',         'Active'),
(4, 'Activities Fee',     'Activities and events fee',          'Active'),
(5, 'Books Fee',          'Books and educational material fee', 'Active'),
(6, 'Supplies Fee',       'School supplies fee',                'Active');
SET IDENTITY_INSERT FeeType OFF;
GO


/* =========================================================
   38. Discount   (per nursery)
   ========================================================= */
SET IDENTITY_INSERT Discount ON;
INSERT INTO Discount
(discount_id, nursery_id, name, discount_type, value, start_date, end_date, status)
VALUES
(1, 1, 'Sibling Discount',       'Percentage',  10.00, '2026-09-01', '2027-06-30', 'Active'),
(2, 1, 'Early Payment Discount', 'Fixed',      100.00, '2026-09-01', '2026-09-30', 'Active'),
(3, 1, 'Special Discount',       'Fixed',      150.00, '2026-09-01', '2026-09-30', 'Active'),
(4, 2, 'Early Payment Discount', 'Fixed',      100.00, '2026-09-01', '2026-09-30', 'Active');
SET IDENTITY_INSERT Discount OFF;
GO


/* =========================================================
   39. Invoice   (linked to the child's enrollment)
   Rules:  Item.total     = quantity * unit_amount - item discounts
           Invoice.total  = SUM(Item.total) - invoice-level discounts
           discount_total = item discounts + invoice-level discounts
   Each discount is applied at ONE level only.

   Invoice 1  item-level discount 100            total 1900  Paid
   Invoice 2  no discount                        total 2000  Paid
   Invoice 3  invoice-level discount 150         total 1850  PartiallyPaid (paid 1000)
   Invoice 4  items 2000 + 200, paid 2400,
              refunded 200 (overpayment)         total 2200  Paid
   Invoice 5  item-level discount 100            total 1900  Pending (a payment failed)
   ========================================================= */
SET IDENTITY_INSERT Invoice ON;
INSERT INTO Invoice
(invoice_id, enrollment_id, child_id, invoice_date, due_date, discount_total, total_amount, status)
VALUES
(1, 1, 1, '2026-09-01', '2026-09-10', 100.00, 1900.00, 'Paid'),
(2, 2, 2, '2026-09-01', '2026-09-10',   0.00, 2000.00, 'Paid'),
(3, 3, 3, '2026-09-02', '2026-09-12', 150.00, 1850.00, 'PartiallyPaid'),
(4, 5, 5, '2026-09-01', '2026-09-10',   0.00, 2200.00, 'Paid'),
(5, 7, 7, '2026-09-03', '2026-09-13', 100.00, 1900.00, 'Pending');
SET IDENTITY_INSERT Invoice OFF;
GO


/* =========================================================
   40. InvoiceItem
   ========================================================= */
SET IDENTITY_INSERT InvoiceItem ON;
INSERT INTO InvoiceItem
(invoice_item_id, invoice_id, fee_type_id, description, quantity, unit_amount, discount_amount, total_amount)
VALUES
(1, 1, 2, 'September Monthly Fee',      1, 2000.00, 100.00, 1900.00),
(2, 2, 2, 'September Monthly Fee',      1, 2000.00,   0.00, 2000.00),
(3, 3, 2, 'September Monthly Fee',      1, 2000.00,   0.00, 2000.00),
(4, 4, 2, 'September Monthly Fee',      1, 2000.00,   0.00, 2000.00),
(5, 4, 3, 'September Transportation',   1,  200.00,   0.00,  200.00),
(6, 5, 2, 'September Monthly Fee',      1, 2000.00, 100.00, 1900.00);
SET IDENTITY_INSERT InvoiceItem OFF;
GO


/* =========================================================
   41. InvoiceDiscount   (invoice-level discounts only)
   ========================================================= */
SET IDENTITY_INSERT InvoiceDiscount ON;
INSERT INTO InvoiceDiscount
(invoice_discount_id, invoice_id, discount_id, discount_amount)
VALUES
(1, 3, 3, 150.00);
SET IDENTITY_INSERT InvoiceDiscount OFF;
GO


/* =========================================================
   42. InvoiceItemDiscount   (item-level discounts only)
   ========================================================= */
SET IDENTITY_INSERT InvoiceItemDiscount ON;
INSERT INTO InvoiceItemDiscount
(invoice_item_discount_id, invoice_item_id, discount_id, discount_amount)
VALUES
(1, 1, 2, 100.00),
(2, 6, 4, 100.00);
SET IDENTITY_INSERT InvoiceItemDiscount OFF;
GO


/* =========================================================
   43. Payment
   Only status 'Completed' counts as money received.
   Payment 5 is waiting for review, payment 6 failed.
   ========================================================= */
SET IDENTITY_INSERT Payment ON;
INSERT INTO Payment
(payment_id, invoice_id, amount, payment_date, payment_method, transaction_number, status)
VALUES
(1, 1, 1900.00, '2026-09-05 10:00:00', 'Cash',         'TXN10001', 'Completed'),
(2, 2, 2000.00, '2026-09-05 11:00:00', 'BankTransfer', 'TXN10002', 'Completed'),
(3, 3, 1000.00, '2026-09-06 12:00:00', 'Cash',         'TXN10003', 'Completed'),
(4, 4, 2400.00, '2026-09-05 13:00:00', 'Card',         'TXN10004', 'Completed'),
(5, 3,  850.00, '2026-09-28 09:00:00', 'BankTransfer', 'TXN10005', 'Pending'),
(6, 5, 1900.00, '2026-09-10 16:00:00', 'BankTransfer', 'TXN10006', 'Failed');
SET IDENTITY_INSERT Payment OFF;
GO


/* =========================================================
   44. PaymentAttempt   (proof uploads and their review)
   ========================================================= */
SET IDENTITY_INSERT PaymentAttempt ON;
INSERT INTO PaymentAttempt
(attempt_id, payment_id, transaction_number, receipt_file_url, submitted_at, reviewed_at, status, rejection_reason)
VALUES
(1, 2, 'TXN10002', 'https://demo.hadanty.local/receipts/payment2.jpg', '2026-09-05 11:00:00', '2026-09-05 12:00:00', 'Approved', NULL),
(2, 4, 'TXN10004', 'https://demo.hadanty.local/receipts/payment4.jpg', '2026-09-05 13:00:00', '2026-09-05 14:00:00', 'Approved', NULL),
(3, 5, 'TXN10005', 'https://demo.hadanty.local/receipts/payment5.jpg', '2026-09-28 09:00:00', NULL,                  'Pending',  NULL),
(4, 6, 'TXN10006', 'https://demo.hadanty.local/receipts/payment6.jpg', '2026-09-10 16:00:00', '2026-09-11 09:00:00', 'Rejected', 'Transfer receipt is not readable');
SET IDENTITY_INSERT PaymentAttempt OFF;
GO


/* =========================================================
   45. Refund
   Payment 4 was 2400 against a 2200 invoice; 200 returned.
   ========================================================= */
SET IDENTITY_INSERT Refund ON;
INSERT INTO Refund (refund_id, payment_id, amount, reason, refund_date, status)
VALUES
(1, 4, 200.00, 'Overpayment returned to guardian', '2026-09-10 14:00:00', 'Completed');
SET IDENTITY_INSERT Refund OFF;
GO


/* =========================================================
   46. Receipt   (one per Completed payment)
   ========================================================= */
SET IDENTITY_INSERT Receipt ON;
INSERT INTO Receipt
(receipt_id, payment_id, receipt_number, issued_at)
VALUES
(1, 1, 'REC10001', '2026-09-05 10:05:00'),
(2, 2, 'REC10002', '2026-09-05 12:05:00'),
(3, 3, 'REC10003', '2026-09-06 12:05:00'),
(4, 4, 'REC10004', '2026-09-05 14:05:00');
SET IDENTITY_INSERT Receipt OFF;
GO


/* =========================================================
   47. Bus
   ========================================================= */
SET IDENTITY_INSERT Bus ON;
INSERT INTO Bus (bus_id, branch_id, bus_number, license_plate, capacity, status)
VALUES
(1, 1, 'BUS-01', 'ABC-1001', 25, 'Active'),
(2, 2, 'BUS-02', 'ABC-1002', 20, 'Active'),
(3, 3, 'BUS-03', 'ABC-1003', 25, 'Active'),
(4, 4, 'BUS-04', 'ABC-1004', 20, 'Active');
SET IDENTITY_INSERT Bus OFF;
GO


/* =========================================================
   48. Driver   (no UserAccount needed)
   ========================================================= */
SET IDENTITY_INSERT Driver ON;
INSERT INTO Driver (driver_id, branch_id, name, phone, license_number, status)
VALUES
(1, 1, 'Hassan Mahmoud', '01220000001', 'LIC1001', 'Active'),
(2, 2, 'Mostafa Ali',    '01220000002', 'LIC1002', 'Active'),
(3, 3, 'Ahmed Samir',    '01220000003', 'LIC1003', 'Active'),
(4, 4, 'Mahmoud Hassan', '01220000004', 'LIC1004', 'Active');
SET IDENTITY_INSERT Driver OFF;
GO


/* =========================================================
   49. BusSupervisor   (no UserAccount needed)
   ========================================================= */
SET IDENTITY_INSERT BusSupervisor ON;
INSERT INTO BusSupervisor (supervisor_id, branch_id, name, phone, status)
VALUES
(1, 1, 'Hoda Ahmed',   '01230000001', 'Active'),
(2, 2, 'Mai Hassan',   '01230000002', 'Active'),
(3, 3, 'Reem Ali',     '01230000003', 'Active'),
(4, 4, 'Dina Mohamed', '01230000004', 'Active');
SET IDENTITY_INSERT BusSupervisor OFF;
GO


/* =========================================================
   50. TransportRoute
   ========================================================= */
SET IDENTITY_INSERT TransportRoute ON;
INSERT INTO TransportRoute (route_id, branch_id, name, description, status)
VALUES
(1, 1, 'Nasr City Route',  'Main Nasr City transportation route',  'Active'),
(2, 2, 'New Cairo Route',  'Main New Cairo transportation route',  'Active'),
(3, 3, 'Dokki Route',      'Main Dokki transportation route',      'Active'),
(4, 4, 'October Route',    'Main October transportation route',    'Active');
SET IDENTITY_INSERT TransportRoute OFF;
GO


/* =========================================================
   51. TransportStop
   ========================================================= */
SET IDENTITY_INSERT TransportStop ON;
INSERT INTO TransportStop
(stop_id, route_id, name, address, sequence_no, latitude, longitude)
VALUES
(1, 1, 'Nasr City Stop 1',  'Nasr City',      1, 30.0626, 31.3407),
(2, 1, 'Nasr City Stop 2',  'Nasr City',      2, 30.0550, 31.3300),
(3, 2, 'New Cairo Stop 1',  'New Cairo',      1, 30.0300, 31.4700),
(4, 2, 'New Cairo Stop 2',  'New Cairo',      2, 30.0200, 31.4800),
(5, 3, 'Dokki Stop 1',      'Dokki',          1, 30.0380, 31.2110),
(6, 3, 'Dokki Stop 2',      'Dokki',          2, 30.0350, 31.2200),
(7, 4, 'October Stop 1',    '6th of October', 1, 29.9770, 30.9500),
(8, 4, 'October Stop 2',    '6th of October', 2, 29.9850, 30.9600);
SET IDENTITY_INSERT TransportStop OFF;
GO


/* =========================================================
   52. TransportTrip   (full date and time on every value)
   ========================================================= */
SET IDENTITY_INSERT TransportTrip ON;
INSERT INTO TransportTrip
(trip_id, branch_id, route_id, bus_id, driver_id, supervisor_id, trip_date, trip_type, start_time, arrival_time, status)
VALUES
(1, 1, 1, 1, 1, 1, '2026-09-21', 'Morning',   '2026-09-21 07:00:00', '2026-09-21 08:00:00', 'Completed'),
(2, 1, 1, 1, 1, 1, '2026-09-21', 'Afternoon', '2026-09-21 15:00:00', '2026-09-21 16:00:00', 'Completed'),
(3, 2, 2, 2, 2, 2, '2026-09-21', 'Morning',   '2026-09-21 07:00:00', '2026-09-21 08:00:00', 'Completed'),
(4, 3, 3, 3, 3, 3, '2026-09-21', 'Morning',   '2026-09-21 07:00:00', '2026-09-21 08:00:00', 'Completed'),
(5, 4, 4, 4, 4, 4, '2026-09-21', 'Morning',   '2026-09-21 07:00:00', '2026-09-21 08:00:00', 'Completed');
SET IDENTITY_INSERT TransportTrip OFF;
GO


/* =========================================================
   53. TripChild
   ========================================================= */
SET IDENTITY_INSERT TripChild ON;
INSERT INTO TripChild
(trip_child_id, trip_id, child_id, boarding_status, boarding_time, arrival_time, pickup_time)
VALUES
(1, 1, 1, 'Boarded', '2026-09-21 07:10:00', '2026-09-21 07:50:00', NULL),
(2, 1, 2, 'Boarded', '2026-09-21 07:15:00', '2026-09-21 07:55:00', NULL),
(3, 2, 1, 'Boarded', '2026-09-21 15:00:00', '2026-09-21 15:50:00', '2026-09-21 15:55:00'),
(4, 2, 2, 'Boarded', '2026-09-21 15:05:00', '2026-09-21 15:55:00', '2026-09-21 16:00:00'),
(5, 3, 3, 'Boarded', '2026-09-21 07:10:00', '2026-09-21 07:55:00', NULL),
(6, 4, 5, 'Boarded', '2026-09-21 07:10:00', '2026-09-21 07:50:00', NULL),
(7, 5, 7, 'Boarded', '2026-09-21 07:15:00', '2026-09-21 07:55:00', NULL);
SET IDENTITY_INSERT TripChild OFF;
GO


/* =========================================================
   54. ChildTransportStop
   ========================================================= */
SET IDENTITY_INSERT ChildTransportStop ON;
INSERT INTO ChildTransportStop
(child_transport_stop_id, child_id, stop_id, stop_type, start_date, end_date, status)
VALUES
(1, 1, 1, 'Both', '2026-09-01', NULL, 'Active'),
(2, 2, 2, 'Both', '2026-09-01', NULL, 'Active'),
(3, 3, 3, 'Pickup', '2026-09-01', NULL, 'Active'),
(4, 5, 5, 'Pickup', '2026-09-01', NULL, 'Active'),
(5, 7, 7, 'Pickup', '2026-09-01', NULL, 'Active');
SET IDENTITY_INSERT ChildTransportStop OFF;
GO


/* =========================================================
   55. Event   (past events are Completed, one is upcoming)
   ========================================================= */
SET IDENTITY_INSERT Event ON;
INSERT INTO Event
(event_id, branch_id, name, description, event_date, start_time, end_time, location, cost, status)
VALUES
(1, 1, 'Family Day',       'Family activities and games',   '2026-09-25', '10:00:00', '14:00:00', 'Nursery Garden', 100.00, 'Completed'),
(2, 2, 'Art Exhibition',   'Children art exhibition',       '2026-09-28', '10:00:00', '13:00:00', 'Main Hall',       50.00, 'Completed'),
(3, 3, 'Science Day',      'Simple science experiments',    '2026-09-29', '09:30:00', '12:30:00', 'Science Room',    75.00, 'Completed'),
(4, 1, 'Halloween Party',  'Costume party for children',    '2026-10-30', '10:00:00', '13:00:00', 'Nursery Garden',  60.00, 'Scheduled');
SET IDENTITY_INSERT Event OFF;
GO


/* =========================================================
   56. EventRegistration
   ========================================================= */
SET IDENTITY_INSERT EventRegistration ON;
INSERT INTO EventRegistration (registration_id, event_id, child_id, confirmation_status)
VALUES
(1, 1, 1, 'Confirmed'),
(2, 1, 2, 'Confirmed'),
(3, 2, 3, 'Confirmed'),
(4, 3, 5, 'Confirmed'),
(5, 4, 1, 'Pending');
SET IDENTITY_INSERT EventRegistration OFF;
GO


/* =========================================================
   57. EventAttendance   (registration 5 is for a future event)
   ========================================================= */
SET IDENTITY_INSERT EventAttendance ON;
INSERT INTO EventAttendance (event_attendance_id, registration_id, attendance_status, recorded_at)
VALUES
(1, 1, 'Present', '2026-09-25 10:15:00'),
(2, 2, 'Present', '2026-09-25 10:20:00'),
(3, 3, 'Present', '2026-09-28 10:10:00'),
(4, 4, 'Absent',  '2026-09-29 09:45:00');
SET IDENTITY_INSERT EventAttendance OFF;
GO


/* =========================================================
   58. NotificationType   (platform-wide)
   ========================================================= */
SET IDENTITY_INSERT NotificationType ON;
INSERT INTO NotificationType (notification_type_id, name, description, is_enabled)
VALUES
(1, 'Attendance', 'Attendance notifications',             1),
(2, 'Payment',    'Payment and invoice notifications',    1),
(3, 'Event',      'Event notifications',                  1),
(4, 'Health',     'Health and incident notifications',    1),
(5, 'General',    'General nursery notifications',        1);
SET IDENTITY_INSERT NotificationType OFF;
GO


/* =========================================================
   59. Notification   (each one is delivered to the guardian
       of the child it is about)
   ========================================================= */
SET IDENTITY_INSERT Notification ON;
INSERT INTO Notification
(notification_id, nursery_id, notification_type_id, child_id, title, message, status)
VALUES
(1, 1, 1, 3,    'Late Arrival',          'Your child arrived late today.',                              'Sent'),
(2, 1, 2, 1,    'Payment Received',      'Your payment has been received successfully.',                'Sent'),
(3, 1, 3, NULL, 'Upcoming Event',        'Family Day is scheduled soon.',                               'Sent'),
(4, 2, 4, 5,    'Incident Notification', 'A minor incident was recorded and the guardian was notified.','Sent'),
(5, 1, 5, NULL, 'General Announcement',  'The nursery has published a new announcement.',               'Sent');
SET IDENTITY_INSERT Notification OFF;
GO


/* =========================================================
   60. NotificationDelivery
   ========================================================= */
SET IDENTITY_INSERT NotificationDelivery ON;
INSERT INTO NotificationDelivery
(delivery_id, notification_id, account_id, sent_at, delivered_at, read_at, delivery_status)
VALUES
(1, 1, 7, '2026-09-21 09:00:00', '2026-09-21 09:00:10', '2026-09-21 09:05:00', 'Read'),
(2, 2, 6, '2026-09-21 12:00:00', '2026-09-21 12:00:05', '2026-09-21 12:10:00', 'Read'),
(3, 3, 6, '2026-09-22 10:00:00', '2026-09-22 10:00:05', NULL,                  'Delivered'),
(4, 4, 8, '2026-09-22 11:00:00', '2026-09-22 11:00:05', '2026-09-22 11:15:00', 'Read'),
(5, 5, 7, '2026-09-23 09:00:00', '2026-09-23 09:00:05', NULL,                  'Delivered');
SET IDENTITY_INSERT NotificationDelivery OFF;
GO


/* =========================================================
   61. Holiday
   ========================================================= */
SET IDENTITY_INSERT Holiday ON;
INSERT INTO Holiday (holiday_id, branch_id, name, start_date, end_date, description, status)
VALUES
(1, 1, 'Mid-Year Holiday', '2026-12-25', '2026-12-27', 'Nursery holiday', 'Active'),
(2, 2, 'Mid-Year Holiday', '2026-12-25', '2026-12-27', 'Nursery holiday', 'Active'),
(3, 3, 'Mid-Year Holiday', '2026-12-25', '2026-12-27', 'Nursery holiday', 'Active'),
(4, 4, 'Mid-Year Holiday', '2026-12-25', '2026-12-27', 'Nursery holiday', 'Active');
SET IDENTITY_INSERT Holiday OFF;
GO


/* =========================================================
   62. WorkingHour
   day_of_week follows ISO: 1 = Monday ... 7 = Sunday.
   Weekly off days are Friday (5) and Saturday (6).
   Opening time 08:00; with LateCheckInMinutes = 15, late is after 08:15.
   ========================================================= */
SET IDENTITY_INSERT WorkingHour ON;
INSERT INTO WorkingHour
(working_hour_id, branch_id, day_of_week, open_time, close_time, is_working_day)
VALUES
(1,  1, 1, '08:00:00', '16:00:00', 1), (2,  1, 2, '08:00:00', '16:00:00', 1),
(3,  1, 3, '08:00:00', '16:00:00', 1), (4,  1, 4, '08:00:00', '16:00:00', 1),
(5,  1, 5, NULL, NULL, 0),             (6,  1, 6, NULL, NULL, 0),
(7,  1, 7, '08:00:00', '16:00:00', 1),

(8,  2, 1, '08:00:00', '16:00:00', 1), (9,  2, 2, '08:00:00', '16:00:00', 1),
(10, 2, 3, '08:00:00', '16:00:00', 1), (11, 2, 4, '08:00:00', '16:00:00', 1),
(12, 2, 5, NULL, NULL, 0),             (13, 2, 6, NULL, NULL, 0),
(14, 2, 7, '08:00:00', '16:00:00', 1),

(15, 3, 1, '08:00:00', '16:00:00', 1), (16, 3, 2, '08:00:00', '16:00:00', 1),
(17, 3, 3, '08:00:00', '16:00:00', 1), (18, 3, 4, '08:00:00', '16:00:00', 1),
(19, 3, 5, NULL, NULL, 0),             (20, 3, 6, NULL, NULL, 0),
(21, 3, 7, '08:00:00', '16:00:00', 1),

(22, 4, 1, '08:00:00', '16:00:00', 1), (23, 4, 2, '08:00:00', '16:00:00', 1),
(24, 4, 3, '08:00:00', '16:00:00', 1), (25, 4, 4, '08:00:00', '16:00:00', 1),
(26, 4, 5, NULL, NULL, 0),             (27, 4, 6, NULL, NULL, 0),
(28, 4, 7, '08:00:00', '16:00:00', 1);
SET IDENTITY_INSERT WorkingHour OFF;
GO


/* =========================================================
   63. NurserySetting
   ========================================================= */
SET IDENTITY_INSERT NurserySetting ON;
INSERT INTO NurserySetting (setting_id, nursery_id, setting_key, setting_value)
VALUES
(1, 1, 'Currency',            'EGP'),
(2, 1, 'LateCheckInMinutes',  '15'),
(3, 1, 'AllowOnlinePayment',  'true'),
(4, 2, 'Currency',            'EGP'),
(5, 2, 'LateCheckInMinutes',  '15'),
(6, 2, 'AllowOnlinePayment',  'true');
SET IDENTITY_INSERT NurserySetting OFF;
GO


/* =========================================================
   64. BranchSetting
   ========================================================= */
SET IDENTITY_INSERT BranchSetting ON;
INSERT INTO BranchSetting (branch_setting_id, branch_id, setting_key, setting_value)
VALUES
(1, 1, 'DefaultClassCapacity',       '20'),
(2, 1, 'PickupNotificationEnabled',  'true'),
(3, 2, 'DefaultClassCapacity',       '20'),
(4, 2, 'PickupNotificationEnabled',  'true'),
(5, 3, 'DefaultClassCapacity',       '20'),
(6, 3, 'PickupNotificationEnabled',  'true'),
(7, 4, 'DefaultClassCapacity',       '20'),
(8, 4, 'PickupNotificationEnabled',  'true');
SET IDENTITY_INSERT BranchSetting OFF;
GO


/* =========================================================
   65. AuditLog   (account_id NULL = done by the System)
   ========================================================= */
SET IDENTITY_INSERT AuditLog ON;
INSERT INTO AuditLog
(audit_id, account_id, action, entity_name, entity_id, old_value, new_value, action_date, ip_address)
VALUES
(1, 1,    'CREATE',            'Child',           1, NULL,             'Child Adam Mohamed created',   '2026-09-01 09:00:00', '192.168.1.10'),
(2, 1,    'UPDATE',            'Child',           1, 'Status=Pending', 'Status=Active',                '2026-09-01 09:10:00', '192.168.1.10'),
(3, 1,    'CREATE',            'Invoice',         1, NULL,             'Invoice created',              '2026-09-01 10:00:00', '192.168.1.20'),
(4, 1,    'CREATE',            'Payment',         1, NULL,             'Payment recorded',             '2026-09-05 10:00:00', '192.168.1.20'),
(5, 2,    'CREATE',            'DailyAssessment', 1, NULL,             'Daily assessment created',     '2026-09-21 12:00:00', '192.168.1.30'),
(6, NULL, 'AUTO_MARK_ABSENT',  'Attendance',      6, NULL,             'Status=Absent',                '2026-09-21 08:30:00', NULL);
SET IDENTITY_INSERT AuditLog OFF;
GO


/* =========================================================
   VERIFICATION
   ========================================================= */
SELECT 'Nursery' AS TableName, COUNT(*) AS [RowCount] FROM Nursery
UNION ALL SELECT 'Branch',          COUNT(*) FROM Branch
UNION ALL SELECT 'Staff',           COUNT(*) FROM Staff
UNION ALL SELECT 'Guardian',        COUNT(*) FROM Guardian
UNION ALL SELECT 'UserAccount',     COUNT(*) FROM UserAccount
UNION ALL SELECT 'Child',           COUNT(*) FROM Child
UNION ALL SELECT 'ChildGuardian',   COUNT(*) FROM ChildGuardian
UNION ALL SELECT 'Class',           COUNT(*) FROM Class
UNION ALL SELECT 'Enrollment',      COUNT(*) FROM Enrollment
UNION ALL SELECT 'ClassAssignment', COUNT(*) FROM ClassAssignment
UNION ALL SELECT 'Attendance',      COUNT(*) FROM Attendance
UNION ALL SELECT 'Invoice',         COUNT(*) FROM Invoice
UNION ALL SELECT 'Payment',         COUNT(*) FROM Payment
UNION ALL SELECT 'Event',           COUNT(*) FROM Event
UNION ALL SELECT 'Notification',    COUNT(*) FROM Notification
UNION ALL SELECT 'AuditLog',        COUNT(*) FROM AuditLog;
GO

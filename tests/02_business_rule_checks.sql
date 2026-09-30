SET NOCOUNT ON;
PRINT '--- rows loaded'; SELECT (SELECT COUNT(*) FROM Child) children,(SELECT COUNT(*) FROM Enrollment) enrollments,(SELECT COUNT(*) FROM ClassAssignment) assignments,(SELECT COUNT(*) FROM Invoice) invoices,(SELECT COUNT(*) FROM ChildGuardian) child_guardian;
PRINT '--- Query 1: current children and current class (expect 8)';
SELECT c.first_name+' '+c.last_name AS child, cl.name AS class
FROM Child c JOIN Enrollment e ON e.child_id=c.child_id AND e.status='Active'
JOIN ClassAssignment ca ON ca.enrollment_id=e.enrollment_id AND ca.status='Active'
JOIN Class cl ON cl.class_id=ca.class_id ORDER BY cl.name,c.first_name;
PRINT '--- invoice total = items - invoice discounts (expect 0 rows)';
SELECT i.invoice_id FROM Invoice i
OUTER APPLY (SELECT SUM(total_amount) s FROM InvoiceItem WHERE invoice_id=i.invoice_id) it
OUTER APPLY (SELECT ISNULL(SUM(discount_amount),0) d FROM InvoiceDiscount WHERE invoice_id=i.invoice_id) idc
WHERE i.total_amount <> it.s - idc.d;
PRINT '--- invoice discount_total = item+invoice discounts (expect 0 rows)';
SELECT i.invoice_id FROM Invoice i
WHERE i.discount_total <> ISNULL((SELECT SUM(x.discount_amount) FROM InvoiceItemDiscount x JOIN InvoiceItem ii ON ii.invoice_item_id=x.invoice_item_id WHERE ii.invoice_id=i.invoice_id),0)+ISNULL((SELECT SUM(discount_amount) FROM InvoiceDiscount WHERE invoice_id=i.invoice_id),0);
PRINT '--- remaining per invoice = total - (completed payments - completed refunds)';
SELECT i.invoice_id,i.status,i.total_amount,
 ISNULL(p.paid,0)-ISNULL(r.ref,0) AS net_paid, i.total_amount-(ISNULL(p.paid,0)-ISNULL(r.ref,0)) AS remaining
FROM Invoice i
OUTER APPLY (SELECT SUM(amount) paid FROM Payment WHERE invoice_id=i.invoice_id AND status='Completed') p
OUTER APPLY (SELECT SUM(rf.amount) ref FROM Refund rf JOIN Payment py ON py.payment_id=rf.payment_id WHERE py.invoice_id=i.invoice_id AND rf.status='Completed') r;
PRINT '--- AccountRole branch not in StaffBranch for staff accounts (expect 0 rows)';
SELECT ar.account_id,ar.branch_id FROM AccountRole ar JOIN UserAccount u ON u.account_id=ar.account_id AND u.account_type='Staff'
WHERE NOT EXISTS (SELECT 1 FROM StaffBranch sb WHERE sb.staff_id=u.staff_id AND sb.branch_id=ar.branch_id);
PRINT '--- guardian AccountRole branch has none of their children enrolled there (expect 0 rows)';
SELECT ar.account_id,ar.branch_id FROM AccountRole ar JOIN UserAccount u ON u.account_id=ar.account_id AND u.account_type='Guardian'
WHERE NOT EXISTS (SELECT 1 FROM ChildGuardian cg JOIN Enrollment e ON e.child_id=cg.child_id AND e.status='Active' WHERE cg.guardian_id=u.guardian_id AND e.branch_id=ar.branch_id);
PRINT '--- ClassStaff staff not working in class branch (expect 0 rows)';
SELECT cs.class_id,cs.staff_id FROM ClassStaff cs JOIN Class c ON c.class_id=cs.class_id WHERE NOT EXISTS (SELECT 1 FROM StaffBranch sb WHERE sb.staff_id=cs.staff_id AND sb.branch_id=c.branch_id);
PRINT '--- Incident staff not working in child branch (expect 0 rows)';
SELECT i.incident_id FROM Incident i WHERE NOT EXISTS (SELECT 1 FROM Enrollment e JOIN StaffBranch sb ON sb.branch_id=e.branch_id WHERE e.child_id=i.child_id AND e.status='Active' AND sb.staff_id=i.staff_id);
PRINT '--- regular pickup by someone not authorized for that child (expect 0 rows)';
SELECT p.pickup_id FROM Pickup p WHERE p.authorized_person_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM ChildAuthorizedPickup x WHERE x.child_id=p.child_id AND x.authorized_person_id=p.authorized_person_id);
PRINT '--- early/exception pickup without approval (expect 0 rows)';
SELECT p.pickup_id FROM Pickup p WHERE (p.pickup_type<>'Regular' OR p.authorized_person_id IS NULL) AND NOT EXISTS (SELECT 1 FROM PickupApproval a WHERE a.pickup_id=p.pickup_id);
PRINT '--- late status consistent with check-in after 08:15 (expect 0 rows)';
SELECT a.attendance_id FROM Attendance a JOIN CheckIn ci ON ci.attendance_id=a.attendance_id
WHERE (a.status='Late' AND CAST(ci.check_in_time AS time) <= '08:15:00') OR (a.status<>'Late' AND CAST(ci.check_in_time AS time) > '08:15:00');
PRINT '--- checkout before checkin, or absent with checkin (expect 0 rows)';
SELECT a.attendance_id FROM Attendance a JOIN CheckIn ci ON ci.attendance_id=a.attendance_id LEFT JOIN CheckOut co ON co.attendance_id=a.attendance_id WHERE co.check_out_time<ci.check_in_time OR a.status='Absent';
PRINT '--- notification delivered to an account that is not a guardian of that child (expect 0 rows)';
SELECT nd.delivery_id FROM NotificationDelivery nd JOIN Notification n ON n.notification_id=nd.notification_id JOIN UserAccount u ON u.account_id=nd.account_id
WHERE n.child_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM ChildGuardian cg WHERE cg.child_id=n.child_id AND cg.guardian_id=u.guardian_id);
PRINT '--- child ages in years vs class age group (info)';
SELECT c.first_name, DATEDIFF(month,c.date_of_birth,'2026-09-21')/12.0 AS age, cl.age_group FROM Child c JOIN Enrollment e ON e.child_id=c.child_id AND e.status='Active' JOIN ClassAssignment ca ON ca.enrollment_id=e.enrollment_id AND ca.status='Active' JOIN Class cl ON cl.class_id=ca.class_id ORDER BY c.child_id;

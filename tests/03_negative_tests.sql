SET NOCOUNT ON; SET QUOTED_IDENTIFIER ON;
DECLARE @t TABLE(test NVARCHAR(90), result NVARCHAR(200));
DECLARE @sql NVARCHAR(MAX), @name NVARCHAR(90);
DECLARE c CURSOR FOR SELECT * FROM (VALUES
('2nd Active enrollment for child 1', 'INSERT INTO Enrollment(nursery_id,child_id,academic_year_id,branch_id,enrollment_date,status) VALUES(1,1,3,2,''2026-09-20'',''Active'')'),
('Enrollment child from nursery 1 into branch of nursery 2', 'INSERT INTO Enrollment(nursery_id,child_id,academic_year_id,branch_id,enrollment_date,status) VALUES(1,3,3,3,''2026-09-20'',''Pending'')'),
('Class assignment to a class in another branch', 'INSERT INTO ClassAssignment(enrollment_id,class_id,branch_id,start_date,status) VALUES(1,3,1,''2026-09-20'',''Ended'')'),
('2nd Active class for enrollment 1', 'INSERT INTO ClassAssignment(enrollment_id,class_id,branch_id,start_date,status) VALUES(1,1,1,''2026-09-20'',''Active'')'),
('Status typo (Actve)', 'UPDATE Enrollment SET status=''Actve'' WHERE enrollment_id=1'),
('NULL status', 'UPDATE Attendance SET status=NULL WHERE attendance_id=1'),
('2nd account for the same staff', 'INSERT INTO UserAccount(account_type,staff_id,username,password_hash) VALUES(''Staff'',1,''dup.staff'',''x'')'),
('Account owned by staff AND guardian', 'INSERT INTO UserAccount(account_type,staff_id,guardian_id,username,password_hash) VALUES(''Staff'',2,1,''both'',''x'')'),
('Duplicate child national id in same nursery', 'INSERT INTO Child(nursery_id,first_name,last_name,national_id,date_of_birth,gender) VALUES(1,''X'',''Y'',''30201101000101'',''2022-01-01'',''Male'')'),
('Invoice with mismatched child and enrollment', 'INSERT INTO Invoice(enrollment_id,child_id,invoice_date,total_amount) VALUES(1,2,''2026-09-20'',100)'),
('Notification about a child of another nursery', 'INSERT INTO Notification(nursery_id,notification_type_id,child_id,title,message) VALUES(2,1,1,''t'',''m'')'),
('Duplicate attendance for same child and day', 'INSERT INTO Attendance(enrollment_id,child_id,attendance_date,status) VALUES(1,1,''2026-09-21'',''Present'')'),
('Pickup with BOTH authorized person and typed name', 'INSERT INTO Pickup(child_id,authorized_person_id,pickup_person_name,pickup_type,pickup_time) VALUES(3,2,''Sara'',''Regular'',''2026-09-25 15:00'')'),
('Pickup with NEITHER authorized person nor name', 'INSERT INTO Pickup(child_id,authorized_person_id,pickup_person_name,pickup_type,pickup_time) VALUES(3,NULL,NULL,''Exception'',''2026-09-25 15:00'')'),
('Unlisted receiver typed as Regular pickup', 'INSERT INTO Pickup(child_id,authorized_person_id,pickup_person_name,pickup_type,pickup_time) VALUES(3,NULL,''Uncle'',''Regular'',''2026-09-25 15:00'')'),
('Invoice item total that breaks the formula', 'INSERT INTO InvoiceItem(invoice_id,fee_type_id,quantity,unit_amount,discount_amount,total_amount) VALUES(1,2,1,2000,100,2000)'),
('Attendance whose child does not match the enrollment', 'INSERT INTO Attendance(enrollment_id,child_id,attendance_date,status) VALUES(1,2,''2026-09-22'',''Present'')'),
('Trip using a bus from another branch', 'INSERT INTO TransportTrip(branch_id,route_id,bus_id,driver_id,supervisor_id,trip_date,trip_type) VALUES(1,1,2,1,1,''2026-09-25'',''Morning'')'),
('Trip using a driver from another branch', 'INSERT INTO TransportTrip(branch_id,route_id,bus_id,driver_id,supervisor_id,trip_date,trip_type) VALUES(1,1,1,2,1,''2026-09-25'',''Morning'')'),
('Class with zero capacity', 'INSERT INTO Class(branch_id,name,capacity) VALUES(1,''Zero'',0)')
) v(n,s);
OPEN c; FETCH NEXT FROM c INTO @name,@sql;
WHILE @@FETCH_STATUS=0 BEGIN
  BEGIN TRY BEGIN TRAN; EXEC(@sql); ROLLBACK; INSERT @t VALUES(@name,'ACCEPTED (bad!)'); END TRY
  BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK; INSERT @t VALUES(@name,'rejected: '+LEFT(REPLACE(ERROR_MESSAGE(),'The statement has been terminated.',''),120)); END CATCH
  FETCH NEXT FROM c INTO @name,@sql;
END
CLOSE c; DEALLOCATE c;
-- rules that SHOULD be allowed
BEGIN TRY BEGIN TRAN;
  INSERT INTO Child(nursery_id,first_name,last_name,date_of_birth,gender) VALUES(1,'NoId1','A','2023-01-01','Male');
  INSERT INTO Child(nursery_id,first_name,last_name,date_of_birth,gender) VALUES(1,'NoId2','B','2023-01-01','Male');
  ROLLBACK; INSERT @t VALUES('Two children without national id','accepted (good)');
END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK; INSERT @t VALUES('Two children without national id','REJECTED (bad!)'); END CATCH
BEGIN TRY BEGIN TRAN;
  INSERT INTO Pickup(child_id,authorized_person_id,pickup_person_name,pickup_type,pickup_time,status) VALUES(3,NULL,'Uncle','Exception','2026-09-25 15:00','Pending');
  ROLLBACK; INSERT @t VALUES('Exception pickup with no authorized person','accepted (good)');
END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK; INSERT @t VALUES('Exception pickup with no authorized person','REJECTED (bad!)'); END CATCH
BEGIN TRY BEGIN TRAN;
  INSERT INTO AuditLog(account_id,action,entity_name,entity_id) VALUES(NULL,'AUTO_MARK_ABSENT','Attendance',1);
  ROLLBACK; INSERT @t VALUES('System audit entry without account','accepted (good)');
END TRY BEGIN CATCH IF @@TRANCOUNT>0 ROLLBACK; INSERT @t VALUES('System audit entry without account','REJECTED (bad!)'); END CATCH
SELECT * FROM @t;

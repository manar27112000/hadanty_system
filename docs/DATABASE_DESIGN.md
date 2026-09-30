# Hadanty: Database Design and Normalization

SQL Server. 65 tables. Built and tested by the scripts in `sql/` and `tests/`.

## 1. Principles

1. **Every fact is stored once.** Anything that would have to be updated in two places is either removed, or kept on purpose with a constraint that makes disagreement impossible (section 3).
2. **The database protects itself.** Business rules are constraints (keys, CHECKs, filtered unique indexes), not application promises.
3. **History is never deleted.** Enrollments, class assignments, payments and audit rows are kept. Things end with a status or an end date.
4. **One nursery never touches another.** Nursery-owned rows carry `nursery_id`. Composite foreign keys stop a row from pointing across nurseries or branches.

## 2. Normal form status

| Area | Tables | Form | Notes |
|---|---|---|---|
| Organization | Nursery, Branch | 3NF | `Branch.nursery_id` is the only link upward. |
| People | Staff, Guardian, Child | 3NF | Names, contact and status depend only on the row key. |
| Many-to-many | StaffBranch, ChildGuardian, ClassStaff, ChildAuthorizedPickup, RolePermission, AccountRole | 3NF (bridge tables) | Composite primary key, no extra attributes except `AccountRole.branch_id` which is part of the key. |
| Security | UserAccount, Role, Permission | 3NF | `account_type` is controlled redundancy (section 3). |
| Academic | AcademicYear, Class, Enrollment, ClassAssignment | 3NF | Controlled redundancy on `nursery_id` / `branch_id`. |
| Attendance | Attendance, CheckIn, CheckOut | 3NF | Attendance status is a recorded fact; arrival and departure times live in their own tables. |
| Pickup | AuthorizedPickupPerson, Pickup, PickupApproval | 3NF | The receiver is stored once (see `CK_Pickup_ReceiverOnce`). |
| Reports | DailyReport, DailyAssessment, MonthlyAssessment, Media | 3NF | |
| Health | HealthRecord, Allergy, Medication, MedicationConsent, Incident | 3NF | |
| Finance | FeeType, Invoice, InvoiceItem, Discount, InvoiceDiscount, InvoiceItemDiscount, Payment, PaymentAttempt, Refund, Receipt | 3NF with documented snapshots | See sections 3 and 4. |
| Transport | Bus, Driver, BusSupervisor, TransportRoute, TransportStop, TransportTrip, TripChild, ChildTransportStop | 3NF | Trip members must share one branch. |
| Events, notifications, settings, audit | Event, EventRegistration, EventAttendance, NotificationType, Notification, NotificationDelivery, Holiday, WorkingHour, NurserySetting, BranchSetting, AuditLog | 3NF | Settings use key/value rows on purpose. |

## 3. Controlled redundancy

A column that can be derived from another table is normally a normalization defect. These exist on purpose, and each is guarded so the two copies can never disagree.

| Column | Could be derived from | Why kept | Guard |
|---|---|---|---|
| `Enrollment.nursery_id` | Branch, Child, AcademicYear | Lets one key prove all three belong to the same nursery | Composite FKs `(child_id, nursery_id)`, `(branch_id, nursery_id)`, `(academic_year_id, nursery_id)` |
| `ClassAssignment.branch_id` | Class, Enrollment | Class and enrollment must be in the same branch | Composite FKs to `Enrollment(enrollment_id, branch_id)` and `Class(class_id, branch_id)` |
| `Invoice.child_id` | Enrollment | Fast "invoices of a child" without a join | Composite FK `(enrollment_id, child_id)` |
| `Attendance.child_id` | Enrollment | Unique rule "one attendance per child per day" | Composite FK `(enrollment_id, child_id)` |
| `TransportTrip.branch_id` | Route, Bus, Driver, Supervisor | Forces all four into one branch | Composite FKs to each table on `(id, branch_id)` |
| `Notification.nursery_id` | Child | Notifications without a child still belong to a nursery | Composite FK `(child_id, nursery_id)` |
| `UserAccount.account_type` | Which of `staff_id` / `guardian_id` is set | Simple filtering | `CK_UserAccount_Owner` |

## 4. Stored money values (snapshots)

Invoices are legal documents, so their amounts are stored, not recomputed.

| Value | Rule | Enforced by |
|---|---|---|
| `InvoiceItem.total_amount` | `quantity * unit_amount - discount_amount` | `CK_InvoiceItem_TotalFormula` (single row, enforced now) |
| `InvoiceItem.discount_amount` | Sum of its `InvoiceItemDiscount` rows | Procedure + `tests/02_business_rule_checks.sql` |
| `Invoice.total_amount` | `SUM(item totals) - invoice-level discounts` | Procedure + tests |
| `Invoice.discount_total` | Item discounts + invoice-level discounts | Procedure + tests |
| Invoice `status` | From payments: `total - (Completed payments - Completed refunds)` | Procedure + tests |
| Remaining amount | Not stored. Always calculated with the rule above | A view (planned) |

`Receipt` stores no amount, method or transaction number. It is printed by joining `Payment`.

## 5. Anomalies and how each is prevented

| Anomaly | Example | Prevention |
|---|---|---|
| Insert | Enrolling a child into a branch of another nursery | Composite FK on `Enrollment` |
| Insert | Assigning a child to a class in a different branch | Composite FK on `ClassAssignment` |
| Insert | A trip that uses a bus from another branch | Composite FKs on `TransportTrip` |
| Insert | Two "current" enrollments or classes for one child | Filtered unique indexes `UX_Enrollment_OneActivePerChild`, `UX_ClassAssignment_OneActivePerEnrollment` |
| Insert | Two logins for one staff member | `UX_UserAccount_Staff`, `UX_UserAccount_Guardian` |
| Insert | Attendance for a child with no matching enrollment | Composite FK on `Attendance` |
| Update | A pickup receiver name that disagrees with the authorized person | Receiver stored once, `CK_Pickup_ReceiverOnce` |
| Update | A receipt whose amount differs from the payment | Receipt has no amount |
| Update | An item total that no longer matches its price | `CK_InvoiceItem_TotalFormula` |
| Delete | Losing a child's enrollment history | No deletes; `status` and `end_date` close a row |
| Typing | `status = 'Actve'` silently excluded from queries | `CK` value list on every status column |

## 6. Rules not yet enforced by the database

These cross more than one table, so they need procedures or triggers (next phase). Each has a test in `tests/`.

- Check-out time is after check-in; an absent child has no check-in.
- Refunds never exceed the payment; payments never exceed the invoice.
- Invoice totals and status match their items and payments.
- Class capacity is not exceeded.
- `AccountRole.branch_id` is a branch the staff member works in.
- A child's transport stop is on a route of the branch the child attends.
- Staff who record incidents or approve pickups work in the child's branch.

## 7. Open design question

Guardians are also stored as `AuthorizedPickupPerson` rows in the demo data, which repeats a name and phone number. Decision needed: are guardians authorized to pick up automatically? If yes, `Pickup` should reference a guardian or an authorized person, and only non-guardians belong in `AuthorizedPickupPerson`.

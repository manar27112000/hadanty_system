# Excel Import Migration

## Objective

Import child data from an Excel file into SQL Server using the SQL Server Import/Export Wizard.

## Source

* File: `children.xlsx`
* Source type: Microsoft Excel
* Sheet: `ورقة1$`

## Destination

* Server: `DESKTOP-6EMTKJJ`
* Database: `Hadanty_MigrationLab`
* Imported table: `dbo.Child_Excel_Import`

## Method

SQL Server Import/Export Wizard.

### Migration Flow

```text
children.xlsx
     ↓
Import/Export Wizard
     ↓
SQL Server
     ↓
Hadanty_MigrationLab
     ↓
dbo.Child_Excel_Import
```

## Result

The Excel data was imported successfully into SQL Server.

The imported records used child IDs:

* 2001
* 2002
* 2003
* 2004
* 2005

## Important Findings

The Import/Export Wizard transferred the **data**, but it did not automatically reproduce the complete structure and constraints of the original `Hadanty.dbo.Child` table.

For example:

* `child_id` in the imported table was initially nullable.
* The Primary Key was not automatically transferred.
* The imported table therefore allowed duplicate `child_id` values until a constraint was added.

This demonstrates an important migration concept:

> Data migration does not necessarily mean schema migration.

## Verification

The imported data was verified using:

```sql
USE Hadanty_MigrationLab;
GO

SELECT *
FROM dbo.Child_Excel_Import
ORDER BY child_id;
```

## Lessons Learned

1. Excel Import Wizard is useful for importing data quickly.
2. The destination database must be checked carefully before running the migration.
3. Imported tables may not have the same constraints as the original tables.
4. Primary Keys and other constraints should be verified after migration.
5. Duplicate data can occur if the destination table does not enforce uniqueness.

## Status

**Completed successfully.**

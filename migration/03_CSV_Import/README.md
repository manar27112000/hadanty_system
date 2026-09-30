# CSV Import Migration

## Objective

Import child data from a CSV file into SQL Server using the SQL Server Import/Export Wizard.

## Source

* File: `children.csv`
* Source type: CSV / Flat File
* Delimiter: Comma
* Records: 5

## Destination

* Server: `DESKTOP-6EMTKJJ`
* Database: `Hadanty_MigrationLab`
* Imported table: `dbo.children1`

## Method

SQL Server Import/Export Wizard using **Flat File Source**.

### Migration Flow

```text
children.csv
     ↓
Flat File Source
     ↓
Import/Export Wizard
     ↓
SQL Server
     ↓
Hadanty_MigrationLab
     ↓
dbo.children1
```

## Data

The CSV contained five child records with IDs:

* 3001
* 3002
* 3003
* 3004
* 3005

## Issues Encountered

### 1. File Access Error

The Wizard initially could not open the CSV because the file was being used by another process.

The issue was resolved by closing the application that had the CSV file open.

### 2. Code Page Conflict

The Wizard reported a conflict between:

* Code Page `65001` (UTF-8)
* Code Page `1256`

The CSV encoding was adjusted so the Wizard could process the file.

### 3. Existing Table

The Wizard initially attempted to create a table named `children`, but a table with that name already existed in the database.

The destination table was changed to:

```text
dbo.children1
```

### 4. Column Definition

The imported columns were created as `varchar` because the Import/Export Wizard inferred their data types from the CSV file.

The imported table therefore does not have the same schema definition as the original `Hadanty.dbo.Child` table.

## Verification

The imported data was verified using:

```sql
USE Hadanty_MigrationLab;
GO

SELECT *
FROM dbo.children1;
GO
```

The five CSV records were successfully returned.

## Important Findings

CSV Import is primarily a **data migration** operation.

The Import/Export Wizard can successfully transfer the data, but it does not automatically reproduce the complete schema of the original SQL Server table.

For example:

* Primary Keys are not automatically reproduced from the original table.
* Foreign Keys are not automatically reproduced.
* Constraints are not automatically reproduced.
* Data types may be inferred from the CSV.
* Column names can be affected by CSV formatting or encoding issues.

Therefore:

> Data migration does not necessarily mean schema migration.

## Lessons Learned

1. CSV is a simple and common source for data migration.
2. File encoding can affect the migration.
3. The CSV file must not be locked by another application during import.
4. The Import/Export Wizard may infer destination data types.
5. The destination table should be checked after migration.
6. Data validation is necessary after importing external files.
7. CSV import is useful for transferring data, but it is not a complete database schema migration.

## Status

**Completed successfully.**

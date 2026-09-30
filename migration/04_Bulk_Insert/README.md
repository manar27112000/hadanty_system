# BULK INSERT Migration

## Objective

Import child data from a CSV file into SQL Server using the `BULK INSERT` command.

## Source

* File: `children.csv`
* Source type: CSV
* Records: 5
* Child IDs: 4001–4005

## Destination

* Server: `DESKTOP-6EMTKJJ`
* Database: `Hadanty_MigrationLab`
* Table: `dbo.Children_Bulk`

## Method

SQL Server `BULK INSERT`.

### Migration Flow

```text
children.csv
     ↓
BULK INSERT
     ↓
SQL Server
     ↓
Hadanty_MigrationLab
     ↓
dbo.Children_Bulk
```

## Implementation

The destination table was created manually with columns suitable for receiving the CSV data.

During the first attempt, `BULK INSERT` produced a data conversion error because the CSV data could not be directly converted into the typed destination columns.

To isolate the file-loading step, the destination columns were changed to `VARCHAR`.

The CSV was then successfully loaded using:

```sql
BULK INSERT dbo.Children_Bulk
FROM 'D:\hadanty_system\migration\04_Bulk_Insert\children.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
```

`FIRSTROW = 2` skips the CSV header.

## Issues Encountered

### 1. CSV Format Option Error

The initial attempt used:

```sql
FORMAT = 'CSV'
```

SQL Server returned an OLE DB/BULK interface error.

The command was changed to the classic `BULK INSERT` syntax using:

* `FIELDTERMINATOR`
* `ROWTERMINATOR`
* `FIRSTROW`

### 2. Data Conversion Error

The typed destination table initially expected:

* `child_id` → `INT`
* `date_of_birth` → `DATE`

The CSV could not be directly converted during the bulk load.

The destination was temporarily changed to `VARCHAR` columns so the raw CSV data could be loaded successfully.

## Verification

The imported records were verified using:

```sql
USE Hadanty_MigrationLab;
GO

SELECT *
FROM dbo.Children_Bulk
ORDER BY child_id;
GO
```

The five records were successfully imported.

## Important Findings

`BULK INSERT` is a fast SQL Server command for loading large amounts of data from files.

Unlike the Import/Export Wizard, the operation is performed directly through SQL.

The target table must be compatible with the incoming file data. Data type and file-format problems can cause the bulk operation to fail.

This migration also demonstrated an important practical technique:

> When direct conversion fails, load the raw data first and handle type conversion separately.

## Lessons Learned

1. `BULK INSERT` can load large files directly into SQL Server.
2. The file path must be accessible to SQL Server.
3. `FIRSTROW` can be used to skip headers.
4. Field and row terminators must match the source file.
5. Destination column types must be compatible with the incoming data.
6. Raw `VARCHAR` loading can help isolate file-loading problems from data-conversion problems.
7. Data should always be verified after a bulk load.

## Status

**Completed successfully.**

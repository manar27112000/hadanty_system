# BCP Migration

## Objective

Transfer child data between SQL Server and a file using the SQL Server **BCP (Bulk Copy Program)** utility.

This migration demonstrates both:

* Export: SQL Server → File
* Import: File → SQL Server

## Source

* Database: `Hadanty_MigrationLab`
* Source table: `dbo.Children_Bulk`
* Records: 5
* Child IDs: 4001–4005

## Export Destination

```text
D:\hadanty_system\migration\05_BCP\children_export.dat
```

## Import Destination

* Database: `Hadanty_MigrationLab`
* Target table: `dbo.Children_BCP`

## Method

SQL Server **BCP (Bulk Copy Program)**.

### Migration Flow

```text
SQL Server
    ↓
BCP queryout
    ↓
children_export.dat
    ↓
BCP in
    ↓
SQL Server
    ↓
dbo.Children_BCP
```

## Export

The data was exported from SQL Server using:

```cmd
bcp "SELECT child_id, first_name, last_name, national_id, date_of_birth, gender, status FROM Hadanty_MigrationLab.dbo.Children_Bulk" queryout "D:\hadanty_system\migration\05_BCP\children_export.dat" -S DESKTOP-6EMTKJJ -T -c
```

The export completed successfully with:

```text
5 rows copied.
```

## Import

The exported file was imported back into SQL Server using:

```cmd
bcp Hadanty_MigrationLab.dbo.Children_BCP in "D:\hadanty_system\migration\05_BCP\children_export.dat" -S DESKTOP-6EMTKJJ -T -c
```

The first import attempt failed because the destination table used typed columns such as `INT` and `DATE`.

The error was:

```text
Invalid character value for cast specification
```

The destination table was changed to `VARCHAR` columns so the file could be loaded as raw data.

The second import completed successfully with:

```text
5 rows copied.
```

## Verification

The imported records were verified using:

```sql
USE Hadanty_MigrationLab;
GO

SELECT *
FROM dbo.Children_BCP
ORDER BY child_id;
GO
```

The five records were successfully returned.

## Important Findings

BCP is a command-line utility designed for high-speed bulk data transfer between SQL Server and files.

It can be used for both exporting and importing data.

The target table must be compatible with the incoming file format. Data type conversion problems can cause the import to fail.

For this migration, loading the data into `VARCHAR` columns allowed the raw file contents to be imported without conversion errors.

## BCP Options Used

| Option     | Purpose                        |
| ---------- | ------------------------------ |
| `queryout` | Export query results to a file |
| `in`       | Import data from a file        |
| `-S`       | SQL Server instance            |
| `-T`       | Windows Authentication         |
| `-c`       | Character/text data format     |

## Lessons Learned

1. BCP can export SQL Server data to a file.
2. BCP can import file data into SQL Server.
3. BCP is operated from the command line.
4. `-T` uses Windows Authentication.
5. `-c` uses character data format.
6. The destination schema must be compatible with the imported data.
7. Data conversion errors should be investigated before changing the source data.
8. BCP is useful for large-volume data transfer and automated migration processes.

## Status

**Completed successfully.**

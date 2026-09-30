# Staging + Validation Migration

## Objective

Import external child data into a staging table, validate the data, and separate valid records from invalid records before loading the final table.

## Source

* File: `children.csv`
* Source type: CSV
* Records: 6
* Child IDs: 5001–5006

## Destination

Database:

```text
Hadanty_MigrationLab
```

### Tables

* `dbo.Children_Staging`
* `dbo.Children_Staging_Final`
* `dbo.Children_Rejected`

## Migration Flow

```text
children.csv
     ↓
Children_Staging
     ↓
Data Validation
     ↓
 ┌─────────────────┐
 │                 │
 ↓                 ↓
Valid            Invalid
 ↓                 ↓
Children_         Children_
Staging_Final     Rejected
                   ↓
              Rejection Reason
```

## Staging

The source data was first loaded into:

```text
dbo.Children_Staging
```

The staging table uses `VARCHAR` columns so that the source data can be received before validation and type conversion.

## Validation Rules

The following validation rules were applied:

### Required Fields

The following fields must contain data:

* `first_name`
* `last_name`
* `national_id`
* `date_of_birth`
* `gender`
* `status`

### Date Validation

`date_of_birth` must be convertible to a valid SQL Server `DATE`.

### Gender Validation

Allowed values:

```text
Male
Female
```

### Child ID Validation

`child_id` must be convertible to `INT`.

## Validation Results

The source contained intentional invalid records.

| Child ID | Result  | Reason                  |
| -------- | ------- | ----------------------- |
| 5001     | Valid   | —                       |
| 5002     | Valid   | —                       |
| 5003     | Invalid | Missing `last_name`     |
| 5004     | Invalid | Invalid `date_of_birth` |
| 5005     | Invalid | Invalid `gender`        |
| 5006     | Valid   | —                       |

## Valid Data

Valid records were converted and loaded into:

```text
dbo.Children_Staging_Final
```

The final table uses proper SQL Server data types such as:

* `INT`
* `DATE`
* `VARCHAR`

## Rejected Data

Invalid records were stored in:

```text
dbo.Children_Rejected
```

A `rejection_reason` column was used to record why a record failed validation.

Rejected records:

* `5003` → Missing `last_name`
* `5004` → Invalid `date_of_birth`
* `5005` → Invalid `gender`

## Important Findings

A staging table provides a controlled area where external data can be loaded and checked before entering a final database table.

This helps prevent invalid external data from directly entering production tables.

The migration also demonstrated the separation of:

1. Data ingestion
2. Validation
3. Type conversion
4. Final loading
5. Rejected-record handling

## Lessons Learned

1. External data should not always be loaded directly into final tables.
2. Staging tables can isolate raw source data from production data.
3. Validation should happen before final loading.
4. Invalid records should be preserved rather than silently discarded.
5. Rejection reasons make migration failures traceable.
6. `TRY_CONVERT` can safely test data type conversions.
7. Data quality is an important part of database migration.

## Status

**Completed successfully.**

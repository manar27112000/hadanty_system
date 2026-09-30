USE Hadanty_MigrationLab;
GO

INSERT INTO dbo.Child_Excel_Import
(
    child_id,
    first_name,
    last_name,
    national_id,
    date_of_birth,
    gender,
    status
)
SELECT
    child_id,
    first_name,
    last_name,
    national_id,
    date_of_birth,
    gender,
    status
FROM dbo.Child_Excel_Import
WHERE child_id BETWEEN 2001 AND 2005;
GO

ALTER TABLE dbo.Child_Excel_Import
ADD CONSTRAINT PK_Child_Excel_Import
PRIMARY KEY (child_id);
GO

USE Hadanty_MigrationLab;
GO

WITH Duplicates AS
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY child_id
               ORDER BY child_id
           ) AS rn
    FROM dbo.Child_Excel_Import
)
DELETE FROM Duplicates
WHERE rn > 1;
GO

USE Hadanty_MigrationLab;
GO

DELETE FROM dbo.Child_Excel_Import;
GO


SELECT *
FROM dbo.Child_Excel_Import;


USE Hadanty_MigrationLab;
GO

ALTER TABLE dbo.Child_Excel_Import
ALTER COLUMN child_id INT NOT NULL;
GO

ALTER TABLE dbo.Child_Excel_Import
ADD CONSTRAINT PK_Child_Excel_Import
PRIMARY KEY (child_id);
GO
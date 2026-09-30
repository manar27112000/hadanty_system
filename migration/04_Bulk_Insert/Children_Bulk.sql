USE Hadanty_MigrationLab;
GO

DROP TABLE dbo.Children_Bulk;
GO

CREATE TABLE dbo.Children_Bulk
(
    child_id VARCHAR(20),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    national_id VARCHAR(20),
    date_of_birth VARCHAR(30),
    gender VARCHAR(10),
    status VARCHAR(20)
);
GO

USE Hadanty_MigrationLab;
GO

BULK INSERT dbo.Children_Bulk
FROM 'D:\hadanty_system\migration\04_Bulk_Insert\children.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

SELECT *
FROM dbo.Children_Bulk;

USE Hadanty_MigrationLab;
GO

DROP TABLE dbo.Children_BCP;
GO

CREATE TABLE dbo.Children_BCP
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

SELECT *
FROM dbo.Children_BCP
ORDER BY child_id;
GO
USE Hadanty;
GO


USE master;
GO

IF DB_ID('Hadanty') IS NOT NULL
BEGIN
    ALTER DATABASE Hadanty
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE Hadanty;
END
GO

CREATE DATABASE Hadanty;
GO

SELECT name
FROM sys.databases
WHERE name = 'Hadanty';
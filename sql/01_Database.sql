/* =========================================================
   01_Database.sql
   Creates the Hadanty database if it does not exist yet.

   This script NEVER drops anything. To wipe and rebuild a
   development database, use dev/reset_database.sql (it refuses
   to run anywhere except the developer machine).
   ========================================================= */

USE master;
GO

IF DB_ID('Hadanty') IS NULL
BEGIN
    CREATE DATABASE Hadanty;
    PRINT 'Database Hadanty created.';
END
ELSE
    PRINT 'Database Hadanty already exists. Nothing changed.';
GO

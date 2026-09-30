/* =========================================================
   migration/00_Create_MigrationLab.sql
   Practice database for the migration exercises. It is not part
   of the Hadanty product and must never be deployed to production.
   ========================================================= */

USE master;
GO

IF DB_ID('Hadanty_MigrationLab') IS NULL
    CREATE DATABASE Hadanty_MigrationLab;
GO

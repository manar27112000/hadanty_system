/* =========================================================
   dev/reset_database.sql
   DEVELOPMENT ONLY. Drops the Hadanty database so the sql/ files
   can rebuild it from scratch.

   Safety: it refuses to run unless the server name matches the
   developer machine below. NEVER add a production server name here.
   ========================================================= */

USE master;
GO

IF @@SERVERNAME <> 'DESKTOP-6EMTKJJ'
BEGIN
    RAISERROR('dev/reset_database.sql refused: this is not the developer machine.', 20, 1) WITH LOG;
    RETURN;
END
GO

IF DB_ID('Hadanty') IS NOT NULL
BEGIN
    ALTER DATABASE Hadanty SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Hadanty;
    PRINT 'Database Hadanty dropped.';
END
GO

CREATE PROCEDURE sp_AlterCompatibilityLevel 
    @databaseName NVARCHAR(128),  
    @targetCompatibilityLevel SMALLINT  
AS
BEGIN  
    DECLARE @databaseid INT
    DECLARE @currentCompatibilityLevel SMALLINT
    DECLARE @sql NVARCHAR(MAX)

    -- GET @databaseid - for example:
    SET @databaseid = (SELECT database_id FROM sys.databases WHERE [name] = @databaseName)

    -- GET Compatibibilite Level Database
    SET @currentCompatibilityLevel = (SELECT compatibility_level FROM sys.databases WHERE [name] = @databaseName)

    IF OBJECT_ID('tempdb..#Compatibilitylevel', 'U') IS NOT NULL
    BEGIN 
        DROP TABLE tempdb..#Compatibilitylevel
    END

    CREATE TABLE tempdb..#Compatibilitylevel (
        DatabaseName VARCHAR(100),
        Id_Database TINYINT,
        Compatibilitylevel TINYINT
    )

    INSERT INTO tempdb..#Compatibilitylevel (DatabaseName, Id_Database, Compatibilitylevel)
    SELECT db.[name], db.database_id, db.[compatibility_level]
    FROM sys.databases db
    WHERE NOT EXISTS (
        SELECT 1
        FROM tempdb..#Compatibilitylevel c
        WHERE c.Id_Database = db.database_id
    )

    IF (@currentCompatibilityLevel <> @targetCompatibilityLevel)
    BEGIN 
        SET @sql = 'ALTER DATABASE ' + QUOTENAME(@databaseName) + ' 
                    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

                    ALTER DATABASE ' + QUOTENAME(@databaseName) + ' SET COMPATIBILITY_LEVEL = ' + CAST(@targetCompatibilityLevel AS NVARCHAR(10)) + ';

                    ALTER DATABASE ' + QUOTENAME(@databaseName) + ' SET MULTI_USER WITH ROLLBACK IMMEDIATE;'

        EXEC sp_executesql @sql
    END
END

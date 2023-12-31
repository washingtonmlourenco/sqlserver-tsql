﻿IF OBJECT_ID('sp_BackupFull', 'P') IS NOT NULL
	DROP PROCEDURE sp_BackupFull
GO

CREATE PROCEDURE sp_BackupFull (
	@DatabaseName SYSNAME
	,@Compression CHAR(1) = N' '
	,@Path NVARCHAR(MAX) = N'C:\SQLServer\BACKUP\'	-- Default directory
	,@MaxTransferSize INT = 65536
	)
AS
BEGIN
	DECLARE @Data NVARCHAR(100)
		,@WithCompression VARCHAR(100)
		,@SQLCommand NVARCHAR(MAX)
		,@Directory NVARCHAR(MAX)
		,@MaxTransferSizeDefault INT = @MaxTransferSize;

	SET @Data = REPLACE(REPLACE(CONVERT(NVARCHAR(100), GETDATE(), 120), ' ', '-'), ':', '-')
	SET @Directory = @Path + @DatabaseName + '_' + @Data + '.BAK'

	-- MaxTransferSize Validate:
	DECLARE @MinTransferSize INT = 64;

	IF @MaxTransferSize < @MinTransferSize
	BEGIN
		RAISERROR (
				'The value for MAXTRANSFERSIZE is not validated. Specify a value within the allowed range.'
				,16
				,1
				);

		RETURN;
	END

	IF @MaxTransferSize < @MinTransferSize
	BEGIN
		RAISERROR (
				'The value for MAXTRANSFERSIZE is not validated. Using default value.'
				,16
				,1
				);

		SET @MaxTransferSizeDefault = 65536;
	END

	IF EXISTS (
			SELECT 1
			FROM sys.master_files
			WHERE physical_name = @Directory
			)
	BEGIN
		PRINT 'The backup file already exists for the current date.'

		RETURN
	END

	IF (@Compression = 'Y')
		SET @WithCompression = 'COMPRESSION'
	ELSE
		SET @WithCompression = 'NO_COMPRESSION'

	SET @SQLCommand = N'BACKUP DATABASE ' + QUOTENAME(@DatabaseName) + ' TO DISK = ''' + @Directory + ''' WITH ' + @WithCompression + ', STATS = 5, MAXTRANSFERSIZE = ' + CAST(@MaxTransferSize AS NVARCHAR(10))

	-- Backup Execute
	EXEC sp_executesql @SQLCommand
END
	

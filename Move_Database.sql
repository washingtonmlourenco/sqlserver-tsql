-- Step: 1°: -> Verifica caminho do arquivo

SELECT  db.[name] DatabaseName 
	   ,mf.[name] LogicalName
	   ,mf.physical_name FileLocation
	   ,(8) * mf.size / 1024 SizeMB 
	   ,mf.state_desc Status_Atual 
FROM sys.master_files mf
INNER JOIN sys.databases db ON db.database_id = mf.database_id
WHERE db.[name] = 'tempdb'


/* Step: 2° and Step: 3°, Query by Brent Ozar, References: https://www.brentozar.com/archive/2017/11/move-tempdb-another-drive-folder/ */

-- Step: 2° -> Gera Script de move database

SELECT 'ALTER DATABASE tempdb MODIFY FILE (NAME = [' + f.name + '],'
	+ ' FILENAME = ''C:\SQLServer\TempDB\' + f.name
	+ CASE WHEN f.type = 1 THEN '.ldf' ELSE '.mdf' END
	+ ''');' Script_MoveDB
FROM sys.master_files f
WHERE f.database_id = DB_ID(N'tempdb');


-- Step: 3°:  -> Saida do passo 2°, executar!

ALTER DATABASE tempdb MODIFY FILE (NAME = [tempdev], FILENAME = 'C:\SQLServer\TempDB\tempdev.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [templog], FILENAME = 'C:\SQLServer\TempDB\templog.ldf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp2], FILENAME = 'C:\SQLServer\TempDB\temp2.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp3], FILENAME = 'C:\SQLServer\TempDB\temp3.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp4], FILENAME = 'C:\SQLServer\TempDB\temp4.mdf');



-- Step: 4° -> Restart do Serviços do SQLServer


-- Step: 5° -> Verifica caminho do arquivo

SELECT  db.[name] DatabaseName 
	   ,mf.[name] LogicalName
	   ,mf.physical_name FileLocation
	   ,(8) * mf.size / 1024 SizeMB 
	   ,mf.state_desc Status_Atual 
FROM sys.master_files mf
INNER JOIN sys.databases db ON db.database_id = mf.database_id
WHERE db.[name] = 'tempdb'
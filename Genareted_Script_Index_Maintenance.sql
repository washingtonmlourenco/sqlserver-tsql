IF OBJECT_ID('tempdb..#IndexFragmentation', 'U') IS NOT NULL
	DROP TABLE #IndexFragmentation;

CREATE TABLE #IndexFragmentation (
	Id INT PRIMARY KEY IDENTITY
	,schema_name VARCHAR(MAX)
	,object_name VARCHAR(MAX)
	,index_name VARCHAR(MAX)
	,index_type VARCHAR(MAX)
	,avg_fragmentation_in_percent FLOAT
	,avg_page_space_used_in_percent FLOAT
	,page_count INT
	)

INSERT INTO #IndexFragmentation
SELECT OBJECT_SCHEMA_NAME(ips.object_id) AS schema_name
	,OBJECT_NAME(ips.object_id) AS object_name
	,i.name AS index_name
	,i.type_desc AS index_type
	,ips.avg_fragmentation_in_percent
	,ips.avg_page_space_used_in_percent
	,ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), DEFAULT, DEFAULT, DEFAULT, 'SAMPLED') AS ips
INNER JOIN sys.indexes AS i ON ips.object_id = i.object_id
	AND ips.index_id = i.index_id
ORDER BY page_count DESC

DECLARE @SQLCommand NVARCHAR(MAX) = '';

SELECT @SQLCommand + 'ALTER INDEX [' + index_name + '] ON [' + schema_name + '].[' + object_name + '] ' + CASE 
		WHEN avg_fragmentation_in_percent >= 5
			AND avg_fragmentation_in_percent < 30
			THEN 'REORGANIZE'
		ELSE 'REBUILD'
		END + CHAR(13) + CHAR(10) + 'GO' Index_Maintenance
FROM #IndexFragmentation


--PRINT @SQLCommand

	--Dropa a tabela temporária
	--DROP TABLE #IndexFragmentation

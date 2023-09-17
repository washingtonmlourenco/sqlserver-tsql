SELECT
	sd.name AS [Database_Name],
	t.name AS Table_Name,
	i.name AS Index_Name,
	i.type_desc AS Index_Type,
	i.is_primary_key AS Is_Primary_Key,
	st.database_id AS Database_ID,
	st.avg_fragmentation_in_percent AS Fragmentation_In_Percent,
	st.avg_page_space_used_in_percent AS Page_Space_Used_In_Percent,
	st.avg_fragment_size_in_pages AS Fragmentation_Size_In_Page,
	st.page_count AS Page_Count
FROM sys.dm_db_index_physical_stats(DB_ID(), default, default, default, 'SAMPLED') AS st
	INNER JOIN sys.indexes AS i ON st.object_id = i.object_id
	JOIN sys.databases sd ON st.database_id = sd.database_id
	JOIN sys.tables t ON t.object_id = st.object_id
ORDER BY st.avg_fragmentation_in_percent DESC


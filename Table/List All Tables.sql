WITH CTE
AS (
	SELECT tb.[name] Nm_Tabela
		,sch.name Nm_Schema
		,tb.create_date Dt_Criacao_Tabela
		,tb.modify_date Dt_Modificacao_Tabela
	FROM sys.tables tb
	INNER JOIN sys.schemas sch ON sch.schema_id = tb.schema_id
	)
SELECT DB_NAME() [Database_Name]
	,CTE.Nm_Tabela
	,CTE.Nm_Schema
	,CTE.Dt_Criacao_Tabela
	,CTE.Dt_Modificacao_Tabela
FROM CTE

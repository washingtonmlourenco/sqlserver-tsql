SELECT	 [name]			UserName
		,loginname		LoginName
		,dbname			[Default_Database]
		,createdate		Data_Criacao
		,updatedate		Data_Ultima_Atualizacao
		,[sid]			ID
FROM sys.syslogins
	WHERE loginname NOT LIKE '%NT%' 
AND loginname NOT LIKE '%##%'

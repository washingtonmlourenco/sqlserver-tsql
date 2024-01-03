-- Developed by my friend Kelson Damasceno 
IF EXISTS (
		SELECT *
		FROM sys.tables
		WHERE [name] LIKE 'tempdb..#ReadErrorlog'
		)
	DROP TABLE #ReadErrorlog
GO

CREATE TABLE #ReadErrorlog (
	 LogDate DATETIME
	,ProcessInfo VARCHAR(100)
	,TEXT VARCHAR(MAX)
	)
GO

INSERT INTO #ReadErrorlog
EXEC sp_readerrorlog;

SELECT *
FROM #ReadErrorlog
WHERE ProcessInfo = 'Backup'

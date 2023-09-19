-- Developed by my friend Kelson Damasceno https://www.linkedin.com/in/ACoAAB79tb4B5IbXIwrhGRqaCqeIBrizBMYlGdI?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_recent_activity_content_view%3Bs9nC%2BP7ATiC2io8M0xqZVg%3D%3D
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

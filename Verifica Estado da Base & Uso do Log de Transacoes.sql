SELECT db.[name] DatabaseName
	,db.physical_database_name PhysicalName
	,mf.[name] LogicalName
	,mf.physical_name [Path]
	,CASE WHEN db.[state] = 0	THEN	'ONLINE'
		  WHEN db.[state] = 1	THEN	'RESTORING'
		  WHEN db.[state] = 2	THEN	'RECOVERING'
		  WHEN db.[state] = 3	THEN	'RECOVERY_PENDING'
		  WHEN db.[state] = 4	THEN	'SUSPECT'  
		  WHEN db.[state] = 5	THEN	'EMERGENCY'  
		  WHEN db.[state] = 6	THEN	'OFFLINE'  
		  WHEN db.[state] = 7	THEN	'COPYING'  
		  WHEN db.[state] = 10	THEN	'OFFLINE_SECONDARY'  
			  END CurrentStateDB
,db.recovery_model_desc RecoveryModel
,db.log_reuse_wait_desc
,CASE WHEN hdr.database_state = 0	THEN	'ONLINE'    
      WHEN hdr.database_state = 1	THEN	'RESTORING'
	  WHEN hdr.database_state = 2	THEN	'RECOVERING'
	  WHEN hdr.database_state = 3	THEN	'RECOVERY_PENDING'
	  WHEN hdr.database_state = 4	THEN	'SUSPECT'  
	  WHEN hdr.database_state = 5	THEN	'EMERGENCY'  
	  WHEN hdr.database_state = 6	THEN	'OFFLINE'  
END CurrentStateWithAlwaysON 
FROM sys.databases db
INNER JOIN sys.master_files mf ON mf.database_id = db.database_id
LEFT JOIN sys.dm_hadr_database_replica_states hdr ON hdr.database_id = db.database_id
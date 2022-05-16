
 exec sp_configure 'allow updates'		,1
 exec sp_configure 'show advanced options'	,1

 reconfigure with override

go


 execute sp_configure 'affinity mask'		,0	 --- Key=1535 Status=0
 execute sp_configure 'allow updates'		,1	 --- Key=102 Status=0
--execute sp_configure 'backup buffer size'	,1	 --- Key=541 Status=0
 execute sp_configure 'cost threshold for parallelism' ,0 
 execute sp_configure 'cursor threshold'	,-1	 --- Key=1531 Status=0

 execute sp_configure 'database size'		,2	 --- Key=111 Status=0
-- execute sp_configure 'default comparison style',0   
 execute sp_configure 'default language'	,0	 --- Key=124 Status=0
-- execute sp_configure 'default sortorder id'	,52	 --- Key=1123 Status=0
 execute sp_configure 'fill factor'		,0	 --- Key=109 Status=0
-- execute sp_configure 'free buffers'		,409	 --- Key=1515 Status=0

-- execute sp_configure 'hash buckets'		,7993	 --- Key=1504 Status=0
 execute sp_configure 'language in cache'	,3	 --- Key=125 Status=0
-- execute sp_configure 'LE threshold maximum'	,200	 --- Key=523 Status=0
-- execute sp_configure 'LE threshold minimum'	,20	 --- Key=1522 Status=0
-- execute sp_configure 'LE threshold percent'	,0	 --- Key=521 Status=0

 execute sp_configure 'locks'			,50000	 --- Key=106 Status=0
-- execute sp_configure 'logwrite sleep (ms)'	,0	 --- Key=1530 Status=0
 execute sp_configure 'max additional query mem.',4096   
 execute sp_configure 'max async IO'		,255     --- Key=502 Status=0
-- execute sp_configure 'max lazywrite IO'	,8	 --- Key=1506 Status=0
 execute sp_configure 'max text repl size'	,65536	 --- Key=1536 Status=0

 execute sp_configure 'max worker threads'	,255	 --- Key=503 Status=0
 execute sp_configure 'media retention'		,0	 --- Key=112 Status=0
 execute sp_configure 'memory'			,0	 --- Key=104 Status=0 (1 MB units)
 execute sp_configure 'nested triggers'		,1	 --- Key=115 Status=0
 execute sp_configure 'network packet size'	,4096	 --- Key=505 Status=0

go

-- execute sp_configure 'open databases'		,20	 --- Key=105 Status=0
-- execute sp_configure 'open objects'		,500	 --- Key=107 Status=0
 execute sp_configure 'priority boost'		,0	 --- Key=1517 Status=0
 execute sp_configure 'procedure cache'		,10	 --- Key=108 Status=0
-- execute sp_configure 'RA cache hit limit'	,4	 --- Key=1513 Status=0

-- execute sp_configure 'RA cache miss limit'	,3	 --- Key=1512 Status=0
-- execute sp_configure 'RA delay'		,15	 --- Key=1511 Status=0
-- execute sp_configure 'RA pre-fetches'		,3	 --- Key=1510 Status=0
-- execute sp_configure 'RA slots per thread'	,5	 --- Key=1509 Status=0
-- execute sp_configure 'RA worker threads'	,3	 --- Key=508 Status=0

-- execute sp_configure 'recovery flags'		,0	 --- Key=113 Status=0
 execute sp_configure 'recovery interval'	,5	 --- Key=101 Status=0
 execute sp_configure 'remote access'		,1	 --- Key=117 Status=0
-- execute sp_configure 'remote conn timeout'	,10	 --- Key=543 Status=0
 execute sp_configure 'remote login timeout'	,5	 --- Key=1519 Status=0

 execute sp_configure 'remote proc trans'	,0	 --- Key=542 Status=0
 execute sp_configure 'remote query timeout'	,0	 --- Key=1520 Status=0
-- execute sp_configure 'remote sites'		,10	 --- Key=1119 Status=0
 execute sp_configure 'resource timeout'	,10	 --- Key=1533 Status=0
 execute sp_configure 'set working set size'	,0	 --- Key=1532 Status=0

 execute sp_configure 'show advanced options'	,1	 --- Key=518 Status=0
 execute sp_configure 'index create memory (KB)'	,8384     --- Key=1505 Status=0 (page size)
 execute sp_configure 'spin counter'		,10000	 --- Key=1514 Status=0
-- execute sp_configure 'tempdb in ram (MB)'	,0	 --- Key=501 Status=0
 execute sp_configure 'time slice'		,100	 --- Key=1110 Status=0

-- execute sp_configure 'user connections'	,15	 --- Key=103 Status=0
 execute sp_configure 'user options'		,0	 --- Key=1534 Status=1
 --- (52 row(s) affected)


go

 reconfigure with override

 print 'Did Reconfigure WOverride, but still need to stop/restart mssqlserver for nondynamic configs...'
 print ' '

go
 --eof


drop database tpcds
go
sp_dbremove, tpcds
go
sp_dropdevice tpcds, DELFILE
go
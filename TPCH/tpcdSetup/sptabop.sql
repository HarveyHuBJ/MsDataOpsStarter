
 --- TPC_D\sptabop.sql   GeneMi   1997/02/08 15:01
go

 execute sp_tableoption 'region'	,'table lock on bulk load'	,'true'
 execute sp_tableoption 'nation'	,'table lock on bulk load'	,'true'
 execute sp_tableoption 'part'		,'table lock on bulk load'	,'true'
 execute sp_tableoption 'supplier'	,'table lock on bulk load'	,'true'
 execute sp_tableoption 'partsupp'	,'table lock on bulk load'	,'true'
 execute sp_tableoption 'customer'	,'table lock on bulk load'	,'true'
 execute sp_tableoption 'orders'	,'table lock on bulk load'	,'true'
 execute sp_tableoption 'lineitem'	,'table lock on bulk load'	,'true'

go
 --eof


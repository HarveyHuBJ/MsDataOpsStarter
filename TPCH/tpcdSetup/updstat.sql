
 --- TPC_D\UpdStat.sql   GeneMi   1997/02/10 13:42
go


 select 'update statistics region...' ,convert(varchar,getdate(),113)

go

 update statistics region

go



 select 'update statistics nation...' ,convert(varchar,getdate(),113)

go

 update statistics nation

go



 select 'update statistics part...' ,convert(varchar,getdate(),113)

go

 update statistics part

go



 select 'update statistics supplier...' ,convert(varchar,getdate(),113)

go

 update statistics supplier

go



 select 'update statistics partsupp...' ,convert(varchar,getdate(),113)

go

 update statistics partsupp

go



 select 'update statistics customer...' ,convert(varchar,getdate(),113)

go

 update statistics customer

go



 select 'update statistics orders...' ,convert(varchar,getdate(),113)

go

 update statistics orders

go



 select 'update statistics lineitem...' ,convert(varchar,getdate(),113)

go

 update statistics lineitem

go
 --eof


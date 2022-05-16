

if exists (select name from sysobjects where name = '#rowcounts')
 drop table #rowcounts
go
if exists (select name from sysobjects where name = '#singlenumber')
 drop table #singlenumber
go

create table #rowcounts (tabname char(8), tabrows int) 
create table #singlenumber (counter int) 
go


insert into #rowcounts values ('SUPPLIER',10000)
insert into #rowcounts values ('PART',200000)
insert into #rowcounts values ('PARTSUPP',800000)
insert into #rowcounts values ('CUSTOMER',150000)
insert into #rowcounts values ('ORDERS',1500000)
insert into #rowcounts values ('LINEITEM',6001215)


insert into #rowcounts values ('NATION',25)
insert into #rowcounts values ('REGION',5)
go

declare fetchrows cursor for select tabname, tabrows from #rowcounts
declare @count int, @err int, @tabrows int
declare @tabname char(8)

OPEN fetchrows

FETCH NEXT FROM fetchrows INTO @tabname, @tabrows 
select @err=0

while (@@fetch_status <> -1) 
BEGIN
   if (@@fetch_status <> -2) 
   BEGIN
      SELECT @tabname = RTRIM (UPPER(@tabname))
      DELETE #singlenumber
     EXEC (" INSERT INTO #singlenumber   SELECT  count(*) FROM " + @tabname)
      SELECT @count= counter FROM #singlenumber
      if @count <> @tabrows
      begin
                PRINT "**********************   Error  ************************"
        PRINT @tabname + " has "+ CONVERT(char(8),@count) + 
              " rows and should have " + CONVERT(CHAR(8),@tabrows)
           select @err=@err+1
      end
      FETCH NEXT FROM fetchrows INTO @tabname, @tabrows 
   END
END

PRINT "********************** Sanity Check Result Follows  ************************"
PRINT CONVERT(char(8),@err) + " errors found."

if exists (select name from sysobjects where name = '#rowcounts')
 drop table #rowcounts
go
if exists (select name from sysobjects where name = '#singlenumber')
 drop table #singlenumber
go
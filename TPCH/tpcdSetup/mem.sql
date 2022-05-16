-- Some parameters need to be adjusted down on machines with lower memory.
create table #temp (Ind smallint, Name varchar(100), Internal_Value int, Character_Value varchar(100))
go
insert #temp exec xp_msver PhysicalMemory
go
declare @MB int
select @MB = Internal_Value from #temp
if (@MB > 128)
begin
	exec sp_configure 'index create memory (KB)', 8384
end
else
begin
	exec sp_configure 'index create memory (KB)', 2048
end
go
reconfigure with override
go

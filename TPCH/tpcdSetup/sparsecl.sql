
 --- TPC_D\sparsecl.sql   GeneMi   1997/02/08 14:22

 --- These indexes are optimized for Sphinx not Hydra, by LuborK. (and GoetzG.?).
 --- Create a clustered index on each table.
 --- All tables except part-supply have been loaded in sorted order.
go

 select 'File sparsecl.SQL execution starts at' ,convert(varchar,getdate(),113)

go

 PRINT 'Creating n_key_idx'

 if exists (select name from sysindexes where name='n_key_idx')
    drop index nation.n_key_idx

go

 create unique clustered index n_key_idx
	on nation(n_nationkey)
	with sorted_data

go

 PRINT 'Creating r_key_idx'

 if exists (select name from sysindexes where name='r_key_idx')
    drop index region.r_key_idx

go

 create unique clustered index r_key_idx
	on region(r_regionkey)
	with sorted_data
go

 PRINT 'Creating p_key_idx'

 if exists (select name from sysindexes where name='p_key_idx')
     drop index part.p_key_idx

go

 create unique clustered index p_key_idx
	on part(p_partkey)
	with sorted_data
go

 PRINT 'Creating s_key_idx'

 if exists (select name from sysindexes where name='s_key_idx')
     drop index supplier.s_key_idx

go

 create unique clustered index s_key_idx
	on supplier(s_suppkey)
	with sorted_data
go

 PRINT 'Creating c_key_idx'

 if exists (select name from sysindexes where name='c_key_idx')
     drop index customer.c_key_idx

go

 create unique clustered index c_key_idx
	on customer(c_custkey)
	with sorted_data
go

 PRINT 'Creating o_key_idx'

 if exists (select name from sysindexes where name='o_key_idx')
     drop index orders.o_key_idx

go

 create unique clustered index o_key_idx
	on orders(o_orderkey)
	with sorted_data
go

 PRINT 'Creating l_key_idx'

 if exists (select name from sysindexes where name='l_key_idx')
     drop index lineitem.l_key_idx

go

 create unique clustered index l_key_idx
	on lineitem(l_orderkey, l_linenumber)
	with sorted_data
go

 PRINT 'Creating ps_key_idx'

 if exists (select name from sysindexes where name='ps_key_idx')
     drop index supplier.ps_key_idx

go

 create unique clustered index ps_key_idx
	on partsupp(ps_partkey, ps_suppkey)

go

select 'File sparsecl.SQL execution ends at' ,convert(varchar,getdate(),113)

go
 --eof


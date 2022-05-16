
 --- TPC_D\idxnc7.sql   GeneMi   1997/02/08 14:12

 --- NONclus indexes only in this file.
 --- These are optimized for Sphinx not Hydra, and were developed by LuborK. (and GoetzG.?).
 --- All indexes are unique because the primary key is added as minor key */
 --- Read-only indexes use fill factor 100, other 95%.
go

select 'File sparsenc.SQL execution starts at' ,convert(varchar,getdate(),113)

go

 print '===== Part ====='

go
 PRINT 'Create index p_typesize_idx'
go

 create unique index p_typesize_idx
	on part(p_type, p_size, p_partkey)
	with fillfactor=100

go

 PRINT 'Create index p_brdcnt_idx'

 
go

 create unique index p_brdcnt_idx
	on part(p_brand, p_container, p_partkey)
	with fillfactor=100

go

 print '===== Supplier ====='

 PRINT 'Create index s_nation_idx'

go

 create unique index s_nation_idx
	on supplier(s_nationkey, s_suppkey)
	with fillfactor=100

go

 print '===== Part Supply ====='

 PRINT 'Create index ps_key_idx2'

go

 create unique index ps_key_idx2
	on partsupp(ps_suppkey, ps_partkey, ps_availqty, ps_supplycost)
	with fillfactor=100

go

 print '===== Customer ====='

 PRINT 'Create index c_nation_idx'

go

 create unique index c_nation_idx
	on customer(c_nationkey, c_custkey)
	with fillfactor=100

go

 print '===== Orders ====='

 PRINT 'Create index o_cust_idx'


go

 create unique index o_cust_idx
	on orders(o_custkey, o_orderkey)
	with fillfactor=95

go

 PRINT 'Create index o_date_idx'


go

 create unique index o_date_idx
	on orders(o_orderdate, o_orderkey)
	with fillfactor=95

go

 PRINT 'Create index o_clerk_idx'


go

 create unique index o_clerk_idx
	on orders(o_clerk, o_orderkey)
	with fillfactor=95

go

 print '===== Lineitem ====='

 PRINT 'Create index l_pkey_idx'


go

 create unique index l_pkey_idx
	on lineitem(l_partkey, l_orderkey, l_linenumber)
	with fillfactor=95

go

 PRINT 'Create index l_skey_idx'


go

 create unique index l_skey_idx
	on lineitem(l_suppkey, l_orderkey, l_linenumber)
	with fillfactor=95

go

 select 'File sparsenc.SQL execution ends at' ,convert(varchar,getdate(),113)

go
 --eof


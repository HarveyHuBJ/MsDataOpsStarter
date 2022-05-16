 select 'File ncidx.SQL execution starts at' ,convert(varchar,getdate(),113)

go

-- add other keys for q2 9 avoid cluster index look up; benefit from caching -used twice)
 PRINT 'Creating s_supnat_idx'

 create unique index s_supnat_idx
	on supplier (s_suppkey, s_nationkey)
	with fillfactor=100

go

----  Indexes for the CUSTOMER table

 PRINT 'Creating c_natcus_idx'

 create unique index c_natcus_idx
	on customer (c_nationkey,c_custkey)
	with fillfactor=100

go
----  Indexes for the PART table
---  added columns for Q16
---  added p_mfgr for Q2
 PRINT 'Creating p_siz_idx'

 create unique index p_siz_idx
	on part (p_size, p_brand, p_type, p_partkey, p_mfgr)
	with fillfactor=100

go

 PRINT 'Creating p_typpar_idx'

 create unique index p_typpar_idx
	on part (p_type, p_partkey)
	with fillfactor=100


go

----  Indexes for the PARTSUPP table

 PRINT 'Creating ps_pkyskysco_idx'

 create unique index ps_pkyskysco_idx
	on partsupp (ps_partkey, ps_suppkey, ps_supplycost)
	with fillfactor=100

go

----  Indexes for the ORDERS table

 PRINT 'Creating o_cle_idx'

 create index o_cle_idx
	on orders (o_clerk, o_orderkey, o_orderdate)
	with fillfactor=95

go

----  Indexes for the LINEITEM table ---- from DB2 were replaced by our own


 print 'creating l_order_idx'
 create --- s3 ,s5 ,s7
	index	l_order_idx
	on	lineitem
			(l_orderkey, l_shipdate, l_suppkey, l_extendedprice, l_discount)
	with	fillfactor=95

go

 print 'creating l_order_dates_idx'
 create --- s4 ,s12 - changed to avoid sort in both queries
	index	l_order_dates_idx
	on	lineitem
			(l_orderkey, l_receiptdate, l_commitdate, l_shipdate)
	with	fillfactor=95

go

 print 'creating l_flag_idx'
 create --- s10 ,s13 
	index	l_flag_idx
	on	lineitem
			(l_returnflag, l_orderkey, l_extendedprice, l_discount)
	with	fillfactor=95

go

 select 'File ncidx.SQL execution ends at' ,convert(varchar,getdate(),113)

go







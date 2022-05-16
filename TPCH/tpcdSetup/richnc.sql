
 --- TPC_D\idxnc6.sql   GeneMi   1997/02/11 13:22
 --- NONclustered indexes only, in this file.
 --- From Goetz Graefe, optimized for Hydra not Sphinx.
go

 select 'File richnc.SQL execution starts at' ,convert(varchar,getdate(),113)

go

 print '------------ tab customer'

go

 create unique
	index	c_nation_idx
	on	customer
			(c_nationkey, c_custkey)
	with	fillfactor=100

go

 create unique --- s3
	index	c_mktsegm_idx
	on	customer
			(c_mktsegment, c_custkey)
	with	fillfactor=100

go

 print '-------- tab lineitem (no clust idx)'

go

 create --- s3 ,s5 ,s7
	index	l_order_idx
	on	lineitem
			(l_orderkey, l_shipdate, l_suppkey, l_extendedprice, l_discount)
	with	fillfactor=95

go

 create --- s4 ,s12
	index	l_order_dates_idx
	on	lineitem
			(l_orderkey, l_receiptdate, l_commitdate, l_shipdate, l_shipmode)
	with	fillfactor=95

go

 create --- s10 ,s13
	index	l_flag_idx
	on	lineitem
			(l_returnflag, l_orderkey, l_extendedprice, l_discount)
	with	fillfactor=95

go

 create --- for multiple queries
	index	l_part_idx
	on	lineitem
			(l_partkey, l_suppkey, l_orderkey,l_quantity, l_extendedprice, l_discount,l_shipdate)
	with	fillfactor=95

go

 create --- s5 ,s7 ,s9
	index	l_supp_idx
	on	lineitem
			(l_suppkey, l_partkey, l_orderkey,l_quantity, l_extendedprice, l_discount, l_shipdate)
	with	fillfactor=95

go

 create --- s1 ,s14
	index	l_shipdate_idx
	on	lineitem
			(l_shipdate, l_quantity, l_extendedprice, l_discount, l_tax,l_returnflag
			, l_linestatus, l_partkey, l_suppkey, l_orderkey)
	with	fillfactor=95

go

 print '------------------ tab nation'

go

 create unique
	index	n_name_idx
	on	nation
		(n_name, n_regionkey, n_nationkey)
	with	fillfactor=100

go

 print '------------- tab orders (no clust idx)'

go

 create unique --- substitute for clust idx
	index	o_order_idx
	on	orders
			(o_orderkey, o_orderdate, o_custkey, o_orderpriority)
	with	fillfactor=95

go

 create unique --- s3
	index	o_cust_idx
	on	orders
			(o_custkey, o_orderkey, o_orderdate, o_shippriority)
	with	fillfactor=95

go

 create unique --- s4 ,s5 ,s8 ,s10
	index	o_date_idx
	on	orders
			(o_orderdate, o_custkey, o_orderkey, o_orderpriority)
	with	fillfactor=95

go

 create unique --- s13
	index	o_clerk_idx
	on	orders
			(o_clerk, o_orderdate, o_orderkey)
	with	fillfactor=95

go

 print '------------- tab part (no clust idx)'

go

 create unique --- s9? ,s16?
	index	p_part_idx
	on	part
			(p_partkey, p_type, p_size, p_brand, p_name)
	with	fillfactor=100

go

 create unique --- s8 ,s14
	index	p_type_idx
	on	part
			(p_type, p_partkey)
	with	fillfactor=100

go

 create unique --- s17
	index	p_brdcnt_idx
	on	part
			(p_brand, p_container, p_partkey)
	with	fillfactor=100

go

 create unique --- s2
	index	p_size_idx
	on	part
			(p_size, p_type, p_mfgr, p_partkey)
	with	fillfactor=100

go

 print '---------------- tab partsupp (no clust idx)'

go

 create unique
	index	ps_supp_idx
	on	partsupp
			(ps_suppkey, ps_partkey, ps_availqty, ps_supplycost)
	with	fillfactor=100

go

 create unique
	index	ps_part_idx
	on	partsupp
			(ps_partkey, ps_suppkey, ps_availqty, ps_supplycost)
	with	fillfactor=100

go

 print '------------- tab region'

go

 create unique
	index	r_name_idx
	on	region
			(r_name, r_regionkey)
	with	fillfactor=100

go

 print '-------------- tab supplier'

go

 create unique
	index	s_nation_idx
	on	supplier
			(s_nationkey, s_suppkey)
	with	fillfactor=100

go

 select 'File richnc.SQL execution ends at' ,convert(varchar,getdate(),113)

go
 --eof


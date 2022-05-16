 select 'File ncidx.SQL execution starts at' ,convert(varchar,getdate(),113)

go


----  Indexes for the REGION table

PRINT 'Creating r_namreg_idx'

 create unique index r_namreg_idx
	on region(r_name, r_regionkey)
	with fillfactor=100

go

----  Indexes for the NATION table
--
-- PRINT 'Creating n_natnam_idx'
--
-- create unique index n_natnam_idx
--	on nation (n_nationkey, n_name)
--	with fillfactor=100
--
--go

-- PRINT 'Creating n_namnat_idx'
--
-- create unique index n_namnat_idx
--	on nation (n_name, n_nationkey)
--	with fillfactor=100
--
--go

---- Note: IBM has this index as non-unique defined!?
-- PRINT 'Creating n_regnatnam_idx'
--
-- create unique index n_regnatnam_idx
--	on nation (n_regionkey, n_nationkey, n_name)
--	with fillfactor=100
--
--go


----  Indexes for the SUPPLIER table
--
-- PRINT 'Creating s_natsup_idx'
--
-- create unique index s_natsup_idx
--	on supplier (s_nationkey, s_suppkey)
--	with fillfactor=100
--
--go

-- add other keys for q2 9 avoid cluster index look up; benefit from caching -used twice)
 PRINT 'Creating s_supnat_idx'

 create unique index s_supnat_idx
	on supplier (s_suppkey, s_nationkey)
	with fillfactor=100

go
-- for s16 see impact?
-- PRINT 'Creating s_comnet_idx'
--
-- create index s_comment_idx
--	on supplier (s_suppkey, s_comment)
--	with fillfactor=100
--
--go

----  Indexes for the CUSTOMER table

 PRINT 'Creating c_natcus_idx'

 create unique index c_natcus_idx
	on customer (c_nationkey,c_custkey)
	with fillfactor=100

go
-- print 'creating c_custnat_idx ...'
-- for s5 ( see if changes plan) [optional - add afterwords

-- create unique index c_custnat_idx 
--	on customer (c_custkey, c_nationkey)
--	with fillfactor=100
-- go

----  see impact on s3 (some positive impact seen)
--
-- PRINT 'Creating c_mkt_idx'
--
-- create index c_mkt_idx
--	on customer(c_mktsegment, c_custkey)
--	with fillfactor=100
--
--go
----  Indexes for the PART table
---  added columns for Q16
---  added p_mfgr for Q2
 PRINT 'Creating p_siz_idx'

 create unique index p_siz_idx
	on part (p_size, p_brand, p_type, p_partkey, p_mfgr)
	with fillfactor=100

go

-- PRINT 'Creating p_braconpar_idx'
--
-- create unique index p_braconpar_idx
--	on part (p_brand, p_container, p_partkey)
--	with fillfactor=100
--
--go

-- PRINT 'Creating p_typsizparmfg_idx'
--
-- create unique index p_typsizparmfg_idx
--	on part (p_type, p_size, p_partkey, p_mfgr)
--	with fillfactor=100
--
-- used only in Q8

 PRINT 'Creating p_typpar_idx'

 create unique index p_typpar_idx
	on part (p_type, p_partkey)
	with fillfactor=100


go

-- PRINT 'Creating p_nampar_idx'
--
-- create unique index p_nampar_idx
--	on part (p_name, p_partkey)
--	with fillfactor=100
--
--go
---  add this one - to avoid sort on key (s9, s14)
-- PRINT 'Creating p_parnam_idx'
--
-- create unique index p_parnam_idx
--	on part (p_partkey, p_name,p_type)
--	with fillfactor=100
--
--go
----  Indexes for the PARTSUPP table

 PRINT 'Creating ps_pkyskysco_idx'

 create unique index ps_pkyskysco_idx
	on partsupp (ps_partkey, ps_suppkey, ps_supplycost)
	with fillfactor=100

go

-- PRINT 'Creating ps_skypkyscoava_idx'
--
-- create unique index ps_skypkyscoava_idx
--	on partsupp (ps_suppkey, ps_partkey, ps_supplycost, ps_availqty)
--	with fillfactor=100
--
--go

----  Indexes for the ORDERS table

 PRINT 'Creating o_cle_idx'

 create index o_cle_idx
	on orders (o_clerk, o_orderkey, o_orderdate)
	with fillfactor=95

go

---  added custkey to avoid cluster scan using o_key_idx for s5
-- PRINT 'Creating o_datkeyopr_idx'
-- for s4, s5, s8
-- create unique index o_datkeyopr_idx
--	on orders (o_orderdate, o_orderkey, o_custkey, o_orderpriority)
--	with fillfactor=95
--
--go

-- print 'creating o_keycusdat_idx'
-- for s3, s5, s7, s10, s12 (see any impact on plan) [optional]
-- create unique index o_keycusdat_idx
--	on orders (o_orderkey, o_orderdate, o_custkey, o_shippriority, o_orderpriority)
--	with fillfactor=95
--
--go

-- PRINT 'Creating o_cust_idx'
-- for s3, s5 (see any impact on plan) [optional]
-- create unique index o_cust_idx
--	on orders (o_custkey, o_orderkey, o_orderdate, o_shippriority)
---	with fillfactor=95

-- go

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
--print 'creating l_shmode_idx'
-- create --- s12 - reduce order count
--	index	l_shmode_idx
--	on	lineitem
--			(l_shipmode,l_orderkey, l_receiptdate, l_commitdate, l_shipdate)
--	with	fillfactor=95
--
--go
 print 'creating l_flag_idx'
 create --- s10 ,s13 
	index	l_flag_idx
	on	lineitem
			(l_returnflag, l_orderkey, l_extendedprice, l_discount)
	with	fillfactor=95

go
-- print 'creating l_part_idx'
-- -- for s8
-- create --- for multiple queries
--	index	l_part_idx
--	on	lineitem
--			(l_partkey, l_suppkey, l_orderkey, l_shipdate, l_quantity, 
--			 l_extendedprice, l_discount)
--	with	fillfactor=95
--
--go
--  print 'creating l_supp_idx ...'
--  -- created specifically for s9 - it needs stats for l_suppkey to build the appropriate plan
--  -- without this index, s9 chose plan and took 2000 sec Vs 139 sec
--  -- see also if s15 uses this index at all, if not reduce the keys to one 
-- create --- s5 ,s7 ,s9
--	index	l_supp_idx
--	on	lineitem
--			(l_suppkey, l_shipdate, l_extendedprice, l_discount)
--	with	fillfactor=95
--
--go
--  print 'creating l_shipdate_idx ..'
--
-- create --- s1 , s6, s14 , s15
--	index	l_shipdate_idx
--	on	lineitem
--			(l_shipdate,l_partkey, l_suppkey, l_quantity, l_extendedprice, l_discount, l_tax,l_returnflag
--			, l_linestatus)
--	with	fillfactor=95
--
--go

 select 'File ncidx.SQL execution ends at' ,convert(varchar,getdate(),113)

go







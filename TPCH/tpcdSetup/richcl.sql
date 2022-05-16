
 --- TPC_D\idxcl6.sql   GeneMi   1997/02/11 13:22
 --- Clustered indexes only, in this file.
 --- Likely all clustered indexes are also unique.
 --- From Goetz Graefe, optimized for Hydra not Sphinx.
go

 select 'File richcl.SQL execution starts at' ,convert(varchar,getdate(),113)

go

 print '------------ tab customer'

go

 create unique clustered
	index	c_cust_idx
	on	customer
			(c_custkey)
	with	sorted_data

go

 print '-------- tab lineitem (no clust idx)'

go

 print '------------------ tab nation'

go

 create unique clustered
	index	n_nation_idx
	on	nation
			(n_nationkey)
	with	sorted_data

go

 print '------------- tab orders (no clust idx)'

go

 print '------------- tab part (no clust idx)'

go

 print '---------------- tab partsupp (no clust idx)'

go

 print '------------- tab region'

go

 create unique clustered
	index	r_region_idx
	on	region
			(r_regionkey)
	with	sorted_data

go

 print '-------------- tab supplier'

go

 create unique clustered
	index	s_supp_idx
	on	supplier
			(s_suppkey)
	with	sorted_data

go

 select 'File richcl.SQL execution ends at' ,convert(varchar,getdate(),113)

go
 --eof


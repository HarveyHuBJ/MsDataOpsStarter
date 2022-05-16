
 /* tpc_d  vew_revu.sql */
 /* See s15.sql */
go

 if exists (select * from sysobjects where type='V ' and name = 'revenue')
    drop view revenue

 print 'create view revenue ...'

go

 CREATE VIEW REVENUE
	(SUPPLIER_NO
	,TOTAL_REVENUE
	)
 AS
 SELECT
		 L_SUPPKEY
		,SUM(L_EXTENDEDPRICE * (1-L_DISCOUNT))
	FROM
		 LINEITEM
	WHERE
		 L_SHIPDATE	>= '1996-1-1'
	AND	 L_SHIPDATE	< dateadd(mm, 3, '1996-1-1')
	GROUP BY
		 L_SUPPKEY

 /**/


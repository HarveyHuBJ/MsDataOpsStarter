alter table supplier add constraint fknation foreign key (s_nationkey) references nation (n_nationkey)
go
alter table customer add constraint fkcnation foreign key (c_nationkey) references nation (n_nationkey)
go
alter table orders add constraint fkcust foreign key (o_custkey) references customer (c_custkey)
go
alter table lineitem add constraint fkorders foreign key (l_orderkey) references orders (o_orderkey)
go
alter table lineitem add constraint fkpps foreign key (l_partkey, l_suppkey) references partsupp (ps_partkey, ps_suppkey)
go
alter table nation add constraint fkregion foreign key (n_regionkey) references region (r_regionkey)
go
alter table partsupp add constraint fkp foreign key (ps_partkey) references part(p_partkey)
go
alter table partsupp add constraint fks foreign key (ps_suppkey) references supplier(s_suppkey)
go

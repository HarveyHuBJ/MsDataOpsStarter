alter table supplier drop constraint fknation 
go
alter table customer drop constraint fkcnation 
go
alter table orders drop constraint fkcust
go
alter table lineitem drop constraint fkorders 
go
alter table lineitem drop constraint fkpps 
go
alter table nation drop constraint fkregion 
go
alter table partsupp drop constraint fkp 
go
alter table partsupp drop constraint fks 
go

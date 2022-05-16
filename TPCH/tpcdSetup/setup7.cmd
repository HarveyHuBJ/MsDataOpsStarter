@echo off
rem @echo on

rem
rem SPHINX INSTALL
rem
rem 300 MBytes (+ log) required for file  if "sparse" indexes are built
rem 500 MBytes (+ log) required for file  if "rich" indexes are built
rem  5 GB (+log) if 1G database with IBM indexes is built
rem 100 MBytes required in tempdb (extended by script)
rem

SET SKEW=-z %3
SET TPCDDBNAME=%4


if /I '%2'=='1G' SET TPCDDEVNO=32
rem if /I '%2'=='1G' SET TPCDSIZE=2400000
if /I '%2'=='1G' SET TPCDSIZE=1500000
if /I '%2'=='1G' SET TPCDCLUIDX=1Gclidx
if /I '%2'=='1G' SET TPCDNOCLUIDX=1Gncidx
if /I '%2'=='1G' SET sanity=san1G

if /I '%2'=='10G' SET TPCDDEVNO=33
rem if /I '%2'=='10G' SET TPCDSIZE=24000000
if /I '%2'=='10G' SET TPCDSIZE=15000000
if /I '%2'=='10G' SET TPCDCLUIDX=10Gclidx
if /I '%2'=='10G' SET TPCDNOCLUIDX=10Gncidx
if /I '%2'=='10G' SET sanity=san10G

SET DATANAME=%1.dat
SET LOGNAME=%1_log.dat


if ''=='%TPCDDBNAME%' goto :USAGE
if ''=='%SKEW%' goto :USAGE


rem if /I '%PROCESSOR_ARCHITECTURE%'=='x86' SET bcp=bcp 
rem if /I '%PROCESSOR_ARCHITECTURE%'=='alpha' SET bcp=alpha\bcp
SET bcp=bcp

echo =============================================================
echo attempting to drop the database (may fail if it didn't exist)
echo =============================================================

osql -E -Q "drop database [%TPCDDBNAME%]" 



echo =============================================================
echo attempting to create the database 
echo =============================================================

osql -E -Q "create database [%TPCDDBNAME%] ON (Name = [%TPCDDBNAME%], FileName = '%DATANAME%') LOG ON (Name = [%TPCDDBNAME%_Log], FileName = '%LOGNAME%')"

:CREATETBL

echo =============================================================
echo created database
echo =============================================================

sqlcmd -E -d %TPCDDBNAME% -i tab_cre.sql
sqlcmd -E -d %TPCDDBNAME% -i vew_revu.sql

:LOADTABLE

echo =============================================================
echo load data
echo =============================================================

sqlcmd -E -d master -i conftpcd.sql
sqlcmd -E -d master -Q"sp_dboption [%TPCDDBNAME%], 'select ',true"
sqlcmd -E -d master -Q"sp_dboption [%TPCDDBNAME%], 'trunc. ',true"

echo =============================================================
echo Set db options
echo =============================================================

rem GOTO :SKIPLOAD

echo ..\TPCDSkew\dbgen -vf -s 10 -T n %SKEW%

if /I '%2'=='10G' ..\TPCDSkew\dbgen -vf -s 10 -T n %SKEW%
if /I '%2'=='1G' ..\TPCDSkew\dbgen -vf -s 1 -T n %SKEW%
%bcp% %TPCDDBNAME%..nation in "nation.tbl"  /c /b 1000 /a 65535 /t"|" /r"|\n" /T 
del nation.tbl

if /I '%2'=='10G' ..\TPCDSkew\dbgen -vf -s 10 -T s %SKEW%
if /I '%2'=='1G' ..\TPCDSkew\dbgen -vf -s 1 -T s %SKEW%
%bcp% %TPCDDBNAME%..supplier in "supplier.tbl" /c /b 1000 /a 65535 /t"|" /r"|\n" /T
del supplier.tbl

if /I '%2'=='10G' ..\TPCDSkew\dbgen -vf -s 10 -T r %SKEW%
if /I '%2'=='1G' ..\TPCDSkew\dbgen -vf -s 1 -T r %SKEW%
%bcp% %TPCDDBNAME%..region in "region.tbl"  /c /b 1000 /a 65535 /t"|" /r"|\n" /T 
del region.tbl

if /I '%2'=='10G' ..\TPCDSkew\dbgen -vf -s 10 -T P %SKEW%
if /I '%2'=='1G' ..\TPCDSkew\dbgen -vf -s 1 -T P %SKEW%
%bcp% %TPCDDBNAME%..part in "part.tbl"  /c /b 1000 /a 65535 /t"|" /r"|\n" /T 
del part.tbl

if /I '%2'=='10G' ..\TPCDSkew\dbgen -vf -s 10 -T c %SKEW%
if /I '%2'=='1G' ..\TPCDSkew\dbgen -vf -s 1 -T c %SKEW%
%bcp% %TPCDDBNAME%..customer in "customer.tbl"  /c /b 1000 /a 65535 /t"|" /r"|\n" /T 
del customer.tbl

if /I '%2'=='10G' ..\TPCDSkew\dbgen -vf -s 10 -T S %SKEW%
if /I '%2'=='1G' ..\TPCDSkew\dbgen -vf -s 1 -T S %SKEW%
%bcp% %TPCDDBNAME%..partsupp in "partsupp.tbl"  /c /b 1000 /a 65535 /t"|" /r"|\n" /T 
del partsupp.tbl

if /I  '%2'=='10G' ..\TPCDSkew\dbgen -vf -s 10 -T O %SKEW%
if /I  '%2'=='1G' ..\TPCDSkew\dbgen -vf -s 1 -T O %SKEW%
%bcp% %TPCDDBNAME%..orders in "order.tbl"  /c /b 1000 /a 65535 /t"|" /r"|\n" /T 
del order.tbl

if /I  '%2'=='10G' ..\TPCDSkew\dbgen -vf -s 10 -T L %SKEW%
if /I  '%2'=='1G' ..\TPCDSkew\dbgen -vf -s 1 -T L %SKEW%
%bcp% %TPCDDBNAME%..lineitem in "lineitem.tbl"  /c /b 1000 /a 65535 /t"|" /r"|\n" /T 
del lineitem.tbl


:SKIPLOAD

rem index creation is disabled for testing of index selection tool.
rem echo build [%TPCDDBNAME%] indices

rem sqlcmd -E -d [%TPCDDBNAME%] -i %TPCDCLUIDX%.sql
rem sqlcmd -E -d [%TPCDDBNAME%] -i %TPCDNOCLUIDX%.sql


rem the following Update Statistics is not more required because they are 
rem updated by the Create Index command
rem sqlcmd -E -d [%TPCDDBNAME%] -i UpdStat.sql

rem ***********************************
echo Setting up the update streans
rem ***********************************


del delete.1
del order.tbl.u1
del lineitem.tbl.u1

if /I '%1'=='1G' ..\TPCDSkew\dbgen -s 1 -O s
if /I '%1'=='1G' ..\TPCDSkew\dbgen -U 1 -s 1

if /I '%1'=='10G' ..\TPCDSkew\dbgen -s 10 -O s 
if /I '%1'=='10G' ..\TPCDSkew\dbgen -U 1 -s 10 

echo create temp tables

sqlcmd -E -d [%TPCDDBNAME%] -i tab_creU.sql

echo load data

if /I '..\TPCDSkew'=='x86' SET bcp=bcp
if /I '..\TPCDSkew'=='alpha' SET bcp=alpha\bcp


rem %bcp% %TPCDDBNAME%..oldorders in "delete.1"  /c  /b 1000 /a 65535 /T 

rem %bcp% %TPCDDBNAME%..neworders in "order.tbl.u1" /c /b 1000 /a 65535 /t"|" /r"|\n" /T 

rem %bcp% %TPCDDBNAME%..newlineitem in "lineitem.tbl.u1" /c /b 1000 /a 65535 /t"|" /r"|\n" /T 

sqlcmd -E -d [%TPCDDBNAME%] -Q "checkpoint"

sqlcmd -E -d [%TPCDDBNAME%] -i %sanity%.sql

sqlcmd -E -d master -Q"sp_dboption [%TPCDDBNAME%], 'select ',false"
sqlcmd -E -d master -Q"sp_dboption [%TPCDDBNAME%], 'trunc. ',false"


rem sqlcmd -E -d [%TPCDDBNAME%] -i addWeightsCol.sql
rem sqlcmd -E -d [%TPCDDBNAME%] -i creExtPriceIdx.sql


goto END



:USAGE

echo specify file name for device, a set of indices (rich,sparse,1G),a skew factor, and database name
echo example: setup7.cmd d:\data70\tpcd7r  rich    0   tpcdSmallUnif
echo example: setup7.cmd d:\data70\tpcd7s  sparse  4   tpcdSmallSkew4
echo example: setup7.cmd d:\data70\tpcd1G  1G      1.52  tpcd1GFracSkew
echo example: setup7.cmd d:\data70\tpcd1G  1G      -1  tpcd1GMixedSkew

:END

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

SET TPCDDBNAME=unknown


if /I '%2'=='SPARSE' SET TPCDDBNAME=tpcds
if /I '%2'=='SPARSE' SET TPCDDEVNO=30
if /I '%2'=='SPARSE' SET TPCDSIZE=150720
if /I '%2'=='SPARSE' SET TPCDCLUIDX=sparsecl
if /I '%2'=='SPARSE' SET TPCDNOCLUIDX=sparsenc
if /I '%2'=='SPARSE' SET sanity=san100M


if /I '%2'=='RICH' SET TPCDDBNAME=tpcdr
if /I '%2'=='RICH' SET TPCDDEVNO=31
if /I '%2'=='RICH' SET TPCDSIZE=240000
if /I '%2'=='RICH' SET TPCDCLUIDX=richcl
if /I '%2'=='RICH' SET TPCDNOCLUIDX=richnc
if /I '%2'=='RICH' SET sanity=san100M


if /I '%2'=='1G' SET TPCDDBNAME=tpcd1G
if /I '%2'=='1G' SET TPCDDEVNO=32
if /I '%2'=='1G' SET TPCDSIZE=2400000
if /I '%2'=='1G' SET TPCDCLUIDX=sparsecl
if /I '%2'=='1G' SET TPCDNOCLUIDX=1Gncidx
if /I '%2'=='1G' SET sanity=san1G

if unknown==%TPCDDBNAME% goto :USAGE

rem GOTO :LOADTABLE

rem GOTO :CREATETBL

echo create device, database

isql -Usa -P -Q "disk resize name='tempdev', size = 51200" 

echo =============================================================
echo attempting to drop the database (may fail if it didn't exist)
echo =============================================================

isql -Usa -P -Q "drop database %TPCDDBNAME%" 

echo =============================================================
echo attempting to drop the davice (may fail if it didn't exist)
echo =============================================================

isql -Usa -P -Q "sp_dropdevice '%TPCDDBNAME%', delfile"
isql -Usa -P -Q "disk init name='%TPCDDBNAME%', physname='%1', vdevno=%TPCDDEVNO%, size=%TPCDSIZE%"
isql -Usa -P -Q "create database %TPCDDBNAME% on %TPCDDBNAME%"

:CREATETBL

isql -Usa -P -d %TPCDDBNAME% -i tab_cre.sql
isql -Usa -P -d %TPCDDBNAME% -i vew_revu.sql

:LOADTABLE

echo load data

isql -Usa -P -d master -i conftpcd.sql
isql -Usa -P -d master -Q"sp_dboption %TPCDDBNAME%, 'select ',true"
isql -Usa -P -d master -Q"sp_dboption %TPCDDBNAME%, 'trunc. ',true"

rem GOTO :SKIPLOAD

if /I '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 1 -T n
if /I NOT '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 0.1 -T n
bcp %TPCDDBNAME%..nation in "nation.tbl"  /c /t"|" /r"|\n" /Usa /P 
del nation.tbl

if /I '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 1 -T s
if /I NOT '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 0.1 -T s
bcp %TPCDDBNAME%..supplier in "supplier.tbl" /c /t"|" /r"|\n" /Usa /P 
del supplier.tbl

if /I '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 1 -T r
if /I NOT '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 0.1 -T r
bcp %TPCDDBNAME%..region in "region.tbl"  /c /t"|" /r"|\n" /Usa /P 
del region.tbl

if /I '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 1 -T P
if /I NOT '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 0.1 -T P
bcp %TPCDDBNAME%..part in "part.tbl"  /c /t"|" /r"|\n" /Usa /P 
del part.tbl

if /I '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 1 -T c
if /I NOT '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 0.1 -T c
bcp %TPCDDBNAME%..customer in "customer.tbl"  /c /t"|" /r"|\n" /Usa /P 
del customer.tbl

if /I '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 1 -T S
if /I NOT '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 0.1 -T S
bcp %TPCDDBNAME%..partsupp in "partsupp.tbl"  /c /t"|" /r"|\n" /Usa /P 
del partsupp.tbl

if /I  '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 1 -T O
if /I NOT '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 0.1 -T O
bcp %TPCDDBNAME%..orders in "order.tbl"  /c /t"|" /r"|\n" /Usa /P 
del order.tbl

if /I  '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 1 -T L
if /I NOT '%2'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -vf -s 0.1 -T L
bcp %TPCDDBNAME%..lineitem in "lineitem.tbl"  /c /t"|" /r"|\n" /Usa /P 
del lineitem.tbl


if /I '%2'=='1G' isql -Usa -P -Q "disk resize name='tempdev', size = 256000"

:SKIPLOAD

echo build %TPCDDBNAME% indices

isql -Usa -P -d %TPCDDBNAME% -i %TPCDCLUIDX%.sql
isql -Usa -P -d %TPCDDBNAME% -i %TPCDNOCLUIDX%.sql

isql -Usa -P -d master -Q"sp_dboption %TPCDDBNAME%, 'select ',false"
isql -Usa -P -d master -Q"sp_dboption %TPCDDBNAME%, 'trunc. ',false"

rem the following Update Statistics is not more required because they are 
rem updated by the Create Index command
rem isql -Usa -P -d %TPCDDBNAME% -i UpdStat.sql

isql -Usa -P -d %TPCDDBNAME% -Q "checkpoint"

isql -Usa -P -d %TPCDDBNAME% -i %sanity%.sql

goto END



:USAGE

echo specify file name for device, and set of indices (rich,sparse)
echo example: setup d:\data70\tpcd7r.dat rich
echo example: setup d:\data70\tpcd7s.dat sparse
echo example: setup d:\data70\tpcd1G.dat 1G

:END

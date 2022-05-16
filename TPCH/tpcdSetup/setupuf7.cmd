@echo off

rem
rem setup update streams
rem


SET TPCDDBNAME=unknown

rem delete.1, order.tbl.u1 and lineitem.tbl.u1 will be created 
rem before running this script, you should run dbgen:
rem 1. %PROCESSOR_ARCHITECTURE%\dbgen -s 1 -O s    --> generate the seeds set for scale 1
rem 2. %PROCESSOR_ARCHITECTURE%\dbgen -U 1 -s 0.1  --> generate the required files (for scale 0.1)

if /I '%1'=='SPARSE' SET TPCDDBNAME=tpcds

if /I '%1'=='RICH' SET TPCDDBNAME=tpcdr

if /I '%1'=='1G' SET TPCDDBNAME=tpcd1G

if unknown==%TPCDDBNAME% goto :USAGE

del delete.1
del order.tbl.u1
del lineitem.tbl.u1

if /I '%1'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -s 1 -O s 
if /I '%1'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -U 1 -s 1

if /I NOT '%1'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -s 0.1 -O s 
if /I NOT '%1'=='1G' %PROCESSOR_ARCHITECTURE%\dbgen -U 1 -s 0.1

 


echo create temp tables

isql -Usa -P -d %TPCDDBNAME% -i tab_creU.sql

echo load data


isql -Usa -P -d master -Q"sp_dboption %TPCDDBNAME%, 'select ',true"
isql -Usa -P -d master -Q"sp_dboption %TPCDDBNAME%, 'trunc. ',true"

if /I '%PROCESSOR_ARCHITECTURE%'=='x86' SET bcp=bcp
if /I '%PROCESSOR_ARCHITECTURE%'=='alpha' SET bcp=alpha\bcp


%bcp% %TPCDDBNAME%..oldorders in "delete.1"  /c  /Usa /P 

%bcp% %TPCDDBNAME%..neworders in "order.tbl.u1" /c /t"|" /r"|\n" /Usa /P 

%bcp% %TPCDDBNAME%..newlineitem in "lineitem.tbl.u1" /c /t"|" /r"|\n" /Usa /P 


isql -Usa -P -d master -Q"sp_dboption %TPCDDBNAME%, 'select ',false"
isql -Usa -P -d master -Q"sp_dboption %TPCDDBNAME%, 'trunc. ',false"

goto END



:USAGE

echo specify the database (rich,sparse)
echo example: setupupd7  rich
echo example: setupupd7  sparse
echo example: setupupd7  1G
:END

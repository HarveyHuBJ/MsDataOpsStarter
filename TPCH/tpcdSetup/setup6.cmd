@echo off

rem
rem HYDRA INSTALL
rem
rem 600 MBytes required for file
rem

if '%2'=='sparse' goto OKARG
if '%2'=='SPARSE' goto OKARG
if '%2'=='rich' goto OKARG
if '%2'=='RICH' goto OKARG
goto USAGE

:OKARG

echo create device, database

isql -Usa -P -Q "drop database tpcd"
isql -Usa -P -Q "sp_dropdevice 'tpcd', delfile"
isql -Usa -P -Q "disk init name='tpcd', physname='%1', vdevno=30, size=307200"
isql -Usa -P -Q "create database tpcd on tpcd = 600"

isql -Usa -P -i createdb.sql
isql -Usa -P -d tpcd -i tab_cre.sql
isql -Usa -P -d tpcd -i vew_revu.sql

echo load data

isql -Usa -P -d tpcd -i sptabop.sql
dbgen -vD -s 0.1 -T n
dbgen -vD -s 0.1 -T r
dbgen -vD -s 0.1 -T s
dbgen -vD -s 0.1 -T c
dbgen -vD -s 0.1 -T P
dbgen -vD -s 0.1 -T S
dbgen -vD -s 0.1 -T O
dbgen -vD -s 0.1 -T L

if '%2'=='sparse' goto SPARSE
if '%2'=='SPARSE' goto SPARSE
if '%2'=='rich' goto RICH
if '%2'=='RICH' goto RICH

:SPARSE

echo build sparse indices

isql -Usa -P -d tpcd -i sparsecl.sql
isql -Usa -P -d tpcd -i sparsenc.sql
isql -Usa -P -d tpcd -i UpdStat.sql
goto END

:RICH

echo build rich indices

isql -Usa -P -d tpcd -i richcl.sql
isql -Usa -P -d tpcd -i richnc.sql
isql -Usa -P -d tpcd -i UpdStat.sql
goto END

:USAGE

echo specify file name for device, and set of indices (rich,sparse)
echo example: setup d:\data65\tpcd6.dat rich
echo example: setup d:\data65\tpcd6.dat sparse

:END

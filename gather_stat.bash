#!/bin/bash

export ORACLE_SID=$1

export ORACLE_HOME=/u02/app/oracle/product/19.3.0/db_1
export PATH=$ORACLE_HOME/bin:$PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin
export REFRESH_DATE=`date +"%Y_%m_%d"`

$ORACLE_HOME/bin/sqlplus -s / as sysdba  <<EOF


SET feedback off
SET verify off
SET echo off
SET termout OFF
SET pages 50000
SET heading OFF
SET linesize 120


SPOOL /u02/app/oracle/scripts/dba/logs/analyze_table_${ORACLE_SID}_${REFRESH_DATE}.sql
SELECT 'SPOOL /u02/app/oracle/scripts/dba/logs/analyze_table_${ORACLE_SID}_${REFRESH_DATE}.log ' FROM dual;
SELECT 'SET ECHO ON' FROM DUAL;
SELECT 'SET TIMING ON' FROM DUAL;
SELECT 'SELECT * FROM GLOBAL_NAME;' FROM DUAL;
SELECT 'SELECT SYSDATE FROM DUAL;'  FROM DUAL;
SELECT 'ANALYZE TABLE ' || OWNER || '.' || TABLE_NAME || ' COMPUTE STATISTICS;' FROM
DBA_TABLES WHERE OWNER IN ('DW','SYSADM');
SELECT 'SET TIMING OFF' FROM DUAL;
SELECT 'select ' || '''' || ' ANALYZE COMPLETED FOR ${ORACLE_SID}' || '''' ||' from dual;' FROM DUAL;
SELECT 'SPOOL OFF' FROM dual;
SELECT 'EXIT;' FROM dual;

SPOOL OFF

-- Execute the sql file created earlier
@/u02/app/oracle/scripts/dba/logs/analyze_table_${ORACLE_SID}_${REFRESH_DATE}.sql
EXIT
/
EOF

$ORACLE_HOME/bin/sqlplus -s / as sysdba  <<EOF


SET feedback off
SET verify off
SET echo off
SET termout OFF
SET pages 50000
SET heading OFF
SET linesize 120


SPOOL /u02/app/oracle/scripts/dba/logs/rebuild_indexes_${ORACLE_SID}_${REFRESH_DATE}.sql
SELECT 'SPOOL /u02/app/oracle/scripts/dba/logs/rebuild_indexes_${ORACLE_SID}_${REFRESH_DATE}.log ' FROM dual;
SELECT 'SET ECHO ON' FROM DUAL;
SELECT 'SET TIMING ON' FROM DUAL;
SELECT 'SELECT * FROM GLOBAL_NAME;' FROM DUAL;
SELECT 'SELECT SYSDATE FROM DUAL;'  FROM DUAL;
SELECT 'ALTER INDEX ' || OWNER || '.' || INDEX_NAME || ' REBUILD ONLINE NOLOGGING;' FROM
DBA_INDEXES WHERE OWNER IN ('DW','SYSADM') AND INDEX_TYPE <> 'LOB';
SELECT 'SET TIMING OFF' FROM DUAL;
SELECT 'select ' || '''' || ' INDEX REBUILD COMPLETED FOR ${ORACLE_SID}' || '''' ||' from dual;' FROM DUAL;
SELECT 'SPOOL OFF' FROM dual;
SELECT 'EXIT;' FROM dual;

SPOOL OFF

-- Execute the sql file created earlier
@/u02/app/oracle/scripts/dba/logs/rebuild_indexes_${ORACLE_SID}_${REFRESH_DATE}.sql
EXIT
/
EOF


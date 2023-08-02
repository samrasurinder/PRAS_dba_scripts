#!/bin/bash

export ORACLE_HOME=/u02/app/oracle/product/19.3.0/db_1
export LD_LIBRARY_PATH=/u02/app/oracle/product/19.3.0/db_1
export PATH=$ORACLE_HOME/bin:$PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin
export NLS_DATE_FORMAT='yyyy/mm/dd hh24:mi:ss';
export TIMESTAMP=`date +"%Y%m%d_%H%M%S"`
export INST=`hostname`
export ORAENV_ASK=NO
export JOB_STATUS=0
db_list=`ps -efZ | grep [p]mon | grep -v asm | awk '{print $NF}' | sed s/ora_pmon_// | grep -v / | grep -v "-"`

for db in $db_list
do
export ORACLE_SID=$db

EXPDPDIR=`sqlplus -s "/ as sysdba" <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
select name from v\\$database;
EXIT;
EOF`


sqlplus -s "/ as sysdba" <<EOF
EXEC DBMS_STATS.GATHER_FIXED_OBJECTS_STATS (NULL);
EXEC DBMS_STATS.GATHER_DICTIONARY_STATS;
EXEC DBMS_STATS.GATHER_SYSTEM_STATS;
EXIT;
EOF


export EXPDPDIR_PATH=/infshare/oracle/exports/${EXPDPDIR}

if [ -z "$EXPDPDIR" ]; then
  echo "No rows returned from database"
  exit 0
else
  DUMPFILE=expdp_${db}_${TIMESTAMP}_%U.dmp
  LOGFILE=expdp_${db}_${TIMESTAMP}.log
  $ORACLE_HOME/bin/expdp \'/ as sysdba\' EXCLUDE=INDEX_STATISTICS EXCLUDE=TABLE_STATISTICS parallel=8 full=y directory=${EXPDPDIR} dumpfile=${DUMPFILE} logfile=${LOGFILE} max_metadata_parallel=4 compression=all
fi

done

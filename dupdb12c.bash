#!/bin/bash

export ORACLE_SID=RMAD
export ORACLE_HOME=/u02/app/oracle/product/12.2/db_1
export PATH=$ORACLE_HOME/bin:$PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin

INST=`hostname`
TODAY=`date +%d%b`
BACKUP_DIR=/infshare/oracle/exports/RMAG/bkp
LOG_DIR=/infshare/oracle/exports/RMAG/bkp
LOGFILE=$LOG_DIR/rman_dup_${ORACLE_SID}_${TODAY}.log
ERRFILE=$LOG_DIR/rman_dup_err_status.log
$ORACLE_HOME/bin/rman <<EOF > ${LOGFILE}
connect auxiliary /
run {
allocate auxiliary channel t1 TYPE DISK;
allocate auxiliary channel t2 TYPE DISK;
allocate auxiliary channel t3 TYPE DISK;
allocate auxiliary channel t4 TYPE DISK;
duplicate target database to RMAD  NOFILENAMECHECK backup location '/infshare/oracle/exports/RMAG/bkp';
}
exit
EOF

#!/bin/bash

export ORACLE_SID=$1
export ORACLE_HOME=/u02/app/oracle/product/19.3.0/db_1
export LD_LIBRARY_PATH=/u02/app/oracle/product/19.3.0/db_1
export PATH=$ORACLE_HOME/bin:$PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin
export NLS_DATE_FORMAT='yyyy/mm/dd hh24:mi:ss';
export CURRENT_TIME=`date +%y%m%d%H%M%S`
export MAIL_ID=reddya1@state.gov
export RMAN_TAG_NAME="${ORACLE_SID}_${CURRENT_TIME}"
export INST=`hostname`
export TODAY=`date +%d%b`
export SCRIPTS_DIR=/u02/app/oracle/scripts/backups
export LOG_DIR=${SCRIPTS_DIR}/logs
export LOGFILE=${LOG_DIR}/rman_backup_${ORACLE_SID}_${CURRENT_TIME}.log

case $ORACLE_SID in
     PRASPMU)
       $ORACLE_HOME/bin/sqlplus -s / as sysdba  <<EOF 
       select * from global_name;
       select * from v\$encryption_wallet;
       alter system set wallet open identified by PmcKNAMR6zus\$;
       select * from v\$encryption_wallet;
EOF
     ;;

     RMAD)
       $ORACLE_HOME/bin/sqlplus -s / as sysdba  <<EOF 
       select * from global_name;
       select * from v\$encryption_wallet;
       --alter system set wallet open identified by SbkRMADBN56\$\$;
       alter system set wallet open identified by SfM\$GAMR2ndbo;
       select * from v\$encryption_wallet;
EOF
     ;;

     RMAG)
       $ORACLE_HOME/bin/sqlplus -s / as sysdba  <<EOF 
       select * from global_name;
       select * from v\$encryption_wallet;
       alter system set wallet open identified by SfM\$GAMR2ndbo;
       select * from v\$encryption_wallet;
EOF
     ;;


     RMAN)
       $ORACLE_HOME/bin/sqlplus -s / as sysdba  <<EOF 
       select * from global_name;
       select * from v\$encryption_wallet;
       alter system set wallet open identified by SfcJNAMR6yt\$\$;
       select * from v\$encryption_wallet;
EOF
     ;;

     *)
      echo -n "unknown"
      ;;
esac

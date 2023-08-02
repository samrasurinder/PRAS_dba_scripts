#!/bin/bash -xv

df -h
export TRACE_DIR=/u02/app/oracle/diag/rdbms
export DUMP_DIR=/infshare/oracle/exports
db_list=`ps -efZ | grep [p]mon | grep -v asm | awk '{print $NF}' | sed s/ora_pmon_// | grep -v / | grep -v "-"`

for db in $db_list
do
mv ${TRACE_DIR}/"${db,,}"/${db}/trace/alert_${db}.log ${TRACE_DIR}/"${db,,}"/${db}/trace/alert_${db}_$(date +%m%d%y).log
find ${TRACE_DIR}/"${db,,}"/${db}/trace         -mtime +7 -name "*.tr*" -exec rm {} \;
find ${TRACE_DIR}/"${db,,}"/${db}/trace         -mtime +7 -name "*.log" -exec rm {} \;
find ${TRACE_DIR}/"${db,,}"/${db}/alert         -mtime +7 -name "*.xml" -exec rm {} \;
find ${DUMP_DIR}/${db}                          -mtime +3 -name "*.dmp" -exec rm {} \;
find ${DUMP_DIR}/${db}                          -mtime +3 -name "*.log" -exec rm {} \;
done



## Remove crontab logs more than 7 days old
find /u02/app/oracle/scripts/backups/logs       -mtime +7 -name "*.log" -exec rm {} \;
find /u02/app/oracle/scripts/dba/logs           -mtime +7 -name "*.log" -exec rm {} \;

## Remove ASM instance audit logs more than 1 day old
##find  /u02/app/grid/rdbms/audit                          -mtime +1 -name "*.aud" -exec rm {} \;

## Rotate ASM instance alert log
mv /u02/app/grid/diag/asm/+asm/+ASM/trace/alert_+ASM.log /u02/app/grid/diag/asm/+asm/+ASM/trace/alert_+ASM_$(date +%m%d%y).log

## Remove ASM trace files more than 7 days old
find /u02/app/grid/diag/asm/+asm/+ASM/trace          -mtime +7 -name "*.tr*" -exec rm {} \;
find /u02/app/grid/diag/asm/+asm/+ASM/alert          -mtime +7 -name "*.xml" -exec rm {} \;
find /u02/app/grid/diag/tnslsnr/hrewprasoel02/listener/alert  -mtime +7 -name "*.xml" -exec rm {} \;
find /u02/app/grid/diag/tnslsnr/hrewprasoel02/listener/trace  -mtime +7 -name "*.log" -exec rm {} \;

## Rotate Listener logs for both ASM and RDBMS
mv /u02/app/grid/diag/tnslsnr/hrewprasoel02/listener/trace/listener.log /u02/app/grid/diag/tnslsnr/hrewprasoel02/listener/trace/listener_$(date +%m%d%y).log

df -h


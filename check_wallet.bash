#!/bin/bash

db_list=`ps -efZ | grep [p]mon | grep -v asm | awk '{print $NF}' | sed s/ora_pmon_// | grep -v / | grep -v "-"`

for db in $db_list
do
/u02/app/oracle/scripts/dba/set_wallet.bash $db
done



alter system set db_recovery_file_dest='+FRA' scope=both;
alter system set db_recovery_file_dest_size=300G scope=both;
alter system set db_flashback_retention_target=4320 scope=both;
alter database flashback on;

# PRAS_dba_scripts
dba scripts used in PRAS to export databases for all databases etc.
The path for backup scripts is /u02/app/oracle/scripts/backups
The path for DBA scripts is /u02/app/oracle/scripts/dba

script "rotatelogs.bash" gets executed in crontab by linux user "root". <- it cleans up all logfiles are the databases.

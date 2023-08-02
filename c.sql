select name,open_mode from v$database;
set line 200
col OWNER for a20
col DIRECTORY_NAME for a35
col DIRECTORY_PATH for a67
select OWNER,DIRECTORY_NAME,DIRECTORY_PATH from dba_directories;

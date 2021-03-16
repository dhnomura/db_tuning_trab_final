SET PAGESIZE 100
SET LINESIZE 265

COLUMN tablespace_name FORMAT A30
COLUMN file_name FORMAT A100
COLUMN used_pct FORMAT A12


SELECT df.tablespace_name,
       df.file_name,
       df.size_mb,
       f.free_mb,
       df.max_size_mb,
       f.free_mb + (df.max_size_mb - df.size_mb) AS max_free_mb,
       RPAD(' '|| RPAD('X',ROUND((df.max_size_mb-(f.free_mb + (df.max_size_mb - df.size_mb)))/max_size_mb*10,0), 'X'),11,'-') AS used_pct
FROM   (SELECT file_id,
               file_name,
               tablespace_name,
               TRUNC(bytes/1024/1024) AS size_mb,
               TRUNC(GREATEST(bytes,maxbytes)/1024/1024) AS max_size_mb
        FROM   dba_data_files) df,
       (SELECT TRUNC(SUM(bytes)/1024/1024) AS free_mb,
               file_id
        FROM dba_free_space
        GROUP BY file_id) f
WHERE  df.file_id = f.file_id (+)
ORDER BY df.tablespace_name,
         df.file_name;
		 
TABLESPACE_NAME      FILE_NAME                                                                                               SIZE_MB    FREE_MB MAX_SIZE_MB MAX_FREE_MB USED_PCT
-------------------- ---------------------------------------------------------------------------------------------------- ---------- ---------- ----------- ----------- ------------
SYSAUX               +DATA/CDBPRD01/BC521E8F20523FF9E055911C06D663FD/DATAFILE/sysaux.278.1065607877                              440         24       32767       32351  ----------
SYSTEM               +DATA/CDBPRD01/BC521E8F20523FF9E055911C06D663FD/DATAFILE/system.277.1065607877                              340          4       32767       32431  ----------
TBS_DATA_16K         +DATA/CDBPRD01/BC521E8F20523FF9E055911C06D663FD/DATAFILE/tbs_data_16k.299.1067116017                         50         49          50          49  ----------
TBS_DATA_2K          +DATA/CDBPRD01/BC521E8F20523FF9E055911C06D663FD/DATAFILE/tbs_data_2k.297.1067115983                          50         49          50          49  ----------
TBS_DATA_4K          +DATA/CDBPRD01/BC521E8F20523FF9E055911C06D663FD/DATAFILE/tbs_data_4k.298.1067116011                          50         49          50          49  ----------
UNDOTBS1             +DATA/CDBPRD01/BC521E8F20523FF9E055911C06D663FD/DATAFILE/undotbs1.276.1065607877                            120         92       32767       32739  ----------
USERS                +DATA/CDBPRD01/BC521E8F20523FF9E055911C06D663FD/DATAFILE/users.280.1065607923                                 5          4       32767       32766  ----------

7 rows selected.

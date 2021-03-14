-- Trabalho Final --

-- 1 Desafio 
-- Criar tablespaces com 2k, 4k, 16k 

PDBPR01 = (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.51)(PORT = 1521))(CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = PDBPR01)))

show parameter _cache_size

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_16k_cache_size                    big integer 0
db_2k_cache_size                     big integer 0
db_32k_cache_size                    big integer 0
db_4k_cache_size                     big integer 0
db_8k_cache_size                     big integer 0

alter system set db_16k_cache_size=200m;
alter system set db_2k_cache_size =200m;
alter system set db_4k_cache_size =200m;

SQL> show parameter _cache_size

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_16k_cache_size                    big integer 208M
db_2k_cache_size                     big integer 208M
db_4k_cache_size                     big integer 208M

CREATE TABLESPACE TBS_DATA_2k DATAFILE '+DATA' SIZE 50M BLOCKSIZE 2K; 
CREATE TABLESPACE TBS_DATA_4k DATAFILE '+DATA' SIZE 50M BLOCKSIZE 4K; 
CREATE TABLESPACE TBS_DATA_16k DATAFILE '+DATA' SIZE 50M BLOCKSIZE 16K; 

SQL> CREATE TABLESPACE TBS_DATA_2k DATAFILE '+DATA' SIZE 50M BLOCKSIZE 2K;

Tablespace created.

SQL> CREATE TABLESPACE TBS_DATA_4k DATAFILE '+DATA' SIZE 50M BLOCKSIZE 4K;

Tablespace created.

SQL> CREATE TABLESPACE TBS_DATA_16k DATAFILE '+DATA' SIZE 50M BLOCKSIZE 16K;

Tablespace created.

SQL>

SQL> select tablespace_name, block_Size
  2  from dba_tablespaces
  3  where block_size <> 8192;

TABLESPACE_NAME                BLOCK_SIZE
------------------------------ ----------
TBS_DATA_2K                          2048
TBS_DATA_4K                          4096
TBS_DATA_16K                        16384

SQL>

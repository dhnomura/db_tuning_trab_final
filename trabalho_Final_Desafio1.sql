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

create user Sakspildap identified by oracle
default tablespace USERS;
grant resource to Sakspildap;

grant create session to Sakspildap;
alter user Sakspildap QUOTA 1g ON TBS_DATA_2K;
alter user Sakspildap QUOTA 1g ON TBS_DATA_4K;
alter user Sakspildap QUOTA 1g ON TBS_DATA_16K;


SQL> set echo on
SQL> set feedback on
SQL> spool cria_sakspildap.log
SQL> @cria_sakspildap.sql
SQL> -- Gerado por Oracle SQL Developer Data Modeler 19.4.0.350.1424
SQL> --   em:        2020-09-20 10:50:55 BRT
SQL> --   site: Oracle Database 11g
SQL> --   tipo: Oracle Database 11g
SQL>
SQL> alter session set current_schema=Sakspildap;

Session altered.

SQL>
SQL> CREATE TABLE t_sak_bairro (
  2      cd_bairro  NUMBER(4) NOT NULL,
  3      cd_cidade  NUMBER(3) NOT NULL,
  4      nm_bairro  VARCHAR2(100) NOT NULL
  5  )
  6  tablespace TBS_DATA_4K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_bairro ADD CONSTRAINT pk_sak_bairro PRIMARY KEY ( cd_bairro );

Table altered.

SQL>
SQL> CREATE TABLE t_sak_cidade (
  2      cd_cidade  NUMBER(3) NOT NULL,
  3      cd_estado  NUMBER(2) NOT NULL,
  4      nm_cidade  VARCHAR2(100) NOT NULL
  5  )
  6  tablespace TBS_DATA_4K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_cidade ADD CONSTRAINT pk_sak_cidade PRIMARY KEY ( cd_cidade );

Table altered.

SQL>
SQL> CREATE TABLE t_sak_dependente (
  2      cd_func        NUMBER(5) NOT NULL,
  3      id_dependente  NUMBER(3) NOT NULL,
  4      nm_dependente  VARCHAR2(50) NOT NULL,
  5      dt_nascimento  DATE NOT NULL,
  6      st_dependente  VARCHAR2(10) NOT NULL
  7  )
  8  tablespace TBS_DATA_2K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_dependente
  2      ADD CONSTRAINT ck_sak_dependente_status CHECK ( st_dependente IN (
  3          'ATIVO',
  4          'INATIVO'
  5      ) );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_dependente ADD CONSTRAINT pk_sak_dependente PRIMARY KEY ( id_dependente,
  2                                                                              cd_func );

Table altered.

SQL>
SQL> CREATE TABLE t_sak_depto (
  2      cd_depto  NUMBER(4) NOT NULL,
  3      nm_depto  VARCHAR2(60) NOT NULL,
  4      sg_depto  CHAR(3) NOT NULL
  5  )
  6  tablespace TBS_DATA_2K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_depto ADD CONSTRAINT pk_sak_depto PRIMARY KEY ( cd_depto );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_depto ADD CONSTRAINT un_sak_depto_nome UNIQUE ( nm_depto );

Table altered.

SQL>
SQL> CREATE TABLE t_sak_endereco (
  2      cd_end_correio  NUMBER NOT NULL,
  3      cd_bairro       NUMBER(4) NOT NULL,
  4      nr_cep          NUMBER(8) NOT NULL,
  5      ds_logradouro   VARCHAR2(150) NOT NULL
  6  )
  7  tablespace TBS_DATA_16K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_endereco ADD CONSTRAINT pk_sak_endereco_correio PRIMARY KEY ( cd_end_correio );

Table altered.

SQL>
SQL> CREATE TABLE t_sak_estado (
  2      cd_estado  NUMBER(2) NOT NULL,
  3      nm_estado  VARCHAR2(45) NOT NULL,
  4      sg_estado  CHAR(2) NOT NULL
  5  )
  6  tablespace TBS_DATA_2K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_estado ADD CONSTRAINT pk_sak_estado PRIMARY KEY ( cd_estado );

Table altered.

SQL>
SQL> CREATE TABLE t_sak_execucao_proj (
  2      cd_projeto          NUMBER(10) NOT NULL,
  3      cd_implantacao      NUMBER(3) NOT NULL,
  4      cd_func             NUMBER(5) NOT NULL,
  5      ds_papel_func_proj  VARCHAR2(100),
  6      dt_entrada          DATE NOT NULL,
  7      dt_saida            DATE
  8  )
  9  tablespace TBS_DATA_16K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_execucao_proj ADD CONSTRAINT pk_sak_implantacao PRIMARY KEY ( cd_implantacao,
  2                                                                                  cd_projeto );

Table altered.

SQL>
SQL> CREATE TABLE t_sak_funcionario (
  2      cd_func          NUMBER(5) NOT NULL,
  3      cd_depto         NUMBER(4) NOT NULL,
  4      nm_funcionario   VARCHAR2(60) NOT NULL,
  5      dt_nascimento    DATE NOT NULL,
  6      ds_estado_civil  VARCHAR2(20),
  7      vl_salario       NUMBER(10, 2),
  8      dt_admissao      DATE NOT NULL
  9  )
 10  tablespace TBS_DATA_4K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_funcionario ADD CONSTRAINT pk_sak_funcionario PRIMARY KEY ( cd_func );

Table altered.

SQL>
SQL> CREATE TABLE t_sak_funcionario_endereco (
  2      cd_func           NUMBER(5) NOT NULL,
  3      cd_end_func       NUMBER(8) NOT NULL,
  4      cd_end_correio    NUMBER NOT NULL,
  5      cd_tipo_endereco  NUMBER(4) NOT NULL,
  6      ds_complemento    VARCHAR2(100) NULL,
  7      nr_logradouro     NUMBER(5) NOT NULL
  8  )
  9  tablespace TBS_DATA_4K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_funcionario_endereco ADD CONSTRAINT pk_sak_funcionario_endereco PRIMARY KEY ( cd_end_func,
  2                                                                                                  cd_func );

Table altered.

SQL>
SQL> CREATE TABLE t_sak_projeto (
  2      cd_projeto         NUMBER(10) NOT NULL,
  3      nm_projeto         VARCHAR2(100) NOT NULL,
  4      vl_budget_projeto  NUMBER(10, 2) NOT NULL,
  5      dt_inicio          DATE NOT NULL,
  6      dt_termino         DATE
  7  )
  8  tablespace TBS_DATA_16K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_projeto ADD CONSTRAINT pk_sak_projeto PRIMARY KEY ( cd_projeto );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_projeto ADD CONSTRAINT un_sak_projeto_nome UNIQUE ( nm_projeto );

Table altered.

SQL>
SQL> CREATE TABLE t_sak_telefone (
  2      cd_func      NUMBER(5) NOT NULL,
  3      cd_telefone  NUMBER(3) NOT NULL,
  4      nr_ddd       NUMBER(3) NOT NULL,
  5      nr_telefone  NUMBER(8) NOT NULL
  6  )
  7  tablespace TBS_DATA_2K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_telefone ADD CONSTRAINT pk_sak_telefone PRIMARY KEY ( cd_telefone,
  2                                                                          cd_func );

Table altered.

SQL>
SQL> CREATE TABLE t_sak_tipo_endereco (
  2      cd_tipo_endereco  NUMBER(4) NOT NULL,
  3      nm_tipo_endereco  VARCHAR2(20) NOT NULL
  4  )
  5  tablespace TBS_DATA_2K;

Table created.

SQL>
SQL> ALTER TABLE t_sak_tipo_endereco ADD CONSTRAINT pk_sak_tipo_endereco PRIMARY KEY ( cd_tipo_endereco );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_endereco
  2      ADD CONSTRAINT fk_sak_bairro_endereco FOREIGN KEY ( cd_bairro )
  3          REFERENCES t_sak_bairro ( cd_bairro );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_bairro
  2      ADD CONSTRAINT fk_sak_cidade_bairro FOREIGN KEY ( cd_cidade )
  3          REFERENCES t_sak_cidade ( cd_cidade );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_funcionario
  2      ADD CONSTRAINT fk_sak_depto_func FOREIGN KEY ( cd_depto )
  3          REFERENCES t_sak_depto ( cd_depto );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_funcionario_endereco
  2      ADD CONSTRAINT fk_sak_end_correio_func FOREIGN KEY ( cd_end_correio )
  3          REFERENCES t_sak_endereco ( cd_end_correio );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_cidade
  2      ADD CONSTRAINT fk_sak_estado_cidade FOREIGN KEY ( cd_estado )
  3          REFERENCES t_sak_estado ( cd_estado );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_dependente
  2      ADD CONSTRAINT fk_sak_func_dependente FOREIGN KEY ( cd_func )
  3          REFERENCES t_sak_funcionario ( cd_func );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_funcionario_endereco
  2      ADD CONSTRAINT fk_sak_func_endereco FOREIGN KEY ( cd_func )
  3          REFERENCES t_sak_funcionario ( cd_func );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_execucao_proj
  2      ADD CONSTRAINT fk_sak_func_exec_proj FOREIGN KEY ( cd_func )
  3          REFERENCES t_sak_funcionario ( cd_func );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_telefone
  2      ADD CONSTRAINT fk_sak_func_telefone FOREIGN KEY ( cd_func )
  3          REFERENCES t_sak_funcionario ( cd_func );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_execucao_proj
  2      ADD CONSTRAINT fk_sak_proj_exec_proj FOREIGN KEY ( cd_projeto )
  3          REFERENCES t_sak_projeto ( cd_projeto );

Table altered.

SQL>
SQL> ALTER TABLE t_sak_funcionario_endereco
  2      ADD CONSTRAINT fk_sak_tipo_endereco FOREIGN KEY ( cd_tipo_endereco )
  3          REFERENCES t_sak_tipo_endereco ( cd_tipo_endereco );

Table altered.

SQL>
SQL>
SQL>
SQL> -- Relatório do Resumo do Oracle SQL Developer Data Modeler:
SQL> --
SQL> -- CREATE TABLE                            12
SQL> -- CREATE INDEX                             0
SQL> -- ALTER TABLE                             26
SQL> -- CREATE VIEW                              0
SQL> -- ALTER VIEW                               0
SQL> -- CREATE PACKAGE                           0
SQL> -- CREATE PACKAGE BODY                      0
SQL> -- CREATE PROCEDURE                         0
SQL> -- CREATE FUNCTION                          0
SQL> -- CREATE TRIGGER                           0
SQL> -- ALTER TRIGGER                            0
SQL> -- CREATE COLLECTION TYPE                   0
SQL> -- CREATE STRUCTURED TYPE                   0
SQL> -- CREATE STRUCTURED TYPE BODY              0
SQL> -- CREATE CLUSTER                           0
SQL> -- CREATE CONTEXT                           0
SQL> -- CREATE DATABASE                          0
SQL> -- CREATE DIMENSION                         0
SQL> -- CREATE DIRECTORY                         0
SQL> -- CREATE DISK GROUP                        0
SQL> -- CREATE ROLE                              0
SQL> -- CREATE ROLLBACK SEGMENT                  0
SQL> -- CREATE SEQUENCE                          0
SQL> -- CREATE MATERIALIZED VIEW                 0
SQL> -- CREATE MATERIALIZED VIEW LOG             0
SQL> -- CREATE SYNONYM                           0
SQL> -- CREATE TABLESPACE                        0
SQL> -- CREATE USER                              0
SQL> --
SQL> -- DROP TABLESPACE                          0
SQL> -- DROP DATABASE                            0
SQL> --
SQL> -- REDACTION POLICY                         0
SQL> --
SQL> -- ORDS DROP SCHEMA                         0
SQL> -- ORDS ENABLE SCHEMA                       0
SQL> -- ORDS ENABLE OBJECT                       0
SQL> --
SQL> -- ERRORS                                   0
SQL> -- WARNINGS                                 0
SQL>
SQL> spool off


SQL> select
        a.owner, a.table_name, a.tablespace_name, b.BLOCK_SIZE
from
        dba_tables a, dba_tablespaces b
where
        a.tablespace_name=b.tablespace_name
        and a.owner ='SAKSPILDAP'
order by
        b.BLOCK_SIZE,a.tablespace_name, b.block_size, a.table_name;  2    3    4    5    6    7    8    9

OWNER        TABLE_NAME                     TABLESPACE_NAME      BLOCK_SIZE
------------ ------------------------------ -------------------- ----------
SAKSPILDAP   T_SAK_DEPENDENTE               TBS_DATA_2K                2048
SAKSPILDAP   T_SAK_DEPTO                    TBS_DATA_2K                2048
SAKSPILDAP   T_SAK_ESTADO                   TBS_DATA_2K                2048
SAKSPILDAP   T_SAK_TELEFONE                 TBS_DATA_2K                2048
SAKSPILDAP   T_SAK_TIPO_ENDERECO            TBS_DATA_2K                2048
SAKSPILDAP   T_SAK_BAIRRO                   TBS_DATA_4K                4096
SAKSPILDAP   T_SAK_CIDADE                   TBS_DATA_4K                4096
SAKSPILDAP   T_SAK_FUNCIONARIO              TBS_DATA_4K                4096
SAKSPILDAP   T_SAK_FUNCIONARIO_ENDERECO     TBS_DATA_4K                4096
SAKSPILDAP   T_SAK_ENDERECO                 TBS_DATA_16K              16384
SAKSPILDAP   T_SAK_EXECUCAO_PROJ            TBS_DATA_16K              16384
SAKSPILDAP   T_SAK_PROJETO                  TBS_DATA_16K              16384

12 rows selected.

SQL>

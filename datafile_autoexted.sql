col file_name format a120
select 
	file_name, tablespace_name, AUTOEXTENSIBLE
from 
	dba_data_files
where
	AUTOEXTENSIBLE='NO'
/
 
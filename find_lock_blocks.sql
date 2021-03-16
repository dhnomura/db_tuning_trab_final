select	sn.USERNAME,
	m.SID,
	sn.SERIAL#,
	m.TYPE,
	decode(LMODE,
		0, 'None',
		1, 'Null',
		2, 'Row-S (SS)',
		3, 'Row-X (SX)',
		4, 'Share',
		5, 'S/Row-X (SSX)',
		6, 'Exclusive') lock_type,
	decode(REQUEST,
		0, 'None', 
		1, 'Null',
		2, 'Row-S (SS)',
		3, 'Row-X (SX)', 
		4, 'Share', 
		5, 'S/Row-X (SSX)',
		6, 'Exclusive') lock_requested,
	m.ID1,
	m.ID2,
	t.SQL_TEXT
from 	v$session sn, 
	v$lock m , 
	v$sqltext t
where 	t.ADDRESS = sn.SQL_ADDRESS 
and 	t.HASH_VALUE = sn.SQL_HASH_VALUE 
and 	((sn.SID = m.SID and m.REQUEST != 0) 
or 	(sn.SID = m.SID and m.REQUEST = 0 and LMODE != 4 and (ID1, ID2) in
        (select s.ID1, s.ID2 
         from 	v$lock S 
         where 	REQUEST != 0 
         and 	s.ID1 = m.ID1 
         and 	s.ID2 = m.ID2)))
order by sn.USERNAME, sn.SID, t.PIECE


USERNAME
--------------------------------------------------------------------------------
       SID    SERIAL# TY LOCK_TYPE     LOCK_REQUESTE        ID1        ID2
---------- ---------- -- ------------- ------------- ---------- ----------
SQL_TEXT
----------------------------------------------------------------
SYS
       146      37755 TX None          Exclusive         458755        968
update employees set SALARY=salary*2



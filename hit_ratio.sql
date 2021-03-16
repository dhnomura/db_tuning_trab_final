-- POPULA TABELAS

DECLARE
   x NUMBER := 1;
BEGIN
   FOR i IN 1..1000 LOOP
      IF MOD(i,2) = 0 THEN     -- i is even
         insert into t_sak_depto values ( i, i,'A' );
      ELSE
         insert into t_sak_depto values ( i, i,'B' );
      END IF;
      x := x + 1;
   END LOOP;
   COMMIT;
END;
/

DECLARE
   x NUMBER := 1;
BEGIN
   FOR i IN 1..1000 LOOP
      IF MOD(i,2) = 0 THEN     -- i is even
		 insert into t_sak_funcionario values ( i, i, 'teste',(sysdate-7000)-i,'SOLTEIRO',i*20,sysdate-i );
      ELSE
		 insert into t_sak_funcionario values ( i, i, 'teste',(sysdate-7000)-i,'SOLTEIRO',i*20,sysdate-i );
      END IF;
      x := x + 1;
   END LOOP;
   COMMIT;
END;
/


DECLARE
   x NUMBER := 1;
BEGIN
   FOR i IN 1..10 LOOP
      IF MOD(i,2) = 0 THEN     -- i is even
		 insert into t_sak_estado values ( i, 'AAAAA','SP' );
      ELSE
		 insert into t_sak_estado values ( i, 'BBBBB','RJ' );
      END IF;
      x := x + 1;
   END LOOP;
   COMMIT;
END;
/

DECLARE
   x NUMBER := 1;
BEGIN
   FOR i IN 1..100 LOOP
      IF MOD(i,2) = 0 THEN     -- i is even
		 insert into t_sak_cidade values ( i, 1,'aaaaaa' );
      ELSE
		 insert into t_sak_cidade values ( i, 2,'bbbb' );
      END IF;
      x := x + 1;
   END LOOP;
   COMMIT;
END;
/


DECLARE
   x NUMBER := 1;
BEGIN
   FOR i IN 1..1000 LOOP
      IF MOD(i,2) = 0 THEN     -- i is even
		 insert into t_sak_bairro values ( i, 1,'aaaaaa' );
      ELSE
		 insert into t_sak_bairro values ( i, 2,'bbbb' );
      END IF;
      x := x + 1;
   END LOOP;
   COMMIT;
END;
/
 
DECLARE
   x NUMBER := 1;
BEGIN
   FOR i IN 1..1000 LOOP
      IF MOD(i,2) = 0 THEN     -- i is even
		 insert into t_sak_endereco values ( i, 1, i,'aaaaaa' );
      ELSE
		 insert into t_sak_endereco values ( i, 2, i,'bbbb' );
      END IF;
      x := x + 1;
   END LOOP;
   COMMIT;
END;
/

-- REALIZA SELET
-- Estes select tem como objetivo "esquentar" o buffer e serão executados inumeras vezes

DECLARE
   l_t_sak_endereco  t_sak_endereco%ROWTYPE;
BEGIN
   FOR i IN 1..1000 LOOP
	select *
		into l_t_sak_endereco
		from t_sak_endereco
		where CD_END_CORREIO=i;
	dbms_output.put_line (l_t_sak_endereco.CD_END_CORREIO||';'||l_t_sak_endereco.DS_LOGRADOURO);
	end loop;
END;
/


DECLARE
   l_t_sak_depto  t_sak_depto%ROWTYPE;
BEGIN
   FOR i IN 1..1000 LOOP
	select *
		into l_t_sak_depto
		from t_sak_depto
		where CD_DEPTO=i;
	dbms_output.put_line (l_t_sak_depto.CD_DEPTO||';'||l_t_sak_depto.NM_DEPTO);
	end loop;
END;
/


DECLARE
   l_t_sak_funcionario  t_sak_funcionario%ROWTYPE;
BEGIN
   FOR i IN 1..1000 LOOP
	select *
		into l_t_sak_funcionario
		from t_sak_funcionario
		where CD_FUNC=i;
	dbms_output.put_line (l_t_sak_funcionario.CD_FUNC||';'||l_t_sak_funcionario.VL_SALARIO);
	end loop;
END;
/


DECLARE
   l_t_sak_estado  t_sak_estado%ROWTYPE;
BEGIN
   FOR i IN 1..2 LOOP
	select *
		into l_t_sak_estado
		from t_sak_estado
		where CD_ESTADO=i;
	dbms_output.put_line (l_t_sak_estado.CD_ESTADO||';'||l_t_sak_estado.SG_ESTADO);
	end loop;
END;
/




SELECT 
	name,
	BLOCK_SIZE/1024 "Block Size KB",
	round(((1-(physical_reads/(db_block_gets + consistent_gets)))*100),2) "Hit Ratio %" 
FROM 
	v$buffer_pool_statistics 
WHERE 
	db_block_gets + consistent_gets > 0
order by 
	2;
	
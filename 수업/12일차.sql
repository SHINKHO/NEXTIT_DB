/*  
    PL/SQL 
    집합적 언어(SQL)와 절차적언어 (PL)의 특징을 모두 가지고
    있음 . DB내부에서 실행되기 때문에 
    수행 속도와 성능이 큰 장점이 있음. 
*/

SET SERVEROUTPUT ON;
--PLSQL 실행 결과 스크립트 출력하려면 
--최초 접속시 한번실행해야함. 

-- 익명블록 (이름이 없는 PLSQL) 
DECLARE
  vn_num NUMBER;    -- 선언부 
BEGIN
  vn_num := 10;     -- 실행부 
  DBMS_OUTPUT.PUT_LINE(vn_num);
END;



DECLARE
  vn_num CONSTANT NUMBER := 3.14;    --상수는 초기값을 설정해야함. 
BEGIN
--  vn_num := 10; -- 변경안됨
  DBMS_OUTPUT.PUT_LINE(vn_num);
END;

DECLARE
 vs_emp_name VARCHAR2(80);
 vs_dep_name departments.department_name%TYPE;  --테이블컬럼타입 
BEGIN
 SELECT a.emp_name, b.department_name
 INTO   vs_emp_name, vs_dep_name  -- 변수에 할당(select 결과) 
 FROM employees a
    , departments b
 WHERE a.department_id = b.department_id
 AND  a.employee_id = 100;
 DBMS_OUTPUT.PUT_LINE(vs_emp_name || ':' || vs_dep_name);
END;


BEGIN
   DBMS_OUTPUT.PUT_LINE('3 * 1 = '|| 3 * 1 );
END;

/* IF ELSIF ELSE*/
DECLARE 
  vn_num NUMBER := :num;
BEGIN
  IF vn_num  < 10 THEN 
     DBMS_OUTPUT.PUT_LINE(vn_num || '은' || '10보다 작음');
  ELSIF vn_num > 10 AND vn_num < 100 THEN
     NULL;   -- 아무것도 안할때 
  ELSE 
     DBMS_OUTPUT.PUT_LINE('100보다 큼'); 
  END IF;
END;

-- 단순 LOOP문 (EXIT 필요:탈출조건) 
DECLARE 
  vn_i NUMBER := 2;
  vn_j NUMBER ;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE(vn_i || '단');
    vn_j := 1;
    LOOP 
     DBMS_OUTPUT.PUT_LINE(vn_i ||
                         '*' || vn_j || '='|| vn_i * vn_j);
     vn_j := vn_j +1;
     EXIT WHEN vn_j >9;
    END LOOP;
    
    vn_i := vn_i + 1;
    EXIT WHEN vn_i > 9;
  END LOOP;
END;
--2단 ~ 9단 까지 출력하시오 
DECLARE
  vn_i NUMBER := 2;
  vn_j NUMBER ;
BEGIN
  LOOP 
    DBMS_OUTPUT.PUT_LINE(vn_i || '단');
    vn_j :=1;
    LOOP
         DBMS_OUTPUT.PUT_LINE(vn_i || '*'||vn_j||'='
               || vn_i * vn_j );
         vn_j:= vn_j + 1;
         EXIT WHEN vn_j > 9;
    END LOOP;
    vn_i := vn_i + 1;
    EXIT WHEN vn_i >9 ;
  END LOOP;
END;

-- WHILE 문 
DECLARE 
  vn_base NUMBER := 3;
  vn_i    NUMBER := 1;
BEGIN
  WHILE vn_i <= 9 --while은 조건이 TRUE일경우 반복
  LOOP
    CONTINUE WHEN vn_i = 5; -- 건너뜀 
    DBMS_OUTPUT.PUT_LINE(vn_base ||'*'|| vn_i
                 || '=' || vn_base *vn_i );
    vn_i := vn_i + 1;
--    EXIT WHEN vn_i = 5; -- 같으면 
  END LOOP;
END;


/* FOR */
BEGIN
  FOR i IN 2..9
  LOOP 
     DBMS_OUTPUT.PUT_LINE(i||'단');
     FOR j IN 1..9
     LOOP
         DBMS_OUTPUT.PUT_LINE(i || '*'
                          || j || '='|| i * j);
     END LOOP ;
  END LOOP;
END;
/*
   이름이 있는 블록 
   이름 
   IS
     선언부 
   BEGIN
     실행부 
   END 
*/
-- 이름을 입력받아서 학번을 리턴하는 함수 
CREATE OR REPLACE FUNCTION fn_get_no(nm VARCHAR2)
 RETURN NUMBER
IS
 vn_num 학생.학번%TYPE;
BEGIN
 SELECT 학번  
 INTO  vn_num 
 FROM 학생 
 WHERE 이름 = nm;
 RETURN vn_num;
END;

SELECT fn_get_no('최숙경')
FROM dual;

/*
  countries 테이블을 사용하여 
  국가 '번호'를 입력받아 
  '국가명'을 리턴하는 함수를 작성하시오 
  input type:number
  return type:varchar2
  function name : fn_get_country
*/
SELECT fn_get_country(52790)
FROM dual;




CREATE OR REPLACE FUNCTION fn_get_country(p_no NUMBER)
 RETURN VARCHAR2
IS
 vs_nm countries.country_name%TYPE;
BEGIN
 SELECT country_name
  INTO vs_nm
 FROM countries
 WHERE country_id = p_no;
 RETURN vs_nm;
END;







-- 구구단 출력 

DECLARE 
 vn_num NUMBER := :tree_size;
 vn_space VARCHAR2(4000);
 vn_star VARCHAR2(4000):='★' ;
 
BEGIN
 FOR i IN 0..vn_num
 LOOP
  vn_space :='';
  FOR j IN 1..vn_num-i
  LOOP
    vn_space := vn_space || '=';    
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(vn_space || vn_star || vn_space);
  vn_star  :='';
  FOR j IN 1..i*2
  LOOP
    vn_star := vn_star || '*';    
  END LOOP;
  
 END LOOP;
END;




/*
  1 ~ 500 까지의 숫자를 입력받아 
  증가되는 숫자를 출력하시오 
  (단:3,6,9가 포함된다면 짝으로 출력)
   ex : 3  ->  짝 
        36 ->  짝짝
        333 -> 짝짝짝  
        hit: length, replace, to_char....
             포함된 문자열의 길이를 사용하여 ...
*/






DECLARE
   vn_base_num VARCHAR2(10);
   vn_base_cnt_3 NUMBER := 0;
   vn_base_cnt_6 NUMBER := 0;
   vn_base_cnt_9 NUMBER := 0;
   vn_all_cnt NUMBER := 0;
   vn_star VARCHAR2(4000):='짝';
BEGIN
   FOR i IN 1..:num
   LOOP
      vn_base_num := TO_CHAR(i) ;
      vn_base_cnt_3 :=LENGTH(vn_base_num) - NVL(LENGTH(REPLACE(vn_base_num,'3','')),0);
      vn_base_cnt_6 :=LENGTH(vn_base_num) - NVL(LENGTH(REPLACE(vn_base_num,'6','')),0);
      vn_base_cnt_9 :=LENGTH(vn_base_num) - NVL(LENGTH(REPLACE(vn_base_num,'9','')),0);
      vn_all_cnt := vn_base_cnt_3 + vn_base_cnt_6 + vn_base_cnt_9;
      vn_star := '';  
      FOR x IN 1..vn_all_cnt
      LOOP
        vn_star := vn_star || '짝';
      END LOOP;
      IF vn_star IS NULL THEN
        DBMS_OUTPUT.PUT_LINE (i || ':' || i);
      ELSE
         DBMS_OUTPUT.PUT_LINE (i || ':' || vn_star);
      END IF;
  END LOOP;
END;


--조회 SQL를 작성하세요 

/*
  1. 고객 이름으로 고객 
     기본정보 조회하는 SELECT문 
     이름은 LIKE검색 
     
  2. 고객의 ID로 
     고객의 예약 및 구매 이력을 
     조회하는 SELECT문 
*/


SELECT ROWNUM AS RNUM
     , A.CUSTOMER_ID 
     , A.CUSTOMER_NAME
     , A.EMAIL
     , (SELECT ADDRESS_DETAIL 
        FROM ADDRESS 
        WHERE ZIP_CODE = A.ZIP_CODE) AS zipNm
FROM CUSTOMER A
WHERE A.CUSTOMER_NAME LIKE '%'||:학생||'%';


SELECT A.CUSTOMER_ID 
     , A.CUSTOMER_NAME
     , (SELECT ADDRESS_DETAIL 
        FROM ADDRESS WHERE ZIP_CODE = A.ZIP_CODE) AS zipNm
     , B.RESERV_NO 
     , B.RESERV_DATE
     , B.CANCEL
     , (SELECT PRODUCT_NAME 
        FROM ITEM WHERE ITEM_ID = C.ITEM_ID) AS itemNm
     , C.QUANTITY
     , C.SALES
FROM CUSTOMER A
   , RESERVATION B
   , ORDER_INFO C 
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID (+)
  AND B.RESERV_NO = C.RESERV_NO (+)
  AND A.CUSTOMER_ID ='W1341063';  --W1327595 W1341752 W1431063
  
  




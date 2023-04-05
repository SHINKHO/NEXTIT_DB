
SELECT department_id 
     , parent_id
     , LPAD(' ', 3 * (LEVEL -1)) || department_name as 부서명
     , LEVEL  -- 가상-열 트리 내에서 어떤 단계(level)에 있는지 나타내는 정수값
     , CONNECT_BY_ISCYCLE as isloop
FROM departments
START WITH department_id = 30
CONNECT BY NOCYCLE PRIOR department_id = parent_id;


UPDATE departments
SET parent_id = 10
WHERE department_id = 30;

COMMIT;




-- 부서테이블에  department_id : 280
--             부서명 :  DB팀 
--             상위부서 : IT 헬프데스크 
--             데이터를 삽입하고 출력하시오 

INSERT INTO departments (department_id, parent_id, department_name)
VALUES(280, 230, 'DB팀');
commit;


SELECT employee_id 
     , emp_name
     , manager_id 
     , job_id
FROM employees;



-- employee_id와 manager_id를 활용하여 
-- 직원의 계층관계를 출력하시오 
-- 최상위 직원은 Steven King 


SELECT a.employee_id 
     , a.manager_id
     , LPAD(' ', 3 * (LEVEL -1)) || a.emp_name as 부서명
     , LEVEL  as lev -- 가상-열 트리 내에서 어떤 단계(level)에 있는지 나타내는 정수값
     
     , CONNECT_BY_ISLEAF as leaf  -- 마지막노드면 1, 자식이 있으면 0 
     , SYS_CONNECT_BY_PATH(emp_name, '<') as depth -- 루트 노드에서 현재 노드까지 
FROM employees a
START WITH a.manager_id is NULL
CONNECT BY PRIOR a.employee_id = a.manager_id
ORDER SIBLINGS BY a.emp_name ; -- 계층형 트리가 깨지지 않고 정렬 


/*
 테이블을 생성하고 
 데이터를 입력하여 
 아래와 같이 출력하도록 계층형 쿼리를 만들어 출력하세요.
 이름       직위     레벨 
 이사장 사장               1
 김부장    부장            2
 서차장       차장         3
 장과장          과장      4
 이대리            대리    5
 박과장          과장      4
 김대리            대리    5
 강사원               사원 6
*/

CREATE TABLE 팀 (
  아이디 number
 ,이름   varchar2(20)
 ,직위   varchar2(20)
 ,상위아이디 number
);

INSERT INTO 팀 VALUES(1, '이사장', '사장', 0);
INSERT INTO 팀 VALUES(2, '김부장', '부장', 1);
INSERT INTO 팀 VALUES(3, '서차장', '차장', 2);
INSERT INTO 팀 VALUES(4, '장과장', '과장', 3);
INSERT INTO 팀 VALUES(5, '박과장', '과장', 3);
INSERT INTO 팀 VALUES(6, '이대리', '대리', 4);
INSERT INTO 팀 VALUES(7, '김대리', '대리', 5);
INSERT INTO 팀 VALUES(8, '최사원', '사원', 6);
INSERT INTO 팀 VALUES(9, '강사원', '사원', 6);
INSERT INTO 팀 VALUES(10,'하사원', '사원', 7);

commit;
SELECT 이름 
      ,LPAD(' ', 3 * (level-1)) || 직위 as 직위
      ,level
FROM 팀
START WITH 상위아이디 = 0
CONNECT BY PRIOR 아이디 = 상위아이디;




SELECT SALES_MONTH
FROM sales
GROUP BY SALES_MONTH;
--sales 1998년 1 ~12월까지 매출 합계를 출력하시오 


SELECT  '2013'||LPAD(LEVEL ,2,'0') as 월 
FROM dual 
CONNECT BY LEVEL <=12;

SELECT period
    , SUM(loan_jan_amt) as amt
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period;

SELECT a.월
     , NVL(b.amt,0) as amt 
FROM (  SELECT  '2013'||LPAD(LEVEL ,2,'0') as 월 
        FROM dual 
        CONNECT BY LEVEL <=12) a    -- 201301 ~ 201312 생성한 년월 
    ,(  SELECT period
            , SUM(loan_jan_amt) as amt
        FROM kor_loan_status
        WHERE period LIKE '2013%'
        GROUP BY period) b
WHERE a.월 = b.period(+)    -- 201310,201311 년월 밖에 없음 
ORDER BY 1;                -- 년월에 null 값이 있는 쪽에 outerjoin

-- 이번달 1일부터 ~ 마지막날 까지 출력하시오 
--20230301 ~ 20230331

SELECT TO_CHAR(SYSDATE,'YYYYMM') 
FROM dual;




SELECT  :months||LPAD(LEVEL,2,'0') as 일자 
FROM dual
CONNECT BY LEVEL <= 
     TO_CHAR(LAST_DAY(TO_DATE(:months, 'YYYYMM')),'DD');
     --1.입력값이 문자열 YYYYMM -> DATE타입으로 변환 
     --2.DATE타입은 LAST_DAY로 월마지막 날을 구할수 있음 
     --3.마지막 날짜의 DATE타입에서 TO_CHAR로 일자만 구하기 









SELECT 대
     , COUNT(*) as 인원수 
FROM (SELECT  TRUNC((TO_CHAR(SYSDATE,'YYYY') - cust_year_of_birth)/10) as 대 
      FROM customers
      )
GROUP BY 대 
;

SELECT LEVEL as 대
FROM dual 
CONNECT BY LEVEL <=12;

/*
customers 테이블의cust_year_of_birth을활용하여(나이계산 올해 - 탄생년도) 
-- 1.나이계산 
-- 2.나이로 10대20대~ 를 구별할 수 있도록 데이터 만들기 
-- 3. 2로 인원수 집계 
-- 4.level 이용하여 10대부터 출력
*/


SELECT a.대 * 10 ||'대' as 년대 
    , NVL(b.인원수,0) as 인원수
FROM (
        SELECT LEVEL as 대
        FROM dual 
        CONNECT BY LEVEL <=(SELECT MAX(대)
                            FROM (
                            SELECT  TRUNC((TO_CHAR(SYSDATE,'YYYY') - cust_year_of_birth)/10) as 대 
                            FROM customers)
                            )
      ) a
    ,(SELECT 대
           , COUNT(*) as 인원수 
       FROM (
              SELECT TRUNC((TO_CHAR(SYSDATE,'YYYY') - cust_year_of_birth)/10) as 대 
              FROM customers
             )
      GROUP BY ROLLUP(대)) b
WHERE a.대 = b.대(+)
ORDER BY a.대;


SELECT MAX(대)
FROM (
SELECT  TRUNC((TO_CHAR(SYSDATE,'YYYY') - cust_year_of_birth)/10) as 대 
FROM customers);



SELECt COUNT(*)
FROM customers;
/*   VIEW 객체 
     단순뷰 
        - 하나의 테이블로 생성 
        - 그룹 함수의 사용 불가 
        - distinct 불가 
        - insert/update/delete 가능 
     복합뷰 
        - 여러 개의 테이블로 생성 
        - 그룹함수 사용가능 
        - insert/update/delete 불가능 
*/
CREATE OR REPLACE VIEW emp_dep AS
SELECT a.employee_id 
     , a.emp_name
     , b.department_name 
FROM employees a
    ,departments b
WHERE a.department_id = b.department_id;
-- 뷰 생성 권한 부여 (DBA권한 있는쪽에서 실행) 
--GRANT CREATE VIEW TO java;
-- 계정 생성 
CREATE USER study IDENTIFIED BY study;
GRANT RESOURCE, CONNECT TO study;

SELECT *
FROM emp_dep;
-- JAVA계정에서 실행 
GRANT SELECT ON emp_dep TO study;

-- study에서 테스트 
SELECT *
FROM java.emp_dep;

-- VIEW 삭제 
DROP VIEW emp_dep;

/* 시노님 synonym '동의어'란 뜻으로 
   객체 각자의 고유한 이름에 대한 동의어를 만드는 것 
   PUBLIC 모든 사용자 
   PRIVATE 특정 사용자 
*/
--DBA권한 있는쪽에서 시노님 생성 권한 부여 
GRANT CREATE SYNONYM TO java;

CREATE OR REPLACE SYNONYM emp_v1 
FOR employees;

GRANT SELECT ON emp_v1 TO study;

-- public 시노님은 DBA권한이 있는 쪽에서 생성, 삭제 가능 
CREATE OR REPLACE PUBLIC SYNONYM emp_v2 
FOR java.employees;
-- PUBLIC 시노님은 삭제도 DBA권한 있는쪽에서 
DROP PUBLIC SYNONYM emp_v2;
-- private 은 만든쪽에서 삭제 가능 
DROP SYNONYM emp_v1;


/* 시퀀스 자동 순번을 반환하는 객체*/
CREATE SEQUENCE my_seq1 
INCREMENT BY 1 -- 증강숫자 
START WITH   1 -- 시작숫자 
MINVALUE     1 -- 최소값 
MAXVALUE     100 --최대값 
NOCYCLE      -- 디폴트 최대 or 최소 도달시 생성 중지 
NOCACHE      -- 디폴트 값을 할당해 놓지 않음. 
;

CREATE SEQUENCE my_seq2
INCREMENT BY 1 -- 증강숫자 
START WITH   1 -- 시작숫자 
MINVALUE     1 -- 최소값 
MAXVALUE     100 --최대값 
;
-- 최소값 1000, 최대값 99999999, 1000부터 시작해서 2씩 증가하는 
-- 시퀀스를 만드시오 
CREATE SEQUENCE my_seq3
INCREMENT BY 2 -- 증강숫자 
START WITH   1000 -- 시작숫자 
MINVALUE     1000 -- 최소값 
MAXVALUE     99999999; --최대값 
-- 시퀀스 삭제 
DROP SEQUENCE my_seq3;

SELECT my_seq3.NEXTVAL
FROM dual;
SELECT my_seq1.CURRVAL  -- 현재 시퀀스값 
FROM dual;

/* ANSI조인  FROM절에 조인조건이 들어감*/
-- 일반 조인 
SELECT a.emp_name
     , b.department_name
FROm employees a 
   , departments b
WHERE a.department_id = b.department_id;
-- ANSI INNER JOIN
SELECT a.emp_name
     , b.department_name
     , department_id -- USING을 쓰면 테이블 alias 안됨 
FROM employees a 
INNER JOIN departments b 
--ON(a.department_id = b.department_id); 
USING(department_id); -- 컬럼명 같을경우 USING 사용가능

-- 학생, 수강내역, 과목 테이블 ANSI INNER JOIN 사용하여 
-- '최숙경'의 학번, 수강내역번호, 과목명을 출력하시오 


SELECT 이름 
    , 수강내역번호 
    , 과목이름
FROM 학생 
INNER JOIN 수강내역 
USING(학번)     -- ON(학생.학번 = 수강내역.학번)
INNER JOIN 과목 
USING(과목번호)
WHERE 이름 = '최숙경';
-- OUTER JOIN 
-- 일반 
SELECT *
FROM 학생, 수강내역, 과목 
WHERE 학생.학번= 수강내역.학번(+)
AND   수강내역.과목번호 = 과목.과목번호(+);
-- ANSI LEFT 
SELECT *
FROM 학생
LEFT OUTER JOIN 수강내역 
ON(학생.학번= 수강내역.학번)   -- USING(학번)
LEFT OUTER JOIN 과목 
ON(수강내역.과목번호 = 과목.과목번호); --USING(과목번호)

-- RIGHT 
SELECT *
FROM 수강내역 
RIGHT OUTER JOIN 학생
ON(학생.학번= 수강내역.학번)   -- USING(학번)
;

SELECT *
FROM 학생, 수강내역
WHERE 학생.학번(+) = 수강내역.학번(+);

CREATE TABLE ex_a (
   emp_id number
);
CREATE TABLE ex_b (
   emp_id number
);
--a
INSERT INTO ex_a VALUES(10);
INSERT INTO ex_a VALUES(20);
INSERT INTO ex_a VALUES(40);
--b
INSERT INTO ex_b VALUES(10);
INSERT INTO ex_b VALUES(20);
INSERT INTO ex_b VALUES(30);
COMMIT;
SELECT *
FROM ex_a;
SELECT *
FROM ex_b;

SELECT *
FROM ex_a , ex_b
WHERE ex_a.emp_id(+) = ex_b.emp_id(+);
-- ANSI FULL OUTER JOIN 양쪽 널포함 
SELECT *
FROM ex_a 
FULL OUTER JOIN ex_b
ON(ex_a.emp_id = ex_b.emp_id);



-- '년도별' Italy의 최대 매출액과 '사원'을 출력하시오 
-- 매출은 amount_sold 사용 
-- 1.년도별 직원별 매출합                   <-- ex a
-- 2.1의 년도별 직원별 매출합의 년도별 max값  <-- ex b
-- 3. a와 b의 년도와, 매출이 같은 정보 출력 


SELECT emp.years, 
       emp.employee_id,
--       emp2.emp_name,
       (select emp_name from employees where employee_id= emp.employee_id)as emp_name ,
       emp.amount_sold
  FROM ( SELECT SUBSTR(a.sales_month, 1, 4) as years,
                a.employee_id, 
                SUM(a.amount_sold) AS amount_sold
           FROM sales a,
                customers b,
                countries c
          WHERE a.cust_id = b.CUST_ID
            AND b.country_id = c.COUNTRY_ID
            AND c.country_name = 'Italy'     
          GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id  
        ) emp,
       ( SELECT  years, 
                 MAX(amount_sold) AS max_sold
          FROM ( SELECT SUBSTR(a.sales_month, 1, 4) as years,
                        a.employee_id, 
                        SUM(a.amount_sold) AS amount_sold
                   FROM sales a,
                        customers b,
                        countries c
                  WHERE a.cust_id = b.CUST_ID
                    AND b.country_id = c.COUNTRY_ID
                    AND c.country_name = 'Italy'     
                  GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id    
               ) K
          GROUP BY years
       ) sale
--       employees emp2
  WHERE emp.years = sale.years
    AND emp.amount_sold = sale.max_sold 
--    AND emp.employee_id = emp2.employee_id
ORDER BY years;








SELECT *
FROM (
        SELECT SUBSTR(a.sales_month, 1, 4) as years,
            a.employee_id, 
            SUM(a.amount_sold) AS amount_sold
        FROM sales a,
            customers b,
            countries c
        WHERE a.cust_id = b.CUST_ID
        AND b.country_id = c.COUNTRY_ID
        AND c.country_name = 'Italy'     
        GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id  
   )
WHERE (years , amount_sold) IN(
                    SELECT  years, 
                            MAX(amount_sold) AS max_sold
                    FROM ( SELECT SUBSTR(a.sales_month, 1, 4) as years,
                                a.employee_id, 
                                SUM(a.amount_sold) AS amount_sold
                           FROM sales a,
                                customers b,
                                countries c
                          WHERE a.cust_id = b.CUST_ID
                            AND b.country_id = c.COUNTRY_ID
                            AND c.country_name = 'Italy'     
                          GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id    
                       ) K
                    GROUP BY years);
    
    
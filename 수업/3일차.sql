/*
 문자 연산자 ||  <-- 문자열 붙일때 사용 
*/
SELECT emp_name || ':' || employee_id ||'^^'
FROM employees;
/* 
  수식 연산자 + - * / 숫자 데이터 타입에 사용가능 
*/
SELECT employee_id
      ,emp_name
      ,salary / 30           AS 일당 
      ,salary                AS 월급 
      ,salary - salary * 0.1 AS 실수령액 
      ,salary * 12           AS 연봉
FROM employees;
/* 논리 연산자 > < >= <= != <> ^= */
SELECT * FROM employees WHERE salary = 2600 ; -- 같다 
SELECT * FROM employees WHERE salary <>2600 ; -- 같지 않다  
SELECT * FROM employees WHERE salary != 2600; -- 같지 않다   
SELECT * FROM employees WHERE salary ^= 2600; -- 같지 않다   
SELECT * FROM employees WHERE salary < 2600;  -- 미만 
SELECT * FROM employees WHERE salary > 2600;  -- 초과 
SELECT * FROM employees WHERE salary <= 2600; -- 이하 
SELECT * FROM employees WHERE salary >= 2600; -- 이상 



-- 직원중에 30, 50번 부서가 아닌 직원만 출력하시오 


SELECT emp_name
     , department_id 
FROM employees 
WHERE department_id ^= 30
AND   department_id !=50
ORDER BY department_id asc;

/* IN 조건식 
*/
SELECT *
FROM employees
WHERE department_id IN (30, 50, 60); -- 포함하는 (and)

SELECT *
FROM employees
WHERE department_id NOT IN (30, 50, 60); -- 반대 
/*  표현식 특정조건일때 표현을 바꾸는 
*/
-- 5000 이하 'c등급' , 5000초과 15000 이하 'B등급' 
-- 그밖에는 'A등급'
SELECT employee_id
     , emp_name
     , salary
     , CASE WHEN salary <= 5000 THEN 'c등급'
            WHEN salary > 5000 AND salary <= 15000 THEN 'b등급'
          ELSE  'A등급'
       END AS grade
FROM employees;



SELECT a.*
     , a.cust_name
FROM customers a;


-- CUSTOMERS 테이블에서 
-- 성별 정보 F -> '여자' M -> '남자' 로 
-- 표현식을 사용하여 출력하시오 
SELECT cust_name
     , cust_gender
     , CASE WHEN cust_gender ='F' THEN '여자'
            WHEN cust_gender ='M' THEN '남자'
       END as gender
FROM customers;

/* LIKE 조건식 (많이사용)  */
SELECT emp_name
FROM employees
--WHERE emp_name LIKE 'A%' -- A로 시작하는 ~ 
--WHERE emp_name LIKE '%a'   -- a로 끝나는  ~ 
--WHERE emp_name LIKE '%a%'   -- a가 포함된  ~ 
WHERE emp_name LIKE '%'||:a||'%' -- 바인드 테스트  
;
CREATE TABLE ex3_1(
   nm VARCHAR2(100)
);
INSERT INTO ex3_1 VALUES ('홍길');
INSERT INTO ex3_1 VALUES ('홍길동');
INSERT INTO ex3_1 VALUES ('홍길동님');
SELECT *
FROM ex3_1
WHERE nm LIKE '_길_'; -- like 길이 정확히 일치 _ <-사용

--TB_INFO 김씨만 조회 
SELECT *
FROM tb_info 
WHERE nm LIKE '김%';

---------------------------------------------------------
/*  문자함수 : 문자 함수는 연산 대상이 문자이며 반환 값은 
              함수에 따라 문자 or 숫자를 반환 
*/
-- UPPER(char) 대문자로 
-- LOWER(char) 소문자로 
SELECT emp_name
     , UPPER(emp_name) as 대문자 
     , LOWER(emp_name) as 소문자 
FROM employees;
SELECT emp_name
FROM employees
WHERE emp_name = 'DOUglas Grant';
-- 검색조건으로 대문자 or 소문자가 들어와도 검색이 되게 하려면? 
SELECT emp_name
FROM employees
WHERE LOWER(emp_name)=LOWER('DOUglas Grant'); --소문자로 바꿔서 검색 



-- Ing 가 포함된 이름을 조회하시오  (대소문자 구별없이)ing ING 
SELECT emp_name
FROM employees
WHERE UPPER(emp_name) LIKE '%'||UPPER(:nm)||'%';

-- SUBSTR 문자열 자르기 
--SUBSTR(char, pos, len) 대상 문자열 char 를 pos 번째 부터 
--                       len 길이 만큼 자른뒤 반환 
--                       pos 값으로 0 이오면 디폴트 1(첫번째 문자열)
--                                 음수가 오면 뒤에서 부터 
--                       len 값이 생략되면 pos 번째 부터 끝까지 
SELECT emp_name
     , SUBSTR(emp_name, 1, 4)
     , SUBSTR(emp_name, 4)
     , SUBSTR(emp_name,-4, 1)
FROM employees;

/* INSTR 위치 반환 
   INSTR(char, n, pos, len) char 대상문자열에서 n을 찾음 
                            pos 부터 len 번째 대상의 시작 위치를 반환       
                            pos, len 디폴트 1
*/
SELECT INSTR('abcabc', 'b', 1,1 ) 
     , INSTR('abcabc', 'b', 1,2 ) 
     , INSTR('abcabc', 'b') 
     , INSTR('abcabc', 'b', 3,1 ) 
FROM DUAL;  -- 테스트 테이블 

-- 1.TB_INFO 의 EMAIL 컬럼에서 '@'의 위치를 출력하시오 
-- 2. 1번의 위치값을 활용하여 id 와 domain 정보를 출력하시오 
--    ex) leeapgil@gmail.com  -> id:leeapgil, domain:gmail.com
--    tip. substr에 숫자를 넣어서 테스트 후 INSTR함수를 활용하세요 
--         함수의 리턴값을 생각해 보세요

SELECT email
     , SUBSTR(email, 1, INSTR(email,'@') -1) as id
     , SUBSTR(email, INSTR(email,'@')+1) as domain
FROM tb_info;
/* REPLACE 치환
   REPLACE(char, n , m)대상 문자열 char에서 n을 찾아서 m으로 변경 
*/
SELECT REPLACE('abcd','a','A') -- 
FROM DUAL;
/* TRIM:양쪽 공백제거 LTRIM:왼쪽 , RTRIM:오른쪽 */
SELECT TRIM(' hi ')
    , LTRIM(' hi ') -- 왼쪽만 
    , RTRIM(' hi ') -- 오른쪽만 
FROM dual;
/* LPAD:왼쪽채움  RPAD:오른쪽  
   LPAD(char, 5, '0')  ->> char를 5자리로 만듬('0'을 채워서)
*/
SELECT LPAD('a',5,'0')
     , LPAD('ab',5,'0')
     , RPAD('ab',5,'*')
     , RPAD('abcdef',5,'*')
FROM DUAL;
-- LENGTH <-- 문자열 길이 반환 
SELECT emp_name
     , LENGTH(emp_name)  -- 문자열 길이 
FROM employees;
-- CUSTOMERS 테이블에서 CUST_MAIN_PHONE_NUMBER 컬럼의 
-- 데이터를 *로 마스킹 처리하고 뒤 2자리만 출력되게 하시오 (phone 번호가 짧을 수 있음)



SELECT CUST_MAIN_PHONE_NUMBER
     , LPAD(SUBSTR(CUST_MAIN_PHONE_NUMBER, LENGTH(CUST_MAIN_PHONE_NUMBER)-1) 
                 , LENGTH(CUST_MAIN_PHONE_NUMBER)
                 ,'*') as phone_number
FROM CUSTOMERS;


SELECT email
     , SUBSTR(email,1, INSTR(email,'@')-1) as id
     , SUBSTR(email, INSTR(email,'@')+1) as domain
     , INSTR(email,'@') as 골뱅이위치 
FROM tb_info;










SELECT *
FROM TB_INFO
WHERE hobby is null;
	



-- NOT 논리 조건식 




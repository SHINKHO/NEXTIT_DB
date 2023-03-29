/*
   member 테이블에서 대전, 서구에 사는 회원의 정보를 출력하시오 
   아이디, 이름, 이메일, 주소, 성별 
*/
SELECT mem_id
     , mem_name
     , mem_mail
     , CASE WHEN SUBSTR(mem_regno2,1,1) = '1' THEN '남자'
            WHEN SUBSTR(mem_regno2,1,1) = '2' THEN '여자'
       END as gender
FROM member
WHERE  mem_add1 LIKE '%대전%'
AND    mem_add1 LIKE '%서구%';
/* 숫자함수 
*/
SELECT ROUND(10.5904, 2)  -- 반올림 
     , ROUND(10.5904, 1) 
     , ROUND(10.5904) 
     , ROUND(16.5904, -1)  -- 소수점 기준 왼쪽 반올림 
     , TRUNC(10.5994, 2)  -- 버림 
     , MOD(4, 2) -- 나머지 반환 
     , MOD(5, 2) 
FROM dual;
/* 날짜 함수  */
SELECT SYSDATE     -- 현재시간 
     , SYSTIMESTAMP
     , SYSDATE + 100   -- 날짜 데이터 +1 <-- 다음날의 날짜 데이터 
FROM dual;
-- ADD_MONTHS, LAST_DAY 
SELECT ADD_MONTHS(SYSDATE, 1) -- 다음날 날짜 반환 
     , ADD_MONTHS(SYSDATE, -1)-- 전달 날짜 반환 
     , LAST_DAY(SYSDATE)      -- 해당월의 마지막 날짜 반환 
FROM dual;
-- 이번달이 몇일 남았는지 출력하시오 
SELECT LAST_DAY(SYSDATE) - SYSDATE || '일 남음..'  as 남은날
FROM dual;
-- NEXT_DAY 
SELECT NEXT_DAY(SYSDATE, '목요일') 
     , NEXT_DAY(SYSDATE, '금요일') 
FROM dual;

SELECT mem_name
     , mem_bir
     , ROUND((ROUND(SYSDATE) - mem_bir)/365) as 나이 
FROM member
ORDER BY 3 ASC;

SELECT ROUND(SYSDATE, 'month')
     , ROUND(SYSDATE, 'year')
     , TRUNC(SYSDATE, 'month')
     , TRUNC(SYSDATE, 'year')
FROM dual;
/* 변환함수  TO_CHAR   문자타입으로 
            TO_NUMBER 숫자타입으로
            TO_DATE   날짜타입으로 타입변환 
*/
SELECT TO_CHAR(123456789, '999,999,999')
     , TO_CHAR(SYSDATE, 'YYYY-MM-DD')
     , TO_CHAR(SYSDATE, 'YYYY MM DD')
     , TO_CHAR(SYSDATE, 'YYYY')
     , TO_CHAR(SYSDATE, 'YYYYMMDD HH24:MI:SS')
     , TO_CHAR(SYSDATE, 'YYYYMMDD HH12:MI:SS')
FROM DUAL;

SELECT TO_DATE('2022*01*01','YYYY*MM*DD')
FROM dual;
CREATE TABLE ex4_1 (
    col1 VARCHAR2(1000)
);
INSERT INTO ex4_1 VALUES('111');
INSERT INTO ex4_1 VALUES('99');
INSERT INTO ex4_1 VALUES('1111');
INSERT INTO ex4_1 VALUES(1111);

SELECT *
FROM ex4_1
ORDER BY TO_NUMBER(col1) DESC;

-- 데이계산 
CREATE TABLE tb_myday(
     mem_id  VARCHAR2(100)
    ,d_title VARCHAR2(1000)
    ,d_day   VARCHAR2(8)
);
INSERT INTO tb_myday VALUES('a001', '연인이 된날','20170815');
INSERT INTO tb_myday VALUES('a001', '과정 시작일' ,'20230320');
-- 1.a001 회원의 과정 시작일 로부터 100일의 날짜 
-- 2.1번의 결과(100일) 일자까지 몇일 남았는지 
-- 3.과정시작일 부터 몇일이 지났는지 출력하시오 (네이버 dday기준)
SELECT TO_CHAR(TO_DATE(d_day)+99, 'YYYY.MM.DD') as 백일 
     , TO_DATE(d_day)+99 - ROUND(SYSDATE) as 남은날 
     , ROUND(SYSDATE) - TO_DATE(d_day) as 지난날 
FROM tb_myday
WHERE mem_id = 'a001'
AND d_title LIKE '%과정%';

SELECT ROUND(SYSDATE) - TO_DATE(d_day)
FROM tb_myday
WHERE d_title like '%연인%';

/*NULL 관련 함수 NVL*/
SELECT emp_name
     , salary
     , NVL(commission_pct,0) -- 값이 널 일경우 0 으로 
     , salary + salary * NVL(commission_pct,0)   as 이번상여금 
FROM employees
;

SELECT emp_name
     , NVL(commission_pct,0)
FROM employees
WHERE NVL(commission_pct,0) < 0.2;

/* 집계함수 AVG, MIN, MAX, SUM, COUNT*/
SELECT COUNT(*)                     -- null 포함  
     , COUNT(department_id)         -- default all 
     , COUNT(ALL department_id)     -- null 제외, 중복 포함 
     , COUNT(DISTINCT department_id)-- 중복 제외 
FROM employees;

SELECT SUM(salary)
     , ROUND(AVG(salary),2)
     , MIN(salary)
     , MAX(salary)
FROM employees;

SELECT DiSTINCT mem_job
FROM member;
-- member 테이블을 활용하여 회원의 수와 평균 마일리지를 출력하시오 
-- 소수점 3자리에서 반올림 
SELECT COUNT(*)
     , COUNT(mem_id)
     , ROUND(AVG(mem_mileage),2) as 평균마일리지 
FROM member;
/* GROUP BY, HAVING*/
SELECT department_id   
     , COUNT(*) as 사원수 
FROM employees
WHERE department_id IS NOT NULL-- 널이 아닌 (널인것만 조회 IS NULL)
GROUP BY department_id   -- 부서별 
HAVING COUNT(*) >= 5     -- 집계결과에서 검색조건  
ORDER BY 사원수;

SELECT department_id
     , job_id
     , COUNT(*)  as 사원수  -- 집계함수를 제외한 
FROM employees             -- select 표시 컬럼은 
GROUP BY department_id     -- group by 절에 포함되어야함.
       , job_id
ORDER BY 1;

-- member 회원의 직업별 회원수와, 평균 마일리지를 출력하시오 
-- 소수점 2째 자리까지 표현(정렬: 평균마일리지 내림차순)
--                      (검색조건 : 회원수 3명이상)
SELECT mem_job
     , COUNT(*) as 회원수 
     , ROUND(AVG(mem_mileage),2) as 평균마일리지 
FROM member
GROUP BY mem_job
HAVING COUNT(*) >= 3
ORDER BY 3 desc;

-- 년도별 대출합계 
SELECT SUBSTR(period,1 ,4 ) as 년도 
     , SUM(loan_jan_amt)    as 대출합계
FROM kor_loan_status
GROUP BY SUBSTR(period,1 ,4 )
ORDER BY 1;
-- 2013년도 지역별 대출합계 
SELECT region 
     , SUM(loan_jan_amt) as 대출합계 
FROM kor_loan_status 
WHERE period LIKE '2013%'
GROUP BY region
ORDER BY 2 DESC;








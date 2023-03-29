/*
    동등조인 (EQUI-JOIN) == 내부조인 (INNER JOIN)
    WHERE 절에 = 등호 연산자 사용 
    A = B 공통된 값을 가진 행이 연결 
*/
SELECT *
FROM 학생 a
   , 수강내역 b
WHERE a.학번 = b.학번;
/* 만약 수강내역이 없는 학생도 조회 되어야 한다면 
   외부조인 사용 (outer join)
   널값을 포함시킬 쪽에 (+)  
*/
SELECT *
FROM 학생 a
   , 수강내역 b
WHERE a.학번 = b.학번(+)
AND a.이름 = '양지운';

/* sub query  
  SQL문장 안에 보조로 사용되는 또는 또 다른 SELECT 문 
  형태에 따라 
  1.일반 서브쿼리(스칼라 서브쿼리) : SELECT 절
  2.인라인 뷰                    : FROM 절 
  3.중첩 쿼리                    : WHERE 절 
*/

-- (1) select 절
-- job_id 를 이용하여 job_title 출력 

SELECT  a.emp_name
      , (SELECT department_name 
         FROM departments
         WHERE department_id = a.department_id) as dep_nm
      , (SELECT job_title
         FROM jobs
         WHERE job_id = a.job_id) as job_title  
FROM employees a;

SELECT  (SELECT emp_name
         FROM employees 
         WHERE department_id = a.department_id) as emp_name
         -- 스칼라 서브쿼리는 1=1 매핑이여야함. 1=m이면 오류 
FROM departments a;

SELECT a.이름 
      ,b.수강내역번호 
      ,b.과목번호  -- 과목번호를 사용하여 과목 이름을 출력하시오 
      ,(SELECT 과목이름 
        FROM 과목 
        WHERE 과목번호 = b.과목번호) as 과목명 
FROM 학생 a 
    ,수강내역 b
WHERE a.학번 = b.학번
AND   a.이름 = '최숙경';

-- 의사 컬럼 ROWNUM 
-- 테이블에는 없지만 있는것 처럼 사용할 수 있는 ..
SELECT  ROWNUM as rnum
      , a.*
FROM employees a;

-- (2) 인라인뷰 (FROM절에 사용 SELECT문의 결과를 테이블 처럼사용)
SELECT *
FROM (SELECT  ROWNUM as rnum
            , a.*
       FROM employees a
      ) b
WHERE b.rnum BETWEEN 11 AND 20  -- between i and j 는 i~j 까지 
;

SELECT *
FROM(SELECT  ROWNUM as rnum 
           , a.*
     FROM (SELECT  *
           FROM employees 
           WHERE department_id = 50
           ORDER BY emp_name
          ) a
    ) c
WHERE c.rnum BETWEEN 11 AND 20;

-- 학생중 평점이 가장 높은 학생을 출력하시오 
SELECT *
FROM (
        SELECT *
        FROM 학생 
        ORDER BY 평점 DESC -- 평점기준 내림차순 정렬
      )
WHERE ROWNUM <= 1;
-- 학생 평점이 2번째로 높은 학생부터 ~ 4번째 학생까지 출력하시오 
SELECT rnum ,이름, 평점 
FROM (
    SELECT  ROWNUM as rnum 
          , a.*
    FROM(SELECT *
         FROM 학생 
         ORDER BY 평점 DESC
         ) a
     )
WHERE rnum BETWEEN 2 AND 4;
--(3) where 절 
SELECT 이름, 평점 
FROM 학생 
WHERE 평점 >= (SELECT AVG(평점) 
              FROM 학생);
-- 수강내역이 있는 학생을 조회하시오 
SELECT 이름 
FROM 학생 
WHERE 학번 IN(SELECT 학번 
             FROM 수강내역) ;
--수강내역이 없는 학생 조회 
SELECT 이름 
FROM 학생 
WHERE 학번 NOT IN(SELECT 학번 
                 FROM 수강내역) ;






SELECT rnum
     , 이름 
     , 전공 
     , 평점 
FROM (
        SELECT  ROWNUM as rnum
              , a.*
        FROM 
        (SELECT *
        FROM 학생 
        ORDER BY 평점 DESC ) a
    )
WHERE rnum BETWEEN 2 AND 4;

;


--직원의 평균 salary 보다 많이 받는 사원의 수를 출력하시오
SELECT count(*) as 사원수 
FROM employees
WHERE salary >= (SELECT AVG(salary)
                 FROM employees);
                 
                 
                 
--직원의 년도별 요일별 입사 인원수를 출력하시오 
-- ex)1. hire_date를 활용하여 년도 구하기 
--    2. hire_date를 활용하여 요일 구하기 
--    3. 각 요일만 포함되도록 요일컬럼 만들기 (ex decode)
--    4. 3번까지 구한 결과를 가지고 집계 하기 (인라인 뷰 사용하면 편함)






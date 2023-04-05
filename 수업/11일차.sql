/*분석함수 
  PARTITION BY : 계산 대상그룹 
  ORDER BY : 대상 그룹 정렬 
  WINDOW   : 파티션으로 분할된 그룹에 대해 더 상세한 그룹 
             분할 시 사용.
*/
-- ROW_NUMBER 
SELECT department_id
     , emp_name
     , ROW_NUMBER() OVER(PARTITION BY department_id
                         ORDER BY emp_name) as dep_row
FROM employees;
-- RANK 동일 순위 있을시 건너뜀 
-- DENSE_RANK 건너 뛰지 않음 
SELECT department_id
     , emp_name
     , salary
     , RANK() OVER(PARTITION BY department_id
                   ORDER BY salary DESC) as rank1
     , RANK() OVER(ORDER BY salary DESC) as all_rank
     , DENSE_RANK() OVER(PARTITION BY department_id
                         ORDER BY salary DESC) as rank2
FROM employees
WHERE department_id = 50;

-- 전공별 1등만(평점) 출력하시오 (학생테이블)
SELECT *
FROM (  SELECT 이름 
             , 전공 
             , 평점 
             , RANK() OVER(PARTITION BY 전공 
                           ORDER BY 평점 DESC)  as 순위
        FROM 학생 
     )
WHERE 순위 = 1;
-- 직원의 부서별 평균급여 
-- 전체 평균 급여와 직원 급여를 출력하시오 
SELECT ROUND(AVG(salary) OVER(PARTITION BY department_id),2) as 부서평균
     , ROUND(AVG(salary) OVER(),2) as 전체평균 
     , salary 
     , emp_name
     , department_id 
FROM employees;


--2013년도 지역별 loan_jan_amt합계금액과 
--loan_jan_amt합계금액 순위(내림차순)를 출력하시오 
SELECT region
     , amt
     , RANK() OVER(ORDER BY amt DESC) as rnk
FROM (
        SELECT REGION 
             , SUM(loan_jan_amt) as amt
        FROM kor_loan_status
        WHERE period LIKE '2013%'
        GROUP BY REGION 
);

SELECT REGION 
     , SUM(loan_jan_amt) as amt
     , RANK() OVER(ORDER BY SUM(loan_jan_amt) DESC)  as rnk
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY REGION ;

--NTILE(3) 함수는 정렬된 PARTITION 을 bucket(그룹)별로 나누고 
--         배치하는 함수 (3은 버킷을 3개로 나눠 담음) 
SELECT department_id
     , emp_name
     , salary
     , NTILE(3) OVER(PARTITION BY department_id
                     ORDER BY salary) as ntiles 
FROM employees
WHERE department_id IN(30, 60);
CREATE TABLE ex_team AS
SELECT a.*
      ,NTILE(6) OVER(ORDER BY DBMS_RANDOM.VALUE) as team
FROM (
        SELECT info_no, nm 
        FROM tb_info
        WHERE nm != '이앞길'
     ) a;

SELECT *
FROM ex_team;

SELECT department_id, salary
     , emp_name
     , WIDTH_BUCKET(salary, 1000, 10000, 4) as buk
FROM employees
WHERE department_id = 60;

-- PERCENT_RANK()  백분위 수를 반환 0 ~ 1
SELECT department_id, emp_name
     , salary
     , PERCENT_RANK() OVER(PARTITION BY department_id
                         ORDER BY salary) as percentt
FROM employees
WHERE department_id = 60;

-- LAG, 선행로우 반환, LEAD 후행로우 반환 
SELECT emp_name
     , salary
     , department_id
     , LAG(emp_name, 2, '가장높음') OVER(
                        PARTITION BY department_id
                        ORDER BY salary DESC) as lags
     , LEAD(emp_name, 2, '가장낮음') OVER(
                        PARTITION BY department_id
                        ORDER BY salary DESC) as leads
FROM employees
WHERE department_id =30;
            
-- 전공별로 각 학생의 평점보다 
-- 한단계 높은 학생과의 평점 차이를 출력 하시오  (소수점 2째짜리 까지)
SELECT 이름, 전공, ROUND(평점,2) as 내평점 
     , LAG(이름, 1, '나다') OVER(PARTITION BY 전공 
                               ORDER BY 평점 DESC) as 나보다위 
     , ROUND(LAG(평점, 1, 평점) OVER(PARTITION BY 전공 
                               ORDER BY 평점 DESC) - 평점, 2)  as 평점차이 
FROM 학생 ;

/* window 절 
  ROWS : 로우(행) 단위로 window 지정 
  RANGE : 논리적인 범위로 window 지정
  preceding (처음)
  current row (현재 행)
  following  (끝지점)
*/
SELECT department_id, emp_name, hire_date, salary
      ,SUM(salary) OVER(PARTITION BY department_id 
                        ORDER BY hire_date 
                        ROWS BETWEEN UNBOUNDED 
                        PRECEDING AND CURRENT ROW) as first_current
    ,SUM(salary) OVER(PARTITION BY department_id 
                        ORDER BY hire_date 
                        ROWS BETWEEN CURRENT ROW 
                        AND UNBOUNDED FOLLOWING) as current_last
FROM employees
WHERE department_id = 30;

-- sales 1998년도 월별 누적 집계를 출력하시오 
-- 1 ~ 12월  (amout_sold)
SELECT sales_month
     , amt
     , SUM(amt) OVER(ORDER BY sales_month
                     ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW)  as 누적합 
FROM (
      SELECT sales_month
           , SUM(amount_sold) as amt
      FROM sales
      WHERE sales_month LIKE '1998%'
      GROUP BY sales_month
    );




SELECT sales_month
   , amt
   , ROUND(RATIO_TO_REPORT(amt) OVER() * 100 ,2) ||'%' as ratio
FROM (
      SELECT sales_month
           , SUM(amount_sold) as amt
      FROM sales
      WHERE sales_month LIKE '1998%'
      GROUP BY sales_month
    )
ORDER BY 1;




SELECT department_id, emp_name, hire_date, salary
      ,SUM(salary) OVER(PARTITION BY department_id 
                        ORDER BY hire_date 
         ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as one_current
    ,SUM(salary) OVER(PARTITION BY department_id 
                        ORDER BY hire_date 
                        ROWS BETWEEN CURRENT ROW 
                        AND 2 FOLLOWING) as two_last
    ,SUM(salary) OVER(PARTITION BY department_id 
                        ORDER BY hire_date 
                        ROWs BETWEEN 1 PRECEDING 
                        AND 1 FOLLOWING) as before1_after1
                        
FROM employees
WHERE department_id = 30;




-- 대전,서울,세종의 지역별, 대출종류별,
-- 월별 대출잔액과 지역별 파티션을 만들어 대출종류별 대출잔액의 %를 구하는 쿼리를 작성해보자. 
-- (201210, 201211, 201310, 201311
SELECT REGION, 
       GUBUN,
       AMT1 || '( ' || ROUND(RATIO_TO_REPORT(amt1) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201210",
       AMT2 || '( ' || ROUND(RATIO_TO_REPORT(amt2) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201211",
       AMT3 || '( ' || ROUND(RATIO_TO_REPORT(amt3) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201310",
       AMT4 || '( ' || ROUND(RATIO_TO_REPORT(amt4) OVER ( PARTITION BY REGION ),2) * 100 || '% )' AS "201311"
FROM (
    SELECT REGION, GUBUN,
           SUM(AMT1) AS AMT1, 
           SUM(AMT2) AS AMT2, 
           SUM(AMT3) AS AMT3, 
           SUM(AMT4) AS AMT4 
      FROM ( 
             SELECT REGION,
                    GUBUN,
                    CASE WHEN PERIOD = '201210' THEN LOAN_JAN_AMT ELSE 0 END AMT1, 
                    CASE WHEN PERIOD = '201211' THEN LOAN_JAN_AMT ELSE 0 END AMT2, 
                    CASE WHEN PERIOD = '201310' THEN LOAN_JAN_AMT ELSE 0 END AMT3,
                    CASE WHEN PERIOD = '201311' THEN LOAN_JAN_AMT ELSE 0 END AMT4
             FROM KOR_LOAN_STATUS
             WHERE REGION IN ('서울','대전','세종')
           )
     GROUP BY REGION, GUBUN
    )
ORDER BY REGION;

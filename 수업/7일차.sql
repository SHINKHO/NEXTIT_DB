SELECT *
FROM member;

-- 주소가 충남인 회원을 출력하시오 
-- 아이디, 이름, 메일, 마일리지, 주소 

SELECT mem_id
     , mem_name
     , mem_mail
     , mem_mileage
     , mem_add1
FROM member
WHERE mem_add1 LIKE '%충남%';

-- 마일리지가 5000 이상인 고객을 출력하시오 



SELECT mem_id
     , mem_name
     , mem_mail
     , mem_mileage
     , mem_add1
FROM member
WHERE mem_mileage >= 5000;

-- 회원의 '전체 평균마일리지' 보다 큰 회원을 출력하시오 
SELECT mem_id
     , mem_name
     , mem_mail
     , mem_mileage
     , mem_add1
FROM member
WHERE mem_mileage >= (SELECT AVG(mem_mileage)
                      FROM member);

-- 회원의 직업별 회원수,
-- 마일리지의 평균(소수점 2째자리까지), 최소, 최대값을 출력하시오 
SELECT mem_job 
     , COUNT(*) as 회원수 
     , ROUND(AVG(mem_mileage), 2) as 평균
     , MAX(mem_mileage) as 최대
     , MIN(mem_mileage) as 최소
FROM member
GROUP BY mem_job;

-- 직업별 마일리지 평균이 가장큰 직업의 
-- 회원수, 마일리지평균(소수점 2째자리까지), 최소, 최대값 출력
-- 1.평균으로 정렬(내림차준) 
-- 2.1건만 출력 (ROWNUM) 
SELECT *
FROM ( SELECT mem_job 
             , COUNT(*) as 회원수 
             , ROUND(AVG(mem_mileage), 2) as 평균
             , MAX(mem_mileage) as 최대
             , MIN(mem_mileage) as 최소
        FROM member
        GROUP BY mem_job
        ORDER BY 평균 DESC
     )
WHERE ROWNUM <= 1;

-- 마일리지가 가장 큰 회원의 정보를 출력하시오 
SELECT mem_id
     , mem_name
     , mem_mail
     , mem_mileage
     , mem_add1
FROM member
WHERE mem_mileage = (SELECT MAX(mem_mileage)
                     FROM member);
   
   
   
                     
-- 회원중 생일의 요일중(ex 금요일) 가장 많은 
-- 요일 생일인 회원들의 정보를 출력하시오  
-- ex) 1.가장많은 생일 요일 구하기 
--     2.1의 요일이 생일인 회원 출력 
SELECT 요일
FROM (
        SELECT TO_CHAR(mem_bir,'DAY') as 요일 
            ,  COUNT(*) cnt
        FROM member
        GROUP BY TO_CHAR(mem_bir,'DAY')
        ORDER BY 2 DESC
    )
WHERE ROWNUM <= 1;

SELECT mem_name, mem_bir
     , TO_CHAR(mem_bir,'DAY') as 요일 
FROM member
WHERE TO_CHAR(mem_bir,'DAY') = (SELECT 요일
                                FROM (
                                        SELECT TO_CHAR(mem_bir,'DAY') as 요일 
                                            ,  COUNT(*) cnt
                                        FROM member
                                        GROUP BY TO_CHAR(mem_bir,'DAY')
                                        ORDER BY 2 DESC
                                    )
                                WHERE ROWNUM <= 1)
ORDER BY 2 DESC;






SELECT  mem_id
     , mem_name
     , mem_bir
     , TO_CHAR(mem_bir,'DAY') as 생일 
FROM member
WHERE TO_CHAR(mem_bir, 'DAY') = (SELECT 요일 
                                 FROM (SELECT TO_CHAR(mem_bir,'DAY') as 요일 
                                            , COUNT(*)
                                        FROM member
                                        GROUP BY TO_CHAR(mem_bir,'DAY') 
                                        ORDER BY 2 DESC
                                    )
                                WHERE ROWNUM <=1 )
ORDER BY 3 DESC;
 
 SELECT *
 FROM cart;
 
 
 -- 회원의 구매이력(카트이용수)를 출력하시오(카트이용수:내림차순)
 -- (구매이력이 있는 회원대상) 
 -- ex)  회원별 cart_no 중복제거 값 
 SELECT a.mem_id
      , a.mem_name
      , COUNT(DISTINCT b.cart_no) as 이용수 
       FROM member a 
    , cart b
 WHERE a.mem_id = b.cart_member
 GROUP BY a.mem_id, a.mem_name
 ORDER BY 3 DESC;
 
 
 
-- 판매가된 상품의 '판매건수'와 상위 10건을 출력하시오 
-- cart, prod (동일 판매수가 있을시 상품명 오름차순)
SELECT *
FROM ( SELECT a.prod_id
             ,a.prod_name
             ,SUM(b.cart_qty) as 판매수 
       FROM prod a 
           ,cart b
       WHERE a.prod_id = b.cart_prod
       GROUP BY a.prod_id,a.prod_name
       ORDER BY 3 DESC, 2 ASC
     )
WHERE ROWNUM <= 10;






SELECT *
FROM (
        SELECT a.prod_id, a.prod_name
             , SUM(b.cart_qty) as 판매수 
        FROM prod a
            ,cart b
        WHERE a.prod_id = b.cart_prod
        GROUP BY a.prod_id, a.prod_name
        ORDER BY 3 DESC, 2 ASC
     )
WHERE ROWNUM <= 10;
 
 
 
 
 
 
SELECT mem_id
     , mem_name
     , COUNT(DISTINCT b.cart_no) as 카트이용수 
FROM member a
    , cart b
WHERE a.mem_id = b.cart_member
GROUP BY mem_id
       , mem_name
ORDER BY 3 DESC;
 
-- EXISTS 존재하는지 체크 (세미조인 방법) 
SELECT *
FROM 학생 
WHERE EXISTS (SELECT 1   --<-- select절 내용은 의미없음 
              FROM 수강내역 
              WHERE 학번 = 학생.학번);
-- 수강내역 테이블 학번 컬럼에 학생의 학번과 동일한 
-- 경우만 학생테이블에서 조회 
-- 안티조인 
SELECT *
FROM 학생 
WHERE NOT EXISTS (SELECT 1   --<-- select절 내용은 의미없음 
                  FROM 수강내역 
                  WHERE 학번 = 학생.학번);
-- 수강내역테이블에 존재하지 않는 건만 학생테이블에서 조회  
-- 
-- employees 테이블에 부서아이디가 사용되지 않는 
-- departments 테이블 정보를 조회하시오 
SELECT *
FROM departments a
WHERE NOT EXISTS (SELECT *
                  FROM employees b
                  WHERE b.department_id = a.department_id);

-- IN 을 사용하여 부서아이디가 사용되는 부서정보 출력 
SELECT *
FROM departments a
WHERE a.department_id IN (SELECT DISTINCT department_id
                          FROM employees ); 




-- 구매이력이 없는 회원을 조회 하시오


SELECT *
FROM member a
WHERE NOT EXISTS (SELECT * 
                  FROM cart 
                  WHERE cart_member = a.mem_id);

-- 직업중 회원이 가장 많은 직업의 최다 상품 최다판매(수량)을 출력하시오  
-- 1.회원이 가장 많은 직업 (ex 주부)
-- 2. 1.직업을 가진 회원들이 가장 많이 산 상품의 판매수 구하기  


-- P201000018/여성 여름 자켓 3/27 


SELECT *
FROM (
        SELECT c.prod_id
             , c.prod_name
             , SUM(b.cart_qty) as 구매수 
        FROM member a
           , cart b
           , prod c
        WHERE a.mem_id = b.cart_member
        AND   b.cart_prod = c.prod_id 
        AND   a.mem_job = (SELECT mem_job
                            FROM ( SELECT mem_job, count(*) as cnt
                                 FROM member 
                                 GROUP BY mem_job
                                 ORDER BY 2 DESC)
                            WHERE ROWNUM <=1)
        GROUP BY c.prod_id
               , c.prod_name
        ORDER BY 3 DESC
     )
    WHERE ROWNUM <=1;
    
    
SELECT mem_job
FROM ( SELECT mem_job, count(*) as cnt
       FROM member 
       GROUP BY mem_job
       ORDER BY 2 DESC
      )
WHERE ROWNUM <=1;


SELECT c.prod_id
     , c.prod_name
     , SUM(b.cart_qty) as 구매수 
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member
AND   b.cart_prod = c.prod_id 
AND   a.mem_job = (SELECT mem_job
                    FROM ( SELECT mem_job, count(*) as cnt
                           FROM member 
                           GROUP BY mem_job
                           ORDER BY 2 DESC
                          )
                    WHERE ROWNUM <=1)
GROUP BY c.prod_id
       , c.prod_name
ORDER BY 3 DESC;


 
 
SELECT *
FROM cart 
WHERE cart_prod = 'P201000018';
 
 
 
-- 2000년 이탈리아 평균 매출액(연평균) 
-- 보다 큰 (월평균) 매출액(amount_sold)을 구하시오 
-- sales, customers ,countries 
--검색조건 : 'Italy' and 2000년도(sales_month 활용)






SELECT a.* 
  FROM ( SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
           FROM sales a,
                customers b,
                countries c
          WHERE a.sales_month BETWEEN '200001' AND '200012'
            AND a.cust_id = b.CUST_ID
            AND b.COUNTRY_ID = c.COUNTRY_ID
            AND c.COUNTRY_NAME = 'Italy'     
          GROUP BY a.sales_month  
       )  a,
       ( SELECT ROUND(AVG(a.amount_sold)) AS year_avg
           FROM sales a,
                customers b,
                countries c
          WHERE a.sales_month BETWEEN '200001' AND '200012'
            AND a.cust_id = b.CUST_ID
            AND b.COUNTRY_ID = c.COUNTRY_ID
            AND c.COUNTRY_NAME = 'Italy'       
       ) b
 WHERE a.month_avg > b.year_avg ;
 
 SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
   FROM sales a,
        customers b,
        countries c
  WHERE a.sales_month BETWEEN '200001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID
    AND c.COUNTRY_NAME = 'Italy'     
  GROUP BY a.sales_month 
  HAVING  ROUND(AVG(a.amount_sold)) >(SELECT ROUND(AVG(a.amount_sold)) AS year_avg
                                       FROM sales a,
                                            customers b,
                                            countries c
                                      WHERE a.sales_month BETWEEN '200001' AND '200012'
                                        AND a.cust_id = b.CUST_ID
                                        AND b.COUNTRY_ID = c.COUNTRY_ID
                                        AND c.COUNTRY_NAME = 'Italy')
 ORDER BY 1 ;
 
SELECT b.department_id 
     , department_name 
     , emp_name  
FROM employees  a
   , departments b
WHERE a.department_id = b.department_id;

 
 
 
 
 
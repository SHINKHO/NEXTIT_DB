/*
 STUDY 계정에 create_table 스크립트를 실해하여 
 테이블 생성후 1~ 5 데이터를 임포트한 뒤 
 아래 문제를 출력하시오 
 (문제에 대한 출력물은 이미지 참고)
 모든 문제 풀이 시작시간과 종료시간을 작성해 주세요 
*/
-----------1번 문제 ---------------------------------------------------
--1988년 이후 출생자의 직업이 의사,자영업 고객을 출력하시오 (어린 고객부터 출력S
DESC customer;
SELECT *
FROM customer
WHERE TO_NUMBER(SUBSTR(birth, 1, 4))  >= 1988 
AND JOB IN('의사','자영업')
ORDER BY TO_DATE(birth) DESC;
/* 작성 쿼리 */
---------------------------------------------------------------------
-----------2번 문제 ---------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 
---------------------------------------------------------------------
SELECT a.customer_name
      ,a.phone_number
FROM customer a
   , address b
WHERE a.zip_code = b.zip_code
AND   b.address_detail = '강남구';

SELECT customer_name
      ,phone_number
FROM customer 
WHERE zip_code = (SELECT zip_code 
                  FROM address 
                  WHERE address_detail = '강남구');
----------3번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)
---------------------------------------------------------------------
SELECT job 
     , COUNT(*) as 회원수 
FROM  customer
WHERE job IS NOT NULL
GROUP BY job 
ORDER BY 2 DESC;
----------4-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
---------------------------------------------------------------------
SELECT *
FROM (
        SELECT TO_CHAR(FIRST_REG_DATE,'DAY') as 요일 
             , COUNT(*) as 건수 
        FROM customer
        GROUP BY TO_CHAR(FIRST_REG_DATE,'DAY')
        ORDER BY 2 DESC
     )
WHERE ROWNUM <=1;
----------4-2번 문제 ---------------------------------------------------
-- 남녀 인원수를 출력하시오 
---------------------------------------------------------------------
SELECT decode(gender, 'F', '여자','M','남자','N','미등록', '합계') as gender
     , cnt 
FROM (  SELECT gender 
             , count(*) as cnt
        FROM (
                SELECT DECODE(sex_code,NULL, 'N', sex_code) as gender
                FROM customer
             )
        GROUP BY ROLLUP(gender)
     );

-----------------------------------------------
SELECT decode(sex_code, 'F', '여자','M','남자','미등록') as gender
      ,cnt
FROM (  SELECT sex_code
            , COUNT(*) as cnt
        FROM customer
        GROUP BY sex_code  )
UNION 
SELECT '합계', cnt 
FROM (  SELECT COUNT(*) as cnt
        FROM customer
     );
     
-- GROUPING_ID 
SELECT CASE WHEN sex_code = 'F' THEN '여자'
            WHEN sex_code = 'M' THEN '남자'
            WHEN sex_code IS NULL AND groupid = 0 THEN '미등록'
            ELSE '합계' 
           END as gender
      ,cnt 
FROM ( SELECT  sex_code
             , GROUPING_ID(sex_code) as groupid
             , COUNT(*) as cnt 
        FROM customer
        GROUP BY ROLLUP(sex_code)
        );
        
SELECT region, gubun 
     , SUM(loan_jan_amt), GROUPING_ID(region, gubun)
FROM kor_loan_status
GROUP BY ROLLUP(region, gubun );
----------5번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
---------------------------------------------------------------------
SELECT TO_CHAR(TO_DATE(reserv_date) ,'MM') as 월 
     , COUNT(*) as 취소건수 
FROM reservation
WHERE cancel = 'Y'
GROUP BY TO_CHAR(TO_DATE(reserv_date) ,'MM')
ORDER BY 2 DESC;
----------6번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
-----------------------------------------------------------------------------
SELECT item_id
     , product_name
FROM item;

SELECT item_id
      ,sales
FROM order_info;

SELECT a.product_name as 상품이름 
     , SUM(b.sales)   as 상품매출
FROM item a
   , order_info b
WHERE a.item_id = b.item_id 
GROUP BY a.item_id, a.product_name
ORDER BY 2 DESC;
---------- 7번 문제 ---------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------
SELECT reserv_date
     , reserv_no
FROM reservation ;

SELECT reserv_no 
     , item_id
     , sales
FROM order_info;

SELECT SUBSTR(a.reserv_date,1,6) as 매출월 
     , SUM(DECODE(b.item_id,'M0001',b.sales, 0)) AS SPACIAL_SET
     , SUM(DECODE(b.item_id,'M0002',b.sales, 0)) AS PASTA
     , SUM(DECODE(b.item_id,'M0003',b.sales, 0)) AS PIZZA
FROM reservation a
   , order_info b
WHERE a.reserv_no = b.reserv_no 
GROUP BY SUBSTR(a.reserv_date,1,6)
ORDER BY 1;
---------- 8번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
----------------------------------------------------------------------------
SELECT 월 
     , product_name
     , SUM(DECODE(요일, '1',sales,0)) as 일요일 
     , SUM(DECODE(요일, '2',sales,0)) as 월요일 
     , SUM(DECODE(요일, '3',sales,0)) as 화요일 
     , SUM(DECODE(요일, '4',sales,0)) as 수요일 
     , SUM(DECODE(요일, '5',sales,0)) as 목요일 
     , SUM(DECODE(요일, '6',sales,0)) as 금요일 
     , SUM(DECODE(요일, '7',sales,0)) as 토요일 
FROM (
        SELECT SUBSTR(a.reserv_date,1,6) 월 
             , TO_CHAR(TO_DATE(a.reserv_date),'d') as 요일 
             , c.product_name
             , b.sales
        FROM reservation a
           , order_info b
           , item c 
        WHERE a.reserv_no = b.reserv_no 
         AND  b.item_id = c.item_id
         AND  c.product_desc = '온라인_전용상품'
)
GROUP BY 월, product_name
ORDER BY 1 ;
---------- 9번 문제 ----------------------------------------------------
-- 고객수, 남자인원수, 여자인원수, 평균나이, 평균거래기간(월기준)을 구하시오 
-- (성별 NULL 제외, 생일 NULL  제외, MONTHS_BETWEEN, AVG, ROUND 사용(소수점 1자리 까지) 나이계산 
----------------------------------------------------------------------------
SELECT COUNT(*) as 고객수 
     , SUM(DECODE(sex_code,'M',1,0)) 남자 
     , SUM(DECODE(sex_code,'F',1,0)) 여자
     , ROUND(AVG(MONTHS_BETWEEN(sysdate,TO_DATE(birth,'YYYYMMDD'))/12),1) as 평균나이 
     , ROUND(AVG(MONTHS_BETWEEN(sysdate, first_reg_date))/12,1) as 평균거래 
FROM customer
WHERE birth IS NOT NULL
AND  sex_code IS NOT NULL;

---------- 10번 문제 ----------------------------------------------------
--매출이력이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
----------------------------------------------------------------------------

SELECT b.address_detail
    , COUNT(*)
FROM (
        SELECT DISTINCT a.customer_id
            ,  a.zip_code
        FROM customer a
           , reservation b
           , order_info c
        WHERE a.customer_id = b.customer_id
        AND   b.reserv_no = c.reserv_no
        GROUP BY a.customer_id
            ,  a.zip_code
     ) a, address b
WHERE a.zip_code = b.zip_code
GROUP BY b.address_detail, a.zip_code
ORDER BY 2 DESC;









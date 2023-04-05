/*
 STUDY 계정에 create_table 스크립트를 실해하여 
 테이블 생성후 1~ 5 데이터를 임포트한 뒤 
 아래 문제를 출력하시오 
 (문제에 대한 출력물은 이미지 참고)
 모든 문제 풀이 시작시간과 종료시간을 작성해 주세요 
*/
-----------1번 문제 ---------------------------------------------------
--1988년 이후 출생자의 직업이 의사,자영업 고객을 출력하시오 (어린 고객부터 출력)
시작시간 :  2023-03-31 14:15:36
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') as 시작시간 FROM DUAL;
종료시간 : 
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') as 종료시간 FROM DUAL;
/* 작성 쿼리 */
select * from customer a
where a.job in ('의사','자영업')
and substr(a.birth,0,4) >= 1988
order by a.birth desc;
/*풀이*/
DESC customer;
SELECT *
FROM customer
WHERE TO_NUMBER(SUBSTR(birth,1,4)) >='1988'
AND JOB IN ('의사','자영업')
ORDER BY TO_DATE(birth) DESC; -- date 형으로 바꾸어주지 않으면 99년도생이 
                              -- 2000년도생보다 앞설수 있음으로 항상 쓰는 습관을 들이자 
---------------------------------------------------------------------
-----------2번 문제 ---------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 
시작시간 :  2023-03-31 14:15:36
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') as 시작시간 FROM DUAL;
종료시간 : 2023-03-31 14:27:26
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') as 종료시간 FROM DUAL;

select a.customer_name,a.phone_number
from customer a INNER JOIN address b USING(ZIP_CODE)
where ADDRESS_DETAIL LIKE '%강남구%';

--풀이 
SELECT  a.customer_name,
        a.phone_number
FROM    customer a,
        address b
WHERE a.zip_code = b.zip_code
AND b.address_detail = '강남구';
---------------------------------------------------------------------
----------3번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)
시작시간 :  2023-03-31 14:27:55
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') as 시작시간 FROM DUAL;
종료시간 : 2023-03-31 14:32:17
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') as 종료시간 FROM DUAL;

SELECT job,
       count(customer_id) CNT
FROM customer
GROUP BY job
HAVING job is not null
order by 2 desc, 1 asc;

--풀이
SELECT  job,
        COUNT(*) as 회원수
FROM customer
where job is not null
group by job
order by 2 desc;

---------------------------------------------------------------------
----------4-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
시작시간 :  2023-03-31 14:32:45
종료시간 : 2023-03-31 15:06:26
--
--SELECT to_char(to_date(r.reserv_date,'YYYYMMDD'),'day') as day
--        ,count(c.customer_id) as cnt
--FROM CUSTOMER c 
--INNER JOIN RESERVATION r
--ON(c.FIRST_REG_DATE = to_date(r.RESERV_DATE,'YYYYMMDD'))
--group by to_char(to_date(r.reserv_date,'YYYYMMDD'),'day')
--;

SELECT  to_char(first_reg_date,'DAY') as 요일 
        , count(*) as 건수
from customer 
group by to_char(first_reg_date,'DAY') 
order by 2 desc;

--풀이
SELECT *
FROM
(
SELECT  TO_CHAR(FIRST_REG_DATE,'DAY') as 요일,
        COUNT(*) as 건수
FROM customer
GROUP BY TO_CHAR(FIRST_REG_DATE,'DAY')
ORDER BY 2 DESC
)
where rownum <=1;
---------------------------------------------------------------------
----------4-2번 문제 ---------------------------------------------------
-- 남녀 인원수를 출력하시오 
시작시간 :  2023-03-31 15:07:40
종료시간 :  2023-03-31 15:18:15
SELECT nvl(a.gender,'합계')as gender , count(customer_id) cnt
FROM
    (SELECT case when sex_code = 'M' then '남자' 
    when sex_code = 'F' then '여자'
    ELSE '미등록' END as gender, customer_id
    from customer ) a
GROUP BY rollup(a.gender)
;
--풀이1
SELECT decode(gender,'F','여자','M','남자','N','미등록','합계') as gender,cnt
FROM (
    SELECT  gender,
            count(*) as cnt
    FROM(
        SELECT  DECODE(sex_code,NULL,'N',SEX_CODE) as gender -- null건을 어떻게 처리할 것인가 
        FROM customer
        )
    GROUP BY ROLLUP(gender)
    );
--풀이2
SELECT decode(sex_code,'F','여자','M','남자','미등록') as gedner
        ,cnt
FROM(
    SELECT  sex_code,
            COUNT(*) as cnt
    FROM customer
    GROUP BY sex_code
    )
UNION
SELECT '합계', COUNT(*) as cnt
FROM customer;
--GROUPING_ID
SELECT  CASE WHEN sex_code = 'F' THEN '여자'
            WHEN sex_code = 'M' THEN '남자'
            WHEN sex_code IS NULL AND groupid=0 THEN '미등록'
            ELSE '합계'
            END as gender,
        cnt
FROM(   SELECT sex_code,
        GROUPING_ID(sex_code) as groupid,--얼마만큼 총계가 구해졌는지 나타내는 지표를 추가해준다.                                -- 
        COUNT(*) as cnt
FROM customer
GROUP BY ROLLUP(sex_code)
)
;
---------------------------------------------------------------------
----------5번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
시작시간 :  2023-03-31 15:18:43
종료시간 :  2023-03-31 15:24:06
SELECT substr(reserv_date,5,2) as 월 , count(*) as 취소건수
FROM reservation 
where cancel ='Y'
group by substr(reserv_date,5,2)
order by 취소건수 desc;
--풀이
SELECT TO_CHAR(TO_DATE(reserv_date), 'MM') as 월,
        count(*) as 취소건수
FROM reservation
WHERE cancel ='Y'
GROUP BY TO_CHAR(TO_DATE(reserv_date),'MM')
ORDER BY 2;
---------------------------------------------------------------------
----------6번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
 시작시간 :  2023-03-31 15:25:01
종료시간 :  2023-03-31 15:27:28
select  it.product_name as 상품이름, 
        sum(oi.sales) as 상품매출
from    item it inner join order_info oi
using(item_id)
group by it.product_name
order by 2 desc;
--풀이
--필요 테이블 1
SELECT  item_id,
        product_name
FROM item;
--필요 테이블 2
SELECT  item_id,
        sales
FROM order_info;
-- JOIN
SELECT  product_name,
        SUM(sales)
FROM item a inner join order_info b 
            ON(a.item_id=b.item_id)
GROUP by a.product_name
ORDER BY 2 desc;
-----------------------------------------------------------------------------
---------- 7번 문제 ---------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
시작시간 :  2023-03-31 15:28:08
종료시간 :  2023-03-31 15:59:31
SELECT  substr(comdate,0,6) as 매출월,
        sum(case when comname = 'SPECIAL_SET' then comsales else 0 end ) as SPECIAL_SET,
        sum(case when comname = 'PASTA' then comsales else 0 end ) as PASTA,
        sum(case when comname = 'PIZZA' then comsales else 0 end ) as PIZZA,
        sum(case when comname = 'SEA_FOOD' then comsales else 0 end ) as SEA_FOOD,
        sum(case when comname = 'STEAK' then comsales else 0 end ) as STEAK,
        sum(case when comname = 'SALAD_BAR' then comsales else 0 end ) as SALA_BAR,
        sum(case when comname = 'SALAD' then comsales else 0 end ) as SALAD,
        sum(case when comname = 'SANDWICH' then comsales else 0 end ) as SANDWICH,
        sum(case when comname = 'WINE' then comsales else 0 end ) as WINE,
        sum(case when comname = 'JUICE' then comsales else 0 end ) as JUICE
FROM
    (select  re.reserv_date comdate ,it.product_name comname,oi.sales comsales
    from order_info oi 
    inner join item it 
    using(item_id)
    inner join reservation re
    using(reserv_no)
    ) combine
group by substr(comdate,0,6)
order by 1;
--풀이-
--필요 테이블 1
SELECT  reserv_date,
        reserv_no
FROM reservation;
--필요 테이블 2
SELECT  reserv_no,
        item_id,
        sales
FROM order_info;
--inner join
SELECT  SUBSTR(a.reserv_date,1,6) as 매출월,
        SUM(DECODE(b.item_id,'M0001',b.sales,0)) AS SPECIAL_SET,
        SUM(DECODE(b.item_id,'M0002',b.sales,0)) AS PASTA,
        SUM(DECODE(b.item_id,'M0003',b.sales,0)) AS PIZZA,
        SUM(DECODE(b.item_id,'M0004',b.sales,0)) AS SEA_FOOD,
        SUM(DECODE(b.item_id,'M0005',b.sales,0)) AS STEAK,
        SUM(DECODE(b.item_id,'M0006',b.sales,0)) AS SALAD_BAR,
        SUM(DECODE(b.item_id,'M0007',b.sales,0)) AS SALAD,
        SUM(DECODE(b.item_id,'M0008',b.sales,0)) AS SANDWICH,
        SUM(DECODE(b.item_id,'M0009',b.sales,0)) AS WINE,
        SUM(DECODE(b.item_id,'M0010',b.sales,0)) AS JUICE
FROM reservation a inner join order_info b 
                   ON(a.reserv_no = b.reserv_no)
GROUP BY SUBSTR(a.reserv_date,1,6)
ORDER BY 1;
----------------------------------------------------------------------------
---------- 8번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
시작시간 : 2023-03-31 16:07:10
종료시간 : 2023-03-31 16:17:22

SELECT  substr(comdate,0,6) as 매출월,
        sum(case when comday = '일요일' then comsales else 0 end ) as 일요일,
        sum(case when comday = '월요일' then comsales else 0 end ) as 월요일,
        sum(case when comday = '화요일' then comsales else 0 end ) as 화요일,
        sum(case when comday = '수요일' then comsales else 0 end ) as 수요일,
        sum(case when comday = '목요일' then comsales else 0 end ) as 목요일,
        sum(case when comday = '금요일' then comsales else 0 end ) as 금요일,
        sum(case when comday = '토요일' then comsales else 0 end ) as 토요일
FROM
    (select  to_char(to_date(re.reserv_date),'DAY') comday,re.reserv_date comdate ,it.product_desc comdesc,oi.sales comsales
    from order_info oi 
    inner join item it 
    using(item_id)
    inner join reservation re
    using(reserv_no)
    where it.product_desc = '온라인_전용상품'
    ) combine
group by substr(comdate,0,6)
order by 1;
--풀이
SELECT  월,
        product_name,
        SUM(DECODE(요일,'1',sales,0)) as 일요일,
        SUM(DECODE(요일,'2',sales,0)) as 월요일,
        SUM(DECODE(요일,'3',sales,0)) as 화요일,
        SUM(DECODE(요일,'4',sales,0)) as 수요일,
        SUM(DECODE(요일,'5',sales,0)) as 목요일,
        SUM(DECODE(요일,'6',sales,0)) as 금요일,
        SUM(DECODE(요일,'7',sales,0)) as 토요일
FROM(
    SELECT  SUBSTR(a.reserv_date,1,6) 월,
            TO_CHAR(TO_DATE(a.reserv_date),'d') as 요일,
            c.product_name,
            b.sales
    FROM reservation a inner join order_info b 
         ON(a.reserv_no = b.reserv_no) INNER JOIN item c 
         ON(b.item_id = c.item_id)
    WHERE c.product_desc = '온라인_전용상품'
)
GROUP BY 월,product_name
ORDER BY 2;
----------------------------------------------------------------------------
---------- 9번 문제 ----------------------------------------------------
-- 고객수, 남자인원수, 여자인원수, 평균나이, 평균거래기간(월기준)을 구하시오 
-- (성별 NULL 제외, 생일 NULL  제외, MONTHS_BETWEEN, AVG, ROUND 사용(소수점 1자리 까지) 나이계산 
시작시간 : 2023-03-31 16:21:45
종료시간 : 2023-03-31 16:55:46
select  count(*) as 고객수, 
        sum(case when sex_code = 'M' then 1 else 0 end) as 남자인원수,
        sum(case when sex_code = 'F' then 1 else 0 end) as 여자인원수,
        round(avg(sysdate-to_date(birth,'YYYYMMDD'))/365,1) as 평균나이,
        round(avg(sysdate-first_reg_date)/365,1) as 평균거래기간
from customer where sex_code is not null and birth is not null;
--풀이
SELECT  COUNT(*) as 고객수,
        SUM(DECODE(sex_code,'M',1,0)) 남자,
        SUM(DECODE(sex_code,'F',1,0)) 여자,
        ROUND(AVG(MONTHS_BETWEEN(sysdate,TO_DATE(birth,'YYYYMMDD'))/12),1) as 평균거래,
        ROUND(AVG(MONTHS_BETWEEN(sysdate,first_reg_date)),1) as 평균거래
FROM customer
WHERE birth IS NOT NULL
AND sex_code IS NOT NULL;

---------------------------------------------------
---------- 10번 문제 ----------------------------------------------------
--매출이력이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
시작시간 : 2023-03-31 16:56:20
종료시간 : 2023-03-31 17:05:18
select address_detail as "고객의 주소",zip_code 우편번호,count(distinct customer_id ) as 고객수
from address inner join customer using (zip_code) 
inner join reservation using(customer_id) 
inner join order_info using(reserv_no)
group by address_detail,zip_code
order by 3 desc;

--풀이
--필요 테이블1
SELECT *
FROM customer;
--필요 테이블 2
SELECT *
FROM order_info;
--필요 테이블 3
SELECT *
FROM reservation;
--결합
    SELECT  b.address_detail,
            COUNT(*) as 고객수
    FROM(SELECT DISTINCT a.customer_id,a.zip_code
            FROM customer a inner join reservation b
            ON(a.customer_id = b.customer_id) inner join order_info c
            ON(b.reserv_no=c.reserv_no)
            GROUP BY a.customer_id,a.zip_code) a, 
            address b
    WHERE a.zip_code = b.zip_code
    GROUP BY b.address_detail,a.zip_code
    ORDER BY 2 DESC;
----------------------------------------------------------------------------

SELECT  LENGTH('339') - LENGTH(REPLACE('339','3','')),
        LENGTH('339') - LENGTH(REPLACE('339','6','')),
        LENGTH('339') - LENGTH(REPLACE('339','9',''))
FROM DUAL;

/**
1. 고객 이름으로 고객 기본정보 조회하는 SELECT 문 이름은 LIKE 검색
2. 고객의 ID로 고객의 예약 및 구매 이력을 조회하는 SELECT 문
*/
--1
SELECT  ROWNUM as NO,a.*
FROM(
    SELECT cus.customer_id as 고객ID,
            cus.customer_name as 고객명,
            cus.email as EMAIL,
            ad.address_detail as 주소
    FROM address ad INNER JOIN customer cus
        ON(ad.zip_code = cus.zip_code)
    WHERE customer_name LIKE '%'||:고객명||'%'
    ORDER BY 1
    )a
;

--2

SELECT *
FROM(
    SELECT cus.customer_id,
            cus.customer_name,
            res.reserv_date,
            res.cancel,
            it.product_name,
            ori.quantity,
            ori.sales
    FROM customer cus
        INNER JOIN reservation res
        ON(cus.customer_id = res.customer_id)
        INNER JOIN order_info ori
        ON(res.reserv_no = ori.reserv_no)
        INNER JOIN item it
        ON(ori.item_id = it.item_id)
    WHERE customer_name LIKE :고객명
    ORDER BY customer_name
    );
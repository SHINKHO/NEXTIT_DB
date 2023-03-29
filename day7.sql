--min(table) : table 의 최솟값을 구함
--max(table) : table 의 최대값을 구함
--avg(table) : table 의 평균값을 구함



--회원의 직업별 회원수,
--마일리지의 평균(소수점 2째자리까지 , 최소,최대값을 출력하시오.
select  mem_job as 직업, 
    count(*) as 회원수,
    round(avg(mem_mileage),2) as 평균,
    max(mem_mileage) as 최대값,
    min(mem_mileage) as 최소값
from member
group by mem_job
order by 2 desc
;

-- 직업의 마일리지 평균이 가장 큰 직업의
-- 마일리지의 평균(소수점 2번째 자리까지), 최소 ,최대값을 출력하시오.

select *
from(   select  mem_job as 직업, 
            count(*) as 회원수,
            round(avg(mem_mileage),2) as 평균,
            max(mem_mileage) as 최대값,
            min(mem_mileage) as 최소값
        from member
        group by mem_job
        order by 3 desc
    ) a
where rownum <= 1 --rownum 번호 매기기 ( 정렬 전에 값이 매겨짐으로 인라인뷰로 감싸야 한다)
;

-- 마일리지가 가장 큰 회원의 정보를 출력하시오
select mem_id,
    mem_name,
    mem_mail,
    mem_mileage,
    mem_add1
from ( select * 
        from member
        order by mem_mileage
     )
where rownum <=1;

--회원중 생일의 요일 중 (ex 금요일) 가장 많은 요일 생일인 회원들의 정보를 출력하시오
select mem_name, mem_bir,to_char(mem_bir,'day')     --추출된 최대값과 동일한 값의 멤버 정보 취득
from member
where to_char(mem_bir,'d') =
( 
    select 요일                                   -- 요일 컬럼 분리하여 최대 빈도 요일 도출
    from 
        (
            select to_char(mem_bir,'d') as 요일,  --요일별로 군집
                    count(*)
            from member 
            group by to_char(mem_bir,'d')
            order by 2 desc
        ) a
    where rownum <=1
);

--회원의 구매이력 (카트이용횟수)를 출력하시오 (횟수 : 내림차순) 
--(구매이력이 있는 회원대상)
select * from cart;

select mem_name as 멤버이름
        ,mem_id as 멤버아이디,
        count(distinct cart_no) as 카트이용수
from member m ,cart c 
where m.mem_id = c.cart_member
group by mem_id,mem_name
order by 3 desc
;

--판매가된 상품의 '판매건수' 와 상위 10건을 출력하시오
--cart,prod
select *
from    (
        select 
            p.prod_id,
            p.prod_name,
            sum(cart_qty)
        from 
            cart c ,
            prod p
        where 
            c.cart_prod=p.prod_id 
        group by 
            p.prod_id,
            p.prod_name
        order by 3 desc, 2 asc
        )
where 
    rownum<=10
;
-- semi join  : <not> exist 

--수강내역 테이블 내에서 
--경우만 학생 테이블에서 조회 
select * from 학생 where exists( select 1 --<-- select 절 내용은 의미없음
                                from 수강내역
                                where 학번 = 학생.학번);
-- 수강내역테이블에 존재하지 않는 건만 학생테이블에서 조회
--
                                
select * from 학생 where not exists( select * --<-- select 절 내용은 의미없음
                                from 수강내역
                                where 학번 = 학생.학번);
                                
-- employees 테이블에 부서아이디가 사용되지 않는 departments 테이블 정보를 조회하시오
select 
    * 
from 
    departments a 
where not exists
                ( 
                    select
                            *
                    from    
                            employees b
                    where 
                            b.department_id = a.department_id
)
;
-- IN 을 사용하여 위 부서아이디가 사용되는 부서정보 출력
select*
from  departments a
where a.department_id IN ( Select distinct department_id
                            from employees b);
                            
-- 피해야할 join  cartesian join
select count(*) from member a , cart b, prod c;
select count(*) from member a , cart b, prod c where a.mem_id = b.cart_member(+) and b.cart_prod = c.prod_id(+);
select count(*) from member a , cart b, prod c where a.mem_id = b.cart_member and b.cart_prod = c.prod_id;

--구매이력이 없는 회원
select *
from member a
where not exists ( select *
                    from cart
                    where cart_member = a.mem_id);
                    
--직업중 회원이 가장 많은 직업의 최다 구매 상품(수량)을 출력하시오
/*
select prod_id , prod_name
from prod
where prod_id 
IN(
    select cp 
        from(select cart_prod cp ,sum(cart_qty) scq
            from cart
            where cart_member in (
                    select mem_id
                    from member
                    where mem_job IN (    
                            select jobName
                            from (  select  mem_job jobName,
                                            count(mem_id) numOfId
                                    from    member m
                                    group by mem_job
                                    order by 2 desc
                                    )
                            where rownum <=1
                        )
                    )
            group by cart_prod
            order by 2 desc
            )
        where rownum <=1
    )group by CART_PROD
;*/
select * from
(
    select cart_prod , sum(cart_QTY), prod_name from cart c, member m,prod p
    where c.cart_member = m.mem_id and c.cart_prod = p.prod_id
            and mem_job IN (
                select jobName
                from (  select  mem_job jobName,
                                count(mem_id)
                        from    member
                        group by mem_job
                        order by 2 desc
                        )
                where rownum <=1
            )
    group by cart_prod,prod_name
    order by 2 desc   
)
where rownum <=1
;


 ---  이탈리아의 2000 년평균  , 이탈리아의 2000년도의 월평균 둘을 비교해서 년평균보다 더 높은 2000년도의 년평균을 구하라  
-- 2000년 이탈리아 평균 매출액(연평균)
-- 보다 큰 (월평균) 매출액(amount-sold)을 구하시오
-- sales , customers ,countries
-- 검색조건  : 'Italy' and 2000년도(sales_month)

--    select NVL(sales_month,'average in year'),round(avg(amount_sold))
--    from 
--            sales,customers,countries 
--    where   
--            countries.country_id = customers.country_id
--            and 
--            sales.cust_id = customers.cust_id
--            and
--            country_name = 'Italy'
--            and
--            substr(sales_month,0,4) = '2000'
--    group by rollup(sales_month);
    
    select sales_month,round(avg(amount_sold))
    from 
            sales,customers,countries 
    where   
            countries.country_id = customers.country_id
            and 
            sales.cust_id = customers.cust_id
            and
            country_name = 'Italy'
            and
            substr(sales_month,0,4) = '2000'
    group by rollup(sales_month)
    having round(avg(amount_sold)) > ((select round(avg(amount_sold))
            from sales , customers
            where sales.cust_id = customers.cust_id
            and customers.country_id = (select country_id 
                                        from countries 
                                        where country_name = 'Italy')
            and sales_month >'200000'
            and sales_month <'200100'
            group by substr(sales_month,0,4)
            ))
    ;
--    
--    select substr(sales_month,0,4),round(avg(amount_sold))
--    from sales , customers
--    where sales.cust_id = customers.cust_id
--    and customers.country_id = (select country_id 
--                                from countries 
--                                where country_name = 'Italy')
--    and sales_month >'200000'
--    and sales_month <'200100'
--    group by substr(sales_month,0,4)
--    ;
    

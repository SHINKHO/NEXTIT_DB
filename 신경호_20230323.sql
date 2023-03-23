--employee 테이블 
--직원의 고용년도별 사원수, 총급여를 출력하시오
-- 정렬조건 (직원수 내림차순)
select substr(hire_date,0,2) as 고용년도,
       COUNT(*) as 직원수 ,
       SUM(salary) as 총급여
from employees
group by substr(hire_date,0,2)
order by 2 desc
;

--3월에 입사한 직원의 수 출력 
select count(*) as "3월에 입사한 직원수"
from employees
where to_char(hire_date,'MM') = 03;

-- customers 테이블에서 
-- cust_marital_status 별 고객수를 출력하시오
-- cust_marital_status 널 제외
select cust_marital_status,
       count(*) as 고객수
from customers
group by cust_marital_status
having cust_marital_status IS NOT NULL
order by 2 desc
;

--products를 활용하여 카테고리, 서브카테고리별 상품수를 출력하시오
--상품수 3개 이상만 출력 
select prod_category as 카테고리,
       prod_subcategory as 서브카테고리,
       count(*) as 상품수
from products
group by prod_category, prod_subcategory
having count(*) >=3
order by 1 asc
;
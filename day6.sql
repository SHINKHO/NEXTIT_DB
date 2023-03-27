/*
    동등조인(EQUI-JOIN) == 내부조인 (INNER JOIN)
    WHERE 절에 = 등호 연산자 사용
    A= B 공통된 값을 가진 행이 연결
*/
select *
from 학생 a
    ,수강내역 b
where a.학번=b.학번;

/*만약 수강내역이 없는 학생도 조회 되어야 한다면 
  외부조인 사용(outer join)
  널값을 포함시킬 쪽에 (+)
*/
select *
from 학생 a
    ,수강내역 b
where a.학번=b.학번(+) -- 플러스 기호는 한쪽에만 쓸수있다
and a.이름 = '양지운';

select count(*)
from 학생 a, 수강내역 b; -- 이 경우 테이블끼리의 곱이 되어 나온다(cartesian join = cross join)

/* sub query
    sql 문장 안에 보조로 사용되는 또는 또 다른 select 문
    형태에 따라
    1. 일반 서브쿼리( 스칼라 서브쿼리) : select 절
    2. 인라인 뷰                   : from 절
    3. 중첩 쿼리                   : where 절 
*/

-- (1)select 절 : 1대 1 매핑 , 중복시 에러
--  값 자체가 필요할떄 사용. 테이블 사이즈가 클시 부하가 큼 = 조인을 이용하여 부하를 줄임.
SELECT a.emp_name 
    ,  a.department_id
    ,  (SELECT department_name
        FROM departments
        WHERE department_id = a.department_id ) as dep_nm
    ,   a.job_id
    ,   (select job_title
        from jobs
        where a.job_id = jobs.job_id) as job_id
FROM employees a
order by 2;
 -- 아래는 위 서브쿼리를 아우터조인으로 구현한 것
SELECT a.emp_name
    ,  b.department_id
    ,  b.department_name
    ,  a.job_id
    from departments b, employees a , jobs c
    where a.department_id = b.department_id(+)
    and a.job_id = c.job_id(+);

SELECT ( SELECT emp_name 
         from employees
         where departent_id = a.department_id) as emp_name
from departments a;
-- 스칼라 서브쿼리는 1=1 매핑이어야 함. 1-m 면 오류 발생 

SELECT a.이름
    ,  b.수강내역번호
    ,   b.과목번호
    ,  (select 과목.과목이름 
        from 과목
        where 과목.과목번호 = b.과목번호) as 과목명
        
FROM 학생 a
,    수강내역 b
 WHERE a.학번 = b.학번
 AND a. 이름 = '최숙경'; -- 과목번호를 사용하여 과목 이름을 출력하시오
 
--의사 컬럼 ROWNUM
--테이블에는 없지만 있는것 처럼 사용 할 수 있는
SELECT ROWNUM as rnum
        ,a.*
from employees;
--ORDER BY emp_name desc; -- ** 주의점 : order by 순서 이전에 ROWNUM이 정의되어서 순서가 맞지 않게 넘버링이 될 수 있음 
-- inline 뷰 활용으로 극복 

-- (2) 인라인뷰 ( from 절에 사용 select 문의 결과를 테이블 처럼 사용)
select *
from ( select rownum as rnum
                    ,a.*
       from employees a ) b
where b.rnum between 11 and 20;--between i and j는 i~j까지

--정렬을 하려면 인라인뷰를 여러번 겹쳐써야 한다.
select *
from(
    select rownum as rnum
        ,  a.*
    from (select *
          from employees
          where department_id = 50
          order by emp_name
          ) a
    )c
where c.rnum between 11 and 20;
    
--학생 평점이 높은 가장 높은 학생을 출력하시오
select *
from 
    (
        select *
        from 학생
        order by 평점 DESC -- 평점기준 내림차순 정렬 
    )
where rownum <=1;
--학생 평점이 2번째로 높은 핛생부터 4번째 학생까지 출력하시오
select rnum,이름, 평점
    from(
        select rownum as rnum
            ,   a.*
        from(
                select * 
                from 학생
                order by 평점 desc
            ) a
        )
where rnum between 2 and 4;

--(3) where 절 
SELECT *
FROM 학생
WHERE 평점 >= (SELECT AVG(평점) 
              from 학생);
-- 수강내역이 있는 학생을 조회하시오
SELECT 이름
FROM 학생
WHERE 학번 IN ( SELECT 학번
           FROM 수강내역) ;
-- 수강내역이 없는 학생을 조회하시오
SELECT 이름
FROM 학생
WHERE 학번 NOT IN ( SELECT 학번
           FROM 수강내역) ;
           
--직원의 평균 salary 보다 많이 받는 사원의 수를 출력하시오
SELECT count(emp_name)
FROM   employees
where  salary >= (select 
                  AVG(salary) 
                  from employees)
;

--직원의 년도별 요일별 입사 인원수를 출력하시오
--      월 화 수 목 금 토 일
-- 1998 0  1 0  1  1  1  5
-- 1999
-- 2000 2 1 10 .....

---- ex ) 1. hire_date 를 활용하여 년도 구하기
--        2. hire_date를 활용하여 요일 구하기
--        3. 각 요일만 포함되도록 요일컬럼 만들기( ex decode)
--        4. 3번까지 구한 결과를 가지고 집계 하기 (인라인 뷰 사용하면 편함)

select ( select count(*) from employees where to_char(hire_date,'d')=1) as 일요일,
( select count(*) from employees where to_char(hire_date,'d')=2) as 월요일,
( select count(*) from employees where to_char(hire_date,'d')=3) as 화요일,
( select count(*) from employees where to_char(hire_date,'d')=4) as 수요일,
( select count(*) from employees where to_char(hire_date,'d')=5) as 목요일,
( select count(*) from employees where to_char(hire_date,'d')=6) as 금요일,
( select count(*) from employees where to_char(hire_date,'d')=7) as 토요일
from dual;

--1)
select NVL(년도,'합계') as 년도
    , SUM(일요일) as 일요일
    , SUM(월요일) as 월요일
    , SUM(화요일) as 화요일
    , SUM(수요일) as 수요일
    , SUM(목요일) as 목요일
    , SUM(금요일) as 금요일
    , SUM(토요일) as 토요일
    , count(*)   as 년도합계
from(
    select to_char(hire_date,'YYYY') as 년도,
           DECODE(to_char(hire_date,'d'),'1','1',0) as 일요일, -- 1(일요일의 'd' 형) 일경우 1을 표에 넣고 아닐경우 0을 넣는다(SUM 용)
           DECODE(to_char(hire_date,'d'),'2','1',0) as 월요일,
           DECODE(to_char(hire_date,'d'),'3','1',0) as 화요일,
           DECODE(to_char(hire_date,'d'),'4','1',0) as 수요일,
           DECODE(to_char(hire_date,'d'),'5','1',0) as 목요일,
           DECODE(to_char(hire_date,'d'),'6','1',0) as 금요일,
           DECODE(to_char(hire_date,'d'),'7','1',0) as 토요일
    from employees
    )
group by rollup(년도)
order by 1
;

select * from kor_loan_status;

--kor_loan_status 테이블을 활용하여 년도별 기타대출 주택담보대출 
--년도별 기타대출 주택담보대출 년도합계를 출력하시오

    select  NVL(년도,'합계') as 년도,
            sum(case when 구분 = '주택담보대출' then 액수 end ) as 주택담보대출, -- sum (decode (구분 , '주택담보대출' ,액수)) 
            sum(case when 구분 = '기타대출'   then 액수 end ) as 기타대출 , -- sum(decode ( 구분 , '기타' ,액수 ))
            sum(액수) as 년도합계 
        from(
        select substr(period,1,4) as 년도
              ,gubun as 구분
              ,loan_jan_amt as 액수
        from kor_loan_status
        )
        group by rollup(년도);
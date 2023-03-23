/*
    member 테이블에서 대전,서구에 사는 회원의 정보를 출력하시오
    아이디, 이름 이메일,주소,성별 ( 1남자, 2여자)
*/
select mem_id,
    mem_name,
    mem_mail,
    mem_add1,
    case when SUBSTR(mem_regno2,1,1) IN ('1','3') THEN '남자'
         when SUBSTR(mem_regno2,1,1) IN ('2','4') THEN '여자'
         end as "gender"
from member
where mem_add1 LIKE '%대전%'
AND   mem_add1 LIKE '%서구%'
;

/*숫자함수*/
select round(10.5904, 2),--반올림
       round(10.5904, 1),
       round(10.5904, -1),
       TRUNC(10.5904, 2),--버림
       MOD(4,2), --나머지 반환
       MOD(5,2) 
FROM dual;

/*날짜함수*/
select SYSDATE, --현재시간
       SYSTIMESTAMP,
       SYSDATE+1 --날짜 데이터 + 1 <-- 다음날의 날짜 데이터
from dual;
-- ADD_MONTHS, LAST_DAY
select add_months(sysdate,1), -- 다음날 날짜 반환
      add_months(sysdate,-1), -- 전달 날짜 반환
      last_day(sysdate) -- 해당월의 마지막 날자 반환
from dual;
--이번달이 몇일 남았는지 출력하시오
select last_day(sysdate) - sysdate from dual;

--날짜데이터에 round 를 스면 시분초가 반올림되어 적용된다.
select mem_name, mem_bir, SYSDATE-mem_bir, round(SYSDATE) from member;
select mem_name, mem_bir, SYSDATE-mem_bir, round((sysdate-mem_bir)/365) as "나이" from member;
-- 시분초 이외에 반올림, 버림 하고 싶을 경우.
select round(sysdate, 'month'), -- 월 전 까지 반올림
       round(sysdate, 'year' ), -- 년 전 까지 반올림
       trunc(sysdate, 'month'), -- 월 전 까지 버림
       trunc(sysdate, 'year' )  -- 년 전 까지 버림
from dual;
/*변환함수 TO_CHAR      문자형으로 
          TO_NUMBER    숫자타입으로
          TO_DATE      날짜타입으로 타입변환
*/
select to_char (123456789, '999,999,999')
,      to_char (sysdate, 'YYYY-MM-DD')
,      to_char (sysdate, 'YYYY MM DD')
,      to_char (sysdate, 'YYYY')
,      to_char (sysdate, 'YYYYMMDD HH24:MI:SS')
,      to_char (sysdate, 'YYYYMMDD AM HH12:MI:SS')
from dual;

select to_date('2022*01*01','YYYY*MM*DD') from dual; -- 이 경우 원본값에 시분초가 없어서 날짜값으로 변환 하더라도 시분초가 비어있다(0이0분)
create table ex4_1(
    col1 varchar2(1000)
);
insert into ex4_1 values('111');
insert into ex4_1 values('99');
insert into ex4_1 values('1111');
select *
from ex4_1
order by col1 desc; -- 이경우 유니코드에서 상대적으로 큰 값을 지니는 9가 맨 앞에 있는 99 가 1111보다 앞에 크다고 나온다.

/* to number로 숫자형 변화가 필요함 
*/
select *
from ex4_1
order by to_number(col1) desc;

--데이계산
create table tb_myday(
    mem_id varchar2(100),
    d_title varchar2(1000),
    d_day varchar2(8)
);
insert into tb_myday values('a001','연인이 된날','20170815');
insert into tb_myday values('a001','과정 시작일','20230320');
-- 1.a001 회원의 과정 시작일로부터 100일의 날짜
-- 2.1번의 결과(100일) 일자까지 몇일 남았는지
-- 3. 과정시작일 부터 몇일이 지났는지 출력하시오( 네이버 dday기준 : 오늘날을 포함함)

select to_date(d_day,'YYYYMMDD')+99 from tb_myday where d_title like '%과정%'; -- 23/06/27
select (to_date(d_day)+99) - round(sysdate) from tb_myday where d_title like '%과정%'; --95
select round(sysdate) - to_date(d_day) from tb_myday where d_title like '%과정%'; --4 

SELECT to_char(to_date(d_day)+99, 'YYYY.MM.DD') as 백일
    ,  to_date(d_day)+99 - round(SYSDATE) as 남은날
    ,  round(sysdate) - to_date(d_day) as 지난날
from tb_myday
where mem_id = 'a001'
and d_title like '%과정%';

/*NULL 관련 함수 NVL( a,b ): a의 값이 null 일경우 b 로 
    연산시 특정 항에 값을 할당 받지 않아 NULL인 상태로 배치되어 있는 경우가 있음
    결과값을 NULL 로 전염시키는 문제가 있기 때문에 NVL로 0으로 만들어 대처함.
*/
select emp_name,
       salary,
       commission_pct,
       NVL(commission_pct,0),
       salary + salary * NVL(commission_pct,0) as 이번상여금
    FROM employees;

/* 집계함수 AVG,MIN,MAX,SUM,COUNT */
SELECT COUNT(*),                     -- null 포함한 전체 행 조회
       COUNT(department_id),         -- default all
       COUNT(ALL department_id),     -- null 제외, 중복 포함한 해당 테이블의 행 조회 
       COUNT(DISTINCT department_id) -- 중복 제외
FROM employees;

SELECT SUM(salary),
       ROUND(AVG(salary),2),
       MIN(salary),
       MAX(salary)
FROM employees;

--member 테이블을 활용항 ㅕ회원의 수오 ㅏ평균 마일리지르 출력하시오
select COUNT( DISTINCT mem_id), COUNT(*), -- mem_id는 prime key 이기 때문에 중복이나 널값이 발생할 수 가 없다. 그래서 *와 같은 결과가 나옴
       round(avg(mem_mileage),2)
from member;

/*GROUP BY , HAVING*/
select department_id,
       count(*) as 사원수
from employees 
where department_id IS NOT NULL --널이 아닌 != 는 쓰면 안됨.
group by department_id -- 부서별
having count(*) >=5 --집계결과에서 검색조건 
order by 1;

--from        (테이블에서 전체값 스캔) 
-->> where    (조건 필터 거침) 
-->> group by (표시할 군집화 걸침) 군집화 조건이 2개 이상일 경우 두 조건값이 동일한 경우의 군집으로 나뉘어짐.1*
-->> having   (표시할 군집화 후의 집계결과 조건필터 걸침) 
-->> select   (모두 걸러진 값 중 출력할 부분 선택) 
-->> order    (정렬)
--*1 . 예를 들어 학생 A, 학생 B 가 있을 경우 '학생' 으로 군집화하여 학생수를 출력한다면 학생 두명이  되겠지만
-- 학생 A 와 학생 B 가 있을 경우 '학생' ,'이름' 으로 학생수를 군집화하여 학생 A 한명 학생 B 한명이 된다.

select department_id        -- 집계함수를 제외한
,      job_id               -- select표시 컬럼은
,      COUNT(*) as 사원수    -- group by 절에 포함되어야함
FROM employees
GROUP BY department_id
,        job_id
ORDER BY 1;

-- member 회원의 직업별 회원수와, 평균 마일리지를 출력하시오 (소수점 2째자리, 평마일 내림차순, 회원수 3명이상)
select MEM_JOB,
       count(*) as 회원수,
       round(avg(MEM_MILEAGE),2) as 평마
from member
group by MEM_JOB
having count(MEM_JOB) >=3
order by 3 desc
;

--년도별 대출합계
select   SUBSTR(period,1,4) as 년도 
,        SUM(loan_jan_amt) as 대출합계 
from     kor_loan_status 
group by SUBSTR(period,1,4) 
order by 1;

--2013년도 지역별 대출 합계 
select  region
,       SUM(loan_jan_amt)
from    kor_loan_status
where period like '2013%'
group by region;

--employee 테이블 
--직원의 고용년도별 사원수, 총급여를 출력하시오
-- 정렬조건 (직원수 내림차순)
select substr(hire_date,0,2) as 고용년도,
       COUNT(*) as 직원수 ,
       SUM(salary) as 총급여
from employees
group by substr(hire_date,0,2)
order by 3 desc
;


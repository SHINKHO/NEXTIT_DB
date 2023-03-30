SELECT  department_id, 
        parent_id,
        LPAD(' ',3*(LEVEL-1)) || department_name as 부서명, 
        LEVEL as 레벨
-- 가상열 트리 내에서 어떤 단계(level)에 있는지 나타내는 정수값
FROM departments
START WITH parent_id is NULL
CONNECT BY PRIOR department_id=parent_id;

-- 부서테이블에 department_id : 280
--                    부서명 : DB팀
--                  상위부서 : IT헬프데스크
--                      데이터를 삽입하고 출력하시오

INSERT INTO 
        departments
        (   department_id,
            parent_id,
            department_name
        ) 
VALUES
        (
            280,
            (
                select 
                    department_id 
                from 
                    departments 
                where 
                    department_name 
                in 
                    'IT 헬프데스크' 
            ),
            'DB팀'
        );

commit;

select 
        department_id,
        department_name as 부서명,
        parent_id as 상위부서 
from 
        departments 
where   
        department_id = 280;
        
--manager id 와 employee_id를 활용하여
--직원의 계층관계를 출력하시오 
-- 최상위 지원은 Steven King
SELECT  employee_id
,       LPAD(' ' ,3*(level-1)) || emp_name as 사원이름
,       manager_id
,       job_id
,       CONNECT_BY_ISLEAF as leaf -- 마지막 노드면 1, 자식이 있으면 0
,       SYS_CONNECT_BY_PATH(emp_name,'<') as depth --루트 노드에서 현재 노드까지
FROM employees a
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY a.emp_name -- 계층형 트리가 깨지지 않고 정렬하기 위해 ORDER SIBLINGS BY 를 넣어 줘야함.
;
/*  테이블을 생성하고 
    데이터를 입력하여
    아래와 같이 출력하도록 계층형 쿼리를 만들어 출력하세요.
    
    이름      직책      레벨      
    이사장    사장       1      head01-
    김부장     부장      2       body01-
    서차장      차장     3       body02
    장과장       과장    4       body03
    이대리        대리   5       tail01
    박과장       과장    4       body04
    김대리        대리   5       tail02
    강사원         사원  6       tail03
*/
CREATE TABLE ex_company (
    excom_id VARCHAR2(100) PRIMARY KEY,
    excom_manager_id VARCHAR2(100),
    excom_rank VARCHAR2(100) NOT NULL,
    excom_name VARCHAR2(100) NOT NULL 
);
commit;
drop table ex_company;

insert into
ex_company(excom_id,excom_manager_id,excom_rank,excom_name)
values('HEAD01',null,'사장','이사장');
insert into
ex_company(excom_id,excom_manager_id,excom_rank,excom_name)
values('BODY01','HEAD01','부장','김부장');
insert into
ex_company(excom_id,excom_manager_id,excom_rank,excom_name)
values('BODY02','BODY01','차장','서차장');
insert into
ex_company(excom_id,excom_manager_id,excom_rank,excom_name)
values('BODY03','BODY02','과장','장과장');
insert into
ex_company(excom_id,excom_manager_id,excom_rank,excom_name)
values('BODY04','BODY02','과장','박과장');
insert into
ex_company(excom_id,excom_manager_id,excom_rank,excom_name)
values('TAIL02','BODY04','대리','김대리');
insert into
ex_company(excom_id,excom_manager_id,excom_rank,excom_name)
values('TAIL03','TAIL02','사원','강사원');
insert into
ex_company(excom_id,excom_manager_id,excom_rank,excom_name)
values('TAIL01','BODY03','대리','이대리');


SELECT  excom_name 이름,
        LPAD(' ',3*(LEVEL-1)) || excom_rank as 직위, 
        LEVEL as 레벨
-- 가상열 트리 내에서 어떤 단계(level)에 있는지 나타내는 정수값
FROM ex_company
START WITH excom_manager_id is NULL
CONNECT BY PRIOR excom_id=excom_manager_id;

--주의할점 참조가 무한루프에 빠질 수 있다.
-- CONNECT_BY_ISCYCLE 라는 함수 로 루프 도는 행을 찾을 수 있다.

--데이터 생성용으로도 사용할 수 있다.
--ex) 통계 쿼리에서 월 열을 추가해야 할때
 SELECT TO_CHAR(SYSDATE,'YYYY')|| LPAD(LEVEL,2,'0')
 FROM dual
 connect by level <=12;
 --위 select 문은 날짜를 리턴해줌
 SELECT period,
        SUM(loan_jan_amt) as amt
 FROM   kor_loan_status
 WHERE  period LIKE '2013%'
 GROUP BY period;
 -- 위 select 문은 period 로 군집화한 2013년의 loan amount 를 리턴해줌
 -- 근데 11월이랑 10월밖에 안나옴
 SELECT a.월,
        NVL(b.amt,0) as amt
 FROM   (
        SELECT '2013'||LPAD(LEVEL,2,'0') as 월
        FROM    dual
        connect by level <= 12) a           -- 201301~ 201312 생성한 년월
        ,(
        SELECT  period,
                SUM(loan_jan_amt) as amt
        FROM    kor_loan_status
        WHERE   period LIKE '2013%'
        GROUP   BY period) b                -- 201310,201311 년월밖에 없다
 WHERE  a.월 = b.period(+)
 order by 월;                 -- 년월에 null 값이 있는 쪽에 outerjoin 을 하여 null을 대입해줌.
 -- 2013년 전부 출력가능
 
 --이번달 1일부터 ~ 마지막날까지 출력하시오
 --월별로 30일 31일 심지어는 2일까지 나뉘니 
 
 --현재 달을 출력해줌
 SELECT TO_CHAR(SYSDATE,'YYYYMMDD')
 from dual;
 
 -- 1.입력한 값에서 YYYYMM형식을 추출하고 (:months -바인드, 'YYYYMM')
 -- 2.date 형식으로 바꾼뒤 TO_DATE(1번의 결과)
 -- 3.마지막날이 포함된 date형식에서 LAST_DAY(2번의 결과)
 -- 4.DD형으로 마지막 날만 추출함 TO_CHAR(3번의 결과,'DD')
 SELECT TO_CHAR(LAST_DAY(TO_DATE(:months,'YYYYMM')),'DD')
    from dual;
 
 --31까지의 일을 출력해줌 
 SELECT LEVEL
 FROM dual
 CONNECT BY LEVEL <=31;
 
 --합치기
 SELECT :months || LPAD(LEVEL,2,'0') as일자
 FROM dual
 CONNECT BY LEVEL <= (
    SELECT TO_CHAR(LAST_DAY(TO_DATE(:months,'YYYYMM')),'DD')
    from dual);
 --1.입력값이 문자열 YYYYMM -> DATE 타입으로 변환
 --2.DATE 타입은 LAST_DAY로 월마지막 날을 구할 수 있음
 --3. 마지막 날짜의 DATE 타입에서 TO_CHAR로 일자만 구하기
 
 --customers 테이블의 cust_year_of_birth을 활용하여
 -- 나이를 구하고 ( 나이계산은 단순하게 올해-탄생년도)
 -- 10대 20대 ~~ 의 인원수를 구하시오
 -- 1. 나이계산, 2. 나이로 10대 20ㄷ ~ 를 구별할 수 있도록 데이터 만들기
 -- 3. 2로 인원수 집계
 -- 4. level 이용하여 10대부터 출력
select ageline || '대' as 년대, 인원수
from
     (select nwn.ageline, 
             nvl(nwd.nums,'0') as 인원수 
     from   
            (select trunc(a.age,-1)as ageline,
                    count(*) as nums
            from
                (select cust_id,
                        TO_CHAR(SYSDATE,'YYYY') - CUST_YEAR_OF_BIRTH age
                from   customers) a
     group by trunc(a.age,-1)
     order by ageline asc) nwd
    ,       
    (select ageline as ageline
    from
        (
        select round(level,-1) as ageline 
        from dual
        CONNECT BY LEVEL <
            (
            select Max(age) 
            from 
                (select cust_id,
                        TO_CHAR(SYSDATE,'YYYY') - CUST_YEAR_OF_BIRTH age
                from   customers
                )
            )
        )
        group by ageline
        having ageline>=10
        ) nwn
    where   nwd.ageline(+) =nwn.ageline
    order by ageline
    )
 -- 결과물
 -- 년대  인원수
 -- 10대     0
 -- 20대     0
 -- 30대  1552
 -- 이하 생략
 
 
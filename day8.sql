/*  VIEW 객체
    "생성법 : CREATE or REPLACE VIEW <스키마> 뷰명 AS SELECT 문장"
    
    단순뷰
        -하나의 테이블로 생성
        -그룹 함수의 사용 불가
        -distinct 불가
        -insert/update/delete 가능
    복합뷰
        -여러개의 테이블로 생성
        -그룹함수 사용가능
        -insert/update/delete 불가능
        
*/
--시스템계정에서 권한을 줘야 뷰를 생성할 수 있음 ( DBA 권한 있는쪽에서 실행)
GRANT CREATE VIEW TO java; --right to CREATE VIEW given TO JAVA.
-- 계정 생성
CREATE USER study IDENTIFIED BY study; 
GRANT RESOURCE , CONNECT TO study; -- right to CONNECT DB AND MODIFY RESOURCE TO STUDY
commit;
--뷰 생성
CREATE OR REPLACE VIEW emp_dep AS
SELECT  a.employee_id
,       a.emp_name
,       b.department_name
FROM    employees a
,       departments b
WHERE   a.department_id = b.department_id;

--java 계정에서 실행, emp_dep 테이블에서 select 할수 있는 권한을 study 계정에게 부여
GRANT SELECT ON emp_dep TO study;

--study에서 테스트 ( 스키마명인 java 로 위치를 명시해야 함)
SELECT *
FROM java.emp_dep;

/*  시노님 synonym '동의어'란 뜻으로 객체 각자의 고유한 이름에 대한 동의어를 만드는 것
    개발 파트와 데이터베이스 조작 파트를 분리하여 DB컬럼 수정과 무관한 개발을 추구한다
    ex) 이미 해당 테이블이 쓰여진 소프트웨어에 테이블명과 테이블 구성을 변경해도 
    해당 테이블명을 코드에 일일히 적지 않고 시노님만 바꿔
    PUBLIC 모든 사용자   PRIVATE 특정 사용자
*/
--DBA 권한 있는쪽에서 시노님 생성 권한 부여
GRANT CREATE SYNONYM TO java;

CREATE OR REPLACE SYNONYM emp_v1
FOR employees;

--public 시노님은 DBA 권한이 있는 쪽에서 생성가능
CREATE OR REPLACE PUBLIC SYNONYM emp_v2
FOR java.employees;
--public 시노님 DBA의 select 권한을 user study 에게 부여
GRANT SELECT ON emp_v2 TO study;
--사용할 수 있는 시노님 확인
select * from USER_SYNONYMS;
--시노님 사용
select * from emp_v2;

--public 시노님은 삭제도 DBA 권한 있는쪽에서
DROP PUBLIC SYNONYM emp_v2;
--private 은 만든쪽에서 삭제 가능
DROP SYNONYM emp_v1;

/*  시퀀스 자동 순번을 반환하는 객체
    한 방향으로만 작동하기 때문에 INCREMENT 문을 수정하느니 삭제하고 다시 만든다.
*/
CREATE SEQUENCE my_seq1
INCREMENT by    1 -- 증강숫자
START WITH      1 -- 시작숫자
MINVALUE        1 -- 최솟값
MAXVALUE        100 -- 최댓값
NOCYCLE           -- 디폴트 : 최대 혹은 최소 도달시 생성 중지, 순환하고 싶으면 cycle 입력
NOCACHE           -- 디폴트 : 디폴트 값을 할당해 놓지 않음.
;
--최소값 1000, 최대값 99999999, 1000부터 시작해서 2씩 증가하는 시퀀스를 만드시오
create sequence my_seq2
increment by        2
start with          1000
minvalue            1000
maxvalue            99999999
nocycle
nocache
;
SELECT my_seq1.NEXTVAL   --다음순번(기존값 증발)
FROM dual;
SELECT my_seq1.CURRVAL   --현재 시퀀스값
FROM dual;

--활용예시 : 1씩 증가하는 시퀀스를 통해 대입
create table ex8_1 (
    col1 number
);

INSERT INTO 
ex8_1 
VALUES(my_seq1.NEXTVAL);

SELECT * 
from ex8_1;

--삭제
DROP SEQUENCE my_seq1;
DROP SEQUENCE my_seq2;

/* ANSI 조인 FROM 절에 조인조건이 들어감 */
-- 일반 조인 
SELECT  a.employee_id
,       b.department_name
FROM    employees a
,       departments b
WHERE   a.department_id = b.department_id;

-- ANSI 조인
SELECT  a.employee_id
,       b.department_name
FROM    employees a INNER JOIN departments b
ON      (a.department_id = b.department_id); 
-- 컬럼명이 같을 경우 using 을 사용 가능하다.
SELECT  a.employee_id
,       b.department_name
,       department_id 
FROM    employees a INNER JOIN departments b
USING   (department_id); -- USING 을 쓰면 테이블 alias 안됨.

--학생 수강내역 과목 테일블 ANSI INNER JOIN 사용하여 '최숙경' 의 학번 수강내역번호 과목명을 출력하시오
SELECT      이름 as nm_stud
,           수강내역번호 as ind
,           과목이름 as nm_sub
FROM        학생  
INNER JOIN  수강내역  
USING       (학번)
INNER JOIN  과목
USING       (과목번호)
where       이름 ='최숙경';

--outer join 일반
SELECT      *
FROM        학생, 수강내역, 과목
WHERE       학생.학번 = 수강내역.학번(+)
AND         수강내역.과목번호 = 과목.과목번호(+);
--ANSI LEFT
SELECT      *
FROM        학생
LEFT OUTER JOIN   수강내역 -- FORMAL EXPRESSION : MARK OUTER 
ON                (학생.학번=수강내역.학번) --USING (학번)
LEFT /*OUTER*/JOIN   과목  -- OUTER 생략가능
ON                (수강내역.과목번호=과목.과목번호); --USING (과목번호);
--ANSI RIGHT
SELECT      count(*)
FROM        수강내역
RIGHT OUTER JOIN 학생
ON(학생.학번 = 수강내역.학번); --USING 학번

CREATE TABLE ex_a(
    emp_id NUMBER
);
CREATE TABLE ex_b (
    emp_id NUMBER
);
--a
INSERT INTO ex_a VALUES(10);
INSERT INTO ex_a VALUES(20);
INSERT INTO ex_a VALUES(40);
--b
INSERT INTO ex_b VALUES(10);
INSERT INTO ex_b VALUES(20);
INSERT INTO ex_b VALUES(30);
commit;
select * 
from ex_a;
select * 
from ex_b;

select *
from ex_a, ex_b
where ex_a.emp_id(+) = ex_b.emp_id(+); -- 에러발생
--ANSI FULL OUTER JOIN 양쪽 널 포함
SELECT  *
FROM    ex_a
FULL OUTER JOIN
        ex_b
ON(ex_a.emp_id = ex_b.emp_id); -- 양쪽 널값 모두 포함

--'년도별' 이태리 최대매출액과 사원을 출력하시오
-- YEARS | EMPLOYEE_ID | EMP_NAME | AMOUNT_SOLD
-- 1998     145          JOHN RUSSEL    312533.58
-- 1999     147     Alberto Errazuriz   193319.44
-- 2000     153     Christopher Olsen   144459.3
-- 2001     173         Sundita Kumar   426018.7

SELECT front.soldyear,front.empId,front.empname,front.soldamount --empname을 스칼라 쿼리로 적용할 수 있다.

FROM (
    SELECT      substr(b.sales_month,0,4) as soldYear
                ,a.emp_name as  empName
                ,a.employee_id as empId
                ,SUM(b.amount_sold) as soldAmount
    FROM        employees a
    INNER JOIN  sales b on(a.employee_id=b.employee_id)
    INNER JOIN  customers  c on (b.cust_id = c.cust_id)
    INNER JOIN  countries  d on(c.country_id = d.country_id)
    WHERE       d.country_name = 'Italy'
    GROUP BY    substr(b.sales_month,0,4),a.emp_name,a.employee_id
    ORDER BY    1
    ) front
INNER JOIN -- join 대신 where (tables) in 을 활용하여  쓸 수 도 있으나 쿼리 실행 두배 가량 느리다.
    (SELECT
            soldYear,max(soldAmount) maxSoldPerEmp
    FROM 
        (
        SELECT      substr(b.sales_month,0,4) as soldYear
                    ,a.emp_name as  empName
                    ,a.employee_id as empId
                    ,SUM(b.amount_sold) as soldAmount
        FROM        employees a
        INNER JOIN  sales b on(a.employee_id=b.employee_id)
        INNER JOIN  customers  c on (b.cust_id = c.cust_id)
        INNER JOIN  countries  d on(c.country_id = d.country_id)
        WHERE       d.country_name = 'Italy'
        GROUP BY    substr(b.sales_month,0,4),a.emp_name,a.employee_id
        ORDER BY    1
        ) 
    group by soldYear
    order by 1 asc
    ) behind
    
ON(front.soldamount = behind.maxSoldPerEmp)
;








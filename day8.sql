/*  VIEW 객체
    "생성법 : CREATE or RPLACE VIEW <스키마> 뷰명 AS SELECT 문장"
    
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

select * from USER_SYNONYMS;

select * from emp_v2;

--public 시노님은 삭제도 DBA 권한 있는쪽에서
DROP PUBLIC SYNONYM emp_v2;
--private 은 만든쪽에서 삭제 가능
DROP SYNONYM emp_v1;

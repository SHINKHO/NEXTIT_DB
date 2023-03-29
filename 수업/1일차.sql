--1일차 주석  
/* 
  주석 공간 
  명령어에 영향을 주지 않음 
*/
-- 테이블 스페이스 생성 
CREATE TABLESPACE myts
DATAFILE '/u01/app/oracle/oradata/XE/myts.dbf'
SIZE 100M AUTOEXTEND ON NEXT 5M;
-- 유저 생성 
CREATE USER java IDENTIFIED BY oracle
DEFAULT TABLESPACE myts
TEMPORARY TABLESPACE temp;
-- 권한 설정  (접속과 기본적인 생성 권한)
GRANT RESOURCE, CONNECT TO java;


SELECT emp_name, department_name
FROM employees
    ,departments
WHERE employees.department_id  = departments.department_id
AND employee_id = 198;

/*  table 테이블 
   1.테이블명 컬럼명으로 예약어는 사용할 수 없다.  (select, from...)
   2.테이블명 컬럼명으로 최대 크기는 30byte
   3.테이블명 컬럼명으로 문자, 숫자, _, $, # 사용할 수 있지만 첫 글자는 문자만 
   4.한 테이블에 사용 가능한 컬럼수는 255개 
*/
-- CREATE TABLE 테이블 생성문 
CREATE TABLE ex1_1(
   col1 CHAR(10)     -- 고정형 크기 
  ,col2 VARCHAR2(10) -- 가변형 
  ,col3 DATE 
);
-- 테이블 삭제 
DROP TABLE ex1_1;














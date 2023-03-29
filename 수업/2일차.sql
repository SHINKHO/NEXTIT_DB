/* SELECT : DML문으로 테이블이나 뷰에 있는 
            데이터를 조회할때 사용 
 실행순서 : FROM -> WHERE -> GROUP BY -> HAVING -> SELECT ->ORDER BY
*/

SELECT *  -- * <--전체를 의미함. 
FROM employees;


SELECT *  -- * <--전체를 의미함. 
FROM employees a; -- 테이블 별칭

-- alias 컬럼 별칭 AS를 붙임  
SELECT emp_name AS nm
     , email    em
     , emp_name "이름"   -- 한글 표시 
FROM employees;

-- 검색조건 WHERE 
-- 추가 조건 AND, OR
SELECT *
FROM employees
WHERE employee_id = 198;

SELECT emp_name
      ,salary 
FROM employees
WHERE salary >= 5000
AND   salary <  10000;

-- 60부서 또는 70번 부서 직원 조회 
SELECT emp_name
     , department_id
FROM employees
WHERE department_id = 60
OR department_id = 70;

--order by 정렬조건 디폴트 ASC(오름차순),내림차순은 DESC
SELECT emp_name
      ,salary 
FROM employees
WHERE salary >= 5000
AND   salary <  10000
ORDER BY salary DESC, emp_name DESC;

SELECT emp_name
      ,salary 
FROM employees
WHERE salary >= 5000
AND   salary <  10000
ORDER BY 2 DESC, 1 DESC;  -- select절에 온 순서로 ..

-- SQL은 대소문자를 구별하지 않음 
-- 데이터 값은 대소문자를 구별함 
SELECT *
FROM employees
WHERE emp_name = 'Tayler Fox';


-- employees 테이블에서 job_id가 SA_REP이면서 
-- 봉급이 9000 이상인 직원의
-- 이름, 고용일자, 봉급, 부서를 조회하시오 
-- 봉급이 큰 직원부터 출력 
DESC employees;

SELECT emp_name
      ,hire_date
      ,salary 
      ,salary * 12 AS 연봉
      ,department_id
FROM employees
WHERE job_id = 'SA_REP'
AND salary >= 9000
ORDER BY salary desc;
DROP TABLE ex2_1; -- 테이블 삭제 
CREATE TABLE ex2_1 ( 
     emp_id NUMBER
    ,nm VARCHAR2(100)
);
-- INSERT 데이터 삽입 
--(1) 컬럼명 명시 
INSERT INTO ex2_1 (emp_id, nm)
VALUES (1, '팽수');
--(2) 입력값만 
INSERT INTO ex2_1     -- 해당 테이블에 모든 컬럼 삽입시 
VALUES (2, '홍길동');
--(3) SELECT ~ INSERT
INSERT INTO ex2_1   -- 테이블의 컬럼 타입 일치해야함 
SELECT employee_id, emp_name
FROM employees;
--COMMIT;
--ROLLBACK;


--UPDATE 데이터 수정 
UPDATE ex2_1        -- 수정 테이블 
 SET nm ='길동'    -- 수정 데이터 
WHERE emp_id = 198;  -- 수정 대상 

--DELETE 데이터 삭제 
DELETE ex2_1 ; -- 전체 삭제 

DELETE ex2_1
WHERE emp_id =198;  -- 해당 행 삭제 



-- DATE :년월일 시분초 
-- TIMESTAMP : 년월일 시분초.밀리세컨드
CREATE TABLE ex2_2 (
     dt1 DATE  
    ,dt2 TIMESTAMP 
);
-- sysdate, systimestamp <--현재 시간 
INSERT INTO ex2_2 VALUES(SYSDATE, SYSTIMESTAMP);
COMMIT;
SELECT * FROM ex2_2;

-- 제약조건 UNIQUE 
--(1) 제약조건 이름 자동생성 
CREATE TABLE ex2_3 (
    col1 VARCHAR2(100)
   ,col2 VARCHAR2(100) UNIQUE   -- 제약조건 이름 자동생성 
);
--(2) 제약조건의 이름을 관리하고 싶을때 
CREATE TABLE ex2_3 (
    col1 VARCHAR2(100)
   ,col2 VARCHAR2(100)
   ,CONSTRAINT uq_2_3 UNIQUE(col2)   -- uq_2_3 이라는 이름으로 생성 
);

CREATE TABLE ex2_4 (
    col1 VARCHAR2(100)
   ,col2 VARCHAR2(100)
   ,CONSTRAINT uq_2_4 UNIQUE(col2)  
);

SELECT *
FROM ex2_3;
INSERT INTO ex2_3 (col1, col2) VALUES ('ABC','abc');

-- NOT NULL <-- NULL을 허용하지 않음 
CREATE TABLE ex2_5(
   col1 VARCHAR2(100) -- defulat NULL
  ,col2 VARCHAR2(100) NOT NULL
);
INSERT INTO ex2_5(col1) VALUES('abc'); -- 오류 col2 NOT NULL
INSERT INTO ex2_5(col2) VALUES('abc'); -- 정상처리 col1 NULL허용
SELECT * FROM ex2_5;

-- DEFAULT 값이 들어오지 않으면 디폴트값 삽입 
CREATE TABLE ex2_6(
   col1 NUMBER DEFAULT 0     -- 값이 들어오지 않으면 0
  ,col2 DATE DEFAULT SYSDATE -- 값이 들어오지 않으면 현재시간 
  ,col3 VARCHAR2(100)       
);
INSERT INTO ex2_6(col3) VALUES ('팽수');
INSERT INTO ex2_6(col1, col3) VALUES (10, '김길동');
SELECT * FROM ex2_6;

-- PRIMARY KEY(PK)기본키, FOREIGN KEY(FK)외래키
CREATE TABLE dep(
    deptno NUMBER(3) PRIMARY KEY
   ,depname VARCHAR2(100)
   ,floor  NUMBER(5)
);
CREATE TABLE emp(
    empno NUMBER PRIMARY KEY --pk
   ,emp_name VARCHAR2(100)
   ,dno NUMBER(3) CONSTRAINT emp_fk REFERENCES dep(deptno)-- fk
);
INSERT INTO dep VALUES(1, '영업', 2);
INSERT INTO dep VALUES(2, '기획', 5);
INSERT INTO dep VALUES(3, '개발', 9);
INSERT INTO emp VALUES(100, '길동', 1);
INSERT INTO emp VALUES(101, '연진', 3); -- 오류 참조하고 있는 곳에 없음 
SELECT * FROM dep;

-- 숫자 데이터타입 number(p, s) :p 최대 유효숫자(자릿수), s:소수점 자리수 
CREATE TABLE ex2_7(
    col1 number  -- 디폴트 32
   ,col2 number(3,2)
   ,col3 number(5,-2)  -- 음수일 경우 소수점기준 왼쪽 자리수 만큼 반올림 
                       -- 최대 길이가 7이됨 
);
INSERT INTO ex2_7(col2) VALUES(1.666);
INSERT INTO ex2_7(col2) VALUES(9.996); --오류 최대 자리3(소수점포함)

INSERT INTO ex2_7(col3) VALUES(99999);
INSERT INTO ex2_7(col3) VALUES(99899); --99899.00(5,-2)  십의자리까지 반올림 
INSERT INTO ex2_7(col3) VALUES(9999999);
SELECT * FROM ex2_7;


SELECT *
FROM user_constraints
WHERE constraint_name like '%UQ%';










CREATE TABLE TB_INFO(
    INFO_NO   NUMBER(3) PRIMARY KEY
  , PC_NO	  VARCHAR2(10) NOT NULL
  , NM	      VARCHAR2(20)
  , EMAIL	  VARCHAR2(100)
  , HOBBY	  VARCHAR2(1000) 
  , UPDATE_DT DATE DEFAULT SYSDATE
);
	





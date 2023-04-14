/*
  트리거 Trigger 
  사전적 의미로 총의 방아쇠를 뜻한다. 
  방아쇠가 당겨지면 -> 발사되는 개념

  어떤 테이블에 특정한 이벤트가 발생 되었을때 _ Trigger 가 동작
  INSERT, UPDATE, DELETE 의 DML문 또는 DDL 문이 실행 되었을때 
  데이터베이스에서 특정 이벤트가 발생되었다 라고 하는데 
  이런 이벤트가 발생하면 자동으로 정해진 동작을 실행하는 데이터베이스 객체

  * 트리거의 사용목적

   1.테이블 생성 과정에서 참조 무결성과 데이터 무결성 등의 복잡한 제약 조건을 생성하는 경우
   2.데이터베이스 테이블의 데이터에 생기는 작업의 감시, 보완
   3.데이터베이스 테이블에 생기는 변화에 따라 필요한 다른 프로그램을 실행하는 경우
   4.불필요한 트랜잭션을 금지하기 위해 
   5.컬럼의 값을 자동으로 생성되도록 하는 경우
   6.복잡한 뷰를 생성하는 경우 

   [기본형식]

   CREATE TRIGGER 트리거명

   BEFORE | AFTER          INSERT | DELETE | UPDATE (OF 컬럼...N)
   OF 컬럼명 ON 테이블명 
   FOR EACH ROW
   BEGIN 
    트리거내용
   END;

    SQL문 실행시기에 따른 분류


 실행시 영향을 받는 곳에 따른 분류

   * BEFORE OR AFTER  = 동작 시점을 설정 트랜잭션 발생 전, 또는 트랜잭션 이후 트리거 작동.
       before 트리거 : INSERT,UPDATE,DELETE 실행하기 전에 트리거 먼저 실행 됨
       after 트리거  : INSERT,UPDATE,DELETE 실행하고 난 후 트리거 실행 됨


   * INSERT | UPDATE | DELETE  = 이벤트 종류를 정의 INSERT OR UPDATE 처럼 복수의 이벤트를 정의할 수 있다. 

   * (OF 컬럼..N) ON 테이블명 = 트리거가 주목하는 대상 테이블을 정의하고 특정 컬럼의 이벤트에 트리거가 동작하려면 컬럼명을 명시해준다. 
      OF 이름 ON 학생
   * FOR EACH ROW   = 행 트리거를 정의한 내용으로 추가되는 행의 수만큼 트리거가 동작하여 행 내에서 이벤트가 발생되는걸 기준으로 트리거의 감시, 보완 범위를 정해두는 내용.
    
     FOR EACH ROW 를 쓰면 row(행) 트리거를 생성하고 WHEN 조건을 주면 WHEN 조건에 만족하는 ROW(행)만 트리거 적용 가능.
     즉,FOR EACH ROW를 안쓰면 statement(문장) 트리거 생성.

     - row 트리거 (행 트리거) : 실행된 트리거가 row(행) 하나하나 마다 실행 됨
     - statement 트리거(문장 트리거)
       실행된 트리거가 INSERT,UPDATE,DELETE 문장에 1번만 실행 됨

   * : OLD & : NEW  = 행트리거에서 컬럼의 실제 데이터 값을 제어하는데 사용되는 연산자  

      INSERT 문의 경우에 : NEW,
      UPDATE 문의 경우 변경 전 컬럼 데이터값은 :OLD, 수정할 새로운 데이터 값은 : NEW로 나타내고 
      DELETE 문의 경우 삭제되는 컬럼값은 : OLD 컬럼명에 저장된다.

      :OLD = 참조 전 열의 값 (INSERT : 입력 전 자료, UPDATE : 수정 전 자료, DELETE : 삭제할 자료)
      :NEW = 참조 후 열의 값 (INSERT : 입력 할 자료, UPDATE : 수정할 자료)

   * BEGIN ~ END = 트리거가 동작할 때 실행되는 내용을 정의한다. 


  * 트리거(TRIGGER)  생성시 고려사항

	1. 트리거는 각 테이블에 최대 3개까지 가능하다
	2. 트리거 내에서는 COMMIT,ROLLBACK 문을 사용할 수 없다.
	3. 이미 트리거가 정의된 작업에 대해 다른 트리거를 정의하면 기존의 것을 대체한다.
	4. 뷰나 임시 테이블을 참조할 수 있으나 생성 할 수는 없다.
	5. 트리거 동작은 이를 삭제하기 전까지 계속된다.
*/

EX)
CREATE TABLE EX11_1 AS
SELECT EMPLOYEE_ID
     , EMP_NAME
     , SALARY
FROM EMPLOYEES;

EX) 
   CREATE OR REPLACE TRIGGER test1_trig
   BEFORE UPDATE
   ON EX11_1
   BEGIN
	DBMS_OUTPUT.PUT_LINE('요청하신 작업이 처리 되었습니다.');
   END;



-- 트리거 삭제 기본형식
/*
DROP TRIGGER 트리거명 

ALTER TRIGGER 트리거명 [ENABLE / DISABLE]
ENABLE  : 사용
DISABLE : 사용하지 않음

INVALID : 문제있음
VALID   : 사용가능
*/
-- 트리거는 항상 데이터베이스를 감시하기 때문에 시스템 자원을 많이 소모한다. 그래서 꼭 필요한 상황에만 사용하기를 권장

-- 트리거 상태정검

SELECT A.OWNER 
     , A.TRIGGER_NAME
     , A.STATUS
     , B.STATUS
FROM ALL_TRIGGERS A
   , ALL_OBJECTS B
WHERE A.TRIGGER_NAME = B.OBJECT_NAME
AND A.OWNER = 'JAVA';


--ALL_TRIGGERS, ALL_OBJECTS 테이블은 오라클의 트리거 상태 정보와 OBJECT 의 상태 정보를 가지고 있는 
--오라클의 딕셔너리 테이블.

CREATE OR REPLACE TRIGGER test2_trig
 BEFORE UPDATE
 OF SALARY ON EX11_1  -- 컬럼을 체크
BEGIN
 DBMS_OUTPUT.PUT_LINE('요청하신 작업이 처리 되었습니다.');
END;
------------------------------------------------------------------
-- 업데이트를 통해 트리거 확인 
UPDATE EX11_1
SET SALARY_IMSI  = 100
WHERE EMPLOYEE_ID =199;

SELECT *
FROM test2_trig;


-- 컬럼 수정을 하여 트리거에 문제가 생기도록.
ALTER TABLE EX11_1 RENAME COLUMN SALARY TO SALARY_IMSI;

UPDATE EX11_1
SET SALARY_IMSI  = 100
WHERE EMPLOYEE_ID =199;

-- 트리거가 사용되지 않도록
ALTER TRIGGER TEST2_TRIG DISABLE;

-- 다시 컬럼을 변경
ALTER TABLE EX11_1 RENAME COLUMN SALARY_IMSI TO  SALARY;

-- 트리거 사용으로 변경
ALTER TRIGGER TEST2_TRIG ENABLE;

-- INVALID 된 트리거는 다시 컴파일 해줘서 -> VALID 로 변경될 수 있도록 해야 작동함.



CREATE TABLE ex15_tb(
     id VARCHAR2(20)
    ,name  VARCHAR2(20)
);
CREATE TABLE ex15_check(
     memo VARCHAR2(20)
    ,createDt DATE DEFAULT SYSDATE
);
-- statement  trigger
 
-- 트리거를 가진 테이블 자료를 입력,수정,삭제 한 후 로그(메모) 테이블에 입력,수정,삭제한 정보를 기록하게하는 트리거--
DROP TRIGGER after_statement_trigger; -- 이미 있을 경우 삭제하고 시작
 
CREATE OR REPLACE TRIGGER after_statement_trigger
   AFTER DELETE OR INSERT OR UPDATE ON ex15_tb
BEGIN
  -- 삽입할 때
   IF INSERTING THEN -- 이 트리거를 가진 ex15_tb에 insert 문장이 실행되면 밑에것(ex15_check에 insert)도 실행
     INSERT INTO ex15_check(memo) VALUES ('insert');
  -- 수정할 때
   ELSIF UPDATING THEN -- 이 트리거를 가진 ex15_tb에 update 문장이 실행되면 밑에것(ex15_check에 update)도 실행
     INSERT INTO ex15_check(memo) VALUES ('update');
  -- 삭제할 때
   ELSIF DELETING THEN -- 이 트리거를 가진 ex15_tb에 delete 문장이 실행되면 밑에것(ex15_check에 delete)도 실행
     INSERT INTO ex15_check(memo) VALUES ('delete');
   END IF;
END;

/
--INSERTING : 이 트리거를 가진 테이블의 문장이 INSERT일때 TRUE 그렇지 않으면 FALSE
--UPDATING  : 이 트리거를 가진 테이블의 문장이 UPDATE일때 TRUE 그렇지 않으면 FALSE
--DELETING  : 이 트리거를 가진 테이블의 문장이 DELETE일때 TRUE 그렇지 않으면 FALSE
 
-- 트리거 점검 --
INSERT INTO ex15_tb(id, name) VALUES (1, 'aaaa');
INSERT INTO ex15_tb(id, name) VALUES (2, 'bbbb');
COMMIT;

SELECT * FROM ex15_tb;
SELECT * FROM ex15_check;



---------------------------------------------------------------------------------------------
    
    
    CREATE TABLE 상품 (
       상품코드 VARCHAR2(10) CONSTRAINT 상품_PK PRIMARY KEY 
      ,상품명   VARCHAR2(100) NOT NULL
      ,제조사  VARCHAR2(100)
      ,소비자가격 NUMBER
      ,재고수량 NUMBER DEFAULT 0
    );
    
    CREATE TABLE 입고 (
       입고번호 NUMBER CONSTRAINT 입고_PK PRIMARY KEY
      ,상품코드 VARCHAR(10) CONSTRAINT 입고_FK REFERENCES 상품(상품코드)
      ,입고일자 DATE DEFAULT SYSDATE
      ,입고수량 NUMBER
      ,입고단가 NUMBER
      ,입고금액 NUMBER
    );
    
    INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('a001','마우스','삼성','1000');
    INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('a002','마우스','NKEY','2000');
    INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('b001','키보드','LG','2000');
    INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('c001','모니터','삼성','1000');

----------------- 다음과 같은 트리거를 생성하시오 



-- 입력트리거 (입고테이블에 상품이 입력되었을 때 재고수량 증가) EX (warehousing_insert)
예 ) 입고테이블에 키보드가 10 개 입고되었을때 자동으로 상품테이블의 'A002' 상품의 재고가 0 -> 10 으로 변경

-- 수정 트리거(입고테이블에 상품의 입고수량이 변경되었을때 상품테이블의 재고수량 변경) (warehousing_update)
-- 삭제 트리거(입고테이블 특정 데이터 삭제시 상품 제고 수량 변경) (warehousing_delete)
------------------------------------------------------------------------------
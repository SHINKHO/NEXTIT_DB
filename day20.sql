--EX) trigger
CREATE TABLE EX11_1 AS
SELECT EMPLOYEE_ID
     , EMP_NAME
     , SALARY
FROM EMPLOYEES;

--EX) 
   CREATE OR REPLACE TRIGGER test1_trig
   BEFORE UPDATE
   ON EX11_1
   BEGIN
	DBMS_OUTPUT.PUT_LINE('요청하신 작업이 처리 되었습니다.');
   END;

SELECT *
FROM ex11_1;

CREATE OR REPLACE TRIGGER hak_tr
BEFORE UPDATE OF 이름 ON 학생
FOR EACH ROW
 DECLARE
    v_msg VARCHAR2(100);
 BEGIN
    DBMS_OUTPUT.PUT_LINE('이름 변경안됨!!!');
    DBMS_OUTPUT.PUT_LINE(:OLD.이름 ||'|'||:OLD.학번); 
    DBMS_OUTPUT.PUT_LINE(:NEW.이름);
    v_msg := '이름변경 NO';
    RAISE_APPLICATION_ERROR(-20999,v_msg);
 END;
 
 SELECT *
 FROM 학생;
 UPDATE 학생
 SET 이름 = '길동'
 WHERE 학번 = 2023000001;
 

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
SELECT *
FROM 상품;
SELECT *
FROM 입고;
 
 
/* insert trigger 입고테이블에 입고내역이 INSERT되면
    해당 상품의 상품수량을 상품테이블에 업데이트
*/
CREATE OR REPLACE TRIGGER warehousing_insert
AFTER INSERT ON 입고
FOR EACH ROW
DECLARE     
    vn_cnt 상품.재고수량%TYPE;
    vn_nm 상품.상품명%TYPE;
BEGIN
    SELECT 재고수량, 상품명
    INTO vn_cnt, vn_nm
    FROM 상품
    WHERE 상품코드 = :NEW.상품코드;
    DBMS_OUTPUT.PUT_LINE(vn_nm||'제품의 수량 정보가 변경됨.');
    DBMS_OUTPUT.PUT_LINE('이전 재고수량:' || vn_cnt);
    DBMS_OUTPUT.PUT_LINE('입고수량:' || :NEW.입고수량);
    DBMS_OUTPUT.PUT_LINE('입고 후 수량:'||(vn_cnt + :NEW.입고수량));
END;
UPDATE 상품
SET 재고수량 = :NEW.입고수량 + 재고수량
WHERE 상품코드 = :NEW.상품코드;
    DBMS_OUTPUT.PUT_LINE(vn_nm||'제품의 수량 정보가 변경됨.');
    DBMS_OUTPUT.PUT_LINE('이전 재고수량:' || vn_cnt);
    DBMS_OUTPUT.PUT_LINE('입고수량:' || :NEW.입고수량);
    DBMS_OUTPUT.PUT_LINE('입고 후 수량:'||(vn_cnt + :NEW.입고수량));

SELECT NVL(MAX(입고번호),0) + 1
FROM 입고;
INSERT INTO 입고 (입고번호, 상품코드, 입고수량, 입고단가, 입고금액)
VALUES ((SELECT NVL(MAX(입고번호),0)+1
    FROM 입고),'a002',100,1000,10000);
INSERT INTO 입고 (입고번호, 상품코드, 입고수량, 입고단가, 입고금액)
VALUES ((SELECT NVL(MAX(입고번호),0)+1
    FROM 입고),'a002',10,1000,10000);
SELECT *
FROM 상품;
    
SELECT * FROM 입고;
/*insert trigger 입고테이블에 입고내역이 INSERT되면 해당 상품의 상품수량을 상품테이블에 업데이트
*/
CREATE OR REPLACE TRIGGER warehousing_insert
AFTER INSERT ON 입고
FOR EACH ROW
DECLARE
    vn_cnt 상품.재고수량%TYPE;
    vn_nm 상품.상품명%TYPE;
BEGIN
    SELECT 재고수량,상품명
    INTO vn_cnt,vn_nm
    FROM 상품
    WHERE 상품코드 = :NEW.상품코드;
    DBMS_OUTPUT.PUT_LINE(vn_nm||'제품의 수량 정보가 변경됨.');
    DBMS_OUTPUT.PUT_LINE('이번 재고수량 :'||vn_cnt);
    DBMS_OUTPUT.PUT_LINE('입고 수량 :'||:NEW.입고수량);
    DBMS_OUTPUT.PUT_LINE('입고 후 수량:' || (vn_cnt+ :NEW.입고수량));
END;

SELECT NVL(MAX(입고번호),0) + 1
FROM 입고;

INSERT INTO 입고 (입고번호, 상품코드, 입고수량, 입고단가, 입고금액)
VALUES ((SELECT NVL(MAX(입고번호),0)+1
    FROM 입고),'a002',100,1000,10000);

INSERT INTO 입고 (입고번호, 상품코드, 입고수량, 입고단가, 입고금액)
VALUES ((SELECT NVL(MAX(입고번호),0)+1
    FROM 입고),'a002',10,1000,10000);

SELECT *
FROM 상품;
-- :OLD = 참조 전 열의 값 :NEW 참조 후 열의 값 
CREATE OR REPLACE TRIGGER warehousing_delete
AFTER DELETE ON 입고
FOR EACH ROW
BEGIN
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량
    WHERE 상품코드  = :OLD.상품코드;
END;

DELETE FROM 입고 WHERE 입고번호 = 2;
select* from 상품;
/*  입고 테이블에  UPDATE트리거를 만드세요
    입고 이력중 특정 입고번호의 수량이 변겨경되면
    상품 재고수량도 수정되도록.
*/

CREATE OR REPLACE TRIGGER warehousing_update
after update on 입고
FOR EACH ROW
begin
    update 상품
    set 재고수량 = 재고수량 -:OLD.입고수량+ :NEW.입고수량
    WHERE 상품코드 = :NEW.상품코드;
END;

grant execute on DBMS_CRYPTO to public;
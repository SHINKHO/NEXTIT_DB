--/프로시저/
CREATE OR REPLACE PROCEDURE job_proc -- 프로시저 이름
( p_job_id IN JOBS.JOB_ID%TYPE
 ,p_job_title JOBS.JOB_TITLE%TYPE -- default 값이 in 이기 때문에 생략 가능
 ,p_min_salary JOBS.MIN_SALARY%TYPE
 ,p_max_salary JOBS.MAX_SALARY%TYPE) --매개변수 정의
 IS
 BEGIN
     INSERT INTO JOBS(job_id,job_title,min_salary,max_salary)
     VALUES (p_job_id,p_job_title,p_min_salary,p_max_salary);
     COMMIT;
 END;
 --실행 
EXEC job_proc('SM_JOB1','sample job1',1000,5000);
--EXECUTE job_proc('SM_JOB1','sample job1',1000,5000);

SELECT * FROM jobs;

CREATE OR REPLACE PROCEDURE test_proc(
     p_v1 VARCHAR2 -- in 내부사용
    ,p_v2 OUT VARCHAR2 -- out 리턴 (내부사용 X) 
    ,p_v3 IN OUT VARCHAR2 -- in out 내부사용 && 리턴
)                         -- out이 붙으면 반드시 리턴이 되어야만함 
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('p_v1:' || p_v1);
    DBMS_OUTPUT.PUT_LINE('p_v2:' || p_v2);
    DBMS_OUTPUT.PUT_LINE('p_v3:' || p_v3);
 --   p_v2 := '리턴v2';                 --리턴되는 함수
  --  p_v3 := '리턴v3';                 --리턴되는 함수
END;
COMMIT;

--테스트
DECLARE
    v_a1 VARCHAR2(100) :='A'; 
    v_b1 VARCHAR2(100) :='B';
    v_c1 VARCHAR2(100) :='C';
BEGIN
    test_proc(v_a1,v_b1,v_c1); --out의 경우 프로시저 안에서 호출시 이름만 사용.
    DBMS_OUTPUT.PUT_LINE('test:' || v_a1); -- in 의 경우 값을 받을 수 있음. 값을 리턴하지는 못함.
    DBMS_OUTPUT.PUT_LINE('test:' || v_b1); -- b1은 값이 있더라도 out 이기 때문에 내부에서 사용이 안 됨 리턴에서만 사용 가능함.
    DBMS_OUTPUT.PUT_LINE('test:' || v_c1); -- in out 의 경우
END;

/*시스템 예외*/
CREATE OR REPLACE PROCEDURE exception_proc
IS
    vn_num NUMBER :=0;
    
BEGIN
    vn_num := 10/0;
    DBMS_OUTPUT.PUT_LINE('종료');
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없음');
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류남');
END
;

CREATE OR REPLACE PROCEDURE no_exception_proc
IS
    vn_num NUMBER :=0;
BEGIN
    vn_num := 10/0;
    DBMS_OUTPUT.PUT_LINE('종료');
END
;

BEGIN
    exception_proc;
   -- no_exception;
    DBMS_OUTPUT.PUT_LINE('success');
END;

-- 20021101112
/*
    신입생이 들어왔습니다. 학번을 생성하여 등록해주세요
    기존 학번에서 가장 높은 학번을 찾아서
    앞 4자리가 올해 년도와 같다면
    해당번호 +1로 생성
    같지 않다면 
    올해년도 + 000001 으로 생성
*/
DECLARE
    --올해
    vn_year VARCHAR2(4) := TO_CHAR(SYSDATE,'YYYY');
    vn_max_num NUMBER := 0;
    vn_make_num NUMBER :=0;
BEGIN
    --1.max값 가져오는 select
        vn_max_num := fn_학생_idMAX;
    --2.올해년도와 같은지 비교하는 조건문 IF & 학번생성
        vn_make_num := to_char(vn_year,'YYYY');
        IF substr(vn_max_num,0,4) = vn_make_num
        THEN vn_make_num := vn_make_num || vn_max_num+1;
        END IF;
    
    --3.INSERT
    INSERT INTO 학생(학번,이름,전공,생년월일)
    VALUES (vn_make_num, :nm, :subject,TO_DATE(:dt));
    COMMIT;
END;
---풀이
DECLARE
    --올해
    vn_year VARCHAR2(4) := TO_CHAR(SYSDATE,'YYYY');
    vn_max_num NUMBER := 0;
    vn_make_num NUMBER :=0;
BEGIN
    --1.max값 가져오는 select
    SELECT MAX(학번)
        INTO vn_max_num
    FROM 학생;
    --2.올해년도와 같은지 비교하는 조건문 IF & 학번생성
    IF vn_year = SUBSTR(vn_max_num,1,4) THEN
        vn_make_num :=vn_max_num +1;
    ELSE
        vn_make_num := vn_year || '000001';
    END IF;
    --3.INSERT
    INSERT INTO 학생(학번,이름,전공,생년월일)
    VALUES(vn_make_num,:nm,:subject,TO_DATE(:dt));
    COMMIT;
END;
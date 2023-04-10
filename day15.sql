--에러가 났을때 저장하는 테이블 
CREATE TABLE error_log(
    error_seq NUMBER
    ,prod_name VARCHAR2(80)
    ,error_code NUMBER
    ,error_msg VARCHAR(4000)
    ,error_line VARCHAR(4000)
    ,error_date DATE DEFAULT SYSDATE
);
CREATE SEQUENCE err_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 9999999;

CREATE OR REPLACE PROCEDURE error_log_proc(
    p_name error_log.prod_name%TYPE
    ,p_error_code error_log.error_code%TYPE
    ,p_error_msg error_log.error_msg%TYPE
    ,p_error_line error_log.error_line%TYPE
)
IS
BEGIN
    INSERT INTO error_log(error_seq,prod_name,error_code,error_msg,error_line)
    VALUES  (err_seq.NEXTVAL,p_name,p_error_code,p_error_msg,p_error_line);
    COMMIT;
END;

--test
CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month  VARCHAR2  )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   
   ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 정의
   
   ex_invalid_month EXCEPTION; -- 잘못된 입사월인 경우 예외 정의
   PRAGMA EXCEPTION_INIT (ex_invalid_month, -1843); -- 예외명과 예외코드 연결
BEGIN
	
	 -- 부서테이블에서 해당 부서번호 존재유무 체크
	 SELECT COUNT(*)
	   INTO vn_cnt
	   FROM departments
	  WHERE department_id = p_department_id;
	  
	 IF vn_cnt = 0 THEN
	    RAISE ex_invalid_depid; -- 사용자 정의 예외 발생
	 END IF;
	 
	 -- 입사월 체크 (1~12월 범위를 벗어났는지 체크)
	 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
	    RAISE ex_invalid_month; -- 사용자 정의 예외 발생
	 
	 END IF;
	 
	 
	 -- employee_id의 max 값에 +1
	 SELECT MAX(employee_id) + 1
	   INTO vn_employee_id
	   FROM employees;
	 
	 -- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
	 INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
              
   COMMIT;              
              
EXCEPTION WHEN ex_invalid_depid THEN -- 사용자 정의 예외 처리
               error_log_proc('ch10_ins_emp_proc',SQLCODE,SQLERRM,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
               DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다');
          WHEN ex_invalid_month THEN -- 입사월 사용자 정의 예외
               error_log_proc('ch10_ins_emp_proc',SQLCODE,SQLERRM,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               DBMS_OUTPUT.PUT_LINE('1~12월 범위를 벗어난 월입니다');               
          WHEN OTHERS THEN
               error_log_proc('ch10_ins_emp_proc',SQLCODE,SQLERRM,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);              	
END;    

EXEC ch10_ins_emp_proc ('홍길동', 110, '201314');

select * from error_log;

/*savepoint test*/
-- 수업/9장_(트랜젝션_배포).sql 와연동

CREATE TABLE ex15_1(
    ex_no NUMBER,
    ex_num VARCHAR2(100)
);
CREATE OR REPLACE PROCEDURE save_proc(flag VARCHAR2)
IS
    point1 EXCEPTION;
    point2 EXCEPTION;
    vn_num  NUMBER;
BEGIN
    INSERT INTO ex15_1 VALUES(1,'POINT1 BEFORE');
    SAVEPOINT my_point1;
    INSERT INTO ex15_1 VALUES(2,'POINT2 BEFORE');
    SAVEPOINT my_point2;
    INSERT INTO ex15_1 VALUES(3,'POINT2 AFTER');
    IF flag = '1' THEN
        RAISE point1;
    ELSIF flag = '2' THEN
        RAISE point2;
    ELSIF flag = '3' then
        vn_num:= 10/0;
    END IF;
    COMMIT;
EXCEPTION WHEN point1 THEN 
        DBMS_OUTPUT.PUT_LINE('point1');
        ROLLBACK TO my_point1;
        COMMIT;
    WHEN point2 THEN
        DBMS_OUTPUT.PUT_LINE('point2');
        ROLLBACK TO my_point2;
        COMMIT;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('others');
    ROLLBACK;
END;

EXEC save_proc('3'); --1,2,3,4

delete ex15_1;
SELECT *
FROM ex15_1;
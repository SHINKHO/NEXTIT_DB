/*
    PL/SQL
    - 집합적 언어(SQL) 와 절차적 언어(PL)의 특징을 모두 가지고
    있음.
    
    - DB 내부에서 실행되기 때문에 수행 속도와 성능에서 큰 장점이 있ㄷ음.
*/
-- 익명블록( 이름이 없는 PLSQL)
DECLARE
    vn_num NUMBER;  --선언부
BEGIN
    vn_num :=10;    --실행부
    DBMS_OUTPUT.PUT_LINE(vn_num);
END;

SET SERVEROUTPUT ON; --PLSQL 실행 결과 스크립트 출력하려면 
                     --세션에 최초 접속시 한번 실행 해야함.
                     --혹은 developer 기준 보기(v) 창의 
                     --dbms출력 선택지를 통해 출력탭을 만들 수 있다
-- 상수
DECLARE
    vn_num CONSTANT NUMBER := 3.14; --상수는 초기값을 설정해야함.
BEGIN
-- vn_num:= 10; 변경안됨
    DBMS_OTUPUT.PUT_LINE(vn_num);
END;
-- 변수에 테이블 값 넣기
DECLARE
    vs_emp_name VARCHAR2(80); --
    vs_dep_name departments.department_name%TYPE; --테이블 컬럼타입
BEGIN
    SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name       --변수에 할당(select결과)
    FROM employees a,
        departments b
    WHERE a.department_id = b.department_id
    AND a.employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || ':' || vs_dep_name);
END;

--정의할 것이 없으면 begin end 만 써도 된다.
BEGIN 
    DBMS_OUTPUT.PUT_LINE('3 * 1 = '||3*1);
END;

/* IF ELSIF ELSE*/
DECLARE
    vn_num NUMBER := :num;
BEGIN
    IF vn_num<10 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num || ' is' || 'smaller than 10' );
    ELSIF vn_num>10 AND vn_num<100 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num || ' is' || 
        'greater than 10 and less than 100');
        --NULL; // 간혹 실행문구 없이 비워둬야 할 경우 NULL; 을 써야 에러가 발생하지 않는다. 
    ELSE
        DBMS_OUTPUT.PUT_LINE(vs_num ||' Greater than 100');
    END IF;
END;

--단순 LOOP 문 (EXIT 필요: 탈출조건)
DECLARE 
    vn_base NUMBER := 3;
    vn_i    NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base || '*' || vn_i || '=' || vn_base * vn_i);
        vn_i := vn_i+1;
        EXIT WHEN vn_i >9;
    END LOOP;
END;

--구구단 출력 
DECLARE
    vn_base NUMBER:=2;
    vn_i    NUMBER:=1;
BEGIN
    LOOP
        LOOP
            DBMS_OUTPUT.PUT_LINE(vn_base || '*' || vn_i || '=' || vn_base*vn_i);
            vn_i := vn_i +1;
            EXIT WHEN vn_i>9;
        END LOOP;
        vn_base := vn_base+1;
        vn_i :=1;
    EXIT WHEN vn_base>9;
    END LOOP;
END;
--while 문 
DECLARE
    vn_base NUMBER := 3;
    vn_i    NUMBER := 0;
BEGIN
    WHILE vn_i <= 9 -- while 은 조건이 true일경우 
    LOOP
        vn_i := vn_i+1;
        CONTINUE WHEN vn_i = 5; -- continue 뒤로는 건너뛰고 다시 loop 문 수행
        DBMS_OUTPUT.PUT_LINE(vn_base || '*' || vn_i || '='||vn_base*vn_i);
        
--      EXIT WHEN vn_i = 5; --같으면
    END LOOP;
END;
/*FOR*/
DECLARE
    vn_base NUMBER :=0;
BEGIN
    FOR vn_base IN 1..9 -- DECLARE 절에 존재하지 않은 변수는 다른 구문에 할당해서 값을 조절할 수 없다.
    LOOP                -- vn_base 는 할당이 되었음으로 다른 구문에서 값 변경이 가능하다.
        FOR i IN 1..9
        LOOP
            DBMS_OUTPUT.PUT_LINE(vn_base || '*' || i || '=' || vn_base *i);
        END LOOP;
    end LOOP;
END;

/*
    이름이 있는 블록
    이름
    IS
        선언부
    BEGIN 
        실행부
    END
오라클의 PL은 SQL 구문을 생성해서 데이터를 조작한다는 조건 하에 만들어진 언어라 무조건 리턴이 있어야 한다.
*/
-- 이름을 입력받아서 학번을 리턴하는 함수 
CREATE OR REPLACE FUNCTION fn_get_no(nm VARCHAR2)
    RETURN NUMBER
IS
    vn_num 학생.학번%TYPE;
BEGIN
    SELECT 학번
    INTO vn_num
    FROM 학생
    WHERE 이름 =nm;
    
    RETURN vn_num;
END;

SELECT fn_get_no('최숙경') from dual;

/*
    countries 테이블을 사용하여
    국가 번호를 입력받아
    국가 명을 리턴하는 함수를 작성하시오
    
    input type : number
    return type : varchar2
    function name = fn_get_country
*/

CREATE OR REPLACE FUNCTION fn_get_country(concd NUMBER)
    RETURN countries.country_name%TYPE
IS
    vn_nm countries.country_name%TYPE;
BEGIN
    SELECT country_name
    INTO vn_nm
    FROM countries
    where country_id = concd;
    
    RETURN vn_nm;
END;

select fn_get_country(52790) from dual;
/*
    1~500 까지의 숫자를 입력받아
    증가되는 숫자를 출력하시오
    (단 3,6,9 가 포함된다면 짝으로 출력)
    ex : 3 -> 짝 
         36 -> 짝짝
         333 -> 짝짝짝 
    hint : length , replace , to_char
    포함된 문자열의 길이를 사용하여 ... 
*/
DECLARE
    vn_range NUMBER :=:num;
    vn_jjak VARCHAR2(12);
BEGIN
    FOR i in 1..vn_range
    LOOP
        vn_jjak:=to_char(i);
        FOR j in 1 .. LENGTH(vn_jjak)
        LOOP
            FOR k in 0 .. 9
            LOOP
                CASE WHEN k=3 or k=6 or k=9 THEN
                    vn_jjak :=replace(vn_jjak,k,'짝');
                    CONTINUE;
                ELSE
                    vn_jjak :=replace(vn_jjak,k,'');
                END CASE;
            END LOOP;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE (i ||':'|| vn_jjak);
    END LOOP;
END;
/*
    문자 연산자 || <-- 문자열 붙일 때 사용
*/

SELECT emp_name || ':' || employee_id
From employees;
/*
        수식 연산자 + * / 숫자 데이터 타입에 사용가능 
*/
SELECT employee_id,
    emp_name,
    round(salary / 30,2) AS 일당,
    salary      AS 월급,
    salary - salary * 0.1 AS 실수령액,
    salary * 12 AS 연봉
FROM employees;

/*
    논리 연산자 > , >= ,<= < != ,<> , ^= 
*/
SELECT * FROM employees where salary = 2600; --같다 
SELECT * FROM employees where salary <> 2600;--같지않다
SELECT * FROM employees where salary != 2600;--같지않다
SELECT * FROM employees where salary ^= 2600;--같지않다
SELECT * FROM employees where salary <  2600;--미만
SELECT * FROM employees where salary >  2600;--초과
SELECT * FROM employees where salary <= 2600;--이하
SELECT * FROM employees where salary >= 2600;--이하

-- 직원중에 30, 50번 부서가 아닌 직원만 출력하시오
SELECT * FROM employees where department_id <> 30 and department_id <> 50;


/*   IN 조건식
     : "다음 파라메터를 포함한다."
     IN (para1,para2, ... )
     
     NOT 조건식 
     : ~ 하지 않는 . In 앞에 붙여줄 경우 "다음 파라메터를 포함하지 않는다" 가 된다.
     NOT 조건식 ~;
*/
SELECT *
FROM employees
WHERE department_id IN (30,50);

SELECT * 
FROM employees 
where department_id not in (30,50);

/*표현식 CASE WHEN 조건식 THEN 값  /조건 1
             WHEN 조건식 THEN 값 / 조건 2
             ELSE 값           / 조건 3
        END AS 아웃풋 컬럼명
        * 테이블명을 알아보기 힘듬으로 ALIAS 사용은 반필수적
    특정조건일때 표현을 바꾸는 표현식
    

*/
-- c등급 ~5001~ b등급 ~ 15000~ a등급 
SELECT *,
        CASE WHEN salary <=5000 THEN 'c등급'
            WHEN salary >5000 AND salary <= 1500 then 'b등급'
            ELSE 'A등급'
        END as grade
FROM employees;

-- CUSTOMER 테이블에서 성별 정보 F-> '여자' M-> '남자' 표현식을 사용하여 출력하시오
SELECT customers.*,
    case 
        when cust_gender = 'M' then '남자' 
            else '여자' 
        end as "성별" -- end as 뒤는 문자열로 인식하여 varchar2 타입을 명시하려고 ''를 쓰면 FROM 문과 겹쳐서 해당 문을 찾지 못하는 문제가 있다.
        -- 따옴표를 없애거나 쌍따옴표를 써야 한다.
FROM customers;

    
/*LIKE 조건식 (많이 사용) */
SELECT emp_name
FROM employees
-- WHERE emp_name LIKE 'A%' -- A로 시작하는~
-- WHERE emp_name LIKE '%a' -- a로 끝나는 ~
-- WHERE emp_name LIKE '%a%' --a가 포함된 `
WHERE emp_name LIKE '%'||:val||'%' -- 바인딩 테스트 -> 여러값을 테스트할 시 사용됨,해당 라인의 경우 {any letter}{operator concat}{binding variable 'val'}{op concat}{any letter}
;

drop table ex3_1;
-- where nm LIKE '_길_' ; -- like '길' 앞뒤의 문자 길이가 정확히 일치 _ <- 사용 
CREATE TABLE ex3_1(
    nm VARCHAR(100)
);
insert into ex3_1 values('홍길');
insert into ex3_1 values('홍길동');
insert into ex3_1 values('홍길동님');

SELECT * 
from ex3_1
where nm like '_길_' ;

--TB_INFO 김씨만 조회
select nm from tb_info where nm like '김%';

/*문자함수 : 문자 함수는 연산 대상이 문자이며 반환 값은 함수에 따라 문자  or 숫자를 반환
*/
--UPPER(char) 대문자로
--LOWER(char) 소문자로 

SELECT emp_name,
    UPPER(emp_name),
    UPPER('hi'),
    LOWER(emp_name)
FROM employees;
-- 검색조건으로 대문자 or 소문자가 들어와도 검색이 되게 하려면?
SELECT emp_name
FROM employees
WHERE LOWER(emp_name) = LOWER('DOUglas Grant')
;

--Ing 가 포함된 이름을 조회하시오( 대소문자 구별없이)
select emp_name
from employees
where LOWER(emp_name) like '%ing%';

select emp_name
from employees
where upper(emp_name) like '%'||upper(:nm)||'%';

--SUBSTR 문자열 자르기
--SUBSTR(char, pos, len) 대상 문자열 char를 pos 번재 부터 len 길이만큼 자른뒤 반환
-- pos 값으로 0이오면 디폴트 1( 첫번째 문자열), 음수가 오면 뒤에서 부터
-- len 값이 생략되면 pos번재부터 끝까지
select emp_name
,      SUBSTR(emp_name,1,4)
,      SUBSTR(emp_name,4)
,      SUBSTR(emp_name,-4,1)
from employees;

/* INSTR 위치 반환

   INSTR(char, n , pos , len ) char 대상문자열에서 n을 찾는다.
                               pos 부터 len 번재 대상의 시작 위치를 반환
                               pos, len 디폴트 1
*/
SELECT INSTR('abcabc', 'b', 1,1),
        INSTR('abcabc', 'b', 1,2),
        INSTR('abcabc', 'b'),
        INSTR('abcabc', 'b', 3,1)
FROM DUAL ; -- 테스트 테이블 ( 더미 테이블 ) 

--1.TB_INFO 의 EMAIL 컬럼에서 @의 위치를 출력하시오
--2. 1번의 위치값을 활용하여 id와 domain 정보를 출력하시오
--  ex) leeapgil@gmail.com -> id : leeapgil , domain : gmail
select email,
        instr(email,'@') as loc,
        substr(email,0,instr(email,'@')-1) as id,
        substr(email,instr(email,'@')+1) as domain
from tb_info;

select email , INSTR(email,'@') -1 as loc
        , SUBSTR(email, 1, INSTR(email,'@') -1) as id
        , SUBSTR(email, INSTR(email,'@')+1) as domain
FROM tb_info;

/* REPLACE 치환
   REPLACE (char, n , m) 대상 문자열 char 에서 n을 찾아서 m 으로 변경
*/
SELECT REPLACE('abcd','a','A') 
FROM DUAL;

/* TRIM: 양쪽 공백제거 LTRIM:왼족, RTRIM: 오른쪽 */
SELECT TRIM(' hi '), LTRIM(' hi '), RTRIM(' hi ') from dual;

/*LPAD : 왼족채움 RPAD : 오른쪽채움
  LPAD(char, 5, '0') ->> char를 5자리로 만듬 ('0'을 채워서) 
*/
SELECT LPAD('a',5,'0'),
        LPAD('ab',5,'0'),
        LPAD('ab',5,'*'),
        LPAD('abcdef',5,'*')
FROM DUAL;

--LENGTH(문자열) <-- 문자열 길이 반환
SELECT emp_name,
       LENGTH(emp_name) --문자열 길이 
FROM employees;

--CUSTOMERS 테이블에서 CUST_MAIN_PHONE_NUMBER 컬럼의 데이터를 *로 마스킹 처리하고 뒤 2자리만 출력되게 하시오 
SELECT cust_main_phone_number as original,LPAD(SUBSTR(CUST_MAIN_PHONE_NUMBER,11),12,'*') as masked FROM CUSTOMERS;

/* 정규표현식
    .(dot) 임의의 1글자를 의미함
    [] <-- 임의의 1글자를 의미함
    '^' <-- 시작
    [^] <-- not
    ? 0 or 1회
    + 1회 이상
    * 0회 이상
*/
--REGEXP_LIKE(대상문자열,정규표현식)
SELECT * 
FROM member 
WHERE REGEXP_LIKE(mem_hometel,'...-9');
-- 시작 숫자 2자리 - <-- 출현하는 전화번호 고객을 조회하시오 ex 02-~~
SELECT * 
FROM member 
WHERE REGEXP_LIKE(mem_hometel,'^..-');
--{n}정확히 n회 매치
--{n,} n회 이상
--{n,m} n~m 매치 
--mem_mail 이 소문자 3자리@ ex)abc@gmail.com
--인 회원을 조회하시오 
SELECT *
FROM member
WHERE REGEXP_LIKE(mem_mail,'^[a-z]{3}@');
-- $ <-- 끝을 의미함
-- () <-- 패턴 그룹
-- | <-- 또는

with T1 AS(
        SELECT '(02)456-1234' as nums FROM dual
        UNION
        SELECT '(042)456-1234' as nums FROM dual
        UNION
        SELECT '010-456-1234' as nums FROM dual
        ) 
-- (숫자2) or (숫자3) 패턴인 데이터만 조회하시오 ( <- 포함
SELECT * FROM t1
WHERE REGEXP_LIKE(nums,'\([0-9]{2,3}\)');
--WHERE REGEXP_LIKE(nums,'(\([0-9]{2}\))|(\([0-9]{3}\))');
--숫자와-만 있는 데이터를 출력하시오
SELECT mem_name,mem_add2
FROM member
WHERE REGEXP_LIKE(MEM_ADD2,'^([0-9]|\-)*$');
--반대로 하고 싶으면 where not 을 붙이자

--mem_add2 정보가 한글만 있는 회원
SELECT mem_add2
FROM member
where REGEXP_LIKE(mem_add2,'^[가-힣]+$');
--한글 공백 숫자 패턴만 조회
SELECT mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2,'[가-힣][ ][0-9]');
--WHERE REGEXP_LIKE(mem_add2,'[가-힣] [0-9]');
--D로 시작하며 세번째 문자가 u or n 인 직원을 출력하시오
SELECT emp_name FROM employees
WHERE REGEXP_LIKE(emp_name,'^D.(n|u)');
--WHERE REGEXP_LIKE(emp-name,'^d.(n|u)','i'); 
-- 3번째param i < -- 대소문자 구별없이

--REGEXP_SUBSTR
SELECT REGEXP_SUBSTR(mem_mail,'[^@]+',1,1) as id,
        REGEXP_SUBSTR(mem_mail,'[^2]+',1,2) as domain
FROM member;
        --(대상문자, 패턴,시작위치,매칭순번)
SELECT REGEXP_SUBSTR('A-01-02','[^-]+',1,1) as a1,
        REGEXP_SUBSTR('A-01-02','[^-]+',1,2) as a2,
        REGEXP_SUBSTR('A-01-02','[^-]+',1,3) as a3
FROM dual;
--member mem_add1 에서 첫번재 단어만 출력하시오
SELECT REGEXP_SUBSTR(mem_add1,'[^ ]+',1,1) as first
FROM member;

--REGEXP_REPLACE (A,B,C) 일 A를 B의 패턴으로 정의하고 C로 변경한다.
SELECT REGEXP_REPLACE('Ellen hildi Smith'
                    ,'(.*) (.*) (.*)','\3, \1 \2') text
    -- 아래는 Joe      SMITH문자열의 (2개 이상의 ' ')를 패턴으로 정의,
    --  이후 그것을 ' '로 교체한다 로 정의한다
    ,   REGEXP_REPLACE('Joe     Smith','( ){2,}',' ') as text2
    -- 단순 띄어쓰기 2개는 구분으로 취급해서 적용되지 않는다.
    ,   REGEXP_REPLACE('Joe     Smith','  ',' ') text3
FROM dual;
--member 테이블에서 mem_add1 대전이 포함되어 있는 주소를
--대전으로 표기해주세요 (대전광역시 -> 대전
--                  대전시 -> 대전 
-- id: p001제외
SELECT  REGEXP_REPLACE(mem_add1,'대전광역시|대전시','대전') as 대전통일 
from    member 
where   mem_id !='p001'
    and mem_add1 like '%대전%';

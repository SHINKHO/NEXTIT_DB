/*
컬럼의 타입과 컬럼의 갯수가 같다면 붙여쓸수있다.
*/
select goods from exp_goods_asia where country ='한국' union all -- 각각의 조회 결과의 집합
select goods from exp_goods_asia where country = '일본';

select goods from exp_goods_asia
where country = '한국'
minus --차집합 
select goods
from exp_goods_asia
where country = '일본';

select goods from exp_goods_asia
where country = '한국'
INTERSECT --교집합 
select goods
from exp_goods_asia
where country = '일본';

select goods,seq 
from exp_goods_asia
where country = '한국'
Union
select goods,seq
from exp_goods_asia
where country = '일본';

select 'hi',1
from dual
union
select 'hi2',2 -- 컬럼의 수와 타입이 같아야함
from dual
order by 2 ; -- 정렬 조건은 마지막 쿼리에만 가능



-- member 회원의 생일 요일 별 회원수를 출력하시오

SELECT to_char(mem_bir,'dy'), -- day = 일요일월요일... dy =일월화수목금토 d =1234567 : 
       count(*) as pop
FROM member
group by ROLLUP(to_char(mem_bir,'dy')) -- roll up 해당 근집화에 대한 통계를 제공
;

--decode 예제  DECODE(해당 컬럼, 레코드 값 조건,-에 따라 출력할 값, 레코드 값 조건, -에 따라 출력할 값,...., ELSE) 
Select cust_name,
       cust_gender,
       DECODE(cust_gender,'F','여자','M','남자','?') as gender
from customers;

--group by ROLLUP() 통계를 위해 사용되어 '전체의 합(총계)'을 나타내는 함수이다..
select  period,
        sum(loan_jan_amt) total 
        from kor_loan_status 
        where period like'2013%' 
        group by rollup(period)
UNION
SELECT '전체'
,       SUM(loan_jan_amt) total
FROM kor_loan_status
where period like '2013%';

/*
2013310 기타대출         676078     (3) 소계
2013310 주택담보대출      411415.9   (3) 소계
2013310 기타대출         1087493    (2) 기간의 총계
2013311 기타대출         681121.3   (3) 소계
2013311 주택담보대출      414236.9   (2) 소계
2013311                                기간의 총계
                        2182852.1 (1) 총계

/*
    INNER JOIN 내부조인 (동등조인)
    a = b <-- 두 값이 같을 경우 행이 연결됨
*/
SELECT a.emp_name
,      a.department_id as emp_dep_id     -- 아래의 dep_id와 같음
,      b.department_id as dep_dep_id   -- 위의 dep_id와 같음. 
,      b.department_name
FROM employees a   --from 절이 가장 먼저 읽히는데 alias 를 대입해준다면 더 쉽게 sql문을 작성 가능하다.
,    departments b --테이블명을 위한 alias엔 as 접두어를 붙이지 않아도 된다.
WHERE a.department_id = b.department_id;
-- 두테이블에 부서 id가 같을경우 조인됨.



/*       강의내역, 과목, 교수, 수강내역, 학생 테이블을 만드시고 아래와 같은 제약 조건을 준 뒤 
        (1)'학생' 테이블의 PK '학번'
        (2)'수강내역' 테이블의 PK '수강내역번호'
        (3)'과목' 테이블의 PK '과목번호'
        (4)'교수' 테이블의 PK '교수번호'
        (5)'강의내역'의 PK를 '강의내역번호'

        (6)'학생' 테이블의 PK를 '수강내역' 테이블의 '학번' 컬럼이 참조한다 FK 키 설정
        (7)'과목' 테이블의 PK를 '수강내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정 
        (8)'교수' 테이블의 PK를 '강의내역' 테이블의 '교수번호' 컬럼이 참조한다 FK 키 설정
        (9)'과목' 테이블의 PK를 '강의내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정
            각 테이블에 엑셀 데이터를 임포트 

    ex) ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
        
        ALTER TABLE 수강내역 
        ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
        REFERENCES 학생(학번);

*/

ALTER TABLE 학생 ADD CONSTRAINT PK_STUDENT_ID PRIMARY KEY (학번);
ALTER TABLE 수강내역 ADD CONSTRAINT PK_LECTAKEN_ID PRIMARY KEY (수강내역번호);
ALTER TABLE 과목 ADD CONSTRAINT PK_LECTURE_ID PRIMARY KEY (과목번호);
ALTER TABLE 교수 ADD CONSTRAINT PK_INSTRUCTOR_ID PRIMARY KEY (교수번호);
ALTER TABLE 강의내역 ADD CONSTRAINT PK_LECGIVEN_ID PRIMARY KEY (강의내역번호);

ALTER TABLE 수강내역 ADD CONSTRAINT FK_STUDENT_ID FOREIGN KEY (학번) REFERENCES 학생(학번);
ALTER TABLE 수강내역 ADD CONSTRAINT FK_LECTURE_ID_LECTAKEN FOREIGN KEY (과목번호) REFERENCES 과목(과목번호);

ALTER TABLE 강의내역 ADD CONSTRAINT FK_INSTRUCTOR_ID FOREIGN KEY (교수번호) REFERENCES 교수(교수번호);
ALTER TABLE 강의내역 ADD CONSTRAINT FK_LECTURE_ID_LECGIVEN FOREIGN KEY (과목번호) REFERENCES 과목(과목번호);
-- 제약조건 또한 한 스키마에 저장되는 객체이기 때문에 타 테이블이더라도 고유의 이름을 가져야 한다. 
-- 즉, 강의내역과 수강내역이 서로 같은 외부키로 제약조건을 걸어놓는다면 각각 제약조건의 이름이 달라야 함. 
commit;

/*     outer join 외부 조인 vs inner join 동등 조인 
*/
SELECT 학생.학번
    ,  학생.이름
    ,  수강내역.수강내역번호
FROM 학생,수강내역
WHERE 학생.학번 = 수강내역.학번(+) -- outer join 외부조인 --null 값도 포함 시킬 때 null 이 있는 쪽에 (+)
;

SELECT 학생.학번
    ,  학생.이름
    ,  수강내역.수강내역번호
FROM 학생,수강내역
WHERE 학생.학번 = 수강내역.학번 -- equal join 동등조인 
;

SELECT count(*)
FROM 학생,수강내역
WHERE 학생.학번 = 수강내역.학번 -- equal join 동등조인은 null 이 존재할 경우 포함하지 않는다.(output : 17)
;

SELECT count(*)
FROM 학생,수강내역
WHERE 학생.학번 = 수강내역.학번(+) -- outer join 외부조인 의 경우 null 이 존재하더라도 출력물에 추가할 수 있다. (output : 20) 
;

select *
FROM 학생 a,
     수강내역 b,
     과목 c
WHERE a.학번 = b.학번
AND b.과목번호 = c.과목번호;


--모든 학생의 수강내역건수를 출력하시오
SELECT a.이름,b."학번" , count(b.학번) as 수강내역건수
FROM 학생 a , 수강내역 b
where a."학번" = b."학번"(+)
group by a.이름 , b.학번
order by 3 desc;
-- 총량까지 구하기
select a.이름
,      count(b.수강내역번호) as 수강내역건수
FROM 학생 a, 수강내역 b
WHERE a.학번 = b.학번(+)
GROUP BY ROLLUP(a.이름);
--수강이력이 있는 학생의 수강 '학점' 합계를 출력하시오
select a.이름,
       SUM(학점) as 총학점
FROM 학생 a,
     수강내역 b,
     과목 c
WHERE a.학번 = b.학번
AND b.과목번호 = c.과목번호
group by a.이름
;
-- tip : 랜덤상수 DBMS_RANDOM


-- Team exercise TEAM 4 : 민은정, 신경호 , 배준호 , 주예슬
/* 주제 : 한 팀에 한개 
    -   데이터 모델링과 ERD
    -   데이터 이상현상과 정규화 
    -   SQL 과 No SQL
    -   ETL 과 DW(data warehouse)
    -   개인정보 보호법과 마이데이터
    -   빅데이터와 4차 산업혁명
    
    4/7 (금)
    -   주제에 대한 정의
    -   개념 설명
    -   사례 (or 실수)
    -   동향
    -   과거와 현재 ~ 
*/
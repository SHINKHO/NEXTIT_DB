

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION ALL  -- 각각의 조회 결과의 집합 
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';



SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION   -- 중복 제거 
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';



SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
MINUS  -- 차집합 
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
INTERSECT -- 교집합 
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';



SELECT goods, seq
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods, seq
FROM exp_goods_asia
WHERE country = '일본'
UNION 
SELECT 'hi', 1
FROM dual
UNION 
SELECT 'hi2', 2 -- 컬럼의 수와 타입이 같아야함 
FROM dual
ORDER by 2 ; -- 정렬 조건은 마지막 쿼리에만 가능 ;

-- member 생일 요일별 회원수를 출력하시오
SELECT TO_CHAR(mem_bir,'day') as 요일 
      ,COUNT(*)               as 회원수  
FROM member
GROUP BY ROLLUP(TO_CHAR(mem_bir,'day'));


--ORDER BY 2 DESC;
-- decode 
SELECT cust_name
     , cust_gender
     , DECODE(cust_gender, 'F', '여자', 'M', '남자','?') as gender
FROM customers;

/*   ROLLUP(expr1, expr2...) 
     expr로 명시한 표현식을 기준으로 집계한 결과를 출력 
     표현식의 수가 n 개이면 n+1레벨까지 집계됨 */
SELECT period
     , gubun
     , SUM(loan_jan_amt) total
FROM kor_loan_status 
WHERE period LIKE '2012%'
GROUP BY ROLLUP(period, gubun);
/* 
201310	기타대출	    676078     (3) 소계
201310	주택담보대출	411415.9   (3) 소계
201310	        	1087493.9  (2) 기간의 총계 
201311	기타대출   	681121.3   (3) 소계
201311	주택담보대출	414236.9   (3) 소계
201311		        1095358.2  (2) 기간의 총계 
             		2182852.1  (1) 총계 
 2개 컬럼 사용 + 1 = 총 3레벨 
(3) 월과 대출종류별 합계 
(2) 월별 합계 
(1) 전체 합계 

*/


SELECT period
     , SUM(loan_jan_amt) total
FROM kor_loan_status 
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period);

SELECT period
     , SUM(loan_jan_amt) total
FROM kor_loan_status 
WHERE period LIKE '2013%'
GROUP BY period
UNION 
SELECT  '전체'
       ,SUM(loan_jan_amt) total
FROM kor_loan_status 
WHERE period LIKE '2013%'

/*   INNER JOIN 내부조인 (동등조인) 
    a = b <-- 두값이 같을경우 행이 연결됨 
*/;
SELECT employees.emp_name
     , employees.department_id   as emp_dep_id
     , departments.department_id as dep_id
     , departments.department_name
FROM employees
    ,departments
WHERE employees.department_id = departments.department_id;
--   두테이블에 부서 id가 같을경우 조인됨. 


SELECT a.emp_name
     , a.department_id   as emp_dep_id
     , b.department_id as dep_id
     , b.department_name
FROM employees a    -- 테이블 별칭  AS(X)
    ,departments b
WHERE a.department_id = b.department_id;


SELECT *
FROM employees
    ,departments
WHERE employees.department_id = departments.department_id;





CREATE TABLE 강의내역 (
     강의내역번호 NUMBER(3)
    ,교수번호 NUMBER(3)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시  NUMBER(3)
    ,수강인원 NUMBER(5)
    ,년월 date
);

CREATE TABLE 과목 (
     과목번호 NUMBER(3)
    ,과목이름 VARCHAR2(50)
    ,학점 NUMBER(3)
);

CREATE TABLE 교수 (
     교수번호 NUMBER(3)
    ,교수이름 VARCHAR2(20)
    ,전공 VARCHAR2(50)
    ,학위 VARCHAR2(50)
    ,주소 VARCHAR2(100)
);

CREATE TABLE 수강내역 (
    수강내역번호 NUMBER(3)
    ,학번 NUMBER(10)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시 NUMBER(3)
    ,취득학점 VARCHAR(10)
    ,년월 DATE 
);

CREATE TABLE 학생 (
     학번 NUMBER(10)
    ,이름 VARCHAR2(50)
    ,주소 VARCHAR2(100)
    ,전공 VARCHAR2(50)
    ,부전공 VARCHAR2(500)
    ,생년월일 DATE
    ,학기 NUMBER(3)
    ,평점 NUMBER
);


COMMIT;



/*    
강의내역, 과목, 교수, 수강내역, 학생 테이블을 
만드시고 아래와 같은 제약 조건을 준 뒤 

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
-- 테이블 수정문 ALTER 
ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY(학번);
ALTER TABLE 수강내역 ADD CONSTRAINT PK_수강내역 PRIMARY KEY(수강내역번호);
ALTER TABLE 과목 ADD CONSTRAINT PK_과목 PRIMARY KEY(과목번호);
ALTER TABLE 교수 ADD CONSTRAINT PK_교수 PRIMARY KEY(교수번호);
ALTER TABLE 강의내역 ADD CONSTRAINT PK_강의내역 PRIMARY KEY(강의내역번호);


ALTER TABLE 수강내역 
ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
REFERENCES 학생(학번);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
REFERENCES 학생(학번);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
REFERENCES 학생(학번);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_수강_과목 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_강의_교수 FOREIGN KEY(교수번호)
REFERENCES 교수(교수번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_강의_과목 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);



SELECT 학생.학번 
     , 학생.이름 
     , 수강내역.수강내역번호 
FROM 학생
   , 수강내역 
WHERE 학생.학번 = 수강내역.학번 -- 동등조인, 이너조인 (같은 학번 행의 결합)

;
SELECT 학생.학번 
     , 학생.이름 
     , 수강내역.수강내역번호 
     , 수강내역.학번 
FROM 학생
   , 수강내역 
WHERE 학생.학번 = 수강내역.학번(+)
AND   학생.이름 = '양지운' ;      -- outer join외부조인 
                                -- null값도 포함 시킬때 (null이 있는쪽에 (+)


SELECT a.이름 , b.수강내역번호, c.과목이름 
FROM 학생 a
   , 수강내역 b
   , 과목 c
WHERE a.학번 = b.학번
AND   b.과목번호 =c.과목번호 ;

-- 모든 학생의 수강내역건수를 출력하시오 

SELECT a.이름 
     , COUNT(b.수강내역번호) as 수강내역건수 
FROM 학생 a
   , 수강내역 b
WHERE a.학번 = b.학번(+)
GROUP BY a.이름;

SELECT info_no 
     , nm 
FROM tb_info
WHERE nm != '이앞길';

--수강이력이 있는 학생의 '학점' 합계를 출력하시오 












/*
    1.수행쿼리 제출(sql 실습파일)  수요일
    2.서술형 (8~10 문제)         목요일(1시간) 
        - 개념문제 (3~4) SQL(4~5)
        
        EX) 데이터베이스 객체
        테이블(table) : DBMS상에서 가장 기본적인 객체로 
                       로우(행)컬럼(열)으로 구성된 2차원 
                       표 형태의 데이터를 저장하는 객체
                       테이블은 무결성(integrity)와 
                       일관성(consistency)를 보장하기위해
                       다양한 제약조건(constraints)을 가지고 있다.
                       이러한 제약 조건으 각 열의 데이터 형식,
                       고유한 값, NULL 값 허용 여부 등을 정의한다.
                       하나의 테이블은 하나의 이름을 가질 수 있으며
                       동일한 이름은 가질 수 없다.
        뷰(view) :   하나 이상의 테이블을 연결해 마치 테이블인 것처럼 
                    사용하는 객체
                    실제 데이터는 뷰를 구성하는 테이블에 담겨 있지만
                    테이블처럼 사용할 수 있다.
                    단일뷰와 복합뷰가 있다.
                    
                사용 목적에 : 
                    (1) 데이터 보안 : 특정사용자,특정컬럼만 사용할 수 있다.
                    (2) 편의성 : 복잡하거나 반복해서 사용해야 하는 SQL을
                                뷰로 만들어서 사용할 수 있다.
            CREATE OR REPLACE VIEW 뷰이름 AS
            사용 SELECT 문.
            
        시퀀스(Sequence) : 일련번호를 채번할때 사용되는 객체
                        테이블과 독립적으로 여러 곳에서 사용가능
                        pk를 설정할 후보키가 없거나, 특별히 의미있게
                        만들지 않아도 되는 경우 또는 자동으로 순차적인
                        번호가 필요한 경우 사용
                        증가시킬때는 시퀀스명.NEXTVAL
                        현재 시퀀스 번호는 시퀀스명.CURRVAL
        함수(function) : 특정연산을 하고 값을 반환하는 객체
                        PL/SQL로 작성하며 무조건 반환값이 1개 있어야 한다.
                        CREATE문으로 컴파일하며 DBMS 내에서 내장함수처럼 사용가능
                        SQL or PL/SQL 구문 어디서든 사용가능
        프로시저 (PROCEDURE) : 업무적으로 복잡한 구문을 작성하여 DB에 저장
                            고유한 기능을 수행하는 함수와 비슷하지만 
                            리턴값이 0 ~ n개 가능하다.
                            함수와 달리 SERVER 내부에서 실행됨
                            PL/SQL 구문에서 EXEC또는 다른 프로시져에서 실행 가능함. 
        시노님 (synonym) : 데이터베이스 객체에 대한 별칭을 부여한 객체 '동의어'란 뜻으로 동의어를
                         만드는 것. public과 private 시노님이 있다. 
                        - 사용 목적 
                         (1) 보안을 목적으로 객체의 이름을 숨기기 위해
                         (2) 객체의 이름을 단순화 or 개발의 편의성을 위해  

        SQL 종류
        DDL(DATA DEFINITION LANGUAGE) 데이터 정의어
            CREATE / ALTER / DROP / TRUNCATE
        DCL(DATA CONTROL LANGUAGE) 제이터 제어어
            GRANT / REVOKE
        DML(DATA MANIPULATION LANGUAGE) 데이터 조작어
            SELECT / INSERT / UPDATE / DELETE
        
        --계정 생성
        CREATE USER 계정명 IDENTIFIED BY 비밀번호
        --계정 권한
        GRANT CONNECT, RESOURCE TO 계정명 
        
        (롤 roll) : 다수의 사용자와 다양한 권한을 효과적으로 관리하기 위해 관련된 권한을 그룹화한 개념.
        
        --테이블생성
        CREATE TABLE 테이블명(
            컬멈명 타입(사이즈)
            ,ex_id NUMBER               -- 컬럼과 컬럼은 콤마(,) 로 구분한다.
            ,ex_nm VARCHAR(100)
        );
        
        --테이블 삭제 
        DROP TABLE 테이블명;
        DROP TABLE CASCADE CONSTRAINTS; <-- 다른곳에서 참조하는 테이블 삭제 
                                            제약조건도 제거 해야함.
        
        --테이블 수정
        ALTER TABLE 테이블명 RENAME COLUMN 컬럼명 TO 변경컬럼명;
        ALTER TABLE 테이블명 MODIFY 컬럼명 타입;
        ALTER TABLE 테이블명 ADD 컬럼명 타입;
        ALTER TABLE 테이블명 DROP 컬럼명;
        
        --TRUNCATE (rollback 불가)
        TRUNCATE TABLE 테이블명;
        
        DML 
        -- 데이터 조회 SELECT
        SELECT *
        FROM 테이블;
        
        SELECT 컬럼
        FROM 테이블
        WHERE 검색조건 ;
        
        -- 데이터 삽입 INSERT
        INSERT INTO 테이블명(컬럼명)
        VALUES( 값 ) 
        ex) 문자열 :'작은따옴표', 숫자 : 1, 날짜 : TO_DATE ('23.10.01','YY.MM.DD')
        
        -- 데이터 수정 UPDATE
        UPDATE 테이블
        SET 수정컬럼 = 변경값      --SET 에는 여러 컬럼의 수정값이 들어갈경우 AND 대신 콤마(,) 를 사용해 명시한다. 
            ,수정컬럼 = 변경값2    -- 모든 컬럼에 있는 데이터를 바꾸기 대문에 where 절을 잘 사용해야 한다.   
        WHERE 검색조건;
        
        --집계함수 
        SELECT 그룹,
                집계함수()
        FROM 테이블 
        GROUP BY 그룹; 
        
        -- INNER JOIN (EQUAL JOIN)
            SELECT 학생 *
            FROM 학생 a 
                ,수강내역 b
            WHERE a.학번 = b.학번
        -- OUTER JOIN
            SELECT 학생 *
            FROM 학생 a 
                ,수강내역 b
            WHERE a.학번 = b.학번(+)      -- (+) null 값이 포함될 쪽에 표시
        
        --ANSI JOIN
            --ANSI INNER
            SELECT *
            FROM 학생 a
            INNER JOIN 수강내역 b
            ON( a.학번 = b.학번)
            --ANSI OUTER FORM of  a = b(+)
            SELECT *
            FROM 학생 a
            LEFT JOIN 수강내역 b
            ON(a학번 = b.학번);
*/

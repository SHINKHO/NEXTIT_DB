SELECT TO_CHAR(SYSDATE, 'YYYYMMDD HH24:MI:SS')
FROM dual;
--문제 1번
--시작시간 : 20230412 13:58:20
--종료시간 : 20230412 14:00:14
CREATE TABLESPACE   TS_STUDY 
DATAFILE            '/u01/app/oracle/oradata/XE/ts_study.dbf'
SIZE                100M 
AUTOEXTEND ON NEXT  5M;
--문제 2번
--시작시간 : 20230412 14:00:14
--종료시간 : 20230412 14:01:58
CREATE USER             java2 
IDENTIFIED BY           oracle 
DEFAULT TABLESPACE      TS_STUDY
TEMPORARY TABLESPACE    TEMP;
--문제 3번
--시작시간 : 20230412 14:01:58
--종료시간 : 20230412 14:02:14
GRANT CONNECT TO    java2;
GRANT RESOURCE TO   java2;
--문제 4번
--시작시간 : 20230412 14:04:45
--종료시간 : 20230412 14:19:35
CREATE TABLE EX_MEM(
    MEM_ID      VARCHAR2(10)                NOT NULL,
    MEM_NAME    VARCHAR(20)                 NOT NULL,
    MEM_JOB     VARCHAR(30),
    MEM_MILEAGE NUMBER(8,2) DEFAULT 0,
    MEM_REG_DATE    DATE    DEFAULT SYSDATE,
    
    Constraint  pk_EX_MEM   Primary Key (MEM_ID)
    );
--문제 5번 
--시작시간 : 20230412 14:19:40
--종료시간 : 20230412 14:22:17
ALTER TABLE EX_MEM 
MODIFY      MEM_NAME VARCHAR2(50);

--문제 6번
--시작시간 : 20230412 14:22:50
--종료시간 : 20230412 14:28:31
CREATE SEQUENCE SEQ_CODE
INCREMENT BY    1
START WITH      1000
MINVALUE        1000
MAXVALUE        9999
CYCLE;
--문제 7번
--시작시간 : 20230412 14:28:35
--종료시간 : 20230412 14:32:08
INSERT 
INTO EX_MEM(
            MEM_ID,
            MEM_NAME,
            MEM_JOB,
            MEM_REG_DATE
            )
    VALUES(
            'hong',
            '홍길동',
            '주부',
            SYSDATE
            );
--문제 8번 
--시작시간 : 20230412 14:32:32
--종료시간 : 20230412 14:38:16
INSERT 
INTO EX_MEM(
            MEM_ID,
            MEM_NAME,
            MEM_JOB,
            MEM_MILEAGE,
            MEM_REG_DATE
            )
SELECT      MEM_ID,
            MEM_NAME,
            MEM_JOB,
            mem_mileage,
            SYSDATE 
FROM        member
WHERE       mem_like IN('독서','등산','바둑');
--문제 9번 
--시작시간 : 20230412 14:46:22
--종료시간 : 20230412 14:49:37
DELETE 
FROM    EX_MEM 
where   MEM_NAME LIKE '김%';
--문제 10번
--시작시간 : 20230412 14:49:58
--종료시간 : 20230412 14:51:38
SELECT  MEM_ID, 
        MEM_NAME, 
        MEM_JOB, 
        MEM_MILEAGE
FROM    member
WHERE   MEM_JOB IN '주부'
AND     MEM_MILEAGE >= 1000
AND     MEM_MILEAGE <= 3000
ORDER BY MEM_MILEAGE DESC;
--문제 11번
--시작시간 : 20230412 14:52:21
--종료시간 : 20230412 14:55:19
SELECT  PROD_ID,
        PROD_NAME,
        PROD_SALE
FROM    PROD
WHERE   PROD_SALE IN 23000
OR      PROD_SALE IN 26000
OR      PROD_SALE IN 33000;
--문제 12번 
--시작시간 : 20230412 14:55:43
--종료시간 : 20230412 15:04:26
SELECT  MEM_JOB,
        COUNT(MEM_ID) as MEM_CNT,
        TO_CHAR(MAX(MEM_MILEAGE),'FM999,999,999,999,999,999') as MAX_MLG,
        TO_CHAR(AVG(MEM_MILEAGE),'FM999,999,999,999,999,999') as AVG_MLG
FROM    member
GROUP BY
        MEM_JOB
HAVING  COUNT(MEM_ID) >=3;
--문제 13번
--시작시간 : 20230412 15:04:45
--종료시간 : 20230412 15:12:26
SELECT      a.MEM_ID,
            a.MEM_NAME,
            a.MEM_JOB,
            b.CART_PROD,
            b.CART_QTY
--            ,TO_DATE(SUBSTR(b.cart_no,1,8),'YYYYMMDD')
FROM member a,cart b
WHERE       a.MEM_ID = b.cart_member
AND         TO_DATE(SUBSTR(b.cart_no,1,8),'YYYYMMDD') 
            = TO_DATE('20050728','YYYYMMDD');
--문제 14번
--시작시간 : 20230412 15:12:53
--종료시간 : 20230412 15:15:25
SELECT      a.MEM_ID,
            a.MEM_NAME,
            a.MEM_JOB,
            b.CART_PROD,
            b.CART_QTY
FROM member a INNER JOIN cart b 
            ON(a.MEM_ID = b.cart_member)
WHERE       TO_DATE(SUBSTR(b.cart_no,1,8),'YYYYMMDD') 
            = TO_DATE('20050728','YYYYMMDD');
--문제 15번 
--시작시간 : 20230412 15:15:46
--종료시간 : 20230412 15:27:05
SELECT  MEM_ID,
        MEM_NAME,
        MEM_JOB,
        MEM_MILEAGE,
        RANK() OVER(PARTITION BY MEM_JOB ORDER BY MEM_MILEAGE DESC) as MEM_RANK
FROM member;
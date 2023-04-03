/*분석함수
    Partition by : 계산 대상그룹
    Order by : 대상 그룹 정렬
    Window : 파티션으로 분할된 그룹에 더 상세한 그룹 분할 시 사용.
*/

-- ROW_NUMBER
SELECT  department_id
    ,   emp_name
    ,   ROW_NUMBER() OVER(PARTITION BY department_id
                                      ORDER BY emp_name) as dep_row
FROM employees;

--RANK 동일 순위 있을시 건너뜀
--DENSE_RANK 건너 뛰지 않음.
SELECT  department_id,
        emp_name,
        salary,
        RANK() OVER(PARTITION BY department_id
                    ORDER BY salary DESC) as rank1,
        RANK() OVER(ORDER BY salary DESC) as all_rank,
        DENSE_RANK() OVER(PARTITION BY department_id
                    ORDER BY salary DESC) as rank2
FROM employees
WHERE department_id <500;

--전공별 1등만 출력하시오(학생테이블)
select * from(SELECT  RANK() OVER(PARTITION BY 전공 
                    ORDER BY 평점 DESC) as 순위,
        이름, 
        전공,
        평점
FROM 학생)
where 순위=1;
--풀이
SELECT *
FROM
(SELECT 이름,
        전공,
        평점,
        RANK() OVER(PARTITION BY 전공
                    ORDER BY 평점 DESC) as 순위
FROM 학생)
WHERE 순위 =1;
--직원의 부서벌 평균급여
--전체 평균 급여 
SELECT  round(AVG(salary) OVER(PARTITION BY department_id),2) as 부서평균,
        round(AVG(salary) OVER(),2) as 전체평균,
        salary,
        emp_name,
        department_id
FROM employees;

--2013년도 지역별 loan_jan_mat 합계 금액과 
--대출크기 순위를 출력하시오

SELECT  지역,지역별합계, rownum as 순위 
FROM
(SELECT  distinct region as 지역,
        CEIL(SUM(loan_jan_amt) OVER(PARTITION BY region)) as 지역별합계
FROM kor_loan_status order by 2 desc );
--풀이
select 지역,
        RANK() OVER(ORDER BY SUM(loan_jan_amt) DESC) as 랭킹
(SELECT region as 지역,
        SUM(loan_jan_amt) as amt
FROM kor_loan_status
WHERE period LIKE '%2013%'
group by region);

--풀이 2
SELECT  REGION
        , SUM(loan_jan_amt) as amt
        , RANK() OVER(ORDER BY SUM(loan_jan_amt) DESC) as rnk
FROM    kor_loan_status
WHERE   period LIKE '2013%'
GROUP BY region;

--NTILE(3) 함수는 정렬된 PARTITION 을 bucket(그룹)별로 나누고 
--배치하는 함수 (3은 버킷을 3개로 나눠 담음)
SELECT  department_id,
        emp_name,
        salary,
        NTILE(3) OVER(PARTITION BY department_id
                      ORDER BY salary) as ntiles
FROM employees
WHERE department_id IN(30,60);
-- 팀나누기, 테이블 생성
CREATE table ex_teams AS
SELECT  a.*,
        NTILE(6) OVER(ORDER BY DBMS_RANDOM.VALUE) as team
FROM(
SELECT info_no,nm
FROM tb_info
WHERE nm != '이앞길'
)a;
--확인
select * from ex_teams;

--WIDTH_BUCKET (COL,MIN, MAX,NO) 
--아래 예제 : salary 컬럼을 1000 에서 10000사이에서 4등분 하겠다.
SELECT  department_id,
        emp_name,
        WIDTH_BUCKET(salary,1000,10000,4) as buk
FROM    employees
WHERE   department_id =60;

--PERCENT_RANK() 백분위 수를 반환 0~1
SELECT  department_id, emp_name,
        salary,
        PERCENT_RANK() OVER(PARTITION BY department_id ORDER BY salary) as percent
FROM employees
WHERE department_id = 60;

--LAG 선행로우 반환, LEAD 후행로우 반환
SELECT  emp_name,
        salary,
        department_id,
-- (col,no,instaed) no 만큼의 앞,뒤에서부터 col 의 내용을 instead로 교체
-- col 의 type 과 instead 의 type은 같아야 한다. 
        LAG(emp_name,1,'가장높음') OVER(PARTITION BY department_id ORDER BY salary DESC) as lags,
        LEAD(emp_name,1,'가장낮음') OVER(PARTITION BY department_id ORDER BY salary DESC) as leads
FROM employees
WHERE department_id=30;

--전공별로 각 학생의 성적보다 한단계 높은 학생과의 평점 차이를 출력하시오
SELECT  학번,
        이름,
        주소,
        전공,
        rounda(평점,2),
        round(LAG(평점,1,평점) OVER (PARTITION BY 전공 
                                        ORDER BY 평점 DESC)-평점,2) as 평점차  
FROM 학생;
--풀이
SELECT 이름,전공,ROUND(평점,2) as 내평점,
        LAG(이름,1,'나다') OVER(PARTITION BY 전공
                                ORDER BY 평점 DESC) as 나보다위,
        ROUND(LAG(평점,1,평점) OVER(PARTITION BY 전공
                                    ORDER BY 평점 DESC) - 평점 ,2) as 평점차이
FROM 학생;

/* windoww 절
    ROWS : 로우 (행) 단위로 window 지정
    RANGE : 논리적인 범위로 windows 지정
    preceding (처음)
    current row(현재 행)
    following (끝지점)
*/
SELECT  department_id, emp_name, hire_date, salary,
        SUM(salary) OVER(PARTITION BY department_id
                        ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED 
                        PRECEDING AND CURRENT ROW) as first_current,
        SUM(salary) OVER(PARTITION BY department_id
                        ORDER BY hire_date
                        ROWS BETWEEN CURRENT ROW
                        AND UNBOUNDED FOLLOWING) as current_last
FROM employees
WHERE department_id =30;
SELECT  department_id, emp_name, hire_date, salary,
        SUM(salary) OVER(PARTITION BY department_id
                        ORDER BY hire_date
                        ROWS BETWEEN 1 --한행 위
                        PRECEDING AND CURRENT ROW) as one_current,
        SUM(salary) OVER(PARTITION BY department_id
                        ORDER BY hire_date
                        ROWS BETWEEN CURRENT ROW
                        AND 2 FOLLOWING) as two_last, --두행 뒤
        SUM(salary) OVER(PARTITION BY department_id
                        ORDER BY hire_date
                        ROWS BETWEEN 1 PRECEDING
                        AND 1 FOLLOWING) as before1_after1
FROM employees
WHERE department_id =30;
--sales 1998년도 월별 누적 집계를 출력하시오
-- 1~ 12월 (amout_sold)
SELECT  
    OVER(PARTITION BY a.TO_CHAR(sales_date,'MM') 
    ORDER BY sum(amount_sold)
    ROWS BETWEEN CURRENT ROW 
    AND UNBOUNDED FOLLOWING) as 월별누적집계
FROM(
    SELECT  TO_CHAR(sales_date,'YYYYMM'),
            SUM(amount_sold) 
    FROM    sales
    WHERE   TO_CHAR(sales_date,'YYYY')='1998'
    GROUP BY TO_CHAR(sales_date,'YYYYMM')
)a;

--풀이
SELECT sales_month,
        amt,
        SUM(amt) OVER(ORDER BY sales_month
                    ROWS BETWEEN UNBOUNDED PRECEDING
                    AND CURRENT ROW) as 누적합
FROM(
SELECT sales_month,
        SUM(amount_sold) as amt
FROM sales
WHERE sales_month LIKE '1998%'
GROUP BY sales_month
);

--행의 비율 
SELECT  sales_month,
        amt,
        ROUND(RATIO_TO_REPORT(amt) OVER() * 100,2) ||'%'as ratio
FROM(
        SELECT sales_month,
                SUM(amount_sold) as amt
        FROM sales
        WHERE sales_month LIKE '1998%'
        GROUP BY sales_month
);

--대전,서울,세종의 지역별,대출종류별,
--월별 대출잔액과 지역별 파티션을 만들어 대출종류별 대출잔액의 %를 구하는 쿼리를 작성해보자
--( 201210, 201211, 201310, 201311)
/*output
REGION      GUBUN       201210          201211           201310       201311
대전         기타대출     17225.4(61%)    17347.9(61%)    18559(60%)    18833.4(61%)
대전        주택담보대출   11169.9(39%)    11210(30%)      12126(40%)    12285.7(39%)
서울          기타대출    202557.1(61%)   202887.5(61%)   2004918.8(62%) 205644.3(62%)
세종          기타대출    1655.1(65%)     1766.3(64%)     2583.7(62%)     2653.4(62%)
세종        주택담보대출   907.6(35%)      1002.9(36%)      1557.8(38%)     1611.4(38%)
*/SELECT * 
    FROM
    (SELECT  region,
            gubun,
            period,
            amt,
            row_number() over(partition by region,gubun order by period) as partitioned
            
    FROM
        (SELECT  region,
                gubun,
                period,
                SUM(loan_jan_amt) amt 
        FROM kor_loan_status
        group by region,gubun,period
        having period in('201210','201211','201310','201311') 
        and region in ('대전','서울','세종')
        order by period desc) a
    ) b
    WHERE partitioned = 1 and region = '대전'
;

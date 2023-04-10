DECLARE
    vn_Floor NUMBER := :num;
    vn_star1 VARCHAR2(10000);
    vn_line1 VARCHAR2(10000);
    vn_linec NUMBER;
BEGIN
    --making first floor
    FOR i IN 1..vn_Floor LOOP
        vn_line1 := vn_line1||'=';
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(vn_line1||'★'||vn_line1);
    
    --making n floors
    FOR i IN 1..vn_Floor LOOP
        vn_linec := vn_Floor/2;
        vn_line1 := '';
        FOR j IN i..vn_Floor LOOP
        vn_line1 := vn_line1 || '=';
        END LOOP;
        vn_star1 := vn_star1 || '*';
        DBMS_OUTPUT.PUT_LINE(vn_line1||vn_star1||vn_star1||vn_line1);
    END LOOP;
END;

--풀이
vn_j := vn_num;
FOR i in 1...vn_num
LOOP
    vs_space :='';
    vs_start := vs_star || '*';
    FOR j IN 1..vn_j
    LOOP
        vs_spcaer := vs_space ||'=';
    END LOOP;
    vn_j := vn_j-1 ; -- 반복 될대마다 -1
    --프린트 출력
    IF i=1 THEN
        DBMS_OUTPUT_PUT_LINE(vs_space || '*' ||vs_spcae);
    END IF;
        BMS_OUTPUT.PUT_LINE(vs_space || vs_star ||vs_space);
    END LOOP;
DECLARE
    vn_Floor NUMBER := :num;
    vn_star1 VARCHAR2(10000);
    vn_line1 VARCHAR2(10000);
    vn_linec NUMBER;
BEGIN
    --making first floor
    FOR i IN 0..vn_Floor LOOP
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

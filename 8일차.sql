SET SERVEROUT ON;

--선택문 : 명령을 선택하여 실행하기 위한 구문
--IF : 조건식에 의해 명령을 선택 실행
--형식)IF(조건식) THEN 명령;명령;... END IF;
--조건식의 ( )기호 생략 가능

--EMP 테이블에서 사원번호 7788인 사원의 사원번호,사원이름,부서번호를 검색하여 사원번호,사원이름,부서번호에 대한
--부서명을 출력하는 PL/SQL 작성
--부서번호에 대한 부서명 : 10(ACCOUNTING),20(RESEARCH),30(SALES),40(OPERATION)
DECLARE
    VEMP EMP%ROWTYPE; /* 레코드 변수 선언 */
    VDNAME VARCHAR2(20) := NULL;  /* 스칼라 변수 선언 */
BEGIN
    SELECT * INTO VEMP FROM EMP WHERE EMPNO=7788;
    
    IF(VEMP.DEPTNO=10) THEN
        VDNAME := 'ACCOUNTING';
    END IF;    
    
    IF(VEMP.DEPTNO=20) THEN
        VDNAME := 'RESEARCH';
    END IF;    

    IF(VEMP.DEPTNO=30) THEN
        VDNAME := 'SAELS';
    END IF;    

    IF(VEMP.DEPTNO=40) THEN
        VDNAME := 'OPERATION';
    END IF;    

    DBMS_OUTPUT.PUT_LINE('사원번호 = '||VEMP.EMPNO);
    DBMS_OUTPUT.PUT_LINE('사원이름 = '||VEMP.ENAME);
    DBMS_OUTPUT.PUT_LINE('부서이름 = '||VDNAME);
END;
/

--형식)IF(조건식) THEN 명령;명령;... ELSE 명령;명령;... END IF;

--EMP 테이블에서 사원번호 7788인 사원의 사원번호,사원이름,연봉을 출력하는 PL/SQL 
--사원연봉: (급여+성과급)*12
DECLARE
    VEMP EMP%ROWTYPE;
    ANNUAL NUMBER(7,2) := 0;
BEGIN
    SELECT * INTO VEMP FROM EMP WHERE EMPNO=7788;
    
    IF VEMP.COMM IS NULL THEN
        ANNUAL := VEMP.SAL + 12;
    ELSE
        ANNUAL := (VEMP.SAL + VEMP.COMM)*12;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 = '||VEMP.EMPNO);
    DBMS_OUTPUT.PUT_LINE('사원이름 = '||VEMP.ENAME);
    DBMS_OUTPUT.PUT_LINE('연봉 = '||ANNUAL);
 
 END;
 /
 
--형식)IF(조건식) THEN 명령;명령;... ELSIF(조건식) 명령;명령;... [ELSE 명령;명령;...] END IF;

--EMP 테이블에서 사원번호 7788인 사원정보를 검색하여 사원번호,사원이름,부서번호에 대한 부서명을 출력하는 PL/SQL 작성
--부서번호에 대한 부서명 : 10(ACCOUNTING),20(RESEARCH),30(SAELS),40(OPERATION)
DECLARE
    VEMP EMP%ROWTYPE;
    VDNAME VARCHAR2(20) := NULL;
BEGIN
    SELECT * INTO VEMP FROM EMP WHERE EMPNO=7788;
    
    IF(VEMP.DEPTNO=10) THEN
        VDNAME := 'ACCOUNTING';
    ELSIF(VEMP.DEPTNO=20) THEN
        VDNAME := 'RESEARCH';
    ELSIF(VEMP.DEPTNO=30) THEN
        VDNAME := 'SAELS';
    ELSIF(VEMP.DEPTNO=40) THEN
        VDNAME := 'OPERATION';
    END IF;    

    DBMS_OUTPUT.PUT_LINE('사원번호 = '||VEMP.EMPNO);
    DBMS_OUTPUT.PUT_LINE('사원이름 = '||VEMP.ENAME);
    DBMS_OUTPUT.PUT_LINE('부서이름 = '||VDNAME);
END;
/

--CASE : 변수에 저장된 값을 비교하여 명령을 선택 실행하거나 조건식을 사용하여 명령을 선택 실행하는 구문
--형식)CASE 변수명 WHEN 비교값1 THEN 명령;명령;... WHEN 비교값2 THEN 명령;명령;... END CASE;

--EMP 테이블에서 사원번호 7788인 사원정보를 검색하여 사원번호,사원이름,업무,급여,업무별 급여 실지급액을 계산하여 출력하는 PL/SQL 작성
--업무별 급여 실지급액 - ANALYST : 급여*1.1, CLERK: 급여*1.2 , MANAGER : 급여*1.3 PRESIDENT : 급여*1.4, SALESMAN : 급여*1.5
DECLARE
    VEMP EMP%ROWTYPE;
    VPAY NUMBER(7,2);
BEGIN
    SELECT * INTO VEMP FROM EMP WHERE EMPNO=7788;
    
    CASE VEMP.JOB
        WHEN 'ANALYST' THEN
            VPAY := VEMP.SAL * 1.1;
        WHEN 'CLERK' THEN
            VPAY := VEMP.SAL * 1.2;
        WHEN 'MANAGER' THEN
            VPAY := VEMP.SAL * 1.3;
        WHEN 'PRESIDENT' THEN
            VPAY := VEMP.SAL * 1.4;
        WHEN 'SALESMAN' THEN
            VPAY := VEMP.SAL * 1.5;
        END CASE;
        
    DBMS_OUTPUT.PUT_LINE('사원번호 = '||VEMP.EMPNO);
    DBMS_OUTPUT.PUT_LINE('사원이름 = '||VEMP.ENAME);
    DBMS_OUTPUT.PUT_LINE('업무 = '||VEMP.JOB);
    DBMS_OUTPUT.PUT_LINE('부서이름 = '||VEMP.SAL);
    DBMS_OUTPUT.PUT_LINE('실지급액 = '||VPAY);
END;
/        

--형식)CASE WHEN 조건식1 THEN 명령;명령;... WHEN 조건식2 THEN 명령;명령;... END CASE;

--EMP 테이블에서 사원번호가 7788인 사원정보를 검색하여 사원번호,사원이름,급여,급여등급을 계산하여 출력하는 PL/SQL 작성
--급여등급 : E(0~1000),D(1001~2000),C(2001~3000),B(3001~4000),A(4001~5000)
DECLARE
    VEMP EMP%ROWTYPE;
    VGRADE VARCHAR2(1);
BEGIN
    SELECT * INTO VEMP FROM EMP WHERE EMPNO=7788;
    
    CASE 
        WHEN VEMP.SAL BETWEEN 0 AND 1000 THEN
            VGRADE := 'E';
        WHEN VEMP.SAL BETWEEN 1001 AND 2000 THEN
            VGRADE := 'D';
        WHEN VEMP.SAL BETWEEN 2001 AND 3000 THEN
            VGRADE := 'C';
        WHEN VEMP.SAL BETWEEN 3001 AND 4000 THEN
            VGRADE := 'B';
        WHEN VEMP.SAL BETWEEN 4001 AND 5000 THEN
            VGRADE := 'A';
        END CASE;
        
    DBMS_OUTPUT.PUT_LINE('사원번호 = '||VEMP.EMPNO);
    DBMS_OUTPUT.PUT_LINE('사원이름 = '||VEMP.ENAME);
    DBMS_OUTPUT.PUT_LINE('업무 = '||VEMP.JOB);
    DBMS_OUTPUT.PUT_LINE('부서이름 = '||VEMP.SAL);
    DBMS_OUTPUT.PUT_LINE('실지급액 = '||VGRADE);
END;
/

--반복문 : 명령을 반복 실행하기 위한 구문

--BASIC LOOP : 무한반복 - 선택문을 사용하여 EXIT 명령으로 조건식이 참인 경우 반복문 종료
--형식)LOOP 명령;명령;... END LOOP;

--1!~5 범위의 숫자값을 출력하는 PL/SQL 작성
DECLARE
    I NUMBER(1) := 1;
BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        IF I > 5 THEN
            EXIT;
        END IF;
    END LOOP;
END;
/

--FOR LOOP : 반복의 횟수가 정해져 있는 경우 사용하는 반복문
--형식)FOR INDEX_COUNTER IN [REVERSE] LOWER_BOUND..HIGH_BOUND LOOP 명령;명령;... END LOOP;

--1~10 범위의 정수들의 합계를 계산하여 출력하는 PL/SQL 작성
DECLARE
    /* FOR LOOP 구문에서 생성되는 변수(INDEX_COUNTER)는 FOR LOOP 구문에서만 사용 가능 */
    TOT NUMBER(2) := 0;
BEGIN 
    FOR I IN 1..10 LOOP 
        TOT := TOT + I;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('1~10 범위의 정수들의 합계 = '||TOT);
END;
/

--FOR LOOP 구문을 이용하여 테이블의 다중 검색행에 대한 반복 처리 - 내부적 커서(CURSOR)를 사용하여 반복처리
--형식)FOR RECORD_VARIABLE IN (SELECT 검색대상,검색대상,... FROM 테이블명 [WHERE 조건식]) LOOP 명령;명령;... END LOOP;
--다중 검색행을 하나씩 전달받아 레코드 변수에 저장하여 반복 처리

--EMP 테이블에 저장된 모든 사원정보를 검색하여 사원번호,사원이름을 출력하는 PL/SQL 작성
BEGIN
    FOR VEMP IN (SELECT * FROM EMP) LOOP
        DBMS_OUTPUT.PUT_LINE('사원번호 = '||VEMP.EMPNO||', 사원이름 = '||VEMP.ENAME);
    END LOOP;
END;
/

--커서(CURSOR) : 테이블의 검색행을 저장하여 처리하기 위한 기능을 제공
--1.묵시적 커서 : 검색결과가 단일행이 경우를 처리하기 위한 커서
--2.명시적 커서 : 검색결과가 다중행인 경우를 처리하기 위한 커서 - 커서(CURSOR)를 생성하여 OPEN,FETCH,CLOSE 명령으로 커서 사용

--명시적 커서의 선언 방법 및 사용
--형식) DELCARE
--          CURSOR 커서명 IS SELECT 검색대상,... FROM 테이블명 [WHERE 조건식];
--     BEGIN
--          OPEN 커서명; /* 커서를 사용하기 위한 열기 작업 */
--          FETCH 커서명 INTO 변수명,변수명,...; /* 커서에 저장된 검색행을 제공받아 변수에 저장 */
--          CLOSE 커서명; /* 커서를 더이상 사용하지 않기 위해 커서 닫기 */
--     END;

--DEPT 테이블에 저장된 모든 부서정보를 검색하여 부서번호,부서이름,부서위치를 출력하는 PL/SQL 작성
DECLARE
    CURSOR C IS SELECT * FROM DEPT;
    VDEPT DEPT%ROWTYPE;
BEGIN
    /* 커서 열기 - 첫번째 섬색행을 제공받기 위해 커서위치 이동 */
    OPEN C;
    
    LOOP
        /* 현재 커서의 위치에 존재하는 검색행을 제공받아 레코드 변수에 저장 - 커서는 다음행으로 자동 이동 */
        FETCH C INTO VDEPT; 
        EXIT WHEN C%NOTFOUND; /* 커서의 위치에 더이상 검색행이 없는 경우 반복문 종료  */
        DBMS_OUTPUT.PUT_LINE('부서번호 = '||VDEPT.DEPTNO||', 부서이름 = '||VDEPT.DNAME||', 부서위치 = '||VDEPT.LOC);
    END LOOP;
    
    /* 커서 닫기 */
    CLOSE C;
END;
/

--DEPT 테이블에 저장된 모든 부서정보를 검색하여 부서번호,부서이름,부서위치를 출력하는 PL/SQL 작성
BEGIN  
    /* 선언부에서 커서를 생성하지 않고 FOR LOOP 구문에서 SELECET 명령을 직접 사용하여 검색행을 반복 처리 가능 */
    FOR VDEPT IN (SELECT * FROM DEPT) LOOP
        DBMS_OUTPUT.PUT_LINE('부서번호 = '||VDEPT.DEPTNO||', 부서이름 = '||VDEPT.DNAME||', 부서위치 = '||VDEPT.LOC);
    END LOOP;
END;
/

--WHILE LOOP ; 반복의 횟수가 부정확한 경우 사용하는 반복문
--형식)WHILE 조건식 LOOP 명령;명령;... END LOOP;

--1~10 범위의 정수들의 합계를 계산하여 출력하는 PL/SQL 작성
DECLARE
    I NUMBER(2) :=1;
    TOT NUMBER(2) :=0;
BEGIN
    WHILE I <= 10 LOOP
        TOT := TOT + I;
        I := I+1;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('1~10 범위의 정수들의 합계 = '||TOT);
END;
/

--저장 프로시저(STORED PROCEDURE) : PL/SQL 프로시저에 이름을 부여하여 저장하고 필요한 경우 호출하여 사용하는 기능
--형식)CREATE (OR REPLACE) PROCEDURE 프로시저명[(매개변수 [MODE] 자료형,...)]
--      IS [변수선언부] BEGIN 명령;명령;... END;

--EMP 테이블에 저장된 모든 사원정보를 삭제하는 저장 프로시저 생성
CREATE OR REPLACE PROCEDURE DELETE_ALL_EMP2 IS
BEGIN 
    DELETE FROM EMP2;
    COMMIT;
END;
/

--저장 프로시저 확인 -USER_SOURCE : 저장 프로시저와 저장 함수 정보를 제공하는 딕셔너리
SELECT NAME,TEXT FROM USER_SOURCE WHERE NAME='DELETE_ALL_EMP2';

--저장 프로시저 호출 - 저장 프로시저에 작성된 PL/SQL 명령 실행
--형식)EXECUTE 프로시저[([변수|값],[변수|값],...)]

--DELETE_ALL_EMP2 저장 프로시저 호출
EXECUTE DELETE_ALL_EMP2;
SELECT * FROM EMP2;

--저장 프로시저 생성시 컴파일 에러가 발생된 경우 컴파일 로그 확인
SHOW ERROR;

--저장 프로시저 삭제
--형식)DROP PROCEDURE 프로시저명

--DELETE_ALL_EMP2 저장 프로시저 삭제
DROP PROCEDURE DELETE_ALL_EMP2;
SELECT NAME,TEXT FROM USER_SOURCE WHERE NAME='DELETE_ALL_EMP2';

--저장 프로시저의 매개변수 모드(MODE)
--1.IN : 외부의 값을 저장 프로시저로 전달받아 PL/SQL 명령에서 사용할 목적의 매개변수를 선언할 때 사용 - 저장 프로시저 호출시 값 전달
--2.OUT : PL/SQL 명령의 실행 결과값을 저장 프로시저의 외부로 제공할 목적으로 매개변수를 선언할 때 사용 - 저장 프로시저 호출시 바인딩 변수 전달
--3.INOUT : IN모드와 OUT모드를 모두 제공하는 매개변수를 선언할 때 사용 - 저장 프로시저 호출시 바인딩 변수(값) 전달

--사원번호를 매개변수로 전달받아 EMP 테이블에서 해당 사원번호의 사원정보를 검색하여 사원이름,업무,급여를 매개변수로 사용하여 외부로 제공하는 저장 프로시저 생성
--외부로 제공하는 저장 프로시저 생성
CREATE OR REPLACE PROCEDURE SELECT_EMPNO(VEMPNO IN EMP.EMPNO%TYPE,VENAME OUT EMP.ENAME%TYPE,VJOB OUT EMP.JOB%TYPE,
    VSAL OUT EMP.SAL%TYPE) IS
BEGIN
    SELECT ENAME,JOB,SAL INTO VENAME,VJOB,VSAL FROM EMP WHERE EMPNO=VEMPNO;
END;
/

--OUT 모드의 매개변수에 의해 제공되는 값을 저장하기 위한 바인딩 변수 선언 방법
--형식)VARIABLE 바인딩변수명 자료형
--바인딩 변수 : 현재 접속 세션에서만 사용할 수 있는 시스템 변수 - 다수의 저장 프로시저에서 필요한 값을 전달하거나 전달받기 위해 사용
VARIABLE VAR_ENAME VARCHAR2(15);
VARIABLE VAR_JOB VARCHAR2(20);
VARIABLE VAR_SAL NUMBER;

--SELECT_EMPNO 저장 프로시저 호출 - IN 모드의 매개변수를 값을 전달하고 OUT 모드의 매개변수에는 바인딩 변수 전달하여 호출
--OUT 모드의 매개변수를 사용하여 바인딩 변수에 값을 저장할 경우 바인딩 변수명 앞에 :를 붙여서 사용
EXECUTE SELECT_EMPNO(7788,:VAR_ENAME,:VAR_JOB,:VAR_SAL);

--바인딩 변수에 저장된 값 출력
--형식)PRINT 바인딩변수명
PRINT VAR_ENAME;
PRINT VAR_JOB;
PRINT VAR_SAL;

--저장 함수(STORED FUNCTION) : 저장 프로시저와 유사한 기능을 제공하지만 반드시 하나의 결과값을 반환
--형식)CREATE [OR REPLACE] FUNCTION 저장함수명[(매개변수 [모드] 자료형,매개변수 [모드] 자료형,...)]
--    RETURN 자료형 IS (변수선언부) BEGIN 명령;명령;... RETURN 결과값; END;

--사원번호를 매개변수로 전달받아 EMP 테이블에서 해당 사원번호의 사원정보를 검색하여 급여에 2배에 해당하는 결과값을 반환하는 저장함수 생성
CREATE OR REPLACE FUNCTION CALCULATE_SAL(VEMPNO IN EMP.EMPNO%TYPE) RETURN NUMBER IS 
    VSAL NUMBER(7,2);
BEGIN
    SELECT SAL INTO VSAL FROM EMP WHERE EMPNO=VEMPNO;
    RETURN(VSAL*2.0);
END;
/

--저장 함수 확인 - USER_SOURCE 딕셔너리
SELECT NAME,TEXT FROM USER_SOURCE WHERE NAME='CALCULATE_SAL';

--저장 함수의 반환값을 저장하기 위한 바인딩 변수 선언
VARIABLE VAR_SAL NUMBER;

--저장 함수 호출 - 저장 함수의 반환값을 바인딩 변수에 저장
EXECUTE :VAR_SAL := CALCULATE_SAL(7788);

--바인딩 변수에 저장된 값 출력
PRINT VAR_SAL;

--저장 함수는 SQL 명령에 포함하여 사용 가능
SELECT EMPNO,ENAME,SAL,CALCULATE_SAL(EMPNO) "특별수당" FROM EMP;

--저장 함수 삭제
--형식)DROP FUNCTION 저장함수명

--CALCULATE_SAL 저장 함수 삭제
DROP FUNCTION CALCULATE_SAL;
SELECT NAME,TEXT FROM USER_SOURCE WHERE NAME='CALCULATE_SAL';

--트리거(TRIGGER) : 특정 SQL 명령(DML)이 실행될 경우 PL/SQL 프로시저의 명령을 실행하는 기능

--트리거 생성
--형식)CREATE (OR REPLACE) TRIGGER 트리거명 [BEFORE|AFTER] [INSERT|UPDATE|DELETE] ON 테이블명
--  [FOR EACH ROW] [WITH 조건식] BEGIN 명령;명령;...END;
--FOR EACH ROW : 생략된 경우 문장 레벨 트리거를 생성하고 선언한 경우 행 레벨 트리거로 생성
--문장 레벨 트리거 : 이벤트 DML 명령이 실행되면 트리거에 작성된 PL/SQL 프로시저의 명령을 한번만 실행
--행 레벨 트리거 : 이벤트 DML 명령이 실행되면 트리거에 작성된 PL/SQL 프로시저의 명령을 행의 갯수만큼 실행
--트리거에 등록된 PL/SQL 프로시저 명령에는 TCL 명령(COMMIT 또는 ROLLBACK) 사용 불가능

--SAWON 테이블에서 사원정보가 삽입될 경우 메세지를 출력하는 트리거 생성
CREATE OR REPLACE TRIGGER SAWON_INSERT AFTER INSERT ON SAWON
BEGIN
    DBMS_OUTPUT.PUT_LINE('새로운 사원이 입사하였습니다.');
END;
/

--트리거 확인 - USER_TRIGGERS : 트리거 정보를 제공하는 딕셔너리
SELECT TRIGGER_NAME,TRIGGER_TYPE,TRIGGERING_EVENT,TABLE_NAME FROM USER_TRIGGERS;


SELECT * FROM SAWON;
INSERT INTO SAWON VALUES(3000,'전우치',10);
SELECT * FROM SAWON;
COMMIT;

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,급여,부서번호를 검색하여 EMP_TRI 테이블을 생성하여 검색행을 삽입
CREATE TABLE EMP_TRI AS SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP;
SELECT * FROM EMP_TRI;

--EMP_HIS 테이블 생성 - 사원번호(숫자형),사원이름(문자형),사원상태(문자형)
CREATE TABLE EMP_HIS(NO NUMBER(4),NAME VARCHAR2(20),STATUS VARCHAR2(50));

--EMP_TRI 테이블에서 행을 삽입하거나 변경 또는 삭제한 경우 명령 실행 후 행 삽입,변경,삭제에 대한 이유를 
--EMP_HIS 테이블에 행으로 삽입하는 트리거 생성
CREATE OR REPLACE TRIGGER INSERT_EMP_HIS AFTER INSERT OR UPDATE OR DELETE ON EMP_TRI FOR EACH ROW
BEGIN
    /* :NEW.컬럼명 - 이벤트가 발생된 테이블의 삽입 또는 변경 명령에서 사용된 새로운 행의 컬럼값 표현 */
    /* :OLD.컬럼명 - 이벤트가 발생된 테이블의 변경 또는 삭제 명령에서 사용된 기존 행의 컬럼값 표현 */
    IF INSERTING THEN
        INSERT INTO EMP_HIS VALUES(:NEW.EMPNO,:NEW.ENAME,'입사');
    ELSIF UPDATING THEN 
        IF :NEW.DEPTNO <> :OLD.DEPTNO THEN 
            INSERT INTO EMP_HIS VALUES(:OLD.EMPNO,:OLD.ENAME,'부서이동');
        ELSE
            INSERT INTO EMP_HIS VALUES(:OLD.EMPNO,:OLD.ENAME,'개인사유');
        END IF;
    ELSIF DELETING THEN
        INSERT INTO EMP_HIS VALUES(:OLD.EMPNO,:OLD.ENAME,'퇴사');
    END IF;
END;
/

--트리거 확인
SELECT TRIGGER_NAME,TRIGGER_TYPE,TRIGGERING_EVENT,TABLE_NAME FROM USER_TRIGGERS;
INSERT INTO EMP_TRI VALUES(5000,'PARK',2000,10);
SELECT * FROM EMP_TRI WHERE EMPNO=5000;
SELECT * FROM EMP_HIS;

--EMP_TRI 테이블에 행 삽입 - 트리거에 의해 EMP_HIS 테이블에 행 삽입 : 부서이동 또는 개인사유
UPDATE EMP_TRI SET DEPTNO=20 WHERE EMPNO=5000;
SELECT * FROM EMP_TRI WHERE EMPNO=5000;
SELECT * FROM EMP_HIS;
UPDATE EMP_TRI SET SAL=2500 WHERE EMPNO=5000;
SELECT * FROM EMP_TRI WHERE EMPNO=5000;
SELECT * FROM EMP_HIS;

--EMP_TRI 테이블에 행 삭제 - 트리거에 의해 EMP_HIS 테이블에 행 삽입 : 퇴사
DELETE FROM EMP_TRI WHERE EMPNO=5000;
SELECT * FROM EMP_TRI WHERE EMPNO=5000;
SELECT * FROM EMP_HIS;
DELETE FROM EMP_TRI WHERE SAL<2000;
SELECT * FROM EMP_TRI;
SELECT * FROM EMP_HIS;
COMMIT;


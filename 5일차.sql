--MANAGER 테이블 생성 - 사원번호(숫자형),사원이름(문자형),입사일(날짜형-기본값:현재),급여(숫자형-기본값:1000)
CREATE TABLE MANAGER(NO NUMBER(4),NAME VARCHAR2(20),STARTDATE DATE DEFAULT SYSDATE,PAY NUMBER DEFAULT 1000);

--테이블 목록 및 구조 확인
SELECT TABLE_NAME FROM USER_TABLES;
DESC MANAGER;

--USER_TAB_COLUMNS : 테이블의 컬럼 정보를 제공하는 딕셔너리
SELECT COLUMN_NAME,DATA_DEFAULT FROM USER_TAB_COLUMNS WHERE TABLE_NAME='MANAGER';

--MANAGER 테이블에 행 삽입 - 컬럼 생략 : 생략된 컬럼에는 기본값이 전달되어 삽입 처리
INSERT INTO MANAGER(NO,NAME) VALUES(1000,'홍길동');
SELECT * FROM MANAGER;
COMMIT;

--DEFAULT 키워드를 사용하여 기본값을 제공받아 삽입 처리
INSERT INTO MANAGER VALUES(2000,'임꺽정',DEFAULT,DEFAULT);
SELECT * FROM MANAGER;
COMMIT;

--제약조건(CONSTRAINT) : 컬럼에 비정상적인 값이 저장되는 것을 방지하기 위한 기능 - 데이타 무결성 유지
--컬럼 수준의 제약조건 : 테이블의 속성 선언시 컬럼에 제약조건을 설정
--테이블 수준의 제약조건 : 테이블 선언시 테이블의 특정 컬럼에 제약조건을 설정

--CHECK : 컬럼값에 대한 조건을 제공하여 조건에 맞는 값만 저장되도록 설정하는 제약조건
--컬럼 수준의 제약조건 또는 테이블 수준 제약조건으로 설정 가능

--SAWON1 테이블 생성 - 사원번호(숫자형),사원이름(문자형),급여(숫자형)
CREATE TABLE SAWON1(NO NUMBER(4),NAME VARCHAR2(20),PAT NUMBER);

--SAWON1 테이블에 행 삽입 - 모든 숫자값이 급여(PAY)에 전달되어 삽입 처리 가능
INSERT INTO SAWON1 VALUES(1000,'홍길동',8000000);
INSERT INTO SAWON1 VALUES(2000,'임꺽정',800000);
SELECT * FROM SAWON1;
COMMIT;

--SAWON2 테이블 생성 - 사원번호(숫자형),사원이름(문자형),급여(숫자형 - 최소급여:5000000)
--컬럼수준의 제약조건 : CHECK 제약조건을 설정하는 컬럼만으로 CHECK 제약조건의 조건식 작성
CREATE TABLE SAWON2(NO NUMBER(4),NAME VARCHAR2(20),PAY NUMBER CHECK(PAY>=5000000));

--SAWON2 테이블에 행 삽입
INSERT INTO SAWON2 VALUES(1000,'홍길동',8000000);
INSERT INTO SAWON2 VALUES(2000,'임꺽정',800000);--CHECK 제약조건을 위반하여 에러 발생
SELECT * FROM SAWON2;
COMMIT;

--USER_CONSTRAINTS : 테이블에 설정된 제약조건을 제공하는 딕셔너리
--CONSTRAINT_NAME : 제약조건을 구분하기 위한 이름(식별자) - 제약조건의 이름을 설정하지 않으면 SYS_XXXXXXX 형식으로 자동 설정
--CONSTRAINT_TYPE : 제약조건의 종류 - C(CHECK), U(UNIQUE), P(PRIMARY KEY), R(REFERENCE - FOREIGN KEY)
--SEARCH_CONDITION : CHEKC 제약조건으로 설정된 조건식
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,SEARCH_CONDITION FROM USER_CONSTRAINTS WHERE TABLE_NAME='SAWON2';

--제약조건을 설정할 경우 제역조건 관리을 효율적으로 하기 위해 제약조건의 이름을 명시하는 것을 권장
--형식)컬럼명 자료형[(크기)] CONSTRAINT 제약조건명 제약조건

--SAWON3 테이블 생성 - 사원번호(숫자형),사원이름(문자형),급여(숫자형 - 최소급여:5000000)
CREATE TABLE SAWON3(NO NUMBER(4),NAME VARCHAR2(20),PAY NUMBER CONSTRAINT SAWON3_PAY_CHECK CHECK(PAY>=5000000));

--제약조건 확인
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,SEARCH_CONDITION FROM USER_CONSTRAINTS WHERE TABLE_NAME='SAWON3';

--SAWON4 테이블 생성 - 사원번호(숫자형),사원이름(문자형),급여(숫자형 - 최소급여:5000000);
--테이블 수준의 제약조건으로 설정 - 테이블 수준의 제약조건은 모든 컬럼을 사용하여 CHECK 제약조건의 조건식 작성 가능
CREATE TABLE SAWON4(NO NUMBER(4),NAME VARCHAR2(20),PAY NUMBER,CONSTRAINT SAWON4_PAY_CHECK CHECK(PAY>=5000000));

--제약조건 확인
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,SEARCH_CONDITION FROM USER_CONSTRAINTS WHERE TABLE_NAME='SAWON4';

--NOT NULL : NULL를 허용하지 않는 제약조건 - 컬럼에 반드시 값이 저장되도록 설정하는 제약조건
--컬럼 수준의 제약조건만 가능

--DEPT1 테이블 생성 : 부서번호(숫자형),부서이름(문자형),부서위치(문자형)
CREATE TABLE DEPT1(DEPTNO NUMBER(2),DNAME VARCHAR2(12),LOC VARCHAR2(11));
DESC DEPT1;

--DEPT1 테이블에 행 삽입
INSERT INTO DEPT1 VALUES(10,'총무부','서울시');
INSERT INTO DEPT1 VALUES(20,NULL,NULL);--명시적 NULL 사용
INSERT INTO DEPT1(DEPTNO) VALUES(30);--묵시적 NULL 사용
SELECT * FROM DEPT1;

--DEPT2 테이블 생성 : 부서번호(숫자형 - NOT NULL),부서이름(문자형 - NOT NULL),부서위치(문자형 - NOT NULL)
CREATE TABLE DEPT2(DEPTNO NUMBER(2) CONSTRAINT DEPT2_DEPTNO_NN NOT NULL,
    DNAME VARCHAR2(12) CONSTRAINT DEPT2_DNAME_NN NOT NULL,LOC VARCHAR2(11) CONSTRAINT DEPT2_LOC_NN NOT NULL);
DESC DEPT2;

--제약조건 확인 : NOT NULL 제약조건의 종류는 [C]로 표현
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,SEARCH_CONDITION FROM USER_CONSTRAINTS WHERE TABLE_NAME='DEPT2';

--DEPT2 테이블에 행 삽입
INSERT INTO DEPT2 VALUES(10,'총무부','서울시');
INSERT INTO DEPT2 VALUES(20,NULL,NULL);--NOT NULL 제약조건이 설정된 컬럼에 NULL를 전달할 경우 에러 발생
--생략된 컬럼의 기본값이 NULL인 경우 생략 컬럼에 NOT NULL 제약조건이 설정되어 있으면 에러 발생
INSERT INTO DEPT2(DEPTNO) VALUES(30);

--UNIQUE : 중복된 컬럼값 저장을 방지하기 위한 제약조건
--컬럼 수준의 제약조건 또는 테이블 수준의 제약조건으로 설정 가능
--테이블의 여러 컬럼에 UNIQUE 제역조건 설정이 가능하며 NULL 허용

--USER1 테이블 생성 - 아이디(문자형),이름(문자형),전화번호(문자형)
CREATE TABLE USER1(ID VARCHAR2(20),NAME VARCHAR2(30),PHONE VARCHAR2(15));

--USER1 테이블에 행 삽입
INSERT INTO USER1 VALUES('ABC','홍길동','010-1234-5678');
INSERT INTO USER1 VALUES('ABC','홍길동','010-1234-5678');
SELECT * FROM USER1;
COMMIT;

--USER2 테이블 생성 - 아이디(문자형 - UNIQUE),이름(문자형),전화번호(문자형 - UNIQUE)
CREATE TABLE USER2(ID VARCHAR2(20) CONSTRAINT USER2_ID_UK UNIQUE,NAME VARCHAR2(30)
    ,PHONE VARCHAR2(15) CONSTRAINT USER2_PHONE_UK UNIQUE);--컬럼 수준의 제약조건
    
--제약조건 확인
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER2';

--USER2 테이블에 행 삽입
INSERT INTO USER2 VALUES('ABC','홍길동','010-1234-5678');
INSERT INTO USER2 VALUES('ABC','임꺽정','010-5678-1234');--ID 컬럼값 중복에 의해 에러 발생
INSERT INTO USER2 VALUES('XYZ','임꺽정','010-1234-5678');--PHONE 컬럼값 중복에 의해 에러 발생
INSERT INTO USER2 VALUES('ABC','홍길동','010-1234-5678');--ID 컬럼값과 PHONE 컬럼값 중복에 의해 에러 발생
INSERT INTO USER2 VALUES('XYZ','임꺽정','010-5678-1234');
SELECT * FROM USER2;
COMMIT;

--UNIQUE 제약조건에 설정된 컬럼에 NULL를 전달하여 삽입 처리 가능
INSERT INTO USER2 VALUES('ASD','전우치',NULL);
--NULL은 값이 아니므로 UNIQUE 제약조건의 영향을 받지 않아 중복유무와 상관없이 삽입 처리 가능
INSERT INTO USER2 VALUES('QWE','일지매',NULL);
SELECT * FROM USER2;
COMMIT;

--USER3 테이블 생성 - 아이디(문자형 - UNIQUE),이름(문자형),전화번호(문자형 - UNIQUE)
CREATE TABLE USER3(ID VARCHAR2(20),NAME VARCHAR2(30),PHONE VARCHAR2(15),
     CONSTRAINT USER3_ID_UK UNIQUE(ID),CONSTRAINT USER3_PHONE_UK UNIQUE(PHONE));--테이블 수준의 제약조건

--제약조건 확인
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER3';

--USER3 테이블에 행 삽입
INSERT INTO USER3 VALUES('ABC','홍길동','010-1234-5678');
INSERT INTO USER3 VALUES('ABC','임꺽정','010-5678-1234');--ID 컬럼값 중복에 의해 에러 발생
INSERT INTO USER3 VALUES('XYZ','임꺽정','010-1234-5678');--PHONE 컬럼값 중복에 의해 에러 발생
INSERT INTO USER3 VALUES('ABC','홍길동','010-1234-5678');--ID 컬럼값과 PHONE 컬럼값 중복에 의해 에러 발생
INSERT INTO USER3 VALUES('XYZ','임꺽정','010-5678-1234');
SELECT * FROM USER3;
COMMIT;

--UNIQUE 제약조건은 테이블 수준의 제약조건을 사용하여 컬럼을 그룹화하여 중복 저장되는 것을 방지
--USER4 테이블 생성 - 아이디(문자형),이름(문자형),전화번호(문자형) : 아이디와 전화번호를 그룹화하여 UNIQUE 제약조건 설정
CREATE TABLE USER4(ID VARCHAR2(20),NAME VARCHAR2(30),PHONE VARCHAR2(15),
     CONSTRAINT USER4_ID_PHONE_UK UNIQUE(ID,PHONE));--테이블 수준의 제약조건만 가능

--제약조건 확인
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER4';

--USER4 테이블에 행 삽입
INSERT INTO USER4 VALUES('ABC','홍길동','010-1234-5678');
INSERT INTO USER4 VALUES('ABC','임꺽정','010-5678-1234');--ID 컬럼값이 중복돼도 저장 가능
INSERT INTO USER4 VALUES('XYZ','전우치','010-1234-5678');--PHONE 컬럼값 중복돼도 저장 가능
INSERT INTO USER4 VALUES('ABC','일지매','010-1234-5678');--ID 컬럼값과 PHONE 컬럼값이 중복될 경우 에러 발생
SELECT * FROM USER4;
COMMIT;

--PRIMARY KEY : 중복된 컬럼값 저장을 방지하기 위한 제약조건
--컬럼 수준의 제약조건 또는 테이블 수준의 제약조건 설정 가능
--PRIMARY KEY 제약조건은 테이블에서 하나의 컬럼에만 설정 가능하며 NULL 미허용
--PRIMARY KEY 제약조건은 테이블에 하나만 설정하므로 제약조건을 구분하기 위한 이름 설정 생략 가능
--테이블에서 행을 구분할 수 있는 고유값이 저장된 컬럼에 PRIMARY KEY 제약조건 설정
--PRIMARY KEY 제약조건은 테이블의 관계를 구체화하기 위해 반드시 설정해야 되는 제약조건

--MGR1 테이블 생성 - 사원번호(숫자형 - PRIMARY KEY),사원이름(문자형),입사일(날찌형)
CREATE TABLE MGR1(NO NUMBER(4) CONSTRAINT MGR1_NO_PK PRIMARY KEY,NAME VARCHAR2(20),STARTDATE DATE);--컬럼 수준의 제약조건
DESC MGR1;--PRIMARY KEY 제약조건의 의해 NO 컬럼은 자동으로 NOT NULL 설정

--제약조건 확인
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='MGR1';
    
--MGR1 테이블에 행 삽입
INSERT INTO MGR1 VALUES(1000,'홍길동',SYSDATE);
INSERT INTO MGR1 VALUES(1000,'임꺽정',SYSDATE);--NO 컬럼에 중복값을 전달할 경우 PRIMARY KEY 제약조건에 의해 에러 발생
INSERT INTO MGR1 VALUES(NULL,'임꺽정',SYSDATE);--PRIMARY KEY 제약조건이 설정된 컬럼에 NULL을 전달할 경우 에러 발생
INSERT INTO MGR1 VALUES(2000,'임꺽정',SYSDATE);
SELECT * FROM MGR1;
COMMIT;

--MGR2 테이블 생성 - 사원번호(숫자형 - PRIMARY KEY),사원이름(문자형),입사일(날찌형)
--테이블 수준의 제약조건 - 컬럼 수준의 제약조건과 동일
CREATE TABLE MGR2(NO NUMBER(4),NAME VARCHAR2(20),STARTDATE DATE, CONSTRAINT MGR2_NO_PK PRIMARY KEY(NO));

--제약조건 확인
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='MGR2';

--FOREIGN KEY : 부모 테이블에 저장된 행의 컬럼값을 참조하여 자식 테이블의 컬럼에 비정상적인 값이 저장되는 것을 방지하는 제약조건
--테이블 수준의 제약조건만 설정 가능
--부모 테이블의 PRIMARY KEY 제약조건이 설정된 컬럼을 참조하여 자식 테이블의 컬럼에 FOREIGN KEY 제약조건 설정

--SUBJECT1 테이블 생성 - 과목코드(숫자형 - PRIMARY KEY),과목명(문자형) : 부모 테이블
CREATE TABLE SUBJECT1(SNO NUMBER(2) CONSTRAINT SUBJECT1_SNO_PK PRIMARY KEY,SNAME VARCHAR2(20));

--SUBJECT1 테이블에 행 삽입
INSERT INTO SUBJECT1 VALUES(10,'JAVA');
INSERT INTO SUBJECT1 VALUES(20,'JSP');
INSERT INTO SUBJECT1 VALUES(30,'SPRING');
SELECT * FROM SUBJECT1;
COMMIT;

--TRAINEE1 테이블 생성 - 수강생번호(숫자형 - PRIMARY KEY),수강생이름(문자형),수강과목코드(숫자형)
CREATE TABLE TRAINEE1(TNO NUMBER(4) CONSTRAINT TRAINEE1_TNO_PK PRIMARY KEY,TNAME VARCHAR2(20),SCODE NUMBER(2));

--TRAINEE1 테이블에 행 삽입
INSERT INTO TRAINEE1 VALUES(1000,'홍길동',10);
INSERT INTO TRAINEE1 VALUES(2000,'임꺽정',20);
INSERT INTO TRAINEE1 VALUES(3000,'전우치',30);
INSERT INTO TRAINEE1 VALUES(4000,'일지매',40);
SELECT * FROM TRAINEE1;
COMMIT;

--TRAINEE1 테이블과 SUBJECT1 테이블에서 모든 수강생의 수강생번호,수강생이름,수강과목명 검색
--결합조건 : TRAINEE1 테이블의 수강과목코드(SCODE)와 SUBJECT1 테이블의 과목코드(SNO)이 같은 행을 결합하여 검색 - INNER JOIN
--INNER JOIN은 결합조건이 맞는 행만 결합하여 검색 - 결합조건이 맞지 않는 행 미검색
--테이블 결합시 결합조건에 맞지 않는 컬럼값이 저장되어 있는 경우 잘못된 결과 제공 - 데이타 무결성 위반
SELECT TNO,TNAME,SNAME FROM TRAINEE1 JOIN SUBJECT1 ON SCODE=SNO;
--OUTER JOIN를 사용하여 결합조건이 맞지 않는 행은 NULL과 결합하여 검색
SELECT TNO,TNAME,SNAME FROM TRAINEE1 LEFT JOIN SUBJECT1 ON SCODE=SNO;

--TRAINEE2 테이블 생성 - 수강생번호(숫자형 - PRIMARY KEY),수강생이름(문자형),수강과목코드(숫자형 - FOREIGN KEY) : 자식 테이블
--자식 테이블이 참조하는 부모 테이블의 컬럼은 반드시 PRIMARY KEY 제약조건이 설정되어 있어야 참조 가능 - 테이블의 관계 형성
--TRAINEE2 테이블의 수강과목코드(SCODE)는 SUBJECT1 테이블의 과목코드(SNO)를 참조하도록 FOREIGN KEY 제약조건 설정
CREATE TABLE TRAINEE2(TNO NUMBER(4) CONSTRAINT TRAINEE2_TNO_PK PRIMARY KEY,TNAME VARCHAR2(20),SCODE NUMBER(2)
    ,CONSTRAINT TRAINEE2_SCODE_FK FOREIGN KEY(SCODE) REFERENCES SUBJECT1(SNO));

--제약조건 확인
--R_CONSTRAINT_NAME : 참조하는 부모 테이블의 컬럼에 설정된 PRIMARY KEY 제약조건의 이름
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,R_CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE TABLE_NAME='TRAINEE2';

--TRAINEE2 테이블에 행 삽입
INSERT INTO TRAINEE2 VALUES(1000,'홍길동',10);
INSERT INTO TRAINEE2 VALUES(2000,'임꺽정',20);
INSERT INTO TRAINEE2 VALUES(3000,'전우치',30);
--FOREIGN KEY 제약조건이 설정된 컬럼에 부모 테이블의 참조 컬럼에 저장되지 않은 값을 전달할 경우 참조가 불가능하여 에러 발생
INSERT INTO TRAINEE2 VALUES(4000,'일지매',40);--FOREIGN KEY 제약조건을 위반하여 에러 발생
SELECT * FROM TRAINEE2;
COMMIT;

--TRAINEE2 테이블과 SUBJECT1 테이블에서 모든 수강생의 수강생번호,수강생이름,수강과목명 검색
--결합조건 : TRAINEE2 테이블의 수강과목코드(SCODE)와 SUBJECT1 테이블의 과목코드(SNO)이 같은 행을 결합하여 검색 - INNER JOIN
SELECT TNO,TNAME,SNAME FROM TRAINEE2 JOIN SUBJECT1 ON SCODE=SNO;

--TRAINEE2 테이블에서 수강생번호가 1000인 수강생의 수강과목코드를 40으로 변경
--FOREIGN KEY 제약조건이 설정된 컬럼에 부모 테이블의 참조 컬럼에 저장되지 않은 값을 전달할 경우 참조가 불가능하여 에러 발생
UPDATE TRAINEE2 SET SCODE=40 WHERE TNO=1000;--FOREIGN KEY 제약조건을 위반하여 에러 발생

--SUBJECT1 테이블에서 과목코드가 10인 과목정보 삭제
--FOREIGN KEY 제약조건이 설정된 자식 테이블의 컬럼이 참조하는 부모 테이블의 컬럼값이 포함된 행을 삭제할 경우 에러 발생
DELETE FROM SUBJECT1 WHERE SNO=10;--FOREIGN KEY 제약조건을 위반하여 에러 발생
--자식 테이블의 컬럼이 참조하는 부모 테이블의 컬럼값 검색 - 검색된 컬럼값이 저장된 부모 테이블의 행 삭제 불가능
SELECT DISTINCT SCODE FROM TRAINEE2;--검색결과 : 10,20,30

--SUBJECT2 테이블 생성 - 과목코드(숫자형 - PRIMARY KEY),과목명(문자형) : 부모 테이블
CREATE TABLE SUBJECT2(SNO NUMBER(2) CONSTRAINT SUBJECT2_SNO_PK PRIMARY KEY,SNAME VARCHAR2(20));

--SUBJECT2 테이블에 행 삽입
INSERT INTO SUBJECT2 VALUES(10,'JAVA');
INSERT INTO SUBJECT2 VALUES(20,'JSP');
INSERT INTO SUBJECT2 VALUES(30,'SPRING');
SELECT * FROM SUBJECT2;
COMMIT;

--TRAINEE3 테이블 생성 - 수강생번호(숫자형 - PRIMARY KEY),수강생이름(문자형),수강과목코드(숫자형 - FOREIGN KEY) : 자식 테이블
--TRAINEE3 테이블의 수강과목코드(SCODE)는 SUBJECT2 테이블의 과목코드(SNO)를 참조하도록 FOREIGN KEY 제약조건 설정
--FOREIGN KEY 제약조건을 설정할 경우 ON DELETE CASCADE 또는 ON DELETE SET NULL 기능 추가
--ON DELETE CASCADE : 부모 테이블의 행을 삭제할 경우 자식 테이블에 참조 컬럼값이 저장된 행도 같이 삭제하는 기능 제공
--ON DELETE SET NULL : 부모 테이블의 행을 삭제할 경우 자식 테이블에 참조 컬럼값을 NULL로 변경하는 기능 제공 
CREATE TABLE TRAINEE3(TNO NUMBER(4) CONSTRAINT TRAINEE3_TNO_PK PRIMARY KEY,TNAME VARCHAR2(20),SCODE NUMBER(2)
    ,CONSTRAINT TRAINEE3_SCODE_FK FOREIGN KEY(SCODE) REFERENCES SUBJECT2(SNO) ON DELETE CASCADE);

--TRAINEE3 테이블에 행 삽입
INSERT INTO TRAINEE3 VALUES(1000,'홍길동',10);
INSERT INTO TRAINEE3 VALUES(2000,'임꺽정',20);
INSERT INTO TRAINEE3 VALUES(3000,'전우치',30);
SELECT * FROM TRAINEE3;
COMMIT;
    
--SUBJECT2 테이블에서 과목코드가 10인 과목정보 삭제
DELETE FROM SUBJECT2 WHERE SNO=10;
SELECT * FROM SUBJECT2;
--ON DELETE CASCADE 옵션에 의해 TRAINEE3 테이블에 저장된 수강생 중 10번 과목을 수강하는 모든 수강생정보 삭제
SELECT * FROM TRAINEE3;
COMMIT;

--서브쿼리를 사용하여 테이블 생성 가능 - 기존 테이블를 이용하여 새로운 테이블 생성 : 행 복사
--형식)CREATE TABLE 타겟테이블명[(컬럼명,컬럼명,...)] AS SELECT 검색대상,검색대상,... FROM 원본테이블명 [WHERE 조건식]
--서브쿼리의 검색결과를 사용하여 타겟테이블을 생성하고 검색된 행을 타겟테이블에 삽입 처리
--서브쿼리의 검색대상의 속성을 전달받아 타겟테이블을 생성하며 타겟테이블의 컬럼명은 변경 가능 - 검색대상의 자료형 및 크기 변경 불가능
--서브쿼리에서 사용된 원본테이블의 제약조건은 타겟테이블에 미적용

--EMP 테이블(원본 테이블)에 저장된 모든 사원의 사원정보를 검색하여 EMP2 테이블(타겟 테이블)을 생성하고 검색행을 삽입 처리
CREATE TABLE EMP2 AS SELECT * FROM EMP;

--EMP 테이블과 EMP2 테이블의 구조 비교 - 원본 테이블과 타겟 테이블의 속성 동일
DESC EMP; 
DESC EMP2;

--EMP 테이블과 EMP2 테이블의 제약조건 비교 - EMP 테이블에는 제약조건이 설정되어 있지만 EMP2 테이블에는 제약조건 미설정
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='EMP';
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='EMP2';

--EMP 테이블과 EMP2 테이블에 저장된 행 비교 - 원본 테이블과 타겟 테이블의 저장행 동일
SELECT * FROM EMP;
SELECT * FROM EMP2;

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,급여를 검색하여 EMP3 테이블을 생성하고 검색행을 삽입 처리
CREATE TABLE EMP3 AS SELECT EMPNO,ENAME,SAL FROM EMP;

--EMP3 테이블의 구조 및 저장행 확인
DESC EMP3;
SELECT * FROM EMP3;

--EMP 테이블에서 급여가 2000 이상인 사원의 사원번호,사원이름,급여를 검색하여 EMP4 테이블을 생성하고 검색행을 삽입 처리
CREATE TABLE EMP4 AS SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL>=2000;

--EMP4 테이블의 구조 및 저장행 확인
DESC EMP4;
SELECT * FROM EMP4;

--EMP 테이블에서 급여가 2000 이상인 사원의 사원번호,사원이름,급여를 검색하여 EMP5 테이블을 생성하고 검색행을 삽입 처리
--EMP5 테이블의 컬럼명을 NO(사원번호),NAME(사원이름),PAY(급여)가 되도록 테이블 생성
CREATE TABLE EMP5(NO,NAME,PAY) AS SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL>=2000;

--EMP5 테이블의 구조 및 저장행 확인
DESC EMP5;
SELECT * FROM EMP5;

--EMP 테이블과 동일한 속성을 설정된 EMP6 테이블을 생성 - 원본 테이블의 행을 복사하지 않도록 작성
CREATE TABLE EMP6 AS SELECT * FROM EMP WHERE 1=0;--서브쿼리의 검색행의 조건식을 무조건 거짓으로 설정하여 검색 

--EMP6 테이블의 구조 및 저장행 확인
DESC EMP6;
SELECT * FROM EMP6;

--테이블 삭제 : 테이블에 저장된 모든 행 삭제
--형식)DROP TABLE 테이블명

--테이블 목록 확인 - USER_TABLES 딕셔너리를 이용하여 확인 가능
SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'USER%';

--USER1 테이블 삭제
DROP TABLE USER1;
SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'USER%';

--테이블 목록 확인 - USER_TABLES 딕셔너리(동의어 : TABS) 대신 TAB 뷰(VIEW)를 이용하여 검색 가능
SELECT TABLE_NAME FROM TABS;
--오라클은 테이블을 삭제할 경우 테이블을 휴지통(RECYCLEBIN)으로 이동하여 삭제 처리 - 삭제 테이블 복구 가능
--TNAME 컬럼에 BIN으로 시작되는 테이블은 오라클 휴지통에 존재하는 삭제 테이블
SELECT * FROM TAB;

--오라클 휴지통에 존재하는 객체 목록 확인
SHOW RECYCLEBIN;

--오라클 휴지통에 존재하는 삭제 테이블 복구
--형식)FLASHBACK TABLE 테이블명 TO BEFORE DROP 

--USER1 삭제 테이블 복구 - 테이블에 저장된 행도 같이 복구
FLASHBACK TABLE USER1 TO BEFORE DROP;

--삭제 테이블 복구 확인 및 저장행 확인
SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'USER%';
SELECT * FROM USER1;

--USER2 테이블 삭제
SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'USER%';
DROP TABLE USER2;
SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'USER%';

--오라클 휴지통의 객체 목록 확인
--오라클 휴지통에는 테이블뿐만 아니라 테이블과 종속관계 있는 INDEX 객체도 같이 존재
SHOW RECYCLEBIN;

--USER2 삭제 테이블 복구 - 테이블과 종속관계 있는 INDEX 객체도 같이 복구 처리
FLASHBACK TABLE USER2 TO BEFORE DROP;
SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'USER%';
SHOW RECYCLEBIN;

--USER1,USER2,USER3,USER4 테이블 삭제
SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'USER%';
DROP TABLE USER1;
DROP TABLE USER2;
DROP TABLE USER3;
DROP TABLE USER4;
SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'USER%';
SHOW RECYCLEBIN;

--오라클 휴지의 테이블 제거 - 테이블과 종속관계 있는 INDEX 객체도 같이 삭제 처리
--형식)PURGE TABLE 테이블명
PURGE TABLE USER4;
SHOW RECYCLEBIN;

--오라클 휴지통의 모든 테이블 제거 - 휴지통 비우기
PURGE RECYCLEBIN;
SHOW RECYCLEBIN;

--MGR1 테이블 삭제
SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'MGR%';
DROP TABLE MGR1;--오라클 휴지통으로 이동 - 삭제 처리
SHOW RECYCLEBIN;
PURGE RECYCLEBIN;--오라클 휴지통 비우기 - 삭제
SHOW RECYCLEBIN;

--MGR2 테이블 삭제 - 오라클 휴지통을 사용하지 않고 삭제 처리
--형식)DROP TABLE 테이블명 PURGE
DROP TABLE MGR2 PURGE;
SHOW RECYCLEBIN;

--테이블 초기화 : 테이블 생성 직후의 상태로 초기화 처리하는 명령 - 테이블에 저장된 모든 행 삭제
--형식)TRUNCATE TABLE 테이블명

--BONUS 테이블에 저장된 모든 행 삭제
SELECT * FROM BONUS;
DELETE FROM BONUS;--테이블의 행을 삭제하지 않고 트렌젝션에 DELETE 명령 저장
SELECT * FROM BONUS;
ROLLBACK;--롤백 처리 가능 - 트렌젝션에 저장된 SQL 명령 제거
SELECT * FROM BONUS;

--BONUS 테이블 초기화
TRUNCATE TABLE BONUS;
SELECT * FROM BONUS;
ROLLBACK;--롤백 처리 불가능
SELECT * FROM BONUS;

--테이블 이름 변경
--형식)RENAME 기존테이블명 TO 변경테이블명

--BONUS 테이블의 이름을 COMM으로 변경
SELECT TABLE_NAME FROM TABS;
RENAME BONUS TO COMM;
SELECT TABLE_NAME FROM TABS;

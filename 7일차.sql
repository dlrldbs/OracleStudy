--시퀸스 변경
--형식)ALTER SEQUENCE 시퀸스명 {MAXVALUE|MINVALUE|INCREMENT BY} 변경값

--USER2_SEQ 시퀸스의 최대값을 99로 변경하고 증가값은 5로 변경
SELECT SEQUENCE_NAME,MAX_VALUE,MIN_VALUE,INCREMENT_BY FROM USER_SEQUENCES;
ALTER SEQUENCE USER2_SEQ MAXVALUE 99 INCREMENT BY 5; 
SELECT SEQUENCE_NAME,MAX_VALUE,MIN_VALUE,INCREMENT_BY FROM USER_SEQUENCES;

--USER2 테이블에 행 삽입
SELECT USER2_SEQ.CURRVAL FROM DUAL;--검색결과 : 5
INSERT INTO USER2 VALUES(USER2_SEQ.NEXTVAL,'일지매','03/09/09');
SELECT * FROM USER2;
COMMIT;

--시퀸스 삭제
--형식)DROP SEQUENCE 시퀸스명

--USER2_SEQ 시퀸스 삭제
SELECT SEQUENCE_NAME,MAX_VALUE,MIN_VALUE,INCREMENT_BY FROM USER_SEQUENCES;
DROP SEQUENCE USER2_SEQ;
SELECT SEQUENCE_NAME,MAX_VALUE,MIN_VALUE,INCREMENT_BY FROM USER_SEQUENCES;

--인덱스(INDEX) : 테이블에 저장된 행을 보다 빠르게 검색하기 위한 기능을 제공하는 객체
--컬럼에 인덱스를 설정하면 인덱스 영역을 생성하여 컬럼에 대한 행 검색 속도 증가
--조건식에서 많이 사용하는 컬럼에 설정하며 행이 많을 때 설정하는 것이 효율적

--유니크 인덱스(UNIQUE INDEX) : PRIMARY KEY 제약조건이나 UNIQUE 제약조건에 의해 자동으로 생성되는 인덱스
--비유니크 인덱스(NON-UNIQUE INDEX) : 사용자가 컬럼을 이용하여 수동으로 생성하는 인덱스

--USER3 테이블 생성 - 회원번호(숫자형-PRIMARY KEY),회원이름(문자형),이메일(문자형-UNIQUE)
--PRIMARY KEY 제약조건이나 UNIQUE 제약조건에 의해 유니크 인덱스 자동 생성
CREATE TABLE USER3(NO NUMBER(2) CONSTRAINT USER3_NO_PK PRIMARY KEY,NAME VARCHAR2(20)
    ,EMAIL VARCHAR2(50) CONSTRAINT USER3_EMAIL_UK UNIQUE);
    
--USER3 테이블의 제약조건 확인
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER3';

--USER3 테이블의 인덱스 확인 - USER_INDEXES : 인덱스 정보를 제공하는 딕셔너리, USER_IND_COLUMNS : 컬럼 인덱스 정보를 제공하는 딕셔너리
--유니크 인덱스의 이름은 제약조건의 이름과 동일
SELECT C.INDEX_NAME,COLUMN_NAME,UNIQUENESS FROM USER_INDEXES I JOIN USER_IND_COLUMNS C 
    ON I.INDEX_NAME=C.INDEX_NAME WHERE C.TABLE_NAME='USER3';

--인덱스 생성 - 비유니크 인덱스(NON-UNIQUE INDEX)
--형식)CREATE INDEX 인덱스명 ON 테이블명(컬럼명)

--USER3 테이블의 NAME 컬럼을 이용하여 인덱스 생성
CREATE INDEX USER3_NAME_INDEX ON USER3(NAME);

--USER3 테이블의 인덱스 확인
SELECT C.INDEX_NAME,COLUMN_NAME,UNIQUENESS FROM USER_INDEXES I JOIN USER_IND_COLUMNS C 
    ON I.INDEX_NAME=C.INDEX_NAME WHERE C.TABLE_NAME='USER3';
    
--인덱스 삭제 - 비유니크 인덱스(NON-UNIQUE INDEX)
--형식)DROP INDEX 인덱스명
--유니크 인덱스는 PRIMARY 제약조건이나 UNIQUE 제약조건을 삭제하면 같이 삭제

--USER3 테이블의 EMAIL 컬럼에 대한 인덱스 삭제
DROP INDEX USER3_EMAIL_UK;--유니크 인덱스를 삭제할 경우 에러 발생

--USER3 테이블의 EMAIL 컬럼에 설정된 UNIQUE 제약조건 삭제
ALTER TABLE USER3 DROP CONSTRAINT USER3_EMAIL_UK;

--USER3 테이블의 제약조건 및 인덱스 확인
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER3';
SELECT C.INDEX_NAME,COLUMN_NAME,UNIQUENESS FROM USER_INDEXES I JOIN USER_IND_COLUMNS C 
    ON I.INDEX_NAME=C.INDEX_NAME WHERE C.TABLE_NAME='USER3';

--USER3 테이블의 NAME 컬럼에 대한 인덱스 삭제
DROP INDEX USER3_NAME_INDEX;
SELECT C.INDEX_NAME,COLUMN_NAME,UNIQUENESS FROM USER_INDEXES I JOIN USER_IND_COLUMNS C 
    ON I.INDEX_NAME=C.INDEX_NAME WHERE C.TABLE_NAME='USER3';

--동의어(SYNONYM) : 오라클 객체를 다른 이름으로 설정하여 사용하기 위한 객체
--전용 동의어 : 특정 사용자만 사용할 수 있는 동의어 - 일반 사용자에 의해 관리
--공용 동의어 : 모든 사용자가 사용할 수 있는 동의어 - 관리자에 의해 관리

--동의어 생성
--형식)CREATE [PUBLIC] SYNONYM 동의어 FOR 객체명
--PUBLIC : 공용 동의어를 생성하기 위한 키워드

--테이블 목록 확인 - USER_TABLES 딕셔너리 이용
--USER_TABLES 딕셔너리 : SYS 계정에 의해 생성된 뷰 
--다른 사용자의 테이블이나 뷰에 접근하는 방법 - 사용자 스키마를 이용하여 접근
--형식)사용자명.테이블명 또는 사용자명.뷰이름
SELECT TABLE_NAME FROM SYS.USER_TABLES;
--SYS.USER_TABLES 객체의 공용 동의어로 USER_TABLES 생성하여 제공
SELECT TABLE_NAME FROM USER_TABLES;
--SYS.USER_TABLES 객체의 공용 동의어로 TABS 생성하여 제공
SELECT TABLE_NAME FROM TABS;

--COMM 테이블에 대한 현재 접속 사용자만 사용 가능한 전용 동의어로 BONUS 생성
--현재 접속 사용자는 동의어에 대한 시스템 권한이 없으므로 동의어를 생성할 경우 에러 발생 - 관리자에게 동의어에 대한 시스템 권한 요청
CREATE SYNONYM BONUS FOR COMM;--에러

--시스템 관리자(SYSDBA - SYS 계정)로 접속하여 현재 접속 사용자(SCOTT)에세 동의어에 대한 시스템 권한 부여
--GRANT CREATE SYNONYM TO SCOTT;

--시스템 관리자에게 동의어에 대한 시스템 권한을 부여 받은 후 동의어 관련 명령 사용 가능
CREATE SYNONYM BONUS FOR COMM;
SELECT * FROM COMM;
SELECT * FROM BONUS;

--COMM 테이블 관련 동의어 확인 - USER_SYNONYMS : 동의어 관련 정보를 제공하는 딕셔너리
SELECT TABLE_NAME,SYNONYM_NAME,TABLE_OWNER FROM USER_SYNONYMS WHERE TABLE_NAME='COMM';

--동의어 삭제
--형식)DROP [PUBLIC] SYNONYM 동의어

--전용 동의어 BONUS 삭제
DROP SYNONYM BONUS;
SELECT TABLE_NAME,SYNONYM_NAME,TABLE_OWNER FROM USER_SYNONYMS WHERE TABLE_NAME='COMM';
SELECT * FROM COMM;
SELECT * FROM BONUS;--테이블이 없으므로 에러 발생

--사용자(USER) : 시스템(DBMS)을 사용할 수 있는 객체 - 계정(ACCOUNT) : 권한을 가진 사용자
--계정 관리는 시스템 관리자(SYSDBA - SYS 계정)만 가능

--계정 생성
--형식)CREATE USER 계정명 IDENTIFIED BY 암호

--KIM 계정 생성 - 관리자 세션에서 작업
--오라클 12C 버전이상에서는 계정 관리하기 전에 세션에 대한 환경설정 변경
--ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
--CREATE USER KIM IDENTIFIED BY 1234;

--계정 확인 - DBA_USERS : 사용자 정보를 제공하는 딕셔너리
--SELECT USERNAME,ACCOUNT_STATUS,DEFAULT_TABLESPACE,CREATED FROM DBA_USERS WHERE USERNAME='KIM';

--계정의 비밀번호 변경 - 계정의 비밀번호는 기본적으로 180일 유효기간으로 설정
--형식)ALTER USER 계정명 IDENTIFIED BY 암호

--KIM 계정의 비밀번호 변경 - 관리자 세션에서 작업
--ALTER USER KIM IDENTIFIED BY 5678;

--계정 상태 변경 - OPEN(계정 활성화 - 접속 가능), LOCK(계정 비활성화 - 접속 불가능)
--오라클 접속시 계정의 비밀번호를 5번 틀리면 계정의 상태가 자동으로 비활성화(LOCK) 상태로 변경되어 접속 불가능
--형식)ALTER USER 계정명 ACCOUNT {LOCK|UNLOCK}

--KIM 계정을 비활성화 상태로 변경 - 관리자 세션에서 작업
--SELECT USERNAME,ACCOUNT_STATUS,DEFAULT_TABLESPACE,CREATED FROM DBA_USERS WHERE USERNAME='KIM';
--ALTER USER KIM ACCOUNT LOCK;
--SELECT USERNAME,ACCOUNT_STATUS,DEFAULT_TABLESPACE,CREATED FROM DBA_USERS WHERE USERNAME='KIM';

--KIM 계정을 활성화 상태로 변경 - 관리자 세션에서 작업
--ALTER USER KIM ACCOUNT UNLOCK;
--SELECT USERNAME,ACCOUNT_STATUS,DEFAULT_TABLESPACE,CREATED FROM DBA_USERS WHERE USERNAME='KIM';

--계정의 기본 테이블스페이스 변경
--테이블스페이스(TABLESPACE) : 데이타베이스 객체(테이블,뷰,시퀸스,인덱스 등)가 저장되는 영역
--오라클에는 기본적으로 SYSTEM 테이블스페이스와 USERS 테이블스페이스 제공
--형식)ALTER USER 계정명 DEFAULT TABLESPACE 테이블스페이스명

--KIM 계정의 기본 테이블스페이스를 USERS로 변경 - 관리자 세션에서 작업
--ALTER USER KIM DEFAULT TABLESPACE USERS;
--SELECT USERNAME,ACCOUNT_STATUS,DEFAULT_TABLESPACE,CREATED FROM DBA_USERS WHERE USERNAME='KIM';

--계정의 테이블스페이스에 대한 물리적 저장크기 변경 - 용량 제한
--형식)ALTER USER 계정명 QUITA 제한크기 ON 테이블스페이스명

--KIM 계정의 물리적 저장크기를 무제한으로 변경 - 관리자 세션에서 작업
--ALTER USER KIM QUOTA UNLIMITED ON USERS;
--제약용량 확인 - DBA_TS_QUOTAS : 테이블스페이스의 물리적 저장공간에 제한 관련 정보를 제공하는 딕셔너리
SELECT TABLESPACE_NAME,USERNAME,MAX_BYTES FROM DBA_TS_QUOTAS;

--KIM 계정의 물리적 저장크기를 20MBYTE로 변경 - 관리자 세션에서 작업
ALTER USER KIM QUOTA 20M ON USERS;
SELECT TABLESPACE_NAME,USERNAME,MAX_BYTES FROM DBA_TS_QUOTAS;

--계정 삭제
--형식)DROP USER 계정명

--KIM 계정 삭제 - 관리자 세션에서 작업
--SELECT USERNAME,ACCOUNT_STATUS,DEFAULT_TABLESPACE,CREATED FROM DBA_USERS WHERE USERNAME='KIM';
--DROP USER KIM;
--SELECT USERNAME,ACCOUNT_STATUS,DEFAULT_TABLESPACE,CREATED FROM DBA_USERS WHERE USERNAME='KIM';

--DCL(DATA CONTROL LANGUAGE) : 데이타 제어어
--계정에게 권한을 부여하거나 회수하는 명령
--오라클 권한(PRIVILEGE) : 시스템 권한(관리자)과 객체 권한(일반 사용자)으로 구분

--시스템 권한 : 시스템을 구성하는 객체를 관리하기 위한 명령(DDL)에 대한 사용 권한
--시스템 권한을 계정에게 부여
--형식)GRANT {PRIVILEGE|ROLL},{PRIVILEGE|ROLL},... TO {계정명|PUBLIC} [WITH ADMIN OPTION][IDENTIFIED BY 암호] 
--롤(ROLL) : 시스템 권한을 그룹화하여 표현한 명칭
--계정명 대신 PUBLIC 키워드를 사용하면 모든 계정에게 일괄적으로 시스템 권한 부여
--WITH ADMIN OPTION : 부여 받은 시스템 권한을 다른 계정에게 부여하거나 회수하는 권한을 제공하는 옵션
--시스템 권한을 부여받을 계정이 없는 경우 자동으로 계정 생성
--GRANT 명령으로 계정이 생성될 경우 반드시 IDENTIFIED BY를 이용하여 암호 설정

--KIM 계정 생성 - 관리자 세션에서 작업
--CREATE USER KIM IDENTIFIED BY 1234;

--KIM 계정으로 오라클 서버에 접속 - SQLPLUS 사용 : 접속 불가능
--DOS> SQLPLUS /NOLOG  >> 로그인을 시도하지 않고 SQLPLUS 프로그램 실행
--SQL> CONN KIM/1234   >> 오라클 서버에서 접속하기 위해 계정과 비밀번호 입력 - 로그인 처리(인증을 통한 권한 획득)
--ORA-01045: 사용자 KIM는 CREATE SESSION 권한을 가지고 있지 않음; 로그온이 거절되었습니다.

--KIM 계정에게 CREATE SESSION 시스템 권한 부여 - 관리자 세션에서 작업
--GRANT CREATE SESSION TO KIM;

--CREATE SESSION 시스템 권한을 부여받은 후 KIM 계정으로 오라클 서버에 접속 - SQLPLUS 사용 : 접속 가능
--SQL> CONN KIM/1234
--연결되었습니다.

--KIM 계정으로 SAWON 테이블 생성 : 사원번호(숫자형-PRIMARY KEY),사원이름(문자형),급여(숫자형) - SQLPLUS 사용 : 생성 불가능
--SQL> CREATE TABLE SAWON(NO NUMBER(4) PRIMARY KEY,NAME VARCHAR2(20),PAY NUMBER);
--ORA-01031: 권한이 불충분합니다

--KIM 계정에게 CREATE TABLE 시스템 권한 부여 - 관리자 세션에서 작업
--GRANT CREATE TABLE TO KIM;

--CREATE TABLE 시스템 권한을 부여받은 후 KIM 계정으로 SAWON 테이블 생성 - SQLPLUS 사용 : 생성 가능
--SQL> CREATE TABLE SAWON(NO NUMBER(4) PRIMARY KEY,NAME VARCHAR2(20),PAY NUMBER);
--테이블이 생성되었습니다

--객체 권한 : 사용자 스키마의 객체 관련 명령(DQL 및 DML) 사용에 대한 권한
--형식)GRANT {ALL|PRIVILEGE,PRIVILEGE,...} ON 객체명 TO 계정명 [WITH GRANT OPTION]
--객체 권한은 INSERT,UPDATE,DELETE,SELECT 등 키워드로 표현
--ALL : 객체에 관련된 모든 명령 사용 권한 표현
--WITH GRANT OPTION : 부여받은 객체 권한을 다른 계정에게 부여하거나 회수하는 기능을 제공하는 옵션

--SCOTT 계정의 DEPT 테이블에 저장된 모든 행 검색 - 계정 소유의 객체는 [계정명.객체명]으로 표현
SELECT * FROM SCOTT.DEPT;
--현재 접속 계정의 객체인 경우 계정명 생략 가능 
SELECT * FROM DEPT;

--KIM 계정으로 SCOTT 계정의 DEPT 테이블에 저장된 모든 행 검색 - SQLPLUS 사용 : 검색 불가능
--SQL> SELECT * FROM SCOTT.DEPT;  >> 현재 접속된 계정의 객체가 아닌 경우 반드시 [계정명.객체명]으로 표현
--ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
--KIM 계정은 SCOTT 계정에 존재하는 DEPT 테이블에 접근할 수 있는 객체 권한이 없으므로 에러 발생
--KIM 계정이 SCOTT 계정에게 DEPT 테이블에 접근할 수 있는 객체 권한 요청

--SCOTT 계정이 KIM 계정에게 DEPT 테이블에 저장된 행을 검색할 수 있는 권한 부여
GRANT SELECT ON DEPT TO KIM;

--객체 권한을 부여 받은 후 KIM 계정으로 SCOTT 계정의 DEPT 테이블에 저장된 모든 행 검색 - SQLPLUS 사용 : 검색 가능
--SQL> SELECT * FROM SCOTT.DEPT;  

--다른 계정에게 부여한 객체 권한 확인 - USER_TAB_PRIVS_MADE : 부여한 객체 권한 정보를 제공하는 딕셔너리
SELECT * FROM USER_TAB_PRIVS_MADE;

--다른 계정에게 부여받은 객체 권한 확인 - USER_TAB_PRIVS_RECD : 부여받은 객체 권한 정보를 제공하는 딕셔너리
SELECT * FROM USER_TAB_PRIVS_RECD;

--객체 권한 회수
--형식)REVOKE {ALL|PRIVILEGE,PRIVILEGE,...} ON 객체명 FROM 계정명 [WITH GRANT OPTIONSELECT

--SCOTT 계정이 KIM 계정에게 DEPT 테이블에 저장된 행을 검색할 수 있는 권한 회수
REVOKE SELECT ON DEPT FROM KIM;
SELECT * FROM USER_TAB_PRIVS_MADE;

--시스템 권한 회수 - 모든 시스템 권한을 회수해도 계정 미삭제
--형식)REVOKE {PRIVILEGE|ROLL},{PRIVILEGE|ROLL},... FROM {계정명|PUBLIC} [WITH ADMIN OPTION]

--관리자가 KIM 계정에게 부여한 CREATE SESSION 시스템 권한 회수 - 관리자 세션에서 작업
--REVOKE CREATE SESSION FROM KIM;

--롤(ROLL) : 관리자가 일반 계정의 시스템 권한을 효율적으로 부여하거나 회수하기 위해 사용하는 시스템 권한 그룹
--오라클에는 기본적으로 제공되는 롤 존재
--CONNECT : 기본적인 시스템 권한 그룹 - CREATE SESSION,CREATE TABLE,ALTER SESSION,CREATE SYNONYM 등
--RESOURCE : 객체 관련 시스템 권한 그룹 - CREATE TABLE,CREATE SEQUENCE,CREATE TRIGGER 등
--DBA : 시스템 관리에 필요한 모든 시스템 권한 그룹 - 관리자 관련 롤

--관리자가 LEE 계정에게 CONNECT와 RESOURCE 롤 부여 - 관리자 세션 작업
--GRANT CONNECT,RESOURCE TO LEE IDENTIFIED BY 1234;

--LEE 계정으로 오라클 서버에 접속하여 SAWON 테이블 생성 - SQLPLUS 사용 : 서버 접속 및 테이블 생성 가능
--SQL> CONN LEE/1234
--연결되었습니다.
--SQL> CREATE TABLE SAWON(NO NUMBER(4) PRIMARY KEY,NAME VARCHAR2(20),PAY NUMBER);
--테이블이 생성되었습니다

--관리자가 LEE 계정에게 CONNECT와 RESOURCE 롤 회수 - 관리자 세션 작업
--REVOKE CONNECT,RESOURCE FROM LEE;

--PL/SQL(PROCEDURAL LANGUAGE EXTENSION TO SQL) : SQL에 없는 변수 선언,선택 처리,반복 처리를 제공하는 절차적인 언어

--세부분의 영역으로 구분하여 PL/SQL 작성
--1.DECLARE 영역(선언부) : DECLARE - 변수를 선언하는 영역(선택)
--2.EXECUTABLE 영역(실행부) : BEGIN - SQL을 포함한 다수의 명령을 작성하는 영역(필수)
--3.EXCEPTION 영역(예외처리부) : EXCEPTION - 예외를 처리하기 위한 명령을 작성하는 영역(선택)

--영역에서 하나의 명령을 구분하기 위해 ; 사용
--마지막 영역은 END 키워드로 마무리 후 ; 사용
--PL/SQL 실행을 위해 마지막에 / 기호를 사용

--메세지를 출력할 수 있도록 세션의 환경변수 설정값 변경
SET SERVEROUT ON;

--메세지를 출력하는 함수 - PL/SQL 실행부에서 호출하여 사용
--형식)DBMS_OUTPUT.PUT_LINE(출력메세지)

--간단한 메세지를 출력하는 PL/SQL 작성
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO, ORACLE!!!');
END;
/

--변수 선언과 초기값 입력 - 선언부
--형식)변수명 [CONSTANT] 자료형 [NOT NULL] [{:=|DEFUALT} 표현식]
--CONSTANT : 변수에 저장된 초기값을 변경하지 못하도록 설정하는 키워드 - 상수 선언
--NOT NULL : 변수에 NULL 사용 불가능
--:= : 대입연산자
--표현식 : 변수에 저장될 값에 대한 표현 방법 - 값,변수(저장값),연산식(결과값),함수(반환값)

--선언된 변수의 저장값 변경 - 실행부
--형식)변수명 := 표현식

--스칼라 변수 : 오라클 자료형을 사용하여 선언된 변수

--스칼라 변수를 선언하여 값을 저장하고 화면에 변수값을 출력하는 PL/SQL 작성
DECLARE
    VEMPNO NUMBER(4) := 7788;
    VENAME VARCHAR2(20) := 'SCOTT';
BEGIN
    DBMS_OUTPUT.PUT_LINE('사원번호 / 사원이름');
    DBMS_OUTPUT.PUT_LINE('-----------------');    
    DBMS_OUTPUT.PUT_LINE(VEMPNO||' / '||VENAME);
    DBMS_OUTPUT.PUT_LINE('-----------------');    
    VEMPNO := 7893;
    VENAME := 'KING';
    DBMS_OUTPUT.PUT_LINE(VEMPNO||' / '||VENAME);
    DBMS_OUTPUT.PUT_LINE('-----------------');    
END;   
/

--레퍼런스 변수 : 다른 변수의 자료형 또는 테이블의 컬럼 자료형을 참조하여 선언된 변수 - 선언부
--형식)변수명 {변수명%TPYE|테이블명.컬럼명%TYPE}

--테이블에 저장된 행을 검색하여 컬럼값을 변수에 저장하는 명령 - 실행부
--형식)SELECT 검색대상,검색대상,... INTO 변수명,변수명,... FROM 테이블명 [WHERE 조건식] 
--검색대상과 변수의 갯수와 자료형이 반드시 일치

--EMP 테이블의 EMPNO 컬럼과 ENAME 컬럼의 자료형을 참조하여 레퍼런스 변수를 선언하고 EMP 테이블에서 사원이름이
--SCOTT인 사원의 사원번호와 사원이름을 검색하여 레퍼런스 변수에 저장해서 출력하는 PL/SQL 작성
DECLARE
    VEMPNO EMP.EMPNO%TYPE;
    VENAME EMP.ENAME%TYPE;
BEGIN
    /* 주석문 처리 - 프로그램에 설명을 제공하는 문장 */
    /* 단일행을 검색하여 컬럼값을 레퍼런스 변수에 저장 - 다중행 검색시 에러 발생 */
    SELECT EMPNO,ENAME INTO VEMPNO,VENAME FROM EMP WHERE ENAME='SCOTT';
    DBMS_OUTPUT.PUT_LINE('사원번호 / 사원이름');
    DBMS_OUTPUT.PUT_LINE('-----------------');    
    DBMS_OUTPUT.PUT_LINE(VEMPNO||' / '||VENAME);
END;
/

--테이블 변수 : 테이블에 저장된 행을 여러개 검색하여 얻은 다수의 컬럼값을 저장하기 위해 선언하는 변수 
--형식)테이블변수명 테이블타입명
--테이블 변수를 생성하기 위해 테이블 변수의 자료형(테이블 타입)을 먼저 선언
--형식)TYPE 테이블타입명 IS TABLE OF {자료형|변수명%TYPE|테이블명.컬럼명%TYPE} [NOT NULL] [INDEX BY BINARY_INTEGER]

--테이블 변수의 사용 방법 : 테이블 변수는 테이블 변수의 요소를 첨자로 구분하여 사용 - 첨자는 1부터 1씩 증가되는 숫자값
--형식)테이블변수명(첨자)

--EMP 테이블의 EMPNO 컬럼과 ENAME 컬럼을 참조하여 테이블 변수를 선언하고 EMP 테이블에 저장된 모든 사원의 사원번호,사원이름을
--검색하여 테이블 변수에 저장해서 출력하는 PL/SQL 작성
DECLARE
    /* 테이블 타입 선언 */
    TYPE EMPNO_TABLE_TYPE IS TABLE OF EMP.EMPNO%TYPE INDEX BY BINARY_INTEGER;
    TYPE ENAME_TABLE_TYPE IS TABLE OF EMP.ENAME%TYPE INDEX BY BINARY_INTEGER;
    
    /* 테이블 변수 선언 */
    VEMPNO_TABLE EMPNO_TABLE_TYPE;
    VENAME_TABLE ENAME_TABLE_TYPE;
    
    /* 테이블 변수의 요소를 반복처리 하기 위해 첨자 역활을 실행하기 위한 변수 선언 - 초기값 저장 */
    I BINARY_INTEGER := 0;
BEGIN
    /* EMP 테이블에 저장된 모든 사원의 사원번호,사원이름을 검색하여 테이블 변수의 요소에 저장하기 위한 반복문 */
    FOR K IN (SELECT EMPNO,ENAME FROM EMP) LOOP
        I := I + 1;
        VEMPNO_TABLE(I) := K.EMPNO;
        VENAME_TABLE(I) := K.ENAME;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 / 사원이름');
    DBMS_OUTPUT.PUT_LINE('-----------------');    
    /* 테이블 변수에 저장된 요소값을 출력하기 위한 반복문 */    
    FOR J IN 1..I LOOP
        DBMS_OUTPUT.PUT_LINE(VEMPNO_TABLE(J)||' / '||VENAME_TABLE(J));
    END LOOP;
END;
/

--레코드 변수 : 테이블의 저장된 하나의 행의 모든 컬럼값을 저장하기 위해 선언하는 변수
--형식)레코드변수명 레코드타입명
--레코드 변수를 생성하기 위해 레코드 변수의 자료형(레코드 타입)을 먼저 선언
--형식)TYPE 레코드타입명 IS RECORD RECORD(필드명 [자료형|변수명%TYPE|테이명.컬럼명%TYPE] [NOT NULL] [{:=|DEFAULT} 표현식]
--      ,필드명 [자료형|변수명%TYPE|테이명.컬럼명%TYPE][NOT NULL] [{:=|DEFAULT} 표현식],...)

--레코드 변수를 사용하여 필드에 접근하는 방법
--형식)레코드변수명.필드명

--EMP 테이블의 EMPNO,ENAME,JOB,SAL,DEPTNO 컬럼을 참조하여 레코드 변수를 선언하고 EMP 테이블에서 사원번호가 7844인 사원의
--사원번호,사원이름,급여,업무,부서번호를 검색하여 레코드 변수에 저장해서 출력하는 PL/SQL 작성
DECLARE
    /* 레코드 타입 선언 */
    TYPE EMP_RECORD_TYPE IS RECORD (VEMPNO EMP.EMPNO%TYPE,VENAME EMP.ENAME%TYPE, VJOB EMP.JOB%TYPE
        ,VSAL EMP.SAL%TYPE, VDEPTNO EMP.DEPTNO%TYPE);
    
    /* 레코드 변수 선언 */
    EMP_RECORD EMP_RECORD_TYPE;
BEGIN
    /* 검색행의 모든 컬럼값을 레코드 변수에 저장 - 검색행이 다중행인 경우 에러 발생 */
    SELECT EMPNO,ENAME,JOB,SAL,DEPTNO INTO EMP_RECORD.VEMPNO,EMP_RECORD.VENAME,EMP_RECORD.VJOB,
    EMP_RECORD.VSAL,EMP_RECORD.VDEPTNO FROM EMP WHERE EMPNO=7844;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 = '||EMP_RECORD.VEMPNO);
    DBMS_OUTPUT.PUT_LINE('사원이름 = '||EMP_RECORD.VENAME);
    DBMS_OUTPUT.PUT_LINE('사원번호 = '||EMP_RECORD.VJOB);
    DBMS_OUTPUT.PUT_LINE('사원번호 = '||EMP_RECORD.VSAL);
    DBMS_OUTPUT.PUT_LINE('사원번호 = '||EMP_RECORD.VDEPTNO);
END;
/

--레코드 타입 없이 테이블의 행의 모든 컬럼을 참조하여 레코드 변수 선언 가능 - 행의 컬럼이 레코드 변수의 필드로 사용
--형식)레코드변수명 테이블명%ROWTYPE;
DECLARE
    EMP_RECORD EMP%ROWTYPE;
BEGIN
    /* EMP 테이블의 검색행(단일행)의 모든 컬럼값을 레코드 변수의 필드에 저장 */
    SELECT * INTO EMP_RECORD FROM EMP WHERE EMPNO=7844;

    DBMS_OUTPUT.PUT_LINE('사원번호 = '||EMP_RECORD.EMPNO);
    DBMS_OUTPUT.PUT_LINE('사원이름 = '||EMP_RECORD.ENAME);
    DBMS_OUTPUT.PUT_LINE('사원번호 = '||EMP_RECORD.JOB);
    DBMS_OUTPUT.PUT_LINE('사원번호 = '||EMP_RECORD.SAL);
    DBMS_OUTPUT.PUT_LINE('사원번호 = '||EMP_RECORD.DEPTNO);
END;
/


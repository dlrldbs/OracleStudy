--집합 연산자(SET 연산자) : 두 개의 SELECT 명령에 대한 검색결과를 이용하여 집합 결과값을 제공하는 연산자
--합집합(UNION),교집합(INTERSECT),차집합(MINUS)

--SUPER_HERO 테이블 생성 - 속성 : 이름(문자항)
CREATE TABLE SUPER_HERO(NAME VARCHAR(20) PRIMARY KEY);

--SUPER_HERO 테이블 행 삽입
INSERT INTO SUPER_HERO VALUES('슈퍼맨');
INSERT INTO SUPER_HERO VALUES('아이언맨');
INSERT INTO SUPER_HERO VALUES('베트맨');
INSERT INTO SUPER_HERO VALUES('앤트맨');
INSERT INTO SUPER_HERO VALUES('스파이더맨');
SELECT * FROM super_heroHERO;
COMMIT;

--MARVEL_HERO 테이블 생성 - 속성 : 이름(문자형),등급(숫자형)
CREATE TABLE MARVEL_HERO(NAME VARCHAR(20) PRIMARY KEY,GRADE NUMBER(1));

--MARVEL_HERO 테이블에 행 삽입
INSERT INTO MARVEL_HERO VALUES('아이언맨',3);
INSERT INTO MARVEL_HERO VALUES('헐크',1);
INSERT INTO MARVEL_HERO VALUES('스파이더맨',4);
INSERT INTO MARVEL_HERO VALUES('토르',2);
INSERT INTO MARVEL_HERO VALUES('앤트맨',5);
SELECT * FROM MARVEL_HERO;
COMMIT;

--UNION : 두 개의 SELECT 명령으로 검색된행을 합한 결과를 제공 - 중복행 제외
--형식)SELECT 검색대상,... FROM 테이블명 UNION SELECT 검색대상,... FROM 테이블명
--두 개의 SELECT 명령의 검색대상의 갯수와 자료형이 반드시 일치하도록 검색
SELECT NAME FROM SUPER_HERO UNION SELECT NAME FROM MARVEL_HERO;

--UNION ALL : 두 개의 SELECT 명령으로 검색된행을 합한 결과를 제공 - 중복행 포함
--형식)SELECT 검색대상,... FROM 테이블명 UNION ALL SELECT 검색대상,... FROM 테이블명
SELECT NAME FROM SUPER_HERO UNION ALL SELECT NAME FROM MARVEL_HERO;

--INTERSECT : 두 개의 SELECT 명령으로 검색된 행에서 중복된 결과를 제공
--형식)SELECT 검색대상,... FROM 테이블명 INTERSECT SELECT 검색대상,... FROM 테이블명
SELECT NAME FROM SUPER_HERO INTERSECT SELECT NAME FROM MARVEL_HERO;

--MINUS : 첫번째 SELECT 명령으로 검색된 행에서 두번째 SELECT 명령의 검색행을 제외한 결과를 제공
--형식)SELECT 검색대상,... FROM 테이블명 MINUS SELECT 검색대상,... FROM 테이블명
SELECT NAME FROM SUPER_HERO MINUS SELECT NAME FROM MARVEL_HERO;

--집합 연산자 사용시 두개의 SELECT 명령에 대한 검색대상의 갯수 또는 자료형이 다른 경우 에러 발생
SELECT NAME FROM SUPER_HERO UNION SELECT GRADE FROM MARVEL_HERO;--에러 : 자료형의 불일치
SELECT NAME FROM SUPER_HERO UNION SELECT NAME,GRADE FROM MARVEL_HERO;--에러 : 자료형의 불일치

--집합 연산자 사용시 두개의 SELECT 명령에 대한 검색대상의 자료형이 다른 경우 변환함수를 사용하여 자료형을 일치시켜 검색
SELECT NAME FROM SUPER_HERO UNION SELECT TO_CHAR(GRADE,'0') FROM MARVEL_HERO;

--집합 연산자 사용시 두개의 SELECT 명령에 대한 검색대상의 갯수가 다른 경우 동일한 자료형의 임의값 또는 NULL을 사용하여 집합 처리
SELECT NAME,0 FROM SUPER_HERO UNION SELECT NAME,GRADE FROM MARVEL_HERO;
SELECT NAME,NULL FROM SUPER_HERO UNION SELECT NAME,GRADE FROM MARVEL_HERO;

--DML(DATA MANIPULATION LAGUAGE) : 데이터 조작어
--테이블의 행에 대한 삽입,변경,삭제 기능 제공하는 SQL명령
--DML 명령 실행 후 COMMIT (DML 명령의 적용) 또는 ROLLBACK (DML 명령의 취소) 을 실행하는 것을 권장

--INSERT : 테이블에 행을 삽입하는 명령
--형식) INSERT INTO 테이블명 VALUES(컬럼값,컬럼값,...)
--테이블에 삽입될 행의 컬럼값은 테이블 속성에 맞게 차례대로 나열하여 전달되도록 작성
--테이블의 속성 순서대로 자료형에 맞는 컬럼값을 생략없이 차례대로 전달하여 삽입

--테이블 속성(컬럼과 자료형) 확인
--형식)DESC 테이블명 
DESC DEPT;

--DEPT 테이블에 새로운 행(부서정보) 삽입
INSERT INTO DEPT VALUES(50,'회계부','서울시');
SELECT * FROM DEPT;
COMMIT;

--삽입행으로 전달될 컬럼값의 갯수가 테이블의 컬럼 갯수와 맞지 않을 경우 에러 발생
INSERT INTO DEPT VALUES(60,'총무부'); --전달값이 충분하지 않아 에러 발생
INSERT INTO DEPT VALUES(60,'총무부','인천시','031-1234-6789');--전달값이 너무 많아 에러 발생

--삽입행으로 전달될 컬럼값이 테이블의 컬럼 자료형과 맞지 않거나 자료형의 크기보다 큰 경우 에러 발생
INSERT INTO DEPT VALUES('육십','총무부','인천시');--컬럼의 자료형과 맞지 않은 값을 전달하여 에러 발생
INSERT INTO DEPT VALUES(60,'총무부','인천시 월미구');--컬럼 자료형의 크기보다 큰 값을 전달하여 에러 발생

--테이블의 컬럼에 부여된 제약조건을 위반하는 값이 전달될 경우 에러 발생
--PK(PRIMAY KEY) 제약조건 : 테이블에 저장된 기존행의 컬럼값과 중복된 값이 저장되도록 설정하는 제약조건
--DEPT 테이블의 DEPTNO 컬럼에 PK 제약조건 설정
SELECT DISTINCT DEPTNO FROM DEPT;
INSERT INTO DEPT VALUES(50,'총무부','인천시'); --PK 제약조건을 위반한 값을 전달하여 에러 발생
--PK 제약조건이 부여된 컬럼에는 NOT NULL 제약조건이 자동으로 설정되어 NULL 저장 불가능
INSERT INTO DEPT VALUES(NULL,'총무부','인천시');

--테이블의 속성과 컬럼의 제약조건을 위반하는 않는 값을 전달해야만 행 삽입 가능 - 데이터 무결성 유지
--데이터 무결성 : 테이블에 잘못된 값이 저장되지 않도록하여 정상적인 결과가 검색
INSERT INTO DEPT VALUES(60,'총무부','인천시');
SELECT * FROM DEPT;
COMMIT;

--테이블에 행 삽입시 컬럼에 값을 저장하고 싶지 않은 경우 NULL 전달하여 삽입 처리
INSERT INTO DEPT VALUES(70,'영업부',NULL); --명시적 NULL 사용
SELECT * FROM DEPT;
COMMIT;

--특정 테이블 컬럼에 값을 전달하여 행 삽입 가능
--형식)INSERT INTO 테이블명(컬럼명,컬럼명,...) VALUES(컬럼값,컬럼값,...)
--테이블에 나열된 컬럼 순서대로 값을 전달하여 행 삽입
INSERT INTO DEPT(LOC,DEPTNO,DNAME) VALUES('수원시',80,'자재부');
SELECT * FROM DEPT;
COMMIT;

--테이블의 컬럼이 생략되면 생략된 컬럼의 기본값이 자동으로 전달되어 삽입 처리
--테이블 생성 또는 테이블 구조 변경시 컬럼 기본값(COLUMN DEFAULT VALUE) 설정 가능
--컬럼 기본값을 미설정시 NULL을 기본값으로 자동 설정
INSERT INTO DEPT(DEPTNO,DNAME) VALUES (90,'인사부');--LOC 컬럼 생략 : NULL 전달되어 삽입 - 묵시적 NULL 사용
SELECT * FROM DEPT;
COMMIT;

--날짜형 컬럼에는 날짜값 대신 SYSDATE 키워드를 사용하여 값을 전하여 삽입 처리
DESC EMP;
INSERT INTO EMP VALUES(9000,'KIM','MANAGER',7298,'00/12/10',3500,1000,40);
SELECT * FROM EMP;
INSERT INTO EMP VALUES(9001,'LEE','ANALYST',9000,SYSDATE,2000,NULL,40);
SELECT * FROM EMP;
COMMIT;

--INSERT 명령에 서브쿼리(SUBQUERY)를 사용하여 행 삽입 가능
--형식)INSERT INTO 테이블명 SELECT 검색대상,... FROM 테이블명
--서브쿼리의 검색결과를 이용하여 테이블에 행 삽입 - 다른 테이블의 행을 검색하여 현재 테이블에 행 삽입 : 테이블 행 복사
--행이 삽입될 테이블의 속성과 서브쿼리의 검색대상에 대한 속성(컬럼명을 제외한 검색대상의 갯수,자료형,크기 동일)이 동일

--BONUS 테이블의 속성 확인 및 행 검색
DESC BONUS;
SELECT * FROM BONUS;

--EMP 테이블에서 성과급이 존재하는 사원을 검색하여 BONUS 테이블에 삽입 처리
INSERT INTO BONUS SELECT ENAME,JOB,SAL,COMM FROM EMP WHERE COMM IS NOT NULL;
SELECT * FROM BONUS;
COMMIT;

--UPDATE : 테이블에 저장된 행의 컬럼값을 변경하는 명령
--형식)UPDATE 테이블명 SET 컬러명=변경값,컬렴명=변경값,.. [WHERE 조건식]
--WHERE의 조건식이 참인 행을 검색하여 컬럼값 변경 - WHERE가 생략된 경우 테이블에 저장된 모든 행의 컬럼값을 동일하게 변경
--WHERE에서 사용되는 조건식의 컬럼은 PK 제약조건이 부여된 컬럼을 사용하는 것을 권장 - 단일행 검색하여 컬럼값 변경
--데이터 무결성을 위반할 수 있으므로 PK 제약조건이 부여된 컬럼의 값은 변경하지 않는 것을 권장 

--DEPT 테이블에서 부서번호가 50인 부서 검색
SELECT * FROM DEPT WHERE DEPTNO=50; --부서이름 : 회계부, 부서위치 : 서울시

--DEPT 테이블에서 부서번호가 50인 부서의 부서이름을 '경리부'로 변경하고 부서위치를 '부천시'로 변경
UPDATE DEPT SET DNAME='경리부',LOC='부천시' WHERE DEPTNO=50;
SELECT * FROM DEPT WHERE DEPTNO=50;
COMMIT;

--컬럼의 변경값은 컬럼의 자료형,크기,제약조건이 맞는 경우에만 변경 가능
UPDATE DEPT SET LOC='부천시 원미구' WHERE DEPTNO=50; --변경값의 LOC 컬럼의 크기보다 크기에 에러 발생

--UPDATE 명령에서 서브쿼리를 사용 가능 : 변경값 또는 조건식의 비교값 대신 서브쿼리 사용
--DEPT 테이블에서 부서이름이 영업부인 부서위치를 총무부의 부서위치와 같도록 변경
SELECT * FROM DEPT;
UPDATE DEPT SET LOC=(SELECT LOC FROM DEPT WHERE DNAME='총무부') WHERE DNAME='영업부';
SELECT * FROM DEPT;
COMMIT;

--BONUS 테이블에서 사원이름이 KIM인 사원보다 성과급이 적은 사원의 성과급을 100 증가되도록 변경
SELECT * FROM BONUS;
UPDATE BONUS SET COMM=COMM+100 WHERE COMM<(SELECT COMM FROM BONUS WHERE ENAME='KIM');
SELECT * FROM BONUS;
COMMIT;

--DELETE : 테이블에 저장된 행을 삭제하는 명령
--형식)DELETE FROM 테이블명 (WHERE 조건식)
--WHERE의 조건식이 참인 행만 검색하여 삭제 처리 - WHERE가 생략된 경우 테이블에 저장된 모든 행 삭제

--DEPT 테이블에서 부서번호가 90인 부서정보 삭제
SELECT * FROM DEPT;
DELETE FROM DEPT WHERE DEPTNO=90;
SELECT * FROM DEPT;
COMMIT;

--DEPT 테이블에서 부서번호가 10인 부서정보 삭제
--자식 테이블에서 참조되는 부모 테이블의 컬럼값은 FK 제약조건에 의해 변경이나 삭제 처리 불가능
--FK(FOREIGN KEY : 참조키) 제약조건 : 자식 테이블의 컬럼값이 부모 테이블의 컬럼값을 참조하여 저장되도록 설정하는 제약조건
--EMP 테이블(자식 테이블)의 부서번호(DEPTNO)는 DEPT 테이블(부모 테이블)의 부서번호(DEPTNO)를 참조하여 저장되도록 FK 제약조건 부여
DELETE FROM DEPT WHERE DEPTNO=10; --FK 제약조건을 위반하여 에러 발생

--EMP 테이블에서 저장된 모든 사원의 중복되지 않은 유일한 부서번호로 검색
--DEPT 테이블에서는 EMP 테이블이 참조하지 않는 부서정보만 삭제 가능
SELECT DISTINCT DEPTNO FROM EMP; --검색결과: 10,20,30,40

--DEPT 테이블(부모 테이블)에서 부서번호가 20인 부서정보 삭제
DELETE FROM DEPT WHERE DEPTNO=20; --FK 제약조건에 의해 에러 발생
--DEPT 테이블(부모 테이블)에서 부서번호가 80인 부서정보 삭제
DELETE FROM DEPT WHERE DEPTNO=80;
SELECT * FROM DEPT;
COMMIT;

--DELETE 명령에서 서브쿼리 사용 가능 - WHERE의 조건식에 비교값 대신 서브쿼리 사용
--DEPT 테이블에서 부서이름이 영업부인 부서와 같은 부서위치의 부서정보 삭제 - 영업부 포함
SELECT * FROM DEPT;
DELETE FROM DEPT WHERE LOC=(SELECT LOC FROM DEPT WHERE DNAME='영업부');
SELECT * FROM DEPT;
COMMIT;

--MERGE : 원본 테이블의 행을 검색하여 타겟 테이블에 행을 삽입하거나 타겟테이블에 저장된 행의 컬럼값을 변경하는 명령
--형식)MERGE INTO 타겟테이블명 USING 원본테이블명 ON (조건식)
--     WHEN MATCHED THEN UPDATE SET 타겟컬럼명=원본컬럼명,타겟컬럼명=원본컬럼명,...
--     WHEN NOT MATCHED THEN INSERT(타겟컬럼명,타겟컬럼명,...) VALUES(원본컬럼명,원본컬럼명,...)

--DEPT 테이블과 동일한 속성의 MERGE_DEPT 테이블 생성
DESC DEPT;
CREATE TABLE MERGE_DEPT(DEPTNO NUMBER(2),DNAME VARCHAR2(14), LOC VARCHAR2(13));
DESC MERGE_DEPT;

--MERGE_DEPT 테이블에 행 삽입
INSERT INTO MERGE_DEPT VALUES(30,'총무부','서울시');
INSERT INTO MERGE_DEPT VALUES(60,'자재부','수원시');
SELECT * FROM MERGE_DEPT;
COMMIT;

--DEPT 테이블(원본 테이블)에 저장된 모든 부서정보를 검색하여 MERGE_DEPT 테이블(타겟 테이블)에 행을 삽입하거나 
--MERGE_DEPT 테이블에 저장된 행의 컬럼값을 변경
SELECT * FROM DEPT; --원본 테이블
SELECT * FROM MERGE_DEPT; --타겟 테이블
MERGE INTO MERGE_DEPT M USING DEPT D ON (M.DEPTNO=D.DEPTNO)
    WHEN MATCHED THEN UPDATE SET M.DNAME=D.DNAME,M.LOC=D.LOC
    WHEN NOT MATCHED THEN INSERT(M.DEPTNO,M.DNAME,M.LOC) VALUES(D.DEPTNO,D.DNAME,D.LOC);
SELECT * FROM MERGE_DEPT;

--TCL(TRANSACTION CONTROL LANGUAGE) : 트렌젝션 제어어
--트렌젝션에 저장된 SQL 명령을 실제 테이블에 적용하여 실행하거나 적용하지 않고 취소하는 명령

--트렌젝션(TRANSACTION) : 세션에서 DBMS 서버에 전달되어 실행될 SQL 명령을 저장하기 위한 작업단위 - SQL 명령 그룹
--클라이언트에서 작성한 SQL 명령을 서버에 전달하고 데이터베이스에 바로 적용하는 것이 아니라 트렌젝션에 저장하여 나중에 실행되도록 처리
--세션(SESSION) : DBMS 서버에 접속하여 SQL 명령을 전달하여 실행하기 위한 사용자의 작업환경

--트렌젝션에 저장된 SQL 명령을 실제 테이블에 적용하는 방법 : 커밋(COMMIT) 처리 - 커밋 처리후 트렌젝션 초기화
--1.현재 세션이 정상적으로 종료된 경우 자동 커밋 처리
--2.DDL (객체관리명령) 명령 또는 DCL (권한관리명령) 명령을 작성하여 서버에 전달하는 경우 자동 커밋 처리
--3.DML 명령을 작성하여 서버에 전달한 경우 COMMIT 명령을 사용하여 커밋 처리

--트렌젝션에 저장된 SQL 명령을 실제 테이블에 적용하지 않고 삭제하는 방법 - 롤백(ROLLBACK) 처리
--1.현재 세션에서 비정상적으로 서버 접속이 종료한 경우 자동 롤백 처리 
--3.DML 명령을 작성하여 서버에 전달한 경우 ROLLBACK 명령을 사용하여 롤백 처리

--DEPT 테이블에 저장된 모든 부서정보 검색
--트렌젝션에 저장된 SQL 명령이 없으므로 실제 테이블의 행을 검색하여 결과 제공
SELECT * FROM DEPT;

--DEPT 테이블에서 부서번호가 50인 부서정보 삭제
--DELETE 명령에 서버에 전달하면 DEPT 테이블의 행을 삭제하지 않고 트렌젝션에 DELETE 명령 저장
DELETE FROM DEPT WHERE DEPTNO=50;
--실제 테이블의 행을 검색하여 트렌젝션에 저장된 SQL 명령(DELETE)이 실행된 결과 제공
SELECT * FROM DEPT;

--롤백 처리 - 트렌젝션에 저장된 SQL 명령 삭제
ROLLBACK;
SELECT * FROM DEPT; --실제 테이블의 검색결과 제공

--DEPT 테이블에서 부서번호가 50인 부서정보 삭제
DELETE FROM DEPT WHERE DEPTNO=50;

--커밋 처리 : 트렌젝션에 저장된 SQL 명령을 실제 테이블에 적용 - 트렌젝션 초기화
COMMIT;--실제 테이블에 저장된 행 삭제
SELECT * FROM DEPT;--실제 테이블의 검색결과 제공

--EMP 테이블에 저장된 모든 사원정보 삭제
DELETE FROM EMP;
SELECT * FROM EMP;
--서버에 전달된 SQL 명령이 잘못된 경우 롤백 처리를 통한 데이터 복구를 위해 트렌젝션 사용 - 데이터 무결성 유지를 위한 방법
ROLLBACK;
SELECT * FROM EMP;

--현재 세션에서 작업중인 결과를 커밋 전까지 다른 세션에서 검색되지 않도록 트렌젝션 사용 - 데이터 일관성을 제공하는 방법
--데이터 일관성 : DBMS를 사용하는 모든 사용자에게 동일한 검색결과를 제공

--BONUS 테이블에서 사원이름이 KIM인 사원정보 삭제
SELECT * FROM BONUS;
DELETE FROM BONUS WHERE ENAME='KIM';
SELECT * FROM BONUS;

--다른 세션에서는 BONUS 테이블에서 사원이름이 KIM인 사원 검색
--현재 세션에서 커밋 처리를 하기 전까지 다른 세션에서는 테이블의 기존 행을 검색하여 제공 - 데이터 일관성
COMMIT;--현재 세션에서 커밋 처리를 해야만 다른 세션에서도 SQL 명령이 적용된 검색결과 제공

SELECT * FROM BONUS;

--데이터 잠김(LOCK) 기능을 제공하기 위해 트렌젝션 사용
--DBMS는 다중 사용자 환경으로 같은 테이블의 행을 다른 세션에서 조작 가능
--현재 세션에서 작업중인 테이블의 행을 다른 세션에서 작업하지 못하도록 트렌젝션을 이용하여 데이터 잠금 기능 제공

--BONUS 테이블에서 사원이름이 ALLEN인 사원의 급여를 2000으로 변경
SELECT * FROM BONUS;
UPDATE BONUS SET SAL=2000 WHERE ENAME='ALLEN';
SELECT * FROM BONUS;

--다른 세션에서 BONUS 테이블에서 사원이름이 ALLEN인 사원의 성과급을 급여의 50%로 변경
--UPDATE BONUS SET COMM=SAL*0.5 WHERE ENAME='ALLEN';
--현재 세션에서 작업중인 테이블의 행을 다른 세션에서 조작할 경우 트렌젝션에 의해 데이터 잠김 기능으로 인해 세션 일시 중지
--현재 세션에서 작업중인 DML 명령에 대한 커밋 또는 롤백 처리 해야만 다른 세션의 DML 명령이 실행
COMMIT;

--SAVEPOINT : 트렌젝션에 라벨(위치)을 붙이는 명령
--트렌젝션에 저장된 라벨을 이용하여 원하는 위치의 DML 명령들을 롤백 처리하기 위해 사용
--형식) SAVEPOINT 라벨명

--BONUS 테이블에서 사원이름이 ALLEN인 사원정보 삭제
SELECT * FROM BONUS;
DELETE FROM BONUS WHERE ENAME='ALLEN';
SELECT * FROM BONUS;

--BONUS 테이블에서 사원이름이 MARTIN인 사원정보 삭제
DELETE FROM BONUS WHERE ENAME='MARTIN';
SELECT * FROM BONUS;

--SAVEPOINT 명령으로 설정된 라벨을 이용하여 롤백 처리
--형식)ROLLBACK TO 라벨명
--트렌젝션에서 사원이름이 MARTIN인 사원정보를 삭제하는 DELETE 명령 제거
ROLLBACK TO ALLEN_DELETE_AFTER;
SELECT * FROM BONUS;

ROLLBACK;
SELECT * FROM BONUS;

--DDL (DATA DEFINITION LANGUAGE) : 데이터 정의어
--데이터베이스의 객체(테이블,뷰,시퀀스,인덱스,동의어,사용자 등)을 관리하기 위한 명령

--테이블(TABLE): 데이터베이스에서 데이터(행)을 저장하기 위한 가장 기본적인 객체

--테이블 생성 : 테이블 속성(ATTRIBUTE)의 집합
--형식)CREATE TABLE 테이블명(컬럼명 자료형[(크기)] [DEFALUT 기본값] [컬럼제약조건], 
--     컬럼명 자료형[(크기)] [DEFALUT 기본값] [컬럼제약조건],...[,테이블제약조건])

--식별자 작성 규칙 : 테이블명, 컬럼명, 별칭, 라벨명 등
--1.영문자로 시작되며 1~30 범위의 문자들로 구성
--2.A~Z,0~9,_,$,# 문자들을 조합하여 작성 - 대소문자 미구분 : 스네이크 표기법을 사용하는 것을 권장
--3.영문자 외 다른 문자 사용 가능 - 비권장
--4.키워드로 식별자를 선언할 경우 에러 발생 - " "안에 표현 가능하지만 비권장

--자료형(DATATYPE) : 컬럼에 저장 가능한 값을 표현하기 위한 키워드
--1.숫자형 : NUMBER[(전체자릿수,소숫점자릿수)]
--2.문자형 : CHAR(크기) - 크기 : 1~2000(BYTE) >> 고정형 길이
--         VARCHAR2(크기) - 크기 : 1~4000(BYTE) >> 가변 길이
--         LONG : 최대 2GBYTE 저장 >> 가변 길이 - 테이블에 하나의 컬럼에만 부여 가능하며 정렬 불가능
--         CLOB : 최대 4GBYTE 저장 >> 가변 길이 - 인코딩 처리된 문자값이 저장된 텍스트 파일을 저장하기 위한 자료형
--         BLOB : 최대 4GBYTE 저장 >> 가변 길이 - 원시 데이터값이 저장된 일반(이진) 파일을 저장하기 위한 자료형
--3.날짜형 : DATE - 날짜와 시간
--          TIMESTAMP - 초(MS)단위 시간

--SALESMAN 테이블 생성 - 사원번호(숫자형),사원이름(문자형),입사일(날짜형)
CREATE TABLE SALESMAN (NO NUMBER(4),NAME VARCHAR2(20),STARTDATE DATE);

--딕셔너리(DICTIONARY) : 시스템 정보를 제공하기 위한 가상의 테이블(뷰)
--USER_DICTIONARY(일반 사용자),DBA_DICTIONARY(관리자),ALL_DICTIONARY(모든 사용자)

--USER_OBJECTS : 현재 접속 사용자의 객체 정보를 제공하는 딕셔너리
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE';

--USER_TABLES : 현재 접속 사용자의 테이블 정보를 제공하는 딕셔너리
SELECT TABLE_NAME FROM USER_TABLES;
--USER_TABLES 딕셔너리 대신 동의어(SYNONYM)로 TABS 제공
SELECT TABLE_NAME FROM TABS;

--테이블의 구조 확인 
DESC SALESMAN;

--SALESMAN 테이블에 행 삽입
INSERT INTO SALESMAN VALUES(1000,'홍길동','00/04/18');
SELECT * FROM SALESMAN;
COMMIT;

--테이블 생성시 제약조건을 설정하지 않은 경우 컬럼에 어떤 값을 전달하든 삽입 가능 - 데이터 무결성 위반 가능
INSERT INTO SALESMAN VALUES(1000,'전우치','10/10/10');
SELECT * FROM SALESMAN;
COMMIT;

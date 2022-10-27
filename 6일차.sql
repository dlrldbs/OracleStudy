--테이블 속성 변경
--형식)ALTER TABLE 테이블명 변경옵션
--변경옵션에 의해 테이블 속성에 대한 추가,삭제,변경 및 제약조건에 대한 추가,삭제 가능

--USER1 테이블 생성 - 회원번호(숫자형),회원이름(문자형),전화번호(문자형)
CREATE TABLE USER1(NO NUMBER(4),NAME VARCHAR2(20),PHONE VARCHAR2(15));
DESC USER1;

--USER1 테이블에 행 삽입
INSERT INTO USER1 VALUES(1000,'홍길동','010-1234-5678');
SELECT * FROM USER1;
COMMIT;

--테이블 속성 추가 - 컬럼 기본값 설정 및 컬럼 수준의 제약조건 설정 가능
--테이블에 행이 저장되어 있어도 테이블 속성 추가 가능 - 기존 저장행의 추가된 속성에는 컬럼 기본값이 자동 저장
--형식)ALTER TABLE 테이블명 ADD(컬럼명 자료형[(크기)] [DEFAULT 기본값] [제약조건]);

--USER1 테이블에 주소(문자형) 속성 추가 - 테이블에 행이 저장되어 있어도 테이블 속성 추가 가능 
ALTER TABLE USER1 ADD (ADDRESS VARCHAR2(100));
DESC USER1;
SELECT * FROM USER1;

--USER1 테이블에 저장행의 ADDRESS 컬럼값 변경
UPDATE USER1 SET ADDRESS='서울시 강남구' WHERE NO=1000;
SELECT * FROM USER1;
COMMIT;

--테이블의 컬럼 자료형과 크기 변경 - 컬럼 기본값 설정 및 컬럼 수준의 제약조건 설정 가능
--테이블에 저장행이 있는 경우 컬럼 자료형 변경 불가능
--형식)ALTER TABLE 테이블명 MODIFY(컬럼명 자료형[(크기)] [DEFAULT 기본값] [제약조건]);

--USER1 테이블 초기화
TRUNCATE TABLE USER1;
SELECT * FROM USER1;

--USER1 테이블의 NO 컬럼의 자료형(숫자형)을 문자형으로 변경
DESC USER1;
ALTER TABLE USER1 MODIFY(NO VARCHAR2(4));
DESC USER1;

--USER 테이블에 행 삽입
INSERT INTO USER1 VALUES('1000','홍길동','010-1234-5678','서울시 강남구');
SELECT * FROM USER1;
COMMIT;

--USER1 테이블의 NO 컬럼의 자료형(문자형)을 숫자형으로 변경
ALTER TABLE USER1 MODIFY(NO NUMBER(4)); --에러 발생

--USER1 테이블의 NAME 컬럼의 크기(20BYTE)를 10BYTE로 변경
--변경 컬럼에 값이 저장되어 있는 경우 저장된 컬럼값보다 변경할 컬럼의 크기가 큰 경우 변경이 가능
ALTER TABLE USER1 MODIFY(NAME VARCHAR(10));
DESC USER1;

--USER1 테이블의 NAME 컬럼의 크기(20BYTE)를 5BYTE로 변경
--변경 컬럼에 값이 저장되어 있는 경우 저장된 컬럼값보다 변경할 컬럼의 크기가 작은 경우 에러 발생
ALTER TABLE USER1 MODIFY(NAME VARCHAR(5));--에러

--테이블의 컬럼명 변경
--형식)ALTER TABLE 테이블명 RENAME COMLUMN 기존컬럼명 TO 변경컬럼명

--USER1 테이블의 ADDRESS 컬럼명을 ADDR 컬럼명으로 변경
DESC USER1;
ALTER TABLE USER1 RENAME COLUMN ADDRESS TO ADDR;
DESC USER1;

--테이블 속성 삭제 - 테이블 컬럼값도 같이 삭제 
--형식)ALTER TABLE 테이블명 DROP COLUMN 컬럼명

--USER1 테이블에서 PHONE 컬럼 삭제
ALTER TABLE USER1 DROP COLUMN PHONE;
DESC USER1;
SELECT * FROM USER1;


--제약조건 추가 - 컬럼 수준의 제약조건은 테이블 속성 추가(ADD) 및 테이블 속성 변경(MODIFY)시 설정 가능
--USER1 테이블 NAME 컬럼에 NOT NULL 제약조건 추가
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER1';
ALTER TABLE USER1 MODIFY(NAME VARCHAR(10) CONSTRAINT USER1_NAME_NN NOT NULL);
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER1';

--제약조건 추가 - 테이블 수준의 제약조건은 ADD 옵션을 사용하여 설정 가능
--형식)ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] 제약조건
--USER1 테이블의 NO 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE USER1 ADD CONSTRAINT USER1_NO_PK PRIMARY KEY(NO);
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER1';

--제약조건 삭제 -테이블 속성 변경시 제약조건 삭제 가능
--형식)ALTER TABLE 테이블명 DROP (PRIMARY KEY|CONSTRAINT 제약조건명) [CASCADE]

--USER1 테이블의 NAME 컬럼에 설정된 NOT NULL 제약조건 삭제
ALTER TABLE USER1 DROP CONSTRAINT USER1_NAME_NN;
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER1';

--USER1 테이블의 NO 컬럼에 설정된 PRIMARY KEY 제약조건 삭제
ALTER TABLE USER1 DROP PRIMARY KEY;
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER1';

--BUSEO 테이블 생성 - 부서번호(숫자형-PRIMARY KEY),부서이름(문자형) : 부모 테이블
CREATE TABLE BUSEO(BNO NUMBER(2) CONSTRAINT BUSEO_BNO_PK PRIMARY KEY,BNAME VARCHAR2(20));

--BUSEO 테이블에 행 삽입
INSERT INTO BUSEO VALUES(10,'총무부');
INSERT INTO BUSEO VALUES(20,'영업부');
SELECT * FROM BUSEO;
COMMIT;

--SAWON 테이블 - 사원번호(숫자형-PRIMARY KEY),사원이름(문자형),부서번호(숫자형-FOREIGN KEY:BUSEO 테이블의 BNO 컬럼 참조) : 자식 테이블
CREATE TABLE SAWON(SNO NUMBER(4) CONSTRAINT SAWON_SNO_PK PRIMARY KEY , SNAME VARCHAR2(20),BNO NUMBER(2)
,CONSTRAINT SAWON_BNO_FK FOREIGN KEY(BNO) REFERENCES BUSEO(BNO));

--SAWON 테이블에 행 삽입
INSERT INTO SAWON VALUES(1000,'홍길동',10);
INSERT INTO SAWON VALUES(2000,'임꺽정',20);
SELECT * FROM SAWON;
COMMIT;

--SAWON 테이블과 BUSEO 테이블의 제약조건 확인
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,R_CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE TABLE_NAME IN('BUSEO','SAWON');

--FOREIGN KEY 제약조건에 의해 부모 테이블의 참조 컬럼에 저장되어 있지 않은 값을 전달하여 삽입할 경우 에러 발생
INSERT INTO SAWON VALUES(3000,'전우치',30);

--제약조건의 비활성화 처리 - 컬럼에 설정된 제약조건을 일시적으로 중지하는 기능
--형식)ALTER TABLE 테이블명 DISABLE (PRIMARY KEY|CONSTRAINT 제약조건명) [CASCADE]

--SAWON 테이블의 BNO 컬럼에 설정된 FOREIGN KEY 제약조건 비활성화 처리
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,STATUS FROM USER_CONSTRAINTS WHERE TABLE_NAME='SAWON';
ALTER TABLE SAWON DISABLE CONSTRAINT SAWON_BNO_FK;

--SAWON 테이블에 행 삽입 - FOREIGN  KEY 제약조건이 비활성화 처리 되었으므로 제약조건을 위반하는 값을 전달해도 에러 미발생
INSERT INTO SAWON VALUES(3000,'전우치',30);
SELECT * FROM SAWON;
COMMIT;

--제약조건의 활성화 - 비활성화 처리된 제약조건을 다시 동작되도록 설정하는 기능
--형식)ALTER TABLE 테이블명 ENABLE (PRIMARY KEY|CONSTRAINT 제약조건명)

--SAWON 테이블의 BNO 컬럼에 설정된 FOREIGN KEY 제약조건 활성화 처리
--활설화 처리될 제약조건에 제약조건을 위반하는 컬럼값이 저장되어 있는 경우 활성화 처리 불가능
ALTER TABLE SAWON ENABLE CONSTRAINT SAWON_BNO_FK; --에러

--제약조건을 위반하는 컬럼값을 변경하거나 컬럼값이 저장된 행을 삭제해야만 제약조건 활성화 가능
SELECT * FROM SAWON;
DELETE FROM SAWON WHERE BNO=30;
COMMIT;
ALTER TABLE SAWON ENABLE CONSTRAINT SAWON_BNO_FK;
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,STATUS FROM USER_CONSTRAINTS WHERE TABLE_NAME='SAWON';

--BUSEO 테이블의 BNO 컬럼에 설정된 PRIMARY KEY 제약조건 비활성화 처리
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,STATUS FROM USER_CONSTRAINTS WHERE TABLE_NAME='BUSEO';
--FOREIGN KEY 제약조건에 의해 참조되는 PRIMARY KEY 제약조건은 비활성화 처리 불가능
ALTER TABLE BUSEO DISABLE PRIMARY KEY; --에러

--CASCADE 키워드를 사용하면 부모 테이블의 PRIMARY KEY 제약조건을 비활성화 처리시 자식 테이블의 FOREIGN KEY 제약조건도 
--자동으로 DROP 비활성화 처리 가능
ALTER TABLE BUSEO DISABLE PRIMARY KEY CASCADE;
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,STATUS FROM USER_CONSTRAINTS WHERE TABLE_NAME IN ('BUSEO','SAWON');

--부모 테이블의 PRIMARY KEY 제약조건을 활성화 처리한 후 자식 테이블의 FOREIGN KEY 제약조건 활성화 처리 가능
ALTER TABLE BUSEO ENABLE PRIMARY KEY;
ALTER TABLE SAWON ENABLE CONSTRAINT SAWON_BNO_FK; 
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,STATUS FROM USER_CONSTRAINTS WHERE TABLE_NAME IN ('BUSEO','SAWON');

--BUSEO 테이블의 BNO 컬럼에 설정된 PRIMARY KEY 제약조건 삭제
--FOREIGN KEY 제약조건에 의해 참조되는 부모 테이블의 PRIMARY KEY 제약조건은 삭제 불가능
ALTER TABLE BUSEO DROP PRIMARY KEY; --에러

--CASCADE 키워드를 사용하면 부모 테이블의 PRIMARY KEY 제약조건을 삭제하면 자식 테이블의 FOREIGN KEY 제약조건도 자동으로 삭제 처리 가능
ALTER TABLE BUSEO DROP PRIMARY KEY CASCADE;
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,STATUS FROM USER_CONSTRAINTS WHERE TABLE_NAME IN ('BUSEO','SAWON');

--뷰(VIEW) : 테이블을 기반으로 만들어지는 가상의 테이블 - 단순뷰와 복합뷰로 구분
--뷰는 행검색 또는 객체 권한 설정을 간편하게 사용하기 위한 기능을 제공
--단순뷰 : 하나의 테이블을 기반으로 생성되는 뷰 - 검색뿐만 아니라 뷰를 이용한 테이블의 행 삽입,변경,삭제 가능
--단순뷰 생성시 그룹함수 또는 DISTINCT 키워드를 사용한 경우 검색만 가능
--복합뷰 : 다수의 테이블을 기반으로 생성되는 뷰 : 테이블 결합을 기반으로 생성하는 뷰 - 검색만 가능


--뷰 생성 : 서브쿼리 이용
--형식)CREATE (OR REPLACE) [(FORCE|NOFORCE)] VIEW 뷰이름[(컬럼명,컬럼명,...)]  
--     AS SELECET 검색대상,검색대상,... FROM 테이블명 [WHERE 조건식] [WITH CHECK OPTION] [WITH READ ONLY]
--서브쿼리의 검색결과를 이용하여 뷰 생성
--CREATE OR REPLACE : 동일한 이름의 뷰가 존재할 경우 기존 뷰를 삭제하고 새로운 뷰 생성
--FORCE : 서브쿼리의 검색결과가 없어도 강제로 뷰를 생성하기 위한 기능 제공
--WITH CHECK OPTION : 뷰를 생성한 서브쿼리의 조건식에서 사용된 컬럼에 저장된 값을 변경하지 못하도록 설정하는 기능 제공
--WITH READ ONLY : 검색만 가능하도록 설정하는 기능 제공(단순뷰)

--EMP 테이블에 저장된 모든 사원을 검색하여 EMP_COPY 테이블을 생성하고 검색행을 삽입 처리
CREATE TABLE EMP_COPY AS SELECT * FROM EMP;
SELECT * FROM EMP_COPY;

--EMP_COPY 테이블에서 부서번호가 30인 사원의 사원번호,사원이름,부서번호를 검색하여 EMP_VIEW30 뷰 생성
--현재 접속 사용자는 뷰에 대한 시스템 권한이 없으므로 뷰를 생성할 경우 에러 발생 - 관리자(SYS)에게 뷰에 대한 시스템 권한 요청
CREATE VIEW EMP_VIEW30 AS SELECT EMPNO,ENAME,DEPTNO FROM EMP_COPY WHERE DEPTNO=30; --에러

--시스템 관리자(SYSDBA - SYS)로 접속하여 현재 접속 사용자(SCOTT)에게 뷰에 대한 시스템 권한 부여
--GRANT CREATE VIEW TO SCOTT;

--시스템 관리자에게 뷰에 대한 시스템 권한을 부여 받은 후 뷰 관련 명령 사용 가능
CREATE OR REPLACE VIEW EMP_VIEW30 AS SELECT EMPNO,ENAME,DEPTNO FROM EMP_COPY WHERE DEPTNO=30; --단순뷰

--뷰 목록 확인 - USER_VIEWS : 뷰 정보를 제공하는 딕셔너리
SELECT VIEW_NAME,TEXT FROM USER_VIEWS;

--뷰 검색 : 테이블에 저장된 행을 이용하여 검색
SELECT * FROM EMP_VIEW30;

--단순 뷰에 행 삽입 : 테이블에 행을 삽입 처리 - 뷰에 없는 컬럼에는 컬럼 기본값 전달되어 삽입
INSERT INTO EMP_VIEW30 VALUES(1111,'홍길동',30);
SELECT * FROM EMP_VIEW30;
SELECT * FROM EMP_COPY;
COMMIT;

--EMP_COPY 테이블에 저장된 모든 사원의 사원번호,사원이름,업무,입사일,급여를 검색하여 EMP_VIEW01 뷰 생성
CREATE VIEW EMP_VIEW01 AS SELECT EMPNO,ENAME, JOB, HIREDATE, SAL FROM EMP_COPY;

--EMP_COPY 테이블에서 업무가 SALESMAN인 사원의 사원번호,사원이름,성과급을 검색하여 EMP_VIEW02 뷰 생성
CREATE VIEW EMP_VIEW02 AS SELECT EMPNO,ENAME,COMM FROM EMP_COPY WHERE JOB='SALESMAN';

--뷰를 이용하여 테이블 관련 권한 설정을 대신하여 필요한 정보를 제공
--EMP_COPY 테이블에 접근 권한을 없애고 뷰를 이용해 EMP_COPY 테이블의 저장된 행을 검색하여 필요한 정보만 제공
--인사부에 근무하는 사원은 EMP_VIEW01 뷰에 접근 가능한 권한 제공
SELECT * FROM EMP_VIEW01;
--영업부에 근무하는 사원은 EMP_VIEW02 뷰에 접근 가능한 권한 제공
SELECT * FROM EMP_VIEW02;

--EMP 테이블과 DEPT 테이블에서 모든 사원의 사원번호,사원이름,급여,부서이름,부서위치 검색
--결합조건 : EMP 테이블의 부서번호(DEPTNO)와 DEPT 테이블의 부서번호(DEPTNO) 같은 행을 서로 결합하여 검색
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO;

--EMP 테이블과 DEPT 테이블에서 모든 사원의 사원번호,사원이름,급여,부서이름,부서위치 검색하여 EMP_VIEW 뷰 생성
CREATE VIEW EMP__VIEW AS SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO;--복합뷰
SELECT * FROM EMP__VIEW; --뷰를 이용하여 두 개 이상의 테이블에서 원하는 행의 결합결과 검색

--EMP_VIEW30 뷰에 SAL 컬럼 추가 : 뷰 속성 변경 불가능 - 기존 뷰를 삭제하고 새로운 뷰 생성
--CREATE OR REPLACE VIEW 명령을 사용하여 기존 뷰를 삭제하고 새로운 뷰 생성 가능
SELECT * FROM EMP_VIEW30;
SELECT VIEW_NAME,TEXT FROM USER_VIEWS;
CREATE OR REPLACE VIEW EMP_VIEW30 AS SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP_COPY WHERE DEPTNO=30;
SELECT VIEW_NAME,TEXT FROM USER_VIEWS;
SELECT * FROM EMP_VIEW30;

--EMP_COPY 테이블에서 부서번호가 10인 사원의 사원번호,사원이름,급여,부서번호를 검색하여 EMP_VIEW10 뷰 생성
CREATE OR REPLACE VIEW EMP_VIEW10 AS SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP_COPY WHERE DEPTNO=10;
SELECT VIEW_NAME,TEXT FROM USER_VIEWS;
SELECT * FROM EMP_VIEW10;

--EMP_VIEW10 뷰에서 사원번호가 7782인 사원의 부서번호를 20으로 변경 - EMP_COPY 테이블의 행 컬럼값 변경 
UPDATE EMP_VIEW10 SET DEPTNO=20 WHERE EMPNO=7782;
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP_COPY;
SELECT * FROM EMP_VIEW10;--테이블에 저장된 컬럼값이 변경되어 뷰에서는 미검색

--롤백 처리
ROLLBACK;
SELECT * FROM EMP_VIEW10;

--EMP_COPY 테이블에서 부서번호가 10인 사원의 사원번호,사원이름,급여,부서번호를 검색하여 EMP_VIEW10 뷰 생성
-- EMP_VIEW10 뷰에 WITH CHECK OPTION 기능 추가
CREATE OR REPLACE VIEW EMP_VIEW10 AS SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP_COPY WHERE DEPTNO=10 WITH CHECK OPTION;

--EMP_VIEW10 뷰에서 사원번호가 7782인 사원의 부서번호를 20으로 변경
--WITH CHECK OPTION 기능에 의해 뷰를 생성한 서브쿼리의 조건식에서 사용한 컬럼값을 변경할 경우 에러 발생
UPDATE EMP_VIEW10 SET DEPTNO=20 WHERE EMPNO=7782; --에러

--EMP__COPY 테이블에서 부서번호가 20인 사원의 사원번호,사원이름,급여,부서번호를 검색하여 EMP_VIEW20 뷰 생성
CREATE OR REPLACE VIEW EMP_VIEW20 AS SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP_COPY WHERE DEPTNO=20;
SELECT * FROM EMP_VIEW20;

--EMP_VIEW20 사원번호가 7788인 사원정보 삭제 - EMP_COPY 테이블의 행 삭제
DELETE FROM EMP_VIEW20 WHERE EMPNO=7788;
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP_COPY;
SELECT * FROM EMP_VIEW20;

--롤백 처리
ROLLBACK;
SELECT * FROM EMP_VIEW20;

--EMP_COPY 테이블에서 부서번호가 20인 사원의 사원번호,사원이름,급여,부서번호를 검색하여 EMP_VIEW20 뷰 생성
--EMP_VIEW20 뷰에 WITH READ ONLY 기능 추가
CREATE OR REPLACE VIEW EMP_VIEW20 AS SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP_COPY WHERE DEPTNO=20 WITH READ ONLY;
SELECT * FROM EMP_VIEW20;

--EMP_VIEW20 사원번호가 7788인 사원정보 삭제
--WIH READ ONLY 기능에 의해 단순뷰에서 DML 명령을 실행할 경우 에러 발생
DELETE FROM EMP_VIEW20 WHERE EMPNO=7788; --에러

--뷰 삭제
--형식)DROP VIEW  뷰이름

--뷰 목록 확인
SELECT VIEW_NAME,TEXT FROM USER_VIEWS;

--EMP__VIEW 뷰 삭제
DROP VIEW EMP__VIEW;
SELECT VIEW_NAME,TEXT FROM USER_VIEWS;

--EMP_COPY 테이블 삭제 - 테이블을 삭제해도 테이블을 기반으로 생성된 뷰 미삭제
DROP TABLE EMP_COPY PURGE;
SELECT VIEW_NAME,TEXT FROM USER_VIEWS;

--EMP_VIEW30 뷰 검색 - 뷰가 참조할 수 있는 테이블이 없는 경우 에러 발생
SELECT * FROM EMP_VIEW30;

--ROWNUM : 검색행에 순차적으로 행번호를 제공하는 키워드
SELECT EMPNO,ENAME,SAL FROM EMP;
SELECT ROWNUM,EMPNO,ENAME,SAL FROM EMP;

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,급여를 급여로 내림차순 정렬하여 검색
SELECT EMPNO,ENAME,SAL FROM EMP ORDER BY SAL DESC;

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,급여를 급여로 내림차순 정렬하여 검색 - 행번호 제공받아 검색
SELECT ROWNUM,EMPNO,ENAME,SAL FROM EMP ORDER BY SAL DESC;

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,급여를 급여로 내림차순 정렬하여 EMP_VIEW 뷰 생성
CREATE OR REPLACE VIEW EMP_VIEW AS SELECT EMPNO,ENAME,SAL FROM EMP ORDER BY SAL DESC;
SELECT * FROM EMP_VIEW;

--EMP_VIEW 뷰의 모든 행을 행번호와 같이 검색
SELECT ROWNUM,EMPNO,ENAME,SAL FROM EMP_VIEW;
--테이블 또는 뷰의 모든 컬럼을 다른 검색대상과 같이 사용할 경우 [테이블.*] 또는 [뷰.*] 형식으로 표현하여 검색 가능
SELECT ROWNUM,EMP_VIEW.* FROM EMP_VIEW;

--인라인 뷰(INLINE VIEW) : SELECT 명령에서 FROM의 서브쿼리를 사용하여 일시적으로 생성되어 사용되는 뷰
--뷰 관련 시스템 권한이 없어도 인라인 뷰를 사용 가능
--형식)SELECT 검색대상,... FROM (SELECT 검색대상,... FROM 테이블명 [WHERE 조건식])
SELECT * FROM (SELECT EMPNO,ENAME,SAL FROM EMP);
SELECT EMPNO,ENAME,SAL FROM (SELECT EMPNO,ENAME,SAL FROM EMP ORDER BY SAL DESC);

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,급여를 급여로 내림차순 정렬하여 행번호를 제공받아 검색
--서브쿼리로 정렬된 인라인 뷰를 생성하여 행번호 제공받아 검색
SELECT ROWNUM,EMPNO,ENAME,SAL FROM (SELECT EMPNO,ENAME,SAL FROM EMP ORDER BY SAL DESC);

--인라인 뷰에 별칭 설정 가능 - 인라인 뷰의 별칭을 사용하여 인라인 뷰의 모든 컬럼값 검색을 표현 
SELECT ROWNUM,TEMP.* FROM (SELECT EMPNO,ENAME,SAL FROM EMP ORDER BY SAL DESC) TEMP;

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,급여를 급여로 내림차순 정렬하여 행번호를 제공받아 검색하고
--행번호가 5보다 작거나 같은 행 검색 - ROWNUM 키워드를 WHERE에서 조건식에서 사용하여 검색
SELECT ROWNUM,TEMP.* FROM (SELECT EMPNO,ENAME,SAL FROM EMP ORDER BY SAL DESC) TEMP WHERE ROWNUM<=5;

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,급여를 급여로 내림차순 정렬하여 행번호를 제공받아 검색하고
--행번호가 10인 행 검색 
--ROWNUM 키워드는 인라인 뷰의 검색행에 순차적으로 부여되는 행번호로 처리행 전에 행번호를 미리 부여받지 못해 비교 검색 불가능
--ROWNUM 키워드를 WHERE에서 조건식에서 사용할 때 > 또는 >=,= 연산자를 이용한 연산식 사용 불가능

SELECT ROWNUM,TEMP.* FROM (SELECT EMPNO,ENAME,SAL FROM EMP ORDER BY SAL DESC) TEMP WHERE ROWNUM=10; --검색 실패

--ROWNUM 키워드를 포함한 인라인 뷰를 생성하고 ROWNUM 키워드에 컬럼 별칭을 설정하여 조건식에 사용하여 검색 가능
SELECT * FROM (SELECT ROWNUM RN,TEMP.* FROM (SELECT EMPNO,ENAME,SAL FROM EMP ORDER BY SAL DESC) TEMP) WHERE RN=10;

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,급여를 급여로 내림차순 정렬하여 행번호를 제공받아 검색하고
--행번호가 6~10 범위에 포함되는 행 검색 - 페이징 처리시 사용하는 SELECT 명령 
--페이징 처리 : 하나의 웹페이지에 원하는 범위의 구분하여 원하는 행만 검색하여 출력하는 기능
SELECT * FROM (SELECT ROWNUM RN,TEMP.* FROM (SELECT EMPNO,ENAME,SAL FROM EMP ORDER BY SAL DESC) TEMP) WHERE RN BETWEEN 6 AND 10; 

--시퀀스 (SEQUENCE) : 숫자값(정수값)을 저장하여 자동 증가되는 값을 제공하는 객체

--시퀀스 생성
--형식)CREATE SEQUENCE 시퀀스명 [START WITH 초기값 ] [INCREMENT BY 증가] [MAXVALUE 최대값]
--     [MINVALUE 최소값] [CYCLE] {CACHE 갯수]
--START WITH 초기값 : 시퀀스에 저장되는 초기값 설정 - 생략 : NULL
--INCREMENT BY 증가 : 자동 증가되는 숫자값 설정 - 생략 : 1
--MAXVALUE 최대값 : 시퀀스에 저장 가능한 최대값 설정 - 생략 : 숫자값으로 표현 가능한 최대값
--MINVALUE 최소값 : 시퀀스에 저장 가능한 최소값 설정 - 생략 : 1
--CYCLE : 시퀀스의 저장값이 최대값을 초과할 경우 최소값부터 다시 제공되도록 반복하는 기능을 제공
--CACHE 갯수 : 임의의 저장공간에 자동 증가값을 미리 생성하여 제공할 수 있는 갯수를 설정하는 기능 - 생략 : 20

--USER2 테이블 생성 - 회원번호(숫자형-PRIMARY KEY),회원이름(문자형),생년월일(날짜형)
CREATE TABLE USER2(NO NUMBER(2) PRIMARY KEY,NAME VARCHAR2(20),BIRTHDAY DATE);
DESC USER2;

--USER2 테이블의 NO 컬럼값으로 저장하기 위한 자동 증가값을 제공하는 시퀀스 생성
CREATE SEQUENCE USER2_SEQ;

--시퀀스 확인 - USER_SEQUENCE : 시퀀스 정보를 제공하는 딕셔너리
SELECT SEQUENCE_NAME,MAX_VALUE,INCREMENT_BY FROM USER_SEQUENCES;

--시퀀스에 저장된 숫자값을 확인하고 싶으면 
--형식)시퀀스명.CURRVAL
SELECT USER2_SEQ.CURRVAL FROM DUAL; --시퀀스에 NULL이 있는 경우 숫자값을 확인하면 에러 발생

--시퀀스에 저장된 숫자값을 이용하여 증가된 값을 제공 - 증가된 값 제공 후 시퀀스에는 증가된 값이 자동저장
--시퀀스에 NULL이 있는 경우 시퀀스의 최소값을 제공한 후 변경 처리
--형식)시퀀스명.NEXTVAL
SELECT USER2_SEQ.NEXTVAL FROM DUAL; --검색결과 : 1 - 시퀀스의 저장값은 1로 변경
SELECT USER2_SEQ.CURRVAL FROM DUAL;
SELECT USER2_SEQ.NEXTVAL FROM DUAL; --검색결과 : 2 - 시퀀스의 저장값은 2로 변경
SELECT USER2_SEQ.CURRVAL FROM DUAL;

--USER2 테이블에 행 삽입
INSERT INTO USER2 VALUES(USER2_SEQ.NEXTVAL,'홍길동','00/01/01');
INSERT INTO USER2 VALUES(USER2_SEQ.NEXTVAL,'임꺽정','00/12/31');
INSERT INTO USER2 VALUES(USER2_SEQ.NEXTVAL,'전우치',SYSDATE);
SELECT * FROM USER2;
COMMIT;

--비동등결합(NON-EQUI JOIN) : 두개이상의 테이블에서 결합조건에 = 연산자가 아닌 연산자를 사용하여 참인 행을 결합하여 검색

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,급여 검색
SELECT EMPNO,ENAME,SAL FROM EMP;

--SALGRADE 테이블에 저장된 모든 급여등급의 급여등급번호,최소급여,최대급여 검색
SELECT GRADE,LOSAL,HISAL FROM SALGRADE;

--EMP 테이블과 SALGRADE 테이블에서 모든 사원의 사원번호,사원이름,급여,급여등급번호 검색
--결합조건 : 사원의 급여(SAL)가 급여등급의 최소급여(LOSAL)부터 최대급여(HISAL) 범위에 포함될 경우 행을 결합하여 검색
SELECT EMPNO,ENAME,SAL,GRADE FROM EMP,SALGRADE WHERE SAL BETWEEN LOSAL AND HISAL;

--외부결합(OUTER JOIN) : 결합조건이 참인 행만 결합하는 것이 아니라 결합조건이 맞지 않는 행도 NULL과 결합하여 검색
--결합조건식의 결합 테이블에 (+)를 사용하면 결합조건이 맞지 않는 행을 NULL과 결합하여 검색

--EMP 테이블에 저장된 모든 사원의 부서번호를 중복되지 않은 유일한 컬럼값 검색
SELECT DISTINCT DEPTNO FROM EMP;--검색결과 : 10,20,30

--DEPT 테이블에 저장된 모든 부서의 부서번호 검색
SELECT DEPTNO FROM DEPT;--검색결과 : 10,20,30,40

--EMP 테이블과 DEPT 테이블에 저장된 모든 사원의 사원번호,사원이름,급여,부서이름,부서위치 검색
--결합조건 : EMP 테이블의 부서번호(DETPNO)와 DEPT 테이블의 부서번호(DETPNO)가 같은 행을 결합하여 검색 - 동등결합
--40번 부서에 근무하는 사원이 없으므로 40번 부서에 대한 부서이름과 부서위치 미검색
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP,DEPT WHERE EMP.DEPTNO=DEPT.DEPTNO;

--사원이 없는 부서정보도 검색하기 위해 검색조건식에서 EMP 테이블의 결합조건에 (+)를 붙여 EMP 테이블에 결합되는 행이 없는 경우
--컬럼값 대신 NULL이 결합되어 검색 - 외부결합
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP,DEPT WHERE EMP.DEPTNO(+)=DEPT.DEPTNO;

--자기결합(SELF JOIN) : 하나의 테이블에서 서로 다른 별칭을 부여하여 다른 테이블로 설정해 행을 결합하여 검색
--검색대상에 반드시 테이블 별칭으로 테이블을 구분하여 컬럼값 검색

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,관리자번호(사원번호) 검색
SELECT EMPNO,ENAME,MGR FROM EMP;

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,관리자번호(사원번호),관리자이름(사원이름) 검색
--결합조건 : EMP 테이블(별칭:WORKER)의 관리자번호(MGR)와 EMP 테이블(별칭:MANAGER)의 사원번호(EMPNO)가 같은 행을 결합하여 검색
--동등결합이므로 EMP 테이블의 관리자번호(MGR)에 NULL이 저장된 사원은 결합조건이 맞지 않으므로 행이 결합되지 않아 미검색
SELECT WORKER.EMPNO,WORKER.ENAME WORKER_ENAME,WORKER.MGR,MANAGER.ENAME MANAGER_ENAME
    FROM EMP WORKER,EMP MANAGER WHERE WORKER.MGR=MANAGER.EMPNO;

--EMP 테이블의 관리자번호(MGR)에 NULL이 저장된 사원도 검색하기 위해 외부결합(OUTER JOIN)을 사용하여 검색
SELECT WORKER.EMPNO,WORKER.ENAME WORKER_ENAME,WORKER.MGR,MANAGER.ENAME MANAGER_ENAME 
    FROM EMP WORKER,EMP MANAGER WHERE WORKER.MGR=MANAGER.EMPNO(+);
    
--EMP 테이블과 DEPT 테이블에서 SALES 부서에 근무하는 사원의 사원번호,사원이름,급여,부서이름,부서위치 검색
--결합조건 : EMP 테이블의 부서번호(DETPNO)와 DEPT 테이블의 부서번호(DETPNO)가 같은 행을 결합하여 검색 
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP,DEPT WHERE EMP.DEPTNO=DEPT.DEPTNO AND DNAME='SALES';

--기존의 테이블 결합은 테이블의 결합조건과 행의 검색조건을 WHERE에서 같이 사용하므로 유지보수의 불편함 존재
--1999년에 채택된 표준 SQL(SQL3)에서는 테이블의 결합조건과 행의 검색조건 구분하여 사용되므로 다양한 테이블 결합방법 제공

--CROSS JOIN : 결합 테이블의 모든 행을 교차 결합하여 검색 - 결합조건 생략
--형식)SELECT 검색대상,... FROM 테이블명1 CROSS JOIN 테이블명2

--EMP 테이블과 DEPT 테이블에서 모든 사원의 사원번호,사원이름,급여,부서이름,부서위치 검색
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP CROSS JOIN DEPT;

--NATURAL JOIN : 결합 테이블에 같은 이름의 컬럼이 하나만 있는 경우 컬럼에 저장된 컬럼값이 같은 행을 서로 결합하여 검색
--형식)SELECT 검색대상,... FROM 테이블명1 NATURAL JOIN 테이블명2

--EMP 테이블과 DEPT 테이블에서 SALES 부서에 근무하는 사원의 사원번호,사원이름,급여,부서이름,부서위치 검색
--결합조건 : EMP 테이블의 부서번호(DETPNO)와 DEPT 테이블의 부서번호(DETPNO)가 같은 행을 결합하여 검색 
--NATURAL JOIN을 사용할 경우 결합조건을 명시하지 않아도 테이블의 행을 결합하여 검색
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP NATURAL JOIN DEPT;

--EMP 테이블과 DEPT 테이블에서 SALES 부서에 근무하는 사원의 사원번호,사원이름,급여,부서번호,부서이름,부서위치 검색
--NATURAL JOIN을 사용할 경우 검색대상으로 결합 테이블에 존재하는 동일한 컬럼명을 검색할 때 테이블을 명시하지 않아도 검색 가능
SELECT EMPNO,ENAME,SAL,DEPTNO,DNAME,LOC FROM EMP NATURAL JOIN DEPT;

--JOIN USING : 결합 테이블에 같은 이름의 컬럼이 여러개 있는 경우 특정 컬럼에 저장된 컬럼값이 같은 행을 서로 결합하여 검색
--형식)SELECT 검색대상,... FROM 테이블명1 JOIN 테이블명2 USING(컬럼명)

--EMP 테이블과 DEPT 테이블에서 SALES 부서에 근무하는 사원의 사원번호,사원이름,급여,부서이름,부서위치 검색
--결합조건 : EMP 테이블의 부서번호(DETPNO)와 DEPT 테이블의 부서번호(DETPNO)가 같은 행을 결합하여 검색 
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP JOIN DEPT USING(DEPTNO);

-- INNER JOIN : 결합조건을 명시하여 결합 테이블에서 결합조건이 맞는 행을 결합하여 검색
--형식)SELECT 검색대상,... FROM 테이블명1 INNER JOIN 테이블명2 ON 결합조건

--EMP 테이블과 DEPT 테이블에서 SALES 부서에 근무하는 사원의 사원번호,사원이름,급여,부서이름,부서위치 검색
--결합조건 : EMP 테이블의 부서번호(DETPNO)와 DEPT 테이블의 부서번호(DETPNO)가 같은 행을 결합하여 검색 
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP INNER JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO;
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO;--INNER 키워드 생략 가능

--EMP 테이블과 DEPT 테이블에서 SALES 부서에 근무하는 사원의 사원번호,사원이름,급여,부서번호,부서이름,부서위치 검색
--INNER JOIN을 사용할 경우 검색대상으로 결합 테이블에 존재하는 동일한 컬럼명을 검색할 때 반드시 테이블을 명시하여 검색
SELECT EMPNO,ENAME,SAL,EMP.DEPTNO,DNAME,LOC FROM EMP INNER JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO;
SELECT EMPNO,ENAME,SAL,DEPT.DEPTNO,DNAME,LOC FROM EMP INNER JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO;

--EMP 테이블과 SALGRADE 테이블에서 모든 사원의 사원번호,사원이름,급여,급여등록번호 검색
--검색조건 : EMP 테이블의 급여(SAL)가 SALGRADE 테이블의 최소급여(LOSAL)와 최대급여(HISAL)에 포함될 경우 행을 결합
SELECT EMPNO,ENAME,SAL,GRADE FROM EMP JOIN SALGRADE ON SAL BETWEEN LOSAL AND HISAL;

--EMP 테이블과 DEPT 테이블, SALGRADE 테이블에서 모든 사원의 사원번호,사원이름,급여,부서이름,부서위치,급여등급번호 검색
--결합조건-1 : EMP 테이블의 부서번호(DETPNO)와 DEPT 테이블의 부서번호(DETPNO)가 같은 행을 결합하여 검색 
--검색조건-2 : EMP 테이블의 급여(SAL)가 SALGRADE 테이블의 최소급여(LOSAL)와 최대급여(HISAL)에 포함될 경우 행을 결합
SELECT EMPNO,ENAME,SAL,DNAME,LOC,GRADE FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO 
    JOIN SALGRADE ON SAL BETWEEN LOSAL AND HISAL;
    
--EMP 테이블과 DEPT 테이블에서 SALES 부서에 근무하는 사원의 사원번호,사원이름,급여,부서이름,부서위치 검색
--결합조건 : EMP 테이블의 부서번호(DETPNO)와 DEPT 테이블의 부서번호(DETPNO)가 같은 행을 결합하여 검색 
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO WHERE DNAME='SALES';

--OUTER JOIN : 결합조건을 명시하여 결합 테이블에서 결합조건이 맞는 행만 결합하여 검색하는 것이 아니라 결합조건이 맞지 
--않는 경우 NULL과 결합하여 검색
--형식)SELECT 검색대상,... FROM 테이블명1 {LEFT|RIGHT|FULL} OUTER JOIN 테이블명2 ON 결합조건
--LEFT OUTER JOIN : 왼쪽 테이블의 모든 행을 검색하고 오른쪽 테이블은 결합조건이 맞는 행이 없는 경우 NULL과 결합하여 검색
--RIGHT OUTER JOIN : 오른쪽 테이블의 모든 행을 검색하고 왼쪽 테이블은 결합조건이 맞는 행이 없는 경우 NULL과 결합하여 검색
--FULL OUTER JOIN : 모든 테이블의 행을 결합하여 검색하고 오른쪽과 왼쪽 테이블에 결합조건이 맞는 행이 없는 경우 NULL과 결합하여 검색

--EMP 테이블과 DEPT 테이블에서 모든 사원의 사원번호,사원이름,급여,부서이름,부서위치 검색
--결합조건 : EMP 테이블의 부서번호(DETPNO)와 DEPT 테이블의 부서번호(DETPNO)가 같은 행을 결합하여 검색하되 
--결합조건이 맞지 않는 행은 NULL과 결합하여 검색
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP LEFT OUTER JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO;
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP RIGHT OUTER JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO;
SELECT EMPNO,ENAME,SAL,DNAME,LOC FROM EMP FULL JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO;--OUTER 키워드 생략 가능

--EMP 테이블에 저장된 모든 사원의 사원번호,사원이름,관리자번호(사원번호),관리자이름(사원이름) 검색
--결합조건 : EMP 테이블(별칭:WORKER)의 관리자번호(MGR)와 EMP 테이블(별칭:MANAGER)의 사원번호(EMPNO)가 같은 행을 결합하여 검색
--INNER JOIN을 사용하면 결합조건이 맞은 행만 검색하므로 EMP 테이블(별칭:WORKER)의 관리자번호(MGR)에 NULL이 저장된 사원 미검색
SELECT WORKER.EMPNO,WORKER.ENAME WORKER_ENAME,WORKER.MGR,MANAGER.ENAME MANAGER_ENAME
    FROM EMP WORKER JOIN EMP MANAGER ON WORKER.MGR=MANAGER.EMPNO;
    
--LEFT OUTER JOIN을 사용하여 결합조건이 맞은 행만 검색하는 것이 아니라 EMP 테이블(별칭:WORKER)의 관리자번호(MGR)에 NULL이 
--저장된 사원의 관리자이름을 NULL로 결합하여 검색   
SELECT WORKER.EMPNO,WORKER.ENAME WORKER_ENAME,WORKER.MGR,MANAGER.ENAME MANAGER_ENAME
    FROM EMP WORKER LEFT JOIN EMP MANAGER ON WORKER.MGR=MANAGER.EMPNO;

--문제1.부서 테이블과 사원 테이블에서 사번,사원명,부서코드,부서명을 검색하시오.(사원명 오름차순 정렬할 것)
SELECT EMPNO,ENAME,EMP.DEPTNO,DNAME FROM EMP INNER JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO ORDER BY ENAME ASC;
SELECT EMPNO,ENAME,DEPT.DEPTNO,DNAME FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO ORDER BY ENAME;

--문제2.부서 테이블과 사원 테이블에서 사번,사원명,급여,부서명을 검색하시오.
--단, 급여가 2000 이상인 사원에 대하여 급여기준으로 내림차순 정렬할 것.
SELECT EMPNO,ENAME,SAL,DNAME FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO WHERE SAL>=2000 ORDER BY SAL DESC;

--문제3.부서 테이블과 사원 테이블에서 사번,사원명,업무,급여,부서명을 검색하시오.
--단, 엄무가 MANAGER이며 급여가 2500 이상인 사원에 대하여 사번을 기준으로 오름차순 정렬할 것.
SELECT EMPNO,ENAME,JOB,SAL,DNAME FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO 
    WHERE JOB='MANAGER' AND SAL>=2500 ORDER BY EMPNO;
    
--문제4.사원 테이블과 급여등급 테이블에서 사번,사원명,급여,등급을 검색하시오. 
--단, 등급은 급여가 하한값과 상한값 범위에 포함되고 등급이 4이며 급여를 기준으로 내림차순 정렬할 것.
SELECT EMPNO,ENAME,SAL,GRADE FROM EMP JOIN SALGRADE ON SAL BETWEEN LOSAL AND HISAL WHERE GRADE=4 ORDER BY SAL DESC;

--문제5.부서 테이블,사원 테이블,급여등급 테이블에서 사번,사원명,부서명,급여,등급을 검색하시오. 
--단, 등급은 급여가 하한값과 상한값 범위에 포함되며 등급을 기준으로 내림차순 정렬할 것.
SELECT EMPNO,ENAME,DNAME,SAL,GRADE FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO 
    JOIN SALGRADE ON SAL BETWEEN LOSAL AND HISAL ORDER BY GRADE DESC;
    
--문제6.사원 테이블에서 사원명과 해당 사원의 관리자명을 검색하시오.  
SELECT W.ENAME 사원명,M.ENAME 관리자명 FROM EMP W JOIN EMP M ON W.MGR=M.EMPNO;

--문제7.사원 테이블에서 사원명,해당 사원의 관리자명,해당 사원의 관리자의 관리자명을 검색하시오
SELECT W.ENAME "사원명",M.ENAME "관리자명",MM.ENAME "관리자의 관리자명" 
    FROM EMP W JOIN EMP M ON W.MGR=M.EMPNO JOIN EMP MM ON M.MGR=MM.EMPNO;
    
--문제8.7번 결과에서 상위 관리자가 없는 모든 사원의 이름도 사원명에 출력되도록 수정하시오.
SELECT W.ENAME "사원명",M.ENAME "관리자명",MM.ENAME "관리자의 관리자명" 
    FROM EMP W LEFT JOIN EMP M ON W.MGR=M.EMPNO LEFT JOIN EMP MM ON M.MGR=MM.EMPNO;
    
--서브쿼리(SUBQUERY) : SQL 명령에 포함되어 실행되는 SELECT 명령
--다수의 SQL 명령으로 얻을 수 있는 결과를 하나의 SQL 명령으로 얻기 위해 사용하는 기능

--SELECT 명령(MAINQUERY)에 포함되어 실행되는 SELECT 명령(SUBQUERY)
--서브쿼리의 명령 실행 후 제공되는 검색결과를 가지고 메인쿼리의 명령 실행하여 검색
--서브쿼리는 메인쿼리의 FROM,WHERE,HAVING에서 ( )안에 작성하여 실행

--EMP 테이블에서 사원이름이 SCOTT인 사원보다 많은 급여를 받은 사원의 사원번호,사원이름,급여 검색
--SELECT 명령을 2번 사용하여 원하는 결과 검색 
SELECT SAL FROM EMP WHERE ENAME='SCOTT';--검색결과 : 3000
SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL>3000;

--서브쿼리를 이용하면 SELECT 명령을 1번만 사용하여 원하는 결과 검색 가능
--WHERE에서 조건식의 비교값 대신 서브쿼리의 검색 결과값을 사용하여 검색
--조건식의 비교대상(컬럼)과 같은 자료형의 값이 하나만 검색되도록 서브쿼리 작성 
--서브쿼리로 단일행(SINGLE-ROW)의 단일컬럼(SINGLE-COLUMN)에 대한 값 검색 
SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL>(SELECT SAL FROM EMP WHERE ENAME='SCOTT');

--EMP 테이블에서 사원번호가 7844인 사원과 같은 업무를 하는 사원의 사원번호,사원이름,업무,급여 검색
SELECT EMPNO,ENAME,JOB,SAL FROM EMP WHERE JOB=(SELECT JOB FROM EMP WHERE EMPNO=7844) AND EMPNO<>7844;

--EMP 테이블에서 사원번호가 7521인 사원과 같은 업무를 하는 사원 중 사원번호가 7844안 사원보다 많은 급여를 
--사원의 사원번호,사원이름,업무,급여 검색
SELECT EMPNO,ENAME,JOB,SAL FROM EMP WHERE JOB=(SELECT JOB FROM EMP WHERE EMPNO=7521) AND EMPNO<>7521
    AND SAL>(SELECT SAL FROM EMP WHERE EMPNO=7844);
    
--EMP 테이블에서 SALES 부서에 근무하는 사원의 사원번호,사원이름,업무,급여 검색
--부서이름은 DEPT 테이블에 저장되어 있으므로 테이블 결합을 사용하여 검색
SELECT EMPNO,ENAME,JOB,SAL FROM EMP JOIN DEPT ON EMP.DEPTNO=DEPT.DEPTNO WHERE DNAME='SALES';

--테이블 결합 대신 서브쿼리를 사용하여 검색 가능
SELECT EMPNO,ENAME,JOB,SAL FROM EMP WHERE DEPTNO=(SELECT DEPTNO FROM DEPT WHERE DNAME='SALES');

--EMP 테이블에 저장된 모든 사원 중 가장 적은 급여를 받는 사원의 사원번호,사원일,업무,급여 검색
SELECT EMPNO,ENAME,JOB,SAL FROM EMP WHERE SAL=(SELECT MIN(SAL) FROM EMP);

--EMP 테이블에서 SALES 부서에 근무하는 사원 중 가작 적은 급여를 받는 사원의 사원번호,사원이름,업무,급여 검색
--오라클은 서브쿼리 안에 서브쿼리 사용 가능
SELECT EMPNO,ENAME,JOB,SAL FROM EMP WHERE SAL=(SELECT MIN(SAL) FROM EMP 
    WHERE DEPTNO=(SELECT DEPTNO FROM DEPT WHERE DNAME='SALES'));
    
--EMP 테이블에서 부서별 평균 급여 중 가장 많은 평균 급여를 받는 부서의 부서번호와 평균급여 검색
--HAVING의 그룹조건식에서 비교값 대신 서브쿼리를 사용하여 검색
SELECT DEPTNO,CEIL(AVG(SAL)) AVG_SAL FROM EMP GROUP BY DEPTNO 
    HAVING AVG(SAL)=(SELECT MAX(AVG(SAL)) FROM EMP GROUP BY DEPTNO);

--EMP 테이블에서 부서별로 가장 적은 급여를 받은 사원의 사원번호,사원이름,급여,부서번호 검색
--서버쿼리의 검색결과가 다중행(MULTI-ROW SUBQUERY)인 경우 = 연산자를 사용하여 컬럼값을 비교할 경우 에러 발생
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE SAL=(SELECT MIN(SAL) FROM EMP GROUP BY DEPTNO);
    
--서브쿼리의 검색결과가 다중행인 경우 = 연산자 대신 IN 키워드를 사용하여 컬럼값을 비교하여 검색    
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE SAL IN(SELECT MIN(SAL) FROM EMP GROUP BY DEPTNO);    

--서브쿼리의 검색결과가 다중행인 경우 > 또는 < 연산자로 비교하기 위해 서브쿼리 앞에 ANY 또는 ALL 키워드를 사용하여 검색

--EMP 테이블에서 부서번호가 10인 부서에 근무하는 어떠한 사원보다 급여가 적은 사원의 사원번호,사원이름,급여,부서번호 검색
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE SAL<ANY(SELECT SAL FROM EMP WHERE DEPTNO=10) AND DEPTNO<>10;

--EMP 테이블에서 부서번호가 10인 부서에 근무하는 모든 사원보다 급여가 적은 사원의 사원번호,사원이름,급여,부서번호 검색
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE SAL<ALL(SELECT SAL FROM EMP WHERE DEPTNO=10);

--EMP 테이블에서 부서번호가 20인 부서에 근무하는 어떠한 사원보다 급여가 많은 사원의 사원번호,사원이름,급여,부서번호 검색
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE SAL>ANY(SELECT SAL FROM EMP WHERE DEPTNO=20) AND DEPTNO<>20;

--EMP 테이블에서 부서번호가 20인 부서에 근무하는 모든 사원보다 급여가 많은 사원의 사원번호,사원이름,급여,부서번호 검색
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE SAL>ALL(SELECT SAL FROM EMP WHERE DEPTNO=20);

--다중행 서브쿼리의 ANY 또는 ALL 대신 단일행 서브쿼리의 MIN 또는 MAX 함수 사용 권장

--EMP 테이블에서 부서번호가 10인 부서에 근무하는 어떠한 사원보다 급여가 적은 사원의 사원번호,사원이름,급여,부서번호 검색
--컬럼명<ANY(다중행 서브쿼리) 대신 컬럼명<(단일행 서브쿼리 - MAX 함수) 사용
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE SAL<(SELECT MAX(SAL) FROM EMP WHERE DEPTNO=10) AND DEPTNO<>10;

--EMP 테이블에서 부서번호가 10인 부서에 근무하는 모든 사원보다 급여가 적은 사원의 사원번호,사원이름,급여,부서번호 검색
--컬럼명<ALL(다중행 서브쿼리) 대신 컬럼명<(단일행 서브쿼리 - MIN 함수) 사용
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE SAL<(SELECT MIN(SAL) FROM EMP WHERE DEPTNO=10);

--EMP 테이블에서 부서번호가 20인 부서에 근무하는 어떠한 사원보다 급여가 많은 사원의 사원번호,사원이름,급여,부서번호 검색
--컬럼명>ANY(다중행 서브쿼리) 대신 컬럼명>(단일행 서브쿼리 - MIN 함수) 사용
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE SAL>(SELECT MIN(SAL) FROM EMP WHERE DEPTNO=20) AND DEPTNO<>20;

--EMP 테이블에서 부서번호가 20인 부서에 근무하는 모든 사원보다 급여가 많은 사원의 사원번호,사원이름,급여,부서번호 검색
--컬럼명>ALL(다중행 서브쿼리) 대신 컬럼명>(단일행 서브쿼리 - MAX 함수) 사용
SELECT EMPNO,ENAME,SAL,DEPTNO FROM EMP WHERE SAL>(SELECT MAX(SAL) FROM EMP WHERE DEPTNO=20);

--EMP 테이블에서 사원이름이 ALLEN인 사원과 관리자가 같으며 같은 업무를 하는 사원의 사원번호,사원이름,관리자번호,업무,급여 검색
SELECT EMPNO,ENAME,MGR,JOB,SAL FROM EMP WHERE MGR=(SELECT MGR FROM EMP WHERE ENAME='ALLEN')
    AND JOB=(SELECT JOB FROM EMP WHERE ENAME='ALLEN') AND ENAME<>'ALLEN';
    
--서브쿼리의 검색대상이 여러 개(MULTI-COLUMN SUBQUERY)인 경우 비교인 경우 비교 컬럼을 ( )안에 ,로 구분하여 나열하면 비교 가능
SELECT EMPNO,ENAME,MGR,JOB,SAL FROM EMP WHERE (MGR,JOB)=(SELECT MGR,JOB FROM EMP WHERE ENAME='ALLEN') AND ENAME<>'ALLEN';

--문제1.사원 테이블에서 BLAKE 보다 급여가 많은 사원들의 사번,이름,급여를 검색하시오.
SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL>(SELECT SAL FROM EMP WHERE ENAME='BLAKE');

--문제2.사원 테이블에서 MILLER 보다 늦게 입사한 사원의 사번,이름,입사일을 검색하시오.
SELECT EMPNO,ENAME,HIREDATE FROM EMP WHERE HIREDATE>(SELECT HIREDATE FROM EMP WHERE ENAME='MILLER');

--문제3.사원 테이블에서 사원 전체 평균 급여보다 급여가 많은 사원들의 사번,이름,급여 검색하시오.
SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL>(SELECT AVG(SAL) FROM EMP);

--문제4.사원 테이블에서 CLARK와 같은 부서이며, 사번이 7698인 직원의 급여보다 많은 급여를 받는 사원들의 사번,이름,급여를 검색하시오.
SELECT EMPNO,ENAME,SAL FROM EMP WHERE DEPTNO=(SELECT DEPTNO FROM EMP WHERE ENAME='CLARK') 
    AND SAL>(SELECT SAL FROM EMP WHERE EMPNO=7698);
    
--문제5.사원 테이블에서 부서별 최대 급여를 받는 사원들의 사번,이름,부서코드,급여를 검색하시오.
SELECT EMPNO,ENAME,DEPTNO,SAL FROM EMP WHERE SAL IN(SELECT MAX(SAL) FROM EMP GROUP BY DEPTNO) ORDER BY DEPTNO;

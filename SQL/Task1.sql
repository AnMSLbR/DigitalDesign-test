/*1. Сотрудник с максимальной заработной платой*/
SELECT * FROM EMPLOYEE WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);

/*2. Максимальная длина цепочки руководителей по таблице сотрудников*/
WITH EMPLOYEE_TREE AS (
    SELECT ID, CHEF_ID, 1 AS DEPTH
    FROM EMPLOYEE
    WHERE CHEF_ID IS NULL --корневые сотрудники, у которых не указан руководитель
    UNION ALL
    SELECT e.ID, e.CHEF_ID, et.DEPTH + 1 AS DEPTH
    FROM EMPLOYEE e
    JOIN EMPLOYEE_TREE et ON et.ID = e.CHEF_ID
)
SELECT MAX(DEPTH) AS MAX_DEPTH
FROM EMPLOYEE_TREE;

/*3. Отдел, с максимальной суммарной зарплатой сотрудников*/
WITH SALARIES_BY_DEPARTMENT AS (
    SELECT D.NAME, SUM(E.SALARY) AS TOTAL_SALARY,
           RANK() OVER (ORDER BY SUM(E.SALARY) DESC) AS RANK
    FROM DEPARTMENT D
    INNER JOIN EMPLOYEE E ON D.ID = E.DEPARTMENT_ID
    GROUP BY D.ID, D.NAME
)
SELECT NAME, TOTAL_SALARY
FROM SALARIES_BY_DEPARTMENT
WHERE RANK = 1;

/*4. Сотрудник, чье имя начинается на «Р» и заканчивается на «н»*/
SELECT * FROM EMPLOYEE WHERE NAME LIKE 'Р%н';

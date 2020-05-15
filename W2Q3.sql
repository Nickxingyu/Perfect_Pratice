USE employees

CREATE TEMPORARY TABLE dept_gender_salary
SELECT dept_no, gender, salary
FROM(
    SELECT emp_no, salary
    FROM salaries s
    LEFT JOIN(
        SELECT emp_no, MAX(from_date) last_date
        FROM salaries GROUP BY emp_no
    ) s1 USING(emp_no)
    WHERE  from_date = last_date
)s2
INNER JOIN(
    SELECT emp_no, dept_no
    FROM dept_emp
    LEFT JOIN(
        SELECT emp_no, MAX(from_date) last_date
        FROM dept_emp GROUP BY emp_no
    ) s3 USING(emp_no)
    WHERE  from_date = last_date
)s4 USING(emp_no)
INNER JOIN employees USING(emp_no);

SELECT * FROM dept_gender_salary LIMIT 100;

CREATE TEMPORARY TABLE Summary
SELECT 'Total' dep, gender, AVG(salary) avg
FROM dept_gender_salary
GROUP BY gender;

SELECT * FROM Summary LIMIT 100;

CREATE TEMPORARY TABLE Entire_dept_gender_salary
SELECT * FROM Summary
UNION
(SELECT dept_no dep, gender, AVG(salary) avg
FROM dept_gender_salary
GROUP BY dep, gender);

SELECT * FROM Entire_dept_gender_salary LIMIT 100;

SELECT dep, mt.avg-ft.avg diff
FROM (
    SELECT * FROM Entire_dept_gender_salary WHERE gender='M'
) mt
INNER JOIN (
    SELECT * FROM(
         SELECT * FROM Summary
         UNION
         SELECT dept_no dep, gender, AVG(salary) avg
         FROM dept_gender_salary
         GROUP BY dep, gender
    ) t WHERE gender='F'
) ft USING(dep);

SELECT * FROM Entire_dept_gender_salary WHERE gender='M';
SELECT * FROM Entire_dept_gender_salary WHERE gender='F';

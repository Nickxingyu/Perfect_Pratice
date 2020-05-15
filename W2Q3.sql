USE employees

CREATE TEMPORARY TABLE dept_gender_salary
SELECT dept_no, gender, salary
FROM(
	SELECT emp_no, salary
	FROM(
		SELECT emp_no, MAX(from_date) from_date
		FROM salaries GROUP BY emp_no
	)s1
	LEFT JOIN salaries USING(emp_no, from_date)
)s2
INNER JOIN(
    SELECT emp_no, dept_no
	FROM(
		SELECT emp_no, MAX(from_date) from_date
		FROM dept_emp GROUP BY emp_no
	)s3
	LEFT JOIN dept_emp USING(emp_no, from_date)
)s4
INNER JOIN employees USING(emp_no);


CREATE TEMPORARY TABLE Summary
SELECT 'Total' dep, gender, AVG(salary) avg
FROM dept_gender_salary
GROUP BY gender;

CREATE TEMPORARY TABLE Entire_dept_gender_salary
SELECT * FROM Summary
UNION
(SELECT dept_no dep, gender, AVG(salary) avg
FROM dept_gender_salary
GROUP BY dep, gender);


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

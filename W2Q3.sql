USE employees

CREATE TEMPORARY TABLE dept_gender_salary

SELECT emp_no, salary
FROM salaries s
LEFT JOIN(
	SELECT emp_no, MAX(from_date) last_date
	FROM salaries GROUP BY emp_no
) s1 USING(emp_no)
WHERE  from_date = last_date;

SELECT * FROM dept_gender_salary;

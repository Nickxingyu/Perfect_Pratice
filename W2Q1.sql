USE employees

SELECT 'HELLO';

SELECT dept_no, AVG(salary) salary
FROM(
    SELECT emp_no, salary
    FROM salaries
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
)s4
GROUP BY dept_no
ORDER BY salary DESC
LIMIT 1 ;

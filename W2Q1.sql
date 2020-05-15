USE employees

SELECT 
    dept_no, 
    dept_name, 
    AVG(salary) avg_salary
FROM dept_emp
INNER JOIN departments USING (dept_no)
INNER JOIN salaries USING (emp_no)
GROUP BY dept_no
ORDER BY avg_salary DESC
LIMIT 1;

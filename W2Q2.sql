USE employees

SELECT @lasttitle:= '' , @colnum:=0;

CREATE TEMPORARY TABLE Title_and_salary
SELECT title, salary
FROM(
	SELECT emp_no, salary
	FROM(
		SELECT emp_no, MAX(from_date) from_date
		FROM salaries GROUP BY emp_no
	)s1
	LEFT JOIN salaries USING(emp_no, from_date)
)s2
INNER JOIN(
	SELECT emp_no, title
	FROM(
		SELECT emp_no, MAX(from_date) from_date
		FROM titles GROUP BY emp_no
	)s3
	LEFT JOIN titles USING(emp_no,from_date)
)s4 USING(emp_no)
ORDER BY title, salary;

SELECT * FROM Title_and_salary LIMIT 100;

CREATE TEMPORARY TABLE Sort_title_and_salary
SELECT title, salary,cnt
FROM(
	SELECT title, salary,
	IF(title = @lasttitle, @colnum := @colnum+1, @colnum := 1) cnt,
	@lasttitle := title
	FROM Title_and_salary
)s6;

SELECT * FROM Sort_title_and_salary LIMIT 100;

CREATE TEMPORARY TABLE Count_of_title
SELECT title, COUNT(*) total FROM Sort_title_and_salary
GROUP BY title;

SELECT * FROM Count_of_salary LIMIT 100;

SELECT*
FROM(
	SELECT title,
	       AVG(salary) Average,
	       STD(salary) 'STD',
	       STD(salary)*STD(salary) 'Variation'
	FROM Title_and_salary
	GROUP BY title
) s1
INNER JOIN(
	SELECT title, AVG(salary) Median
	FROM(
		SELECT title, salary, cnt, total
		FROM Sort_title_and_salary LEFT JOIN Count_of_title USING(title)
		HAVING (total % 2 = 0 and (cnt = total/2 or cnt = (total/2)+1))
		    or (total%2<>0 and (cnt = (total+1)/2))
	)s2
	GROUP BY title
	ORDER BY title
)s3 USING(title);

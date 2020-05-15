USE employees

SELECT
    (sss-n*avg_sa*avg_se)/(n*std_sa*std_se) c_ss,
    (sss-n*avg_sa*avg_age)/(n*std_sa*std_age) c_sa,
    (sss-n*avg_sa*avg_g)/(n*std_sa*std_g) c_sg
FROM(
    SELECT
        AVG(salary) avg_sa, AVG(seniority) avg_se, AVG(age) avg_age, 
        AVG(gender) avg_g,
        
        SUM(ss) sss, SUM(sa) ssa, SUM(sg) ssg,
        
        STD(salary) std_sa, STD(seniority) std_se, STD(age) std_age,
        STD(gender) std_g,
        
        COUNT(*) n
    FROM(    
        SELECT 
            salary,
            seniority,
            age,
            gender,
            salary*seniority ss,
            salary*age sa,
            salary*gender sg
        FROM(
            SELECT salary, 
            DATEDIFF(from_date,hire_date) seniority, 
            DATEDIFF(from_date,birth_date) age,
            IF(gender='M',0,1) gender
            FROM employees INNER JOIN salaries USING(emp_no)
        ) s1
    )s2
)s3;

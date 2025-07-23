-- Cameron Houpe, 2/25/25
use projectexercise;

-- create the PK for the project table
ALTER TABLE project
ADD PRIMARY KEY(Proj_Num);

-- create the PK for the employee table
ALTER TABLE employee
ADD PRIMARY KEY(Emp_Num);

-- create the PK for the jobclass table
ALTER TABLE jobclass
ADD PRIMARY KEY(job_class_code(3));

-- create the composite PK for the assignment table
ALTER TABLE assignment
ADD constraint pkc_Name PRIMARY KEY (Proj_Num, Emp_Num);

ALTER TABLE employee MODIFY Job_Class_Code VARCHAR(3);

ALTER TABLE jobclass MODIFY Job_Class_Code VARCHAR(3);


ALTER TABLE assignment
ADD CONSTRAINT FK_emp_num FOREIGN KEY (Emp_Num)
REFERENCES employee(Emp_Num);

ALTER TABLE assignment
ADD CONSTRAINT FK_proj_num FOREIGN KEY (Proj_Num)
REFERENCES project(Proj_Num);

ALTER TABLE employee
ADD CONSTRAINT FK_job_class_code FOREIGN KEY (Job_Class_Code)
REFERENCES jobclass(Job_Class_Code);

SELECT Count(*) AS ‘CountofProjects’
FROM project;

SELECT Count(Proj_Num) AS 'Count of Projects using an Electrical Engineer'
FROM assignment, employee
WHERE assignment.Emp_Num = employee.Emp_Num
AND Job_Class_Code = 'EE';

SELECT proj_name, FORMAT(SUM(hourly_chargeout_rate*hours_charged),2) AS Project_Charges
FROM assignment, project, jobclass, employee
WHERE assignment.proj_num = project.proj_num
AND assignment.emp_num = employee.emp_num
AND employee.job_class_code = jobclass.job_class_code
GROUP BY proj_name
ORDER BY proj_name;

SELECT emp_lname, emp_fname, 
ROUND(SUM(hourly_chargeout_rate*hours_charged), 2) AS Project_Charges
FROM assignment, project, jobclass, employee
WHERE assignment.proj_num = project.proj_num
AND assignment.emp_num = employee.emp_num
AND employee.job_class_code = jobclass.job_class_code
GROUP BY emp_lname, emp_fname
ORDER BY Project_Charges DESC;

SELECT Proj_Num, FORMAT(SUM(Hours_Charged*Hourly_Chargeout_Rate),2) AS 'ProjectCharges',
	(SELECT FORMAT (SUM(Hours_Charged*Hourly_Chargeout_Rate), 2)
	FROM project AS p, assignment AS a, jobclass AS j, employee as e
	WHERE p.ProJ_Num = a.ProJ_Num
	AND j.Job_Class_Code = e.Job_Class_Code
	AND a.Emp_Num = e.Emp_Num) AS 'AllProjectCharges'
FROM employee, assignment, jobclass
WHERE employee.Emp_Num = assignment.Emp_Num
AND employee.Job_Class_Code = jobclass.Job_Class_Code
GROUP BY Proj_Num;

SELECT Count(*) FROM employee;

SELECT Count(*) FROM employee WHERE Job_Class_Code = 'PR';

SELECT DISTINCT Emp_FName, Emp_MName, Emp_LName
FROM employee, assignment
WHERE employee.Emp_Num = assignment.Emp_Num
AND Job_Class_Code = 'PR';

SELECT Job_Class_Desc, count(Emp_Num) AS EmployeeCount
FROM jobclass, employee
WHERE jobclass.Job_Class_Code = employee.Job_Class_Code
GROUP BY Job_Class_Desc
ORDER BY EmployeeCount DESC;

SELECT Proj_Name, count(Emp_Num) AS EmployeesOnProject
FROM project, assignment
WHERE project.Proj_Num = assignment.Proj_Num
GROUP BY Proj_Name
ORDER BY EmployeesOnProject DESC;

SELECT jobclass.job_class_code, ROUND(SUM(hourly_chargeout_rate*hours_charged), 2) 
AS Project_Charges
FROM assignment, project, jobclass, employee
WHERE assignment.proj_num = project.proj_num
AND assignment.emp_num = employee.emp_num
AND employee.job_class_code = jobclass.job_class_code
GROUP BY job_class_code
ORDER BY project_charges DESC;

SELECT jobclass.job_class_code, ROUND(AVG(hourly_chargeout_rate*hours_charged), 2) 
AS Project_Charges
FROM assignment, project, jobclass, employee
WHERE assignment.proj_num = project.proj_num
AND assignment.emp_num = employee.emp_num
AND employee.job_class_code = jobclass.job_class_code
GROUP BY job_class_code
ORDER BY project_charges DESC;


SELECT jobclass.job_class_code, ROUND(AVG(hourly_chargeout_rate*assignment.hours_charged), 2) 
AS Project_Charges
from assignment 
inner join project on assignment.proj_num = project.proj_num
inner join employee on assignment.emp_num = employee.emp_num
inner join jobclass on employee.job_class_code = jobclass.job_class_code
GROUP BY job_class_code
ORDER BY project_charges DESC;

-- What is the average hours charged based on each project name?
SELECT Proj_Name, avg (assignment.hours_charged)
FROM project, assignment
WHERE project.Proj_Num = assignment.Proj_Num
GROUP BY Proj_Name;





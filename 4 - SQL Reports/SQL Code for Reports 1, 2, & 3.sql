
-- SQL Report:

-- 1.) Dept Endorsement Duration after Notice Given

SELECT Department_ID , DATEDIFF(Department_Endorsement_Date,Notice_Date) AS "Endorsement Duration in Days"
FROM A_Withdrawl_Paperwork
GROUP BY Department_ID 


-- 2.) Check resigned employees salary, compared with job salary range 



SELECT e.First_Name, e.Last_Name , e.Salary ,j.Title , j.MinSalary , j.MaxSalary , if(e.Salary BETWEEN j.MinSalary AND j.MaxSalary, 'Salary Within Normal Range', 'Salary Not Within Normal Range') 
FROM A_Employee e 
JOIN A_Withdrawl_Paperwork w
ON (e.Employee_ID = w.Employee_ID)
JOIN A_Job_Title j
ON (e.Job_ID = j.Job_ID)



-- 3.) Assets for Offboarded Employees Report

SELECT ca.Asset_ID , ca.Asset_Type , co.Employee_ID, co.Ownership_End_Date
FROM A_Company_Asset ca
JOIN A_Company_Asset_Ownership co
ON(ca.Asset_ID=co.Asset_ID)
JOIN A_Withdrawl_Paperwork awp 
ON(awp.Employee_ID = co.employee_id)



SELECT * FROM mytable;
USE employee_analysis;
#overall attrition rate
SELECT (COUNT(*)*100.0/(SELECT count(*) FROM mytable)) AS Attrition_Rate
FROM mytable
WHERE Attrition="Yes";

#Attrition Rate by Department
SELECT Department,(COUNT(*)*100.0/(SELECT COUNT(*) FROM mytable)) AS Attrition_Rate_By_Department
FROM mytable
WHERE Attrition="Yes"
GROUP BY Department
ORDER BY Attrition_Rate_By_Department;

#Attrition Rate By Job Role
SELECT JobRole,(COUNT(*) * 100.0 / (SELECT COUNT(*)FROM mytable)) AS Attrition_Rate_By_Department
FROM mytable
WHERE Attrition = 'Yes'
GROUP BY JobRole
ORDER BY Attrition_Rate_By_Department;

#Attriton Rate By Age Group
SELECT
   CASE
      WHEN Age < 25 THEN "Under 25"
      WHEN Age BETWEEN 25 AND 35 THEN "25-35"
      WHEN Age BETWEEN 36 AND 45 THEN "36-45"
      ELSE "Above 45"
   END As Age_Group,
   (COUNT(*)*100.0/(SELECT COUNT(*) FROM mytable)) AS Attrition_Rate_By_AgeGroup
   FROM mytable
   WHERE Attrition="Yes"
   GROUP BY Age_Group
   ORDER BY Attrition_Rate_By_AgeGroup DESC;
   
# Attrition Rate By Gender
SELECT Gender,(COUNT(*)*100.0/(SELECT COUNT(*) FROM mytable)) FROM mytable
GROUP BY Gender;

#Attrition Rate By Salary Hike
SELECT PercentSalaryHike,(COUNT(*)*100.0/(SELECT COUNT(*) FROM mytable)) AS Attrition_Rate_By_Salary_Hike
FROM mytable
WHERE Attrition="Yes"
GROUP BY PercentSalaryHike
ORDER BY PercentSalaryHike;

#Impact Of OverTime On Attrition
SELECT OverTime,(COUNT(*)*100.0/(SELECT COUNT(*) FROM mytable)) AS Attrition_Rate
FROM mytable
GROUP BY OverTime;

#Work life balance and Attrition Rate
SELECT WorkLifeBalance,(COUNT(*)*100.0/(SELECT COUNT(*) FROM mytable)) 
FROM mytable
GROUP BY WorkLifeBalance;

# High risk employees
SELECT EmployeeNumber,JobRole,MonthlyIncome,OverTime,AVG(MonthlyIncome) OVER (PARTITION BY JobRole) AS AvgSalaryByRole,
CASE
   WHEN OverTime="Yes" AND MonthlyIncome < AVG(MonthlyIncome) OVER (PARTITION BY JobRole)
   THEN 'High Attrition Risk'
   ELSE 'Low Attrition Risk'
END AS RiskCategory
FROM mytable
ORDER BY RiskCategory DESC,MonthlyIncome ASC;

# impact of distance from home on attrition
SELECT EmployeeNumber,DistanceFromHome,AVG(DistanceFromHome) OVER() AS AvgDistance,
CASE
   WHEN DistanceFromHome > AVG(DistanceFromHome) OVER() THEN "Far"
   ELSE "Near"
END AS DistanceCategory
FROM mytable
ORDER BY DistanceCategory DESC,DistanceFromHome DESC;

# average work experience of employees who left vs stayed
SELECT Attrition,ROUND(AVG(TotalWorkingYears),2) AS AvgExperience
FROM mytable
GROUP BY Attrition;
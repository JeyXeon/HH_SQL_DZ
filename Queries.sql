SELECT v.Name as vacancy_name, a.Name as area_name, e.Name as employer_name 
	FROM employer as e JOIN employer_vacancy as ev ON ev.Employer_id = e.Id
	JOIN vacancy as v ON ev.Vacancy_id = v.Id
	JOIN area as a ON v.Area_id = a.Id
		WHERE (v.Compensation_to IS NULL) and (v.Compensation_from IS NULL)
			ORDER BY v.Created_at DESC
				LIMIT 10;

SELECT AVG(v.Compensation_from) as average_min, 
	AVG(v.Compensation_to) as average_max, 
	AVG(v.Compensation_to - v.Compensation_from) as average_avg
		FROM vacancy as v 
			WHERE v.Compensation_gross = true;

SELECT company_name FROM (
	SELECT company_name, MAX(temp.amount) as maximum FROM
		(
			SELECT e.Name as company_name, COUNT(r.*) as amount FROM Employer as e 
				LEFT JOIN Employer_vacancy as ev ON e.Id = ev.Employer_id
				JOIN vacancy as v ON ev.Vacancy_id = v.Id
				JOIN vacancy_response as vr ON v.Id = vr.vacancy_id 
				JOIN response as r ON vr.response_id = r.Id
					GROUP BY company_name, amount
		) as temp
		GROUP BY company_name, maximum	
) as final
	ORDER BY maximum DESC, company_name DESC 
		LIMIT 5;

SELECT PERCENTILE_CONT(0.5) within group(ORDER BY temp.amount) FROM 
(
	SELECT e.Name as company, COUNT(v.*) as amount FROM employer as e 
	JOIN employer_vacancy as ev ON e.Id = ev.Employer_id
	JOIN vacancy as v ON ev.Vacancy_id = v.Id
		GROUP BY company
) as temp;

WITH total_sample (city, vacancy_id, cr, re)
	AS
	(
		SELECT ar.Id as city, v.Id as vacancy_id, v.Created_at as cr, r.Date as re 
    			FROM vacancy as v JOIN vacancy_response as vr ON v.Id = vr.vacancy_id
			JOIN response as r ON vr.response_id = r.Id
			JOIN area as ar ON v.Area_id = ar.Id
        		GROUP BY city, v.Id, r.Date)
	)
SELECT DISTINCT city, MAX(min_re - cr) OVER (PARTITION BY city), MIN(min_re - cr) OVER (PARTITION BY city) FROM
(SELECT city, vacancy_id, cr, MIN(re) OVER (PARTITION BY vacancy_id) as min_re FROM
	total_sample as partition_by_vacancies;
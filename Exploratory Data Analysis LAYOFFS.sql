-- Exploring the Layoff Data sets to uncover insights


SELECT *
FROM layoff_staging2
WHERE company = 'google'
;

SELECT *
FROM layoff_staging2
ORDER BY total_laid_off DESC
 ;

-- Industries with the highest and lowest layoff

SELECT industry, SUM(total_laid_off) 
FROM layoff_staging2
GROUP BY industry
ORDER by 2 DESC
;

-- Companies that went under

SELECT *, ROW_NUMBER() OVER()
FROM layoff_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC
;

-- Industry with the most companies that went under

SELECT industry, COUNT(industry)
FROM layoff_staging2
WHERE percentage_laid_off = 1
GROUP BY industry
ORDER BY 2 DESC
;

-- Food and Retail had the most companies that went under, 7 each

SELECT company, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC
;

-- Amazon had the highest layoffs 

SELECT MIN(`date`), MAX(`date`)
FROM layoff_staging2
;
				
-- Country with the most layoffs

SELECT country, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY country
ORDER BY 2 DESC
;
	-- United States had the most layoffs
    
    -- Calculation in Percentages

SELECT country, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY country
ORDER BY 2 DESC
;

WITH percent_of_US AS
(SELECT country, SUM(total_laid_off) as Total
FROM layoff_staging2
GROUP BY country
ORDER by 2 DESC
), percent_of_US1 AS
(SELECT *, SUM(total) OVER() as overall_total
FROM percent_of_US)
SELECT *, (total/overall_total)*100 as percent_of_total
FROM percent_of_US1
;

-- United States had a 69% of the oveall layoffs

-- The year with the most layoffs

SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoff_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC
;

-- 2023 has the most layoffs

-- Lets see if the stages affected the layoffs

SELECT stage, SUM(total_laid_off) 
FROM layoff_staging2
GROUP BY stage
ORDER BY 2 DESC
;

-- Post IPO has more layoffs overall, that doesnt do much because of the size of the 

-- lets check which stage had more companies that went under

SELECT stage, COUNT(stage)
FROM layoff_staging2
WHERE percentage_laid_off = 1
GROUP BY stage
ORDER BY 2 DESC
;

-- Companies at Series B and Acquired stage went under more 

-- Let's do a rolling total off the months

SELECT SUBSTRING(`date`,1,7), SUM(total_laid_off) AS total_off
FROM layoff_staging2
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1 ASC
;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) as Months, SUM(total_laid_off) AS total_off
FROM layoff_staging2
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1 ASC
)
SELECT Months, total_off, SUM(total_off) OVER(ORDER BY months) as rolling__total
FROM Rolling_Total
;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company
;

WITH Company_Year (Company, YEARS, Total_Laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company
),
company_year1 AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY YEARS ORDER BY total_laid_off DESC) as rankk
FROM Company_Year
)
SELECT *
FROM company_year1
WHERE rankk <= 5
;


SELECT *
FROM layoff_staging2
;

SELECT industry, SUM(total_laid_off)
FROM layoff_staging2
GROUP by industry
ORDER BY 2 DESC
;

SELECT stage, SUM(total_laid_off)
FROM layoffs
GROUP BY stage
ORDER BY 2 DESC
;


-- This Exploratory Analysis has uncovered the narrative of the data, identified trends, patterns and outliers.



















-- LAYOFF Data Cleaning Project


SELECT * 
FROM layoffs;

-- Copy Raw data into a different to ensure the integrity of the original data

CREATE TABLE layoff_staging
LIKE layoffs;

INSERT INTO layoff_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoff_staging1;

-- 1, REMOVE DUPLICATES, 
-- We do not have any unique identifier that will help us easily identify duplicate rows,
-- So, we'd have to CREATE a new column and partition by all the columns

SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off,`date`, stage, country, funds_raised) AS ROW_NUM
FROM layoff_staging
;

-- Create a Temp Table to filter out duplicate rows

WITH duplicate_cte as
(SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off,`date`, stage, country, funds_raised) AS row_num
FROM layoff_staging)
SELECT *
FROM duplicate_cte
WHERE row_num > 1
;

-- There are two duplicates, so we'd have to create another stage table since we can't delete off a Temp Table

CREATE TABLE layoff_staging1
LIKE layoff_staging;

ALTER TABLE layoff_staging1
ADD COLUMN row_num INT AFTER funds_raised;

INSERT INTO layoff_staging1
(SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off,`date`, stage, country, funds_raised) AS row_num
FROM layoff_staging)
;

SELECT *
FROM layoff_staging1;

-- we can now delete off the Duplicates

SELECT *
FROM layoff_staging1
WHERE row_num > 1;

DELETE
FROM layoff_staging1
WHERE row_num > 1;

-- Duplicates Deleted

-- 2 Standardization, spellings, spaces and correct date formats

SELECT *
FROM layoff_staging1
WHERE company LIKE ' %';			-- To check spaces before

SELECT *
FROM layoff_staging1
WHERE company LIKE '% ';			-- To check spaces after

-- TRIM the datas with spaces before and/or after

SELECT company, TRIM(company)
FROM layoff_staging1;

UPDATE layoff_staging1
SET company = TRIM(company);


SELECT DISTINCT industry
FROM layoff_staging1
ORDER BY 1;

-- moving on

SELECT DISTINCT location
FROM layoff_staging1
ORDER BY 1;

-- location column is okay

SELECT DISTINCT country
FROM layoff_staging1
ORDER BY 1;

-- lets change the date column which was string to a date data type

CREATE TABLE layoff_staging2
LIKE layoff_staging1;

INSERT INTO layoff_staging2
SELECT *
FROM layoff_staging1;

SELECT *
FROM layoff_staging2;

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;

-- 3. Next, we try to populate null or empty cells that can be populated from the data we already have

SELECT *
FROM layoff_staging2
WHERE industry LIKE '' OR industry IS NULL; 

-- one row has industry column empty, lets try to see if there's another layoff by that company with the industry column filled

SELECT *
FROM layoff_staging2
WHERE company = 'Appsmith' 
ORDER BY company;

-- unfortunately, we only have one entry, so there's nothing to populate it based off,

SELECT DISTINCT industry
FROM layoff_staging2
ORDER BY 1;

-- making personal research, its under information and technology industry, which we dont have, so we'll update it under others

UPDATE layoff_staging2
SET industry = 'other'
WHERE company = 'Appsmith';

-- updated


SELECT *
FROM layoff_staging2
WHERE  (total_laid_off IS NULL OR '') AND (percentage_laid_off IS NULL OR '');

-- Data is now clean and sutitable for exploartion and visualisations










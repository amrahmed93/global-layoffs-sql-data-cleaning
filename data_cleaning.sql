-- first we will check for duplicates (create row numbers first)
SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
	) AS row_num
FROM layoffs_staging
;
-- we can't do WHERE in the above query as row_num doesn't actually exist in our table - but a CTE allows for an instance of it:

WITH duplicate_cte AS (
	SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
	) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- identified duplicates - create secondary table to remove

CREATE TABLE layoffs_staging2 AS
SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
	) AS row_num
FROM layoffs_staging;

-- delete duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- next we standardize our data
-- start with company column (white space)

UPDATE layoffs_staging2
SET company = TRIM(company);

-- then manual check industry (only 1 had to be standardized)
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- noticed blank in industry so do check
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL OR industry = ''
ORDER BY industry;
-- returns 4 with missing industry, but now need to see if there are others with industry populated

SELECT company, industry
FROM layoffs_staging2
WHERE company IN (
    SELECT company
    FROM layoffs_staging2
    WHERE industry IS NULL
       OR industry = ''
)
ORDER BY company;

-- now to fill in the blanks based on the ones filled in
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
	AND t2.industry IS NOT NULL
    AND t2.industry <> '';

-- checking punctuation/grammar
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;

-- removing variations with mistakes
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- removing data that will be useless for analysis
SELECT *
FROM layoffs_staging2
WHERE (total_laid_off IS NULL OR TRIM(total_laid_off) = '')
	AND (percentage_laid_off IS NULL OR TRIM(percentage_laid_off) = '')
;

DELETE
FROM layoffs_staging2
WHERE (total_laid_off IS NULL OR TRIM(total_laid_off) = '')
	AND (percentage_laid_off IS NULL OR TRIM(percentage_laid_off) = '')
;

-- now to standardize our dates (and change type)
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- now we remove the extra column we had created for cleaning
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- now we create our final cleaned table
CREATE TABLE layoffs_cleaned AS
SELECT *
FROM layoffs_staging2;
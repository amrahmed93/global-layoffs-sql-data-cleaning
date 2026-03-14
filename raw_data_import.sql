-- first we create the database
CREATE DATABASE IF NOT EXISTS layoffs_cleaning;

USE layoffs_cleaning;

-- then we create a table to import the data into (check raw file in excel)
CREATE TABLE IF NOT EXISTS layoffs_raw (
	company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off TEXT,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions TEXT
)
;

-- to allow us to import successfully
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'data/layoffs.csv'
INTO TABLE layoffs_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- then create identical table so we leave raw data untouched
CREATE TABLE layoffs_staging LIKE layoffs_raw;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs_raw;
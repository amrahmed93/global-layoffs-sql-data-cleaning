# Global Layoffs Data Cleaning (SQL)



## Overview



This project demonstrates a complete data cleaning workflow using SQL.  

The dataset contains global layoff events collected from multiple public sources and includes information about companies, industries, locations, layoff sizes, and funding stages.



Because the data originates from multiple sources, it contains common real-world data quality issues such as duplicate records, inconsistent text formatting, missing values, and incorrect data types.



The goal of this project is to transform the raw dataset into a structured and reliable dataset suitable for analysis.



---



## Dataset



The dataset contains information about layoffs across various companies and industries worldwide.



Columns include:



- company

- location

- industry

- total_laid_off

- percentage_laid_off

- date

- stage

- country

- funds_raised_millions



The raw dataset is included in this repository and imported into MySQL for cleaning.



---



## Data Cleaning Process



The cleaning process follows a structured pipeline commonly used in real-world data preparation:



1. Import the raw dataset into SQL

2. Create a staging table to preserve the original data

3. Identify and remove duplicate records

4. Standardize text fields (company names, industry labels)

5. Fill missing industry values using existing company records

6. Standardize country names to remove punctuation inconsistencies

7. Remove rows with insufficient layoff information

8. Convert the date column from text to a proper DATE datatype

9. Generate a final cleaned dataset



The final cleaned dataset is stored in the table `layoffs_cleaned`.



---



## SQL Techniques Used



This project demonstrates several SQL techniques commonly used in data cleaning:



- Window functions (`ROW_NUMBER()`)

- Common Table Expressions (CTEs)

- Self joins

- Data standardization using `TRIM()` and pattern matching

- Handling missing values (`NULL`)

- Data type conversion using `STR_TO_DATE()`

- Removing duplicates and invalid records

- Creating staged transformation tables



---



## Project Structure



```

global-layoffs-sql-cleaning

│

├── README.md

├── raw_data_import.sql

├── data_cleaning.sql

│

└── data

         └── layoffs.csv

```



**raw_data_import.sql**  

Imports the raw dataset and creates the initial staging table.



**data_cleaning.sql**  

Performs the full data cleaning pipeline and produces the final cleaned dataset.



**data/layoffs.csv**  

Original dataset used for the project.



---



## Result



The final cleaned dataset removes duplicates, standardizes categorical values, handles missing data, and converts the date column into a proper SQL date format.



This prepares the data for reliable downstream analysis such as trend analysis, industry comparisons, and geographic insights.



---



## Author



Amr Ahmed


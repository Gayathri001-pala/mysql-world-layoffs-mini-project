-- Mysql project - World layoffs - data cleaning
SET SQL_SAFE_UPDATES = 0;

use world_layoffs;

SELECT  count(*) 
FROM layoffs;

SELECT count(*) as total_number_of_rows  
FROM  layoffs;

DESC layoffs;

SELECT company 
FROM layoffs 
where company is NULL ;

SELECT Location
FROM layoffs 
where location is NULL ;


SELECT total_laid_off
FROM layoffs 
where total_laid_off is NULL;


SELECT percentage_laid_off
FROM layoffs 
where percentage_laid_off is NULL;

SELECT date 
FROM layoffs 
where date is NULL; 

SELECT stage
FROM layoffs 
where stage is NULL; 

SELECT country
FROM layoffs 
where country is NULL;

select 
sum(case when (company is null or company='') then 1 else 0 end) as company_nulls,
sum(case when (location is null or location='') then 1 else 0 end) as location_nulls,
sum(case when (industry is null or industry='') then 1 else 0 end) as industry_nulls,
sum(case when (total_laid_off is null or total_laid_off = '')  then 1 else 0 end) as laid_off_nulls,
sum(case when (percentage_laid_off is null or percentage_laid_off = '') then 1 else 0 end ) as percent_laidoff_nulls,
sum(case when (`date` is null or date='') then 1 else 0 end) as date_nulls,
sum(case when (stage is null or stage='') then 1 else 0 end) as stage_nulls,
sum(case when  (country is null or country='') then 1 else 0 end) as country_nulls,
sum(case when (funds_raised_millions is null  or funds_raised_millions='')  then 1 else 0 end) as funds_nulls
FROM layoffs;

create table layoffs_staging1 
like layoffs;

select * from layoffs_staging1;

insert into  layoffs_staging1 
select * from layoffs;

select * from layoffs_staging1;


drop table layoffs_staging1;

create table layoffs_staging1 as select * from layoffs;

select * from (select row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,
stage,country,funds_raised_millions) as `row_number` from layoffs_staging1) as new_table where `row_number` = 2;


select count(*) from layoffs_staging1;

CREATE TABLE layoffs_staging2 AS
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company, location, country, industry, stage, percentage_laid_off,
                        total_laid_off, `date`, funds_raised_millions) AS `row_number`
FROM layoffs_staging1;

select count(*) from layoffs_staging2 where `row_number`>1;

delete from layoffs_staging2
where `row_number`>1;

alter table layoffs_staging2
drop column `row_number`;

select distinct(industry) from layoffs_staging2 order by industry;

update layoffs_staging2
SET location=trim(location);

select industry from layoffs_staging2 where industry like ' % ' or industry like '% ' or industry like ' %';



UPDATE layoffs_staging2
set industry='Crypto Currency' where industry like 'Crypto%';

desc layoffs_staging2;


select count(*) from layoffs_staging2;

select company from layoffs_staging2 where company is NULL or company='';


select 
sum(case when (company is null or company='') then 1 else 0 end) as company_nulls,
sum(case when (location is null or location='') then 1 else 0 end) as location_nulls,
sum(case when (industry is null or industry='') then 1 else 0 end) as industry_nulls,
sum(case when (total_laid_off is null or total_laid_off = '')  then 1 else 0 end) as laid_off_nulls,
sum(case when (percentage_laid_off is null or percentage_laid_off = '') then 1 else 0 end ) as percent_laidoff_nulls,
sum(case when (`date` is null or date='') then 1 else 0 end) as date_nulls,
sum(case when (stage is null or stage='') then 1 else 0 end) as stage_nulls,
sum(case when  (country is null or country='') then 1 else 0 end) as country_nulls,
sum(case when (funds_raised_millions is null  or funds_raised_millions='')  then 1 else 0 end) as funds_nulls
FROM layoffs;



select * from layoffs_staging2 
where company='Abra'  ;

select distinct company from layoffs_staging2;

select * from layoffs_staging2 
where company like 'juul';

select * from layoffs_staging2 where industry is null or industry='';

select * from layoffs_staging2;

update layoffs_staging2
set company=trim(company);

update layoffs_staging2
set location=trim(location);

select distinct industry from layoffs_staging2 order by industry;

update layoffs_staging2
set industry = trim(industry);

create table layoffs_staging3 as
select * from layoffs_staging2;

select distinct country from layoffs_staging2 order by country;

update layoffs_staging2
set country ='United States' where country like 'United States.';

update layoffs_staging2 
set `date` = str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

select * from layoffs_staging2layoffs_staging3 where company like 'B%' order by company;

update layoffs_staging2
set industry=NULL where industry='';

update layoffs_staging2 t1 join layoffs_staging2 t2  
on t1.company=t2.company 
set t1.industry=t2.industry
where  t1.industry is null  and t2.industry is not null;

delete from
layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

select * from layoffs_staging3;

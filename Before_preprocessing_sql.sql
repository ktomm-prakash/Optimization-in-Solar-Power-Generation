select * from solar_power_project;

#1st business moment (Mean/Median/Mode)
#mean

SELECT 
    AVG(UNIT1_INV1_Power) AS mean_UNIT1_INV1_Power, 
    AVG(UNIT1_INV2_Power) AS mean_UNIT1_INV2_Power, 
    AVG(UNIT2_INV1_Power) AS mean_UNIT2_INV1_Power,
    AVG(UNIT2_INV2_Power) AS mean_UNIT2_INV2_Power,
    AVG(GII) AS mean_GII,
    AVG(`MODULE TEMP.1`) AS mean_MODULE_TEMP,
    AVG(RAIN) AS mean_RAIN,
    AVG(`AMBIENT TEMPRETURE`) AS mean_AMBIENT_TEMPRETURE
FROM solar_power_project;


#Median

select 
UNIT1_INV1_Power as median_UNIT1_INV1_Power, 
UNIT1_INV2_Power as median_UNIT1_INV2_Power, 
UNIT2_INV1_Power as median_UNIT2_INV1_Power,
UNIT2_INV2_Power as median_UNIT2_INV2_Power,
GII AS median_GII,
`MODULE TEMP.1` AS median_MODULE_TEMP,
RAIN AS median_RAIN,
`AMBIENT TEMPRETURE` AS median_AMBIENT_TEMPRETURE
from 
(
select UNIT1_INV1_Power, UNIT1_INV2_Power, UNIT2_INV1_Power, UNIT2_INV2_Power,GII,`MODULE TEMP.1`,RAIN,`AMBIENT TEMPRETURE`,
row_number() over (order by UNIT1_INV1_Power, UNIT1_INV2_Power, UNIT2_INV1_Power, UNIT2_INV2_Power,GII,`MODULE TEMP.1`,RAIN,`AMBIENT TEMPRETURE`)
as row_num,
count(*) over () as total_count
from solar_power_project
) as subquery
where row_num = (total_count + 1) / 2 or row_num = (total_count + 2) / 2;


#Mode

select
UNIT1_INV1_Power as Mode_UNIT1_INV1_Power, 
UNIT1_INV2_Power as Mode_UNIT1_INV2_Power, 
UNIT2_INV1_Power as Mode_UNIT2_INV1_Power,
UNIT2_INV2_Power as Mode_UNIT2_INV2_Power,
GII AS Mode_GII,
`MODULE TEMP.1` AS Mode_MODULE_TEMP,
RAIN AS Mode_RAIN,
`AMBIENT TEMPRETURE` AS Mode_AMBIENT_TEMPRETURE
from 
(
select  UNIT1_INV1_Power, UNIT1_INV2_Power, UNIT2_INV1_Power, UNIT2_INV2_Power,GII,`MODULE TEMP.1`,RAIN,`AMBIENT TEMPRETURE`, 
count(*) as frequency
from solar_power_project
group by  UNIT1_INV1_Power, UNIT1_INV2_Power, UNIT2_INV1_Power, UNIT2_INV2_Power,GII,`MODULE TEMP.1`,RAIN,`AMBIENT TEMPRETURE`
order by frequency Desc
limit 1
) as subquery;


#2nd business moment
#Variance

SELECT 
    VAR_SAMP(UNIT1_INV1_Power) AS variance_UNIT1_INV1_Power, 
    VAR_SAMP(UNIT1_INV2_Power) AS variance_UNIT1_INV2_Power, 
    VAR_SAMP(UNIT2_INV1_Power) AS variance_UNIT2_INV1_Power,
    VAR_SAMP(UNIT2_INV2_Power) AS variance_UNIT2_INV2_Power,
    VAR_SAMP(GII) AS variance_GII, 
    VAR_SAMP(`MODULE TEMP.1`) AS variance_MODULE_TEMP, 
    VAR_SAMP(RAIN) AS variance_RAIN,
    VAR_SAMP(`AMBIENT TEMPRETURE`) AS variance_AMBIENT_TEMPRETURE
FROM solar_power_project;

#Standard Deviation

select 
stddev(UNIT1_INV1_Power) as stddev_UNIT1_INV1_Power, 
stddev(UNIT1_INV2_Power) as stddev_UNIT1_INV2_Power, 
stddev(UNIT2_INV1_Power) as stddev_UNIT2_INV1_Power,
stddev(UNIT2_INV2_Power) as stddev_UNIT2_INV2_Power,
stddev(GII) as stddev_GII, 
stddev(`MODULE TEMP.1`) as stddev_MODULE_TEMP, 
stddev(RAIN) as stddev_RAIN,
stddev(`AMBIENT TEMPRETURE`) as stddev_AMBIENT_TEMPRETURE
from solar_power_project;


#RANGE
select
max(UNIT1_INV1_Power) - min(UNIT1_INV1_Power) as range_UNIT1_INV1_Power, 
max(UNIT1_INV2_Power) - min(UNIT1_INV2_Power) as range_UNIT1_INV2_Power, 
max(UNIT2_INV1_Power) -min(UNIT2_INV1_Power) as range_UNIT2_INV1_Power,
max(UNIT2_INV2_Power) -min(UNIT2_INV2_Power) as range_UNIT2_INV2_Power,
max(GII) - min(GII) as range_GII, 
max(`MODULE TEMP.1`) - min(`MODULE TEMP.1`) as range_MODULE_TEMP, 
max(RAIN) -min(RAIN) as range_RAIN,
max(`AMBIENT TEMPRETURE`) -min(`AMBIENT TEMPRETURE`) as range_AMBIENT_TEMPRETURE
from solar_power_project;


#3rd business moment
#Skewness

SELECT
(
SUM(POWER(UNIT1_INV1_Power - (SELECT AVG(UNIT1_INV1_Power) FROM solar_power_project), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(UNIT1_INV1_Power) FROM solar_power_project), 3))
) AS skewness

FROM solar_power_project;



SELECT
(
SUM(POWER(UNIT1_INV2_Power - (SELECT AVG(UNIT1_INV2_Power) FROM solar_power_project), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(UNIT1_INV2_Power) FROM solar_power_project), 3))
) AS skewness

FROM solar_power_project;


SELECT
(
SUM(POWER(UNIT2_INV1_Power - (SELECT AVG(UNIT2_INV1_Power) FROM solar_power_project), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(UNIT2_INV1_Power) FROM solar_power_project), 3))
) AS skewness

FROM solar_power_project;


SELECT
(
SUM(POWER(UNIT2_INV2_Power - (SELECT AVG(UNIT2_INV2_Power) FROM solar_power_project), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(UNIT2_INV2_Power) FROM solar_power_project), 3))
) AS skewness

FROM solar_power_project;


SELECT
(
SUM(POWER(GII - (SELECT AVG(GII) FROM solar_power_project), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(GII) FROM solar_power_project), 3))
) AS skewness

FROM solar_power_project;



SELECT
(
SUM(POWER(`MODULE TEMP.1` - (SELECT AVG(`MODULE TEMP.1`) FROM solar_power_project), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(`MODULE TEMP.1`) FROM solar_power_project), 3))
) AS skewness

FROM solar_power_project;


SELECT
(
SUM(POWER(RAIN - (SELECT AVG(RAIN) FROM solar_power_project), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(RAIN) FROM solar_power_project), 3))
) AS skewness

FROM solar_power_project;


SELECT
(
SUM(POWER(`AMBIENT TEMPRETURE` - (SELECT AVG(`AMBIENT TEMPRETURE`) FROM solar_power_project), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(`AMBIENT TEMPRETURE`) FROM solar_power_project), 3))
) AS skewness

FROM solar_power_project;


#4th business moment
#Kurtosis

SELECT
(
(SUM(POWER(UNIT1_INV1_Power- (SELECT AVG(UNIT1_INV1_Power) FROM solar_power_project), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(UNIT1_INV1_Power) FROM solar_power_project), 4))) - 3
) AS kurtosis
FROM solar_power_project;


SELECT
(
(SUM(POWER(UNIT1_INV2_Power- (SELECT AVG(UNIT1_INV2_Power) FROM solar_power_project), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(UNIT1_INV2_Power) FROM solar_power_project), 4))) - 3
) AS kurtosis
FROM solar_power_project;


SELECT
(
(SUM(POWER(UNIT2_INV1_Power- (SELECT AVG(UNIT2_INV1_Power) FROM solar_power_project), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(UNIT2_INV1_Power) FROM solar_power_project), 4))) - 3
) AS kurtosis
FROM solar_power_project;



SELECT
(
(SUM(POWER(UNIT2_INV2_Power- (SELECT AVG(UNIT2_INV2_Power) FROM solar_power_project), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(UNIT2_INV2_Power) FROM solar_power_project), 4))) - 3
) AS kurtosis
FROM solar_power_project;


SELECT
(
(SUM(POWER(GII- (SELECT AVG(GII) FROM solar_power_project), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(GII) FROM solar_power_project), 4))) - 3
) AS kurtosis
FROM solar_power_project;


SELECT
(
(SUM(POWER(`MODULE TEMP.1`- (SELECT AVG(`MODULE TEMP.1`) FROM solar_power_project), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(`MODULE TEMP.1`) FROM solar_power_project), 4))) - 3
) AS kurtosis
FROM solar_power_project;


SELECT
(
(SUM(POWER(RAIN- (SELECT AVG(RAIN) FROM solar_power_project), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(RAIN) FROM solar_power_project), 4))) - 3
) AS kurtosis
FROM solar_power_project;


SELECT
(
(SUM(POWER(`AMBIENT TEMPRETURE`- (SELECT AVG(`AMBIENT TEMPRETURE`) FROM solar_power_project), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(`AMBIENT TEMPRETURE`) FROM solar_power_project), 4))) - 3
) AS kurtosis
FROM solar_power_project;

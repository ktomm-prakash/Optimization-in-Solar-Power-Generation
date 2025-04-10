#__________________________________________Typecasting___________________________________________________

ALTER TABLE solar_power_project MODIFY `DATE & TIME` DATETIME;
select * from solar_power_project;


#Count_Duplicates

SELECT `DATE & TIME`, UNIT1_INV1_Power, UNIT1_INV2_Power, UNIT2_INV1_Power, UNIT2_INV2_Power,GII,`MODULE TEMP.1`,RAIN,'AMBIENT TEMPRETURE', COUNT(*)
FROM solar_power_project
GROUP BY `DATE & TIME`, UNIT1_INV1_Power, UNIT1_INV2_Power, UNIT2_INV1_Power, UNIT2_INV2_Power,GII,`MODULE TEMP.1`,RAIN,'AMBIENT TEMPRETURE'
HAVING COUNT(*) > 1;

#-------------no duplicates--------------------


#__________________________________________Handle Outliers_________________________________________________
   
   WITH quartiles AS (
    SELECT 
        -- Calculate Q1 and Q3 for each column using the correct NTILE alias
        MAX(CASE WHEN ntile_4_col1 = 1 THEN UNIT1_INV1_Power END) AS q1_col1,
        MAX(CASE WHEN ntile_4_col1 = 3 THEN UNIT1_INV1_Power END) AS q3_col1,
        
        MAX(CASE WHEN ntile_4_col2 = 1 THEN UNIT1_INV2_Power END) AS q1_col2,
        MAX(CASE WHEN ntile_4_col2 = 3 THEN UNIT1_INV2_Power END) AS q3_col2,
        
        MAX(CASE WHEN ntile_4_col3 = 1 THEN UNIT2_INV1_Power END) AS q1_col3,
        MAX(CASE WHEN ntile_4_col3 = 3 THEN UNIT2_INV1_Power END) AS q3_col3,
        
        MAX(CASE WHEN ntile_4_col4 = 1 THEN UNIT2_INV2_Power END) AS q1_col4,
        MAX(CASE WHEN ntile_4_col4 = 3 THEN UNIT2_INV2_Power END) AS q3_col4,
        
        MAX(CASE WHEN ntile_4_col5 = 1 THEN GII END) AS q1_col5,
        MAX(CASE WHEN ntile_4_col5 = 3 THEN GII END) AS q3_col5,
        
        MAX(CASE WHEN ntile_4_col6 = 1 THEN `MODULE TEMP.1` END) AS q1_col6,
        MAX(CASE WHEN ntile_4_col6 = 3 THEN `MODULE TEMP.1` END) AS q3_col6,
        
        MAX(CASE WHEN ntile_4_col7 = 1 THEN RAIN END) AS q1_col7,
        MAX(CASE WHEN ntile_4_col7 = 3 THEN RAIN END) AS q3_col7,
        
        MAX(CASE WHEN ntile_4_col8 = 1 THEN `AMBIENT TEMPRETURE` END) AS q1_col8,
        MAX(CASE WHEN ntile_4_col8 = 3 THEN `AMBIENT TEMPRETURE` END) AS q3_col8
    FROM (
        SELECT 
            UNIT1_INV1_Power, UNIT1_INV2_Power, 
            UNIT2_INV1_Power, UNIT2_INV2_Power,
            GII, `MODULE TEMP.1`, RAIN, `AMBIENT TEMPRETURE`,
            
            -- Assign NTILE quartiles for each column
            NTILE(4) OVER (ORDER BY UNIT1_INV1_Power) AS ntile_4_col1,
            NTILE(4) OVER (ORDER BY UNIT1_INV2_Power) AS ntile_4_col2,
            NTILE(4) OVER (ORDER BY UNIT2_INV1_Power) AS ntile_4_col3,
            NTILE(4) OVER (ORDER BY UNIT2_INV2_Power) AS ntile_4_col4,
            NTILE(4) OVER (ORDER BY GII) AS ntile_4_col5,
            NTILE(4) OVER (ORDER BY `MODULE TEMP.1`) AS ntile_4_col6,
            NTILE(4) OVER (ORDER BY RAIN) AS ntile_4_col7,
            NTILE(4) OVER (ORDER BY `AMBIENT TEMPRETURE`) AS ntile_4_col8
        FROM solar_power_project
    ) AS quartile_data
),
iqr_values AS (
    SELECT 
        q1_col1, q3_col1, (q3_col1 - q1_col1) AS iqr_col1,
        (q1_col1 - 1.5 * (q3_col1 - q1_col1)) AS lower_bound_col1,
        (q3_col1 + 1.5 * (q3_col1 - q1_col1)) AS upper_bound_col1,

        q1_col2, q3_col2, (q3_col2 - q1_col2) AS iqr_col2,
        (q1_col2 - 1.5 * (q3_col2 - q1_col2)) AS lower_bound_col2,
        (q3_col2 + 1.5 * (q3_col2 - q1_col2)) AS upper_bound_col2,

        q1_col3, q3_col3, (q3_col3 - q1_col3) AS iqr_col3,
        (q1_col3 - 1.5 * (q3_col3 - q1_col3)) AS lower_bound_col3,
        (q3_col3 + 1.5 * (q3_col3 - q1_col3)) AS upper_bound_col3,

        q1_col4, q3_col4, (q3_col4 - q1_col4) AS iqr_col4,
        (q1_col4 - 1.5 * (q3_col4 - q1_col4)) AS lower_bound_col4,
        (q3_col4 + 1.5 * (q3_col4 - q1_col4)) AS upper_bound_col4,

        q1_col5, q3_col5, (q3_col5 - q1_col5) AS iqr_col5,
        (q1_col5 - 1.5 * (q3_col5 - q1_col5)) AS lower_bound_col5,
        (q3_col5 + 1.5 * (q3_col5 - q1_col5)) AS upper_bound_col5,

        q1_col6, q3_col6, (q3_col6 - q1_col6) AS iqr_col6,
        (q1_col6 - 1.5 * (q3_col6 - q1_col6)) AS lower_bound_col6,
        (q3_col6 + 1.5 * (q3_col6 - q1_col6)) AS upper_bound_col6,

        q1_col7, q3_col7, (q3_col7 - q1_col7) AS iqr_col7,
        (q1_col7 - 1.5 * (q3_col7 - q1_col7)) AS lower_bound_col7,
        (q3_col7 + 1.5 * (q3_col7 - q1_col7)) AS upper_bound_col7,

        q1_col8, q3_col8, (q3_col8 - q1_col8) AS iqr_col8,
        (q1_col8 - 1.5 * (q3_col8 - q1_col8)) AS lower_bound_col8,
        (q3_col8 + 1.5 * (q3_col8 - q1_col8)) AS upper_bound_col8
    FROM quartiles
)
DELETE sp
FROM solar_power_project sp
JOIN iqr_values iqr
    ON sp.UNIT1_INV1_Power < iqr.lower_bound_col1 OR sp.UNIT1_INV1_Power > iqr.upper_bound_col1
    OR sp.UNIT1_INV2_Power < iqr.lower_bound_col2 OR sp.UNIT1_INV2_Power > iqr.upper_bound_col2
    OR sp.UNIT2_INV1_Power < iqr.lower_bound_col3 OR sp.UNIT2_INV1_Power > iqr.upper_bound_col3
    OR sp.UNIT2_INV2_Power < iqr.lower_bound_col4 OR sp.UNIT2_INV2_Power > iqr.upper_bound_col4
    OR sp.GII < iqr.lower_bound_col5 OR sp.GII > iqr.upper_bound_col5
    OR sp.`MODULE TEMP.1` < iqr.lower_bound_col6 OR sp.`MODULE TEMP.1` > iqr.upper_bound_col6
    OR sp.RAIN < iqr.lower_bound_col7 OR sp.RAIN > iqr.upper_bound_col7
    OR sp.`AMBIENT TEMPRETURE` < iqr.lower_bound_col8 OR sp.`AMBIENT TEMPRETURE` > iqr.upper_bound_col8;



#_______________________________Normalization__________________________________#



CREATE TABLE solar_power_project_scaled AS
SELECT
    UNIT1_INV1_Power,
    UNIT1_INV2_Power,
    UNIT2_INV1_Power,
    UNIT2_INV2_Power,
    GII,
    `MODULE TEMP.1`,
    RAIN,
    `AMBIENT TEMPRETURE`,

    -- Min-Max Scaling with NULLIF to prevent division by zero
    (UNIT1_INV1_Power - min_UNIT1_INV1) / NULLIF(max_UNIT1_INV1 - min_UNIT1_INV1, 0) AS scaled_UNIT1_INV1_Power,
    (UNIT1_INV2_Power - min_UNIT1_INV2) / NULLIF(max_UNIT1_INV2 - min_UNIT1_INV2, 0) AS scaled_UNIT1_INV2_Power,
    (UNIT2_INV1_Power - min_UNIT2_INV1) / NULLIF(max_UNIT2_INV1 - min_UNIT2_INV1, 0) AS scaled_UNIT2_INV1_Power,
    (UNIT2_INV2_Power - min_UNIT2_INV2) / NULLIF(max_UNIT2_INV2 - min_UNIT2_INV2, 0) AS scaled_UNIT2_INV2_Power,
    (GII - min_GII) / NULLIF(max_GII - min_GII, 0) AS scaled_GII,
    (`MODULE TEMP.1` - min_ModuleTemp) / NULLIF(max_ModuleTemp - min_ModuleTemp, 0) AS scaled_ModuleTemp,
    (RAIN - min_RAIN) / NULLIF(max_RAIN - min_RAIN, 0) AS scaled_RAIN,
    (`AMBIENT TEMPRETURE` - min_AmbientTemp) / NULLIF(max_AmbientTemp - min_AmbientTemp, 0) AS scaled_AmbientTemp

FROM (
    SELECT 
        UNIT1_INV1_Power, UNIT1_INV2_Power, UNIT2_INV1_Power, UNIT2_INV2_Power, 
        GII, `MODULE TEMP.1`, RAIN, `AMBIENT TEMPRETURE`,

        -- Get min/max values for each column
        (SELECT MIN(UNIT1_INV1_Power) FROM solar_power_project) AS min_UNIT1_INV1,
        (SELECT MAX(UNIT1_INV1_Power) FROM solar_power_project) AS max_UNIT1_INV1,
        
        (SELECT MIN(UNIT1_INV2_Power) FROM solar_power_project) AS min_UNIT1_INV2,
        (SELECT MAX(UNIT1_INV2_Power) FROM solar_power_project) AS max_UNIT1_INV2,
        
        (SELECT MIN(UNIT2_INV1_Power) FROM solar_power_project) AS min_UNIT2_INV1,
        (SELECT MAX(UNIT2_INV1_Power) FROM solar_power_project) AS max_UNIT2_INV1,
        
        (SELECT MIN(UNIT2_INV2_Power) FROM solar_power_project) AS min_UNIT2_INV2,
        (SELECT MAX(UNIT2_INV2_Power) FROM solar_power_project) AS max_UNIT2_INV2,
        
        (SELECT MIN(GII) FROM solar_power_project) AS min_GII,
        (SELECT MAX(GII) FROM solar_power_project) AS max_GII,
        
        (SELECT MIN(`MODULE TEMP.1`) FROM solar_power_project) AS min_ModuleTemp,
        (SELECT MAX(`MODULE TEMP.1`) FROM solar_power_project) AS max_ModuleTemp,
        
        (SELECT MIN(RAIN) FROM solar_power_project) AS min_RAIN,
        (SELECT MAX(RAIN) FROM solar_power_project) AS max_RAIN,
        
        (SELECT MIN(`AMBIENT TEMPRETURE`) FROM solar_power_project) AS min_AmbientTemp,
        (SELECT MAX(`AMBIENT TEMPRETURE`) FROM solar_power_project) AS max_AmbientTemp
    FROM solar_power_project
) AS scaled_data;



select * from solar_power_project_scaled;



#1st business moment (Mean/Median/Mode)
#______________________________________mean______________________________________#

SELECT 
    AVG(scaled_UNIT1_INV1_Power) AS mean_UNIT1_INV1_Power, 
    AVG(scaled_UNIT1_INV2_Power) AS mean_UNIT1_INV2_Power, 
    AVG(scaled_UNIT2_INV1_Power) AS mean_UNIT2_INV1_Power,
    AVG(scaled_UNIT2_INV2_Power) AS mean_UNIT2_INV2_Power,
    AVG(scaled_GII) AS mean_GII,
    AVG(scaled_ModuleTemp) AS mean_MODULE_TEMP,
    AVG(scaled_RAIN) AS mean_RAIN,
    AVG(scaled_AmbientTemp) AS mean_AMBIENT_TEMPRETURE
FROM solar_power_project_scaled;


#_______________________________________Median__________________________________#

select 
scaled_UNIT1_INV1_Power as median_UNIT1_INV1_Power, 
scaled_UNIT1_INV2_Power as median_UNIT1_INV2_Power, 
scaled_UNIT2_INV1_Power as median_UNIT2_INV1_Power,
scaled_UNIT2_INV2_Power as median_UNIT2_INV2_Power,
scaled_GII AS median_GII,
scaled_ModuleTemp AS median_MODULE_TEMP,
scaled_RAIN AS median_RAIN,
scaled_AmbientTemp AS median_AMBIENT_TEMPRETURE
from 
(
select scaled_UNIT1_INV1_Power, scaled_UNIT1_INV2_Power, scaled_UNIT2_INV1_Power, scaled_UNIT2_INV2_Power,scaled_GII,scaled_ModuleTemp,scaled_RAIN,scaled_AmbientTemp,
row_number() over (order by scaled_UNIT1_INV1_Power, scaled_UNIT1_INV2_Power, scaled_UNIT2_INV1_Power, scaled_UNIT2_INV2_Power,scaled_GII,scaled_ModuleTemp,scaled_RAIN,scaled_AmbientTemp)
as row_num,
count(*) over () as total_count
from solar_power_project_scaled
) as subquery
where row_num = (total_count + 1) / 2 or row_num = (total_count + 2) / 2;


#_____________________________________Mode________________________________________#

select
scaled_UNIT1_INV1_Power as Mode_UNIT1_INV1_Power, 
scaled_UNIT1_INV2_Power as Mode_UNIT1_INV2_Power, 
scaled_UNIT2_INV1_Power as Mode_UNIT2_INV1_Power,
scaled_UNIT2_INV2_Power as Mode_UNIT2_INV2_Power,
scaled_GII AS Mode_GII,
scaled_ModuleTemp AS Mode_MODULE_TEMP,
scaled_RAIN AS Mode_RAIN,
scaled_AmbientTemp AS Mode_AMBIENT_TEMPRETURE
from 
(
select  scaled_UNIT1_INV1_Power, scaled_UNIT1_INV2_Power, scaled_UNIT2_INV1_Power, scaled_UNIT2_INV2_Power,scaled_GII,scaled_ModuleTemp,scaled_RAIN,scaled_AmbientTemp, 
count(*) as frequency
from solar_power_project_scaled
group by  scaled_UNIT1_INV1_Power, scaled_UNIT1_INV2_Power, scaled_UNIT2_INV1_Power, scaled_UNIT2_INV2_Power,scaled_GII,scaled_ModuleTemp,scaled_RAIN,scaled_AmbientTemp
order by frequency Desc
limit 1
) as subquery;


#2nd business moment
#____________________________________Variance_____________________________________#

SELECT 
    VAR_SAMP(scaled_UNIT1_INV1_Power) AS variance_UNIT1_INV1_Power, 
    VAR_SAMP(scaled_UNIT1_INV2_Power) AS variance_UNIT1_INV2_Power, 
    VAR_SAMP(scaled_UNIT2_INV1_Power) AS variance_UNIT2_INV1_Power,
    VAR_SAMP(scaled_UNIT2_INV2_Power) AS variance_UNIT2_INV2_Power,
    VAR_SAMP(scaled_GII) AS variance_GII, 
    VAR_SAMP(scaled_ModuleTemp) AS variance_MODULE_TEMP, 
    VAR_SAMP(scaled_RAIN) AS variance_RAIN,
    VAR_SAMP(scaled_AmbientTemp) AS variance_AMBIENT_TEMPRETURE
FROM solar_power_project_scaled;


#Standard Deviation

select 
stddev(scaled_UNIT1_INV1_Power) as stddev_UNIT1_INV1_Power, 
stddev(scaled_UNIT1_INV2_Power) as stddev_UNIT1_INV2_Power, 
stddev(scaled_UNIT2_INV1_Power) as stddev_UNIT2_INV1_Power,
stddev(scaled_UNIT2_INV2_Power) as stddev_UNIT2_INV2_Power,
stddev(scaled_GII) as stddev_GII, 
stddev(scaled_ModuleTemp) as stddev_MODULE_TEMP, 
stddev(scaled_RAIN) as stddev_RAIN,
stddev(scaled_AmbientTemp) as stddev_AMBIENT_TEMPRETURE
from solar_power_project_scaled;


#_________________________________RANGE______________________________________
select
max(scaled_UNIT1_INV1_Power) - min(scaled_UNIT1_INV1_Power) as range_UNIT1_INV1_Power, 
max(scaled_UNIT1_INV2_Power) - min(scaled_UNIT1_INV2_Power) as range_UNIT1_INV2_Power, 
max(scaled_UNIT2_INV1_Power) -min(scaled_UNIT2_INV1_Power) as range_UNIT2_INV1_Power,
max(scaled_UNIT2_INV2_Power) -min(scaled_UNIT2_INV2_Power) as range_UNIT2_INV2_Power,
max(scaled_GII) - min(scaled_GII) as range_GII, 
max(scaled_ModuleTemp) - min(scaled_ModuleTemp) as range_MODULE_TEMP, 
max(scaled_RAIN) -min(scaled_RAIN) as range_RAIN,
max(scaled_AmbientTemp) -min(scaled_AmbientTemp) as range_AMBIENT_TEMPRETURE
from solar_power_project_scaled;


#3rd business moment
#________________________________________Skewness_____________________________________-__--_

SELECT
(
SUM(POWER(scaled_UNIT1_INV1_Power - (SELECT AVG(scaled_UNIT1_INV1_Power) FROM solar_power_project_scaled), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_UNIT1_INV1_Power) FROM solar_power_project_scaled), 3))
) AS skewness

FROM solar_power_project_scaled;



SELECT
(
SUM(POWER(scaled_UNIT1_INV2_Power - (SELECT AVG(scaled_UNIT1_INV2_Power) FROM solar_power_project_scaled), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_UNIT1_INV2_Power) FROM solar_power_project_scaled), 3))
) AS skewness

FROM solar_power_project_scaled;


SELECT
(
SUM(POWER(scaled_UNIT2_INV1_Power - (SELECT AVG(scaled_UNIT2_INV1_Power) FROM solar_power_project_scaled), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_UNIT2_INV1_Power) FROM solar_power_project_scaled), 3))
) AS skewness

FROM solar_power_project_scaled;


SELECT
(
SUM(POWER(scaled_UNIT2_INV2_Power - (SELECT AVG(scaled_UNIT2_INV2_Power) FROM solar_power_project_scaled), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_UNIT2_INV2_Power) FROM solar_power_project_scaled), 3))
) AS skewness

FROM solar_power_project_scaled;



SELECT
(
SUM(POWER(scaled_GII - (SELECT AVG(scaled_GII) FROM solar_power_project_scaled), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_GII) FROM solar_power_project_scaled), 3))
) AS skewness

FROM solar_power_project_scaled;


SELECT
(
SUM(POWER(scaled_ModuleTemp - (SELECT AVG(scaled_ModuleTemp) FROM solar_power_project_scaled), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_ModuleTemp) FROM solar_power_project_scaled), 3))
) AS skewness

FROM solar_power_project_scaled;


SELECT
(
SUM(POWER(scaled_RAIN - (SELECT AVG(scaled_RAIN) FROM solar_power_project_scaled), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_RAIN) FROM solar_power_project_scaled), 3))
) AS skewness

FROM solar_power_project_scaled;


SELECT
(
SUM(POWER(scaled_AmbientTemp - (SELECT AVG(scaled_AmbientTemp) FROM solar_power_project_scaled), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_AmbientTemp) FROM solar_power_project_scaled), 3))
) AS skewness

FROM solar_power_project_scaled;


#4th business moment
#____________________________________________Kurtosis________________________________________#


SELECT
(
(SUM(POWER(scaled_UNIT1_INV1_Power- (SELECT AVG(scaled_UNIT1_INV1_Power) FROM solar_power_project_scaled), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_UNIT1_INV1_Power) FROM solar_power_project_scaled), 4))) - 3
) AS kurtosis
FROM solar_power_project_scaled;


SELECT
(
(SUM(POWER(scaled_UNIT1_INV2_Power- (SELECT AVG(scaled_UNIT1_INV2_Power) FROM solar_power_project_scaled), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_UNIT1_INV2_Power) FROM solar_power_project_scaled), 4))) - 3
) AS kurtosis
FROM solar_power_project_scaled;


SELECT
(
(SUM(POWER(scaled_UNIT2_INV1_Power- (SELECT AVG(scaled_UNIT2_INV1_Power) FROM solar_power_project_scaled), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_UNIT2_INV1_Power) FROM solar_power_project_scaled), 4))) - 3
) AS kurtosis
FROM solar_power_project_scaled;

SELECT
(
(SUM(POWER(scaled_UNIT2_INV2_Power- (SELECT AVG(scaled_UNIT2_INV2_Power) FROM solar_power_project_scaled), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_UNIT2_INV2_Power) FROM solar_power_project_scaled), 4))) - 3
) AS kurtosis
FROM solar_power_project_scaled;



SELECT
(
(SUM(POWER(scaled_GII- (SELECT AVG(scaled_GII) FROM solar_power_project_scaled), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_GII) FROM solar_power_project_scaled), 4))) - 3
) AS kurtosis
FROM solar_power_project_scaled;


SELECT
(
(SUM(POWER(scaled_ModuleTemp- (SELECT AVG(scaled_ModuleTemp) FROM solar_power_project_scaled), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_ModuleTemp) FROM solar_power_project_scaled), 4))) - 3
) AS kurtosis
FROM solar_power_project_scaled;


SELECT
(
(SUM(POWER(scaled_RAIN- (SELECT AVG(scaled_RAIN) FROM solar_power_project_scaled), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_RAIN) FROM solar_power_project_scaled), 4))) - 3
) AS kurtosis
FROM solar_power_project_scaled;


SELECT
(
(SUM(POWER(scaled_AmbientTemp- (SELECT AVG(scaled_AmbientTemp) FROM solar_power_project_scaled), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(scaled_AmbientTemp) FROM solar_power_project_scaled), 4))) - 3
) AS kurtosis
FROM solar_power_project_scaled;
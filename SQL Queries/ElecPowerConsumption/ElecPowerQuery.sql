CREATE DATABASE ElectricConsumption;

SELECT *
FROM powerconsumption
ORDER BY Datetime;



-- MIN AND MAX DATE
SELECT
	MIN(MONTH(Datetime)) min_month,
	MAX(MONTH(Datetime)) max_month
FROM powerconsumption;

SELECT
	MIN(CAST(Datetime AS DATE)),
	MAX(CAST(Datetime AS DATE))
FROM powerconsumption;


-- Checking columns with NULL values
SELECT 
	SUM( CASE WHEN Temperature IS NULL THEN 1 ELSE 0 END),
	SUM( CASE WHEN Humidity IS NULL THEN 1 ELSE 0 END),
	SUM( CASE WHEN WindSpeed IS NULL THEN 1 ELSE 0 END),
	SUM( CASE WHEN GeneralDiffuseFlows IS NULL THEN 1 ELSE 0 END),
	SUM( CASE WHEN DiffuseFlows IS NULL THEN 1 ELSE 0 END),
	SUM( CASE WHEN PowerConsumption_Zone1 IS NULL THEN 1 ELSE 0 END),
	SUM( CASE WHEN PowerConsumption_Zone2 IS NULL THEN 1 ELSE 0 END),
	SUM( CASE WHEN PowerConsumption_Zone3 IS NULL THEN 1 ELSE 0 END)
FROM powerconsumption;
-- 0 Null values every column


-- GETTING THE AVERAGE
SELECT
	MONTH(Datetime) AS months,
	ROUND(AVG(Temperature),2) AS Avg_Temp,
	ROUND(AVG(Humidity),2) AS Avg_Humidity,
	ROUND(AVG(Windspeed),2) AS Avg_Windspeed,
	ROUND(AVG(GeneralDiffuseFlows),2) AS Avg_General_Diff_Flows,
	ROUND(AVG(DiffuseFlows),2) AS Avg_Diff_Flows,
	ROUND(AVG(PowerConsumption_Zone1),2) AS Avg_PowerConsumption_Z1,
	ROUND(AVG(PowerConsumption_Zone2),2) AS Avg_PowerConsumption_Z2,
	ROUND(AVG(PowerConsumption_Zone3),2) AS Avg_PowerConsumption_Z3
FROM powerconsumption
GROUP BY MONTH(Datetime)
ORDER BY MONTH(Datetime);



-- TO KNOW IF THE AVERAGE OF EVERY CATEGORY IS ABOVE OR BELLOW OF THE TOTAL AVERAGE.
SELECT
	CAST(Datetime AS DATE) AS Date,
	ROUND(AVG(Temperature),2) AS Avg_Temperature,
		CASE 
			WHEN ROUND(AVG(Temperature),2) <= (SELECT ROUND(AVG(Temperature),2)FROM powerconsumption) THEN 'Bellow Average'
			ELSE 'Above Average'
		END AS Temperature_Level,
	ROUND(AVG(Humidity),2) AS Avg_Humidity,
		CASE
			WHEN ROUND(AVG(Humidity),2) <= (SELECT ROUND(AVG(Humidity),2)FROM powerconsumption) THEN 'Bellow Average'
			ELSE 'Above Average'
		END AS Humidity_Level,
	ROUND(AVG(WindSpeed),2) AS Avg_WindSpeed,
		CASE
			WHEN ROUND(AVG(WindSpeed),2) <= (SELECT ROUND(AVG(WindSpeed),2)FROM powerconsumption) THEN 'Bellow Average'
			ELSE 'Above Average'
		END AS WindSpeed_Level,
	ROUND(AVG(GeneralDiffuseFlows),2) AS Avg_Humidity,
		CASE
			WHEN ROUND(AVG(GeneralDiffuseFlows),2) <= (SELECT ROUND(AVG(GeneralDiffuseFlows),2)FROM powerconsumption) THEN 'Bellow Average'
			ELSE 'Above Average'
		END AS GeneralDIffuseFlows_Level,
	ROUND(AVG(DiffuseFlows),2) AS Avg_Humidity,
		CASE
			WHEN ROUND(AVG(DiffuseFlows),2) <= (SELECT ROUND(AVG(DiffuseFlows),2)FROM powerconsumption) THEN 'Bellow Average'
			ELSE 'Above Average'
		END AS DiffuseFlows_Level,
	ROUND(AVG(PowerConsumption_Zone1),2) AS Avg_PowerCons_Z1,
		CASE
			WHEN ROUND(AVG(PowerConsumption_Zone1),2) <= (SELECT ROUND(AVG(PowerConsumption_Zone1),2)FROM powerconsumption) THEN 'Bellow Average'
			ELSE 'Above Average'
		END AS PowerConsumption_Level_Z1,
	ROUND(AVG(PowerConsumption_Zone2),2) AS Avg_PowerCons_Z2,
		CASE
			WHEN ROUND(AVG(PowerConsumption_Zone2),2) <= (SELECT ROUND(AVG(PowerConsumption_Zone2),2)FROM powerconsumption) THEN 'Bellow Average'
			ELSE 'Above Average'
		END AS PowerConsumption_Level_Z2,
	ROUND(AVG(PowerConsumption_Zone3),2) AS Avg_PowerCons_Z3,
		CASE
			WHEN ROUND(AVG(PowerConsumption_Zone3),2) <= (SELECT ROUND(AVG(PowerConsumption_Zone3),2)FROM powerconsumption) THEN 'Bellow Average'
			ELSE 'Above Average'
		END AS PowerConsumption_Level_Z3
FROM powerconsumption
GROUP BY CAST(Datetime AS DATE)
ORDER BY CAST(Datetime AS DATE);




SELECT
	Datetime,
	Temperature,
	AVG(Temperature) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE)) AS Avg_TemperatureByDay,
	CASE
		WHEN Temperature <= AVG(Temperature) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE))
		THEN 'Below Average' 
		ELSE 'Above Average'
		END AS Temp_Level,
	Humidity,
	AVG(Humidity) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE)) AS Avg_HumidityByDay,
	CASE
		WHEN Humidity <= AVG(Humidity) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE))
		THEN 'Below Average' 
		ELSE 'Above Average'
		END AS Humid_Level,
	WindSpeed,
	AVG(WindSpeed) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE)) AS Avg_WindSpeedByDay,
	CASE
		WHEN WindSpeed <= AVG(WindSpeed) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE))
		THEN 'Below Average' 
		ELSE 'Above Average'
		END AS WindSpd_Level,
	GeneralDiffuseFlows,
	AVG(GeneralDiffuseFlows) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE)) AS Avg_GeneralDiffuseFlowsByDay,
	CASE
		WHEN GeneralDiffuseFlows <= AVG(GeneralDiffuseFlows) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE))
		THEN 'Below Average' 
		ELSE 'Above Average'
		END AS GDF_Level,
	DiffuseFlows,
	AVG(DiffuseFlows) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE)) AS Avg_DiffuseFlowsByDay,
	CASE
		WHEN DiffuseFlows <= AVG(DiffuseFlows) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE))
		THEN 'Below Average' 
		ELSE 'Above Average'
		END AS DF_Level,
	PowerConsumption_Zone1,
	AVG(PowerConsumption_Zone1) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE)) AS Avg_PCZone1ByDay,
	CASE
		WHEN PowerConsumption_Zone1 <= AVG(PowerConsumption_Zone1) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE))
		THEN 'Below Average' 
		ELSE 'Above Average'
		END AS PCZ1_Level,
	PowerConsumption_Zone2,
	AVG(PowerConsumption_Zone2) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE)) AS Avg_PCZone2ByDay,
	CASE
		WHEN PowerConsumption_Zone2 <= AVG(PowerConsumption_Zone2) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE))
		THEN 'Below Average' 
		ELSE 'Above Average'
		END AS PCZ2_Level,
	PowerConsumption_Zone3,
	AVG(PowerConsumption_Zone3) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE)) AS Avg_PCZone3ByDay,
	CASE
		WHEN PowerConsumption_Zone3 <= AVG(PowerConsumption_Zone3) OVER(PARTITION BY CAST(Datetime AS DATE) ORDER BY CAST(Datetime AS DATE))
		THEN 'Below Average' 
		ELSE 'Above Average'
		END AS PCZ3_Level
FROM powerconsumption;

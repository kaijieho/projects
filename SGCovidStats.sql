--Data set taken from https://data.world/hxchua/covid-19-singapore by Hui Xiang Chua
--SG Covid cases data exploration using SQL

--Testing table execution
Select *
  From [SGCovidStats].[dbo].[Sheet1]

Select
  Date,
  sum(Daily_Confirmed) as Confirmed_cases
 From [SGCovidStats].[dbo].[Sheet1]
  Group by Date
  Order by Date

Select
 max(Cumulative_Confirmed) as Total_cases,
 max(Cumulative_Deaths) as Total_deaths,
 (max(Cumulative_Deaths) / max(Cumulative_Confirmed) * 100) as Percentage_of_deaths
From [SGCovidStats].[dbo].[Sheet1]

--Overview of Covid cases throughout the years and months, found no data for May 2022
Select
  Year(Date) as Year,
  Month(Date) as Month,
  sum(Daily_Confirmed) as Confirmed_cases
 From [SGCovidStats].[dbo].[Sheet1]
  Group by Year(Date) , Month(Date)
  Order by Year(Date), Month(Date) asc

--Convert numbered months to month name
 Select
  Year(Date) as Year,
  Case Month(Date)
  When '1' Then 'Jan'
  When '2' Then 'Feb'
  When '3' Then 'Mar'
  When '4' Then 'Apr'
  When '5' Then 'May'
  When '6' Then 'Jun'
  When '7' Then 'Jul'
  When '8' Then 'Aug'
  When '9' Then 'Sep'
  When '10' Then 'Oct'
  When '11' Then 'Nov'
  When '12' Then 'Dec'
  End as Month,
  sum(Daily_Confirmed) as Confirmed_cases
 From [SGCovidStats].[dbo].[Sheet1]
  Group by Year(Date) , Month(Date)
  Order by Year(Date), Month(Date) asc

--Calculating percentage of imported cases to total cases
Select
  sum(Daily_Imported) as Acc_Imported_transmission,
  sum(Daily_Local_transmission) as Acc_Local_transmission,
  Round(sum(Daily_Imported) * 100 / (sum(Daily_Imported) + sum(Daily_Local_transmission)), 2) as percentag_of_imported
From [SGCovidStats].[dbo].[Sheet1]

--Imported and local cases in each month of the year
Select
  Year(Date) as Year,
  Case Month(Date)
  When '1' Then 'Jan'
  When '2' Then 'Feb'
  When '3' Then 'Mar'
  When '4' Then 'Apr'
  When '5' Then 'May'
  When '6' Then 'Jun'
  When '7' Then 'Jul'
  When '8' Then 'Aug'
  When '9' Then 'Sep'
  When '10' Then 'Oct'
  When '11' Then 'Nov'
  When '12' Then 'Dec'
  End as Month,
  sum(Daily_Imported) as Imported_cases,
  sum(Daily_Local_transmission) as Local_cases,
  Round(sum(Daily_Imported) * 100 / (sum(Daily_Imported) + sum(Daily_Local_transmission)), 2) as percentage_of_imported
 From [SGCovidStats].[dbo].[Sheet1]
  Group by Year(Date) , Month(Date)
  Order by Year(Date), Month(Date) asc

--Update table to convert empty string to Null 
UPDATE [SGCovidStats].[dbo].[Sheet1] 
SET Phase = NULLIF(Phase, '')

--Update Phase column as before CB there was no Phase name which indicated as Null
UPDATE [SGCovidStats].[dbo].[Sheet1] 
SET Phase = 'Before Circuit Breaker'
Where Date < '2020-04-07'

--Update Phase column as after Transitional phase there was no Phase name which indicated as Null
UPDATE [SGCovidStats].[dbo].[Sheet1] 
SET Phase = 'After Transitional Phase'
Where Date > '2022-11-05'

--Covid deaths in each phase
Select
  sum(Daily_Deaths) as Deaths,
  Phase
From [SGCovidStats].[dbo].[Sheet1]
  Group by Phase
  Order by Phase

--Deleted all rows with Date as Null value since the data there is not needed
Delete
From [SGCovidStats].[dbo].[Sheet1]
Where Date IS NULL

--Covid cases in each phase, phase is orderd by phase in sequence of Covid timeline
Select
  Phase,
  sum(Daily_Confirmed) as confirmed_cases
From [SGCovidStats].[dbo].[Sheet1]
  Group by Phase
  Order By
  case Phase
  when 'Before Circuit Breaker' then 1
  when 'Circuit Breaker' then 2
  when 'Phase 1' then 3
  when 'Phase 2' then 4
  when 'Phase 3' then 5
  when 'Phase 2 (Heightened Alert)' then 6
  when 'Phase 3 (Heightened Alert)' then 7
  when 'Preparatory Stage' then 8
  when 'Stabilisation Phase' then 9
  when 'Transition Phase' then 10
  when 'After Transitional Phase' then 11
  End

--Covid cases in each phase with deaths
Select
  Phase,
  max(Cumulative_Confirmed) as Total_Cases,
  max(Cumulative_Confirmed)- sum(Daily_Deaths) as Cases_without_Deaths,
  sum(Daily_Deaths) as Deaths
From [SGCovidStats].[dbo].[Sheet1]
  Group by Phase
  Order By
  case Phase
  when 'Before Circuit Breaker' then 1
  when 'Circuit Breaker' then 2
  when 'Phase 1' then 3
  when 'Phase 2' then 4
  when 'Phase 3' then 5
  when 'Phase 2 (Heightened Alert)' then 6
  when 'Phase 3 (Heightened Alert)' then 7
  when 'Preparatory Stage' then 8
  when 'Stabilisation Phase' then 9
  when 'Transition Phase' then 10
  when 'After Transitional Phase' then 11
  End

select *
from dbo.Tobacco_Use
-- Remove columns without data
Alter Table dbo.Tobacco_use
Drop Column F9, F10, Data_Value_Footnote_Symbol, Data_Value_Footnote

-- Percentage of frequent tobacco users where sample size is greater than 1500
select LocationDesc, MAX(Data_Value), Sample_Size
from dbo.Tobacco_Use
where Sample_Size > 1500 and Response = 'Frequent'
group by LocationDesc, Sample_Size
order by Max(Data_Value) DESC
-- Tennessee and Minnesota have the highest recorded percentages of frequent tobacco users

-- Highest percent of frequent tobacco by years (Top 10 percent were in years 1999 or 2000)
select YEAR, LocationDesc, MAX(Data_Value), Sample_Size
from dbo.Tobacco_Use
where Sample_Size > 1500 and Response = 'Frequent'
group by YEAR, Sample_size, LocationDesc
order by MAX(Data_Value) DESC

-- Create a change in use column to see the change in cigarette use by year and by state
select LocationDesc, YEAR, Data_Value,
  Data_Value - LAG(Data_Value) Over (
    Partition by LocationDesc
	Order by YEAR
	) As change_in_Use
from dbo.Tobacco_use
Where Response = 'Frequent' and TopicDesc = 'Cigarette Use (Youth)'
order by LocationDesc ASC

-- Running average of frequent cigarette use
select LocationDesc, YEAR, Data_Value, AVG(Data_Value) over (
    Partition by LocationDesc, YEAR 
    order by YEAR) as 'running average'
from dbo.Tobacco_Use
where Response = 'Frequent' and TopicDesc = 'Cigarette Use (Youth)'
order by LocationDesc, YEAR ASC
 
-- The data shows that the largest percent of frequent tobacco use in teens was in the earlier years(1999-2000's).
-- The results from the lag function and running average shows the decrease in frequent tobacco use over time.

-- Difference in Middle school and High school use
select Education, AVG(Data_Value)
from dbo.Tobacco_Use
where Response = 'ever'
group by Education
-- Tobacco use in high schools is 10% higher than in middle schools
-- Frequent use is roughly 1.5% in middle schools compared to 5% in high schools
-- About 33% of high schoolers surveyed have tried tobacco and 18% of middle schoolers have tried tobacco
select * from Sales_Data$

--5 Which product sold the most? Why do you think it sold the most?
select Product,[Price Each],count(Product) as t from Sales_Data$
group by Product,[Price Each]
order by t desc
#because its cheaper and affordable

--4Which products are most often sold together?
with temp as(
select [Order ID],STRING_AGG(Product,'+')as Sold_Together from Sales_Data$
group by [Order ID])
select Sold_Together, count(Sold_Together) as Quantity_Sold from temp
group by Sold_Together
having Sold_Together like '%+%'
order by Quantity_Sold desc 

--3What time should we display advertisemens
--to maximize the likelihood of customer’s buying product?
select [Time_Group],sum([Sales]) as [Best_Timesale]
from Sales_Data$
group by [Time_Group]
order by [Best_Timesale] desc

update Sales_Data$
set [Time_Group]=
case
  when [Time]>='00:00:00' and [Time] <='3:00:00' Then 'Midnight'
  when [Time]>='3:01:0' and [Time] <='12:00:00' Then 'Morning'
  when [Time]>='12:01:00' and [Time] <='15:00:00' Then 'Afternoon'
  else 'Evening'
  end 
from Sales_Data$

alter table Sales_Data$
ADD [Time_Group] varchar(20)

alter table Sales_Data$
alter column [Time] time

update Sales_Data$
set [Time]=convert(varchar(10),[Order Date],108) 

--2which city sold the most product?
select [City],sum([Sales]) as [City_Sales]
from Sales_Data$
group by [City]
order by [City_Sales] desc

update Sales_Data$
set [City]=SUBSTRING([Purchase Address],
len(left([Purchase Address],CHARINDEX(',',[Purchase Address])+2)),
len([Purchase Address])-len(left([Purchase Address],CHARINDEX(',',[Purchase Address])+1))-
len(right([Purchase Address],CHARINDEX(',',REVERSE([Purchase Address]))+1)
)) from Sales_Data$

alter table Sales_Data$
add [City] varchar(30)

--1 what was the best month for sale?
--how much was earned that month?
select [Month_Name],sum([Sales]) as Best_Month
from Sales_Data$
group by [Month_Name]
order by Best_Month desc

update Sales_Data$
set[Month_Name]= DATENAME(month,[Order Date])

delete duplicate_table
from(
select *,row_number=ROW_NUMBER() over(
                              partition by
				 [Order ID],[Product],[Quantity Ordered],[Order Date],[Sales]
				order by (select null)			  
				) from Sales_Data$
) as duplicate_table
where row_number>1


alter table Sales_Data$
add [Month] int

alter table Sales_Data$
add [Month_Name] varchar(20)

alter table Sales_Data$
alter column [Sales] float

update Sales_Data$
set [Sales]=[Quantity Ordered]*[Price Each]

select * from Sales_Data$
where [Order ID] is null

select * from Sales_Data$
where [Product] is null






use information_schema;

select TABLE_Name,TABLE_ROWS 
	from TABLES
	where TABLE_SCHEMA like 'aw';


select TABLE_NAME,COLUMN_NAME,COLUMN_KEY
	from COLUMNS
	where TABLE_SCHEMA like 'aw'
    and COLUMN_KEY like 'PRI';

use aw;

    
select EnglishProductSubcategoryName 
from DimProductSubcategory
where EnglishProductSubcategoryName like '%bikes%';

select FI.ProductKey, DT.FullDateAlternateKey,FI.CustomerKey,DPS.EnglishProductSubcategoryName,DP.Color
	From FactInternetSales FI, DimProduct DP, DimProductSubcategory DPS,DimTime DT
    WHERE DP.ProductKey = FI.ProductKey
    AND DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
    AND FI.OrderDateKey = DT.TimeKey
    AND DPS.EnglishProductSubcategoryName like '%bikes%';
    -- Group By FI.ProductKey;
    
    
    
-- q6
select YEAR(DT.FullDateAlternateKey) as Year, count(FI.ProductKey) as Sales, totalSales.Sales as TotalSales,DP.Color, count(DP.Color) as colorCount
	From FactInternetSales FI, DimProduct DP, DimProductSubcategory DPS,DimTime DT, 
		(select YEAR(DT.FullDateAlternateKey) as Year, count(FI.ProductKey) as Sales 
		From FactInternetSales FI, DimProduct DP, DimProductSubcategory DPS,DimTime DT
		WHERE DP.ProductKey = FI.ProductKey
		AND DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
		AND FI.OrderDateKey = DT.TimeKey
		AND DPS.EnglishProductSubcategoryName like '%bikes%'
		Group by YEAR(DT.FullDateAlternateKey) ) AS totalSales
    WHERE DP.ProductKey = FI.ProductKey
    AND DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
    AND FI.OrderDateKey = DT.TimeKey
    AND YEAR(DT.FullDateAlternateKey) = totalSales.Year
    AND DPS.EnglishProductSubcategoryName like '%bikes%'
    Group by YEAR(DT.FullDateAlternateKey),DP.Color,totalSales.Sales
    Order By totalSales.Sales desc;
    
    select YEAR(DT.FullDateAlternateKey) as Year, count(FI.ProductKey) as Sales -- , DP.Color, count(DP.Color) as colorCount
		From FactInternetSales FI, DimProduct DP, DimProductSubcategory DPS,DimTime DT
		WHERE DP.ProductKey = FI.ProductKey
		AND DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
		AND FI.OrderDateKey = DT.TimeKey
		AND DPS.EnglishProductSubcategoryName like '%bikes%'
		Group by YEAR(DT.FullDateAlternateKey)
        Order By YEAR(DT.FullDateAlternateKey) desc;
        
-- q7
    select YEAR(DT.FullDateAlternateKey) as Year, month(DT.FullDateAlternateKey)as Month,DC.Gender,count(FI.ProductKey) as Sales 
		From FactInternetSales FI, DimProduct DP, DimProductSubcategory DPS,DimTime DT, DimCustomer DC
		WHERE DP.ProductKey = FI.ProductKey
		AND DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
		AND FI.OrderDateKey = DT.TimeKey
        AND FI.CustomerKey = DC.CustomerKey
		AND DPS.EnglishProductSubcategoryName like '%bikes%'
		Group by DC.Gender,YEAR(DT.FullDateAlternateKey),month(DT.FullDateAlternateKey)
        Order By Year(DT.FullDateAlternateKey),Month(DT.FullDateAlternateKey) desc;
        -- Order By month(DT.FullDateAlternateKey) asc;
        
        
-- q8
select Year, model,max(Margin) as max
	from ( select DPS.EnglishProductSubcategoryName as Model, Year(DT.FullDateAlternateKey) as Year, sum(FI.SalesAmount - FI.TotalProductCost) as Margin
	From FactInternetSales FI, DimProduct DP, DimProductSubcategory DPS,DimTime DT
    WHERE DP.ProductKey = FI.ProductKey
    AND DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
    AND FI.OrderDateKey = DT.TimeKey
    AND DPS.EnglishProductSubcategoryName like '%bikes%'
    AND YEAR(DT.FullDateAlternateKey) = '2003'
    Group by DPS.EnglishProductSubcategoryName,Year(DT.FullDateAlternateKey) ) as ModelBikeTable
    group by Year,model
	having max(Margin);


select DPS.EnglishProductSubcategoryName as Model, Year(DT.FullDateAlternateKey) as Year, sum(FI.SalesAmount - FI.TotalProductCost) as Margin
	From FactInternetSales FI, DimProduct DP, DimProductSubcategory DPS,DimTime DT
    WHERE DP.ProductKey = FI.ProductKey
    AND DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
    AND FI.OrderDateKey = DT.TimeKey
    AND DPS.EnglishProductSubcategoryName like '%bikes%'
    AND YEAR(DT.FullDateAlternateKey) = '2003'
    Group by DPS.EnglishProductSubcategoryName,Year(DT.FullDateAlternateKey)
    Order by Margin desc
    Limit 1;
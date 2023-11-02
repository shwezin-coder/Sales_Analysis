------Customer Analysis-----------
CREATE VIEW Customer_Analysis_Tbl AS
SELECT CONCAT(DC.FirstName,' ',DC.MiddleName,' ',DC.LastName) Customer,DC.Gender,
DATEDIFF(Year,DC.BirthDate,'2019-01-01') Age,
DC.YearlyIncome,DST.SalesTerritoryRegion, DST.SalesTerritoryCountry,DST.SalesTerritoryGroup,
DP.EnglishPromotionName, DP.EnglishPromotionCategory, DPR.EnglishProductName, DPC.EnglishProductCategoryName,
DPS.EnglishProductSubcategoryName,DCR.CurrencyName, FIS.OrderQuantity,
SUM(FIS.SalesAmount) OVER(PARTITION BY FIS.CustomerKey,MONTH(OrderDate),YEAR(OrderDate)) [TotalSalesAmountByCustomer],
SUM(FIS.SalesAmount) OVER(PARTITION BY FIS.ProductKey,MONTH(OrderDate),YEAR(OrderDate)) [TotalSalesAmountByProduct],
SUM(FIS.SalesAmount - FIS.TotalProductCost) OVER(PARTITION BY FIS.CustomerKey,MONTH(OrderDate),YEAR(OrderDate)) [TotalProfitbyCustomer],
SUM(FIS.SalesAmount - FIS.TotalProductCost) OVER(PARTITION BY FIS.ProductKey,MONTH(OrderDate),YEAR(OrderDate)) [TotalProfitbyProduct],
CAST(FIS.OrderDate AS DATE) OrderDate
FROM DimCustomer AS DC, FactInternetSales AS FIS, 
DimSalesTerritory AS DST,DimPromotion AS DP,DimProduct AS DPR,DimProductCategory AS DPC,
DimProductSubcategory AS DPS,DimCurrency AS DCR
WHERE FIS.CustomerKey = DC.CustomerKey AND FIS.ProductKey = DPR.ProductKey 
AND (DPR.ProductSubcategoryKey = DPS.ProductSubcategoryKey OR DPR.ProductSubcategoryKey IS NULL)
AND (DPS.ProductCategoryKey = DPC.ProductCategoryKey OR DPS.ProductCategoryKey IS NULL) AND DCR.CurrencyKey = FIS.CurrencyKey
AND DP.PromotionKey = FIS.PromotionKey AND FIS.SalesTerritoryKey = DST.SalesTerritoryKey;

----------Reseller Analysis------------
CREATE VIEW Reseller_Analysis_Tbl AS
SELECT SUM(FRS.SalesAmount) OVER(PARTITION BY FRS.ResellerKey,MONTH(OrderDate),YEAR(OrderDate)) [TotalSalesAmountbyReseller],
SUM(FRS.SalesAmount) OVER(PARTITION BY FRS.ProductKey, MONTH(OrderDate),YEAR(OrderDate)) [TotalSalesAmountbyProduct],
SUM(FRS.SalesAmount-FRS.TotalProductCost) OVER(PARTITION BY FRS.ResellerKey, MONTH(OrderDate),YEAR(OrderDate)) [TotalProfitbyReseller],
SUM(FRS.SalesAmount-FRS.TotalProductCost) OVER(PARTITION BY FRS.ProductKey, MONTH(OrderDate),YEAR(OrderDate)) [TotalProfitbyProduct],
DR.ResellerName, DR.BusinessType,  DR.AnnualRevenue,
CAST(OrderDate AS date) OrderDate,
DPR.EnglishProductName, DPC.EnglishProductCategoryName,DPS.EnglishProductSubcategoryName,
DP.EnglishPromotionName, DP.EnglishPromotionCategory,DST.SalesTerritoryRegion,
DST.SalesTerritoryCountry,DST.SalesTerritoryGroup,DC.CurrencyName
FROM FactResellerSales FRS, DimReseller DR, DimProduct DPR, DimProductSubcategory DPS,
DimProductCategory DPC,DimSalesTerritory DST,DimPromotion AS DP,DimCurrency DC
WHERE FRS.ResellerKey = DR.ResellerKey AND FRS.ProductKey = DPR.ProductKey 
AND (DPR.ProductSubcategoryKey = DPS.ProductSubcategoryKey OR DPR.ProductSubcategoryKey IS NULL)
AND (DPS.ProductCategoryKey = DPC.ProductCategoryKey OR DPS.ProductCategoryKey IS NULL) AND
FRS.SalesTerritoryKey = DST.SalesTerritoryKey AND DP.PromotionKey = FRS.PromotionKey
AND DC.CurrencyKey = FRS.CurrencyKey;


















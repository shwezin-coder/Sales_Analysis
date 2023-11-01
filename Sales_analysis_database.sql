------Customer Analysis-----------
CREATE VIEW Customer_Analysis_Tbl AS
SELECT CONCAT(DC.FirstName,' ',DC.MiddleName,' ',DC.LastName) Customer,DC.Gender,
DATEDIFF(Year,DC.BirthDate,'2019-01-01') Age,
DC.YearlyIncome,DST.SalesTerritoryRegion, DST.SalesTerritoryCountry,DST.SalesTerritoryGroup,
DP.EnglishPromotionName, DP.EnglishPromotionCategory, DPR.EnglishProductName, DPC.EnglishProductCategoryName,
DPS.EnglishProductSubcategoryName,DCR.CurrencyName, FIS.OrderQuantity, FIS.SalesAmount,(FIS.SalesAmount - FIS.TotalProductCost) Profit,CAST(FIS.OrderDate AS DATE) OrderDate
FROM DimCustomer AS DC, FactInternetSales AS FIS, 
DimSalesTerritory AS DST,DimPromotion AS DP,DimProduct AS DPR,DimProductCategory AS DPC,
DimProductSubcategory AS DPS,DimCurrency AS DCR
WHERE FIS.CustomerKey = DC.CustomerKey AND FIS.ProductKey = DPR.ProductKey 
AND (DPR.ProductSubcategoryKey = DPS.ProductSubcategoryKey OR DPR.ProductSubcategoryKey IS NULL)
AND (DPS.ProductCategoryKey = DPC.ProductCategoryKey OR DPS.ProductCategoryKey IS NULL) AND DCR.CurrencyKey = FIS.CurrencyKey
AND DP.PromotionKey = FIS.PromotionKey AND FIS.SalesTerritoryKey = DST.SalesTerritoryKey

----------Reseller Analysis------------
CREATE VIEW Reseller_Analysis_Tbl AS
SELECT DR.ResellerName, DR.BusinessType, FRS.SalesAmount,  DR.AnnualRevenue,
(FRS.SalesAmount-FRS.TotalProductCost) Profit,CAST(OrderDate AS date) OrderDate,
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


















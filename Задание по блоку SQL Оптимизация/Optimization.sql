-- Задача 1
-- Создание покрывающего индекса
CREATE INDEX IX_WebLog_SessionStart_ServerID
ON Marketing.WebLog (SessionStart, ServerID)
INCLUDE (SessionID, UserName);

DECLARE @StartTime datetime2 = '2010-08-30 16:27';

SELECT TOP(5000) wl.SessionID, wl.ServerID, wl.UserName 
FROM Marketing.WebLog AS wl WITH (INDEX(IX_WebLog_SessionStart_ServerID))
WHERE wl.SessionStart >= @StartTime
ORDER BY wl.SessionStart, wl.ServerID;

-- Задача 2
CREATE INDEX IX_PostalCode_StateCode_PostalCode_Country
ON Marketing.PostalCode (StateCode, PostalCode, Country);

DECLARE @stateCode varchar(2) = 'KY';

SELECT PostalCode, Country
FROM Marketing.PostalCode WITH (INDEX(IX_PostalCode_StateCode_PostalCode_Country))
WHERE StateCode = @stateCode
ORDER BY StateCode, PostalCode;

-- Задача 3
CREATE INDEX IX_Prospect_LastName ON Marketing.Prospect (LastName) INCLUDE (FirstName);
CREATE INDEX IX_Salesperson_LastName ON Marketing.Salesperson (LastName);

DECLARE @Counter INT = 0;
WHILE @Counter < 350
BEGIN
  SELECT p.LastName, p.FirstName 
  FROM Marketing.Prospect AS p
  INNER JOIN Marketing.Salesperson AS sp
  ON p.LastName = sp.LastName
  ORDER BY p.LastName, p.FirstName;
  
  SELECT * 
  FROM Marketing.Prospect AS p
  WHERE p.LastName = 'Smith';
  SET @Counter += 1;
END;

--Задача 4
CREATE INDEX IX_Product_ProductModelID_SubcategoryID_ProductID
ON Marketing.Product (ProductModelID, SubcategoryID, ProductID);

CREATE INDEX IX_Subcategory_SubcategoryID_CategoryID
ON Marketing.Subcategory (SubcategoryID, CategoryID)
include (SubcategoryName);

CREATE INDEX IX_Category_CategoryID
ON Marketing.Category (CategoryID)
include (CategoryName);

CREATE INDEX IX_ProductModel_ProductModelID_ProductModel
ON Marketing.ProductModel (ProductModelID, ProductModel);

SELECT
	c.CategoryName,
	sc.SubcategoryName,
	pm.ProductModel,
	COUNT(p.ProductID) AS ModelCount
FROM Marketing.ProductModel pm WITH (INDEX(IX_ProductModel_ProductModelID_ProductModel))
	JOIN Marketing.Product p
		ON p.ProductModelID = pm.ProductModelID 
	JOIN Marketing.Subcategory sc WITH (INDEX(IX_Subcategory_SubcategoryID_CategoryID))
		ON sc.SubcategoryID = p.SubcategoryID 
	JOIN Marketing.Category c WITH (INDEX(IX_Category_CategoryID))
		ON c.CategoryID = sc.CategoryID
GROUP BY c.CategoryName,
	sc.SubcategoryName,
	pm.ProductModel
HAVING COUNT(p.ProductID) > 1
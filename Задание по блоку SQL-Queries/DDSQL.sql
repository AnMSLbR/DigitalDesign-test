-- Задание 2. Вывести общую сумму продаж с разбивкой по годам и месяцам, за все время работы компании
SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    SUM(TotalDue) AS TotalDue
FROM
    Sales.SalesOrderHeader
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;

-- Задание 3. Выбрать 10 самых приоритетных городов для следующего магазина
-- Города из таблицы адресов, имеющие AddressTypeID = Home и не имеющие при этом Main Office или Shipping, и отсортированные по количеству уникальных покупателей в них
SELECT TOP 10 A.City, COUNT(DISTINCT SOH.CustomerID) AS Unique_customers
FROM Person.Address AS A
INNER JOIN Person.BusinessEntityAddress AS BEA ON A.AddressID = BEA.AddressID
INNER JOIN Person.AddressType AS AT ON BEA.AddressTypeID = AT.AddressTypeID
LEFT JOIN Sales.SalesOrderHeader AS SOH ON SOH.BillToAddressID = A.AddressID
WHERE AT.Name = 'Home' AND A.City NOT IN (
    SELECT DISTINCT A.City
    FROM Person.Address AS A
    INNER JOIN Person.BusinessEntityAddress AS BEA ON A.AddressID = BEA.AddressID
    INNER JOIN Person.AddressType AS AT ON BEA.AddressTypeID = AT.AddressTypeID
    WHERE AT.Name IN ('Main Office', 'Shipping')
)
GROUP BY A.City
ORDER BY Unique_customers DESC;

-- Задание 4. Выбрать покупателей, купивших больше 15 единиц одного и того же продукта за все время работы компании.
SELECT C.LastName AS LastName, C.FirstName AS FirstName, P.Name AS Product, SUM(SOD.OrderQty) AS Qty
FROM Sales.SalesOrderDetail SOD
INNER JOIN Sales.SalesOrderHeader SOH ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Person.Person C ON SOH.CustomerID = C.BusinessEntityID
INNER JOIN Production.Product P ON SOD.ProductID = P.ProductID
GROUP BY
    C.LastName,
    C.FirstName,
    P.Name
HAVING
    SUM(SOD.OrderQty) > 15
ORDER BY
    Qty DESC,
	C.LastName ASC,
    C.FirstName ASC

-- Задание 5. Вывести содержимое первого заказа каждого клиента
SELECT O.OrderDate AS 'Date', P.LastName AS 'LastName', P.FirstName AS 'FirstName',
    STRING_AGG(PR.Name + ' Quantity: ' + CONVERT(NVARCHAR, OD.OrderQty) + ' pcs.', ' | ') AS 'Order'
FROM Sales.SalesOrderHeader AS O
INNER JOIN Person.Person AS P ON O.CustomerID = P.BusinessEntityID
INNER JOIN Sales.SalesOrderDetail AS OD ON O.SalesOrderID = OD.SalesOrderID
INNER JOIN Production.Product AS PR ON OD.ProductID = PR.ProductID
WHERE O.SalesOrderID IN (
        SELECT MIN(SalesOrderID)
        FROM Sales.SalesOrderHeader
        GROUP BY CustomerID
    )
GROUP BY
    O.OrderDate,
    P.LastName,
    P.FirstName
ORDER BY O.OrderDate DESC;

-- Задание 6. Вывести список сотрудников, непосредственный руководитель которых младше сотрудника и меньше работает в компании
	SELECT
    CONCAT(p1.LastName, ' ', LEFT(p1.FirstName, 1), '.', LEFT(p1.MiddleName, 1), '.') AS 'Managers name',
    e1.HireDate AS 'HireDate',
    e1.BirthDate AS 'BirthDate',
    CONCAT(p2.LastName, ' ', LEFT(p2.FirstName, 1), '.', LEFT(p2.MiddleName, 1), '.') AS 'Employee name',
    e2.HireDate AS 'HireDate',
    e2.BirthDate AS 'BirthDate'
FROM
    HumanResources.Employee AS e1
    INNER JOIN HumanResources.Employee AS e2 ON e2.OrganizationNode.IsDescendantOf(e1.OrganizationNode) = 1
    INNER JOIN Person.Person AS p1 ON p1.BusinessEntityID = e1.BusinessEntityID
    INNER JOIN Person.Person AS p2 ON p2.BusinessEntityID = e2.BusinessEntityID
WHERE
    e1.BirthDate > e2.BirthDate
    AND e1.HireDate > e2.HireDate
ORDER BY
    e1.OrganizationLevel ASC,
    p1.LastName,
    p2.LastName;

-- Задание 7. Написать хранимую процедуру, с тремя параметрами и результирующим набором данных  
DECLARE @Count INT;

EXEC GetSingleMaleEmployees '1980-01-01', '1995-12-31', @Count OUTPUT;

SELECT @Count AS RecordCount;

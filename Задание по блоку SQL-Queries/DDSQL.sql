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
-- Вариант с выводом покупателя в несколько строк, если он имеет несколько разных товаров: 
SELECT
    p.LastName AS LastName,
    p.FirstName AS FirstName,
    pr.Name AS Product,
    SUM(sod.OrderQty) AS OrderQty
FROM
    Sales.SalesOrderHeader AS soh
    JOIN Sales.Customer AS c ON soh.CustomerID = c.CustomerID
    JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product AS pr ON sod.ProductID = pr.ProductID
GROUP BY
    p.LastName,
    p.FirstName,
    pr.Name
HAVING
    SUM(sod.OrderQty) > 15
ORDER BY
    SUM(sod.OrderQty) DESC,
	p.LastName ASC,
    p.FirstName ASC

-- Вариант с выводом покупателя только один раз с товаром с самым большим количеством:
SELECT
    t.LastName AS LastName,
    t.FirstName AS FirstName,
    t.Name AS Product,
    t.TotalOrderQty AS OrderQty
FROM
    (
        SELECT
            p.LastName,
            p.FirstName,
            pr.Name,
            SUM(sod.OrderQty) AS TotalOrderQty,
            ROW_NUMBER() OVER (PARTITION BY p.LastName, p.FirstName ORDER BY SUM(sod.OrderQty) DESC) AS RowNum
        FROM
            Sales.SalesOrderHeader AS soh
            JOIN Sales.Customer AS c ON soh.CustomerID = c.CustomerID
            JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID
            JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
            JOIN Production.Product AS pr ON sod.ProductID = pr.ProductID
        GROUP BY
            p.LastName,
            p.FirstName,
            pr.Name
        HAVING
            SUM(sod.OrderQty) > 15
    ) AS t
WHERE
    t.RowNum = 1
ORDER BY
    t.TotalOrderQty DESC,
	t.LastName ASC,
    t.FirstName ASC

-- Задание 5. Вывести содержимое первого заказа каждого клиента
SELECT soh.OrderDate AS Date, P.LastName AS LastName, P.FirstName AS FirstName,
    STRING_AGG(PR.Name + ' Quantity: ' + CONVERT(NVARCHAR, sod.OrderQty) + ' pcs.', ' | ') AS 'Order'
FROM
    Sales.SalesOrderHeader AS soh
    JOIN Sales.Customer AS c ON soh.CustomerID = c.CustomerID
    JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product AS pr ON sod.ProductID = pr.ProductID
WHERE soh.SalesOrderID IN (
        SELECT MIN(SalesOrderID)
        FROM Sales.SalesOrderHeader
        GROUP BY CustomerID
    )
GROUP BY
    soh.OrderDate,
    P.LastName,
    P.FirstName
ORDER BY soh.OrderDate DESC;

-- Задание 6. Вывести список сотрудников, непосредственный руководитель которых младше сотрудника и меньше работает в компании
SELECT
    CONCAT(p1.LastName, ' ', LEFT(p1.FirstName, 1), '.', LEFT(p1.MiddleName, 1), '.') AS ManagerName,
    e1.HireDate AS HireDate,
    e1.BirthDate AS BirthDate,
    CONCAT(p2.LastName, ' ', LEFT(p2.FirstName, 1), '.', LEFT(p2.MiddleName, 1), '.') AS EmployeeName,
    e2.HireDate AS HireDate,
    e2.BirthDate AS BirthDate
FROM
    HumanResources.Employee AS e1
    INNER JOIN HumanResources.Employee AS e2 ON e2.OrganizationNode.GetAncestor(1) = e1.OrganizationNode
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

EXEC GetEmployees '1980-01-01', '1995-12-31', @Count OUTPUT;

SELECT @Count AS RecordCount;

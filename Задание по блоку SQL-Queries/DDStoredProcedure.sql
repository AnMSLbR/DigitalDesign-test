CREATE PROCEDURE GetSingleMaleEmployees
    @StartDate DATE,
    @EndDate DATE,
    @RecordCount INT OUTPUT
AS
BEGIN
    CREATE TABLE #Results
    (
        BusinessEntityID INT,
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        BirthDate DATE,
        MaritalStatus NVARCHAR(1),
        Gender NVARCHAR(1)
    );

    INSERT INTO #Results (BusinessEntityID, FirstName, LastName, BirthDate, MaritalStatus, Gender)
    SELECT 
        e.BusinessEntityID,
        p.FirstName,
        p.LastName,
        e.BirthDate,
        e.MaritalStatus,
        e.Gender
    FROM
        HumanResources.Employee e
    INNER JOIN
        Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
    WHERE
        e.MaritalStatus = 'S'
        AND e.Gender = 'M'
        AND e.BirthDate BETWEEN @StartDate AND @EndDate;

    -- Получение количества найденных записей
    SET @RecordCount = @@ROWCOUNT;

    -- Вывод результирующего набора данных
    SELECT
        BusinessEntityID,
        FirstName,
        LastName,
        BirthDate,
        MaritalStatus,
        Gender
    FROM
        #Results;

    DROP TABLE #Results;
END

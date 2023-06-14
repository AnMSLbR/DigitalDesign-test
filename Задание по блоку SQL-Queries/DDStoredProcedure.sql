CREATE PROCEDURE GetEmployees
    @StartDate DATE,
    @EndDate DATE,
    @RecordCount INT OUTPUT
AS
BEGIN
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

    SET @RecordCount = @@ROWCOUNT;
END

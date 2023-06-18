CREATE TABLE Customer (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Gender NVARCHAR(1) NOT NULL
);

CREATE TABLE Product (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL
);

CREATE TABLE Address (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    City NVARCHAR(50) NOT NULL,
    AddressLine NVARCHAR(100) NOT NULL
);

CREATE TABLE OrderHeader (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    AddressID INT NOT NULL,
    OrderDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
    FOREIGN KEY (AddressID) REFERENCES Address(ID)
);

CREATE TABLE OrderDetail (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL NOT NULL,
    Total AS Price * Quantity, 
    FOREIGN KEY (OrderID) REFERENCES OrderHeader(ID),
    FOREIGN KEY (ProductID) REFERENCES Product(ID)
);

INSERT INTO Customer (FirstName, LastName, Gender)
VALUES ('Петр', 'Романов', 'М'),
       ('София Августа Фредерика', 'Ангальт-Цербстская', 'Ж'),
       ('Александр', 'Рюрикович', 'М');

INSERT INTO Product (Name)
VALUES ('Рама оконная'),
       ('Платье бальное'),
       ('Грудки куриные'),
	   ('Cалат'),
       ('Топор'),
       ('Пила'),
       ('Доски'),
       ('Брус'),
       ('Парусина');

INSERT INTO Address (City, AddressLine)
VALUES ('СПб', 'Сенатская площадь д.1'),
       ('СПб', 'площадь Островского д.1'),
       ('СПб', 'пл. Александра Невского д.1');

INSERT INTO OrderHeader (CustomerID, AddressID, OrderDate)
VALUES (1, 1, '1703-05-27'),
       (2, 2, '1762-06-28'),
       (3, 3, '1242-04-05'),
       (1, 1, '1704-11-05');

INSERT INTO OrderDetail (OrderID, ProductID, Quantity, Price)
VALUES (1, 1, '1', 3875),
       (2, 2, '999', 15000),
       (3, 3, '5', 180),
       (3, 4, '5', 52),
       (1, 5, '1', 500),
       (1, 6, '1', 450),
       (1, 7, '200', 4890),
       (1, 8, '20', 9390),
       (1, 9, '100', 182);
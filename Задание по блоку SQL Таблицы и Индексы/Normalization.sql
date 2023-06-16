CREATE TABLE Customer (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    Имя NVARCHAR(50) NOT NULL,
    Фамилия NVARCHAR(50) NOT NULL,
    Пол NVARCHAR(1) NOT NULL
);

CREATE TABLE Product (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL
);

CREATE TABLE OrderHeader (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    ПокупательID INT NOT NULL,
    Дата_заказа DATE NOT NULL,
    Город NVARCHAR(50) NOT NULL,
    Адрес NVARCHAR(100) NOT NULL,
    FOREIGN KEY (ПокупательID) REFERENCES Customer(ID)
);

CREATE TABLE OrderDetail (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    ЗаказID INT NOT NULL,
    ТоварID INT NOT NULL,
    Количество INT NOT NULL,
    Цена DECIMAL NOT NULL,
    Всего AS Цена * Количество, 
    FOREIGN KEY (ЗаказID) REFERENCES OrderHeader(ID),
    FOREIGN KEY (ТоварID) REFERENCES Product(ID)
);

INSERT INTO Customer (Имя, Фамилия, Пол)
VALUES ('Петр', 'Романов', 'М'),
       ('София Августа Фредерика', 'Ангальт-Цербстская', 'Ж'),
       ('Александр', 'Рюрикович', 'М');

INSERT INTO Product (Название)
VALUES ('Рама оконная'),
       ('Платье бальное'),
       ('Грудки куриные'),
	   ('Cалат'),
       ('Топор'),
       ('Пила'),
       ('Доски'),
       ('Брус'),
       ('Парусина');

INSERT INTO OrderHeader (ПокупательID, Дата_заказа, Город, Адрес)
VALUES (1, '1703-05-27', 'СПб', 'Сенатская площадь д.1'),
       (2, '1762-06-28', 'СПб', 'площадь Островского д.1'),
       (3, '1242-04-05', 'СПб', 'пл. Александра Невского д.1'),
       (1, '1704-11-05', 'СПб', 'Сенатская площадь д.1');

INSERT INTO OrderDetail (ЗаказID, ТоварID, Количество, Цена)
VALUES (1, 1, '1', 3875),
       (2, 2, '999', 15000),
       (3, 3, '5', 180),
	   (3, 4, '5', 52),
       (1, 5, '1', 500),
       (1, 6, '1', 450),
       (1, 7, '200', 4890),
       (1, 8, '20', 9390),
       (1, 9, '100', 182);









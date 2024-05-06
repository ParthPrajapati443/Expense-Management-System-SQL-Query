CREATE DATABASE ExpenseManagementUaingAPI;

CREATE TABLE UserRegistration(
	UserID BIGINT PRIMARY KEY IDENTITY(1,1),
	UserName VARCHAR(50) NOT NULL,
	UserEmail VARCHAR(30) UNIQUE,
	UserPhone VARCHAR(15),
	UserAddress VARCHAR(300),
	UserCreatedDate DATETIME DEFAULT GETDATE(),
	IsActive BIT DEFAULT 1,
	UserPassword varchar(20)
);

SELECT * FROM UserRegistration;

CREATE TABLE SaveExpense(
	ExpenseID BIGINT PRIMARY KEY IDENTITY(1,1),
	ExpenseEmail VARCHAR(30) NOT NULL,
	ExpenseType VARCHAR(20) NOT NULL,
	ExpenseAmount BIGINT NOT NULL,
	ExpenseReason VARCHAR(300) DEFAULT 'Others',
	ExpenseDate VARCHAR(20) DEFAULT (CONVERT(VARCHAR, GETDATE(), 3)),
	TotalBalence BIGINT,
	UserID BIGINT FOREIGN KEY REFERENCES UserRegistration(UserID),
	UserEmail VARCHAR(30) FOREIGN KEY REFERENCES UserRegistration(UserEmail),
	ExpenseAddDate DATETIME DEFAULT GETDATE(),
	IsActive BIT DEFAULT 1
);

SELECT * FROM SaveExpense;

CREATE TABLE MonthlyExpense(
	MonthID INT PRIMARY KEY IDENTITY(1,1),
	UserName VARCHAR(30) ,
	[Month] INT,
	TotalCredit BIGINT,
	TotalDebit BIGINT,
	TotalBalence BIGINT

);

SELECT * FROM MonthlyExpense;

truncate table MonthlyExpense

EXEC Sp_MonthlyExpense 'user1@gmail.com'
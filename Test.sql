EXEC Sp_SaveExpense NULL,'credit','1000','','20-03-2024';

EXEC Sp_SaveExpense 'user2@gmail.com','credit','1000','Salary','20-03-2024';
EXEC Sp_SaveExpense 'user2@gmail.com','debit','1000','Salary','20-03-2024';

EXEC Sp_SaveExpense 'user1@gmail.com','credit',1000,null,null;

EXEC Sp_SaveExpense 'user1@gmail.com','debit',-1000,null,null;

EXEC Sp_SaveExpense 'user2@gmail.com','credit',1000,NULL,null;

EXEC Sp_SaveExpense 'user2@gmail.com','debit',-1000,null,null;

SELECT * FROM SaveExpense;

--TRUNCATE TABLE SaveExpense;

SELECT top 1 TotalBalence FROM SaveExpense WHERE ExpenseEmail ='user1@gmail.com'
ORDER BY ExpenseAddDate DESC
SELECT * FROM SaveExpense;
SELECT MONTH(ExpenseAddDate) FROM SaveExpense 
-------------------------------------------------------------------------------------------

EXEC Sp_UserRegistration 'User1','user1@gmail.com','1234567890','vastral, ahmeadabad';

EXEC Sp_UserRegistration @Flag='INSERT',@UserName='User2',@UserEmail='user2@gmail.com',@UserPhone='2234567890',@UserAddress='vastrall, ahmeadabad';

if EXISTS(SELECT UserEmail FROM UserRegistration WHERE UserEmail = 'user2@gmail.com')
	begin
		select 'true'
	end
else
	begin
		select 'false'
	end

EXEC Sp_UserRegistration @Flag='GET',@UserEmail='user@gmail.com';

SELECT * FROM UserRegistration;

delete from UserRegistration
WHERE UserId = 6;

EXEC Sp_GetExpense;

EXEC Sp_GetExpense 'user2@gmail.com';

SELECT * FROM SaveExpense;

INSERT INTO SaveExpense (ExpenseEmail, ExpenseType, ExpenseAmount, ExpenseReason, ExpenseDate, TotalBalence, UserID, UserEmail,ExpenseAddDate) 
VALUES('user1@gmail.com', 'credit', 1000, 'Other', '25/1/2024', 3000, 1, 'user1@gmail.com',dateadd(month, -1, GETDATE()))

INSERT INTO SaveExpense (ExpenseEmail, ExpenseType, ExpenseAmount, ExpenseReason, ExpenseDate, TotalBalence, UserID, UserEmail,ExpenseAddDate) 
VALUES('user1@gmail.com', 'debit', 1000, 'Other', '25/1/2024', 2000, 1, 'user1@gmail.com',dateadd(month, -1, GETDATE()))


INSERT INTO SaveExpense (ExpenseEmail, ExpenseType, ExpenseAmount, ExpenseReason, ExpenseDate, TotalBalence, UserID, UserEmail,ExpenseAddDate) 
VALUES('user2@gmail.com', 'credit', 2000, 'Other', '25/1/2024', 3500, 2, 'user2@gmail.com',dateadd(month, -1, GETDATE()))

INSERT INTO SaveExpense (ExpenseEmail, ExpenseType, ExpenseAmount, ExpenseReason, ExpenseDate, TotalBalence, UserID, UserEmail,ExpenseAddDate) 
VALUES('user2@gmail.com', 'debit', 1000, 'Other', '25/1/2024', 2000, 2, 'user2@gmail.com',dateadd(month, -1, GETDATE()))

INSERT INTO MonthlyExpense (UserName ,[MonthName] ,TotalCredit ,TotalDebit ,TotalBalence)
VALUES (@UserName, @MonthName, @TotalCredit, @TotalDebit, @TotalBalence)

EXEC Sp_MonthlyExpense 'user2@gmail.com';

EXEC Sp_Login 'user333@gmail.com', '222', 'User';

EXEC Sp_Login 'admin@gmail.com', '12356', 'Admin';

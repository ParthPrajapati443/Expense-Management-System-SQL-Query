ALTER PROC Sp_MonthlyExpense
@ExpenseEmail VARCHAR(30)
AS
BEGIN
	BEGIN TRY
		IF (@ExpenseEmail IS NOT NULL AND @ExpenseEmail != '')
			BEGIN
				IF EXISTS(SELECT 1 FROM UserRegistration WHERE UserEmail = @ExpenseEmail)
					BEGIN
						IF EXISTS(SELECT 1 FROM SaveExpense WHERE ExpenseEmail = @ExpenseEmail)
							BEGIN
								TRUNCATE TABLE MonthlyExpense
								DECLARE @UserName VARCHAR(20)
								DECLARE @TotalCredit BIGINT
								DECLARE @TotalDebit BIGINT
								DECLARE @TotalBalence BIGINT
								DECLARE @Count INT
								SET @UserName =  (SELECT UserName FROM UserRegistration WHERE UserEmail = @ExpenseEmail)
								SET @Count = 1

								WHILE @Count < 13
									BEGIN
										SET @TotalCredit = (SELECT SUM(ExpenseAmount) FROM SaveExpense WHERE ExpenseEmail = @ExpenseEmail AND  ExpenseType = 'credit' AND MONTH(ExpenseAddDate) = @Count)
										SET @TotalDebit = (SELECT SUM(ExpenseAmount) FROM SaveExpense WHERE ExpenseEmail = @ExpenseEmail AND  ExpenseType = 'debit' AND MONTH(ExpenseAddDate) = @Count)
										SET @TotalBalence = (@TotalCredit - @TotalDebit)
										IF (@TotalBalence IS NOT NULL)
											BEGIN
												--SELECT @UserName AS UserName,@Count AS [Month],@TotalCredit AS TotalCredit,@TotalDebit AS TotalDebit,@TotalBalence AS TotalBalence, '200' AS Code, '200|Data Found' AS [Message]
												INSERT INTO MonthlyExpense (UserName ,[Month] ,TotalCredit ,TotalDebit ,TotalBalence)
												VALUES (@UserName, @Count, @TotalCredit, @TotalDebit, @TotalBalence)
											END
										SET @Count = @Count+1
									END
								--SELECT @UserName AS UserName,@Count AS [Month],@TotalCredit AS TotalCredit,@TotalDebit AS TotalDebit,@TotalBalence AS TotalBalence, '200' AS Code, '200|Data Found' AS [Message]
								SELECT UserName ,[Month] ,TotalCredit ,TotalDebit ,TotalBalence, '200' AS Code, '200|Data Found' AS [Message] FROM MonthlyExpense
							END
						ELSE
							BEGIN
								SELECT '400' AS Code, '400|Expense detail is not exist.' AS [Message]
							END 
					END
				ELSE 
			        BEGIN
						SELECT '400' AS Code, '400|User does not exist.' AS [Message]
					END  
			END
		ELSE 
			BEGIN
				SELECT '400' AS Code, '400|Enter your E-mail.' AS [Message]
			END
	END TRY  
	BEGIN CATCH
	   SELECT ERROR_MESSAGE() AS [Message]
	END CATCH
END
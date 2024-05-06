ALTER PROC Sp_GetExpense
@ExpenseEmail VARCHAR(30) = NULL
AS
BEGIN
	BEGIN TRY
		IF(@ExpenseEmail IS NULL OR @ExpenseEmail='')
			BEGIN
				SELECT ExpenseID, ExpenseEmail, ExpenseType, ExpenseAmount, TotalBalence, ExpenseReason, ExpenseDate, '200' AS Code, '200|Expense Detail of all users.' AS [Message]
				FROM SaveExpense 
				AS GetAllExpense
			END
		ELSE 
			BEGIN
				IF EXISTS(SELECT 1 FROM UserRegistration WHERE UserEmail = @ExpenseEmail)
					BEGIN
						IF EXISTS(SELECT 1 FROM SaveExpense WHERE ExpenseEmail = @ExpenseEmail)
							BEGIN
								SELECT ExpenseID, ExpenseEmail, ExpenseType, ExpenseAmount, TotalBalence, ExpenseReason, ExpenseDate, '200' AS Code, '200|Expense Detail of only one user.' AS [Message]
								FROM SaveExpense  
								WHERE ExpenseEmail = @ExpenseEmail
							END
						ELSE
							BEGIN
								SELECT '400' AS Code, '400|Expense detail is not exist.' AS [Message]
							END
					END
				ELSE
					BEGIN
						SELECT '400' AS Code, '400|User dose not Exist.' AS [Message]
					END
			END
	END TRY  
	BEGIN CATCH
	   SELECT ERROR_MESSAGE() AS [Message]
	END CATCH
END


ALTER PROC Sp_SaveExpense
@ExpenseEmail VARCHAR(30),
@ExpenseType VARCHAR(20),
@ExpenseAmount BIGINT,
@ExpenseReason VARCHAR(300),
@ExpenseDate VARCHAR(20)
AS
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT 1 FROM UserRegistration WHERE UserEmail = @ExpenseEmail)
			BEGIN
				IF (@ExpenseEmail IS NOT NULL AND @ExpenseEmail != '' AND @ExpenseType IS NOT NULL AND @ExpenseType != '' AND @ExpenseAmount IS NOT NULL AND @ExpenseAmount != 0 AND @ExpenseAmount !< 0)
					BEGIN
						DECLARE @UserID BIGINT
						DECLARE @LastTotalBalence BIGINT

						IF (@ExpenseReason IS NULL OR @ExpenseReason = '')
							BEGIN
								SET @ExpenseReason = 'Others'
							END				

						IF (@ExpenseDate IS NULL OR @ExpenseDate = '')
							BEGIN
								SET @ExpenseDate = CONVERT(VARCHAR, GETDATE(), 3)
							END
						
						SET @UserID = (SELECT UserID FROM UserRegistration WHERE UserEmail = @ExpenseEmail)
						SET @LastTotalBalence = (SELECT TOP 1 TotalBalence FROM SaveExpense WHERE ExpenseEmail = @ExpenseEmail
												ORDER BY ExpenseAddDate DESC)

										
						IF (@LastTotalBalence IS NULL AND @ExpenseType = 'credit')
							BEGIN
								SET @LastTotalBalence = @ExpenseAmount

									INSERT INTO SaveExpense (ExpenseEmail, ExpenseType, ExpenseAmount, ExpenseReason, ExpenseDate
															, TotalBalence, UserID, UserEmail) 
									VALUES(@ExpenseEmail, @ExpenseType, @ExpenseAmount, @ExpenseReason, @ExpenseDate
												, @LastTotalBalence, @UserID, @ExpenseEmail) 

								SELECT '200' AS Code, 'Expense inserted Successfully' AS [Message]
							END
						ELSE IF (@ExpenseType = 'credit')
							BEGIN
								SET @LastTotalBalence = (@LastTotalBalence + @ExpenseAmount)

								INSERT INTO SaveExpense (ExpenseEmail, ExpenseType, ExpenseAmount, ExpenseReason, ExpenseDate, TotalBalence
														, UserID, UserEmail) 
								VALUES(@ExpenseEmail, @ExpenseType, @ExpenseAmount, @ExpenseReason, @ExpenseDate, @LastTotalBalence
													, @UserID, @ExpenseEmail) 
								SELECT '200' AS Code, 'Expense inserted Successfully' AS [Message]
							END
						ELSE IF (@ExpenseType = 'debit')
							BEGIN
								IF (@LastTotalBalence >= @ExpenseAmount)
									BEGIN
										SET @LastTotalBalence = (@LastTotalBalence - @ExpenseAmount)
										INSERT INTO SaveExpense (ExpenseEmail, ExpenseType, ExpenseAmount, ExpenseReason, ExpenseDate, TotalBalence, UserID, UserEmail) VALUES(@ExpenseEmail, @ExpenseType, @ExpenseAmount, @ExpenseReason, @ExpenseDate, @LastTotalBalence, @UserID, @ExpenseEmail) 
										SELECT '200' AS Code, 'Expense inserted Successfully' AS [Message]
									END
								ELSE 
									BEGIN
										SELECT '400' AS Code, 'Insufficent balence.' AS [Message]
									END
							END
					END
				ELSE 
			        BEGIN
						SELECT '400' AS Code, 'Enter the proper details. Expense is not saved' AS [Message]
					END  
			END
		ELSE 
			BEGIN
				SELECT '400' AS Code, 'User does not exist.' AS [Message]
			END
		
	END TRY  
	BEGIN CATCH
	   SELECT ERROR_MESSAGE() AS Error
	END CATCH
END


ALTER PROC Sp_UserRegistration
@Flag VARCHAR(20),
@UserName VARCHAR(50),
@UserEmail VARCHAR(30),
@UserPhone VARCHAR(15),
@UserAddress VARCHAR(300),
@UserPassword VARCHAR(20)
AS
BEGIN
	BEGIN TRY
		IF (@Flag = 'INSERT')
			BEGIN
				IF (@UserEmail IS NOT NULL AND @UserEmail != '')
					BEGIN
						IF EXISTS(SELECT 1 FROM UserRegistration WHERE UserEmail = @UserEmail)
							BEGIN
								SELECT '400' AS Code, '400|Already Exist' AS [Message]
							END
						ELSE
							BEGIN
								INSERT INTO UserRegistration (UserName, UserEmail, UserPhone, UserAddress,UserPassword)
								VALUES(@UserName, @UserEmail, @UserPhone, @UserAddress,@UserPassword) 
								SELECT '200' AS Code, '200|Insertes Successfully' AS [Message]
							END
					END
				ELSE
					BEGIN
						SELECT '400' AS Code, '400|Enter your email properly.' AS [Message]
					END
			END
		ELSE IF (@Flag = 'GET')
			BEGIN
				IF (@UserEmail IS NULL OR @UserEmail = '')
					BEGIN
						SELECT  UserID,UserName, UserEmail, UserPhone, UserAddress, IsActive 
						FROM UserRegistration
					END		
				ELSE IF (@UserEmail IS NOT NULL OR @UserEmail != '')
					BEGIN
						IF NOT EXISTS(SELECT 1 FROM UserRegistration WHERE UserEmail = @UserEmail)
							BEGIN
								SELECT '400' AS Code, '400|User does not Exist.' AS [Message]
							END
						ELSE
							BEGIN
								SELECT  UserID,UserName, UserEmail, UserPhone, UserAddress, IsActive 
								FROM UserRegistration 
								WHERE UserEmail = @UserEmail
							END
					END
				ELSE
					BEGIN
						SELECT '400' AS Code, '400|Data not found.' AS [Message]
					END
					
				END
	END TRY  
	BEGIN CATCH
	   SELECT ERROR_MESSAGE() AS [Message]
	END CATCH
END

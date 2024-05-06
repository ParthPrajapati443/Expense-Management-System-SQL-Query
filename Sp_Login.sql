ALTER PROC Sp_Login
@EmailId VARCHAR(30),
@Password VARCHAR(20),
@Role VARCHAR(15)
AS
BEGIN
	BEGIN TRY
		IF (@Role = 'User')
			BEGIN
				IF EXISTS(SELECT 1 FROM UserRegistration WHERE UserEmail = @EmailId AND UserPassword = @Password) AND (@Role = 'User')
					BEGIN
						SELECT '200' AS Code, '200|Successfull Login as User' AS [Message], @EmailId AS Email
					END
				ELSE
					BEGIN
						SELECT '400' AS Code, '400|User does not exist' AS [Message]
					END
			END
		
		ELSE IF (@EmailId = 'admin@gmail.com' AND @Password = '123456' AND @Role = 'Admin')
			BEGIN
				SELECT '200' AS Code, '200|Successfull Login as Admin' AS [Message], @EmailId AS Email
			END
		ELSE
			BEGIN
				SELECT '400' AS Code, 'Unsuccessfull' AS [Message]
			END
	END TRY  
	BEGIN CATCH
	   SELECT ERROR_MESSAGE() AS [Message]
	END CATCH
END

DECLARE @CodeError INT;
DECLARE @MessageError NVARCHAR(MAX);
SET @CodeError = 0;
SET @MessageError = '';

BEGIN TRY
    BEGIN TRANSACTION
    --   DELETE FROM Tabla1 WHERE (ID = 2)
	   --SELECT *  FROM Tabla1
       DELETE FROM Usuario WHERE (IdUsuario LIKE @IdUsuario)
       DELETE FROM Login WHERE (IdUsuario LIKE @IdUsuario)
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    SET @CodeError = ERROR_NUMBER()
    IF @CodeError = 547
	    BEGIN
		    SET @MessageError = 'No se puede eliminar este usario porque ya tiene información relacionada.';
		END
 
-- Transaction uncommittable
    IF (XACT_STATE()) = -1
        ROLLBACK TRANSACTION
 
-- Transaction committable
    IF (XACT_STATE()) = 1
        COMMIT TRANSACTION
 END CATCH
 SELECT @CodeError;
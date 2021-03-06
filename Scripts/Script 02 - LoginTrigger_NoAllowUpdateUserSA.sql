USE [BDBocore]
GO
/****** Object:  Trigger [dbo].[LoginTrigger_NoAllowUpdateUserSA]    Script Date: 3/4/2021 18:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	JORGE URIEL LIEVANO CIFUENTES
-- Create date: Febrero 2021
-- Description:	Evita que el usuario super administrador sea modificado.
-- =============================================
ALTER TRIGGER [dbo].[LoginTrigger_NoAllowUpdateUserSA]
ON [dbo].[Login]
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
	-- Si no existen filas para actualizar, salir.
    IF 0 = (SELECT COUNT(*) FROM inserted) RETURN

	DECLARE @UsuarioActual NVARCHAR(20);
	DECLARE @UsuarioNuevo NVARCHAR(20);
	SELECT @UsuarioActual=Usuario FROM deleted;
	SELECT @UsuarioNuevo=Usuario FROM inserted;

    --If Exists(SELECT 1 FROM inserted WHERE Usuario = 'sa')
	IF @UsuarioActual = 'sa' AND @UsuarioNuevo <> 'sa'
    BEGIN
        RAISERROR('No está permitido cambiar el usuario Super Administrador', 16, 1);
        ROLLBACK TRANSACTION;
        Return;
    END;
END

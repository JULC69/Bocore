USE [BDBocore]
GO
INSERT [dbo].[Login] ([IdLogin], [IdCentroServicio], [Usuario], [Contrasena], [DebeCambiar], [IdUsuario], [FechaCreacion], [FechaUltimaActividad]) VALUES (N'95403295-5e84-4f5c-a636-02a071ef254f', 1, N'Empresariales', N'123456', 0, N'95403295-5e84-4f5c-a636-02a071ef254f', CAST(N'2021-03-22T14:08:29.487' AS DateTime), CAST(N'2021-03-22T14:08:29.487' AS DateTime))
GO
INSERT [dbo].[Login] ([IdLogin], [IdCentroServicio], [Usuario], [Contrasena], [DebeCambiar], [IdUsuario], [FechaCreacion], [FechaUltimaActividad]) VALUES (N'fb127f8e-a162-4d97-8a43-14d41cbb5265', 2, N'CampusVirtual', N'123456', 0, N'fb127f8e-a162-4d97-8a43-14d41cbb5265', CAST(N'2021-04-03T18:35:18.430' AS DateTime), CAST(N'2021-04-03T18:35:18.430' AS DateTime))
GO
INSERT [dbo].[Login] ([IdLogin], [IdCentroServicio], [Usuario], [Contrasena], [DebeCambiar], [IdUsuario], [FechaCreacion], [FechaUltimaActividad]) VALUES (N'b3bd9d1a-d923-4f10-b33c-248aa0c3632c', 5, N'Laboratorios', N'123456', 0, N'b3bd9d1a-d923-4f10-b33c-248aa0c3632c', CAST(N'2021-04-03T18:38:25.167' AS DateTime), CAST(N'2021-04-03T18:38:25.167' AS DateTime))
GO
INSERT [dbo].[Login] ([IdLogin], [IdCentroServicio], [Usuario], [Contrasena], [DebeCambiar], [IdUsuario], [FechaCreacion], [FechaUltimaActividad]) VALUES (N'f745c9e5-73ee-4fb0-8147-3c08cbe297de', 1, N'AndresLievano', N'123456', 1, N'FBC09DCC-6D97-4442-8713-D260D0D2933B', CAST(N'2021-04-15T22:51:35.850' AS DateTime), CAST(N'2021-04-15T22:51:35.850' AS DateTime))
GO
INSERT [dbo].[Login] ([IdLogin], [IdCentroServicio], [Usuario], [Contrasena], [DebeCambiar], [IdUsuario], [FechaCreacion], [FechaUltimaActividad]) VALUES (N'f53d86fc-54b7-4d5c-b0d1-460db2d1d4e9', 4, N'Creatividad', N'123456', 0, N'f53d86fc-54b7-4d5c-b0d1-460db2d1d4e9', CAST(N'2021-04-03T18:37:36.390' AS DateTime), CAST(N'2021-04-03T18:37:36.390' AS DateTime))
GO
INSERT [dbo].[Login] ([IdLogin], [IdCentroServicio], [Usuario], [Contrasena], [DebeCambiar], [IdUsuario], [FechaCreacion], [FechaUltimaActividad]) VALUES (N'94a6985b-e9b3-43e9-9356-484a52b8034d', 3, N'ClinicaVeterinaria', N'123456', 0, N'94a6985b-e9b3-43e9-9356-484a52b8034d', CAST(N'2021-04-03T18:36:37.103' AS DateTime), CAST(N'2021-04-03T18:36:37.103' AS DateTime))
GO


--- USUARIOS
INSERT [dbo].[Usuario] ([IdCentroServicio], [IdUsuario], [Nombres], [Apellidos], [Foto], [IdTipoDocumento], [Documento], [IdRol], [Email], [Celular], [Direccion], [CodigoPostal], [IdPais], [IdDepartamento], [IdCiudad], [OtraCIudad], [TiempoConectado], [Activo], [FechaRegistro], [FechaActualizacion]) VALUES (1, N'95403295-5e84-4f5c-a636-02a071ef254f', N'Jorge', N'Lievano', N'f0b1c1ba-0d50-48ee-8856-542d4a405042_Jorge_Lievano.JPG', 1, N'91271544', 3, N'jorge.lievano@outlook.com', N'320-9192537', N'Direccion 1', NULL, 48, N'68', N'68001', NULL, 0, 1, CAST(N'2021-03-22T14:12:06.047' AS DateTime), CAST(N'2021-04-19T08:16:17.247' AS DateTime))
GO
INSERT [dbo].[Usuario] ([IdCentroServicio], [IdUsuario], [Nombres], [Apellidos], [Foto], [IdTipoDocumento], [Documento], [IdRol], [Email], [Celular], [Direccion], [CodigoPostal], [IdPais], [IdDepartamento], [IdCiudad], [OtraCIudad], [TiempoConectado], [Activo], [FechaRegistro], [FechaActualizacion]) VALUES (2, N'fb127f8e-a162-4d97-8a43-14d41cbb5265', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, CAST(N'2021-04-13T10:52:34.553' AS DateTime), CAST(N'2021-04-13T10:52:34.553' AS DateTime))
GO
INSERT [dbo].[Usuario] ([IdCentroServicio], [IdUsuario], [Nombres], [Apellidos], [Foto], [IdTipoDocumento], [Documento], [IdRol], [Email], [Celular], [Direccion], [CodigoPostal], [IdPais], [IdDepartamento], [IdCiudad], [OtraCIudad], [TiempoConectado], [Activo], [FechaRegistro], [FechaActualizacion]) VALUES (3, N'b3bd9d1a-d923-4f10-b33c-248aa0c3632c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, CAST(N'2021-04-13T10:52:58.710' AS DateTime), CAST(N'2021-04-13T10:52:58.710' AS DateTime))
GO
INSERT [dbo].[Usuario] ([IdCentroServicio], [IdUsuario], [Nombres], [Apellidos], [Foto], [IdTipoDocumento], [Documento], [IdRol], [Email], [Celular], [Direccion], [CodigoPostal], [IdPais], [IdDepartamento], [IdCiudad], [OtraCIudad], [TiempoConectado], [Activo], [FechaRegistro], [FechaActualizacion]) VALUES (4, N'f53d86fc-54b7-4d5c-b0d1-460db2d1d4e9', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, CAST(N'2021-04-13T10:53:09.517' AS DateTime), CAST(N'2021-04-13T10:53:09.517' AS DateTime))
GO
INSERT [dbo].[Usuario] ([IdCentroServicio], [IdUsuario], [Nombres], [Apellidos], [Foto], [IdTipoDocumento], [Documento], [IdRol], [Email], [Celular], [Direccion], [CodigoPostal], [IdPais], [IdDepartamento], [IdCiudad], [OtraCIudad], [TiempoConectado], [Activo], [FechaRegistro], [FechaActualizacion]) VALUES (5, N'94a6985b-e9b3-43e9-9356-484a52b8034d', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, CAST(N'2021-04-13T10:53:18.660' AS DateTime), CAST(N'2021-04-13T10:53:18.660' AS DateTime))
GO
INSERT [dbo].[Usuario] ([IdCentroServicio], [IdUsuario], [Nombres], [Apellidos], [Foto], [IdTipoDocumento], [Documento], [IdRol], [Email], [Celular], [Direccion], [CodigoPostal], [IdPais], [IdDepartamento], [IdCiudad], [OtraCIudad], [TiempoConectado], [Activo], [FechaRegistro], [FechaActualizacion]) VALUES (1, N'fbc09dcc-6d97-4442-8713-d260d0d2933b', N'Andres', N'Lievano', NULL, 1, N'1100555', 3, N'andres.lievano@outlook.com', N'300-9192666', N'Direccion 2', NULL, 70, N'00', NULL, N'Oklahoma', 0, 1, CAST(N'2021-04-15T22:51:35.897' AS DateTime), CAST(N'2021-04-15T22:51:35.897' AS DateTime))
GO

-----------------------------------------------------------------------------------
DELETE FROM Usuario
WHERE (IdUsuario = 'FBC09DCC-6D97-4442-8713-D260D0D2933B')

DELETE FROM Login
WHERE (IdUsuario = 'FBC09DCC-6D97-4442-8713-D260D0D2933B')

USE [BDBocore]
GO
INSERT [dbo].[Login] ([IdLogin], [IdCentroServicio], [Usuario], [Contrasena], [DebeCambiar], [IdUsuario], [FechaCreacion], [FechaUltimaActividad]) VALUES (N'f745c9e5-73ee-4fb0-8147-3c08cbe297de', 1, N'AndresLievano', N'123456', 1, N'FBC09DCC-6D97-4442-8713-D260D0D2933B', CAST(N'2021-04-15T22:51:35.850' AS DateTime), CAST(N'2021-04-15T22:51:35.850' AS DateTime))
INSERT [dbo].[Usuario] ([IdCentroServicio], [IdUsuario], [Nombres], [Apellidos], [Foto], [IdTipoDocumento], [Documento], [IdRol], [Email], [Celular], [Direccion], [CodigoPostal], [IdPais], [IdDepartamento], [IdCiudad], [OtraCIudad], [TiempoConectado], [Activo], [FechaRegistro], [FechaActualizacion]) VALUES (1, N'fbc09dcc-6d97-4442-8713-d260d0d2933b', N'Andres', N'Lievano', NULL, 1, N'1100555', 3, N'andres.lievano@outlook.com', N'300-9192666', N'Direccion 2', NULL, 70, N'00', NULL, N'Oklahoma', 0, 1, CAST(N'2021-04-15T22:51:35.897' AS DateTime), CAST(N'2021-04-15T22:51:35.897' AS DateTime))

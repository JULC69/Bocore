USE [BDBocore]
GO
SET IDENTITY_INSERT [dbo].[Proyecto] ON 
GO
INSERT [dbo].[Proyecto] ([IdCentroServicio], [IdProyecto], [IdTipoProyecto], [Titulo], [Descripcion], [Alcance], [ObjetivoMinimo], [IdEmpresa], [ProgramaAcademico], [AsignaturaAcademica], [IdEtapaActual], [IdEstadoProyecto], [IdUsuario], [IdRol], [FechaRegistro], [FechaActualizacion]) VALUES (1, 1, 1, N'Título 1', N'Descripcion del proyecto 1', N'Alcance del proyecto 1', N'Objetivo mínimo del proyecto 1', 1, N'Programa Academico 1', N'Asignatura Academica 11', 1, 1, N'95403295-5e84-4f5c-a636-02a071ef254f', 1, CAST(N'2021-04-28T20:52:56.930' AS DateTime), CAST(N'2021-05-01T08:28:59.610' AS DateTime))
GO
INSERT [dbo].[Proyecto] ([IdCentroServicio], [IdProyecto], [IdTipoProyecto], [Titulo], [Descripcion], [Alcance], [ObjetivoMinimo], [IdEmpresa], [ProgramaAcademico], [AsignaturaAcademica], [IdEtapaActual], [IdEstadoProyecto], [IdUsuario], [IdRol], [FechaRegistro], [FechaActualizacion]) VALUES (1, 2, 1, N'Título 2', N'Descripcion del proyecto 2', N'Alcance del proyecto 2', N'Objetivo mínimo del proyecto 2', 1, N'Programa Academico 1', N'Asignatura Academica 22', 1, 1, N'95403295-5e84-4f5c-a636-02a071ef254f', 1, CAST(N'2021-04-28T20:55:30.417' AS DateTime), CAST(N'2021-05-01T09:08:36.703' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Proyecto] OFF
GO
SET IDENTITY_INSERT [dbo].[ParticipanteProyecto] ON 
GO
INSERT [dbo].[ParticipanteProyecto] ([IdParticipanteProyecto], [IdProyecto], [IdUsuario], [IdRol], [FechaRegistro]) VALUES (13, 2, N'fbc09dcc-6d97-4442-8713-d260d0d2933b', 3, CAST(N'2021-04-29T19:27:21.863' AS DateTime))
GO
INSERT [dbo].[ParticipanteProyecto] ([IdParticipanteProyecto], [IdProyecto], [IdUsuario], [IdRol], [FechaRegistro]) VALUES (14, 2, N'95403295-5e84-4f5c-a636-02a071ef254f', 3, CAST(N'2021-04-29T19:28:05.140' AS DateTime))
GO
INSERT [dbo].[ParticipanteProyecto] ([IdParticipanteProyecto], [IdProyecto], [IdUsuario], [IdRol], [FechaRegistro]) VALUES (30, 1, N'fbc09dcc-6d97-4442-8713-d260d0d2933b', 3, CAST(N'2021-05-01T08:16:37.247' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[ParticipanteProyecto] OFF
GO
INSERT [dbo].[Empresa] ([IdEmpresa], [RazonSocial], [NIT], [Logo], [RepresentanteLegal], [Email], [Celular1], [Celular2], [Telefono1], [Telefono2], [IdPais], [IdDepartamento], [IdCiudad], [OtraCIudad], [Direccion], [IdUsuario], [IdRol], [FechaRegistro], [FechaActualizacion]) VALUES (1, N'Empresa 1', N'111111112', NULL, N'Representante 1', N'representante@servidor.com', N'301 21456987', N'300 1478563', N'6387845', NULL, 48, N'68', N'68001', NULL, N'Direccion 1', N'95403295-5e84-4f5c-a636-02a071ef254f', 1, CAST(N'2021-04-27T12:25:00.000' AS DateTime), CAST(N'2021-04-27T12:25:00.000' AS DateTime))
GO
INSERT [dbo].[Usuario] ([IdCentroServicio], [IdUsuario], [Nombres], [Apellidos], [Foto], [IdTipoDocumento], [Documento], [IdRol], [Email], [Celular], [Direccion], [CodigoPostal], [IdPais], [IdDepartamento], [IdCiudad], [OtraCIudad], [TiempoConectado], [Activo], [FechaRegistro], [FechaActualizacion]) VALUES (1, N'95403295-5e84-4f5c-a636-02a071ef254f', N'JorgeX', N'Lievano', N'f0b1c1ba-0d50-48ee-8856-542d4a405042_Jorge_Lievano.JPG', 1, N'91271544', 3, N'jorge.lievano@outlook.com', N'320-9192537', N'Direccion 1', NULL, 48, N'68', N'68001', NULL, 0, 1, CAST(N'2021-03-22T14:12:06.047' AS DateTime), CAST(N'2021-04-20T17:28:02.923' AS DateTime))
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

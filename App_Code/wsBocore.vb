Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Web.Script.Services
Imports System.Net
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System
Imports System.Collections.Generic
Imports System.Guid
Imports System.Web.Script.Serialization
Imports System.IO
Imports dtoDataTables
'Imports Newtonsoft.Json

' Para permitir que se llame a este servicio web desde un script, usando ASP.NET AJAX, quite la marca de comentario de la línea siguiente.
<System.Web.Script.Services.ScriptService()>
<WebService(Namespace:="http://tempuri.org/")>
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)>
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Public Class wsBocore
    Inherits System.Web.Services.WebService

    <WebMethod()>
    Public Function HelloWorld() As String
        Return "Hola a todos"
    End Function

    ''' <summary>
    ''' Crea un registro de participante del proyecto especificado
    ''' </summary>
    ''' <param name="dataNuevoParticipante">Objeto que contiene información de un nuevo participante dal proyecto.</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function AgregarParticipanteProyecto(dataNuevoParticipante As DataNuevoParticipante) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLInsert As String = String.Empty
                Dim registrosAfectados As Integer = -1
                Dim strSubquery As String = String.Empty

                strSubquery = "SELECT IdProyecto, IdUsuario "
                strSubquery &= "   FROM ParticipanteProyecto "
                strSubquery &= "WHERE (IdProyecto = @IdProyecto) "
                strSubquery &= "      AND (IdUsuario LIKE @IdUsuario) "

                strSQLInsert = String.Format("IF NOT EXISTS({0}) ", strSubquery)
                strSQLInsert &= "BEGIN "
                strSQLInsert &= "      DECLARE @IdRol INT;"
                strSQLInsert &= "      SELECT @IdRol = IdRol "
                strSQLInsert &= "         FROM [dbo].[Usuario] "
                strSQLInsert &= "      WHERE (IdUsuario LIKE @IdUsuario); "

                strSQLInsert &= "     INSERT INTO ParticipanteProyecto ("
                strSQLInsert &= "          IdProyecto, "
                strSQLInsert &= "          IdUsuario, "
                strSQLInsert &= "          IdRol, "
                strSQLInsert &= "          FechaRegistro) "
                strSQLInsert &= "     VALUES ("
                strSQLInsert &= "          @IdProyecto, "
                strSQLInsert &= "          @IdUsuario, "
                strSQLInsert &= "          @IdRol, "
                strSQLInsert &= "          GETDATE()); "
                strSQLInsert &= "     SET @ParticipanteExiste = 0; "
                strSQLInsert &= "END "
                strSQLInsert &= "ELSE "
                strSQLInsert &= "BEGIN "
                strSQLInsert &= "     SET @ParticipanteExiste = 1; "
                strSQLInsert &= "END "

                'Diligencia parámetros
                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = dataNuevoParticipante.IdProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = dataNuevoParticipante.IdUsuario
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmParticipanteExiste As New SqlParameter("@ParticipanteExiste", SqlDbType.Bit)
                prmParticipanteExiste.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmParticipanteExiste)

                ''Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.SmallInt)
                ''prmIDRol.Value = DataParticipanteProyecto.IdRol
                ''cmd.Parameters.Add(prmIDRol)

                cmd.CommandText = strSQLInsert
                cmd.ExecuteNonQuery()

                Dim participanteExiste As Boolean = Boolean.Parse(cmd.Parameters("@ParticipanteExiste").Value)

                transaction.Commit()

                If participanteExiste Then
                    respuesta.Codigo = "-1"
                    respuesta.Mensaje = "El particpante seleccionado ya se encuentra vinculado al proyecto."
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al vincular participante al proyecto actual. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de centros de servicios
    ''' </summary>
    ''' <returns>Lista de centros de servicios</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaCentrosServicios() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdCentroServicio AS ID, Nombre "
                strSQLSelect &= "FROM  CentroServicio "
                strSQLSelect &= "ORDER BY Nombre"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Nombre").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay centros de servicios disponibles"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de centros de servicios</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de departamentos ó estados
    ''' </summary>
    ''' <param name="idDepartamento">Identificador ó código del departamento</param>
    ''' <returns>Lista de departamentos ó estado</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaCiudades(idDepartamento As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdCIudad AS ID, Nombre "
                strSQLSelect &= "FROM  Ciudad "
                strSQLSelect &= "WHERE  IdDepartamento = @IdDepartamento "
                strSQLSelect &= "ORDER BY Nombre"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIdDepartamento As New SqlParameter("@IdDepartamento", SqlDbType.NVarChar, 2)
                    prmIdDepartamento.Value = idDepartamento.Trim()
                    cmd.Parameters.Add(prmIdDepartamento)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Nombre").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay ciudades ó municipios disponibles"
                        End If
                    End Using 'sdr

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de ciudades ó municipios</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de departamentos ó estados
    ''' </summary>
    ''' <returns>Lista de departamentos ó estado</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaDepartamentos(idPais As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        If idPais = "48" Then 'Si es Colombia....
            Try
                Using connection As New SqlConnection(connectionString)
                    connection.Open()

                    Dim strSQLSelect As String = String.Empty

                    strSQLSelect = "SELECT IdDepartamento AS ID, Nombre "
                    strSQLSelect &= "FROM  Departamento "
                    strSQLSelect &= "ORDER BY Orden"

                    Using cmd As New SqlCommand(strSQLSelect)
                        cmd.Connection = connection
                        cmd.CommandType = CommandType.Text

                        Using sdr As SqlDataReader = cmd.ExecuteReader()
                            If sdr.HasRows Then
                                While sdr.Read()
                                    Dim item As New itemLista

                                    item.Key = sdr("ID").ToString()
                                    item.Value = sdr("Nombre").ToString()
                                    listaItems.Add(item)
                                End While
                                respuesta.Resultado = listaItems
                            Else 'Esto no deberá ocurrir nunca.
                                respuesta.Codigo = -1
                                respuesta.Mensaje = "No hay departamentos disponibles"
                            End If
                        End Using 'sdr

                    End Using

                    connection.Close()
                End Using

            Catch ex As Exception
                respuesta.Codigo = -1
                respuesta.Mensaje = String.Format("<b>Error al recuperar lista de departamentos</b>. Mensaje: {0}", ex.Message)
            End Try
        Else
            Dim item As New itemLista

            item.Key = "00"
            item.Value = "Exterior"
            listaItems.Add(item)
            respuesta.Resultado = listaItems
        End If

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Retorna un objeto DatatTable con el listado de documentos relacionados con el proyecto especificado..
    ''' </summary>
    ''' <param name="idProyecto">Identificador de proyecto.</param>
    ''' <returns>Listado de documentos del prouecto especificado.</returns>
    ''' <remarks>Copyright JULC Mayo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaDocumentosProyecto(idProyecto As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaDocumentos As List(Of DataDocumentoDTO) = New List(Of DataDocumentoDTO)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT DOC.IdDocumento, "
                strSQLSelect &= "             DOC.NombreOriginalDocumento, "
                strSQLSelect &= "             DOC.NombreArchivoServidor, "
                strSQLSelect &= "             CONCAT(USR.Nombres,' ', USR.Apellidos) AS Responsable, "
                strSQLSelect &= "             DOC.FechaRegistro "
                strSQLSelect &= "    FROM Documento AS DOC INNER JOIN Usuario AS USR "
                strSQLSelect &= "         ON DOC.IdResponsable = USR.IdUsuario "
                strSQLSelect &= " WHERE (DOC.IdProyecto = @IdProyecto) "
                strSQLSelect &= "ORDER BY DOC.FechaRegistro DESC"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                    prmIDProyecto.Value = idProyecto
                    cmd.Parameters.Add(prmIDProyecto)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")
                            Dim urlBase As String = ObtenerURLBase()

                            While sdr.Read()
                                Dim documento As New DataDocumentoDTO
                                documento.IdDocumento = sdr("IdDocumento").ToString()
                                documento.IdProyecto = idProyecto
                                documento.NombreArchivo = Path.GetFileNameWithoutExtension(sdr("NombreOriginalDocumento").ToString())
                                documento.URL = String.Format("{0}Files/CentroServicio{1}/Proyectos/{2}/Documentos/{3}", urlBase, idCentroServicio, Long.Parse(idProyecto).ToString("D6"), sdr("NombreArchivoServidor").ToString())
                                documento.Responsable = sdr("Responsable").ToString()
                                documento.FechaRegistro = DateTime.Parse(sdr("FechaRegistro")).ToString("dd-MM-yyyy HH:mm:ss")

                                listaDocumentos.Add(documento)
                            End While
                            respuesta.Resultado = listaDocumentos
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay aún documentos registrados con el proyecto actual."
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar información sobre documentos relacionados con el proyecto actual.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de empresas vinculadas con la Universidad
    ''' </summary>
    ''' <returns>Lista de empresas vinculadas</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaEmpresas() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdEmpresa AS ID, RazonSocial "
                strSQLSelect &= "FROM  Empresa "
                strSQLSelect &= "ORDER BY RazonSocial"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("RazonSocial").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay empresas disponibles"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de empresas</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de estados proyecto
    ''' </summary>
    ''' <returns>Lista de estados proyecto</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaEstadosProyecto() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdEstadoProyecto AS ID, Nombre "
                strSQLSelect &= "FROM  EstadoProyecto "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Nombre").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay estados de proyecto disponibles"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de estados de proyecto</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de estados de requisitos
    ''' </summary>
    ''' <returns>Lista de estados de requisitos</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaEstadosRequisito() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdEstadoRequisito AS ID, Nombre "
                strSQLSelect &= "FROM  EstadoRequisito "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Nombre").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay estados del requisito disponibles"
                        End If

                    End Using
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de estados del requisito</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de estados de tarea
    ''' </summary>
    ''' <returns>Lista de estados de tarea</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaEstadosTarea() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdEstadoTarea AS ID, Descripcion "
                strSQLSelect &= "FROM  EstadoProyecto "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Descripcion").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay estados de tarea disponibles"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de estados de tarea</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de etapas de un proyecto
    ''' </summary>
    ''' <returns>Lista de etapas de un proyecto</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaEtapas() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdEtapa AS ID, Descripcion "
                strSQLSelect &= "FROM  Etapa "
                strSQLSelect &= "ORDER BY Descripcion"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Descripcion").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay etapas de proyecto disponibles"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de etapas de un proyecto</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Retorna un objeto DatatTable con el listado de empresas registradas en el sistema.
    ''' </summary>
    ''' <returns>Listado de mepresas</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaGeneralEmpresas() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaEmpresas As List(Of DataListaGeneralEmpresas) = New List(Of DataListaGeneralEmpresas)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdEmpresa, "
                strSQLSelect &= "            RazonSocial, "
                strSQLSelect &= "            RepresentanteLegal, "
                strSQLSelect &= "            Celular1, "
                strSQLSelect &= "            FechaRegistro "
                strSQLSelect &= "   FROM Empresa "
                strSQLSelect &= "ORDER BY RazonSocial"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim empresa As New DataListaGeneralEmpresas

                                empresa.IdEmpresa = sdr("IdEmpresa").ToString()
                                empresa.RazonSocial = sdr("RazonSocial").ToString()
                                empresa.RepresentanteLegal = sdr("RepresentanteLegal").ToString()
                                empresa.Celular = sdr("Celular1").ToString()
                                empresa.FechaRegistro = DateTime.Parse(sdr("FechaRegistro")).ToString("dd-MM-yyyy HH:mm:ss")

                                listaEmpresas.Add(empresa)
                            End While
                            respuesta.Resultado = listaEmpresas
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay información disponible sobre empresas."
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar información sobre empresas.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Retorna un objeto DatatTable con un listado general de usuarios registrados en el centro de servicios especificado.
    ''' </summary>
    ''' <returns>Listado general de usuarios</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaGeneralUsuarios() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaUsuarios As List(Of DataListaGeneralUsuarios) = New List(Of DataListaGeneralUsuarios)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT USR.IdUsuario, "
                strSQLSelect &= "              USR.Foto, "
                strSQLSelect &= "              USR.Nombres, "
                strSQLSelect &= "              USR.Apellidos, "
                strSQLSelect &= "              Rol.Nombre AS Rol, "
                strSQLSelect &= "              USR.FechaRegistro "
                strSQLSelect &= "   FROM Usuario AS USR INNER JOIN Rol ON USR.IdRol = Rol.IdRol "
                strSQLSelect &= "WHERE (USR.IdCentroServicio LIKE @IdCentroServicio)"
                strSQLSelect &= "ORDER BY USR.Nombres, USR.Apellidos"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    'Diligencia parámetros
                    Dim prmIDCentroServicio As New SqlParameter("@IdCentroServicio", SqlDbType.TinyInt)
                    prmIDCentroServicio.Value = idCentroServicio
                    cmd.Parameters.Add(prmIDCentroServicio)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim usuario As New DataListaGeneralUsuarios

                                usuario.IdCentroServicio = idCentroServicio
                                usuario.IdUsuario = sdr("IdUsuario").ToString()
                                If Not sdr.IsDBNull(sdr.GetOrdinal("Foto")) AndAlso sdr("Foto").ToString <> "" Then
                                    'dataUsuario.Foto = String.Format(Server.MapPath("~/Files/CentroServicio{0}/Usuarios/{1}"), idCentroServicio, sdr("Foto").ToString())
                                    usuario.Foto = String.Format("/Files/CentroServicio{0}/Usuarios/{1}", idCentroServicio, sdr("Foto").ToString())
                                    usuario.ConFoto = True.ToString().ToLower()
                                    usuario.NombreArchivoFotoServidor = sdr("Foto").ToString()
                                Else
                                    usuario.Foto = "/images/Silueta.png"
                                    usuario.ConFoto = False.ToString().ToLower()
                                    usuario.NombreArchivoFotoServidor = String.Empty
                                End If
                                usuario.Nombres = sdr("Nombres").ToString()
                                usuario.Apellidos = sdr("Apellidos").ToString()
                                usuario.Rol = sdr("Rol").ToString()
                                usuario.FechaRegistro = sdr("FechaRegistro").ToString()

                                listaUsuarios.Add(usuario)
                            End While
                            respuesta.Resultado = listaUsuarios
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay usuarios registrados para este centro de servicios"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar usuarios para este centro de servicios</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de países del mundo según el centro de servicios especificado
    ''' </summary>
    ''' <returns>Lista de países del mundo</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaPaises() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT  @ValorDefault = IdPais FROM Pais WHERE (ValorDefault = 1);"
                strSQLSelect &= "SELECT IdPais AS ID, Nombre "
                strSQLSelect &= "FROM  Pais "
                strSQLSelect &= "ORDER BY Nombre"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmValorDefault As New SqlParameter("@ValorDefault", SqlDbType.NVarChar, -1)
                    prmValorDefault.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmValorDefault)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Nombre").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay países disponibles"
                        End If
                    End Using 'sdr

                    'Recupera el valor por defecto estableciod para la lista de datos.
                    If Not IsDBNull(cmd.Parameters("@ValorDefault").Value) Then
                        respuesta.ValorDefault = cmd.Parameters("@ValorDefault").Value
                    End If
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de países</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de modalidades para desarrollo de proyectos.
    ''' </summary>
    ''' <returns>Lista de modalidades para desarrollo de proyectos</returns>
    ''' <remarks>Copyright JULC Mayo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaModalidades() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdModalidad AS ID, Descripcion "
                strSQLSelect &= "FROM  Modalidad "
                strSQLSelect &= "ORDER BY Descripcion"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Descripcion").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay información de modalidades para desarrollo de proyectos."
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de  modalidades para desarrollo de proyectos</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Retorna unobjeto DatatTable con la lista de participantes matriculados en el proyecto especificado.
    ''' </summary>
    ''' <param name="idProyecto">Identificador de proyecto</param>
    ''' <returns>Lista de participantes matriculados en el proyecto</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaParticipantesProyecto(idProyecto As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaParticipantes As List(Of DataUsuarioParticipante) = New List(Of DataUsuarioParticipante)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT PPY.IdParticipanteProyecto AS ID, "
                strSQLSelect &= "             USR.Foto, "
                strSQLSelect &= "             CONCAT(USR.Nombres, ' ', USR.Apellidos) AS Nombre, "
                strSQLSelect &= "             Rol.Nombre AS Rol, USR.Celular "
                strSQLSelect &= "FROM  ParticipanteProyecto AS PPY INNER JOIN Usuario AS USR "
                strSQLSelect &= "      ON PPY.IdUsuario = USR.IdUsuario INNER JOIN Rol "
                strSQLSelect &= "      ON PPY.IdRol = Rol.IdRol "
                strSQLSelect &= "WHERE (PPY.IdProyecto = @IdProyecto) "
                strSQLSelect &= "ORDER BY Nombre"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    'Diligencia parámetros
                    Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                    prmIDProyecto.Value = idProyecto
                    cmd.Parameters.Add(prmIDProyecto)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim participante As New DataUsuarioParticipante

                                participante.IdParticipante = sdr("ID").ToString()
                                If Not sdr.IsDBNull(sdr.GetOrdinal("Foto")) AndAlso sdr("Foto").ToString <> "" Then
                                    'dataUsuario.Foto = String.Format(Server.MapPath("~/Files/CentroServicio{0}/Usuarios/{1}"), idCentroServicio, sdr("Foto").ToString())
                                    participante.Foto = String.Format("/Files/CentroServicio{0}/Usuarios/{1}", idCentroServicio, sdr("Foto").ToString())
                                Else
                                    participante.Foto = "/images/Silueta.png"
                                End If
                                participante.Nombre = sdr("Nombre").ToString()
                                participante.Rol = sdr("Rol").ToString()
                                participante.Telefono = sdr("Celular").ToString()

                                listaParticipantes.Add(participante)
                            End While
                            respuesta.Resultado = listaParticipantes
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = 1
                            respuesta.Mensaje = "No hay participantes vinculados al proyecto especificado."
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de participantes vinculados al proyecto especificado.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve la lista de programas académicos.
    ''' </summary>
    ''' <returns>Lista de programas académicos</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaProgramasAcademicos(estado As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdPrograma AS ID, Nombre "
                strSQLSelect &= "   FROM ProgramaAcademico "
                Select Case estado
                    Case "activo"
                        strSQLSelect &= "WHERE (Activo = 1) "
                    Case "no-activo"
                        strSQLSelect &= "WHERE (Activo = 0) "
                    Case "todos"
                End Select
                strSQLSelect &= "ORDER BY Nombre "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Nombre").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay programas académicos disponibles"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de programas académicos</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de programas académicos sugeridos de acuerdo a la cadena de consulta especificada.
    ''' </summary>
    ''' <returns>Lista de programas académicos</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaProgramasAcademicosSugeridos(stringQuery As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of String) = New List(Of String)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdPrograma AS ID, Nombre "
                strSQLSelect &= "   FROM ProgramaAcademico "
                strSQLSelect &= "WHERE (Nombre Like '%" & stringQuery & "%') "
                strSQLSelect &= "ORDER BY Nombre "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                listaItems.Add(sdr("Nombre").ToString())
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay programas académicos disponibles"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de programas académicos</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Retorna la lista de proyectos registrados en el centro de servicios especificado.
    ''' </summary>
    ''' <returns>Lista de centros de servicios</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaProyectosCentroServicio() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaProyectos As List(Of DataListaProyecto) = New List(Of DataListaProyecto)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT PRY.IdProyecto, "
                strSQLSelect &= "             PRY.Titulo, "
                strSQLSelect &= "             EMP.RazonSocial AS Empresa, "
                strSQLSelect &= "             ETP.Descripcion AS Etapa, "
                strSQLSelect &= "             EST.Nombre AS Estado, "
                strSQLSelect &= "             PRY.FechaRegistro "
                strSQLSelect &= "  FROM Proyecto AS PRY INNER JOIN Empresa AS EMP "
                strSQLSelect &= "       ON PRY.IdEmpresa = EMP.IdEmpresa INNER JOIN Etapa AS ETP "
                strSQLSelect &= "       ON PRY.IdEtapaActual = ETP.IdEtapa INNER JOIN EstadoProyecto AS EST "
                strSQLSelect &= "       ON PRY.IdEstadoProyecto = EST.IdEstadoProyecto "
                strSQLSelect &= "WHERE (PRY.IdCentroServicio = @IdCentroServicio) "
                strSQLSelect &= "ORDER BY PRY.FechaRegistro DESC"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    'Diligencia parámetros
                    Dim prmIDCentroServicio As New SqlParameter("@IdCentroServicio", SqlDbType.TinyInt)
                    prmIDCentroServicio.Value = idCentroServicio
                    cmd.Parameters.Add(prmIDCentroServicio)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim proyecto As New DataListaProyecto

                                proyecto.IdCentroServicio = idCentroServicio
                                proyecto.IdProyecto = sdr("IdProyecto").ToString()
                                proyecto.Titulo = sdr("Titulo").ToString()
                                proyecto.Empresa = sdr("Empresa").ToString()
                                proyecto.Etapa = sdr("Etapa").ToString()
                                proyecto.Estado = sdr("Estado").ToString()
                                proyecto.FechaRegistro = sdr("FechaRegistro").ToString()

                                listaProyectos.Add(proyecto)
                            End While
                            respuesta.Resultado = listaProyectos
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay proyectos registrados para el centro de servicios actual."
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar proyectos para el centro de servicios actual</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de roles según el centro de servicios especificado
    ''' </summary>
    ''' <returns>Lista de roles según el centro de servicios especificado</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaRoles() As String
        'Crea una cadena de conexión
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdRol AS ID, Nombre "
                strSQLSelect &= "FROM  Rol "
                strSQLSelect &= "ORDER BY Nombre"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Nombre").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay roles disponibles"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de roles</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de tipos de documentos de identificación.
    ''' </summary>
    ''' <returns>Lista de tipos de documentos de identificación</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaTiposDocumento() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdTipoDocumento AS ID, Descripcion "
                strSQLSelect &= "   FROM TipoDocumento "
                strSQLSelect &= "ORDER BY Descripcion "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Descripcion").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay tipos de documentos de identificación disponibles"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de tipos de documentos de identificación</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de tipos de proyecto.
    ''' </summary>
    ''' <returns>Lista de tipos de proyecto</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaTiposProyecto() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT idTipoProyecto AS ID, Nombre "
                strSQLSelect &= "   FROM TipoProyecto "
                strSQLSelect &= "ORDER BY Nombre "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Nombre").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay tipos de proyecto disponibles"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de tipos de proyecto</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de tipos de tarea.
    ''' </summary>
    ''' <returns>Lista de tipos de tarea</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaTiposTarea() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdTipoTarea AS ID, Descripcion "
                strSQLSelect &= "   FROM TipoTarea "
                strSQLSelect &= "ORDER BY Descripcion "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemLista

                                item.Key = sdr("ID").ToString()
                                item.Value = sdr("Descripcion").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay tipos de tarea disponibles"
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de tipos de tarea</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve una lista de usuarios sugeridos.
    ''' </summary>
    ''' <returns>Lista de usuarios sugeridos</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ListaUsuariosSugeridos(search As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemSelect2) = New List(Of itemSelect2)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdUsuario, "
                strSQLSelect &= "   CONCAT(Nombres,' ', Apellidos) AS Usuario "
                strSQLSelect &= "   FROM Usuario "
                strSQLSelect &= "WHERE (Activo = 1) "
                strSQLSelect &= String.Format("      AND (CONCAT(Nombres,' ', Apellidos) LIKE '%{0}%') ", search)
                strSQLSelect &= "ORDER BY Usuario "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim item As New itemSelect2

                                item.id = sdr("IdUsuario").ToString()
                                item.text = sdr("Usuario").ToString()
                                listaItems.Add(item)
                            End While
                            respuesta.Resultado = listaItems
                            'Else 'Esto no deberá ocurrir nunca.
                            '    respuesta.Codigo = -1
                            '    respuesta.Mensaje = "No hay usuarios disponibles."
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar lista de usuarios sugeridos.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Inicializa la página del Administrador de slides del carrousel de la página principal del sitio.
    ''' </summary>
    ''' <param name="dataLogin">Objeto que contiene información sobre las credenciales del usuario</param>
    ''' <returns>Cadena HTML con el menú HTML personalizado</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ValidarCredenciales(dataLogin As DataLogin) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty
                Dim strSubquery As String = String.Empty

                strSubquery = "SELECT CONCAT(Nombre1, ' ', Apellido1) AS Nombre "
                strSubquery &= " FROM Usuario "
                strSubquery &= "WHERE IdUsuario =  Login.IdUsuario "

                strSQLSelect = String.Format("SELECT IdLogin, IdUsuario, ({0}) AS Nombre ", strSubquery)
                strSQLSelect &= "   FROM Login "
                strSQLSelect &= "WHERE (Usuario = @Usuario) "
                strSQLSelect &= "      AND (Contrasena = @Contrasena) "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmUsuario As New SqlParameter("@Usuario", SqlDbType.NVarChar, 20)
                    prmUsuario.Value = dataLogin.ToString.Trim()
                    cmd.Parameters.Add(prmUsuario)

                    Dim prmContrasena As New SqlParameter("@Contrasena", SqlDbType.NVarChar, 20)
                    prmContrasena.Value = dataLogin.Contrasena.Trim()
                    cmd.Parameters.Add(prmContrasena)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            Dim dataRespuestaLogin As New DataRespuestaLogin

                            While sdr.Read()
                                dataRespuestaLogin.IdLogin = sdr("IdLogin").ToString()
                                dataRespuestaLogin.IdUsuario = Guid.Parse(sdr("IdUsuario").ToString())
                                dataRespuestaLogin.Nombre = sdr("Nombre").ToString()
                            End While
                            respuesta.Resultado = dataRespuestaLogin
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "Usuario o Contraseña no válidos"
                        End If

                    End Using 'sdr
                End Using 'Estudiante

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            Throw New Exception(String.Format("Error al autenticar usuario. Mensaje: {0}", ex.Message))
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Crea una empresa.
    ''' </summary>
    ''' <param name="dataEmpresa">Objeto que contiene información sobre la empresa actual</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function CrearEmpresa(dataEmpresa As DataEmpresa) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLInsert As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLInsert = "IF NOT EXISTS(SELECT TOP 1 NIT FROM Empresa WHERE (NIT = @NIT)) "
                strSQLInsert &= "   BEGIN "
                strSQLInsert &= "        INSERT INTO Empresa ("
                'strSQLInsert &= "                        IdEmpresa, "
                strSQLInsert &= "                         RazonSocial, "
                strSQLInsert &= "                         NIT, "
                'strSQLInsert &= "                        Logo, "
                strSQLInsert &= "                         RepresentanteLegal, "
                strSQLInsert &= "                         Email, "
                strSQLInsert &= "                         Celular1, "
                strSQLInsert &= "                         Celular2, "
                strSQLInsert &= "                         Telefono1, "
                strSQLInsert &= "                         Telefono2, "
                strSQLInsert &= "                         IdPais, "
                strSQLInsert &= "                         IdDepartamento, "
                strSQLInsert &= "                         IdCiudad, "
                strSQLInsert &= "                         OtraCIudad, "
                strSQLInsert &= "                         Direccion, "
                strSQLInsert &= "                         IdUsuario, "
                strSQLInsert &= "                         IdRol, "
                strSQLInsert &= "                         FechaRegistro, "
                strSQLInsert &= "                         FechaActualizacion) "
                strSQLInsert &= "        VALUES ("
                'strSQLInsert &= "                        @IdEmpresa, "
                strSQLInsert &= "                         @RazonSocial, "
                strSQLInsert &= "                         @NIT, "
                'strSQLInsert &= "                        @Logo, "
                strSQLInsert &= "                         @RepresentanteLegal, "
                strSQLInsert &= "                         @Email, "
                strSQLInsert &= "                         @Celular1, "
                strSQLInsert &= "                         @Celular2, "
                strSQLInsert &= "                         @Telefono1, "
                strSQLInsert &= "                         @Telefono2, "
                strSQLInsert &= "                         @IdPais, "
                strSQLInsert &= "                         @IdDepartamento, "
                strSQLInsert &= "                         @IdCiudad, "
                strSQLInsert &= "                         @OtraCIudad, "
                strSQLInsert &= "                         @Direccion, "
                strSQLInsert &= "                         @IdUsuario, "
                strSQLInsert &= "                         @IdRol, "
                strSQLInsert &= "                         GetDate(), "
                strSQLInsert &= "                         GetDate()); "
                strSQLInsert &= "         SET @IDEmpresa = SCOPE_IDENTITY(); "
                strSQLInsert &= "         SET @NIT_Existe = 0; "
                strSQLInsert &= "    END "
                strSQLInsert &= "ELSE "
                strSQLInsert &= "    BEGIN "
                strSQLInsert &= "         SET @IDEmpresa = 0x0; "
                strSQLInsert &= "         SET @NIT_Existe = 1; "
                strSQLInsert &= "    END "

                'Diligencia parámetros
                Dim prmRazonSocial As New SqlParameter("@RazonSocial", SqlDbType.NVarChar, 50)
                prmRazonSocial.Value = dataEmpresa.RazonSocial.Trim()
                cmd.Parameters.Add(prmRazonSocial)

                Dim prmNIT As New SqlParameter("@NIT", SqlDbType.NVarChar, 12)
                prmNIT.Value = dataEmpresa.NIT.Trim()
                cmd.Parameters.Add(prmNIT)

                Dim prmRepresentanteLegal As New SqlParameter("@RepresentanteLegal", SqlDbType.NVarChar, 30)
                prmRepresentanteLegal.Value = dataEmpresa.RepresentanteLegal.Trim()
                cmd.Parameters.Add(prmRepresentanteLegal)

                Dim prmEmail As New SqlParameter("@Email", SqlDbType.NVarChar, 50)
                prmEmail.Value = dataEmpresa.Email.Trim()
                cmd.Parameters.Add(prmEmail)

                Dim prmCelular1 As New SqlParameter("@Celular1", SqlDbType.NVarChar, 15)
                prmCelular1.Value = dataEmpresa.Celular1.Trim()
                cmd.Parameters.Add(prmCelular1)

                Dim prmCelular2 As New SqlParameter("@Celular2", SqlDbType.NVarChar, 15)
                If Not String.IsNullOrEmpty(dataEmpresa.Celular2.Trim()) Then
                    prmCelular2.Value = dataEmpresa.Celular2.Trim()
                Else
                    prmCelular2.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmCelular2)

                Dim prmTelefono1 As New SqlParameter("@Telefono1", SqlDbType.NVarChar, 15)
                If Not String.IsNullOrEmpty(dataEmpresa.Telefono1.Trim()) Then
                    prmTelefono1.Value = dataEmpresa.Telefono1.Trim()
                Else
                    prmTelefono1.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmTelefono1)

                Dim prmTelefono2 As New SqlParameter("@Telefono2", SqlDbType.NVarChar, 15)
                If Not String.IsNullOrEmpty(dataEmpresa.Telefono2.Trim()) Then
                    prmTelefono2.Value = dataEmpresa.Telefono2.Trim()
                Else
                    prmTelefono2.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmTelefono2)

                Dim prmIDPais As New SqlParameter("@IdPais", SqlDbType.TinyInt)
                prmIDPais.Value = dataEmpresa.IdPais
                cmd.Parameters.Add(prmIDPais)

                Dim prmIDDepartamento As New SqlParameter("@IdDepartamento", SqlDbType.NVarChar, 2)
                prmIDDepartamento.Value = dataEmpresa.IdDepartamento
                cmd.Parameters.Add(prmIDDepartamento)

                Dim prmIDCiudad As New SqlParameter("@IdCiudad", SqlDbType.NVarChar, 5)

                If Not IsNothing(dataEmpresa.IdCiudad) AndAlso Not String.IsNullOrEmpty(dataEmpresa.IdCiudad.Trim()) Then
                    prmIDCiudad.Value = dataEmpresa.IdCiudad.Trim()
                Else
                    prmIDCiudad.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmIDCiudad)

                Dim prmOtraCIudad As New SqlParameter("@OtraCIudad", SqlDbType.NVarChar, 30)
                If Not String.IsNullOrEmpty(dataEmpresa.OtraCIudad.Trim()) Then
                    prmOtraCIudad.Value = dataEmpresa.OtraCIudad.Trim()
                Else
                    prmOtraCIudad.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmOtraCIudad)

                Dim prmDireccion As New SqlParameter("@Direccion", SqlDbType.NVarChar, 100)
                prmDireccion.Value = dataEmpresa.Direccion.Trim()
                cmd.Parameters.Add(prmDireccion)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = Guid.Parse(HttpContext.Current.Session("IDUsuario").ToString())
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.TinyInt)
                prmIDRol.Value = HttpContext.Current.Session("IDRol")
                cmd.Parameters.Add(prmIDRol)

                'Parametros de salida
                Dim prmIDEmpresa As New SqlParameter("@IDEmpresa", SqlDbType.Int)
                prmIDEmpresa.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmIDEmpresa)

                Dim prmNIT_Existe As New SqlParameter("@NIT_Existe", SqlDbType.Bit)
                prmNIT_Existe.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmNIT_Existe)

                cmd.CommandText = strSQLInsert
                cmd.ExecuteNonQuery()

                Dim idNuevaEmpresa As Integer = cmd.Parameters("@IDEmpresa").Value
                Dim nitExiste As Boolean = Boolean.Parse(cmd.Parameters("@NIT_Existe").Value)

                If nitExiste Then
                    respuesta.Codigo = "-1"
                    respuesta.Mensaje = "El NIT <b>" + dataEmpresa.NIT.Trim() + "</b> ya se encuentra registrado  en el sistema. Por favor verifique e inténtelo de nuevo."
                    transaction.Rollback()
                Else
                    respuesta.Resultado = idNuevaEmpresa 'Id de la empresa registrada.
                    transaction.Commit()
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al crear empresa. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Crea un registro de entregable de proyecto.
    ''' </summary>
    ''' <param name="dataEntregableProyecto">Objeto que contiene información actualizada de un entregable de proyecto</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function CrearEntregableProyecto(dataEntregableProyecto As DataEntregableProyecto) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLInsert As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLInsert = "INSERT INTO EntregableProyecto ("
                'strSQLInsert &= "IdEntregableProyecto, "
                strSQLInsert &= "IdProyecto, "
                strSQLInsert &= "IdEtapa, "
                strSQLInsert &= "Descripcion, "
                strSQLInsert &= "RutaArchivo, "
                strSQLInsert &= "IdUsuario, "
                strSQLInsert &= "IdRol, "
                Select Case Session("RolUsuario")
                    Case "Coordinador"
                        strSQLInsert &= "FeedBackCoordinador, "
                        strSQLInsert &= "FechaFeedBackCoordinador, "
                    Case "Docente"
                        strSQLInsert &= "FeedBackDocente, "
                        strSQLInsert &= "FechaFeedBackDocente, "
                End Select
                strSQLInsert &= "FechaRegistro, "
                strSQLInsert &= "FechaActualizacion) "

                strSQLInsert &= "VALUES ("
                'strSQLInsert &= "@IdEntregableProyecto, "
                strSQLInsert &= "@IdProyecto, "
                strSQLInsert &= "@IdEtapa, "
                strSQLInsert &= "@Descripcion, "
                strSQLInsert &= "@RutaArchivo, "
                strSQLInsert &= "@IdUsuario, "
                strSQLInsert &= "@IdRol, "
                Select Case Session("RolUsuario")
                    Case "Coordinador"
                        strSQLInsert &= "@FeedBackCoordinador, "
                        strSQLInsert &= "@FechaFeedBackCoordinador, "
                    Case "Docente"
                        strSQLInsert &= "@FeedBackDocente, "
                        strSQLInsert &= "@FechaFeedBackDocente, "
                End Select
                strSQLInsert &= "GetDate(), "
                strSQLInsert &= "GetDate()) "

                'Diligencia parámetros
                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = dataEntregableProyecto.IdProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Dim prmIDEtapa As New SqlParameter("@IdEtapa", SqlDbType.TinyInt)
                prmIDEtapa.Value = dataEntregableProyecto.IdEtapa
                cmd.Parameters.Add(prmIDEtapa)

                Dim prmDescripcion As New SqlParameter("@Descripcion", SqlDbType.NVarChar, 1000)
                prmDescripcion.Value = dataEntregableProyecto.Descripcion.Trim()
                cmd.Parameters.Add(prmDescripcion)

                Dim prmRutaArchivo As New SqlParameter("@RutaArchivo", SqlDbType.NVarChar, 1000)
                prmRutaArchivo.Value = dataEntregableProyecto.RutaArchivo.Trim()
                cmd.Parameters.Add(prmRutaArchivo)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = dataEntregableProyecto.IdUsuario
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.TinyInt)
                prmIDRol.Value = dataEntregableProyecto.IdRol
                cmd.Parameters.Add(prmIDRol)

                Select Case Session("RolUsuario")
                    Case "Coordinador"
                        Dim prmFeedBackCoordinador As New SqlParameter("@FeedBackCoordinador", SqlDbType.NVarChar, -1)
                        Dim prmFechaFeedBackCoordinador As New SqlParameter("@FechaFeedBackCoordinador", SqlDbType.DateTime)
                        If Not String.IsNullOrEmpty(dataEntregableProyecto.FeedBackCoordinador.Trim()) Then
                            prmFeedBackCoordinador.Value = dataEntregableProyecto.FeedBackCoordinador.Trim()
                            prmFechaFeedBackCoordinador.Value = Date.Now()
                        Else
                            prmFeedBackCoordinador.Value = DBNull.Value
                            prmFechaFeedBackCoordinador.Value = DBNull.Value
                        End If
                        cmd.Parameters.Add(prmFeedBackCoordinador)
                        cmd.Parameters.Add(prmFechaFeedBackCoordinador)
                    Case "Docente"
                        Dim prmFeedBackDocente As New SqlParameter("@FeedBackDocente", SqlDbType.NVarChar, -1)
                        Dim prmFechaFeedBackDocente As New SqlParameter("@FechaFeedBackDocente", SqlDbType.DateTime)
                        If Not String.IsNullOrEmpty(dataEntregableProyecto.FeedBackDocente.Trim()) Then
                            prmFeedBackDocente.Value = dataEntregableProyecto.FeedBackDocente.Trim()
                            prmFechaFeedBackDocente.Value = Date.Now()
                        Else
                            prmFeedBackDocente.Value = DBNull.Value
                            prmFechaFeedBackDocente.Value = DBNull.Value
                        End If
                        cmd.Parameters.Add(prmFeedBackDocente)
                        cmd.Parameters.Add(prmFechaFeedBackDocente)
                End Select

                cmd.CommandText = strSQLInsert
                cmd.ExecuteNonQuery()

                transaction.Commit()

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al crear entregable de proyecto. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Crea un inicio de sesión (login) y un registro vacío en la tabla usuario.
    ''' </summary>
    ''' <param name="dataLogin">Objeto que contiene información sobre las credenciales del usuario</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function CrearLogin(dataLogin As DataLogin) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLInsert As String = String.Empty
                Dim strSQLSelect As String = String.Empty
                Dim registrosAfectados As Integer = -1

                'Primero comprueba si el usuario del nuevo login no se encuentre registrado en el sistema.
                strSQLSelect = String.Format("SELECT  Usuario  FROM Login WHERE (Usuario = N'{0}')", dataLogin.Usuario)

                strSQLInsert = String.Format("IF NOT EXISTS({0}) ", strSQLSelect)
                strSQLInsert &= "BEGIN "
                strSQLInsert &= "  SET @IDUsuario = NEWID(); "
                strSQLInsert &= "  INSERT INTO Login "
                strSQLInsert &= "                 (Usuario, Contrasena, DebeCambiar) "
                strSQLInsert &= "  VALUES (@IDUsuario, @Contrasena, @DebeCambiar);"
                strSQLInsert &= "  INSERT INTO Usuario ( "
                strSQLInsert &= "                IdCentroServicio, "
                strSQLInsert &= "                IdUsuario "
                strSQLInsert &= "  VALUES ("
                strSQLInsert &= "                  @IDCentroServicio, "
                strSQLInsert &= "                  @IDUsuario) ;"
                strSQLInsert &= "  SET @UsuarioExiste = 0; "
                strSQLInsert &= "END "
                strSQLInsert &= "ELSE "
                strSQLInsert &= "BEGIN "
                strSQLInsert &= "   SET @IDUsuario = 0x0; "
                strSQLInsert &= "   SET @UsuarioExiste = 1; "
                strSQLInsert &= "END "

                Dim prmUsuario As New SqlParameter("@Usuario", SqlDbType.NVarChar, 50)
                prmUsuario.Value = dataLogin.Usuario.Trim()
                cmd.Parameters.Add(prmUsuario)

                Dim prmContrasena As New SqlParameter("@Contrasena", SqlDbType.NVarChar, 20)
                prmContrasena.Value = dataLogin.Contrasena.Trim()
                cmd.Parameters.Add(prmContrasena)

                Dim prmDebeCambiar As New SqlParameter("@DebeCambiar", SqlDbType.Bit)
                prmDebeCambiar.Value = Boolean.Parse(dataLogin.DebeCambiar)
                cmd.Parameters.Add(prmDebeCambiar)

                Dim prmIDUsuario As New SqlParameter("@IDUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmUsuarioExiste As New SqlParameter("@UsuarioExiste", SqlDbType.Bit)
                prmUsuarioExiste.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmUsuarioExiste)

                cmd.CommandText = strSQLInsert
                cmd.ExecuteNonQuery()

                Dim idUsuario As Guid = cmd.Parameters("@IDUsuario").Value
                Dim usuarioExiste As Boolean = Boolean.Parse(cmd.Parameters("@UsuarioExiste").Value)

                transaction.Commit()

                If usuarioExiste Then
                    respuesta.Codigo = "-1"
                    respuesta.Mensaje = "Ya tú usuario se encuentra registrado, ten en cuenta que un usuario no se puede crear por segunda vez."
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Agrega un mensaje al chat.
    ''' </summary>
    ''' <param name="dataMensajeChat">Objeto que contiene información sobre el mensaje del chat</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function CrearMensajeChat(dataMensajeChat As DataMensajeChat) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLInsert As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLInsert = "INSERT INTO ChatMensaje ("
                'strSQLInsert &= "IdMensaje, "
                strSQLInsert &= "IdCentroServicio, "
                strSQLInsert &= "IdProyecto, "
                strSQLInsert &= "IdUsuarioEmisor, "
                ' strSQLInsert &= "IdUsuarioReceptor, "
                strSQLInsert &= "Mensaje, "
                strSQLInsert &= "FechaMensaje) "
                strSQLInsert &= "VALUES ("
                'strSQLInsert &= "@IdMensaje, "
                strSQLInsert &= "@IdCentroServicio, "
                strSQLInsert &= "@IdProyecto, "
                strSQLInsert &= "@IdUsuarioEmisor, "
                'strSQLInsert &= "@IdUsuarioReceptor, "
                strSQLInsert &= "@Mensaje, "
                strSQLInsert &= "GETDATE()) "

                'Diligencia parámetros
                Dim prmIDCentroServiciol As New SqlParameter("@IdCentroServicio", SqlDbType.TinyInt)
                prmIDCentroServiciol.Value = dataMensajeChat.IdCentroServicio
                cmd.Parameters.Add(prmIDCentroServiciol)

                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = dataMensajeChat.IdProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Dim prmIDUsuarioEmisor As New SqlParameter("@IdUsuarioEmisor", SqlDbType.UniqueIdentifier)
                prmIDUsuarioEmisor.Value = dataMensajeChat.IdUsuarioEmisor
                cmd.Parameters.Add(prmIDUsuarioEmisor)

                Dim prmIDUsuarioReceptor As New SqlParameter("@IdUsuarioReceptor", SqlDbType.UniqueIdentifier)
                prmIDUsuarioReceptor.Value = dataMensajeChat.IdUsuarioReceptor
                cmd.Parameters.Add(prmIDUsuarioReceptor)

                Dim prmMensaje As New SqlParameter("@Mensaje", SqlDbType.NVarChar, -1)
                prmMensaje.Value = dataMensajeChat.Mensaje
                cmd.Parameters.Add(prmMensaje)

                cmd.CommandText = strSQLInsert
                cmd.ExecuteNonQuery()

                transaction.Commit()

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al crear mensaje de chat. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Crea un registro de objetivo del proyecto especificado
    ''' </summary>
    ''' <param name="dataObjetivoProyecto">Objeto que contiene información sobre la tel objetivo dal proyecto especificado.</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function CrearObjetivoProyecto(dataObjetivoProyecto As DataObjetivoProyecto) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLInsert As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLInsert = "INSERT INTO ObjetivoProyecto ("
                'strSQLInsert &= "IdObjetivoProyecto, "
                strSQLInsert &= "IdProyecto, "
                strSQLInsert &= "Objetivo, "
                strSQLInsert &= "IdUsuario, "
                strSQLInsert &= "IdRol, "
                strSQLInsert &= "FechaRegistro, "
                strSQLInsert &= "FechaActualizacion) "
                strSQLInsert &= "VALUES ("
                'strSQLInsert &= "@IdObjetivoProyecto, "
                strSQLInsert &= "@IdProyecto, "
                strSQLInsert &= "@Objetivo, "
                strSQLInsert &= "@IdUsuario, "
                strSQLInsert &= "@IdRol, "
                strSQLInsert &= "GETDATE(), "
                strSQLInsert &= "GETDATE()) "

                'Diligencia parámetros
                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = dataObjetivoProyecto.IdProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Dim prmObjetivo As New SqlParameter("@Objetivo", SqlDbType.TinyInt)
                prmObjetivo.Value = dataObjetivoProyecto.Objetivo
                cmd.Parameters.Add(prmObjetivo)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = dataObjetivoProyecto.IdUsuario
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.SmallInt)
                prmIDRol.Value = dataObjetivoProyecto.IdRol
                cmd.Parameters.Add(prmIDRol)

                cmd.CommandText = strSQLInsert
                cmd.ExecuteNonQuery()

                transaction.Commit()

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al crear objetivo del proyecto. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Crea una programa académico.
    ''' </summary>
    ''' <param name="dataProgramaAcademico">Objeto que contiene información sobre el programa académico</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function CrearProgramaAcademico(dataProgramaAcademico As DataProgramaAcademico) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLInsert As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLInsert = "IF NOT EXISTS(SELECT Nombre FROM  ProgramaAcademico WHERE (Nombre = @Nombre)) "
                strSQLInsert &= "BEGIN "
                strSQLInsert &= "    INSERT INTO ProgramaAcademico ("
                'strSQLInsert &= "                 IdPrograma, "
                strSQLInsert &= "                 Nombre, "
                strSQLInsert &= "                 Activo, "
                strSQLInsert &= "                 IdUsuario, "
                strSQLInsert &= "                 IdRol, "
                strSQLInsert &= "                 FechaRegistro) "
                strSQLInsert &= "    VALUES ("
                'strSQLInsert &= "                 @IdPrograma, "
                strSQLInsert &= "                 @Nombre, "
                strSQLInsert &= "                 @Activo, "
                strSQLInsert &= "                 @IdUsuario, "
                strSQLInsert &= "                 @IdRol, "
                strSQLInsert &= "                 GETDATE()); "
                strSQLInsert &= "    SET @CodeError = 0; "
                strSQLInsert &= "    SET @MessageError = 'Programa académico creado éxitosamente.'; "
                strSQLInsert &= "END "
                strSQLInsert &= "ELSE "
                strSQLInsert &= "BEGIN"
                strSQLInsert &= "    SET @CodeError = -1; "
                strSQLInsert &= String.Format("		SET @MessageError = 'El programa académico {0} ya existe.'; ", dataProgramaAcademico.Nombre.Trim())
                strSQLInsert &= "END"

                'Diligencia parámetros
                Dim prmNombre As New SqlParameter("@Nombre", SqlDbType.NVarChar, 50)
                prmNombre.Value = dataProgramaAcademico.Nombre.Trim()
                cmd.Parameters.Add(prmNombre)

                Dim prmActivo As New SqlParameter("@Activo", SqlDbType.Bit)
                prmActivo.Value = Boolean.Parse(dataProgramaAcademico.Activo)
                cmd.Parameters.Add(prmActivo)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = dataProgramaAcademico.IdUsuario
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.SmallInt)
                prmIDRol.Value = dataProgramaAcademico.IdRol
                cmd.Parameters.Add(prmIDRol)

                cmd.CommandText = strSQLInsert
                cmd.ExecuteNonQuery()

                transaction.Commit()

                If cmd.Parameters("@CodeError").Value > 0 Then
                    respuesta.Codigo = -1
                    respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al crear programa académico. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Crea un registro de datos para un proyecto.
    ''' </summary>
    ''' <param name="DataProyecto">Objeto que contiene información sobre el proyecto actual</param>
    ''' <returns>Cadena con información del estado final de la operación</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function CrearProyecto(dataProyecto As DataProyecto) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLInsert As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLInsert = "INSERT INTO Proyecto ("
                strSQLInsert &= "IdCentroServicio, "
                'strSQLInsert &= "IdProyecto, "
                strSQLInsert &= "IdTipoProyecto, "
                strSQLInsert &= "Titulo, "
                strSQLInsert &= "Descripcion, "
                strSQLInsert &= "Alcance, "
                strSQLInsert &= "ObjetivoMinimo, "
                strSQLInsert &= "IdEmpresa, "
                strSQLInsert &= "IdModalidad, "
                strSQLInsert &= "ProgramaAcademico, "
                strSQLInsert &= "AsignaturaAcademica, "
                strSQLInsert &= "IdEtapaActual, "
                strSQLInsert &= "IdEstadoProyecto, "
                strSQLInsert &= "IdUsuario, "
                strSQLInsert &= "IdRol, "
                strSQLInsert &= "FechaRegistro, "
                strSQLInsert &= "FechaActualizacion) "
                strSQLInsert &= "VALUES ("
                strSQLInsert &= "@IdCentroServicio, "
                'strSQLInsert &= "@IdProyecto, "
                strSQLInsert &= "@IdTipoProyecto, "
                strSQLInsert &= "@Titulo, "
                strSQLInsert &= "@Descripcion, "
                strSQLInsert &= "@Alcance, "
                strSQLInsert &= "@ObjetivoMinimo, "
                strSQLInsert &= "@IdEmpresa, "
                strSQLInsert &= "@IdModalidad, "
                strSQLInsert &= "@ProgramaAcademico, "
                strSQLInsert &= "@AsignaturaAcademica, "
                strSQLInsert &= "1, "
                strSQLInsert &= "1, "
                strSQLInsert &= "@IdUsuario, "
                strSQLInsert &= "@IdRol, "
                strSQLInsert &= "GETDATE(), "
                strSQLInsert &= "GETDATE()); "
                strSQLInsert &= "SELECT SCOPE_IDENTITY()"

                'Diligencia parámetros
                Dim prmIDCentroServiciol As New SqlParameter("@IdCentroServicio", SqlDbType.TinyInt)
                prmIDCentroServiciol.Value = HttpContext.Current.Session("IDCentroServicio")
                cmd.Parameters.Add(prmIDCentroServiciol)

                'Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                'prmIDProyecto.Value = dataProyecto.IdProyecto
                'cmd.Parameters.Add(prmIDProyecto)

                Dim prmIDTipoProyecto As New SqlParameter("@IdTipoProyecto", SqlDbType.TinyInt)
                prmIDTipoProyecto.Value = dataProyecto.IdTipoProyecto
                cmd.Parameters.Add(prmIDTipoProyecto)

                Dim prmTitulo As New SqlParameter("@Titulo", SqlDbType.NVarChar, 150)
                prmTitulo.Value = dataProyecto.Titulo.Trim()
                cmd.Parameters.Add(prmTitulo)

                Dim prmDescripcion As New SqlParameter("@Descripcion", SqlDbType.NVarChar, -1)
                If Not String.IsNullOrEmpty(dataProyecto.Descripcion.Trim()) Then
                    prmDescripcion.Value = dataProyecto.Descripcion.Trim()
                Else
                    prmDescripcion.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmDescripcion)

                Dim prmAlcance As New SqlParameter("@Alcance", SqlDbType.NVarChar, -1)
                If Not String.IsNullOrEmpty(dataProyecto.Alcance.Trim()) Then
                    prmAlcance.Value = dataProyecto.Alcance.Trim()
                Else
                    prmAlcance.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmAlcance)

                Dim prmObjetivoMinimo As New SqlParameter("@ObjetivoMinimo", SqlDbType.NVarChar, -1)
                If Not String.IsNullOrEmpty(dataProyecto.ObjetivoMinimo.Trim()) Then
                    prmObjetivoMinimo.Value = dataProyecto.ObjetivoMinimo.Trim()
                Else
                    prmObjetivoMinimo.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmObjetivoMinimo)

                Dim prmIDEmpresa As New SqlParameter("@IdEmpresa", SqlDbType.Int)
                prmIDEmpresa.Value = dataProyecto.IdEmpresa
                cmd.Parameters.Add(prmIDEmpresa)

                Dim prmIDModalidad As New SqlParameter("@IdModalidad", SqlDbType.TinyInt)
                prmIDModalidad.Value = dataProyecto.IdModalidad
                cmd.Parameters.Add(prmIDModalidad)

                Dim prmProgramaAcademico As New SqlParameter("@ProgramaAcademico", SqlDbType.NVarChar, 50)
                prmProgramaAcademico.Value = dataProyecto.ProgramaAcademico.Trim()
                cmd.Parameters.Add(prmProgramaAcademico)

                Dim prmAsignaturaAcademica As New SqlParameter("@AsignaturaAcademica", SqlDbType.NVarChar, 50)
                prmAsignaturaAcademica.Value = dataProyecto.AsignaturaAcademica.Trim()
                cmd.Parameters.Add(prmAsignaturaAcademica)

                'Dim prmIDEtapaActual As New SqlParameter("@IdEtapaActual", SqlDbType.TinyInt)
                'prmIDEtapaActual.Value = dataProyecto.IdEtapaActual
                'cmd.Parameters.Add(prmIDEtapaActual)

                'Dim prmIDEstadoProyecto As New SqlParameter("@IdEstadoProyecto", SqlDbType.TinyInt)
                'prmIDEstadoProyecto.Value = dataProyecto.IdEstadoProyecto
                'cmd.Parameters.Add(prmIDEstadoProyecto)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = Guid.Parse(HttpContext.Current.Session("IDUsuario").ToString())
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.TinyInt)
                prmIDRol.Value = HttpContext.Current.Session("IDRol")
                cmd.Parameters.Add(prmIDRol)

                cmd.CommandText = strSQLInsert
                Dim IdNuevoProyecto As Long = cmd.ExecuteScalar()
                respuesta.Resultado = IdNuevoProyecto

                transaction.Commit()

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al crear proyecto. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Crea una tarea para el proyecto especificado
    ''' </summary>
    ''' <param name="dataTareaProyecto">Objeto que contiene información sobre la tarea asignada al proyecto especificado.</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function CrearTareaProyecto(dataTareaProyecto As DataTareaProyecto) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLInsert As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLInsert = "INSERT INTO TareaProyecto ("
                'strSQLInsert &= "IdTareaProyecto, "
                strSQLInsert &= "IdCentroServicio, "
                strSQLInsert &= "IdProyecto, "
                strSQLInsert &= "IdTipoTarea, "
                strSQLInsert &= "Nombre, "
                strSQLInsert &= "Descripcion, "
                strSQLInsert &= "FechaInicio, "
                strSQLInsert &= "FechaFinalización, "
                strSQLInsert &= "FechaLimite, "
                strSQLInsert &= "IdResponsable, "
                strSQLInsert &= "IdEstadoTarea, "
                strSQLInsert &= "IdUsuario, "
                strSQLInsert &= "IdRol, "
                strSQLInsert &= "FechaRegistro, "
                strSQLInsert &= "FechaActualizacion) "
                strSQLInsert &= "VALUES ("
                'strSQLInsert &= "@IdTareaProyecto, "
                strSQLInsert &= "@IdCentroServicio, "
                strSQLInsert &= "@IdProyecto, "
                strSQLInsert &= "@IdTipoTarea, "
                strSQLInsert &= "@Nombre, "
                strSQLInsert &= "@Descripcion, "
                strSQLInsert &= "@FechaInicio, "
                strSQLInsert &= "@FechaFinalización, "
                strSQLInsert &= "@FechaLimite, "
                strSQLInsert &= "@IdResponsable, "
                strSQLInsert &= "@IdEstadoTarea, "
                strSQLInsert &= "@IdUsuario, "
                strSQLInsert &= "@IdRol, "
                strSQLInsert &= "GETDATE(), "
                strSQLInsert &= "GETDATE()) "

                'Diligencia parámetros
                Dim prmIDCentroServiciol As New SqlParameter("@IdCentroServicio", SqlDbType.TinyInt)
                prmIDCentroServiciol.Value = dataTareaProyecto.IdCentroServicio
                cmd.Parameters.Add(prmIDCentroServiciol)

                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = dataTareaProyecto.IdProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Dim prmIDTipoTarea As New SqlParameter("@IdTipoTarea", SqlDbType.TinyInt)
                prmIDTipoTarea.Value = dataTareaProyecto.IdTipoTarea
                cmd.Parameters.Add(prmIDTipoTarea)

                Dim prmNombre As New SqlParameter("@Nombre", SqlDbType.NVarChar, 50)
                prmNombre.Value = dataTareaProyecto.Nombre.Trim()
                cmd.Parameters.Add(prmNombre)

                Dim prmDescripcion As New SqlParameter("@Descripcion", SqlDbType.NVarChar, 50)
                prmDescripcion.Value = dataTareaProyecto.Descripcion.Trim()
                cmd.Parameters.Add(prmDescripcion)

                Dim prmFechaInicio As New SqlParameter("@FechaInicio", SqlDbType.DateTime)
                prmFechaInicio.Value = dataTareaProyecto.FechaInicio
                cmd.Parameters.Add(prmFechaInicio)

                Dim prmFechaFinalización As New SqlParameter("@FechaFinalización", SqlDbType.DateTime)
                prmFechaFinalización.Value = dataTareaProyecto.FechaFinalización
                cmd.Parameters.Add(prmFechaFinalización)

                Dim prmFechaLimite As New SqlParameter("@FechaLimite", SqlDbType.DateTime)
                prmFechaLimite.Value = dataTareaProyecto.FechaLimite
                cmd.Parameters.Add(prmFechaLimite)

                Dim prmIDResponsable As New SqlParameter("@IdResponsable", SqlDbType.BigInt)
                prmIDResponsable.Value = dataTareaProyecto.IdResponsable
                cmd.Parameters.Add(prmIDResponsable)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = dataTareaProyecto.IdUsuario
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.SmallInt)
                prmIDRol.Value = dataTareaProyecto.IdRol
                cmd.Parameters.Add(prmIDRol)

                cmd.CommandText = strSQLInsert
                cmd.ExecuteNonQuery()

                transaction.Commit()

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al crear tarea de proyecto. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Crea un usuario y un inicio de sesión (login).
    ''' </summary>
    ''' <param name="dataUsuario">Objeto que contiene información sobre el usuario actual</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function CrearUsuario(dataUsuario As DataUsuario) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLInsert As String = String.Empty
                Dim strSQLSelect As String = String.Empty
                Dim registrosAfectados As Integer = -1

                'Primero comprueba si las credenciales de acceso del nuevo usuario no se encuentre registrado en el sistema.
                strSQLSelect = "SELECT  Usuario  FROM Login WHERE (Usuario = @Usuario)"

                strSQLInsert = String.Format("IF NOT EXISTS({0}) ", strSQLSelect)
                strSQLInsert &= "BEGIN "
                strSQLInsert &= "  SET @IDUsuario = NEWID(); "
                strSQLInsert &= "  INSERT INTO Login "
                strSQLInsert &= "                 (IdCentroServicio, Usuario, Contrasena, DebeCambiar) "
                strSQLInsert &= "  VALUES (@IdCentroServicio, @Usuario, @Contrasena, @DebeCambiar);"
                strSQLInsert &= "  INSERT INTO Usuario ( "
                strSQLInsert &= "                IdCentroServicio, "
                strSQLInsert &= "                IdUsuario, "
                strSQLInsert &= "                Nombres, "
                strSQLInsert &= "                Apellidos, "
                strSQLInsert &= "                IdTipoDocumento, "
                strSQLInsert &= "                Documento, "
                strSQLInsert &= "                IdRol, "
                strSQLInsert &= "                Email, "
                strSQLInsert &= "                Celular, "
                strSQLInsert &= "                Direccion, "
                strSQLInsert &= "                IdPais, "
                strSQLInsert &= "                IdDepartamento, "
                strSQLInsert &= "                IdCiudad, "
                strSQLInsert &= "                OtraCIudad, "
                strSQLInsert &= "                Activo) "
                strSQLInsert &= "  VALUES ("
                strSQLInsert &= "                @IdCentroServicio, "
                strSQLInsert &= "                @IDUsuario, "
                strSQLInsert &= "                @Nombres, "
                strSQLInsert &= "                @Apellidos, "
                strSQLInsert &= "                @IdTipoDocumento, "
                strSQLInsert &= "                @Documento, "
                strSQLInsert &= "                @IdRol, "
                strSQLInsert &= "                @Email, "
                strSQLInsert &= "                @Celular, "
                strSQLInsert &= "                @Direccion, "
                strSQLInsert &= "                @IdPais, "
                strSQLInsert &= "                @IdDepartamento, "
                strSQLInsert &= "                @IdCiudad, "
                strSQLInsert &= "                @OtraCIudad, "
                strSQLInsert &= "                @Activo) ; "
                strSQLInsert &= "  SET @UsuarioExiste = 0; "
                strSQLInsert &= "END "
                strSQLInsert &= "ELSE "
                strSQLInsert &= "BEGIN "
                strSQLInsert &= "   SET @IDUsuario = 0x0; "
                strSQLInsert &= "   SET @UsuarioExiste = 1; "
                strSQLInsert &= "END "

                Dim prmUsuario As New SqlParameter("@Usuario", SqlDbType.NVarChar, 50)
                prmUsuario.Value = dataUsuario.Credenciales.Usuario.Trim()
                cmd.Parameters.Add(prmUsuario)

                Dim prmContrasena As New SqlParameter("@Contrasena", SqlDbType.NVarChar, 20)
                prmContrasena.Value = dataUsuario.Credenciales.Contrasena.Trim()
                cmd.Parameters.Add(prmContrasena)

                Dim prmDebeCambiar As New SqlParameter("@DebeCambiar", SqlDbType.Bit)
                prmDebeCambiar.Value = Boolean.Parse(dataUsuario.Credenciales.DebeCambiar)
                cmd.Parameters.Add(prmDebeCambiar)

                Dim prmIDUsuario As New SqlParameter("@IDUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDCentroServicio As New SqlParameter("@IdCentroServicio", SqlDbType.TinyInt)
                prmIDCentroServicio.Value = HttpContext.Current.Session("IDCentroServicio")
                cmd.Parameters.Add(prmIDCentroServicio)

                Dim prmNombres As New SqlParameter("@Nombres", SqlDbType.NVarChar, 20)
                prmNombres.Value = dataUsuario.Nombres.Trim()
                cmd.Parameters.Add(prmNombres)

                Dim prmApellidos As New SqlParameter("@Apellidos", SqlDbType.NVarChar, 20)
                prmApellidos.Value = dataUsuario.Apellidos.Trim()
                cmd.Parameters.Add(prmApellidos)

                Dim prmIDTipoDocumento As New SqlParameter("@IdTipoDocumento", SqlDbType.TinyInt)
                prmIDTipoDocumento.Value = dataUsuario.IdTipoDocumento
                cmd.Parameters.Add(prmIDTipoDocumento)

                Dim prmDocumento As New SqlParameter("@Documento", SqlDbType.NVarChar, 15)
                prmDocumento.Value = dataUsuario.Documento.Trim()
                cmd.Parameters.Add(prmDocumento)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.TinyInt)
                prmIDRol.Value = dataUsuario.IdRol
                cmd.Parameters.Add(prmIDRol)

                Dim prmEmail As New SqlParameter("@Email", SqlDbType.NVarChar, 50)
                prmEmail.Value = dataUsuario.Email.Trim()
                cmd.Parameters.Add(prmEmail)

                Dim prmCelular As New SqlParameter("@Celular", SqlDbType.NVarChar, 15)
                If Not String.IsNullOrEmpty(dataUsuario.Celular.Trim()) Then
                    prmCelular.Value = dataUsuario.Celular.Trim()
                Else
                    prmCelular.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmCelular)

                Dim prmDireccion As New SqlParameter("@Direccion", SqlDbType.NVarChar, 100)
                prmDireccion.Value = dataUsuario.Direccion.Trim()
                cmd.Parameters.Add(prmDireccion)

                'Dim prmCodigoPostal As New SqlParameter("@CodigoPostal", SqlDbType.NVarChar, 10)
                'If Not String.IsNullOrEmpty(dataUsuario.CodigoPostal.Trim()) Then
                '    prmCodigoPostal.Value = dataUsuario.CodigoPostal.Trim()
                'Else
                '    prmCodigoPostal.Value = DBNull.Value
                'End If
                'cmd.Parameters.Add(prmCodigoPostal)

                Dim prmIDPais As New SqlParameter("@IdPais", SqlDbType.TinyInt)
                prmIDPais.Value = dataUsuario.IdPais
                cmd.Parameters.Add(prmIDPais)

                Dim prmIdDepartamento As New SqlParameter("@IdDepartamento", SqlDbType.NVarChar, 2)
                prmIdDepartamento.Value = dataUsuario.IdDepartamento.Trim()
                cmd.Parameters.Add(prmIdDepartamento)

                Dim prmIDCiudad As New SqlParameter("@IdCiudad", SqlDbType.NVarChar, 5)
                'If Not String.IsNullOrEmpty(dataUsuario.IdCiudad.Trim()) Then
                If Not IsNothing(dataUsuario.IdCiudad) Then
                    prmIDCiudad.Value = dataUsuario.IdCiudad.Trim()
                Else
                    prmIDCiudad.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmIDCiudad)

                Dim prmOtraCIudad As New SqlParameter("@OtraCIudad", SqlDbType.NVarChar, 30)
                If Not String.IsNullOrEmpty(dataUsuario.OtraCIudad.Trim()) Then
                    prmOtraCIudad.Value = dataUsuario.OtraCIudad.Trim()
                Else
                    prmOtraCIudad.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmOtraCIudad)

                'Dim prmEsAnonimo As New SqlParameter("@EsAnonimo", SqlDbType.Bit)
                'prmEsAnonimo.Value = Boolean.Parse(dataUsuario.EsAnonimo)
                'cmd.Parameters.Add(prmEsAnonimo)

                'Dim prmTiempoConectado As New SqlParameter("@TiempoConectado", SqlDbType.BigInt)
                'prmTiempoConectado.Value = Boolean.Parse(dataUsuario.TiempoConectado)
                'cmd.Parameters.Add(prmTiempoConectado)

                Dim prmActivo As New SqlParameter("@Activo", SqlDbType.Bit)
                prmActivo.Value = Boolean.Parse(dataUsuario.Activo)
                cmd.Parameters.Add(prmActivo)

                Dim prmUsuarioExiste As New SqlParameter("@UsuarioExiste", SqlDbType.Bit)
                prmUsuarioExiste.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmUsuarioExiste)

                cmd.CommandText = strSQLInsert
                cmd.ExecuteNonQuery()

                Dim idUsuario As Guid = cmd.Parameters("@IDUsuario").Value
                Dim usuarioExiste As Boolean = Boolean.Parse(cmd.Parameters("@UsuarioExiste").Value)

                If usuarioExiste Then
                    respuesta.Codigo = "-1"
                    respuesta.Mensaje = "El usuario <b>" + dataUsuario.Credenciales.Usuario.Trim() + "</b> ya se encuentra en uso. Por favor inténtelo con otro usuario."
                    transaction.Rollback()
                Else
                    respuesta.Resultado = idUsuario 'Id del nuevo usuario.
                    transaction.Commit()
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve el registro de datos de la empresa especificada.
    ''' </summary>
    ''' <param name="idEmpresa">Identificador de registro de empresa</param>
    ''' <returns>Lista de departamentos ó estado</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EditarEmpresa(idEmpresa As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdEmpresa, "
                strSQLSelect &= "             RazonSocial, "
                strSQLSelect &= "             NIT, "
                strSQLSelect &= "             Logo, "
                strSQLSelect &= "             RepresentanteLegal, "
                strSQLSelect &= "             Email, "
                strSQLSelect &= "             Celular1, "
                strSQLSelect &= "             Celular2, "
                strSQLSelect &= "             Telefono1, "
                strSQLSelect &= "             Telefono2, "
                strSQLSelect &= "             IdPais, "
                strSQLSelect &= "             IdDepartamento, "
                strSQLSelect &= "             IdCiudad, "
                strSQLSelect &= "             OtraCIudad, "
                strSQLSelect &= "             Direccion, "
                strSQLSelect &= "             IdUsuario, "
                strSQLSelect &= "             IdRol, "
                strSQLSelect &= "             FechaRegistro, "
                strSQLSelect &= "             FechaActualizacion "
                strSQLSelect &= "  FROM Empresa "
                strSQLSelect &= "WHERE (IdEmpresa = @IdEmpresa)"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDEmpresa As New SqlParameter("@IdEmpresa", SqlDbType.Int)
                    prmIDEmpresa.Value = Integer.Parse(idEmpresa)
                    cmd.Parameters.Add(prmIDEmpresa)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            Dim dataEmpresa As New DataEmpresa
                            While sdr.Read()
                                dataEmpresa.IdEmpresa = sdr("IdEmpresa").ToString()
                                dataEmpresa.RazonSocial = sdr("RazonSocial").ToString()
                                dataEmpresa.NIT = sdr("NIT").ToString()
                                dataEmpresa.RepresentanteLegal = sdr("RepresentanteLegal").ToString()
                                dataEmpresa.Email = sdr("Email").ToString()
                                dataEmpresa.Celular1 = sdr("Celular1").ToString()
                                dataEmpresa.Celular2 = sdr("Celular2").ToString()
                                dataEmpresa.Telefono1 = sdr("Telefono1").ToString()
                                dataEmpresa.Telefono2 = sdr("Telefono2").ToString()
                                dataEmpresa.IdPais = sdr("IdPais").ToString()
                                dataEmpresa.IdDepartamento = sdr("IdDepartamento").ToString()
                                dataEmpresa.IdCiudad = sdr("IdCiudad").ToString()
                                dataEmpresa.OtraCIudad = sdr("OtraCIudad").ToString()
                                dataEmpresa.Direccion = sdr("Direccion").ToString()
                                dataEmpresa.FechaRegistro = sdr("FechaRegistro").ToString()
                                dataEmpresa.FechaActualizacion = sdr("FechaActualizacion").ToString()

                                If Not sdr.IsDBNull(sdr.GetOrdinal("Logo")) AndAlso sdr("Logo").ToString <> "" Then
                                    'Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")
                                    'dataEmpresa.Logo = String.Format(Server.MapPath("~/Files/CentroServicio{0}/Usuarios/{1}"), idCentroServicio, sdr("Logo").ToString())
                                    dataEmpresa.Logo = String.Format("/Files/Empresas/{0}", sdr("Logo").ToString())
                                    dataEmpresa.ConLogo = True.ToString().ToLower()
                                    dataEmpresa.NombreArchivoLogoServidor = sdr("Logo").ToString()
                                Else
                                    dataEmpresa.Logo = "/images/SiluetaLogoCompany.png"
                                    dataEmpresa.ConLogo = False.ToString().ToLower()
                                    dataEmpresa.NombreArchivoLogoServidor = String.Empty
                                End If
                            End While
                            respuesta.Resultado = dataEmpresa
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay información disponible sobre el logo empresarial especificado."
                        End If
                    End Using 'sdr

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar información sobre el logo empresarial especificado.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve el registro de datos del proyecto especificado.
    ''' </summary>
    ''' <param name="idProyecto">Identificador de proyecto</param>
    ''' <returns>Lista de departamentos ó estado</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EditarProyecto(idProyecto As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdProyecto, "
                strSQLSelect &= "IdCentroServicio, "
                strSQLSelect &= "IdTipoProyecto, "
                strSQLSelect &= "Titulo, "
                strSQLSelect &= "Descripcion, "
                strSQLSelect &= "Alcance, "
                strSQLSelect &= "ObjetivoMinimo, "
                strSQLSelect &= "IdEmpresa, "
                strSQLSelect &= "ProgramaAcademico, "
                strSQLSelect &= "AsignaturaAcademica, "
                strSQLSelect &= "IdEtapaActual, "
                strSQLSelect &= "IdEstadoProyecto, "
                strSQLSelect &= "IdUsuario, "
                strSQLSelect &= "IdRol, "
                strSQLSelect &= "FechaRegistro, "
                strSQLSelect &= "FechaActualizacion "
                strSQLSelect &= "FROM  Proyecto "
                strSQLSelect &= "WHERE (IdProyecto = @IdProyecto)"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                    prmIDProyecto.Value = idProyecto
                    cmd.Parameters.Add(prmIDProyecto)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            Dim dataProyecto As New DataProyecto
                            While sdr.Read()
                                dataProyecto.IdProyecto = sdr("IdProyecto").ToString()
                                dataProyecto.IdCentroServicio = sdr("IdCentroServicio").ToString()
                                dataProyecto.IdTipoProyecto = sdr("IdTipoProyecto").ToString()
                                dataProyecto.Titulo = sdr("Titulo").ToString()
                                dataProyecto.Descripcion = sdr("Descripcion").ToString()
                                dataProyecto.Alcance = sdr("Alcance").ToString()
                                dataProyecto.ObjetivoMinimo = sdr("ObjetivoMinimo").ToString()
                                dataProyecto.IdEmpresa = sdr("IdEmpresa").ToString()
                                dataProyecto.ProgramaAcademico = sdr("ProgramaAcademico").ToString()
                                dataProyecto.AsignaturaAcademica = sdr("AsignaturaAcademica").ToString()
                                dataProyecto.IdEtapaActual = sdr("IdEtapaActual").ToString()
                                dataProyecto.IdEstadoProyecto = sdr("IdEstadoProyecto").ToString()
                                dataProyecto.IdUsuario = Guid.Parse(sdr("IdUsuario").ToString())
                                dataProyecto.IdRol = sdr("IdRol").ToString()
                                dataProyecto.FechaRegistro = sdr("FechaRegistro").ToString()
                                dataProyecto.FechaActualizacion = sdr("FechaActualizacion").ToString()

                                'If Not sdr.IsDBNull(sdr.GetOrdinal("Foto")) AndAlso sdr("Foto").ToString <> "" Then
                                '    Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")
                                '    'dataUsuario.Foto = String.Format(Server.MapPath("~/Files/CentroServicio{0}/Usuarios/{1}"), idCentroServicio, sdr("Foto").ToString())
                                '    dataUsuario.Foto = String.Format("/Files/CentroServicio{0}/Usuarios/{1}", idCentroServicio, sdr("Foto").ToString())
                                '    dataUsuario.ConFoto = True.ToString().ToLower()
                                '    dataUsuario.NombreArchivoFotoServidor = sdr("Foto").ToString()
                                'Else
                                '    dataUsuario.Foto = "/images/Silueta.png"
                                '    dataUsuario.ConFoto = False.ToString().ToLower()
                                '    dataUsuario.NombreArchivoFotoServidor = String.Empty
                                'End If
                            End While
                            respuesta.Resultado = dataProyecto
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay información disponible del proyecto especificado"
                        End If
                    End Using 'sdr

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar información del proyecto especificado.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Devuelve el registro de datos del usuario especificado.
    ''' </summary>
    ''' <param name="idUsuario">Identificador de usuario</param>
    ''' <returns>Lista de departamentos ó estado</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EditarUsuario(idUsuario As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaItems As List(Of itemLista) = New List(Of itemLista)
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT IdUsuario, "
                strSQLSelect &= "IdCentroServicio,  "
                strSQLSelect &= "Nombres, "
                strSQLSelect &= "Apellidos, "
                strSQLSelect &= "Foto, "
                strSQLSelect &= "IdTipoDocumento, "
                strSQLSelect &= "Documento, "
                strSQLSelect &= "IdRol, "
                strSQLSelect &= "Email, "
                strSQLSelect &= "Celular, "
                strSQLSelect &= "Direccion, "
                strSQLSelect &= "CodigoPostal, "
                strSQLSelect &= "IdPais, "
                strSQLSelect &= "IdDepartamento, "
                strSQLSelect &= "IdCiudad, "
                strSQLSelect &= "OtraCIudad, "
                strSQLSelect &= "TiempoConectado, "
                strSQLSelect &= "Activo, "
                strSQLSelect &= "FechaRegistro, "
                strSQLSelect &= "FechaActualizacion "
                strSQLSelect &= "FROM  Usuario "
                strSQLSelect &= "WHERE (IdUsuario = @IdUsuario)"

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                    prmIDUsuario.Value = Guid.Parse(idUsuario)
                    cmd.Parameters.Add(prmIDUsuario)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            Dim dataUsuario As New DataUsuario
                            While sdr.Read()
                                dataUsuario.IdUsuario = sdr("IdUsuario").ToString()
                                dataUsuario.IdCentroServicio = sdr("IdCentroServicio").ToString()
                                dataUsuario.Nombres = sdr("Nombres").ToString()
                                dataUsuario.Apellidos = sdr("Apellidos").ToString()
                                dataUsuario.IdTipoDocumento = sdr("IdTipoDocumento").ToString()
                                dataUsuario.Documento = sdr("Documento").ToString()
                                dataUsuario.IdRol = sdr("IdRol").ToString()
                                dataUsuario.Email = sdr("Email").ToString()
                                dataUsuario.Celular = sdr("Celular").ToString()
                                dataUsuario.Direccion = sdr("Direccion").ToString()
                                dataUsuario.CodigoPostal = sdr("CodigoPostal").ToString()
                                dataUsuario.IdPais = sdr("IdPais").ToString()
                                dataUsuario.IdDepartamento = sdr("IdDepartamento").ToString()
                                dataUsuario.IdCiudad = sdr("IdCiudad").ToString()
                                dataUsuario.OtraCIudad = sdr("OtraCIudad").ToString()
                                dataUsuario.TiempoConectado = sdr("TiempoConectado").ToString()
                                dataUsuario.Activo = sdr("Activo").ToString().ToLower()
                                dataUsuario.FechaRegistro = sdr("FechaRegistro").ToString()
                                dataUsuario.FechaActualizacion = sdr("FechaActualizacion").ToString()

                                If Not sdr.IsDBNull(sdr.GetOrdinal("Foto")) AndAlso sdr("Foto").ToString <> "" Then
                                    Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")
                                    'dataUsuario.Foto = String.Format(Server.MapPath("~/Files/CentroServicio{0}/Usuarios/{1}"), idCentroServicio, sdr("Foto").ToString())
                                    dataUsuario.Foto = String.Format("/Files/CentroServicio{0}/Usuarios/{1}", idCentroServicio, sdr("Foto").ToString())
                                    dataUsuario.ConFoto = True.ToString().ToLower()
                                    dataUsuario.NombreArchivoFotoServidor = sdr("Foto").ToString()
                                Else
                                    dataUsuario.Foto = "/images/Silueta.png"
                                    dataUsuario.ConFoto = False.ToString().ToLower()
                                    dataUsuario.NombreArchivoFotoServidor = String.Empty
                                End If
                            End While
                            respuesta.Resultado = dataUsuario
                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay información disponible para el usuario especificado"
                        End If
                    End Using 'sdr

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar información para el usuario especificado.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Crea un inicio de sesión (login) y un registro vacío en la tabla usuario.
    ''' </summary>
    ''' <param name="dataUsuario">Objeto que contiene información sobre el usuario actual</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ActualizarUsuario(dataUsuario As DataUsuario) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLUpdate As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLUpdate = "UPDATE Usuario "
                strSQLUpdate &= "     SET Nombres = @Nombres, "
                strSQLUpdate &= "     Apellidos = @Apellidos, "
                'strSQLUpdate &= "     Foto = @Foto, "
                strSQLUpdate &= "     IdTipoDocumento = @IdTipoDocumento, "
                strSQLUpdate &= "     Documento = @Documento, "
                strSQLUpdate &= "     IdRol = @IdRol, "
                strSQLUpdate &= "     Email = @Email, "
                strSQLUpdate &= "     Celular = @Celular, "
                strSQLUpdate &= "     Direccion = @Direccion, "
                'strSQLUpdate &= "     CodigoPostal = @CodigoPostal, "
                strSQLUpdate &= "     IdPais = @IdPais, "
                strSQLUpdate &= "     IdDepartamento = @IdDepartamento, "
                strSQLUpdate &= "     IdCiudad = @IdCiudad, "
                strSQLUpdate &= "     OtraCIudad = @OtraCIudad, "
                'strSQLUpdate &= "     EsAnonimo = @EsAnonimo, "
                'strSQLUpdate &= "     TiempoConectado = @TiempoConectado, "
                strSQLUpdate &= "     Activo = @Activo, "
                strSQLUpdate &= "     FechaActualizacion = GETDATE() "
                strSQLUpdate &= "WHERE (IdUsuario LIKE @IdUsuario)"

                'Diligencia parámetros
                Dim prmIDUsuario As New SqlParameter("@IDUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = Guid.Parse(dataUsuario.IdUsuario)
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmNombres As New SqlParameter("@Nombres", SqlDbType.NVarChar, 20)
                prmNombres.Value = dataUsuario.Nombres.Trim()
                cmd.Parameters.Add(prmNombres)

                Dim prmApellidos As New SqlParameter("@Apellidos", SqlDbType.NVarChar, 20)
                prmApellidos.Value = dataUsuario.Apellidos.Trim()
                cmd.Parameters.Add(prmApellidos)

                Dim prmIDTipoDocumento As New SqlParameter("@IdTipoDocumento", SqlDbType.TinyInt)
                prmIDTipoDocumento.Value = dataUsuario.IdTipoDocumento
                cmd.Parameters.Add(prmIDTipoDocumento)

                Dim prmDocumento As New SqlParameter("@Documento", SqlDbType.NVarChar, 15)
                prmDocumento.Value = dataUsuario.Documento.Trim()
                cmd.Parameters.Add(prmDocumento)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.TinyInt)
                prmIDRol.Value = dataUsuario.IdRol
                cmd.Parameters.Add(prmIDRol)

                Dim prmEmail As New SqlParameter("@Email", SqlDbType.NVarChar, 50)
                prmEmail.Value = dataUsuario.Email.Trim()
                cmd.Parameters.Add(prmEmail)

                Dim prmCelular As New SqlParameter("@Celular", SqlDbType.NVarChar, 15)
                If Not String.IsNullOrEmpty(dataUsuario.Celular.Trim()) Then
                    prmCelular.Value = dataUsuario.Celular.Trim()
                Else
                    prmCelular.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmCelular)

                Dim prmDireccion As New SqlParameter("@Direccion", SqlDbType.NVarChar, 100)
                prmDireccion.Value = dataUsuario.Direccion.Trim()
                cmd.Parameters.Add(prmDireccion)

                'Dim prmCodigoPostal As New SqlParameter("@CodigoPostal", SqlDbType.NVarChar, 10)
                'If Not String.IsNullOrEmpty(dataUsuario.CodigoPostal.Trim()) Then
                '    prmCodigoPostal.Value = dataUsuario.CodigoPostal.Trim()
                'Else
                '    prmCodigoPostal.Value = DBNull.Value
                'End If
                'cmd.Parameters.Add(prmCodigoPostal)

                Dim prmIDPais As New SqlParameter("@IdPais", SqlDbType.TinyInt)
                prmIDPais.Value = dataUsuario.IdPais
                cmd.Parameters.Add(prmIDPais)

                Dim prmIdDepartamento As New SqlParameter("@IdDepartamento", SqlDbType.NVarChar, 2)
                prmIdDepartamento.Value = dataUsuario.IdDepartamento.Trim()
                cmd.Parameters.Add(prmIdDepartamento)

                Dim prmIDCiudad As New SqlParameter("@IdCiudad", SqlDbType.NVarChar, 5)
                If Not String.IsNullOrEmpty(dataUsuario.IdCiudad.Trim()) Then
                    prmIDCiudad.Value = dataUsuario.IdCiudad.Trim()
                Else
                    prmIDCiudad.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmIDCiudad)

                Dim prmOtraCIudad As New SqlParameter("@OtraCIudad", SqlDbType.NVarChar, 30)
                If Not String.IsNullOrEmpty(dataUsuario.OtraCIudad.Trim()) Then
                    prmOtraCIudad.Value = dataUsuario.OtraCIudad.Trim()
                Else
                    prmOtraCIudad.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmOtraCIudad)

                'Dim prmEsAnonimo As New SqlParameter("@EsAnonimo", SqlDbType.Bit)
                'prmEsAnonimo.Value = Boolean.Parse(dataUsuario.EsAnonimo)
                'cmd.Parameters.Add(prmEsAnonimo)

                'Dim prmTiempoConectado As New SqlParameter("@TiempoConectado", SqlDbType.BigInt)
                'prmTiempoConectado.Value = Boolean.Parse(dataUsuario.TiempoConectado)
                'cmd.Parameters.Add(prmTiempoConectado)

                Dim prmActivo As New SqlParameter("@Activo", SqlDbType.Bit)
                prmActivo.Value = Boolean.Parse(dataUsuario.Activo)
                cmd.Parameters.Add(prmActivo)

                cmd.CommandText = strSQLUpdate
                cmd.ExecuteNonQuery()

                transaction.Commit()

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al actualizar usuario. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Guarda cambios de la data de empresa especificada..
    ''' </summary>
    ''' <param name="dataEmpresa">Objeto que contiene información sobre la empresa actual</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ActualizarEmpresa(dataEmpresa As DataEmpresa) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLUpdate As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLUpdate = "DECLARE @Empresa NVARCHAR(MAX); "
                strSQLUpdate &= "IF EXISTS(SELECT 1 FROM Empresa WHERE IdEmpresa = @IdEmpresa) "
                strSQLUpdate &= "BEGIN "
                strSQLUpdate &= "    IF NOT EXISTS(SELECT 1 FROM  Empresa WHERE (NIT = @NIT) AND (IdEmpresa <> @IdEmpresa)) "
                strSQLUpdate &= "        BEGIN "
                strSQLUpdate &= "            UPDATE Empresa "
                strSQLUpdate &= "            SET RazonSocial = @RazonSocial, "
                strSQLUpdate &= "                    NIT = @NIT, "
                'strSQLUpdate &= "                    Logo = @Logo, "
                strSQLUpdate &= "                    RepresentanteLegal = @RepresentanteLegal, "
                strSQLUpdate &= "                    Email = @Email, "
                strSQLUpdate &= "                    Celular1 = @Celular1, "
                strSQLUpdate &= "                    Celular2 = @Celular2, "
                strSQLUpdate &= "                    Telefono1 = @Telefono1, "
                strSQLUpdate &= "                    Telefono2 = @Telefono2, "
                strSQLUpdate &= "                    IdPais = @IdPais, "
                strSQLUpdate &= "                    IdDepartamento = @IdDepartamento, "
                strSQLUpdate &= "                    IdCiudad = @IdCiudad, "
                strSQLUpdate &= "                    OtraCIudad = @OtraCIudad, "
                strSQLUpdate &= "                    Direccion = @Direccion, "
                strSQLUpdate &= "                    IdUsuario = @IdUsuario, "
                strSQLUpdate &= "                    IdRol = @IdRol, "
                strSQLUpdate &= "                    FechaActualizacion = GetDate() "
                strSQLUpdate &= "            WHERE (IdEmpresa = @IdEmpresa); "
                strSQLUpdate &= "            SET @CodeError = 0; "
                strSQLUpdate &= "	           SET @MessageError = 'Actualización éxitosa.'; "
                strSQLUpdate &= "        END "
                strSQLUpdate &= "    ELSE"
                strSQLUpdate &= "        BEGIN "
                strSQLUpdate &= "            SELECT @Empresa = RazonSocial FROM  Empresa WHERE (NIT = @NIT); "
                strSQLUpdate &= "            SET @CodeError = -1 "
                strSQLUpdate &= String.Format("	           SET @MessageError = 'El <b>Nit {0}</b> ya se encuentra registrado con la empresa <b>' + @Empresa + '</b>.'; ", dataEmpresa.NIT.Trim())
                strSQLUpdate &= "        END "
                strSQLUpdate &= "END"

                'Diligencia parámetros
                Dim prmIDEmpresa As New SqlParameter("@IdEmpresa", SqlDbType.Int)
                prmIDEmpresa.Value = dataEmpresa.IdEmpresa
                cmd.Parameters.Add(prmIDEmpresa)

                Dim prmRazonSocial As New SqlParameter("@RazonSocial", SqlDbType.NVarChar, 50)
                prmRazonSocial.Value = dataEmpresa.RazonSocial.Trim()
                cmd.Parameters.Add(prmRazonSocial)

                Dim prmNIT As New SqlParameter("@NIT", SqlDbType.NVarChar, 12)
                prmNIT.Value = dataEmpresa.NIT.Trim()
                cmd.Parameters.Add(prmNIT)

                Dim prmRepresentanteLegal As New SqlParameter("@RepresentanteLegal", SqlDbType.NVarChar, 30)
                prmRepresentanteLegal.Value = dataEmpresa.RepresentanteLegal.Trim()
                cmd.Parameters.Add(prmRepresentanteLegal)

                Dim prmEmail As New SqlParameter("@Email", SqlDbType.NVarChar, 50)
                prmEmail.Value = dataEmpresa.Email.Trim()
                cmd.Parameters.Add(prmEmail)

                Dim prmCelular1 As New SqlParameter("@Celular1", SqlDbType.NVarChar, 15)
                prmCelular1.Value = dataEmpresa.Celular1.Trim()
                cmd.Parameters.Add(prmCelular1)

                Dim prmCelular2 As New SqlParameter("@Celular2", SqlDbType.NVarChar, 15)
                If Not String.IsNullOrEmpty(dataEmpresa.Celular2.Trim()) Then
                    prmCelular2.Value = dataEmpresa.Celular2.Trim()
                Else
                    prmCelular2.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmCelular2)

                Dim prmTelefono1 As New SqlParameter("@Telefono1", SqlDbType.NVarChar, 15)
                If Not String.IsNullOrEmpty(dataEmpresa.Telefono1.Trim()) Then
                    prmTelefono1.Value = dataEmpresa.Telefono1.Trim()
                Else
                    prmTelefono1.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmTelefono1)

                Dim prmTelefono2 As New SqlParameter("@Telefono2", SqlDbType.NVarChar, 15)
                If Not String.IsNullOrEmpty(dataEmpresa.Telefono2.Trim()) Then
                    prmTelefono2.Value = dataEmpresa.Telefono2.Trim()
                Else
                    prmTelefono2.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmTelefono2)

                Dim prmIDPais As New SqlParameter("@IdPais", SqlDbType.TinyInt)
                prmIDPais.Value = dataEmpresa.IdPais
                cmd.Parameters.Add(prmIDPais)

                Dim prmIDDepartamento As New SqlParameter("@IdDepartamento", SqlDbType.NVarChar, 2)
                prmIDDepartamento.Value = dataEmpresa.IdDepartamento
                cmd.Parameters.Add(prmIDDepartamento)

                Dim prmIDCiudad As New SqlParameter("@IdCiudad", SqlDbType.NVarChar, 5)
                If Not String.IsNullOrEmpty(dataEmpresa.IdCiudad.Trim()) Then
                    prmIDCiudad.Value = dataEmpresa.IdCiudad.Trim()
                Else
                    prmIDCiudad.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmIDCiudad)

                Dim prmOtraCIudad As New SqlParameter("@OtraCIudad", SqlDbType.NVarChar, 30)
                If Not String.IsNullOrEmpty(dataEmpresa.OtraCIudad.Trim()) Then
                    prmOtraCIudad.Value = dataEmpresa.OtraCIudad.Trim()
                Else
                    prmOtraCIudad.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmOtraCIudad)

                Dim prmDireccion As New SqlParameter("@Direccion", SqlDbType.NVarChar, 100)
                prmDireccion.Value = dataEmpresa.Direccion.Trim()
                cmd.Parameters.Add(prmDireccion)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = Guid.Parse(HttpContext.Current.Session("IDUsuario").ToString())
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.TinyInt)
                prmIDRol.Value = HttpContext.Current.Session("IDRol")
                cmd.Parameters.Add(prmIDRol)

                Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                prmCodeError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmCodeError)

                Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                prmMessageError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmMessageError)

                cmd.CommandText = strSQLUpdate
                cmd.ExecuteNonQuery()

                transaction.Commit()

                If cmd.Parameters("@CodeError").Value <> 0 Then
                    respuesta.Codigo = -1
                    respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al crear empresa. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Guarda cambios del registro de entregable de proyecto...
    ''' </summary>
    ''' <param name="dataEntregableProyecto">Objeto que contiene información actualizada de un entregable de proyecto</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ActualizarEntregaProyecto(dataEntregableProyecto As DataEntregableProyecto) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLUpdate As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLUpdate = "IF EXISTS(SELECT 1 FROM EntregableProyecto WHERE IdEntregableProyecto = @IdEntregableProyecto) "
                strSQLUpdate &= "   BEGIN "
                strSQLUpdate &= "        UPDATE EntregableProyecto "
                strSQLUpdate &= "               SET IdProyecto = @IdProyecto, "
                strSQLUpdate &= "   	 	             IdEtapa = @IdEtapa, "
                strSQLUpdate &= "   		             Nombre = @Nombre, "
                strSQLUpdate &= "   		             Descripcion = @Descripcion, "
                strSQLUpdate &= "   		             RutaArchivo = @RutaArchivo, "
                Select Case Session("RolUsuario")
                    Case "Coordinador"
                        strSQLUpdate &= "   		             FeedBackCoordinador = @FeedBackCoordinador, "
                        strSQLUpdate &= "   		             FechaFeedBackCoordinador = @FechaFeedBackCoordinador, "
                    Case "Docente"
                        strSQLUpdate &= "                      FeedBackDocente = @FeedBackDocente, "
                        strSQLUpdate &= "                      FechaFeedBackDocente = @FechaFeedBackDocente, "
                End Select
                strSQLUpdate &= "                      IdUsuario = @IdUsuario, "
                strSQLUpdate &= "   		            IdRol = @IdRol, "
                strSQLUpdate &= "   		            FechaActualizacion = GetDate() "
                strSQLUpdate &= "        WHERE (IdEntregableProyecto = @IdEntregableProyecto); "
                strSQLUpdate &= "        SET @CodeError = 0; "
                strSQLUpdate &= "	       SET @MessageError = ''Registro de entregable de proyecto actualizado éxitosamente.'; "
                strSQLUpdate &= "    END"
                strSQLUpdate &= "ELSE "
                strSQLUpdate &= "    BEGIN "
                strSQLUpdate &= "        SET @CodeError = -1; "
                strSQLUpdate &= "		   SET @MessageError = 'Registro de entregable de proyecto no disponible. La actualización del registro de entregable del proyecto no pudo llevarse a cabo.'; "
                strSQLUpdate &= "    END"

                'Diligencia parámetros
                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = dataEntregableProyecto.IdProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Dim prmIDEtapa As New SqlParameter("@IdEtapa", SqlDbType.TinyInt)
                prmIDEtapa.Value = dataEntregableProyecto.IdEtapa
                cmd.Parameters.Add(prmIDEtapa)

                Dim prmDescripcion As New SqlParameter("@Descripcion", SqlDbType.NVarChar, 1000)
                prmDescripcion.Value = dataEntregableProyecto.Descripcion.Trim()
                cmd.Parameters.Add(prmDescripcion)

                Dim prmRutaArchivo As New SqlParameter("@RutaArchivo", SqlDbType.NVarChar, 1000)
                prmRutaArchivo.Value = dataEntregableProyecto.RutaArchivo.Trim()
                cmd.Parameters.Add(prmRutaArchivo)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = dataEntregableProyecto.IdUsuario
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.TinyInt)
                prmIDRol.Value = dataEntregableProyecto.IdRol
                cmd.Parameters.Add(prmIDRol)

                Select Case Session("RolUsuario")
                    Case "Coordinador"
                        Dim prmFeedBackCoordinador As New SqlParameter("@FeedBackCoordinador", SqlDbType.NVarChar, -1)
                        Dim prmFechaFeedBackCoordinador As New SqlParameter("@FechaFeedBackCoordinador", SqlDbType.DateTime)
                        If Not String.IsNullOrEmpty(dataEntregableProyecto.FeedBackCoordinador.Trim()) Then
                            prmFeedBackCoordinador.Value = dataEntregableProyecto.FeedBackCoordinador.Trim()
                            prmFechaFeedBackCoordinador.Value = Date.Now()
                        Else
                            prmFeedBackCoordinador.Value = DBNull.Value
                            prmFechaFeedBackCoordinador.Value = DBNull.Value
                        End If
                        cmd.Parameters.Add(prmFeedBackCoordinador)
                        cmd.Parameters.Add(prmFechaFeedBackCoordinador)
                    Case "Docente"
                        Dim prmFeedBackDocente As New SqlParameter("@FeedBackDocente", SqlDbType.NVarChar, -1)
                        Dim prmFechaFeedBackDocente As New SqlParameter("@FechaFeedBackDocente", SqlDbType.DateTime)
                        If Not String.IsNullOrEmpty(dataEntregableProyecto.FeedBackDocente.Trim()) Then
                            prmFeedBackDocente.Value = dataEntregableProyecto.FeedBackDocente.Trim()
                            prmFechaFeedBackDocente.Value = Date.Now()
                        Else
                            prmFeedBackDocente.Value = DBNull.Value
                            prmFechaFeedBackDocente.Value = DBNull.Value
                        End If
                        cmd.Parameters.Add(prmFeedBackDocente)
                        cmd.Parameters.Add(prmFechaFeedBackDocente)
                End Select

                cmd.CommandText = strSQLUpdate
                cmd.ExecuteNonQuery()

                transaction.Commit()

                If cmd.Parameters("@CodeError").Value > 0 Then
                    respuesta.Codigo = -1
                    respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al actualizar el proyecto. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Guarda cambios del objetivo del proyecto especificado..
    ''' </summary>
    ''' <param name="dataObjetivoProyecto">Objeto que contiene información sobre el objetivo del proyecto especificado.</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ActualizarObjetivoProyecto(dataObjetivoProyecto As DataObjetivoProyecto) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLUpdate As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLUpdate = "IF EXISTS(SELECT 1 FROM ObjetivoProyecto WHERE IdObjetivoProyecto = @IdObjetivoProyecto) "
                strSQLUpdate &= "   BEGIN "
                strSQLUpdate &= "        UPDATE ObjetivoProyecto "
                strSQLUpdate &= "               SET Objetivo = @Objetivo, "
                strSQLUpdate &= "                       IdUsuario = @IdUsuario, "
                strSQLUpdate &= "   		             IdRol = @IdRol, "
                strSQLUpdate &= "   		             FechaActualizacion = GetDate() "
                strSQLUpdate &= "        WHERE (IdObjetivoProyecto = @IdObjetivoProyecto); "
                strSQLUpdate &= "        SET @CodeError = 0; "
                strSQLUpdate &= "	       SET @MessageError = ''Objetivo del proyecto actualizada éxitosamente.'; "
                strSQLUpdate &= "    END"
                strSQLUpdate &= "ELSE "
                strSQLUpdate &= "    BEGIN "
                strSQLUpdate &= "        SET @CodeError = -1; "
                strSQLUpdate &= "		   SET @MessageError = 'Obejtivo del proyecto no disponible. La actualización del objetivo de proyecto no pudo llevarse a cabo.'; "
                strSQLUpdate &= "    END"

                'Diligencia parámetros
                Dim prmIDObjetivoProyecto As New SqlParameter("@IdObjetivoProyecto", SqlDbType.BigInt)
                prmIDObjetivoProyecto.Value = dataObjetivoProyecto.IdObjetivoProyecto
                cmd.Parameters.Add(prmIDObjetivoProyecto)

                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = dataObjetivoProyecto.IdProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Dim prmObjetivo As New SqlParameter("@Objetivo", SqlDbType.TinyInt)
                prmObjetivo.Value = dataObjetivoProyecto.Objetivo
                cmd.Parameters.Add(prmObjetivo)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = dataObjetivoProyecto.IdUsuario
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.SmallInt)
                prmIDRol.Value = dataObjetivoProyecto.IdRol
                cmd.Parameters.Add(prmIDRol)

                Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                prmCodeError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmCodeError)

                Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                prmMessageError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmMessageError)

                cmd.CommandText = strSQLUpdate
                cmd.ExecuteNonQuery()

                transaction.Commit()

                If cmd.Parameters("@CodeError").Value > 0 Then
                    respuesta.Codigo = -1
                    respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al actualizar objetivo del proyecto. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Guarda cambios de la data del programa académico especificado..
    ''' </summary>
    ''' <param name="dataProgramaAcademico">Objeto que contiene información sobre la data del programa académico especificado</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ActualizarProgramaAcademico(dataProgramaAcademico As DataProgramaAcademico) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLUpdate As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLUpdate = "IF EXISTS(SELECT 1 FROM ProgramaAcademico WHERE IdPrograma = @IdPrograma) "
                strSQLUpdate &= "   BEGIN "
                strSQLUpdate &= "        UPDATE ProgramaAcademico "
                strSQLUpdate &= "               SET Nombre = @IdCentroServicio, "
                strSQLUpdate &= "                       Activo = @IdTipoProyecto, "
                strSQLUpdate &= "                       IdUsuario = @IdUsuario, "
                strSQLUpdate &= "   		             IdRol = @IdRol, "
                strSQLUpdate &= "   		             FechaActualizacion = GetDate() "
                strSQLUpdate &= "        WHERE (IdPrograma = @IdPrograma); "
                strSQLUpdate &= "        SET @CodeError = 0; "
                strSQLUpdate &= "	       SET @MessageError = ''Programa académico actualizado éxitosamente.'; "
                strSQLUpdate &= "    END"
                strSQLUpdate &= "ELSE "
                strSQLUpdate &= "    BEGIN "
                strSQLUpdate &= "        SET @CodeError = -1; "
                strSQLUpdate &= "		   SET @MessageError = 'Programa académico no disponible. La actualización del 'programa académico no pudo llevarse a cabo.'; "
                strSQLUpdate &= "    END"

                'Diligencia parámetros
                Dim prmIDPrograma As New SqlParameter("@IdPrograma", SqlDbType.TinyInt)
                prmIDPrograma.Value = dataProgramaAcademico.IdPrograma
                cmd.Parameters.Add(prmIDPrograma)

                Dim prmNombre As New SqlParameter("@Nombre", SqlDbType.NVarChar, 50)
                prmNombre.Value = dataProgramaAcademico.Nombre.Trim()
                cmd.Parameters.Add(prmNombre)

                Dim prmActivo As New SqlParameter("@Activo", SqlDbType.Bit)
                prmActivo.Value = Boolean.Parse(dataProgramaAcademico.Activo)
                cmd.Parameters.Add(prmActivo)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = dataProgramaAcademico.IdUsuario
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.SmallInt)
                prmIDRol.Value = dataProgramaAcademico.IdRol
                cmd.Parameters.Add(prmIDRol)

                Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                prmCodeError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmCodeError)

                Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                prmMessageError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmMessageError)

                cmd.CommandText = strSQLUpdate
                cmd.ExecuteNonQuery()

                transaction.Commit()

                If cmd.Parameters("@CodeError").Value > 0 Then
                    respuesta.Codigo = -1
                    respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al actualizar el programa académico. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Guarda cambios de la data del proyecto especificado..
    ''' </summary>
    ''' <param name="dataProyecto">Objeto que contiene información sobre la data del proyecto especificado</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ActualizarProyecto(dataProyecto As DataProyecto) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLUpdate As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLUpdate = "IF EXISTS(SELECT 1 FROM Proyecto WHERE IdProyecto = @IdProyecto) "
                strSQLUpdate &= "   BEGIN "
                strSQLUpdate &= "        UPDATE Proyecto "
                strSQLUpdate &= "               SET IdCentroServicio = @IdCentroServicio, "
                strSQLUpdate &= "                       IdTipoProyecto = @IdTipoProyecto, "
                strSQLUpdate &= "   	 	             Titulo = @Titulo, "
                strSQLUpdate &= "   		             Descripcion = @Descripcion, "
                strSQLUpdate &= "   		             Alcance = @Alcance, "
                strSQLUpdate &= "   		             ObjetivoMinimo = @ObjetivoMinimo, "
                strSQLUpdate &= "   		             IdEmpresa = @IdEmpresa, "
                strSQLUpdate &= "   		             IdModalidad = @IdModalidad, "
                strSQLUpdate &= "                      ProgramaAcademico = @ProgramaAcademico, "
                strSQLUpdate &= "                      AsignaturaAcademica = @AsignaturaAcademica, "
                strSQLUpdate &= "   		             IdEtapaActual = @IdEtapaActual, "
                strSQLUpdate &= "   		             IdEstadoProyecto = @IdEstadoProyecto, "
                strSQLUpdate &= "                      IdUsuario = @IdUsuario, "
                strSQLUpdate &= "   		            IdRol = @IdRol, "
                strSQLUpdate &= "   		            FechaActualizacion = GetDate() "
                strSQLUpdate &= "        WHERE (IdProyecto = @IdProyecto); "
                strSQLUpdate &= "        SET @CodeError = 0; "
                strSQLUpdate &= "	       SET @MessageError = 'Proyectos: Actualización éxitosa.'; "
                strSQLUpdate &= "    END "
                strSQLUpdate &= "ELSE "
                strSQLUpdate &= "    BEGIN "
                strSQLUpdate &= "        SET @CodeError = -1; "
                strSQLUpdate &= "		   SET @MessageError = 'Proyectos: Registro de datos no disponible. La actualización del proyecto no pudo llevarse a cabo.'; "
                strSQLUpdate &= "    END"

                'Diligencia parámetros
                Dim prmIDCentroServiciol As New SqlParameter("@IdCentroServicio", SqlDbType.TinyInt)
                prmIDCentroServiciol.Value = HttpContext.Current.Session("IDCentroServicio")
                cmd.Parameters.Add(prmIDCentroServiciol)

                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = dataProyecto.IdProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Dim prmIDTipoProyecto As New SqlParameter("@IdTipoProyecto", SqlDbType.TinyInt)
                prmIDTipoProyecto.Value = dataProyecto.IdTipoProyecto
                cmd.Parameters.Add(prmIDTipoProyecto)

                Dim prmTitulo As New SqlParameter("@Titulo", SqlDbType.NVarChar, 150)
                prmTitulo.Value = dataProyecto.Titulo.Trim()
                cmd.Parameters.Add(prmTitulo)

                Dim prmDescripcion As New SqlParameter("@Descripcion", SqlDbType.NVarChar, -1)
                If Not String.IsNullOrEmpty(dataProyecto.Descripcion.Trim()) Then
                    prmDescripcion.Value = dataProyecto.Descripcion.Trim()
                Else
                    prmDescripcion.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmDescripcion)

                Dim prmAlcance As New SqlParameter("@Alcance", SqlDbType.NVarChar, -1)
                If Not String.IsNullOrEmpty(dataProyecto.Alcance.Trim()) Then
                    prmAlcance.Value = dataProyecto.Alcance.Trim()
                Else
                    prmAlcance.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmAlcance)

                Dim prmObjetivoMinimo As New SqlParameter("@ObjetivoMinimo", SqlDbType.NVarChar, -1)
                If Not String.IsNullOrEmpty(dataProyecto.ObjetivoMinimo.Trim()) Then
                    prmObjetivoMinimo.Value = dataProyecto.ObjetivoMinimo.Trim()
                Else
                    prmObjetivoMinimo.Value = DBNull.Value
                End If
                cmd.Parameters.Add(prmObjetivoMinimo)

                Dim prmIDEmpresa As New SqlParameter("@IdEmpresa", SqlDbType.Int)
                prmIDEmpresa.Value = dataProyecto.IdEmpresa
                cmd.Parameters.Add(prmIDEmpresa)

                Dim prmIDModalidad As New SqlParameter("@IdModalidad", SqlDbType.TinyInt)
                prmIDModalidad.Value = dataProyecto.IdModalidad
                cmd.Parameters.Add(prmIDModalidad)

                Dim prmProgramaAcademico As New SqlParameter("@ProgramaAcademico", SqlDbType.NVarChar, 50)
                prmProgramaAcademico.Value = dataProyecto.ProgramaAcademico.Trim()
                cmd.Parameters.Add(prmProgramaAcademico)

                Dim prmAsignaturaAcademica As New SqlParameter("@AsignaturaAcademica", SqlDbType.NVarChar, 50)
                prmAsignaturaAcademica.Value = dataProyecto.AsignaturaAcademica.Trim()
                cmd.Parameters.Add(prmAsignaturaAcademica)

                Dim prmIDEtapaActual As New SqlParameter("@IdEtapaActual", SqlDbType.TinyInt)
                prmIDEtapaActual.Value = dataProyecto.IdEtapaActual
                cmd.Parameters.Add(prmIDEtapaActual)

                Dim prmIDEstadoProyecto As New SqlParameter("@IdEstadoProyecto", SqlDbType.TinyInt)
                prmIDEstadoProyecto.Value = dataProyecto.IdEstadoProyecto
                cmd.Parameters.Add(prmIDEstadoProyecto)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = Guid.Parse(HttpContext.Current.Session("IDUsuario").ToString())
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.TinyInt)
                prmIDRol.Value = HttpContext.Current.Session("IDRol")
                cmd.Parameters.Add(prmIDRol)

                Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                prmCodeError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmCodeError)

                Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                prmMessageError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmMessageError)

                cmd.CommandText = strSQLUpdate
                cmd.ExecuteNonQuery()

                transaction.Commit()

                If cmd.Parameters("@CodeError").Value <> 0 Then
                    respuesta.Codigo = -1
                    respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al actualizar el proyecto. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Guarda cambios de la tarea del proyecto especificado..
    ''' </summary>
    ''' <param name="dataTareaProyecto">Objeto que contiene información sobre la tarea asignada al proyecto especificado.</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ActualizarTareaProyecto(dataTareaProyecto As DataTareaProyecto) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLUpdate As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLUpdate = "IF EXISTS(SELECT 1 FROM TareaProyecto WHERE IdTareaProyecto = @IdTareaProyecto) "
                strSQLUpdate &= "   BEGIN "
                strSQLUpdate &= "        UPDATE TareaProyecto "
                strSQLUpdate &= "               SET IdCentroServicio = @IdCentroServicio, "
                strSQLUpdate &= "                       IdProyecto = @IdProyecto, "
                strSQLUpdate &= "   	 	             IdTipoTarea = @IdTipoTarea, "
                strSQLUpdate &= "   		             Nombre = @Nombre, "
                strSQLUpdate &= "   		             Descripcion = @Descripcion, "
                strSQLUpdate &= "   		             FechaInicio = @FechaInicio, "
                strSQLUpdate &= "   		             FechaFinalización = @FechaFinalización, "
                strSQLUpdate &= "   		             FechaLimite = @FechaLimite, "
                strSQLUpdate &= "                      IdResponsable = @IdResponsable, "
                strSQLUpdate &= "                      IdEstadoTarea = @IdEstadoTarea, "
                strSQLUpdate &= "                      IdUsuario = @IdUsuario, "
                strSQLUpdate &= "   		            IdRol = @IdRol, "
                strSQLUpdate &= "   		            FechaActualizacion = GetDate() "
                strSQLUpdate &= "        WHERE (IdTareaProyecto = @IdTareaProyecto); "
                strSQLUpdate &= "        SET @CodeError = 0; "
                strSQLUpdate &= "	       SET @MessageError = ''Tarea de proyecto actualizada éxitosamente.'; "
                strSQLUpdate &= "    END"
                strSQLUpdate &= "ELSE "
                strSQLUpdate &= "    BEGIN "
                strSQLUpdate &= "        SET @CodeError = -1; "
                strSQLUpdate &= "		   SET @MessageError = 'Tarea de proyecto no disponible. La actualización de la tarea de proyecto no pudo llevarse a cabo.'; "
                strSQLUpdate &= "    END"

                'Diligencia parámetros
                Dim prmIDTareaProyecto As New SqlParameter("@IdTareaProyecto", SqlDbType.BigInt)
                prmIDTareaProyecto.Value = dataTareaProyecto.IdTareaProyecto
                cmd.Parameters.Add(prmIDTareaProyecto)

                Dim prmIDCentroServiciol As New SqlParameter("@IdCentroServicio", SqlDbType.TinyInt)
                prmIDCentroServiciol.Value = dataTareaProyecto.IdCentroServicio
                cmd.Parameters.Add(prmIDCentroServiciol)

                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = dataTareaProyecto.IdProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Dim prmIDTipoTarea As New SqlParameter("@IdTipoTarea", SqlDbType.TinyInt)
                prmIDTipoTarea.Value = dataTareaProyecto.IdTipoTarea
                cmd.Parameters.Add(prmIDTipoTarea)

                Dim prmNombre As New SqlParameter("@Nombre", SqlDbType.NVarChar, 50)
                prmNombre.Value = dataTareaProyecto.Nombre.Trim()
                cmd.Parameters.Add(prmNombre)

                Dim prmDescripcion As New SqlParameter("@Descripcion", SqlDbType.NVarChar, 50)
                prmDescripcion.Value = dataTareaProyecto.Descripcion.Trim()
                cmd.Parameters.Add(prmDescripcion)

                Dim prmFechaInicio As New SqlParameter("@FechaInicio", SqlDbType.DateTime)
                prmFechaInicio.Value = dataTareaProyecto.FechaInicio
                cmd.Parameters.Add(prmFechaInicio)

                Dim prmFechaFinalización As New SqlParameter("@FechaFinalización", SqlDbType.DateTime)
                prmFechaFinalización.Value = dataTareaProyecto.FechaFinalización
                cmd.Parameters.Add(prmFechaFinalización)

                Dim prmFechaLimite As New SqlParameter("@FechaLimite", SqlDbType.DateTime)
                prmFechaLimite.Value = dataTareaProyecto.FechaLimite
                cmd.Parameters.Add(prmFechaLimite)

                Dim prmIDResponsable As New SqlParameter("@IdResponsable", SqlDbType.BigInt)
                prmIDResponsable.Value = dataTareaProyecto.IdResponsable
                cmd.Parameters.Add(prmIDResponsable)

                Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                prmIDUsuario.Value = dataTareaProyecto.IdUsuario
                cmd.Parameters.Add(prmIDUsuario)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.SmallInt)
                prmIDRol.Value = dataTareaProyecto.IdRol
                cmd.Parameters.Add(prmIDRol)

                Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                prmCodeError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmCodeError)

                Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                prmMessageError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmMessageError)

                cmd.CommandText = strSQLUpdate
                cmd.ExecuteNonQuery()

                transaction.Commit()

                If cmd.Parameters("@CodeError").Value > 0 Then
                    respuesta.Codigo = -1
                    respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al actualizar el proyecto. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Retorna unobjeto DatatTable con la lista de usuarios registrados en el centro de servicios especificado.
    ''' </summary>
    ''' <returns>Lista de centros de servicios</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    '<WebMethod(EnableSession:=True)>
    '<ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    'Public Function CargarUsuariosXXX() As String
    '    Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
    '    Dim listaUsuarios As List(Of DataListaGeneralUsuarios) = New List(Of DataListaGeneralUsuarios)
    '    Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
    '    Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")
    '    Dim ds As DataSet

    '    Try
    '        Using connection As New SqlConnection(connectionString)
    '            connection.Open()

    '            Dim strSQLSelect As String = String.Empty

    '            strSQLSelect = "SELECT USR.Nombres, "
    '            strSQLSelect &= "              USR.Apellidos, "
    '            strSQLSelect &= "              Rol.Nombre AS Rol, "
    '            strSQLSelect &= "              USR.FechaRegistro "
    '            strSQLSelect &= "   FROM Usuario AS USR INNER JOIN Rol ON USR.IdRol = Rol.IdRol "
    '            strSQLSelect &= "WHERE (USR.IdCentroServicio LIKE @IdCentroServicio)"
    '            strSQLSelect &= "ORDER BY USR.Nombres, USR.Apellidos"

    '            Using cmd As New SqlCommand(strSQLSelect)
    '                cmd.Connection = connection
    '                cmd.CommandType = CommandType.Text

    '                'Diligencia parámetros
    '                Dim prmIDCentroServicio As New SqlParameter("@IdCentroServicio", SqlDbType.TinyInt)
    '                prmIDCentroServicio.Value = idCentroServicio
    '                cmd.Parameters.Add(prmIDCentroServicio)

    '                ds = New DataSet("data")
    '                Using da As New SqlDataAdapter(cmd)
    '                    da.Fill(ds)
    '                    ds.Tables(0).TableName = "data"
    '                    respuesta.Resultado = JsonConvert.SerializeObject(ds, Formatting.Indented)
    '                End Using
    '            End Using

    '            connection.Close()
    '        End Using

    '    Catch ex As Exception
    '        respuesta.Codigo = -1
    '        respuesta.Mensaje = String.Format("<b>Error al recuperar usuarios para este centro de servicios</b>. Mensaje: {0}", ex.Message)
    '    End Try

    '    'Return New JavaScriptSerializer().Serialize(respuesta)
    '    Return JsonConvert.SerializeObject(ds, Formatting.Indented)
    'End Function

    ''' <summary>
    ''' Elimina el documento en el servidor..
    ''' </summary>
    ''' <param name="idProyecto">Identificador de proyecto</param>''' 
    ''' <param name="idDocumento">Identificador de documento</param>
    ''' <param name="nombreArchivoDocumentoServidor">Nombre del documento en disco en el servidor</param>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EliminarDocumento(idProyecto As String, idDocumento As String, nombreArchivoDocumentoServidor As String) As String
        Dim respuesta As New EstadoOperacion("0", "Proceso exitoso")

        Try
            Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")

            'Mapea el directorio Usuarios del Centro de Servicios especificado.
            Dim folderDocumentos = String.Format(Server.MapPath("~/Files/CentroServicio{0}/Proyectos/{1}/Documentos"), idCentroServicio, Long.Parse(idProyecto).ToString("D6"))
            If Not Directory.Exists(folderDocumentos) Then
                Directory.CreateDirectory(folderDocumentos)
            End If

            Dim rutaArchivo As String = String.Format("{0}\{1}", folderDocumentos, nombreArchivoDocumentoServidor)
            If File.Exists(rutaArchivo) Then
                File.Delete(rutaArchivo)
            End If

            'Marca como nulo el campo Foto del registro de datos del usuario especiifcado
            If EliminarDocumentoEnBaseDatos(idDocumento, respuesta) Then
                respuesta.Codigo = "0"
                respuesta.Mensaje = "Proceso exitoso"
            End If

        Catch ex As Exception
            respuesta.Codigo = "-1"
            respuesta.Mensaje = String.Format("Error al eliminar documento del proyecto actual: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Elimina el registro de datos del documento de la base de datos.
    ''' </summary>
    ''' <param name="idDocumento">Identificador de documento</param>
    ''' <param name="respuesta">Objeto que encapsula el estado final de la operación.</param>
    ''' <returns>Cadena con información del estado final de la operación</returns>
    ''' <remarks>Copyright JULC Mayo 2021</remarks>
    Private Function EliminarDocumentoEnBaseDatos(idDocumento As String, ByRef respuesta As EstadoOperacion) As Boolean
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim estadoOperacion As Boolean = False
        Dim sbMensaje As StringBuilder = New StringBuilder()
        respuesta.ValorDefault = String.Empty

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim sqlDelete As String = String.Empty
                Dim registrosAfectados As Integer = -1

                sqlDelete = "DELETE FROM Documento "
                sqlDelete &= "WHERE (IdDocumento = @IdDocumento)"

                Dim prmIDDocumento As New SqlParameter("@IdDocumento", SqlDbType.Int)
                prmIDDocumento.Value = idDocumento
                cmd.Parameters.Add(prmIDDocumento)

                cmd.CommandText = sqlDelete
                cmd.ExecuteNonQuery()

                transaction.Commit()
                estadoOperacion = True

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al eliminar documento del proyecto. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return estadoOperacion
    End Function

    ''' <summary>
    ''' Elimina un registro de Empresa.
    ''' </summary>
    ''' <param name="idEmpresa">Identificador de empresa</param>
    ''' <returns>Cadena con información del estado final de la operación</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EliminarEmpresa(idEmpresa As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLTransaction As String = String.Empty

                strSQLTransaction = "BEGIN TRY "
                strSQLTransaction &= "BEGIN TRANSACTION "
                ' Borra el registro de Empresa
                strSQLTransaction &= "      DELETE FROM Empresa WHERE (IdEmpresa = @IdEmpresa) "
                ' Si todo sale bien entonces confirma la transaccion.
                strSQLTransaction &= "      COMMIT TRANSACTION "
                strSQLTransaction &= "      SET @CodeError = 0 "
                strSQLTransaction &= "END TRY "
                strSQLTransaction &= "BEGIN CATCH "
                strSQLTransaction &= "     SET @CodeError = ERROR_NUMBER() "
                strSQLTransaction &= "     IF @CodeError = 547 "
                'El usuario ya tiene información relacionada con otras tablas del istema, entonces no se puede eliminar.
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = 'No se puede eliminar esta Empresa porque ya tiene información relacionada en el sistema.'; "
                strSQLTransaction &= "	       END "
                strSQLTransaction &= "	  ELSE "
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = ERROR_MESSAGE(); "
                strSQLTransaction &= "	      END "

                '-- Transaction uncommittable "
                strSQLTransaction &= "    IF (XACT_STATE()) = -1 "
                strSQLTransaction &= "        ROLLBACK TRANSACTION "

                '- Transaction committable "
                strSQLTransaction &= "     IF (XACT_STATE()) = 1 "
                strSQLTransaction &= "         COMMIT TRANSACTION "
                strSQLTransaction &= " END CATCH"

                Using cmd As New SqlCommand(strSQLTransaction)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDEmpresa As New SqlParameter("@IdEmpresa", SqlDbType.Int)
                    prmIDEmpresa.Value = Integer.Parse(idEmpresa)
                    cmd.Parameters.Add(prmIDEmpresa)

                    Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                    prmCodeError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmCodeError)

                    Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                    prmMessageError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmMessageError)

                    cmd.CommandText = strSQLTransaction
                    cmd.ExecuteNonQuery()

                    If cmd.Parameters("@CodeError").Value > 0 Then
                        respuesta.Codigo = -1
                        respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                    End If

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al eliminar Empresa</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Elimina un registro de entregable de proyecto.
    ''' </summary>
    ''' <param name="idEntregableProyecto">Identificador de regoistro de entregable de proyecto</param>
    ''' <returns>Cadena con información del estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EliminarEntregableProyecto(idEntregableProyecto As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLTransaction As String = String.Empty

                strSQLTransaction = "BEGIN TRY "
                strSQLTransaction &= "BEGIN TRANSACTION "
                ' Borra el registro de entregable del proyecto
                strSQLTransaction &= "      DELETE FROM TareaProyecto WHERE (IdEntregableProyecto = @IdEntregableProyecto) "
                ' Si todo sale bien entonces confirma la transaccion.
                strSQLTransaction &= "      COMMIT TRANSACTION "
                strSQLTransaction &= "      SET @CodeError = 0 "
                strSQLTransaction &= "END TRY "
                strSQLTransaction &= "BEGIN CATCH "
                strSQLTransaction &= "     SET @CodeError = ERROR_NUMBER() "
                strSQLTransaction &= "     IF @CodeError = 547 "
                'El usuario ya tiene información relacionada con otras tablas del istema, entonces no se puede eliminar.
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = 'No se puede eliminar el registro de entregable del Proyecto porque ya tiene información relacionada en el sistema.'; "
                strSQLTransaction &= "	       END "
                strSQLTransaction &= "	  ELSE "
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = ERROR_MESSAGE(); "
                strSQLTransaction &= "	      END "

                '-- Transaction uncommittable "
                strSQLTransaction &= "    IF (XACT_STATE()) = -1 "
                strSQLTransaction &= "        ROLLBACK TRANSACTION "

                '-- Transaction committable "
                strSQLTransaction &= "     IF (XACT_STATE()) = 1 "
                strSQLTransaction &= "         COMMIT TRANSACTION "
                strSQLTransaction &= " END CATCH"

                Using cmd As New SqlCommand(strSQLTransaction)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDEntregableProyecto As New SqlParameter("@IdTareaProyecto", SqlDbType.BigInt)
                    prmIDEntregableProyecto.Value = Long.Parse(idEntregableProyecto)
                    cmd.Parameters.Add(prmIDEntregableProyecto)

                    Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                    prmCodeError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmCodeError)

                    Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                    prmMessageError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmMessageError)

                    cmd.CommandText = strSQLTransaction
                    cmd.ExecuteNonQuery()

                    If cmd.Parameters("@CodeError").Value > 0 Then
                        respuesta.Codigo = -1
                        respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                    End If

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al eliminar registro deentregable del Proyecto</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Elimina un mensaje del chat.
    ''' </summary>
    ''' <param name="idMensaje">identificador del mensaje del chat.</param>
    ''' <returns>Cadena con información del  estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EliminarMensajeChat(idMensaje As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLUpdate As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLUpdate = "IF EXISTS(SELECT 1 FROM MensajeChat WHERE IdMensaje = @IdMensaje) "
                strSQLUpdate &= "   BEGIN "
                strSQLUpdate &= "        UPDATE MensajeChat "
                strSQLUpdate &= "               SET Eliminado = 1, "
                strSQLUpdate &= "   		              FechaEliminacion = GetDate() "
                strSQLUpdate &= "        WHERE (IdMensaje = @IdMensaje); "
                strSQLUpdate &= "        SET @CodeError = 0; "
                strSQLUpdate &= "	       SET @MessageError = ''Mensaje del chat eliminado éxitosamente.'; "
                strSQLUpdate &= "    END"
                strSQLUpdate &= "ELSE "
                strSQLUpdate &= "    BEGIN "
                strSQLUpdate &= "        SET @CodeError = -1; "
                strSQLUpdate &= "		   SET @MessageError = 'Mensaje del chat no disponible.'; "
                strSQLUpdate &= "    END"

                'Diligencia parámetros
                Dim prmIDMensaje As New SqlParameter("@IdMensaje", SqlDbType.BigInt)
                prmIDMensaje.Value = idMensaje
                cmd.Parameters.Add(prmIDMensaje)

                Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                prmCodeError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmCodeError)

                Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                prmMessageError.Direction = ParameterDirection.Output
                cmd.Parameters.Add(prmMessageError)

                cmd.CommandText = strSQLUpdate
                cmd.ExecuteNonQuery()

                transaction.Commit()

                If cmd.Parameters("@CodeError").Value > 0 Then
                    respuesta.Codigo = -1
                    respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al eliminar mensaje del chat. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Elimina un objetivo del proyecto.
    ''' </summary>
    ''' <param name="idObjetivoProyecto">Identificador de objetivo del proyecto</param>
    ''' <returns>Cadena con información del estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EliminarObjetivoProyecto(idObjetivoProyecto As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLTransaction As String = String.Empty

                strSQLTransaction = "BEGIN TRY "
                strSQLTransaction &= "BEGIN TRANSACTION "
                ' Borra un objetivo del proyecto
                strSQLTransaction &= "      DELETE FROM ObjetivoProyecto WHERE (IdObjetivoProyecto = @IdObjetivoProyecto) "
                ' Si todo sale bien entonces confirma la transaccion.
                strSQLTransaction &= "      COMMIT TRANSACTION "
                strSQLTransaction &= "      SET @CodeError = 0 "
                strSQLTransaction &= "END TRY "
                strSQLTransaction &= "BEGIN CATCH "
                strSQLTransaction &= "     SET @CodeError = ERROR_NUMBER() "
                strSQLTransaction &= "     IF @CodeError = 547 "
                'El usuario ya tiene información relacionada con otras tablas del istema, entonces no se puede eliminar.
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = 'No se puede eliminar este Objetivo del Proyecto porque ya tiene información relacionada en el sistema.'; "
                strSQLTransaction &= "	       END "
                strSQLTransaction &= "	  ELSE "
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = ERROR_MESSAGE(); "
                strSQLTransaction &= "	      END "

                '-- Transaction uncommittable "
                strSQLTransaction &= "    IF (XACT_STATE()) = -1 "
                strSQLTransaction &= "        ROLLBACK TRANSACTION "

                '-- Transaction committable "
                strSQLTransaction &= "     IF (XACT_STATE()) = 1 "
                strSQLTransaction &= "         COMMIT TRANSACTION "
                strSQLTransaction &= " END CATCH"

                Using cmd As New SqlCommand(strSQLTransaction)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDObjetivoProyecto As New SqlParameter("@IdObjetivoProyecto", SqlDbType.BigInt)
                    prmIDObjetivoProyecto.Value = Long.Parse(idObjetivoProyecto)
                    cmd.Parameters.Add(prmIDObjetivoProyecto)

                    Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                    prmCodeError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmCodeError)

                    Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                    prmMessageError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmMessageError)

                    cmd.CommandText = strSQLTransaction
                    cmd.ExecuteNonQuery()

                    If cmd.Parameters("@CodeError").Value > 0 Then
                        respuesta.Codigo = -1
                        respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                    End If

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al eliminar Objetivo del Proyecto</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Elimina un registro de programa académico.
    ''' </summary>
    ''' <param name="idPrograma">Identificador de programa académico</param>
    ''' <returns>Cadena con información del estado final de la operación</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EliminarProgramaAcademico(idPrograma As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLTransaction As String = String.Empty

                strSQLTransaction = "BEGIN TRY "
                strSQLTransaction &= "BEGIN TRANSACTION "
                ' Borra el registro de Empresa
                strSQLTransaction &= "      DELETE FROM ProgramaAcademico WHERE (idPrograma = @idPrograma) "
                ' Si todo sale bien entonces confirma la transaccion.
                strSQLTransaction &= "      COMMIT TRANSACTION "
                strSQLTransaction &= "      SET @CodeError = 0 "
                strSQLTransaction &= "END TRY "
                strSQLTransaction &= "BEGIN CATCH "
                strSQLTransaction &= "     SET @CodeError = ERROR_NUMBER() "
                strSQLTransaction &= "     IF @CodeError = 547 "
                'El usuario ya tiene información relacionada con otras tablas del istema, entonces no se puede eliminar.
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = 'No se puede eliminar este Programa Académico porque ya tiene información relacionada en el sistema.'; "
                strSQLTransaction &= "	       END "
                strSQLTransaction &= "	  ELSE "
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = ERROR_MESSAGE(); "
                strSQLTransaction &= "	      END "

                '-- Transaction uncommittable "
                strSQLTransaction &= "    IF (XACT_STATE()) = -1 "
                strSQLTransaction &= "        ROLLBACK TRANSACTION "

                '-- Transaction committable "
                strSQLTransaction &= "     IF (XACT_STATE()) = 1 "
                strSQLTransaction &= "         COMMIT TRANSACTION "
                strSQLTransaction &= " END CATCH"

                Using cmd As New SqlCommand(strSQLTransaction)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDPrograma As New SqlParameter("@idPrograma", SqlDbType.Int)
                    prmIDPrograma.Value = Short.Parse(idPrograma)
                    cmd.Parameters.Add(prmIDPrograma)

                    Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                    prmCodeError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmCodeError)

                    Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                    prmMessageError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmMessageError)

                    cmd.CommandText = strSQLTransaction
                    cmd.ExecuteNonQuery()

                    If cmd.Parameters("@CodeError").Value > 0 Then
                        respuesta.Codigo = -1
                        respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                    End If

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al eliminar Programa Académico</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Elimina un registro de proyecto de co-creación.
    ''' </summary>
    ''' <param name="idProyecto">Identificador de proyecto de co-creación.</param>
    ''' <returns>Cadena con información del estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EliminarProyecto(idProyecto As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLTransaction As String = String.Empty

                strSQLTransaction = "BEGIN TRY "
                strSQLTransaction &= "BEGIN TRANSACTION "
                ' Borra el registro de Proyecto
                strSQLTransaction &= "      DELETE FROM Proyecto WHERE (IdProyecto = @IdProyecto) "
                ' Si todo sale bien entonces confirma la transaccion.
                strSQLTransaction &= "      COMMIT TRANSACTION "
                strSQLTransaction &= "      SET @CodeError = 0 "
                strSQLTransaction &= "END TRY "
                strSQLTransaction &= "BEGIN CATCH "
                strSQLTransaction &= "     SET @CodeError = ERROR_NUMBER() "
                strSQLTransaction &= "     IF @CodeError = 547 "
                'El proyecto ya tiene información relacionada con otras tablas del istema, entonces no se puede eliminar.
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = 'No se puede eliminar este Proyecto de co-creación porque ya tiene información relacionada en el sistema.'; "
                strSQLTransaction &= "	       END "
                strSQLTransaction &= "	  ELSE "
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = ERROR_MESSAGE(); "
                strSQLTransaction &= "	      END "

                '-- Transaction uncommittable "
                strSQLTransaction &= "    IF (XACT_STATE()) = -1 "
                strSQLTransaction &= "        ROLLBACK TRANSACTION "

                '-- Transaction committable "
                strSQLTransaction &= "     IF (XACT_STATE()) = 1 "
                strSQLTransaction &= "         COMMIT TRANSACTION "
                strSQLTransaction &= " END CATCH"

                Using cmd As New SqlCommand(strSQLTransaction)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                    prmIDProyecto.Value = Long.Parse(idProyecto)
                    cmd.Parameters.Add(prmIDProyecto)

                    Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                    prmCodeError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmCodeError)

                    Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                    prmMessageError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmMessageError)

                    cmd.CommandText = strSQLTransaction
                    cmd.ExecuteNonQuery()

                    If cmd.Parameters("@CodeError").Value > 0 Then
                        respuesta.Codigo = -1
                        respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                    End If

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al eliminar Proyecto de Co-creación</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Elimina un registro de tarea del proyecto.
    ''' </summary>
    ''' <param name="idTareaProyecto">Identificador de tarea del proyecto</param>
    ''' <returns>Cadena con información del estado final de la operación</returns>
    ''' <remarks>Copyright JULC Marzo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EliminarTareaProyecto(idTareaProyecto As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLTransaction As String = String.Empty

                strSQLTransaction = "BEGIN TRY "
                strSQLTransaction &= "BEGIN TRANSACTION "
                ' Borra el registro de Tarea del proyecto
                strSQLTransaction &= "      DELETE FROM TareaProyecto WHERE (IdTareaProyecto = @IdTareaProyecto) "
                ' Si todo sale bien entonces confirma la transaccion.
                strSQLTransaction &= "      COMMIT TRANSACTION "
                strSQLTransaction &= "      SET @CodeError = 0 "
                strSQLTransaction &= "END TRY "
                strSQLTransaction &= "BEGIN CATCH "
                strSQLTransaction &= "     SET @CodeError = ERROR_NUMBER() "
                strSQLTransaction &= "     IF @CodeError = 547 "
                'El usuario ya tiene información relacionada con otras tablas del istema, entonces no se puede eliminar.
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = 'No se puede eliminar esta Tarea del Proyecto porque ya tiene información relacionada en el sistema.'; "
                strSQLTransaction &= "	       END "
                strSQLTransaction &= "	  ELSE "
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = ERROR_MESSAGE(); "
                strSQLTransaction &= "	      END "

                '-- Transaction uncommittable "
                strSQLTransaction &= "    IF (XACT_STATE()) = -1 "
                strSQLTransaction &= "        ROLLBACK TRANSACTION "

                '-- Transaction committable "
                strSQLTransaction &= "     IF (XACT_STATE()) = 1 "
                strSQLTransaction &= "         COMMIT TRANSACTION "
                strSQLTransaction &= " END CATCH"

                Using cmd As New SqlCommand(strSQLTransaction)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDTareaProyecto As New SqlParameter("@IdTareaProyecto", SqlDbType.BigInt)
                    prmIDTareaProyecto.Value = Long.Parse(idTareaProyecto)
                    cmd.Parameters.Add(prmIDTareaProyecto)

                    Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                    prmCodeError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmCodeError)

                    Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                    prmMessageError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmMessageError)

                    cmd.CommandText = strSQLTransaction
                    cmd.ExecuteNonQuery()

                    If cmd.Parameters("@CodeError").Value > 0 Then
                        respuesta.Codigo = -1
                        respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                    End If

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al eliminar Tarea del Proyecto</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Elimina un registro de Usuario junto con su registro de Login. siempre 
    ''' y cuando no tenga información relacionada en el sistema.
    ''' </summary>
    ''' <param name="idUsuario">Identificador de usuariol</param>
    ''' <returns>Cadena con información del estado final de la operación</returns>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function EliminarUsuario(idUsuario As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLTransaction As String = String.Empty

                strSQLTransaction = "BEGIN TRY "
                strSQLTransaction &= "BEGIN TRANSACTION "
                ' Borra el registro de Usuario
                strSQLTransaction &= "      DELETE FROM Usuario WHERE (IdUsuario LIKE @IDUsuario) "
                ' Borra el registro de Login
                strSQLTransaction &= "      DELETE FROM Login WHERE (IdUsuario LIKE @IDUsuario) "
                ' Si todo sale bien entonces confirma la transaccion.
                strSQLTransaction &= "      COMMIT TRANSACTION "
                strSQLTransaction &= "      SET @CodeError = 0 "
                strSQLTransaction &= "END TRY "
                strSQLTransaction &= "BEGIN CATCH "
                strSQLTransaction &= "     SET @CodeError = ERROR_NUMBER() "
                strSQLTransaction &= "     IF @CodeError = 547 "
                'El usuario ya tiene información relacionada con otras tablas del istema, entonces no se puede eliminar.
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = 'No se puede eliminar este usuario porque ya tiene información relacionada en el sistema.'; "
                strSQLTransaction &= "	      END "
                strSQLTransaction &= "	  ELSE "
                strSQLTransaction &= "	       BEGIN "
                strSQLTransaction &= "		        SET @MessageError = ERROR_MESSAGE(); "
                strSQLTransaction &= "	      END "

                '-- Transaction uncommittable "
                strSQLTransaction &= "    IF (XACT_STATE()) = -1 "
                strSQLTransaction &= "        ROLLBACK TRANSACTION "

                '-- Transaction committable "
                strSQLTransaction &= "     IF (XACT_STATE()) = 1 "
                strSQLTransaction &= "         COMMIT TRANSACTION "
                strSQLTransaction &= " END CATCH"

                Using cmd As New SqlCommand(strSQLTransaction)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDUsuario As New SqlParameter("@IDUsuario", SqlDbType.UniqueIdentifier)
                    prmIDUsuario.Value = Guid.Parse(idUsuario)
                    cmd.Parameters.Add(prmIDUsuario)

                    Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.Int)
                    prmCodeError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmCodeError)

                    Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                    prmMessageError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmMessageError)

                    cmd.CommandText = strSQLTransaction
                    cmd.ExecuteNonQuery()

                    If cmd.Parameters("@CodeError").Value > 0 Then
                        respuesta.Codigo = -1
                        respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                    End If

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al eliminar Usuario</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Asegura que el protocolo http de la URL contenga el caracter 's' de seguridad para sitios seguros
    ''' </summary>
    ''' <param name="str"></param>
    ''' <param name="sEndValue"></param>
    ''' <param name="ignoreCase"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function EnsureEndsWith(ByVal str As String, ByVal sEndValue As String, Optional ByVal ignoreCase As Boolean = True) As String
        If (HttpContext.Current.Request.Url.Host.ToString() = "localhost") Then
            If (HttpContext.Current.Request.IsSecureConnection) Then
                If (ignoreCase = True) Then
                    If Not str.EndsWith(sEndValue, StringComparison.CurrentCultureIgnoreCase) Then
                        str = str & sEndValue
                    End If
                Else
                    If Not str.EndsWith(sEndValue) Then
                        str = str & sEndValue
                    End If
                End If
            End If
        End If
        Return str
    End Function

    ''' <summary>
    ''' Actualiza el campo foto del registro de datos del usuairio espeicifcado con el nombre del archivo en disco..
    ''' </summary>
    ''' <param name="idUsuario">Identificador de usuariol</param>
    ''' <param name="nombreArchivoFoto">Nombre del archivo en disco que contiene la fotografía del usuario registrado</param>
    ''' <param name="respuesta">Objeto que encapsula el estado final de la operación.</param>
    ''' <returns>Cadena con información del estado final de la operación</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    Public Function ActualizarNombreArchivoFoto(idUsuario As String, nombreArchivoFoto As String, ByRef respuesta As EstadoOperacion) As Boolean
        Dim estadoOperacion As Boolean = False
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        'Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLTransaction As String = String.Empty

                strSQLTransaction = "BEGIN TRY "
                strSQLTransaction &= "BEGIN TRANSACTION "
                ' Actualiza el registro de Usuario
                strSQLTransaction &= " UPDATE Usuario "
                strSQLTransaction &= "         SET Foto = @Foto "
                strSQLTransaction &= "WHERE (IdUsuario = @IdUsuario) "
                ' Si todo sale bien entonces confirma la transaccion.
                strSQLTransaction &= "      COMMIT TRANSACTION "
                strSQLTransaction &= "      SET @CodeError = 0; "
                strSQLTransaction &= "END TRY "
                strSQLTransaction &= "BEGIN CATCH "
                strSQLTransaction &= "     SET @CodeError = ERROR_NUMBER(); "
                strSQLTransaction &= "	  SET @MessageError = ERROR_MESSAGE(); "
                '-- Transaction uncommittable "
                strSQLTransaction &= "    IF (XACT_STATE()) = -1 "
                strSQLTransaction &= "        ROLLBACK TRANSACTION "
                '-- Transaction committable "
                strSQLTransaction &= "     IF (XACT_STATE()) = 1 "
                strSQLTransaction &= "         COMMIT TRANSACTION "
                strSQLTransaction &= " END CATCH"

                Using cmd As New SqlCommand(strSQLTransaction)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDUsuario As New SqlParameter("@IdUsuario", SqlDbType.UniqueIdentifier)
                    prmIDUsuario.Value = Guid.Parse(idUsuario)
                    cmd.Parameters.Add(prmIDUsuario)

                    Dim prmNombreArchivoFoto As New SqlParameter("@Foto", SqlDbType.NVarChar, -1)
                    If Not String.IsNullOrEmpty(nombreArchivoFoto.Trim) Then
                        prmNombreArchivoFoto.Value = nombreArchivoFoto
                    Else
                        prmNombreArchivoFoto.Value = DBNull.Value
                    End If
                    cmd.Parameters.Add(prmNombreArchivoFoto)

                    Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                    prmCodeError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmCodeError)

                    Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                    prmMessageError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmMessageError)

                    cmd.CommandText = strSQLTransaction
                    cmd.ExecuteNonQuery()

                    If cmd.Parameters("@CodeError").Value > 0 Then
                        respuesta.Codigo = -1
                        respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                    Else
                        estadoOperacion = True
                    End If

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al actualizar el nombre del archivo que contiene la fotografía del usuario.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return estadoOperacion
    End Function

    ''' <summary>
    ''' Actualiza el campo foto del registro de datos de la empresa espeicifcada con el nombre del archivo en disco..
    ''' </summary>
    ''' <param name="idEmpresa">Identificador de empresa</param>
    ''' <param name="nombreArchivoLogo">Nombre del archivo en disco que contiene el logo de la empresa registrada</param>
    ''' <param name="respuesta">Objeto que encapsula el estado final de la operación.</param>
    ''' <returns>Cadena con información del estado final de la operación</returns>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    Public Function ActualizarNombreArchivoLogoEmpresa(idEmpresa As String, nombreArchivoLogo As String, ByRef respuesta As EstadoOperacion) As Boolean
        Dim estadoOperacion As Boolean = False
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        'Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")
        respuesta.ValorDefault = String.Empty

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLTransaction As String = String.Empty

                strSQLTransaction = "BEGIN TRY "
                strSQLTransaction &= "BEGIN TRANSACTION "
                ' Actualiza el registro de Usuario
                strSQLTransaction &= " UPDATE Empresa "
                strSQLTransaction &= "         SET Logo = @Logo "
                strSQLTransaction &= "WHERE (IdEmpresa = @IdEmpresa) "
                ' Si todo sale bien entonces confirma la transaccion.
                strSQLTransaction &= "      COMMIT TRANSACTION "
                strSQLTransaction &= "      SET @CodeError = 0; "
                strSQLTransaction &= "END TRY "
                strSQLTransaction &= "BEGIN CATCH "
                strSQLTransaction &= "     SET @CodeError = ERROR_NUMBER(); "
                strSQLTransaction &= "	  SET @MessageError = ERROR_MESSAGE(); "
                '-- Transaction uncommittable "
                strSQLTransaction &= "    IF (XACT_STATE()) = -1 "
                strSQLTransaction &= "        ROLLBACK TRANSACTION "
                '-- Transaction committable "
                strSQLTransaction &= "     IF (XACT_STATE()) = 1 "
                strSQLTransaction &= "         COMMIT TRANSACTION "
                strSQLTransaction &= " END CATCH"

                Using cmd As New SqlCommand(strSQLTransaction)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDEmpresa As New SqlParameter("@IdEmpresa", SqlDbType.Int)
                    prmIDEmpresa.Value = Integer.Parse(idEmpresa)
                    cmd.Parameters.Add(prmIDEmpresa)

                    Dim prmNombreArchivoLogo As New SqlParameter("@Logo", SqlDbType.NVarChar, -1)
                    If Not String.IsNullOrEmpty(nombreArchivoLogo.Trim) Then
                        prmNombreArchivoLogo.Value = nombreArchivoLogo.Trim
                    Else
                        prmNombreArchivoLogo.Value = DBNull.Value
                    End If
                    cmd.Parameters.Add(prmNombreArchivoLogo)

                    Dim prmCodeError As New SqlParameter("@CodeError", SqlDbType.SmallInt)
                    prmCodeError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmCodeError)

                    Dim prmMessageError As New SqlParameter("@MessageError", SqlDbType.NVarChar, -1)
                    prmMessageError.Direction = ParameterDirection.Output
                    cmd.Parameters.Add(prmMessageError)

                    cmd.CommandText = strSQLTransaction
                    cmd.ExecuteNonQuery()

                    If cmd.Parameters("@CodeError").Value > 0 Then
                        respuesta.Codigo = -1
                        respuesta.Mensaje = cmd.Parameters("@MessageError").Value
                    Else
                        estadoOperacion = True
                    End If

                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al actualizar el nombre del archivo que contiene el logo de la empresa.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return estadoOperacion
    End Function

    ''' <summary>
    ''' Sube el documento al servidor y actualiza ifnormacion del documento wn la tabla Documento.
    ''' </summary>
    ''' <remarks>Copyright JULC Mayo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Sub AgregarDocumentoProyecto()
        'NOTA:   Cuando enviamos datos con FORMDATA a través Ajaz y queremos que el
        '             Web service nos regrese un objeto JSON, debemos tener en cuenta las siguientes condiciones.
        '             Del lado del CLIENTE, en la fun´ción Ajax debe configurar las siguiente propiedas 
        '             a False(contentType, processData), mientras que...
        '             Del lado del SERVIDOR, el método debe retornar el objeto serializdo en JSON
        '             y retornarlo usando el objeto RESPONSE.
        Dim respuesta As New EstadoOperacion("0", "Proceso exitoso")
        Dim dataForm As DataFormDocumento = New DataFormDocumento()

        ' Lee el objeto FormData 
        dataForm.IdProyecto = HttpContext.Current.Request.Form("IdProyecto")
        'dataForm.Nombre = HttpContext.Current.Request.Form("Nombre")
        'dataForm.IdResponsable = HttpContext.Current.Session("IDUsuario")
        'dataForm.IdRol = HttpContext.Current.Session("IDRol")

        'Recupera el archivo
        Dim Files As HttpFileCollection = HttpContext.Current.Request.Files
        For i As Integer = 0 To Files.Count - 1
            dataForm.Archivo = Files(i)
        Next i

        Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")
        Dim IdDocumento As Guid = Guid.NewGuid()
        Dim extension As String = System.IO.Path.GetExtension(dataForm.Archivo.FileName)
        Dim nombreDocumentoServidor As String = String.Format("CS{0}_PRY{1}_DOC_{2}{3}", idCentroServicio, dataForm.IdProyecto.ToString("D6"), IdDocumento.ToString().ToUpper(), extension)

        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim sbMensaje As StringBuilder = New StringBuilder()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim cmd As SqlCommand = connection.CreateCommand()
            Dim transaction As SqlTransaction

            transaction = connection.BeginTransaction("Bocore")
            cmd.Connection = connection
            cmd.Transaction = transaction

            Try
                Dim strSQLInsert As String = String.Empty
                Dim registrosAfectados As Integer = -1

                strSQLInsert = " INSERT INTO Documento ("
                strSQLInsert &= "          IdDocumento, "
                strSQLInsert &= "          IdProyecto, "
                strSQLInsert &= "          NombreOriginalDocumento, "
                strSQLInsert &= "          NombreArchivoServidor, "
                strSQLInsert &= "          IdResponsable, "
                strSQLInsert &= "          IdRol, "
                strSQLInsert &= "          FechaRegistro, "
                strSQLInsert &= "          FechaActualizacion) "
                strSQLInsert &= "     VALUES ("
                strSQLInsert &= "          @IdDocumento, "
                strSQLInsert &= "          @IdProyecto, "
                strSQLInsert &= "          @NombreOriginalDocumento, "
                strSQLInsert &= "          @NombreArchivoServidor, "
                strSQLInsert &= "          @IdResponsable, "
                strSQLInsert &= "          @IdRol, "
                strSQLInsert &= "          GETDATE(), "
                strSQLInsert &= "          GETDATE()); "

                'Diligencia parámetros
                Dim prmIDDocumento As New SqlParameter("@IdDocumento", SqlDbType.UniqueIdentifier)
                prmIDDocumento.Value = IdDocumento
                cmd.Parameters.Add(prmIDDocumento)

                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = dataForm.IdProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Dim prmNombreOriginalDocumento As New SqlParameter("@NombreOriginalDocumento", SqlDbType.NVarChar, -1)
                prmNombreOriginalDocumento.Value = dataForm.Archivo.FileName
                cmd.Parameters.Add(prmNombreOriginalDocumento)

                Dim prmNombreArchivoServidor As New SqlParameter("@NombreArchivoServidor", SqlDbType.NVarChar, -1)
                prmNombreArchivoServidor.Value = nombreDocumentoServidor
                cmd.Parameters.Add(prmNombreArchivoServidor)

                Dim prmIDResponsable As New SqlParameter("@IdResponsable", SqlDbType.UniqueIdentifier)
                prmIDResponsable.Value = Guid.Parse(HttpContext.Current.Session("IDUsuario").ToString())
                cmd.Parameters.Add(prmIDResponsable)

                Dim prmIDRol As New SqlParameter("@IdRol", SqlDbType.TinyInt)
                prmIDRol.Value = HttpContext.Current.Session("IDRol")
                cmd.Parameters.Add(prmIDRol)

                cmd.CommandText = strSQLInsert
                cmd.ExecuteNonQuery()

                Dim urlDocumento As String = String.Empty
                If GuardarDocumentoServidor(dataForm, idCentroServicio, IdDocumento, nombreDocumentoServidor, urlDocumento, respuesta) Then
                    Dim documento As DataDocumentoDTO = New DataDocumentoDTO()

                    documento.IdDocumento = IdDocumento.ToString()
                    documento.IdProyecto = dataForm.IdProyecto
                    documento.NombreArchivo = Path.GetFileNameWithoutExtension(dataForm.Archivo.FileName)
                    documento.URL = urlDocumento
                    documento.Responsable = HttpContext.Current.Session("NombreUsuarioLoggeado")
                    documento.FechaRegistro = DateTime.Now.ToString("dd-MMM-yyyy hh:mm:ss")
                    'Retorna un objeto con información del nuevo documento vinculado al proyecto actual.
                    respuesta.Resultado = documento

                    transaction.Commit()
                Else
                    transaction.Rollback()
                End If

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al registrar un documento nuevo al proyecto especificado. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                respuesta.Codigo = "-1"
                respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using

        'Dim documento As DataDocumentoDTO = New DataDocumentoDTO()

        'documento.IdDocumento = "95403295-5E84-4F5C-A636-02A071EF254F"
        'documento.IdProyecto = dataForm.IdProyecto
        'documento.Nombre = dataForm.Archivo.FileName
        'documento.Responsable = HttpContext.Current.Session("NombreUsuarioLoggeado")
        'documento.FechaRegistro = DateTime.Now.ToString("dd-MMM-yyyy hh:mm:ss")
        ''Retorna un objeto con información del nuevo documento vinculado al proyecto actual.
        'respuesta.Resultado = documento

        Context.Response.Write(New JavaScriptSerializer().Serialize(respuesta))
    End Sub

    ''' <summary>
    ''' Recupera información del centro de servicio especificado.
    ''' </summary>
    ''' <param name="idCentroServicio">Identificador de centro de servicio.</param>
    ''' <returns>Información del centro de servicio especificado</returns>
    ''' <remarks>Copyright JULC Mayo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ObtenerInformacionCentroServicio(idCentroServicio As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT Nombre, "
                strSQLSelect &= "               Descripcion, "
                strSQLSelect &= "               QuienesSomos, "
                strSQLSelect &= "               Mision, "
                strSQLSelect &= "               Vision, "
                strSQLSelect &= "               Servicios "
                strSQLSelect &= "   FROM CentroServicio "
                strSQLSelect &= "WHERE (IdCentroServicio = @IdCentroServicio) "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDCentroServicio As New SqlParameter("@IdCentroServicio", SqlDbType.TinyInt)
                    prmIDCentroServicio.Value = idCentroServicio
                    cmd.Parameters.Add(prmIDCentroServicio)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim centroServicio As New DataInfoCentroServicioDTO

                                centroServicio.Nombre = sdr("Nombre").ToString()
                                centroServicio.Descripcion = sdr("Descripcion").ToString()
                                centroServicio.QuienesSomos = sdr("QuienesSomos").ToString()
                                centroServicio.Mision = sdr("Mision").ToString()
                                centroServicio.Vision = sdr("Vision").ToString()
                                centroServicio.Servicios = sdr("Servicios").ToString()

                                respuesta.Resultado = centroServicio
                            End While

                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay información sobre el centro de servicio especificado."
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar información sobre el centro de servicio especificado.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Recupera información del proyecto especificado.
    ''' </summary>
    ''' <param name="idProyecto">Identificador de proyecto.</param>
    ''' <returns>Información del proyecto especificado</returns>
    ''' <remarks>Copyright JULC Mayo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ObtenerInformarcionProyecto(idProyecto As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT TOP 1 PRY.ProgramaAcademico, "
                strSQLSelect &= "               PRY.FechaRegistro AS FechaInicio, "
                strSQLSelect &= "               EPR.Celular1, "
                strSQLSelect &= "               EPR.Celular2, "
                strSQLSelect &= "               EPR.Telefono1, "
                strSQLSelect &= "               EPR.Telefono2, "
                strSQLSelect &= "               MDL.Descripcion AS Modalidad, "
                strSQLSelect &= "               EPR.Email, "
                strSQLSelect &= "               CONCAT(USR.Nombres, ' ', USR.Apellidos) AS Coordinador "
                strSQLSelect &= "   FROM Proyecto AS PRY INNER JOIN Empresa AS EPR "
                strSQLSelect &= "        ON PRY.IdEmpresa = EPR.IdEmpresa INNER JOIN Modalidad AS MDL "
                strSQLSelect &= "	     ON PRY.IdModalidad = MDL.IdModalidad INNER JOIN ParticipanteProyecto AS PPY "
                strSQLSelect &= "	     ON PRY.IdProyecto = PPY.IdProyecto INNER JOIN Usuario AS USR "
                strSQLSelect &= "	     ON PRY.IdUsuario = USR.IdUsuario "
                strSQLSelect &= "WHERE (PRY.IdProyecto = @IdProyecto) "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                    prmIDProyecto.Value = idProyecto
                    cmd.Parameters.Add(prmIDProyecto)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim informacionEmpresa As String = String.Empty

                                If Not sdr.IsDBNull(sdr.GetOrdinal("Celular1")) Then
                                    informacionEmpresa = sdr("Celular1").ToString()
                                End If
                                If Not sdr.IsDBNull(sdr.GetOrdinal("Celular2")) Then
                                    informacionEmpresa = String.Format("{0}, {1}", informacionEmpresa, sdr("Celular2").ToString())
                                End If
                                If Not sdr.IsDBNull(sdr.GetOrdinal("Telefono1")) Then
                                    informacionEmpresa = String.Format("{0}, {1}", informacionEmpresa, sdr("Telefono1").ToString())
                                End If
                                If Not sdr.IsDBNull(sdr.GetOrdinal("Telefono2")) Then
                                    informacionEmpresa = String.Format("{0}, {1}", informacionEmpresa, sdr("Telefono2").ToString())
                                End If

                                Dim proyecto As New DataInfoProyectoDTO

                                proyecto.ProgramaAcademico = sdr("ProgramaAcademico").ToString()
                                proyecto.InformacionEmpresa = informacionEmpresa
                                proyecto.Email = sdr("Email").ToString()
                                proyecto.FechaInicio = DateTime.Parse(sdr("FechaInicio")).ToString("dd-MMM-yyyy")
                                proyecto.Modalidad = sdr("Modalidad").ToString()
                                proyecto.Coordinador = sdr("Coordinador").ToString()

                                respuesta.Resultado = proyecto
                            End While

                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay información sobre el proyecto especificado."
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar información sobre el proyecto especificado.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Recupera información del proyecto (reto) especificado.
    ''' </summary>
    ''' <param name="idProyecto">Identificador de proyecto o reto.</param>
    ''' <returns>Información del proyecto especificado</returns>
    ''' <remarks>Copyright JULC Mayo 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function ObtenerInformarcionReto(idProyecto As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT PRY.Descripcion AS DescReto, "
                strSQLSelect &= "             PRY.Alcance, "
                strSQLSelect &= "             PRY.ObjetivoMinimo, "
                strSQLSelect &= "             EMP.Descripcion AS DescEmpresa "
                strSQLSelect &= "  FROM Proyecto AS PRY INNER JOIN Empresa AS EMP "
                strSQLSelect &= "       ON PRY.IdEmpresa = EMP.IdEmpresa "
                strSQLSelect &= "WHERE (PRY.IdProyecto = @IdProyecto) "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                    prmIDProyecto.Value = idProyecto
                    cmd.Parameters.Add(prmIDProyecto)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            While sdr.Read()
                                Dim infoReto As New DataInfoRetoDTO

                                infoReto.Alcance = sdr("Alcance").ToString()
                                infoReto.DescEmpresa = sdr("DescEmpresa").ToString()
                                infoReto.DescReto = sdr("DescReto").ToString()
                                infoReto.ObjetivoMinimo = sdr("ObjetivoMinimo").ToString()

                                respuesta.Resultado = infoReto
                            End While

                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "No hay información sobre el reto especificado."
                        End If

                    End Using 'sdr
                End Using

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("<b>Error al recuperar información sobre el reto especificado.</b>. Mensaje: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    Private Function ObtenerURLBase() As String
        'Genera la URL base para la imagen guardada en el servidor
        Dim lpscheme = HttpContext.Current.Request.Url.Scheme
        lpscheme = EnsureEndsWith(lpscheme, "s", True)

        'Genera la URL base para la imagen guardada en el servidor
        Dim urlBase As String = String.Format("{0}://{1}{2}{3}", lpscheme, HttpContext.Current.Request.Url.Host, IIf(HttpContext.Current.Request.Url.IsDefaultPort, "", String.Format(":{0}", HttpContext.Current.Request.Url.Port.ToString())), HttpContext.Current.Request.ApplicationPath)
        If Not urlBase.EndsWith("/") Then
            urlBase += "/"
        End If

        Return urlBase
    End Function

    ''' <summary>
    ''' Gurarda el documento como archivo en el servidor.
    ''' </summary>
    ''' <param name="dataForm">Objeto que contiene información del nuevo documento aportado al proyecto.especificado.</param>
    ''' <param name="idCentroServicio">Identificador de centro de servicio.</param>
    ''' <param name="idDocumento">Identificador de documento</param>
    ''' <param name="nombreDocumentoServidor">Nombre del documento como archivo en el servidor</param>
    ''' <param name="urlDocumento">URL del documento en el servidor</param>
    ''' <param name="respuesta">Objeto que encapsula el estado final de la operación.</param>
    ''' <returns>Un indicador que determina si la operación tubo o no éxito.</returns>
    ''' <remarks>Copyright JULC Mayo 2021</remarks>''' 
    Private Function GuardarDocumentoServidor(dataForm As DataFormDocumento, idCentroServicio As String, idDocumento As Guid, nombreDocumentoServidor As String, ByRef urlDocumento As String, ByRef respuesta As EstadoOperacion) As Boolean
        Dim estadoOperacion As Boolean = False

        Try
            'Guardar el arreglo de bytes como Archivo.
            Dim fs As Stream = dataForm.Archivo.InputStream
            Dim br As BinaryReader = New BinaryReader(fs)
            Dim bytes As Byte() = br.ReadBytes(CType(fs.Length, Int32))

            'Mapea el directorio Usuarios del Centro de Servicios especificado.
            Dim folderDocumentos = String.Format(Server.MapPath("~/Files/CentroServicio{0}/Proyectos/{1}/Documentos"), idCentroServicio, dataForm.IdProyecto.ToString("D6"))
            If Not Directory.Exists(folderDocumentos) Then
                Directory.CreateDirectory(folderDocumentos)
            End If

            Dim urlBase As String = ObtenerURLBase()
            urlDocumento = String.Format("{0}Files/CentroServicio{1}/Proyectos/{2}/Documentos/{3}", urlBase, idCentroServicio, dataForm.IdProyecto.ToString("D6"), nombreDocumentoServidor)

            Dim rutaArchivo As String = String.Format("{0}\{1}", folderDocumentos, nombreDocumentoServidor)
            File.WriteAllBytes(rutaArchivo, bytes)

            estadoOperacion = True

        Catch ex As Exception
            respuesta.Codigo = "-1"
            respuesta.Mensaje = String.Format("Error al guardar documento como archivo en el servidor: {0}", ex.Message)
        End Try

        Return estadoOperacion
    End Function


    ''' <summary>
    ''' Sube el archivo al servidor y actualiza ifnormacion del archivo wn la tabla Alumno.
    ''' </summary>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Sub GuardarFoto()
        'NOTA:   Cuando enviamos datos con FORMDATA a través Ajaz y queremos que el
        '             Web service nos regrese un objeto JSON, debemos tener en cuenta las siguientes condiciones.
        '             Del lado del CLIENTE, en la fun´ción Ajax debe configurar las siguiente propiedas 
        '             a False(contentType, processData), mientras que...
        '             Del lado del SERVIDOR, el método debe retornar el objeto serializdo en JSON
        '             y retornarlo usando el objeto RESPONSE.
        Dim respuesta As New EstadoOperacion("0", "Proceso exitoso")
        Dim dataForm As DataFormFoto = New DataFormFoto()

        ' Lee el objeto FormData 
        dataForm.IdUsuario = HttpContext.Current.Request.Form("IdUsuario")
        dataForm.NombreUsuario = HttpContext.Current.Request.Form("NombreUsuario")
        dataForm.Extension = HttpContext.Current.Request.Form("Extension")
        dataForm.Tipo = HttpContext.Current.Request.Form("Tipo")

        'Recupera el archivo
        Dim Files As HttpFileCollection = HttpContext.Current.Request.Files
        For i As Integer = 0 To Files.Count - 1
            dataForm.Archivo = Files(i)
        Next i

        Try
            'Guardar el arreglo de bytes como Archivo.
            Dim fs As Stream = dataForm.Archivo.InputStream
            Dim br As BinaryReader = New BinaryReader(fs)
            Dim bytes As Byte() = br.ReadBytes(CType(fs.Length, Int32))
            Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")
            Dim nuevoGuid As Guid = Guid.NewGuid()
            Dim nombreArchivoFotoServidor As String = String.Format("{0}_{1}.{2}", nuevoGuid.ToString, dataForm.NombreUsuario, dataForm.Extension)

            'Mapea el directorio Usuarios del Centro de Servicios especificado.
            Dim folderUsuarios = String.Format(Server.MapPath("~/Files/CentroServicio{0}/Usuarios"), idCentroServicio)
            If Not Directory.Exists(folderUsuarios) Then
                Directory.CreateDirectory(folderUsuarios)
            End If

            Dim rutaArchivo As String = String.Format("{0}\{1}", folderUsuarios, nombreArchivoFotoServidor)
            File.WriteAllBytes(rutaArchivo, bytes)

            If ActualizarNombreArchivoFoto(dataForm.IdUsuario, nombreArchivoFotoServidor, respuesta) Then
                respuesta.Codigo = "0"
                respuesta.Mensaje = "Proceso exitoso"
                respuesta.Resultado = nombreArchivoFotoServidor
            End If

        Catch ex As Exception
            respuesta.Codigo = "-1"
            respuesta.Mensaje = String.Format("Error al guardar archivo de fotografía del usuario en el servidor: {0}", ex.Message)
        End Try

        Context.Response.Write(New JavaScriptSerializer().Serialize(respuesta))
    End Sub

    ''' <summary>
    ''' Sube y guarda en el servidor el logo de la empresa especificada .
    ''' </summary>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Sub GuardarLogoEmpresa()
        'NOTA:   Cuando enviamos datos con FORMDATA a través Ajaz y queremos que el
        '             Web service nos regrese un objeto JSON, debemos tener en cuenta las siguientes condiciones.
        '             Del lado del CLIENTE, en la fun´ción Ajax debe configurar las siguiente propiedas 
        '             a False(contentType, processData), mientras que...
        '             del lado del SERVIDOR, el método debe retornar el objeto serializdo en JSON
        '             y retornarlo usando el objeto RESPONSE.
        Dim respuesta As New EstadoOperacion("0", "Proceso exitoso")
        Dim dataForm As DataFormLogo = New DataFormLogo()

        ' Lee el objeto FormData 
        dataForm.IdEmpresa = HttpContext.Current.Request.Form("IdEmpresa")
        dataForm.NombreEmpresa = HttpContext.Current.Request.Form("NombreEmpresa")
        dataForm.Extension = HttpContext.Current.Request.Form("Extension")
        dataForm.Tipo = HttpContext.Current.Request.Form("Tipo")

        'Recupera el archivo
        Dim Files As HttpFileCollection = HttpContext.Current.Request.Files
        For i As Integer = 0 To Files.Count - 1
            dataForm.Archivo = Files(i)
        Next i

        Try
            'Guardar el arreglo de bytes como Archivo.
            Dim fs As Stream = dataForm.Archivo.InputStream
            Dim br As BinaryReader = New BinaryReader(fs)
            Dim bytes As Byte() = br.ReadBytes(CType(fs.Length, Int32))
            Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")
            Dim nuevoGuid As Guid = Guid.NewGuid()
            Dim nombreArchivoLogoServidor As String = String.Format("{0}_{1}.{2}", nuevoGuid.ToString, dataForm.NombreEmpresa, dataForm.Extension)

            'Mapea el directorio Usuarios del Centro de Servicios especificado.
            Dim folderEmpresas = Server.MapPath("~/Files/Empresas")
            If Not Directory.Exists(folderEmpresas) Then
                Directory.CreateDirectory(folderEmpresas)
            End If

            Dim rutaArchivo As String = String.Format("{0}\{1}", folderEmpresas, nombreArchivoLogoServidor)
            File.WriteAllBytes(rutaArchivo, bytes)

            If ActualizarNombreArchivoLogoEmpresa(dataForm.IdEmpresa, nombreArchivoLogoServidor, respuesta) Then
                respuesta.Codigo = "0"
                respuesta.Mensaje = "Proceso exitoso"
                respuesta.Resultado = nombreArchivoLogoServidor
            End If

        Catch ex As Exception
            respuesta.Codigo = "-1"
            respuesta.Mensaje = String.Format("Error al guardar logo de la empresa en el servidor: {0}", ex.Message)
        End Try

        Context.Response.Write(New JavaScriptSerializer().Serialize(respuesta))
    End Sub

    ''' <summary>
    ''' Elimina el archivo que contiene la fotografía del usuario y actualiza iinformación el campo Foto..
    ''' </summary>
    ''' <param name="idUsuario">Identificador de usuario</param>
    ''' <param name="nombreArchivoFotoServidor">Nombre del archivo en disco que contiene la fotografía del usuario</param>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function RemoverFoto(idUsuario As String, nombreArchivoFotoServidor As String) As String
        Dim respuesta As New EstadoOperacion("0", "Proceso exitoso")

        Try
            Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")

            'Mapea el directorio Usuarios del Centro de Servicios especificado.
            Dim folderUsuarios = String.Format(Server.MapPath("~/Files/CentroServicio{0}/Usuarios"), idCentroServicio)
            If Not Directory.Exists(folderUsuarios) Then
                Directory.CreateDirectory(folderUsuarios)
            End If

            Dim rutaArchivo As String = String.Format("{0}\{1}", folderUsuarios, nombreArchivoFotoServidor)
            If File.Exists(rutaArchivo) Then
                File.Delete(rutaArchivo)
            End If

            'Marca como nulo el campo Foto del registro de datos del usuario especiifcado
            If ActualizarNombreArchivoFoto(idUsuario, String.Empty, respuesta) Then
                respuesta.Codigo = "0"
                respuesta.Mensaje = "Proceso exitoso"
            End If

        Catch ex As Exception
            respuesta.Codigo = "-1"
            respuesta.Mensaje = String.Format("Error al remover fotografía del usuario especificado: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

    ''' <summary>
    ''' Elimina el archivo que contiene el logo de la empresa y actualiza iinformación el campo Logo.
    ''' </summary>
    ''' <param name="idEmpresa">Identificador de empresa</param>
    ''' <param name="nombreArchivoLogoServidor">Nombre del archivo en disco que contiene el logo empresarial.</param>
    ''' <remarks>Copyright JULC Abril 2021</remarks>
    <WebMethod(EnableSession:=True)>
    <ScriptMethod(UseHttpGet:=False, ResponseFormat:=ResponseFormat.Json)>
    Public Function RemoverLogoEmpresa(idEmpresa As String, nombreArchivoLogoServidor As String) As String
        Dim respuesta As New EstadoOperacion("0", "Proceso exitoso")

        Try
            'Dim idCentroServicio As String = HttpContext.Current.Session("IDCentroServicio")

            'Mapea el directorio Empresas
            Dim folderEmpresas = Server.MapPath("~/Files/Empresas")
            If Not Directory.Exists(folderEmpresas) Then
                Directory.CreateDirectory(folderEmpresas)
            End If

            Dim rutaArchivo As String = String.Format("{0}\{1}", folderEmpresas, nombreArchivoLogoServidor)
            If File.Exists(rutaArchivo) Then
                File.Delete(rutaArchivo)
            End If

            'Marca como nulo el campo Logo del registro de datos empresarial especiifcado
            If ActualizarNombreArchivoLogoEmpresa(idEmpresa, String.Empty, respuesta) Then
                respuesta.Codigo = "0"
                respuesta.Mensaje = "Proceso exitoso"
            End If

        Catch ex As Exception
            respuesta.Codigo = "-1"
            respuesta.Mensaje = String.Format("Error al remover logo del perfil empresarial: {0}", ex.Message)
        End Try

        Return New JavaScriptSerializer().Serialize(respuesta)
    End Function

End Class
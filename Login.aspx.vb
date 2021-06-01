'Form Validation
'https://www.w3schools.com/bootstrap4/bootstrap_forms.asp
'Exploring Client Callback
'https://codewala.net/tag/codeproject/page/3/
'How to know which version of ASP.net it is?
'https://stackoverflow.com/questions/5161529/how-to-know-which-version-of-asp-net-it-is

Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Configuration.ConfigurationManager
Imports Jayrock.Json.Conversion
Imports System.Web.Script.Serialization

Partial Class Login
    Inherits System.Web.UI.Page
    Implements System.Web.UI.ICallbackEventHandler

    Private Class ParametrosCallbackCliente
        Public IdCallback As String
        Public Parametro As String
    End Class

    Private Class DataLogin
        Public IdCallback As String
        Public Usuario As String
        Public Contrasena As String
    End Class

    Private Class DataRespuestaLogin
        Public IdCentroServicio As String
        Public IdLogin As String
        Public IdUsuario As String
        Public Nombre As String
        Public IdRol As String
    End Class

    Private Class EstadoOperacion
        Public Codigo As String
        Public Mensaje As String
        Public Resultado As Object
        ' Constructor
        Public Sub New(ByVal codigoEO As String, ByVal mensajeEO As String)
            Codigo = codigoEO
            Mensaje = mensajeEO
        End Sub 'New
    End Class

    'Private arrRespuestaCallback(0) As RespuestaCallbackJSON

#Region "Variables de Sesión - Set/Get datos de sesión. "
    ''' <summary>
    ''' Devuelve o establece el centro de servicio.
    ''' </summary>
    ''' <remarks>Copyright (c) Marzo 2021 - JULC</remarks>
    Public Property IDCentroServicio() As Integer
        Get
            Return HttpContext.Current.Session("IDCentroServicio")
        End Get
        Set(ByVal value As Integer)
            HttpContext.Current.Session("IDCentroServicio") = value
        End Set
    End Property

    ''' <summary>
    ''' Devuelve o establece el identificador de usuario.
    ''' </summary>
    ''' <remarks>Copyright (c) Marzo 2021 - JULC</remarks>
    Public Property IDRol() As Byte
        Get
            Return HttpContext.Current.Session("IDRol")
        End Get
        Set(ByVal value As Byte)
            HttpContext.Current.Session("IDRol") = value
        End Set
    End Property

    ''' <summary>
    ''' Devuelve o establece el valor inicial de la cuenta regresiva
    ''' </summary>
    ''' <value>Valor inicial de la cuenta regresiva</value>
    ''' <returns>Valor inicial de la cuenta regresiva</returns>
    ''' <remarks>Copyright (c) Abril 2018 - JULC</remarks>
    Public Property IDUsuario() As Guid
        Get
            Return HttpContext.Current.Session("IDUsuario")
        End Get
        Set(ByVal value As Guid)
            HttpContext.Current.Session("IDUsuario") = value
        End Set
    End Property

    ''' <summary>
    ''' Devuelve o establece el nombre del usuario loggeado.
    ''' </summary>
    ''' <remarks>Copyright (c) Marzo 2021 - JULC</remarks>
    Public Property NombreUsuarioLoggeado() As String
        Get
            Return HttpContext.Current.Session("NombreUsuarioLoggeado")
        End Get
        Set(ByVal value As String)
            HttpContext.Current.Session("NombreUsuarioLoggeado") = value
        End Set
    End Property
#End Region

    Private Sub Login_Load(sender As Object, e As EventArgs) Handles Me.Load
        'If Me.User.Identity.IsAuthenticated Then
        If Me.IsCallback Then
            Return
        End If

        '--------------------------------------------------------------------------------
        ' 1. Validar Credenciales de Usuario
        '--------------------------------------------------------------------------------
        'Creating a reference of Client side Method, that Is called after callback on server
        Dim cbReference As String = Page.ClientScript.GetCallbackEventReference(Me, "arg", "ReceiveServerValidarCredenciales", "")

        'Putting the reference in the method that will initiate Callback
        Dim callbackScript As String = "function CallValidarCredenciales(arg, context) {" & cbReference & "; }"

        'Registering the method
        Page.ClientScript.RegisterClientScriptBlock(Me.GetType(), "CallValidarCredenciales", callbackScript, True)

        'MostrarInformacionASPNet()
    End Sub

    Public Sub MostrarInformacionASPNet()
        Dim cmnNETver, cmnNETsplt, dotNETver, dotNETsplt, aspNETver, aspNETsplt As Object
        Dim osVersion, dotNETfil, aspNETfil, cmnNETfix, dotNETpth, dotNETtxt, dotNETfix, aspNETpth, aspNETtxt, aspNETfix As String

        osVersion = System.Environment.OSVersion.ToString

        dotNETfil = "ngen.exe"
        aspNETfil = "clr.dll"

        cmnNETver = System.Environment.Version.ToString
        cmnNETsplt = cmnNETver.Split(".")
        cmnNETfix = cmnNETsplt(0) & "." & cmnNETsplt(1) & "." & cmnNETsplt(2)

        dotNETpth = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Windows) & "\Microsoft.NET\Framework64\v" & cmnNETfix & "\" & dotNETfil

        If System.IO.File.Exists(dotNETpth) Then
            dotNETver = System.Diagnostics.FileVersionInfo.GetVersionInfo(dotNETpth)
            dotNETtxt = dotNETver.FileVersion.ToString
            dotNETsplt = dotNETtxt.Split(" ")
            dotNETfix = dotNETsplt(0) & " per " & dotNETfil
        Else
            dotNETfix = "Ruta no encontrada... Versión no encontrada..."
        End If

        aspNETpth = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Windows) & "\Microsoft.NET\Framework64\v" & cmnNETfix & "\" & aspNETfil

        If System.IO.File.Exists(aspNETpth) Then
            aspNETver = System.Diagnostics.FileVersionInfo.GetVersionInfo(aspNETpth)
            aspNETtxt = aspNETver.FileVersion.ToString
            aspNETsplt = aspNETtxt.Split(" ")
            aspNETfix = aspNETsplt(0) & " per " & aspNETfil
        Else
            aspNETfix = "Path not found... No version found..."
        End If

        Response.Write("Common MS.NET version: " & cmnNETver & "<br>")
        Response.Write("Common MS.NET path number: " & cmnNETfix & "<br>")
        Response.Write("Microsoft.NET full path: " & dotNETpth & "<br>")
        Response.Write("<b>Microsoft.NET version: " & dotNETfix & "</b><br>")
        Response.Write("ASP.NET full path: " & aspNETpth & "<br>")
        Response.Write("<b>ASP.NET version: " & aspNETfix & "</b><br>")
        Response.Write("OS version: " & osVersion & "<br>")
    End Sub

#Region "Metodos Personalizados"
    ''' <summary>
    ''' Inicia sesión sin Postback
    ''' <paramref name="idataRespuestaLogin"/>
    ''' <paramref name="respuesta"/>
    ''' </summary>
    ''' <remarks>Copyright JULC 2021</remarks>
    Private Function IniciarSesion(dataRespuestaLogin As DataRespuestaLogin, ByRef respuesta As EstadoOperacion) As Boolean
        Dim estadoOperacion As Boolean = False

        'Para limpiar autenticacion
        Try
            FormsAuthentication.SignOut()
        Catch ex As System.Exception
        End Try

        'Para autenticar
        Try
            FormsAuthentication.SetAuthCookie("Usuario", False)

            Me.IDCentroServicio = Short.Parse(dataRespuestaLogin.IdCentroServicio)
            Me.IDUsuario = Guid.Parse(dataRespuestaLogin.IdUsuario)
            Me.NombreUsuarioLoggeado = dataRespuestaLogin.Nombre
            Me.IDRol = Short.Parse(dataRespuestaLogin.IdRol)

            estadoOperacion = True

            'Response.Redirect("Dashboard.aspx")
        Catch ex As System.Exception
            respuesta.Codigo = "-1"
            respuesta.Mensaje = ex.Message
        End Try

        Return estadoOperacion
    End Function

    ''' <summary>
    ''' Valida las credenciales del usuario que se está loggeando..
    ''' </summary>
    ''' <param name="dataLogin">Objeto que contiene información sobre las credenciales del usuario</param>
    ''' <param name="respuesta">Objeto que retorna información sobre el resultado de la operación.</param>
    ''' <remarks>Copyright JULC Enero 2021</remarks>
    Private Function ValidarCredenciales(dataLogin As DataLogin, ByRef respuesta As EstadoOperacion) As Boolean
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim estadoOperacion As Boolean = False

        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim strSQLSelect As String = String.Empty

                strSQLSelect = "SELECT USR.IdCentroServicio, "
                strSQLSelect &= "             USR.IdRol, "
                strSQLSelect &= "             USR.IdUsuario, "
                strSQLSelect &= "             LGN.IdLogin, "
                strSQLSelect &= "             CONCAT(USR.Nombres, ' ', USR.Apellidos) AS Nombre "
                strSQLSelect &= "   FROM Usuario AS USR INNER JOIN Login AS LGN "
                strSQLSelect &= "        ON USR.IdUsuario = LGN.IdUsuario "
                strSQLSelect &= "WHERE (LGN.Usuario = @Usuario) "
                strSQLSelect &= "      AND (LGN.Contrasena = @Contrasena) "

                Using cmd As New SqlCommand(strSQLSelect)
                    cmd.Connection = connection
                    cmd.CommandType = CommandType.Text

                    Dim prmUsuario As New SqlParameter("@Usuario", SqlDbType.NVarChar, 20)
                    prmUsuario.Value = dataLogin.Usuario.ToString.Trim()
                    cmd.Parameters.Add(prmUsuario)

                    Dim prmContrasena As New SqlParameter("@Contrasena", SqlDbType.NVarChar, 20)
                    prmContrasena.Value = dataLogin.Contrasena.Trim()
                    cmd.Parameters.Add(prmContrasena)

                    Using sdr As SqlDataReader = cmd.ExecuteReader()
                        If sdr.HasRows Then
                            Dim dataRespuestaLogin As New DataRespuestaLogin

                            While sdr.Read()
                                dataRespuestaLogin.IdLogin = sdr("IdLogin").ToString()
                                dataRespuestaLogin.IdCentroServicio = sdr("IdCentroServicio").ToString()
                                dataRespuestaLogin.IdUsuario = sdr("IdUsuario").ToString()
                                dataRespuestaLogin.IdRol = sdr("IdRol").ToString()
                                dataRespuestaLogin.Nombre = sdr("Nombre").ToString()
                            End While
                            respuesta.Resultado = dataRespuestaLogin
                            estadoOperacion = True

                        Else 'Esto no deberá ocurrir nunca.
                            respuesta.Codigo = -1
                            respuesta.Mensaje = "Usuario o Contraseña no válidos"
                            HttpContext.Current.Session("IDCentroServicio") = Nothing
                        End If
                    End Using 'sdr
                End Using 'Estudiante

                connection.Close()
            End Using

        Catch ex As Exception
            respuesta.Codigo = -1
            respuesta.Mensaje = String.Format("Error al autenticar usuario. Mensaje: {0}", ex.Message)
        End Try

        Return estadoOperacion
    End Function

#End Region

#Region "Implementación Métodos CallBack"
    Protected valorRetorno As String

    ''' <summary>
    ''' Recupera la petición del cliente.
    ''' </summary>
    ''' <param name="jsonParametrosCliente"></param> 
    Public Sub RaiseCallbackEvent(jsonParametrosCliente As String) Implements ICallbackEventHandler.RaiseCallbackEvent
        Dim respuesta As New EstadoOperacion(0, "Proceso exitoso")

        Dim serializador As JavaScriptSerializer = New JavaScriptSerializer()
        Dim dataLogin As DataLogin = serializador.Deserialize(Of DataLogin)(jsonParametrosCliente)

        If ValidarCredenciales(dataLogin, respuesta) Then
            If IniciarSesion(respuesta.Resultado, respuesta) Then
            End If
        End If

        'valorRetorno = JsonConvert.ExportToString(respuesta)
        valorRetorno = New JavaScriptSerializer().Serialize(respuesta)
    End Sub

    ''' <summary>
    ''' Recupera el resultado del CallBack
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks>Copyright JULC - 2021</remarks>
    Public Function GetCallbackResult() As String Implements ICallbackEventHandler.GetCallbackResult
        Return valorRetorno
    End Function
#End Region

End Class

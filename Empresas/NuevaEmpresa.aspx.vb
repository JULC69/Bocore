
Partial Class Empresas_NuevaEmpresa
    Inherits System.Web.UI.Page

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
    Public Property IDUsuario() As String
        Get
            Return HttpContext.Current.Session("IDUsuario")
        End Get
        Set(ByVal value As String)
            HttpContext.Current.Session("IDUsuario") = value
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

    Private Sub Empresas_NuevaEmpresa_Load(sender As Object, e As EventArgs) Handles Me.Load
        'If Not Me.User.Identity.IsAuthenticated Then
        '    Try
        '        FormsAuthentication.SignOut()
        '        HttpContext.Current.Response.Redirect("~/Login.aspx")
        '    Catch xExc As System.Exception
        '    End Try
        'Else
        '    If Context.Session.Count = 0 Then
        '        HttpContext.Current.Response.Redirect("~/Login.aspx")
        '    End If
        'End If

        'Me.IDCentroServicio = 1 'Empresariales
        'Me.IDUsuario = "95403295-5E84-4F5C-A636-02A071EF254F"
        'Me.IDRol = 1
    End Sub

    Private Sub btnCerrarSesion_Click(sender As Object, e As EventArgs) Handles btnCerrarSesion.Click
        Try
            'If Not Me.IsPostBack Then
            If Me.User.Identity.IsAuthenticated Then
                'Iniciar sesión como usuario Anonino
                FormsAuthentication.SignOut()
                Try
                    HttpContext.Current.Response.Redirect("~/Login.aspx")
                Catch xExc As System.Exception
                End Try
            Else
                'Se asegura de que no exista sesion abierta
                'Try : FormsAuthentication.SignOut() : Catch xExc As System.Exception : End Try
            End If
            'End If
        Catch xExc2 As System.Exception
        End Try
    End Sub
End Class

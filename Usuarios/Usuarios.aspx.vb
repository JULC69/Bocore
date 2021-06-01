'Documentacion DataTables JQuery
'https://datatables.net/examples/ajax/objects.html
'How can I get ASP.NET C# to load AJAX json ... - DataTables
'https://datatables.net/forums/discussion/55772/how-can-i-get-asp-net-c-to-load-ajax-json-data-returned-from-the-server
'Using DataTables Grid With ASP.NET MVC
'https://www.c-sharpcorner.com/article/using-datatables-grid-with-asp-net-mvc/
'jQuery datatables server side processing example asp net
'https://youtu.be/u4QKLehvUhs
'destroy() - Reload
'https://datatables.net/reference/api/destroy()
'Raise error in ajax call from server side asp.net
'https://stackoverflow.com/questions/27146104/raise-error-in-ajax-call-from-server-side-asp-net
'Representación de datos
'https://datatables.net/examples/basic_init/data_rendering.html
'How to show export buttons at the bottom of the table
'https://datatables.net/forums/discussion/30218/how-to-show-export-buttons-at-the-bottom-of-the-table#Comment_80941
'Disable sorting of one column
'https://datatables.net/forums/discussion/21164/disable-sorting-of-one-column
'Column priority
'https://datatables.net/extensions/responsive/examples/column-control/columnPriority.html
'Class name - Set Column Header no-responsive
'https://datatables.net/extensions/responsive/examples/initialisation/className.html
'Datatables.responsive header cells issue
'https://datatables.net/forums/discussion/52445/datatables-responsive-header-cells-issue
'Select2 event is not trigger if clicked on selected
'https://github.com/select2/select2/issues/5229

Partial Class Usuarios_Usuarios
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
    Public Property IDRol() As Byte
        Get
            Return HttpContext.Current.Session("IDRol")
        End Get
        Set(ByVal value As Byte)
            HttpContext.Current.Session("IDRol") = value
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

    Private Sub btnCerrarSesion_Load(sender As Object, e As EventArgs) Handles btnCerrarSesion.Load
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

        Me.IDCentroServicio = 1 'Empresariales
        Me.IDUsuario = "95403295-5E84-4F5C-A636-02A071EF254F"
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

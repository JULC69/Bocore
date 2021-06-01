
Partial Class Dashboard
    Inherits System.Web.UI.Page

    Private Sub Dashboard_Load(sender As Object, e As EventArgs) Handles Me.Load
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

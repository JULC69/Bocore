'How to handle SignalR server exception at client?
'https://stackoverflow.com/questions/36135484/how-to-handle-signalr-server-exception-at-client
'SignalR - Handling errors
'https://subscription.packtpub.com/book/web_development/9781783285952/7/ch07lvl1sec60/handling-errors
'Database Change Notifications in ASP.NET using SignalR and SqlDependency
'https://techbrij.com/database-change-notifications-asp-net-signalr-sqldependency
'Materiales y vídeo hangout SignalR y Web API
'https://rlbisbe.net/2014/03/18/materiales-y-video-hangout-signalr-y-web-api/
'Error Handling within SignalR Hubs
'https://www.errlog.io/blogs/2018/1/error-handling-in-a-signalr-hub
'ntroduction to WebSockets with SignalR in .NET Part 6: the basics of publishing to groups
'https://dotnetcodr.com/tag/signalr/
'SignalR multiple chat rooms
'https://stackoverflow.com/questions/11175173/signalr-multiple-chat-rooms
'SignalR Coding Best Practices - Handling Errors
'https://www.sinara.com/signalr-coding-best-practices/
'Pro ASP.NET SignalR: Real-Time Communication in .NET with SignalR 2.1 (2014)
'https://apprize.best/microsoft/aspnet_2/4.html
'Tutorial: creación de una aplicación en tiempo real de alta frecuencia con Signalr 2
'https://docs.microsoft.com/es-es/aspnet/signalr/overview/getting-started/tutorial-high-frequency-realtime-with-signalr

'Real Time Web Solution for Chat by MVC SignalR Hub -ScrollingTop
'https://www.codeproject.com/Articles/732190/Real-Time-Web-Solution-for-Chat-by-MVC-SignalR-H
'Hands On Lab: Real-Time Web Applications with SignalR + SQLServer
'https://docs.microsoft.com/en-us/aspnet/signalr/overview/getting-started/real-time-web-applications-with-signalr
'How To Get List Of Connected Clients In SignalR
'https://www.c-sharpcorner.com/blogs/how-to-get-connected-client-list-in-signalr

'Create a push notification system with SignalR
'http://www.dotnetawesome.com/2016/05/push-notification-system-with-signalr.html
'How to Get Connection Id of Connected Clients in Signal R
'https://www.youtube.com/watch?v=Mu8MbF7uaCY
'Pro ASP.NET SignalR: Real-Time Communication in .NET with SignalR 2.1 (2014)
'https://apprize.best/microsoft/aspnet_2/4.html
'Asp.Net SignalR Chat Room
'https://www.codeproject.com/Articles/562023/Asp-Net-SignalR-Chat-Room
'[Windows Phone] ASP.net SignalR, mundo de posibilidades!
'https://javiersuarezruiz.wordpress.com/tag/signalr/
'Real Time Web Solution for Chat by MVC SignalR Hub
'https://www.codeproject.com/Articles/732190/Real-Time-Web-Solution-for-Chat-by-MVC-SignalR-H
'Crear un Web Chat en C# con SignalR
'http://vbpuntonet.blogspot.com/2020/08/crear-un-web-chat-en-c-con-signalr.html
'Load Data Dynamically on Page Scroll using jQuery AJAX and PHP
'https://phppot.com/jquery/load-data-dynamically-on-page-scroll-using-jquery-ajax-and-php/
'ASP.NET SignalR Hubs API Guide - Server (C#)
'https://docs.microsoft.com/en-us/aspnet/signalr/overview/guide-to-the-api/hubs-api-guide-server
'Load Data Dynamically on Page Scroll using jQuery AJAX and PHP
'https://phppot.com/jquery/load-data-dynamically-on-page-scroll-using-jquery-ajax-and-php/

Partial Class Chat
    Inherits System.Web.UI.Page

#Region "Propiedades"
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

    Private Sub Chat_Load(sender As Object, e As EventArgs) Handles Me.Load
        Me.IDCentroServicio = 1 'Empresariales
        Me.IDUsuario = "95403295-5E84-4F5C-A636-02A071EF254F"
        Me.IDRol = 1
    End Sub
#End Region

End Class

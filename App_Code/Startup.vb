'Chat con SignalR .net Framework
'https://techclub.tajamar.es/chat-con-signalr-net-framework/
'OWIN Startup Class Detection
'https://docs.microsoft.com/en-us/aspnet/aspnet/overview/owin-and-katana/owin-startup-class-detection
'Javascript Scroll Tutorial Load Dynamic Content Into Page When User Reaches Bottom Ajax
'https://youtu.be/eziREnZPml4
'http://www.developphp.com/video/JavaScript/Scroll-Load-Dynamic-Content-When-User-Reach-Bottom-Ajax

Imports Microsoft.Owin
Imports Owin
Imports Microsoft.AspNet.SignalR
Imports Microsoft.VisualBasic

<Assembly: OwinStartup(GetType(Global.Startup))>

Public Class Startup
    Public Sub Configuration(app As IAppBuilder)
        'GlobalHost.HubPipeline.AddModule(New RejoingGroupPipelineModule())

        'app.MapSignalR()
        'app.MapSignalR("/chatSignalR", New HubConfiguration())
        Dim hubConfiguration As HubConfiguration = New HubConfiguration()
        hubConfiguration.EnableDetailedErrors = True
        app.MapSignalR("/chatSignalR", hubConfiguration)
    End Sub
End Class

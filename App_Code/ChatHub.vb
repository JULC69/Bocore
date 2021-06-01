Imports System.Threading.Tasks
Imports Microsoft.AspNet.SignalR

Public Class ChatHub
    Inherits Hub

    'Public Shared Sub Show()
    '    Dim context As IHubContext = GlobalHost.ConnectionManager.GetHubContext(Of ChatHub)()
    '    context.Clients.All.displayStatus()
    '    'context.Clients.All.addMessage("my message")
    'End Sub
    Public Sub BroadcastMessage(ByVal message As Message)
        Clients.Group(message.IdProyecto).displayText(message.IdProyecto, message.Remitente, message.Mensaje)
    End Sub

    Public Function Join(ByVal groupName As String) As Task
        Return Groups.Add(Context.ConnectionId, groupName)
    End Function

    Public Function Leave(ByVal groupName As String) As Task
        Return Groups.Remove(Context.ConnectionId, groupName)
    End Function
End Class


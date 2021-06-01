Imports System.Threading.Tasks
Imports Microsoft.AspNet.SignalR
Imports Microsoft.VisualBasic

Public Class BroadcastHub
    Inherits Hub

    Private ReadOnly _broadcast As Broadcast

    Public Sub New()
        Me.New(Broadcast.Instance)
    End Sub

    Public Sub New(ByVal broadcast As Broadcast)
        _broadcast = broadcast
    End Sub

    Public Sub BroadcastMessage(ByVal message As Message)
        _broadcast.BroadcastMessage(message, Context.ConnectionId, True)
    End Sub

    Public Function Join(ByVal groupName As String) As Task
        Return Groups.Add(Context.ConnectionId, groupName)
    End Function

    Public Function Leave(ByVal groupName As String) As Task
        Return Groups.Remove(Context.ConnectionId, groupName)
    End Function

    Public Sub OpenBroadcast(ByVal groupName As String)
        _broadcast.OpenBroadcast(groupName, Context.ConnectionId)
    End Sub

    Public Function GetConnectionId() As String
        Return Context.ConnectionId
    End Function
End Class

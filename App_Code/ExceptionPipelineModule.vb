Imports Microsoft.AspNet.SignalR
Imports Microsoft.AspNet.SignalR.Hubs
Imports Microsoft.VisualBasic

Public Class RejoingGroupPipelineModule
    Inherits HubPipelineModule
    'https://www.sinara.com/signalr-coding-best-practices/

    Public Overrides Function BuildRejoiningGroups(ByVal rejoiningGroupsFunc As Func(Of HubDescriptor, IRequest, IList(Of String), IList(Of String))) As Func(Of HubDescriptor, IRequest, IList(Of String), IList(Of String))
        rejoiningGroupsFunc = Function(hb, request, wantedListOfGroups)
                                  Dim assignedGroups As List(Of String) = New List(Of String)()
                                  Dim username As String = request.User.Identity.Name
                                  Return assignedGroups
                              End Function

        Return rejoiningGroupsFunc
    End Function
End Class

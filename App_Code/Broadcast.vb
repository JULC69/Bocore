Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.AspNet.SignalR
Imports Microsoft.AspNet.SignalR.Hubs
Imports Microsoft.VisualBasic

Public Class Broadcast
    Private Property Clients As IHubConnectionContext(Of Object)

    Private Sub New(ByVal clients As IHubConnectionContext(Of Object))
        Me.Clients = clients
    End Sub

    Private Shared ReadOnly _instance As Lazy(Of Broadcast) = New Lazy(Of Broadcast)(Function() New Broadcast(GlobalHost.ConnectionManager.GetHubContext(Of BroadcastHub)().Clients))
    Private ReadOnly _broadcastStateLock As Object = New Object()

    Public Shared ReadOnly Property Instance As Broadcast
        Get
            Return _instance.Value
        End Get
    End Property

    Public Sub BroadcastMessage(ByVal mensaje As Message, ByVal connectionId As String, ByVal isNew As Boolean)
        If isNew Then
            Clients.Group(mensaje.IdProyecto.ToString()).displayText(mensaje.IdProyecto, mensaje.Remitente, mensaje.Mensaje)
            Call RegistrarMensaje(mensaje)
        Else
            'Presenta la lista de mesnajes registrados en la base de datos hasta el momento
            Clients.Client(connectionId).displayText(mensaje.IdProyecto, mensaje.Remitente, mensaje.Mensaje)
        End If
    End Sub

    'Public Sub BroadcastMessage(ByVal message As Message, ByVal isNew As Boolean)
    '    Clients.All.displayText(message)

    '    If isNew Then
    '        Call RegistrarMensaje(message)
    '    End If
    'End Sub

    Public Sub OpenBroadcast(ByVal groupName As String, ByVal connectionId As String)
        SyncLock _broadcastStateLock
            Dim messages As IEnumerable(Of Message) = GetAllMessages(groupName)

            For Each message In messages
                BroadcastMessage(message, connectionId, False)
            Next message
        End SyncLock
    End Sub

    ''' <summary>
    ''' Get a list of messages for the specified group
    ''' </summary>
    ''' <param name="groupName">Corresponds to the project identifier</param>
    ''' <remarks>Copyright JULC Mayo 2021</remarks>
    ''' <returns>A list with the messages for the specified group</returns>
    Private Function GetAllMessages(ByVal groupName As String) As IEnumerable(Of Message)
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CSBocore").ConnectionString
        Dim listaIMensajes As List(Of Message) = New List(Of Message)
        Dim idProyecto As Long = Long.Parse(groupName)

        'Try
        Using connection As New SqlConnection(connectionString)
            connection.Open()

            Dim strSQLSelect As String = String.Empty

            strSQLSelect = "SELECT CMS.IdChatMensaje, "
            strSQLSelect &= "            USR.Foto, "
            strSQLSelect &= "            CONCAT(USR.Nombres, ' ', USR.Apellidos) AS Remitente, "
            strSQLSelect &= "            CMS.Mensaje, "
            strSQLSelect &= "            CMS.FechaMensaje "
            strSQLSelect &= "   FROM ChatMensaje AS CMS INNER JOIN Usuario AS USR "
            strSQLSelect &= "        ON CMS.IdRemitente = USR.IdUsuario "
            strSQLSelect &= "WHERE (CMS.IdProyecto = @IdProyecto) "
            strSQLSelect &= "ORDER BY CMS.FechaMensaje"

            Using cmd As New SqlCommand(strSQLSelect)
                cmd.Connection = connection
                cmd.CommandType = CommandType.Text

                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = idProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Using sdr As SqlDataReader = cmd.ExecuteReader()
                    If sdr.HasRows Then
                        While sdr.Read()
                            Dim mensaje As New Message

                            'mensaje.IdCentroServicio = HttpContext.Current.Session("IDCentroServicio")
                            mensaje.IdProyecto = idProyecto
                            mensaje.IdChatMensaje = sdr("IdChatMensaje").ToString()
                            'mensaje.IdRemitente = sdr("IdRemitente").ToString()
                            mensaje.Foto = sdr("Foto").ToString()
                            mensaje.Remitente = sdr("Remitente").ToString()
                            mensaje.Mensaje = sdr("Mensaje").ToString()
                            mensaje.FechaMensaje = sdr("FechaMensaje").ToString()

                            listaIMensajes.Add(mensaje)
                        End While
                    End If

                End Using 'sdr
            End Using

            connection.Close()
        End Using

        'Catch ex As Exception
        '    'respuesta.Codigo = -1
        '    'respuesta.Mensaje = String.Format("<b>Error al recuperar lista de etapas de un proyecto</b>. Mensaje: {0}", ex.Message)
        'End Try

        Return listaIMensajes
    End Function

    Private Sub RegistrarMensaje(ByVal mensaje As Message)
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

                strSQLInsert = "INSERT INTO ChatMensaje ("
                strSQLInsert &= "IdCentroServicio, "
                strSQLInsert &= "IdProyecto, "
                strSQLInsert &= "IdRemitente, "
                strSQLInsert &= "Mensaje, "
                strSQLInsert &= "FechaMensaje) "
                strSQLInsert &= "VALUES ("
                strSQLInsert &= "@IdCentroServicio, "
                strSQLInsert &= "@IdProyecto, "
                strSQLInsert &= "@IdRemitente, "
                strSQLInsert &= "@Mensaje, "
                strSQLInsert &= "GETDATE()) "

                Dim prmIDCentroServiciol As New SqlParameter("@IdCentroServicio", SqlDbType.TinyInt)
                prmIDCentroServiciol.Value = mensaje.IdCentroServicio
                cmd.Parameters.Add(prmIDCentroServiciol)

                Dim prmIDProyecto As New SqlParameter("@IdProyecto", SqlDbType.BigInt)
                prmIDProyecto.Value = mensaje.IdProyecto
                cmd.Parameters.Add(prmIDProyecto)

                Dim prmIDRemitente As New SqlParameter("@IdRemitente", SqlDbType.UniqueIdentifier)
                prmIDRemitente.Value = Guid.Parse(mensaje.IdRemitente)
                cmd.Parameters.Add(prmIDRemitente)

                Dim prmMensaje As New SqlParameter("@Mensaje", SqlDbType.NVarChar, -1)
                prmMensaje.Value = mensaje.Mensaje
                cmd.Parameters.Add(prmMensaje)

                cmd.CommandText = strSQLInsert
                cmd.ExecuteNonQuery()

                transaction.Commit()

            Catch ex As Exception
                sbMensaje.AppendFormat("Error al agregar mensaje de chat. Commit Exception: {0} {1}", ex.Message, ex.StackTrace())
                Try
                    'Intenta revertir la transacción.
                    transaction.Rollback()
                Catch ex2 As Exception
                    'Este bloque de captura se encarga de cualquier error que pueda haber ocurrido 
                    'en el servidor que causaría que la reversión fallara, como una conexión cerrada.
                    sbMensaje.AppendFormat("Rollback Exception: {0} {1}", ex2.Message, ex2.StackTrace())
                End Try

                'respuesta.Codigo = "-1"
                'respuesta.Mensaje = sbMensaje.ToString()
            End Try
        End Using
    End Sub
End Class

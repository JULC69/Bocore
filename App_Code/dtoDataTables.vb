Imports Microsoft.VisualBasic

Public Class dtoDataTables

    Public Class DataInfoCentroServicioDTO
        Public Nombre As String
        Public Descripcion As String
        Public QuienesSomos As String
        Public Mision As String
        Public Vision As String
        Public Servicios As String
    End Class

    Public Class DataEmpresa
        Public IdEmpresa As Integer
        Public RazonSocial As String
        Public NIT As String
        Public Logo As String
        Public ConLogo As String
        Public NombreArchivoLogoServidor As String
        Public RepresentanteLegal As String
        Public Email As String
        Public Celular1 As String
        Public Celular2 As String
        Public Telefono1 As String
        Public Telefono2 As String
        Public IdPais As Short
        Public IdDepartamento As String
        Public IdCiudad As String
        Public OtraCIudad As String
        Public Direccion As String
        Public IdUsuario As Guid
        Public IdRol As Short
        Public FechaRegistro As DateTime
        Public FechaActualizacion As DateTime
    End Class

    Public Class DataEntregableProyecto
        Public IdEntregableProyecto As Long
        Public IdProyecto As Long
        Public IdEtapa As Short
        Public Descripcion As String
        Public RutaArchivo As String
        Public IdUsuario As Guid
        Public IdRol As Short
        Public FeedBackCoordinador As String
        Public FechaFeedBackCoordinador As DateTime
        Public FeedBackDocente As String
        Public FechaFeedBackDocente As DateTime
        Public FechaRegistro As DateTime
        Public FechaActualizacion As DateTime
    End Class

    Public Class DataFormDocumento
        Public IdProyecto As Long
        Public Archivo As HttpPostedFile
        Public Nombre As String
        Public IdResponsable As String
        Public IdRol As Short
    End Class

    Public Class DataFormFoto
        Public IdUsuario As String
        Public NombreUsuario As String
        Public Archivo As HttpPostedFile
        Public Extension As String
        Public Tipo As String
    End Class

    Public Class DataFormLogo
        Public IdEmpresa As String
        Public NombreEmpresa As String
        Public Archivo As HttpPostedFile
        Public Extension As String
        Public Tipo As String
    End Class

    Public Class DataListaGeneralEmpresas
        Public IdEmpresa As Integer
        Public RazonSocial As String
        Public RepresentanteLegal As String
        Public Celular As String
        Public FechaRegistro As String
    End Class

    Public Class DataListaGeneralUsuarios
        Public IdCentroServicio As String
        Public IdUsuario As String
        Public Nombres As String
        Public Apellidos As String
        Public ConFoto As String
        Public Foto As String
        Public NombreArchivoFotoServidor As String
        Public Rol As String
        Public FechaRegistro As String
    End Class

    Public Class DataListaProyecto
        Public IdCentroServicio As String
        Public IdProyecto As String
        Public Titulo As String
        Public Empresa As String
        Public Etapa As String
        Public Estado As String
        Public FechaRegistro As DateTime
    End Class

    Public Class DataLogin
        Public Usuario As String
        Public Contrasena As String
        ''' <summary>
        ''' Debe cambiar contraseña al iniciar sesión la próxima vez.
        ''' </summary>
        Public DebeCambiar As String
    End Class

    Public Class DataMensajeChat
        Public IdCentroServicio As Short
        Public IdMensaje As Long
        Public IdUsuarioEmisor As Guid
        Public IdUsuarioReceptor As Guid
        Public IdProyecto As Long
        Public Mensaje As String
        Public FechaMensaje As DateTime
        Public Leido As Boolean
        Public FechaLectura As DateTime
        Public Eliminado As Boolean
        Public FechaEliminacion As DateTime
    End Class

    Public Class DataDocumentoDTO
        Public IdDocumento As String
        Public IdProyecto As String
        Public NombreArchivo As String
        Public URL As String
        Public IdResponsable As String
        Public Responsable As String
        Public FechaRegistro As String
    End Class

    Public Class DataInfoProyectoDTO
        Public ProgramaAcademico As String
        Public Email As String
        Public FechaInicio As String
        Public InformacionEmpresa As String
        Public Modalidad As String
        Public Coordinador As String
    End Class

    Public Class DataInfoRetoDTO
        Public Alcance As String
        Public DescEmpresa As String
        Public DescReto As String
        Public ObjetivoMinimo As String
    End Class

    Public Class DataNuevoParticipante
        Public IdProyecto As Long
        Public IdUsuario As Guid
    End Class

    Public Class DataObjetivoProyecto
        Public IdObjetivoProyecto As Long
        Public IdProyecto As Long
        Public Objetivo As String
        Public IdUsuario As Guid
        Public IdRol As Short
        Public FechaRegistro As DateTime
        Public FechaActualizacion As DateTime
    End Class

    Public Class DataParticipanteProyecto
        Public IdParticipanteProyecto As Long
        Public IdProyecto As Long
        Public IdUsuario As Guid
        Public IdRol As Short
        Public FechaRegistro As DateTime
    End Class

    ''' <summary>
    ''' Clase Programa Académico.
    ''' </summary>
    Public Class DataProgramaAcademico
        Public IdPrograma As Short
        Public Nombre As String
        Public Activo As Boolean
        Public IdUsuario As Guid
        Public IdRol As Short
        Public FechaRegistro As DateTime
    End Class

    Public Class DataProyecto
        Public IdCentroServicio As Short
        Public IdProyecto As Long
        Public IdTipoProyecto As Short
        Public Titulo As String
        Public Descripcion As String
        Public Alcance As String
        Public ObjetivoMinimo As String
        Public IdEmpresa As Integer
        Public IdModalidad As Short
        Public ProgramaAcademico As String
        Public AsignaturaAcademica As String
        Public IdEtapaActual As Short
        Public IdEstadoProyecto As Short
        Public IdUsuario As Guid
        Public IdRol As Short
        Public FechaRegistro As DateTime
        Public FechaActualizacion As DateTime
    End Class

    Public Class DataRespuestaLogin
        Public IdLogin As Long
        Public IdUsuario As Guid
        Public Nombre As String
    End Class

    Public Class DataTareaProyecto
        Public IdTareaProyecto As String
        Public IdCentroServicio As String
        Public IdProyecto As String
        Public IdTipoTarea As String
        Public Nombre As String
        Public Descripcion As String
        Public FechaInicio As DateTime
        Public FechaFinalización As DateTime
        Public FechaLimite As DateTime
        Public IdResponsable As String
        Public IdEstadoTarea As String
        Public IdUsuario As Guid
        Public IdRol As Short
        Public FechaRegistro As DateTime
        Public FechaActualizacion As DateTime
    End Class

    Public Class DataUsuario
        Public IdCentroServicio As String
        Public IdUsuario As String
        Public Nombres As String
        Public Apellidos As String
        Public ConFoto As String
        Public Foto As String
        Public NombreArchivoFotoServidor As String
        Public IdTipoDocumento As String
        Public Documento As String
        Public IdRol As Short
        Public Email As String
        Public Celular As String
        Public Direccion As String
        Public CodigoPostal As String
        Public IdPais As Short
        Public IdDepartamento As String
        Public IdCiudad As String
        Public OtraCIudad As String
        Public Credenciales As DataLogin
        Public EsAnonimo As String
        Public TiempoConectado As String
        Public Activo As String
        Public FechaRegistro As DateTime
        Public FechaActualizacion As DateTime
    End Class

    Public Class DataUsuarioParticipante
        Public IdParticipante As String
        Public Foto As String
        Public Nombre As String
        Public Rol As String
        Public Telefono As String
    End Class

    Public Class EstadoOperacion
        Public Codigo As String
        Public Mensaje As String
        Public Resultado As Object
        Public ValorDefault As String
        ' Constructor
        Public Sub New(ByVal codigoEO As String, ByVal mensajeEO As String)
            Codigo = codigoEO
            Mensaje = mensajeEO
        End Sub 'New
    End Class

    ''' <summary>
    ''' Clase ItemLista
    ''' </summary>
    Public Class itemLista
        Public Key As String
        Public Value As String
    End Class

    ''' <summary>
    ''' Clase itemSelect2
    ''' </summary>
    Public Class itemSelect2
        Public id As String
        Public text As String
    End Class
End Class

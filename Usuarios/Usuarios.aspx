<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Usuarios.aspx.vb" Inherits="Usuarios_Usuarios" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOCORE | Usuarios</title>
    <link rel="stylesheet" href="../css/bootstrap.min.css" />
    <link rel="stylesheet" href="../css/hover/hover-min.css" />
    <link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" />
    <link rel="stylesheet" href="../css/bocore.css"/>

    <style>
        /* Elimina el bord de los diálogos modales*/
        .modal-content {
            border: 0px;
        }

        td {
            vertical-align: middle !important;
        }

        table.dataTable thead tr {
            background-color: black;
            color: white;
        }

        .width-th-actions {
            width: 80px;
        }
    </style>
</head>

<body>

    <header class="navbar sticky-top bg-dark flex-md-nowrap p-0 shadow">
        <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3" href="#">
            <img src="../images/logo.png" class="img-fluid" /></a>
        <ul class="navbar-nav px-3 text-right">
            <li>
                <a href="#"><i class="fa fa-comment"></i></a>
                <a href="#"><i class="fa fa-bell"></i></a>
                <span id="spnUsuarioLogueado"></span>
                <a href="#" onclick="CerrarSesion();">Salir <i class="fa fa-sign-out" aria-hidden="true"></i></a>
                <form id="form1" runat="server">
                    <asp:Button ID="btnCerrarSesion" CssClass="d-none" runat="server" Text="Cerrar Sesión" />
                </form>
            </li>
        </ul>
    </header>

    <div class="container-fluid dashboardContainer full-heightX">
        <div class="row">
            <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar navbar navbar-expand-lg">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo01" aria-controls="navbarTogglerDemo01" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"><i class="fa fa-bars" aria-hidden="true"></i></span>
                </button>
                <div class="position-sticky pt-3 w-100">
                    <ul class="nav flex-column collapse navbar-collapse " id="navbarTogglerDemo01">
                        <li class="nav-item">
                            <a class="nav-link active" aria-current="page" href="#">
                                <span data-feather="home"></span>
                                Panel Principal
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/Proyectos/Proyectos.aspx">
                                <span data-feather="briefcase"></span>
                                Proyectos
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/Empresas/Empresas.aspx">
                                <span data-feather="book-open"></span>
                                Empresas
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/Usuarios/Usuarios.aspx">
                                <span data-feather="users"></span>
                                Usuarios
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="Seguridad.aspx">
                                <span data-feather="shield"></span>
                                Seguridad
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <span data-feather="user"></span>
                                Mi Cuenta
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <span data-feather="help-circle"></span>
                                Ayuda
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <span data-feather="log-out"></span>
                                Salir
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="breadcrumbs">
                    <a href="#">Home</a> - Usuarios
                </div>
                <div class="contentBox">
                    <div class="row">
                        <div class="col-sm">

                            <div class="row mb-4 mt-1">
                                <div class="col-7">
                                    <h3 class="titulo">Usuarios</h3>
                                </div>
                                <div class="col-5 text-right"><a href="NuevoUsuario.aspx" class="btn btn-primary">+ Nuevo Usuario</a></div>
                            </div>

                            <table id="tblUsuarios" class="table table-striped table-bordered dataTable hover nowrap" style="width: 100%">
                                <thead>
                                    <tr>
                                        <th class="text-center">Foto</th>
                                        <th class="text-center">Nombre</th>
                                        <th class="text-center">Apellidos</th>
                                        <th class="text-center">Rol</th>
                                        <th class="text-center">Fecha Registro</th>
                                        <th class="text-center width-th-actions">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="tbdDetalleUsuarios">
                                    <%--                            <tr>
                                <td><img src="../images/Silueta.png" class="img-fluid"  height="80px" width="60px" /></td>
                                <td>David Santiago</td>
                                <td>Liévano Rueda</td>
                                <td>Estudiante</td>
                                <td>11-04-2021 09:50:59</td>
                                <td>
                                    <a href="#"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a>
                                    <a href="#"><i class="fa fa-eye" aria-hidden="true"></i></a>
                                    <a href="#"><i class="fa fa-trash" aria-hidden="true"></i></a>
                                </td>
                            </tr>
                            <tr>
                                <td><img src="../images/Silueta.png" class="img-fluid"  height="80px" width="60px" /></td>
                                <td>Juan Manuel</td>
                                <td>Perez Lito</td>
                                <td>Estudiante</td>
                                <td>11-04-2021 09:50:59</td>
                                <td>
                                    <a href="#"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a>
                                    <a href="#"><i class="fa fa-eye" aria-hidden="true"></i></a>
                                    <a href="#"><i class="fa fa-trash" aria-hidden="true"></i></a>
                                </td>
                            </tr>
                            <tr id="95403295-5E84-4F5C-A636-02A071EF254F">
                                <td><img src="../images/Silueta.png" class="img-fluid"  height="80px" width="60px" /></td>
                                <td>Andrés Felipel</td>
                                <td>Liévano Jaimes</td>
                                <td>Estudiante</td>
                                <td>11-04-2021 09:50:59</td>
                                <td>
                                    <a href="#" onclick="fEditar(this);"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a>
                                    <a href="#" onclick="fConsultar(this);"><i class="fa fa-eye" aria-hidden="true"></i></a>
                                    <a href="#" onclick="fEliminar(this);"><i class="fa fa-trash" aria-hidden="true"></i></a>
                                </td>
                            </tr>--%>
                                </tbody>
                            </table>
                            <hr />
                            <p>Configurado con DataTables. <a href="https://datatables.net/manual/" target="_blank">Documentación</a></p>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <div class="container-fluid footer">
        <div class="row">
            <div class="col-sm-12 copy text-center">
                Universidad de Santander UDES - 2021
            </div>
        </div>
    </div>

    <!-- Diálogo de Mensajes -->
    <div class="modal fade" id="dlgMensajeModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="MensajeModalLabel" aria-hidden="true" style="z-index: 1900;">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                 <div class="modal-header bg-success text-white py-0" style="border-bottom: -1px!important;">
                    <h5 class="modal-title text-white" id="MensajeModalLabel">Bocore</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true" class="text-white font-weight-bold">&times;</span>
                    </button>
                </div>
                <div id="divCuerpoMensaje" class="modal-body word-wrap-break-word">
                    <span id="spnCuerpoMensaje">Contenido del mensaje Contenido del mensaje Contenido del mensaje</span>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Aceptar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Dialogo de Confirmación para Eliminación de regsitro de datos -->
    <div class="modal fade" id="dlgMensajeConfirmacionModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="MensajeConfirmacionModalLabel" aria-hidden="true" style="z-index: 1800;">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                 <div class="modal-header bg-success text-white py-0" style="border-bottom: -1px!important;">
                    <h5 class="modal-title text-white" id="MensajeConfirmacionModalLabel">Confirmación</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true" class="text-white font-weight-bold">&times;</span>
                    </button>
                </div>
                <div id="divMensajeConfirmacion" class="modal-body">
                    <span id="spnMensajeConfirmacion">¿Está usted seguro de eliminar este Usuario?</span>
                </div>
                <div class="modal-footer">
                    <button id="btnEliminarUsuario" type="button" class="btn btn-primary mr-sm-2">Aceptar</button>
                    <button type="button" class="btn btn-secondary ml-sm-2" data-dismiss="modal">Cancelar</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/feather-icons@4.28.0/dist/feather.min.js" integrity="sha384-uO3SXW5IuS1ZpFPKugNNWqTZRRglnUJK6UAZ/gxOX80nxEkN9NcGZTftn6RzhGWE" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js" integrity="sha384-zNy6FEbO50N+Cg5wap8IKA4M/ZnLJgzc6w2NqACZaK0u0FXfOWRRJOnQtpZun8ha" crossorigin="anonymous"></script>
    <script src="../js/dashboard.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" crossorigin="anonymous"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bs-custom-file-input/dist/bs-custom-file-input.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" crossorigin="anonymous"></script>
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>

    <%--    Botones de exportacion de datos--%>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.7.0/js/dataTables.buttons.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.7.0/js/buttons.html5.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/buttons/1.7.0/js/buttons.print.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/select/1.3.3/js/dataTables.select.min.js"></script>

    <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/fixedheader/3.1.6/js/dataTables.fixedHeader.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.3/js/dataTables.responsive.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.3/js/responsive.bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.1/js/tempusdominus-bootstrap-4.min.js"></script>
    <%--    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/sweetalert2@9.5.4/dist/sweetalert2.all.min.js"></script>--%>
    <script type="text/javascript" src="../js/tabledit/jquery.tabledit.min.js"></script>
    <%--    <script type="text/javascript" src="../js/custom.js"></script>--%>

    <script type="text/javascript">
        var _gIdUsuario = null;

        $(document).ready(function () {
            let usuarioLoggeado = '<%= Session("NombreUsuarioLoggeado") %>';
            $("#spnUsuarioLogueado").text(usuarioLoggeado);

            // Ejecuta secuencialmente y sincrónicamente las siguientes subrutinas.
            ListaGeneralUsuarios().then(estado => {
                //alert("Usuarios cargados");
                // Adjunta el plugin DataTable a la tabla de Usuarios.
                $('#tblUsuarios').dataTable({
                    //"dom": 'Bfrtip',
                    //"buttons": [
                    //    'copy', 'csv', 'excel', 'pdf', 'print'
                    //],
                    "stateSave": true,  /* Guarda el estado de la tabla (su posición de paginación, estado de pedido, etc.) para que se pueda restaurar cuando el usuario recargue una página o regrese a la página después de visitar una subpágina*/
                    "language": {
                        "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
                    },
                    "responsive": true,
                    "columnDefs": [{ // Deshabilita función Sort columna Foto.
                        "targets": [0, 5],
                        "orderable": false
                    },
                    //Da prioridad a la primera, segunda y última columna:
                    { "responsivePriority": 1, targets: 0 }, // Columna Foto
                    { "responsivePriority": 2, targets: 1 }, // Columna Nombres
                    { "responsivePriority": 3, targets: -1 }   // Obliga a mostrar siempre la columna Acciones.
                    ],
                    "select": false
                });
            }).catch(error => {
                //console.log(error);
                //MostrarMensaje(error);
                //$("#loader").hide();
                MostrarMensaje(error);
                //window.location.replace(document.referrer);
            });
        });

        function fConsultar(obj) {
            let fila = $(obj).parent().parent(); //Objeto fila
            //alert($(fila).attr('id')); // Id de fila
            window.location.href = "EditarUsuario.aspx?Id=" + $(fila).attr('id') + "&op=1";
        }

        function fEditar(obj) {
            let fila = $(obj).parent().parent(); //Objeto fila
            //alert($(fila).attr('id')); // Id de fila
            window.location.href = "EditarUsuario.aspx?Id=" + $(fila).attr('id') + "&op=2";
        }

        function fEliminar(obj) {
            let fila = $(obj).parent().parent(); //Objeto fila
            _gIdUsuario = $(fila).attr('id');
            $('#dlgMensajeConfirmacionModal').modal('show');
            //$('#tblUsuarios").DataTable().ajax.reload();
        }

        function ListaGeneralUsuarios() {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';
                //alert("CargarUsuarios");
                $.ajax({
                    type: "POST",
                    url: pageUrl + "/ListaGeneralUsuarios",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    async: false, // Para usar con promesas
                    data: '',
                    success: function (response) {
                        let objResultado = JSON.parse(response.d);

                        if (objResultado.Codigo == '0') {
                            $("#tbdDetalleUsuarios").empty();

                            $.each(objResultado.Resultado, function (i, usuario) {
                                let htmlTR = `<tr id="${usuario.IdUsuario}">
                                                            <td><img src="${usuario.Foto}" class="img-fluid"  height="80px" width="60px" /></td>
                                                            <td>${usuario.Nombres}</td>
                                                            <td>${usuario.Apellidos}</td>
                                                            <td>${usuario.Rol}</td>
                                                            <td>${usuario.FechaRegistro}</td>
                                                            <td class="text-center">
                                                                <a href="#" onclick="fEditar(this);"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a>
                                                                <a href="#" onclick="fConsultar(this);"><i class="fa fa-eye" aria-hidden="true"></i></a>
                                                                <a href="#" onclick="fEliminar(this);"><i class="fa fa-trash" aria-hidden="true"></i></a>
                                                            </td>
                                                      </tr>`;
                                // Agrega una fila con información de un usuario.
                                $('#tbdDetalleUsuarios').append(htmlTR);
                            });
                            resolve(true);
                        } else {
                            reject(objResultado.Mensaje);
                        }
                    },
                    failure: function (response) {
                        reject(response.status);
                    },
                    error: function (jqXHR, exception) {
                        var mensaje = '';
                        if (jqXHR.status === 0) {
                            mensaje = 'Sin conexión.\n Verifique Red.';
                        } else if (jqXHR.status == 404) {
                            mensaje = 'Página solicitada no encontrada. [404]';
                        } else if (jqXHR.status == 500) {
                            mensaje = 'Error de servidor interno [500].';
                        } else if (exception === 'parsererror') {
                            mensaje = 'El análisis JSON solicitado falló.';
                        } else if (exception === 'timeout') {
                            mensaje = 'Error de tiempo de espera.';
                        } else if (exception === 'abort') {
                            mensaje = 'Solicitud de Ajax abortada.';
                        } else {
                            mensaje = 'Error no detectado.\n' + jqXHR.responseText;
                        }
                        reject(mensaje);
                    }
                });
            })
        }

        function EliminarUsuario(idUsuario) {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';
                //alert("Eliminado usuario");
                $.ajax({
                    type: "POST",
                    url: pageUrl + "/EliminarUsuario",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    async: false, // Para usar con promesas
                    data: JSON.stringify({ 'idUsuario': idUsuario }),
                    success: function (response) {
                        let objResultado = JSON.parse(response.d);

                        if (objResultado.Codigo == '0') {
                            resolve(true);
                        } else {
                            reject(objResultado.Mensaje);
                        }
                    },
                    failure: function (response) {
                        reject(response.status);
                    },
                    error: function (jqXHR, exception) {
                        var mensaje = '';
                        if (jqXHR.status === 0) {
                            mensaje = 'Sin conexión.\n Verifique Red.';
                        } else if (jqXHR.status == 404) {
                            mensaje = 'Página solicitada no encontrada. [404]';
                        } else if (jqXHR.status == 500) {
                            mensaje = 'Error de servidor interno [500].';
                        } else if (exception === 'parsererror') {
                            mensaje = 'El análisis JSON solicitado falló.';
                        } else if (exception === 'timeout') {
                            mensaje = 'Error de tiempo de espera.';
                        } else if (exception === 'abort') {
                            mensaje = 'Solicitud de Ajax abortada.';
                        } else {
                            mensaje = 'Error no detectado.\n' + jqXHR.responseText;
                        }
                        reject(mensaje);
                    }
                });
            })
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Cerrar Sesión: Se apoya de un button ASP.Net oculto
        //---------------------------------------------------------------------------------------------------------------------
        function CerrarSesion() {
            // alert('Cerrando sesión');
            document.getElementById('btnCerrarSesion').click();
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Elimina el registro de datos del usuario especificado
        //---------------------------------------------------------------------------------------------------------------------
        $("#btnEliminarUsuario").on("click", function () {
            EliminarUsuario(_gIdUsuario).then(estado => {
                // Refresca página
                window.location.reload();
            }).catch(error => {
                MostrarMensaje(error);
                //window.location.replace(document.referrer);
            });
        });

        //---------------------------------------------------------------------------------------------------------------------
        // Presenta una ventana modal con un mensaje
        //---------------------------------------------------------------------------------------------------------------------
        function MostrarMensaje(mensaje) {
            $("#divCuerpoMensaje").empty();
            $("#divCuerpoMensaje").html(mensaje);
            // Presenta el diálogo Modal
            $("#dlgMensajeModal").modal('show');
        }
    </script>
</body>
</html>


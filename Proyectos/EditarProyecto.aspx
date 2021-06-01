<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EditarProyecto.aspx.vb" Inherits="Proyectos_EditarProyecto" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOCORE | Editar Proyecto</title>

    <link rel="stylesheet" href="../css/bootstrap.min.css" />
    <link rel="stylesheet" href="../css/hover/hover-min.css" />
    <link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" />
    <link rel="stylesheet" href="../css/bocore.css"/>

    <script type="text/javascript">  
        function preventBack() { window.history.forward(); }
        setTimeout("preventBack()", 0);
        window.onunload = function () { null };
    </script>

    <style>
        /*a.disabled {*/
            /* Make the disabled links grayish*/
            /*color: gray;*/
            /* And disable the pointer events */
            /*pointer-events: none;
        }*/

        /* Elimina el bord de los diálogos modales*/
        .modal-content {
            border: 0px;
        }
        /* Centra verticalmente los nombres de las columnas de la tabla */
        td {
            vertical-align: middle !important;
        }

        /* Establece color de fondo y color del texto en los encabezados de columna de la tabla */
        table.dataTable thead tr {
            background-color: black;
            color: white;
        }

        .width-th-actions {
            width: 60px;
        }

        .width-th-foto {
            width: 60px;
        }

        /* Resuelve el problema de establecer directamente el ancho del comntrol Select2*/
        .select2-container {
            width: 100% !important;
            padding: 0;
        }

/*        body.modal-open {
          height: 100vh;
          overflow-y: hidden;
        }*/
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

    <div class="container-fluid dashboardContainer">
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
                    <a href="#">Home</a> - Dashboard
                </div>
                <div class="contentBox">
                    <div class="row">
                        <div class="col-sm">

                            <h3 id="hTitulo" class="titulo">Nuevo Proyecto</h3>

                            <form id="frmPerfilProyecto" class="was-validated" method="post">
                                <input id="hddOperacion" name="Operacion" type="hidden" value="">
                                <input id="hddIDProyecto" name="IdProyecto" type="hidden" value="">
                                <div class="form-group">
                                    <label for="cmbTipoProyecto">Tipo de Proyecto</label>
                                    <select id="cmbTipoProyecto" class="form-control" oninvalid="this.setCustomValidity('Seleccione un Tipo de proyecto')" oninput="this.setCustomValidity('')" required>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="txtTitulo">Título</label>
                                    <input id="txtTitulo"
                                        class="form-control"
                                        maxlength="150"
                                        oninvalid="this.setCustomValidity('Ingrese el Título del proyecto')"
                                        oninput="this.setCustomValidity('')"
                                        placeholder="Título"
                                        type="text"
                                        required>
                                </div>
                                <%--                                <div class="form-group">
                                    <label for="text">Nombre Coordinador</label>
                                    <input type="text" class="form-control" id="texto" placeholder="Texto" required>
                                </div>
                                <div class="form-group">
                                    <label for="text">Teléfono Coordinador</label>
                                    <input type="text" class="form-control" id="texto" placeholder="Texto" required>
                                </div>--%>

                                <div class="form-group">
                                    <label for="txtDescripcion">Descripción</label>
                                    <textarea id="txtDescripcion" class="form-control" maxlength="4000" oninvalid="this.setCustomValidity('Ingrese la Descripción del proyecto')" oninput="this.setCustomValidity('')" placeholder="Descripción Proyecto" rows="3" required></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="txtAlcance">Alcance Reto</label>
                                    <textarea id="txtAlcance" class="form-control" maxlength="4000" oninvalid="this.setCustomValidity('Ingrese el Alcance del reto')" oninput="this.setCustomValidity('')" placeholder="Alcance Reto" rows="3" required></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="txtObjetivoMinimo">Objetivo Mínimo</label>
                                    <textarea id="txtObjetivoMinimo" class="form-control" maxlength="4000" oninvalid="this.setCustomValidity('Ingrese el Objetivo Mínimo del proyecto')" oninput="this.setCustomValidity('')" placeholder="Objetivo Mínimo" rows="3" required></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="cmbEmpresa">Empresa</label>
                                    <select id="cmbEmpresa" class="form-control" oninvalid="this.setCustomValidity('Seleccione la Empresa que acompañará el desarrollo del proyecto')" oninput="this.setCustomValidity('')" required>
                                        <%--                                        <option>Opción 1</option>
                                        <option>Opción 2</option>
                                        <option>Opción 3</option>
                                        <option>Opción 4</option>
                                        <option>Opción 5</option>--%>
                                    </select>
                                </div>
                                <%--                                <div class="form-group">
                                    <label for="cmbProgramaAcademico">Programa UDES asignado</label>
                                    <select id="cmbProgramaAcademico" class="form-control" required>
                                        <option>Opción 1</option>
                                        <option>Opción 2</option>
                                        <option>Opción 3</option>
                                        <option>Opción 4</option>
                                        <option>Opción 5</option>
                                    </select>
                                </div>--%>

                                <div class="form-group">
                                    <label for="txtProgramaAcademico">Programa UDES asignado</label>
                                    <input type="text" class="form-control auttoCompleteProgramaAcademico" id="txtProgramaAcademico" autocomplete="off" maxlength="150" placeholder="Programa académico asignado" required>
                                </div>

                                <%--                                <div class="form-group">
                                    <label for="select1">Docente a cargo</label>
                                    <select class="form-control" id="select1" required>
                                        <option>Opción 1</option>
                                        <option>Opción 2</option>
                                        <option>Opción 3</option>
                                        <option>Opción 4</option>
                                        <option>Opción 5</option>
                                    </select>
                                </div>--%>



                                <div class="form-group">
                                    <label for="txtAsignaturaAcademica">Asignatura</label>
                                    <input id="txtAsignaturaAcademica" class="form-control" placeholder="Asignatura académica" type="text" required>
                                </div>

                                <div class="form-group">
                                    <label for="cmbModalidad">Modalidad</label>
                                    <select id="cmbModalidad" class="form-control" oninvalid="this.setCustomValidity('Seleccione la modalidad académica para el desarrollo del proyecto')" oninput="this.setCustomValidity('')" required>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <div class="row mb-4 mt-1">
                                        <div class="col-6">
                                            <h3 class="titulo">Participantes</h3>
                                        </div>
                                        <div class="col-6 text-right">
<%--                                            <button id="btnNuevoParticipante" type="button" class="btn btn-primary"  data-toggle="modal" data-target="#dlgNuevoParticipanteModal">+ Nuevo Participante</button>--%>
                                            <input id="btnNuevoParticipante"  type="button" class="btn btn-primary" data-toggle="modal" data-target="#dlgNuevoParticipanteModal" value="+ Nuevo Participante" />
                                        </div>
                                    </div>
                                    <table id="tblParticipantes" class="table table-striped table-bordered dataTable hover nowrap" style="width: 100%">
                                        <thead>
                                            <tr>
                                                <th class="text-center width-th-foto">Foto</th>
                                                <th class="text-center">Nombre</th>
                                                <th class="text-center">Rol</th>
                                                <th class="text-center">Tekéfono</th>
                                                <th class="text-center width-th-actions">Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody id="tbdDetalleParticipantes">
<%--                                            <tr id="1000">
                                                <td><img src="../images/Silueta.png" class="img-fluid"  height="80px" width="60px" /></td>
                                                <td>Participante 1</td>
                                                <td>Coordinador</td>
                                                <td>320 9325647</td>
                                                <td class="text-center">
                                                    <a href="#" class="disabled" onclick="fEditar(this);"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a>
                                                    <a href="#" onclick="fConsultar(this);"><i class="fa fa-eye" aria-hidden="true"></i></a>
                                                    <a href="#"><i class="fa fa-users" aria-hidden="true"></i></a>
                                                    <a href="#" onclick="fEliminar(this);"><i class="fa fa-trash" aria-hidden="true"></i></a>
                                                </td>
                                            </tr>
                                            <tr id="1001">
                                                <td><img src="../images/Silueta.png" class="img-fluid"  height="80px" width="60px" /></td>
                                                <td>Participante 2</td>
                                                <td>Docente</td>
                                                <td>300 1859624</td>
                                                <td class="text-center">
                                                    <a href="#" onclick="fEditar(this);"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a>
                                                    <a href="#" onclick="fConsultar(this);"><i class="fa fa-eye" aria-hidden="true"></i></a>
                                                    <a href="#"><i class="fa fa-users" aria-hidden="true"></i></a>
                                                    <a href="#" onclick="fEliminar(this);"><i class="fa fa-trash" aria-hidden="true"></i></a>
                                                </td>
                                            </tr>
                                            <tr id="1002">
                                                <td><img src="../images/Silueta.png" class="img-fluid"  height="80px" width="60px" /></td>
                                                <td>Participante 3</td>
                                                <td>Estudiante</td>
                                                <td>301 1012365</td>
                                                <td class="text-center">
                                                    <a href="#" onclick="fEditar(this);"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a>
                                                    <a href="#" onclick="fConsultar(this);"><i class="fa fa-eye" aria-hidden="true"></i></a>
                                                    <a href="#"><i class="fa fa-users" aria-hidden="true"></i></a>
                                                    <a href="#" onclick="fEliminar(this);"><i class="fa fa-trash" aria-hidden="true"></i></a>
                                                </td>
                                            </tr>--%>

                                        </tbody>
                                    </table>
                                </div>
                                <div class="form-group float-right">
                                    <%--               <button class="btn btn-danger">Cancelar</button>--%>
                                    <input type="submit" class="btn btn-success" value="Guardar cambios" />
                                </div>
                            </form>
                        </div>
                    </div>
                    <p></p>
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

    <!-- Modal Agregar Participante -->
    <div class="modal fade" id="dlgNuevoParticipanteModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="NuevoParticipanteModalLabel" aria-hidden="true" style="z-index: 1800;">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                 <div class="modal-header bg-success text-white py-0" style="border-bottom: -1px!important;">
                    <h5 class="modal-title text-white" id="NuevoParticipanteModalLabel">Nuevo participante</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true" class="text-white font-weight-bold">&times;</span>
                    </button>
                </div>
                <div id="divCuerpoNuevoParticipante" class="modal-body">
                     <div class="container">
                        <div class="form-group row">
                            <label for="cmbParticipanteSugerido">Nombre</label>
                            <select class="form-control" id="cmbParticipanteSugerido" required>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
<%--                    <button id="btnAgregarParticipante" type="button" class="btn btn-secondary" data-dismiss="modal">Aceptar</button>--%>
                    <button id="btnAgregarParticipante" type="button" class="btn btn-secondary" aria-disabled="true" >Vincular</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Mensaje -->
    <div class="modal fade" id="dlgMensajeModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="MensajeModalLabel" aria-hidden="true" style="z-index: 1800;">
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
                    <span id="spnMensajeConfirmacion">¿Está seguro de eliminar este registro de Usuario?</span>
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
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/fixedheader/3.1.6/js/dataTables.fixedHeader.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.3/js/dataTables.responsive.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.3/js/responsive.bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.1/js/tempusdominus-bootstrap-4.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/xcash/bootstrap-autocomplete@v2.3.7/dist/latest/bootstrap-autocomplete.min.js"></script>

    <%--    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/sweetalert2@9.5.4/dist/sweetalert2.all.min.js"></script>--%>
    <script type="text/javascript" src="../js/tabledit/jquery.tabledit.min.js"></script>
    <%--    <script type="text/javascript" src="../js/custom.js"></script>--%>

    <script type="text/javascript" src="../js/URLParametros.js"></script>

    <!--   Pluggin Select2   -->
    <link href="../css/select2/select2.css" rel="stylesheet" />
    <script src="../js/select2/select2.js"></script>
    <script src="../js/select2/i18n/es.js"></script>

    <script type="text/javascript">
        var _gIdUsuario = null;

        $(document).ready(function () {
            let idProyecto = getURLParameter("Id");
            let operacion = getURLParameter("op");
            //let idProyecto = 2;
            //let operacion = 2;

            //alert("idProyecto: " + idProyecto);
            //alert("operacion: " + operacion);

            $("#hddIDProyecto").val(idProyecto);
            $("#hddOperacion").val(operacion);

            if (idProyecto != "null" && operacion != "null") {
                let usuarioLoggeado = '<%= Session("NombreUsuarioLoggeado") %>';
                $("#spnUsuarioLogueado").text(usuarioLoggeado);

                // Ejecuta secuencialmente y sincrónicamente las siguientes subrutinas.
                ListaTiposProyecto().then(estado => {
                    return ListaEmpresas();
                }).then(estado => {
                    return ListaModalidades();
                }).then(estado => {
                    return EditarProyecto(idProyecto);
                }).then(estado => {
                    return ListaParticipantesProyecto(idProyecto);
                }).then(estado => {
                    //alert("Registro cargado");
                    //DatosPrueba();

                    $('#tblParticipantes').dataTable({
                        //"dom": 'Bfrtip',
                        //"buttons": [
                        //    'copy', 'csv', 'excel', 'pdf', 'print'
                        //],
                        "stateSave": true,  /* Guarda el estado de la tabla (su posición de paginación, estado de pedido, etc.) para que se pueda restaurar cuando el usuario recargue una página o regrese a la página después de visitar una subpágina*/
                        "language": {
                            "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
                        },
                        "responsive": true,
                        "columnDefs": [{ // Deshabilita función Sort columna Acciones.
                            "targets": [0, 4],
                            "orderable": false
                        },
                        //Da prioridad a la primera, segunda y última columna:
                        { "responsivePriority": 1, targets: 0 }, // Columna Foto
                        { "responsivePriority": 2, targets: 1 }, // Columna Nombre
                        { "responsivePriority": 3, targets: 2 }, // Columna Rol
                        { "responsivePriority": 4, targets: -1 }   // Obliga a mostrar siempre la columna Acciones.
                        ],
                        "select": false
                    });

                    if (operacion == 1) {
                        $("#frmPerfilProyecto :input").prop("disabled", true);
                        $("#divGuardarCambios").remove();
                        $("#hTitulo").text("Proyecto en consulta");
                    } else {
                        $("#hTitulo").text("Proyecto en edición");
                    }

                    $("#btnAgregarParticipante").prop("disabled", true);

                }).catch(error => {
                    MostrarMensaje(error);
                    //window.location.replace(document.referrer);
                });
            }
            else {
                let urlPage404 = '<%=ResolveUrl("Proyectos.aspx") %>';
                window.location.href = urlPage404;
            }
        });

        function DatosPrueba() {
            $("#txtTitulo").val("Título 1");
            $("#txtDescripcion").val("Descripcion del proyecto 1");
            $("#txtAlcance").val("Alcance del proyecto 1");
            $("#txtObjetivoMinimo").val("Obejtivo mínimo del proyecto 1");
            $("#cmbEmpresa").val(1); //Empresa 1
            $("#cmbTipoProyecto").val(1); //Productos
            $("#txtProgramaAcademico").val("Programa Academico 1");
            $("#txtAsignaturaAcademica").val("Asignatura Academica 1");
        }

        //---------------------------------------------------------------------------------------------------
        // Obtiene una lista de Programas académicos sugeridos
        //---------------------------------------------------------------------------------------------------
        $('.auttoCompleteProgramaAcademico').autoComplete({
            resolver: 'custom',
            events: {
                search: function (stringQuery, callback) {
                    var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                    $.ajax({
                        type: "POST",
                        url: pageUrl + "/ListaProgramasAcademicosSugeridos",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        processData: false,
                        async: false,
                        data: JSON.stringify({ 'stringQuery': stringQuery }),
                        success: function (response) {
                            var objResultado = JSON.parse(response.d);

                            if (objResultado.Codigo == '0') {
                                callback(objResultado.Resultado)
                            } else {
                                //MostrarMensaje(objResultado.Mensaje);
                            }
                        },
                        failure: function (response) {
                            MostrarMensaje(response.status);
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

                            MostrarMensaje(mensaje);
                        }
                    });
                }
            }
        });

        $("#btnAgregarParticipante").on("click", function () {
            let IdNuevoParticipante = ObtenerIDNuevoParticipante()

            let dataNuevoParticipante = {};
            dataNuevoParticipante.IdProyecto = $("#hddIDProyecto").val();
            dataNuevoParticipante.IdUsuario = IdNuevoParticipante;

            AgregarParticipante(dataNuevoParticipante);
        });

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

        $('#cmbParticipanteSugerido').select2({
            dropdownParent: $('#dlgNuevoParticipanteModal'),
            ajax: {
                url: '<%=ResolveUrl("~/wsBocore.asmx")%>' + "/ListaUsuariosSugeridos",
                contentType: "application/json; charset=utf-8",
                processData: false,
                type: 'POST',
                dataType: 'json',
                delay: 250,
                data: function (params) {
                    return JSON.stringify({ search: params.term })
                },
                processResults: function (data) {
                    var objResultado = JSON.parse(data.d);
                    if (objResultado.Codigo != '-1') {
                        //console.log();
                        var results = [];
                        if (objResultado.Resultado == null) 
                            return { results: results };
                        else 
                            return { results: objResultado.Resultado };
                        // Transforms the top-level key of the response object from 'items' to 'results'
                    } else {
                        MostrarMensaje(objResultado.Mensaje);
                    }
                },
                escapeMarkup: function (text) { return text; },
                width: '100%', //No trabaja aquí-Forza a establecer el ancho del contenedor del select al 100%.
                cache: true
            },
            language: "es",
            minimumInputLength: 2, // Solo inicia la bísqueda cuando el usuario haya ingresado 3 o más caracteres
            placeholder: "- Seleccione -",
        }).on('select2:select', function (e) {
            //var data = e.params.data;
            //console.log(data.selected);
            $("#btnAgregarParticipante").prop("disabled", false);
        });

        //---------------------------------------------------------------------------------------------------------------------
        // Guarda cambios del perfil del proyecto.
        //---------------------------------------------------------------------------------------------------------------------
        $('#frmPerfilProyecto').submit(function (e) {
            e.preventDefault();  //prevent form from submitting

            // recupera datos del formulario Perfil del Proyecto.
            let dataProyecto = {};
            dataProyecto.IdProyecto = $("#hddIDProyecto").val();
            dataProyecto.Titulo = $("#txtTitulo").val();
            dataProyecto.Descripcion = $("#txtDescripcion").val();
            dataProyecto.Alcance = $("#txtAlcance").val();
            dataProyecto.ObjetivoMinimo = $("#txtObjetivoMinimo").val();
            dataProyecto.IdEmpresa = $("#cmbEmpresa").val();
            dataProyecto.IdModalidad = $("#cmbModalidad").val();
            dataProyecto.IdTipoProyecto = $("#cmbTipoProyecto").val();
            dataProyecto.ProgramaAcademico = $("#txtProgramaAcademico").val();
            dataProyecto.AsignaturaAcademica = $("#txtAsignaturaAcademica").val();
            dataProyecto.IdEtapaActual = 1; //Por defecto
            dataProyecto.IdEstadoProyecto = 1; //Por defecto

            ActualizarProyecto(dataProyecto);
        });

        $("#btnNuevoParticipante").on("click", function () {
            // Limpia o remueve la lsita de items seleccionados de la lista de sugeridos.
            $("#cmbParticipanteSugerido").empty().trigger("change");
        });

        //---------------------------------------------------------------------------------------------------------------------
        // Vincula al proyecto actual un nuevo participante..
        //---------------------------------------------------------------------------------------------------------------------
        function AgregarParticipante(dataNuevoParticipante) {
            //alert('AgregarParticipante.');
            var dataObject = "{'dataNuevoParticipante':" + JSON.stringify(dataNuevoParticipante) + "}";
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                url: pageUrl + "/AgregarParticipanteProyecto",
                cache: false,
                //contentType: false,
                //processData: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false, // Para usar con promesas
                data: dataObject,
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    //alert(objResultado.Codigo);
                    if (objResultado.Codigo == '0') {
                        //ListaParticipantesProyecto($("#hddIDProyecto").val()).then(estado => {
                        //    $('#tblParticipantes').dataTable({
                        //        //"dom": 'Bfrtip',
                        //        //"buttons": [
                        //        //    'copy', 'csv', 'excel', 'pdf', 'print'
                        //        //],
                        //        "stateSave": true,  /* Guarda el estado de la tabla (su posición de paginación, estado de pedido, etc.) para que se pueda restaurar cuando el usuario recargue una página o regrese a la página después de visitar una subpágina*/
                        //        "language": {
                        //            "url": "//cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
                        //        },
                        //        "responsive": true,
                        //        "columnDefs": [{ // Deshabilita función Sort columna Acciones.
                        //            "targets": [2],
                        //            "orderable": false
                        //        },
                        //        //Da prioridad a la primera, segunda y última columna:
                        //        { "responsivePriority": 1, targets: 0 }, // Columna Nombre
                        //        { "responsivePriority": 2, targets: 1 }, // Columna Rol
                        //        { "responsivePriority": 3, targets: -1 }   // Obliga a mostrar siempre la columna Acciones.
                        //        ],
                        //        "select": false
                        //    });

                        //    if ($("#hddOperacion").val() == 1) {
                        //        $("#frmPerfilProyecto :input").prop("disabled", true);
                        //        $("#divGuardarCambios").remove();
                        //    }
                        //    // Cierra el diálogo Modal
                        //    $("#dlgNuevoParticipanteModal").modal("hide");

                        //}).catch(error => {
                        //    MostrarMensaje(error);
                        //    //window.location.replace(document.referrer);
                        //});
                        // Carga el registro de datos del proyecto actual.
                        window.location.href = "EditarProyecto.aspx?Id=" + $("#hddIDProyecto").val() + "&op=" + $("#hddOperacion").val();
                    } else {
                        MostrarMensaje(objResultado.Mensaje);
                    }
                },
                failure: function (response) {
                    MostrarMensaje(response.status);
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

                    MostrarMensaje(mensaje);
                }
            });
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Cerrar Sesión: Se apoya de un button ASP.Net oculto
        //---------------------------------------------------------------------------------------------------------------------
        function CerrarSesion() {
            // alert('Cerrando sesión');
            document.getElementById('btnCerrarSesion').click();
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Recupera el registro de datos para el proyecto especificado.
        //---------------------------------------------------------------------------------------------------------------------
        function EditarProyecto(idProyecto) {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/EditarProyecto",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    data: JSON.stringify({ 'idProyecto': idProyecto }),
                    async: false,  // Establecer en false si se invoca desde una promesa.
                    success: function (response) {
                        var objResultado = JSON.parse(response.d);

                        if (objResultado.Codigo == '0') {
                            let dataProyecto = objResultado.Resultado;

                            $("#hddIDProyecto").val(dataProyecto.IdProyecto);
                            $("#cmbTipoProyecto").val(dataProyecto.IdTipoProyecto);
                            $("#txtTitulo").val(dataProyecto.Titulo);
                            $("#txtDescripcion").val(dataProyecto.Descripcion);
                            $("#txtAlcance").val(dataProyecto.Alcance);
                            $("#txtObjetivoMinimo").val(dataProyecto.ObjetivoMinimo);
                            $("#cmbEmpresa").val(dataProyecto.IdEmpresa);
                            $("#cmbModalidad").val(dataProyecto.IdModalidad);
                            $("#txtProgramaAcademico").val(dataProyecto.ProgramaAcademico);
                            $("#txtAsignaturaAcademica").val(dataProyecto.AsignaturaAcademica);
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

        function EliminarParticipante(idUsuario) {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';
                //alert("Eliminado usuario");
                $.ajax({
                    type: "POST",
                    url: pageUrl + "/EliminarParticipante",
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

        function fConsultar(obj) {
            let fila = $(obj).parent().parent(); //Objeto fila
            //alert($(fila).attr('id')); // Id de fila
            window.location.href = "/EditarParticipante.aspx?Id=" + $(fila).attr('id') + "&op=1";
        }

        function fEditar(obj) {
            let fila = $(obj).parent().parent(); //Objeto fila
            //alert($(fila).attr('id')); // Id de fila
            window.location.href = "/EditarParticipante.aspx?Id=" + $(fila).attr('id') + "&op=2";
        }

        function fEliminar(obj) {
            let fila = $(obj).parent().parent(); //Objeto fila
            _gIdUsuario = $(fila).attr('id');
            //alert(_gIdUsuario);
            //$('#dlgMensajeConfirmacionModal').modal('show');
            //$('#tblUsuarios").DataTable().ajax.reload();
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Actualiza el registro de datos del proyecto actual..
        //---------------------------------------------------------------------------------------------------------------------
        function ActualizarProyecto(dataProyecto) {
            //alert('ActualizarProyecto.');
            var dataObject = "{'dataProyecto':" + JSON.stringify(dataProyecto) + "}";
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                url: pageUrl + "/ActualizarProyecto",
                cache: false,
                //contentType: false,
                //processData: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false, // Para usar con promesas
                data: dataObject,
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    if (objResultado.Codigo == '0') {
                        // Carga el registro de datos del proyecto actual.
                        window.location.href = "EditarProyecto.aspx?Id=" + $("#hddIDProyecto").val() + "&op=" + $("#hddOperacion").val();
                    } else {
                        MostrarMensaje(objResultado.Mensaje);
                    }
                },
                failure: function (response) {
                    MostrarMensaje(response.status);
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

                    MostrarMensaje(mensaje);
                }
            });
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Devuelve una lista de empresas.
        //---------------------------------------------------------------------------------------------------------------------
        function ListaEmpresas() {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/ListaEmpresas",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    async: false,
                    data: "",
                    success: function (response) {
                        var objResultado = JSON.parse(response.d);

                        $("#cmbEmpresa").empty();
                        $("#cmbEmpresa").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");

                        if (objResultado.Codigo == '0') {
                            $.each(objResultado.Resultado, function (i, listado) {
                                $("#cmbEmpresa").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
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

        //---------------------------------------------------------------------------------------------------------------------
        // Devuelve una lista de modalidades de acompañamiento de proyectos..
        //---------------------------------------------------------------------------------------------------------------------
        function ListaModalidades() {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/ListaModalidades",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    async: false,
                    data: "",
                    success: function (response) {
                        var objResultado = JSON.parse(response.d);

                        $("#cmbModalidad").empty();
                        $("#cmbModalidad").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");

                        if (objResultado.Codigo == '0') {
                            $.each(objResultado.Resultado, function (i, listado) {
                                $("#cmbModalidad").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
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

        function ListaParticipantesProyecto(idProyecto) {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';
                //alert("CargarParticipantes");
                $.ajax({
                    type: "POST",
                    url: pageUrl + "/ListaParticipantesProyecto",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    async: false, // Para usar con promesas
                    data: JSON.stringify({ 'idProyecto': idProyecto }),
                    success: function (response) {
                        let objResultado = JSON.parse(response.d);

                        if (objResultado.Codigo == '0') {
                            $("#tbdDetalleParticipantes").empty();

                            let htmlTR = "";
                            let operacion = $("#hddOperacion").val();

                            $.each(objResultado.Resultado, function (i, usuario) {
                                if (operacion == 1) { // Modo Consulta
                                    htmlTR = `<tr id="${usuario.IdParticipante}">
                                                        <td><img src="${usuario.Foto}" class="img-fluid"  height="80px" width="60px" /></td>
                                                        <td>${usuario.Nombre}</td>
                                                        <td>${usuario.Rol}</td>
                                                        <td>${usuario.Telefono}</td>
                                                        <td class="text-center">
                                                            <a href="javascript:void(0);" class="disabled" name="eliminar"><i class="fa fa-trash" aria-hidden="true"></i></a>
                                                        </td>
                                                    </tr>`;

                                                            //<a href="#" class="disabled"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a>
                                                            //<a href="#" onclick="fConsultar(this);"><i class="fa fa-eye" aria-hidden="true"></i></a>
                                }
                                else { // Modo Edición
                                    htmlTR = `<tr id="${usuario.IdParticipante}">
                                                        <td><img src="${usuario.Foto}" class="img-fluid"  height="80px" width="60px" /></td>
                                                        <td>${usuario.Nombre}</td>
                                                        <td>${usuario.Rol}</td>
                                                        <td>${usuario.Telefono}</td>
                                                        <td class="text-center">
                                                            <a href="javascript:void(0);" data-toggle="modal" data-target="#dlgMensajeConfirmacionModal" onclick="fEliminar(this);"><i class="fa fa-trash" aria-hidden="true"></i></a>
                                                        </td>
                                                    </tr>`;
                                                            //<a href="#" onclick="fEditar(this);"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a>
                                                            //<a href="#" onclick="fConsultar(this);"><i class="fa fa-eye" aria-hidden="true"></i></a>
                                }

                                // Agrega una fila con informaciónb'asica de un participante.
                                $('#tbdDetalleParticipantes').append(htmlTR);
                            });
                            resolve(true);
                        } else if (objResultado.Codigo == '1') {
                            $("#tbdDetalleParticipantes").empty();
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
        // Devuelve una lista de Programas Academicos.
        //---------------------------------------------------------------------------------------------------------------------
        function ListaProgramasAcademicos() {
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                url: pageUrl + "/ListaProgramasAcademicos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                processData: false,
                async: false,
                data: JSON.stringify({ 'estado': 'activo' }),
                success: function (response) {
                    var objResultado = JSON.parse(response.d);

                    $("#cmbProgramaAcademico").empty();
                    $("#cmbProgramaAcademico").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");

                    if (objResultado.Codigo == '0') {
                        $.each(objResultado.Resultado, function (i, listado) {
                            $("#cmbProgramaAcademico").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
                        });
                    } else {
                        MostrarMensaje(objResultado.Mensaje);
                    }
                    //resultado = true;
                },
                failure: function (response) {
                    MostrarMensaje(response.status);
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

                    MostrarMensaje(mensaje);
                }
            });
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Devuelve una lista de Tipos de Proyecto.
        //---------------------------------------------------------------------------------------------------------------------
        function ListaTiposProyecto() {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/ListaTiposProyecto",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    async: false,
                    data: "",
                    success: function (response) {
                        var objResultado = JSON.parse(response.d);

                        $("#cmbTipoProyecto").empty();
                        $("#cmbTipoProyecto").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");

                        if (objResultado.Codigo == '0') {
                            $.each(objResultado.Resultado, function (i, listado) {
                                $("#cmbTipoProyecto").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
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

        //---------------------------------------------------------------------------------------------------------------------
        // Presenta una ventana modal con un mensaje
        //---------------------------------------------------------------------------------------------------------------------
        function MostrarMensaje(mensaje) {
            $("#divCuerpoMensaje").empty();
            $("#divCuerpoMensaje").html(mensaje);
            // Presenta el diálogo Modal
            $("#dlgMensajeModal").modal('show');
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Devuelve el Identifcador del nuevo participante del proyecto actual.
        //---------------------------------------------------------------------------------------------------------------------
        function ObtenerIDNuevoParticipante() {
            // Recupera el ID del nuevo participante.
            let idNuevoParticipante;
            let data = $('#cmbParticipanteSugerido').select2('data');
            data.forEach(function (item) {
                idNuevoParticipante = item.id;
            });
            return idNuevoParticipante;
        }
    </script>
</body>
</html>

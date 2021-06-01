<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EtapasProyecto.aspx.vb" Inherits="Proyectos_EtapasProyecto" %>
+
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOCORE | Etapas</title>
    <link rel="stylesheet" href="../css/bootstrap.min.css" />
    <link rel="stylesheet" href="../css/hover/hover-min.css" />
    <link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" />
    <link href="../css/bocore.css" rel="stylesheet" />

    <style>
/*        .popover {background-color: #000000;  color:#ffffff; font-size: 18px;}
        .popover.bottom .arrow::after {border-bottom-color: #F3782F; }
        .popover-content {background-color: tomato;}*/

        /* Elimina el bord de los diálogos modales*/
        .modal-content {
            border: 0px;
        }

        .popover-header {
            color: white;
            padding: .5rem .75rem;
            margin-bottom: 0;
            font-size: 1rem;
            background-color: #000000;
            border-bottom: 1px solid #ebebeb;
            border-top-left-radius: calc(.3rem - 1px);
            border-top-right-radius: calc(.3rem - 1px);
        }

        .popover-body {
            background-color: #AED6F1;
            color: black;
            font-size:18px;
            padding: .5rem .75rem;
             border: 2px;
        }

        .bs-popover-auto[x-placement^=top]>.arrow::after, .bs-popover-top>.arrow::after {
            bottom: 0px;
            border-width: .6rem .6rem 0;
            border-top-color: #AED6F1;
            border-bottom-color: red !important;
        }

        .remove-image {
            display: none;
            position: absolute;
            top:-10px;
            right: 10px;
            border-radius: 10em;
            padding: 2px 6px 3px;
            text-decoration: none;
            font: 700 21px/20px sans-serif;
            background: #555;
            border: 3px solid #fff;
            color: #FFF;
            box-shadow: 0 2px 6px rgba(0,0,0,0.5), inset 0 2px 4px rgba(0,0,0,0.3);
            text-shadow: 0 1px 2px rgba(0,0,0,0.5);
            -webkit-transition: background 0.5s;
            transition: background 0.5s;
        }

        .remove-image:hover {
            background: #E54E4E;
            padding: 3px 7px 5px;
            top: -11px;
            right: 11px;
        }
        .remove-image:active {
            background: #E54E4E;
            top:-11px;
            right: 11px;
        }

        .card-img-top {
        width: 100%;
        height: 15rem!important;
        object-fit: contain;
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
<%--                        <li class="nav-item">
                            <a class="nav-link" href="/Empresas/Empresas.aspx">
                                <span data-feather="book-open"></span>
                                Empresas
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/Usuarios.aspx">
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
                        </li>--%>
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
                    <a href="#">Home</a> - Etapas proyecto
                </div>
                <div class="contentBox">
                    <div class="row mb-4 mt-1">
                        <div class="col-12 col-lg-7">
                            <h3 class="titulo">Proyecto - Nombre de Proyecto Nombre de Proyecto Nombre de Proyecto</h3>
                        </div>
                        <div class="col-12 col-lg-5 text-right"><a href="Proyectos.aspx" class="btn btn-primary">Volver a Proyectos</a></div>
                    </div> 
                    <div class="row">
                         <div class="col-12 col-lg-7">
                            <p>
                                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque mauris at malesuada aliquam. Aenean dictum odio molestie sapien pharetra, eu ullamcorper orci posuere. Duis justo mi, rutrum ac ipsum vitae, vestibulum
                        lobortis ante. Nam felis mauris, dictum id tellus vitae, faucibus accumsan nisl.
                            </p>
                            <p>
                                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque mauris at malesuada aliquam. Aenean dictum odio molestie sapien pharetra, eu ullamcorper orci posuere. Duis justo mi, rutrum ac ipsum vitae, vestibulum
                        lobortis ante. Nam felis mauris, dictum id tellus vitae, faucibus accumsan nisl.
                            </p>
                            <p>
                                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque mauris at malesuada aliquam. Aenean dictum odio molestie sapien pharetra, eu ullamcorper orci posuere. Duis justo mi, rutrum ac ipsum vitae, vestibulum
                        lobortis ante. Nam felis mauris, dictum id tellus vitae, faucibus accumsan nisl.
                            </p>
                        </div>
                         <div class="col-12 col-lg-5 text-right table-bordered">
                               <input id="hddIDProyecto" name="IdProyecto" type="hidden" value="">
                                    <div class="row">
                                        <div class="col-4 pt-5">
                                            <img src="../images/logo.png" class="img-fluid" />
                                        </div>
                                        <div id="divInfoProyecto" class="col-8">
                                            <b>Programa</b>
                                            <p>Ingeniería de Software</p>
                                            <b>Fecha de Inicio</b>
                                            <p>18/01/2020</p>
                                            <b>Modalidad</b>
                                            <p>Profesor Experto</p>
                                            <b>Información Empresa</b>
                                            <p>Teléfono: 6545454</p>
                                            <p>Email: info@empresa.com</p>
                                            <p>Coordinador: Juan Perez</p>
                                        </div>
                                    </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <h3>Etapas del Proyecto</h3>
                        </div>
                    </div>

                    <div class="row etapas">
                        <div class="col-sm">
                            <div class="etapa active">
                                <a href="/Etapas/PresentacionReto.aspx" class="text-white">
                                    Presentación
                                    <br />
                                    Reto
                                </a>
                            </div>
                        </div>
                        <div class="col-sm">
                            <div class="etapa active">
                                Conecta y
                                <br />
                                Plasma
                            </div>
                        </div>
                        <div class="col-sm">
                            <div class="etapa">
                                Retroalimentación
                            </div>
                        </div>
                        <div class="col-sm">
                            <div class="etapa">
                                Validación
                            </div>
                        </div>
                        <div class="col-sm">
                            <div class="etapa">
                                Presentación
                                <br />
                                Final
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                           <h3>Participantes</h3>
                        </div>
                    </div>

                    <div class="row justify-content-center participantes ">
                        <div id="divParticipantesProyecto" class="row w-100">
<%--                              <div class="card col-12 col-sm-6 col-md-4 col-xl-3">
                                <img src="/images/Silueta.png" class="card-img-top rounded-circle mx-auto d-block" alt="...">
                                <div class="card-body">
                                  <h5 class="card-title">Andrés Liévano</h5>
                                  <p class="card-text">Estudiante</p>
                                </div>
                                <div class="card-footer">
                                  <small class="text-muted">320 9192537</small>
                                </div>
                              </div>
                              <div class="card col-12 col-sm-6 col-md-4 col-xl-3">
                                <img src="/Files/CentroServicio1/Usuarios/673b172f-a9f1-4fae-9abb-c09bbec92230_Jorge_Lievano.JPG" class="card-img-top rounded-circle mx-auto d-block" style="height: 15rem;" alt="...">
                                <div class="card-body">
                                  <h5 class="card-title">Juan José Lievano Jaimes</h5>
                                  <p class="card-text">Profesor</p>
                                </div>
                                <div class="card-footer">
                                  <small class="text-muted">321 7845123</small>
                                </div>
                              </div>
                              <div class="card col-12 col-sm-6 col-md-4 col-xl-3">
                                <img src="/images/Silueta.png" class="card-img-top rounded-circle" alt="...">
                                <div class="card-body">
                                  <h5 class="card-title">Jorge uriel Lievano</h5>
                                  <p class="card-text">Coordinador</p>
                                </div>
                                <div class="card-footer">
                                  <small class="text-muted">300 1245789</small>
                                </div>
                              </div>
                              <div class="card col-12 col-sm-6 col-md-4 col-xl-3">
                                <img src="/Files/CentroServicio1/Usuarios/673b172f-a9f1-4fae-9abb-c09bbec92230_Jorge_Lievano.JPG" class="card-img-top rounded-circle mx-auto d-block" style="height: 15rem;" alt="...">
                                <div class="card-body">
                                  <h5 class="card-title">Juan José Lievano Jaimes</h5>
                                  <p class="card-text">This card has supporting.</p>
                                </div>
                                <div class="card-footer">
                                  <small class="text-muted">Last updated 3 mins ago</small>
                                </div>
                              </div>
                              <div class="card col-12 col-sm-6 col-md-4 col-xl-3">
                                <img src="/images/Silueta.png" class="card-img-top rounded-circle mx-auto d-block" alt="...">
                                <div class="card-body">
                                  <h5 class="card-title">ANdrés Felipe Liévano</h5>
                                  <p class="card-text">This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                                </div>
                                <div class="card-footer">
                                  <small class="text-muted">Last updated 3 mins ago</small>
                                </div>
                              </div>--%>
                       </div>

<%--                        <div class="col-4 col-sm-3 col-md-2">
                            <img src="/images/Silueta.png" class="img-fluid rounded-circle" />
                            <h5>Juan Perez</h5>
                            <p>Profesor</p>
                        </div>
                        <div class="col-4 col-sm-3 col-md-2">
                            <img src="../images/people.PNG" class="img-fluid" />
                            <h5>Juan Perez</h5>
                            <p>Estudiante</p>
                        </div>
                        <div class="col-4 col-sm-3 col-md-2">
                            <img src="../images/people.PNG" class="img-fluid" />
                            <h5>Juan Perez</h5>
                            <p>Estudiante</p>
                        </div>
                        <div class="col-4 col-sm-3 col-md-2">
                            <img src="../images/people.PNG" class="img-fluid" />
                            <h5>Juan Perez</h5>
                            <p>Estudiante</p>
                        </div>
                        <div class="col-4 col-sm-3 col-md-2">
                            <img src="../images/people.PNG" class="img-fluid" />
                            <h5>Juan Perez</h5>
                            <p>Estudiante</p>
                        </div>--%>
                    </div>

                    <div class="row my-3 w-100">
                        <div class="col-6">
                            <h3 class="titulo p-0 ">Documentación</h3>
                        </div> 
                        <div class="col-6 text-right">
                             <a id="lnkAgregarDocumento" href="#" class="btn btn-primary" data-toggle="modal" data-target="#dlgCargarDocumentoModal">+ Agregar documento</a>
                        </div>
                    </div> 

                    <div class="row  justify-content-center mx-1 pt-2 mb-0">
                        <div id="divDocumentosProyecto" class="full-height w-100">

<%--                            <div class="full-height-item col-12 col-lg-6">
                                <div class="row documentos">
                                    <div class="col-4 col-sm-3 bg-infoX">
                                           <img src="../images/documento.png" class="img-fluid"  />
                                           <a class="remove-image poplink" href="#" data-id="1000" style="display: inline;" onclick="fEliminarDocumento(this);">&#215;</a>
                                    </div>
                                    <div class="col-8 col-sm-9">
                                        <p class="text-left">
                                            <span class="font-weight-bold">Documento</span><br>
                                            bootstrap-autocomplete-readthedocs-io-en-latest<br>
                                            <span class="font-weight-bold">Respnsable</span><br>
                                            Jorge Urile Lievano Cifuentes<br>
                                            <span class="font-weight-bold">Fecha registro</span><br>
                                            05-May-2021 10:15;28<br>
                                            <a href="https://static.wikia.nocookie.net/disney/images/3/35/Pluto.png" download="Pluto">Descargar</a>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="full-height-item col-12 col-lg-6">
                                <div class="row documentos">
                                    <div class="col-4 col-sm-3 bg-infoX">
                                           <img src="../images/documento.png" class="img-fluid"  />
                                           <a class="remove-image poplink" href="#" data-id="1000" style="display: inline;" onclick="fEliminarDocumento(this);">&#215;</a>
                                    </div>
                                    <div class="col-8 col-sm-9">
                                        <p class="text-left">Documento</p>
                                    </div>
                                </div>
                            </div>
                            <div class="full-height-item col-12 col-lg-6">
                                <div class="row documentos">
                                    <div class="col-4 col-sm-3 bg-infoX">
                                           <img src="../images/documento.png" class="img-fluid"  />
                                           <a class="remove-image poplink" href="#" data-id="1000" style="display: inline;" onclick="fEliminarDocumento(this);">&#215;</a>
                                    </div>
                                    <div class="col-8 col-sm-9">
                                        <p class="text-left">Documento</p>
                                    </div>
                                </div>
                            </div>
                            <div class="full-height-item col-12 col-lg-6">
                                <div class="row documentos">
                                    <div class="col-4 col-sm-3 bg-infoX">
                                           <img src="../images/documento.png" class="img-fluid"  />
                                           <a class="remove-image poplink" href="#" data-id="1000" style="display: inline;" onclick="fEliminarDocumento(this);">&#215;</a>
                                    </div>
                                    <div class="col-8 col-sm-9">
                                        <p class="text-left">
                                            <span class="font-weight-bold">Documento</span><br>
                                            bootstrap-autocomplete-readthedocs-io-en-latest<br>
                                            <span class="font-weight-bold">Respnsable</span><br>
                                            Jorge Urile Lievano Cifuentes<br>
                                            <span class="font-weight-bold">Fecha registro</span><br>
                                            05-May-2021 10:15;28
                                        </p>
                                    </div>
                                </div>
                            </div>--%>
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

        <!-- Modal Cargar dpcumento -->
    <div class="modal fade" id="dlgCargarDocumentoModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="CargarDocumentoModalLabel" aria-hidden="true" style="z-index: 1700;">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header bg-success text-white py-0" style="border-bottom: -1px!important;">
                    <h5 class="modal-title  text-white" id="CargarDocumentoModalLabel">Cargar documento</h5>
                    <a href="#" class="close poplink" data-dismiss="modal" aria-label="Close" style="line-height:initial;" >
                         <span aria-hidden="true" class="text-white font-weight-bold">&times;</span>
                    </a>
                </div>
                <div class="modal-body">
                    <button id="btnfileUpload" class="btn btn-light border border-dark" onclick="document.getElementById('fileUploadDocumento').click()">Seleccionar archivo...</button>
                    &nbsp;
                   <span id="spnfileChoise">Archivo no escogido</span>
                    <input id="fileUploadDocumento" type="file" name="fileUploadDocumento" style="display: none;" />
                </div>
                <div class="modal-footer">
                    <%--        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>--%>
                    <button id="btnSubirDocumento" type="button" class="btn btn-primary" disabled>Guardar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Diálogo de Mensajes -->
    <div class="modal fade" id="dlgMensajeModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="MensajeModalLabel" aria-hidden="true" style="z-index: 1900;">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header bg-success text-white py-0" style="border-bottom: -1px!important;">
                    <h5 class="modal-title text-white" id="MensajeModalLabel">Bocore</h5>
                    <a href="#" class="close poplink" data-dismiss="modal" aria-label="Close" style="line-height:initial;" >
                         <span aria-hidden="true" class="text-white font-weight-bold">&times;</span>
                    </a>
                </div>
                <div id="divCuerpoMensaje" class="modal-body word-wrap-break-word" >
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
                    <a href="#" class="close poplink" data-dismiss="modal" aria-label="Close" style="line-height:initial;" >
                         <span aria-hidden="true" class="text-white font-weight-bold">&times;</span>
                    </a>
                </div>
                <div id="divMensajeConfirmacion" class="modal-body">
                    <span id="spnMensajeConfirmacion">¿Está usted seguro de eliminar este Proyecto?</span>
                </div>
                <div class="modal-footer">
                    <button id="btnEliminarDocumento" data-id="0" type="button" class="btn btn-primary mr-sm-2">Aceptar</button>
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
    <%--    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/sweetalert2@9.5.4/dist/sweetalert2.all.min.js"></script>--%>
    <script type="text/javascript" src="../js/tabledit/jquery.tabledit.min.js"></script>
    <%--    <script type="text/javascript" src="../js/custom.js"></script>--%>
    <script type="text/javascript" src="../js/URLParametros.js"></script>
</body>

    <script type="text/javascript">
        var _gTamañoMaxArchivo = 10485760; //10 MB

        $(document).ready(function () {
            let idProyecto = getURLParameter("Id");
            let operacion = getURLParameter("op");

            //let idProyecto =1;
            //let operacion = 2;

            if (idProyecto != "null" && operacion != "null") {
                let usuarioLoggeado = '<%= Session("NombreUsuarioLoggeado") %>';
                $("#spnUsuarioLogueado").text(usuarioLoggeado);

                $("#hddIDProyecto").val(idProyecto);

                // Ejecuta secuencialmente y sincrónicamente las siguientes subrutinas.
                ObtenerInformarcionProyecto(idProyecto).then(estado => {
                    return ListaParticipantesProyecto(idProyecto);
                }).then(estado => {
                    return ListaDocumentosProyecto(idProyecto);
                }).then(estado => {
                    //if (operacion == 1) {
                    //    $("#frmPerfilEmpresa :input").prop("disabled", true);
                    //    $("#btnRemoverLogo").remove();
                    //    $("#divGuardarCambios").remove();
                    //    $("#hTitulo").text("Empresa");
                    //} else {
                    //    $("#hTitulo").text("Empresa - edición");
                    //}

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

        // Cancela el salto que se genera al hacer clic sobre un enlace.
        $('a.poplink').click(function (e) {
            e.preventDefault();
        });

        $("#lnkAgregarDocumento").on("click", function () {
            // Limpia el control fileUpload
            $("#fileUploadDocumento").val("");
            $("#spnfileChoise").html("Archivo no escogido");
            // Deshabilita el botón Subir archivo
            $('#btnSubirDocumento').prop('disabled', true);
        });

        $("#btnSubirDocumento").on("click", function () {
            // Desactiva el botón y agrega el icono spinner al botón
            BtnLoading(this);

            let datosDocumento = new FormData();
            datosDocumento.append("IdProyecto", $("#hddIDProyecto").val());
            datosDocumento.append("file", $("#fileUploadDocumento").prop('files')[0]);

            AgregarDocumentoProyecto(datosDocumento);
        });

        $('#dlgMensajeConfirmacionModal').on('hidden.bs.modal', function () {
            $("#btnEliminarDocumento").attr("data-id", 0);
        })

        $("#fileUploadDocumento").on("change", function () {
            //console.log(this.files[0].size);
            if (this.files[0].size > _gTamañoMaxArchivo) {
                MostrarMensaje("No se permite cargar archivos de más de " + _gTamañoMaxArchivo / 1024 / 1024 + "MB");
            } else {
                var fileName = $(this).val().split("\\").pop();
                $(this).siblings("#spnfileChoise").addClass("selected").html(fileName);
                // Habilita el botón Subir archivo
                $('#btnSubirDocumento').prop('disabled', false);
            }
        });

        //---------------------------------------------------------------------------------------------------------------------
        // Cerrar Sesión: Se apoya de un button ASP.Net oculto
        //---------------------------------------------------------------------------------------------------------------------
        function CerrarSesion() {
            // alert('Cerrando sesión');
            document.getElementById('btnCerrarSesion').click();
        }

        function fEliminarDocumento(obj) {
            //alert("Eliminado documento..." + $(obj).data("id"));
            $("#btnEliminarDocumento").attr("data-id", $(obj).data("id"));
            $('#dlgMensajeConfirmacionModal').modal('show');
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Elimina el documento del proyecto. actual
        //---------------------------------------------------------------------------------------------------------------------
        function EliminarDocumento(idProyecto, idDocumento, nombreArchivoDocumentoServidor) {
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                //headers: token,
                url: pageUrl + "/EliminarDocumento",
                cache: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                data: JSON.stringify({ 'idProyecto': idProyecto, 'idDocumento': idDocumento, 'nombreArchivoDocumentoServidor': nombreArchivoDocumentoServidor }),
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    // Cierra el diálogo Modal
                    $("#dlgMensajeConfirmacionModal").modal("hide");

                    if (objResultado.Codigo == '0') {
                        MostrarMensaje("Documento eliminado exitosamente");
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
        // Guardar documento en el proyecto.
        //---------------------------------------------------------------------------------------------------------------------
        function AgregarDocumentoProyecto(datosDocumento) {
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            // NOTA: Cuando enviamos datos con FORMDATA a través Ajaz y queremos que el
            // web service nos regrese un objeto JSON, debemos tener en cuenta las siguientes condiciones.
            // Del lado del CLIENTE, en la fun´ción Ajax debe configurar las siguiente propiedas 
            // a false (contentType, processData), mientras que...
            // Del lado del SERVIDOR, el método debe retornar el objeto serializdo en JSON
            // y retornarlo usando el objeto RESPONSE.
            $.ajax({
                type: "POST",
                //headers: token,
                //data: $("#formFamiliar").serialize(),
                url: pageUrl + "/AgregarDocumentoProyecto",
                cache: false,
                contentType: false,   // tell jQuery not to set contentType
                processData: false,  // tell jQuery not to process the data
                async: true,
                data: datosDocumento,  //FormData
                //global: false,  // this makes sure ajaxStart is not triggered
                success: function (response) {
                    // Agrega el icono spinner al botón
                    BtnReset($("#btnSubirDocumento"));

                    var objResultado = JSON.parse(response);
                    //console.log(objResultado);
                    //console.log(objResultado.Resultado);

                    if (objResultado.Codigo == '0') {
                        let documento = objResultado.Resultado;

                        //let htmlDocumento = `<div class="col-4 col-sm-3 col-md-2">
                        //                                        <a href="#" title="Información" class="poplink" data-toggle="popover" data-trigger="hover" data-placement="top" data-content="${documento.Nombre}">
                        //                                           <img src="../images/documento.png" class="img-fluid"  />
                        //                                           <a class="remove-image poplink" href="#" data-id="${documento.IdDocumento}" style="display: inline;" onclick="fEliminarDocumento(this);">&#215;</a>
                        //                                        </a>
                        //                                        <p>Documento</p>
                        //                                    </div>`;

                        let htmlDocumento = `<div class="full-height-item col-12 col-lg-6">
                                                                <div class="row documentos">
                                                                    <div class="col-4 col-sm-3 bg-infoX">
                                                                           <img src="../images/documento.png" class="img-fluid"  />
                                                                           <a class="remove-image poplink" href="#" data-id="${documento.IdDocumento}" style="display: inline;" onclick="fEliminarDocumento(this);">&#215;</a>
                                                                    </div>
                                                                    <div class="col-8 col-sm-9">
                                                                        <p class="text-left">
                                                                            <span class="font-weight-bold">Documento</span><br>
                                                                            ${documento.NombreArchivo}<br>
                                                                            <span class="font-weight-bold">Responsable</span><br>
                                                                            ${documento.Responsable}<br>
                                                                            <span class="font-weight-bold">Fecha registro</span><br>
                                                                           ${documento.FechaRegistro}<br>
                                                                           <a href="${documento.URL}" download="${documento.NombreArchivo}">Descargar</a>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                            </div>`;

                        // Agrega el nuevo documento a la sección de documentos del proyecto actual.
                        $('#divDocumentosProyecto').append(htmlDocumento);
                        // Cierra el diálogo modal.
                        $("#dlgCargarDocumentoModal").modal("hide");
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
            //return resultado;
        }

        // Almacena el texto/html original como un atributo y lo restaura desde allí.
        function BtnLoading(elem) {
            $(elem).attr("data-original-text", $(elem).html());
            $(elem).prop("disabled", true);
            $(elem).html('<i class="spinner-border spinner-border-sm"></i> Cargando...');
        }

        // Habilita de nuevo el botón y le remueve el icono del spinner.
        function BtnReset(elem) {
            $(elem).prop("disabled", false);
            $(elem).html($(elem).attr("data-original-text"));
        }

        function ListaDocumentosProyecto(idProyecto) {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/ListaDocumentosProyecto",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    async: false, // Para usar con promesas
                    data: JSON.stringify({ 'idProyecto': idProyecto }),
                    success: function (response) {
                        let objResultado = JSON.parse(response.d);

                        if (objResultado.Codigo == '0') {
                            $("#divDocumentosProyecto").empty();
                            $.each(objResultado.Resultado, function (i, documento) {
                                let htmlDocumento = `<div class="full-height-item col-12 col-lg-6">
                                                                        <div class="row documentos">
                                                                            <div class="col-4 col-sm-3 bg-infoX">
                                                                                   <img src="../images/documento.png" class="img-fluid"  />
                                                                                   <a class="remove-image poplink" href="#" data-id="${documento.IdDocumento}" style="display: inline;" onclick="fEliminarDocumento(this);">&#215;</a>
                                                                            </div>
                                                                            <div class="col-8 col-sm-9">
                                                                                <p class="text-left">
                                                                                    <span class="font-weight-bold">Documento</span><br>
                                                                                    ${documento.NombreArchivo}<br>
                                                                                    <span class="font-weight-bold">Responsable</span><br>
                                                                                    ${documento.Responsable}<br>
                                                                                    <span class="font-weight-bold">Fecha registro</span><br>
                                                                                   ${documento.FechaRegistro}<br>
                                                                                   <a href="${documento.URL}" download="${documento.NombreArchivo}">Descargar</a>
                                                                                </p>
                                                                            </div>
                                                                        </div>
                                                                    </div>`;

                                // Agrega el nuevo documento a la sección de documentos del proyecto actual.
                                $('#divDocumentosProyecto').append(htmlDocumento);
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
                            $("#divParticipantesProyecto").empty();
                            $.each(objResultado.Resultado, function (i, participante) {
                              //  let htmlParticipante = `<div class="card col-12 col-sm-6 col-md-4 col-xl-3">
                              //  <img src="${participante.Foto}" class="card-img-top rounded-circle mx-auto d-block" alt="...">
                              //  <div class="card-body">
                              //    <h5 class="card-title">${participante.Nombre}</h5>
                              //    <p class="card-text">Estudiante</p>
                              //  </div>
                              //  <div class="card-footer">
                              //    <small class="text-muted">Last updated 3 mins ago</small>
                              //  </div>
                              //</div>`;

                                let htmlParticipante = `<div class="card col-12 col-sm-6 col-md-4 col-xl-3">
                                                                        <img src="${participante.Foto}" class="card-img-top rounded-circle mx-auto d-block" alt="...">
                                                                            <div class="card-body">
                                                                                <h5 class="card-title">${participante.Nombre}</h5>
                                                                                <p class="card-text">${participante.Rol}</p>
                                                                            </div>
                                                                            <div class="card-footer">
                                                                                <small class="text-muted">${participante.Telefono}</small>
                                                                            </div>
                                                                   </div>`;

                                // Agrega un participante del proyecto actual.
                                $('#divParticipantesProyecto').append(htmlParticipante);
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

        function MostrarMensaje(mensaje) {
            //alert("Se requiere ingresar el Asunto");
            $("#divCuerpoMensaje").empty();
            $("#divCuerpoMensaje").html(mensaje);
            // Presenta el diálogo Modal
            $("#dlgMensajeModal").modal('show');
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Devuelve una lista de modalidades de acompañamiento de proyectos..
        //---------------------------------------------------------------------------------------------------------------------
        function ObtenerInformarcionProyecto(idProyecto) {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/ObtenerInformarcionProyecto",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    async: false,
                    data: JSON.stringify({ 'idProyecto': idProyecto }),
                    success: function (response) {
                        var objResultado = JSON.parse(response.d);

                        $("#divInfoProyecto").empty();

                        if (objResultado.Codigo == '0') {
                            let proyecto = objResultado.Resultado;

                            let htmlInfoProyecto = `<b>Programa</b>
                                <p>${proyecto.ProgramaAcademico}</p>
                                <b>Fecha de Inicio</b>
                                <p>${proyecto.FechaInicio}</p>
                                <b>Modalidad</b>
                                <p>${proyecto.Modalidad}</p>
                                <b>Información Empresa</b>
                                <p>${proyecto.InformacionEmpresa}</p>
                                <p><b>Email:</b> ${proyecto.Email}</p>
                                <p><b>Coordinador:</b> ${proyecto.Coordinador}</p>`;

                            // Agrega el nuevo documento a la sección de documentos del proyecto actual.
                            $('#divInfoProyecto').append(htmlInfoProyecto);
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
    </script>
</html>

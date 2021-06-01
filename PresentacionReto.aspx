<%@ Page Language="VB" AutoEventWireup="false" CodeFile="PresentacionReto.aspx.vb" Inherits="Etapas_PresentacionReto" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOCORE | Presentación del reto</title>
    <link rel="stylesheet" href="css/bootstrap.min.css" />
    <link rel="stylesheet" href="css/hover/hover-min.css" />
    <link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" />
    <link rel="stylesheet" href="css/bocore.css" />

    <script type="text/javascript">  
        function preventBack() { window.history.forward(); }
        setTimeout("preventBack()", 0);
        window.onunload = function () { null };
    </script>

    <style>
        .chat_message {
            border-bottom: 1px solid #c4c4c4;
            /*          margin: 0;*/
            /*          padding: 18px 16px 10px;*/
        }
    </style>
</head>
<body>

    <header class="navbar sticky-top bg-dark flex-md-nowrap p-0 shadow">
        <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3" href="#">
            <img src="images/logo.png" class="img-fluid" /></a>
        <%--        <button class="navbar-toggler position-absolute d-md-none collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <ul class="navbar-nav px-3 col-md-3 col-lg-2 text-right">--%>
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
                        <%--                       <li class="nav-item">
                            <a class="nav-link" href="#">
                                <span data-feather="shield"></span>
                                Seguridad
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <span data-feather="users"></span>
                                Usuarios
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
                                <span data-feather="book-open"></span>
                                Base de Conocimientos
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <span data-feather="archive"></span>
                                Recursos
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
                    <a href="#">Home</a> - Presentación del Reto
       
                </div>
                <div class="contentBox">
                    <div class="row">
                        <div class="col-sm p-0">
                            <div class="row pl-4 pr-2 pt-4">
                                <div class="col-lg-7">
                                    <h3 class="titulo">Proyecto - Nombre de Proyecto</h3>
                                </div>
                                <div class="col-lg-5 text-right">
                                    <a href="/Proyectos/Proyectos.aspx" class="btn btn-primary">Volver a Proyectos</a>
                                </div>
                            </div>
                            <div class="row mt-4 p-4">
                                <div class="col-lg-8">
                                    <div class="row">
                                        <div class="col-lg-8">
                                            <h3>La Empresa</h3>
                                            <div id="divDescEmpresa">
                                                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque mauris at malesuada aliquam. Aenean dictum odio molestie sapien pharetra, eu ullamcorper orci posuere. Duis justo mi, rutrum ac ipsum vitae, vestibulum
                                    lobortis ante. Nam felis mauris, dictum id tellus vitae, faucibus accumsan nisl.
                                            </div>
                                        </div>
                                        <div class="col-lg-4">
                                            <img src="images/logo.PNG" class="img-fluid pt-4" />
                                        </div>
                                    </div>


                                    <hr />
                                    <h3>Descripción del Reto</h3>
                                    <div id="divDescReto">
                                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque mauris at malesuada aliquam. Aenean dictum odio molestie sapien pharetra, eu ullamcorper orci posuere. Duis justo mi, rutrum ac ipsum vitae, vestibulum
                                lobortis ante. Nam felis mauris, dictum id tellus vitae, faucibus accumsan nisl.

                                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque mauris at malesuada aliquam. Aenean dictum odio molestie sapien pharetra, eu ullamcorper orci posuere. Duis justo mi, rutrum ac ipsum vitae, vestibulum
                                  lobortis ante. Nam felis mauris, dictum id tellus vitae, faucibus accumsan nisl.

                                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque mauris at malesuada aliquam. Aenean dictum odio molestie sapien pharetra, eu ullamcorper orci posuere. Duis justo mi, rutrum ac ipsum vitae, vestibulum
                                    lobortis ante. Nam felis mauris, dictum id tellus vitae, faucibus accumsan nisl.
                                    </div>
                                    <hr />
                                    <h3>Alcance</h3>
                                    <div id="divAlcance">
                                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque mauris at malesuada aliquam. Aenean dictum odio molestie sapien pharetra, eu ullamcorper orci posuere. Duis justo mi, rutrum ac ipsum vitae, vestibulum
                                lobortis ante. Nam felis mauris, dictum id tellus vitae, faucibus accumsan nisl.

                                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque mauris at malesuada aliquam. Aenean dictum odio molestie sapien pharetra, eu ullamcorper orci posuere. Duis justo mi, rutrum ac ipsum vitae, vestibulum
                                  lobortis ante. Nam felis mauris, dictum id tellus vitae, faucibus accumsan nisl.
                                    </div>
                                    <hr />
                                    <h3>Objetivo Mínimo</h3>
                                    <div id="divObjetivoMinimo">
                                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque mauris at malesuada aliquam. Aenean dictum odio molestie sapien pharetra, eu ullamcorper orci posuere. Duis justo mi, rutrum ac ipsum vitae, vestibulum
                                lobortis ante. Nam felis mauris, dictum id tellus vitae, faucibus accumsan nisl.

                                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque mauris at malesuada aliquam. Aenean dictum odio molestie sapien pharetra, eu ullamcorper orci posuere. Duis justo mi, rutrum ac ipsum vitae, vestibulum
                                  lobortis ante. Nam felis mauris, dictum id tellus vitae, faucibus accumsan nisl.
                                    </div>

                                </div>
                                <div class="col-lg-4 p-3">
                                    <div class="row">
                                        <div class="card">
                                            <h5 class="card-header boxHeader">Mensajes</h5>
                                            <div class="card-body">
                                                <div id="divWrapChat" class="mensajes" style="overflow:auto;">
                                                    <div class="row chat_message border-bottom-1X mb-2">
                                                        <div class="col-3">
                                                            <img src="images/people.png" class="img-fluid" />
                                                        </div>
                                                        <div class="col-9">
                                                            <h5>Juan Perez</h5>
                                                            <p>Loren ipsum dolor sit amet, consectetur adipiscing elit.</p>
                                                            <small class="float-right">10/04/2021 8:34am</small>
                                                        </div>
                                                    </div>
                                                    <div class="row chat_message border-bottom-1X mb-2">
                                                        <div class="col-3">
                                                            <img src="images/people.png" class="img-fluid" />
                                                        </div>
                                                        <div class="col-9">
                                                            <h5>Juan Perez</h5>
                                                            <p>Loren ipsum dolor sit amet, consectetur adipiscing elit.</p>
                                                            <small class="float-right">10/04/2021 8:34am</small>
                                                        </div>
                                                    </div>
                                                    <div class="row chat_message border-bottom-1X mb-2">
                                                        <div class="col-3">
                                                            <img src="images/people.png" class="img-fluid" />
                                                        </div>
                                                        <div class="col-9">
                                                            <h5>Juan Perez</h5>
                                                            <p>Loren ipsum dolor sit amet, consectetur adipiscing elit.</p>
                                                            <small class="float-right">10/04/2021 8:34am</small>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="nuevoMensaje border-top-2 mt-3">
                                                    <textarea rows="5" class="form-control" style="background-color: #f8f9fa"></textarea>
                                                    <input id="btnEnviarMensaje" type="button" value="Enviar" class="btn btn-primary float-right mt-3" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row coordinador">
                                        <h3 class="col-12 ">Coordinador del Reto</h3>
                                        <div class="col-3">
                                            <img src="images/people.png" class="img-fluid" />
                                        </div>
                                        <div class="col-9">
                                            <h5>Juan Carlos Rojas</h5>
                                            <p>Director de Mercadeo</p>
                                            <p>email: jprojas@email.com</p>
                                            <p>celular: 300 900 0000</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 p-0">
                            <div class="row px-4 pb-4 pt-0">
                                <div class="col-12">
                                    <h3 class="pt-0">Cronograma del Proyecto</h3>
                                    <div class="cronograma">
                                        <!-- aquí se debe ver la carga de la imagen del cronograma propuesto-->
                                        <img src="images/cronograma.jpg" class="img-fluid" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </main>
        </div>
    </div>

    <!-- Diálogo de Mensajes -->
    <div class="modal fade" id="dlgMensajeModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="MensajeModalLabel" aria-hidden="true" style="z-index: 1900;">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header bg-success text-white py-0" style="border-bottom: -1px!important;">
                    <h5 class="modal-title text-white" id="MensajeModalLabel">Bocore</h5>
                    <a href="#" class="close poplink" data-dismiss="modal" aria-label="Close" style="line-height: initial;">
                        <span aria-hidden="true" class="text-white font-weight-bold">&times;</span>
                    </a>
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

    <div class="container-fluid footer">
        <div class="row">
            <div class="col-sm-12 copy text-center">
                Universidad de Santander UDES - 2021
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/feather-icons@4.28.0/dist/feather.min.js" integrity="sha384-uO3SXW5IuS1ZpFPKugNNWqTZRRglnUJK6UAZ/gxOX80nxEkN9NcGZTftn6RzhGWE" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js" integrity="sha384-zNy6FEbO50N+Cg5wap8IKA4M/ZnLJgzc6w2NqACZaK0u0FXfOWRRJOnQtpZun8ha" crossorigin="anonymous"></script>
    <script src="js/dashboard.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" crossorigin="anonymous"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bs-custom-file-input/dist/bs-custom-file-input.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" crossorigin="anonymous"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>

    <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/fixedheader/3.1.6/js/dataTables.fixedHeader.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.3/js/dataTables.responsive.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.3/js/responsive.bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.1/js/tempusdominus-bootstrap-4.min.js"></script>
    <%--    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/sweetalert2@9.5.4/dist/sweetalert2.all.min.js"></script>--%>
    <script type="text/javascript" src="js/tabledit/jquery.tabledit.min.js"></script>
    <%--    <script type="text/javascript" src="../js/custom.js"></script>--%>
    <script type="text/javascript" src="js/URLParametros.js"></script>

    <!-- Chat --->
    <script src="Scripts/jquery-3.5.1.min.js"></script>
    <script src="Scripts/jquery.signalR-2.4.1.min.js"></script>
    <script src="chatSignalR/hubs"></script>
    <script src="js/chat/chat.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            InicializarChat(1);
            ObtenerInformarcionReto(1);

            $('#divWrapChat').on('scroll', function () {
                //console.log("Vertical " + $(this).scrollTop());
                if ($(this).scrollTop() == 0) {
                    //alert("Cargando más mensajes...");
                }
            });

            //$(window).on('beforeunload', function () {
            //    broadcaster.server.leave($('#groupName').val());
            //    return 'Are you sure you want to leave?';
            //});
        });

        //---------------------------------------------------------------------------------------------------------------------
        // Cerrar Sesión: Se apoya de un button ASP.Net oculto
        //---------------------------------------------------------------------------------------------------------------------
        function CerrarSesion() {
            // alert('Cerrando sesión');
            document.getElementById('btnCerrarSesion').click();
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
        // Recupera información del reto o proyecto.
        //---------------------------------------------------------------------------------------------------------------------
        function ObtenerInformarcionReto(idProyecto) {
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                url: pageUrl + "/ObtenerInformarcionReto",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                processData: false,
                async: false,
                data: JSON.stringify({ 'idProyecto': idProyecto }),
                success: function (response) {
                    var objResultado = JSON.parse(response.d);

                    if (objResultado.Codigo == '0') {
                        let infoReto = objResultado.Resultado;

                        $('#divDescEmpresa').html(infoReto.DescEmpresa);
                        $('#divDescReto').html(infoReto.DescReto);
                        $('#divAlcance').html(infoReto.Alcance);
                        $('#divObjetivoMinimo').html(infoReto.ObjetivoMinimo);

                        //MostrarMensaje("OK");
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

    </script>
</body>
</html>

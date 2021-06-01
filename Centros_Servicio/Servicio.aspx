<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Servicio.aspx.vb" Inherits="Centros_Servicio_Servicio" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOCORE | Servicio</title>

    <link rel="stylesheet" href="../css/bootstrap.min.css" />
    <link rel="stylesheet" href="../css/hover/hover-min.css" />
    <link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/4.5.6/css/ionicons.min.css">
    <link href="../css/bocore.css" rel="stylesheet" />

    <style>
        .card-header {
            padding: .75rem 1.25rem;
            margin-bottom: 0;
            background-color: #F3782F;
            border-bottom: 1px solid rgba(0, 0, 0, .125);
        }

        .btn-link-cs {
            color:white!important;
        }
    </style>
</head>

<body>

    <header class="navbar sticky-top bg-dark flex-md-nowrap p-0 shadow">
        <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3" href="#">
            <img src="../images/logo.png" class="img-fluid" /></a>
        <button class="navbar-toggler position-absolute d-md-none collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <ul class="navbar-nav px-3 col-md-3 col-lg-2 text-right">
            <li>
                <a href="#"><i class="fa fa-comment"></i></a>
                <a href="#"><i class="fa fa-bell"></i></a>
                <a href="#">Salir <i class="fa fa-sign-out" aria-hidden="true"></i></a>
            </li>
        </ul>
    </header>

    <div class="container-fluid dashboardContainer">
        <div class="row justify-content-center">
            <main class="col-md-12 ms-sm-auto col-lg-10 px-md-4">
                <div class="breadcrumbs">
                    <a href="#">Home</a> - Servicio
                </div>
                <div class="contentBox servicio px-0 px-sm-3 mb-4">
                    <div class="icono">
                        <img src="../images/servicio1.png" class="img-fluid" />
                    </div>
                    <div class="row p-4 p-sm-5">
                        <div class="col-md-5">
                            <img src="../images/imagen.png" class="img-fluid" />
                        </div>
                        <div class="col-md-7" style="padding-left:10px; padding-right;10px;">
                            <h3 id="hdnCentroServicio">Campus Virtual</h3>
                            <p id="pDescripcionCentroServicio">
<%--                                Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.--%>
                            </p>
                        </div>
                    </div>
                    <div class="row mt-0">
                        <div class="col-md-12">
                            <div class="accordion" id="accordionExample">
                                <div class="card">
                                    <div class="card-header" id="headingOne">
                                        <h2 class="mb-0 py-0">
                                            <span class="ion-ios-people text-white" wfd-id="30"></span>
                                            <button class="btn btn-link-cs" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                                Quienes Somos
                                            </button>
                                        </h2>
                                    </div>

                                    <div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#accordionExample">
                                        <div id="divQuienesSomos" class="card-body">
<%--                                            Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird
                                    on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft
                                    beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.--%>
                                        </div>
                                    </div>
                                </div>
                                <div class="card">
                                    <div class="card-header" id="headingTwo">
                                        <h2 class="mb-0 py-0">
                                            <span class="ion-ios-disc text-white" wfd-id="30"></span>
                                            <button class="btn btn-link-cs collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                                Misión
                                            </button>
                                        </h2>
                                    </div>
                                    <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionExample">
                                        <div id="divMision" class="card-body">
<%--                                            Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird
                                    on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft
                                    beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.--%>
                                        </div>
                                    </div>
                                </div>
                                <div class="card">
                                    <div class="card-header" id="headingThree">
                                        <h2 class="mb-0 py-0">
                                            <span class="ion-ios-eye text-white" wfd-id="30"></span>
                                            <button class="btn btn-link-cs collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                                Visión
                                            </button>
                                        </h2>
                                    </div>
                                    <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#accordionExample">
                                        <div id="divVision" class="card-body">
<%--                                            Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird
                                    on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft
                                    beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.--%>
                                        </div>
                                    </div>
                                </div>
                                <div class="card">
                                    <div class="card-header" id="headingThree">
                                        <h2 class="mb-0 py-0">
                                            <span class="ion-ios-construct text-white" wfd-id="30"></span>
                                            <button class="btn btn-link-cs collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                                Servicios
                                            </button>
                                        </h2>
                                    </div>
                                    <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#accordionExample">
                                        <div id="divServicios" class="card-body">
<%--                                            Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird
                                    on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft
                                    beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.--%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row py-3">
                        <div class="col-md-12 text-center">
                            <a href="../Login.aspx" class="btn btn-secondary botonCCX">
                                <img src="../images/icono-cc.png" height="35px" />
                                <span class="text-white">Programa Conecta y Crea</span>
                           </a>
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

    <script type="text/javascript">
        $(document).ready(function () {
            let idCentroServicio = getURLParameter("Id");
            //idCentroServicio = 1;
            ObtenerInformacionCentroServicio(idCentroServicio);
        });

        //---------------------------------------------------------------------------------------------------------------------
        // Devuelve la lista de tipos de documentos de identificación..
        //---------------------------------------------------------------------------------------------------------------------
        function ObtenerInformacionCentroServicio(idCentroServicio) {
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                url: pageUrl + "/ObtenerInformacionCentroServicio",
                //headers: token,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                processData: false,
                data: JSON.stringify({ 'idCentroServicio': idCentroServicio }),
                async: false,
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    if (objResultado.Codigo == '0') {
                        let centroServicio = objResultado.Resultado;

                        $("#hdnCentroServicio").text(centroServicio.Nombre);
                        $("#pDescripcionCentroServicio").text(centroServicio.Descripcion);
                        $("#divQuienesSomos").text(centroServicio.QuienesSomos);
                        $("#divMision").text(centroServicio.Mision);
                        $("#divVision").text(centroServicio.Vision);
                        $("#divServicios").text(centroServicio.Servicios);
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
    </script>
</body>
</html>

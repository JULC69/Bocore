<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Index.aspx.vb" Inherits="Index" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOCORE | Servicios</title>
    <link rel="stylesheet" href="css/bootstrap.min.css" />
    <link rel="stylesheet" href="css/hover/hover-min.css" />
    <link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" />
    <link href="css/bocore.css" rel="stylesheet" />

    <style>
        .size-logo-service-center {
            width:130px!important;
        }
    </style>
</head>

<body>
    <header class="navbar sticky-top bg-dark flex-md-nowrap p-0 shadow">
        <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3" href="#">
            <img src="images/logo.png" class="img-fluid" /></a>
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
                    <a href="#">Home</a> - Servicios
                </div>
                <div class="contentBox">
                    <div class="row p-5 servicios">
                        <div class="col-md-4">
                            <div class="row p-3">
                                <div class="col-md-4 text-center">
                                    <a href="Centros_Servicio/Servicio.aspx?Id=1" title="Empresariales (Conecta y Crea)">
                                       <img src="images/servicio1.png" class="img-fluid size-logo-service-center"  />
                                    </a>
                                </div>
                                <div class="col-md-8 d-flex justify-content-center justify-content-lg-start align-items-center">
                                    <p class="titulo">Empresariales (Conecta y Crea)</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="row p-3">
                                <div class="col-md-4 text-center">
                                    <a href="Centros_Servicio/Servicio.aspx?Id=3" title="Laboratorios">
                                       <img src="images/servicio2.png" class="img-fluid size-logo-service-center" />
                                    </a>
                                </div>
                                <div class="col-md-8 d-flex justify-content-center justify-content-lg-start align-items-center">
                                    <p class="titulo">Laboratorios</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="row p-3">
                                <div class="col-md-4 text-center">
                                    <a href="Centros_Servicio/Servicio.aspx?Id=2" title="Campus Virtual">
                                        <img src="images/servicio3.png" class="img-fluid size-logo-service-center" />
                                    </a>
                                </div>
                                <div class="col-md-8 d-flex justify-content-center justify-content-lg-start align-items-center">
                                    <p class="titulo">Campus Virtual</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="row p-3">
                                <div class="col-md-4 text-center">
                                    <a href="Centros_Servicio/Servicio.aspx?Id=4" title="Técnicos de obras civiles e infraestructura">
                                        <img src="images/servicio4.png" class="img-fluid size-logo-service-center" />
                                    </a>
                                </div>
                                <div class="col-md-8 d-flex justify-content-center justify-content-lg-start align-items-center">
                                    <p class="titulo">Técnicos de obras civiles e infraestructura</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="row p-3">
                                <div class="col-md-4 text-center">
                                    <a href="Centros_Servicio/Servicio.aspx?Id=5" title="Sociales, políticos y humanísticos" >
                                        <img src="images/servicio5.png" class="img-fluid size-logo-service-center" />
                                    </a>
                                </div>
                                <div class="col-md-8 d-flex justify-content-center justify-content-lg-start align-items-center">
                                    <p class="titulo">Sociales, políticos y humanísticos</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="row p-3">
                                <div class="col-md-4 text-center">
                                    <a href="Centros_Servicio/Servicio.aspx?Id=6" title="Creatividad y producción audiovisual">
                                        <img src="images/servicio6.png" class="img-fluid size-logo-service-center" />
                                    </a>
                                </div>
                                <div class="col-md-8 d-flex justify-content-center justify-content-lg-start align-items-center">
                                    <p class="titulo">Creatividad y producción audiovisual</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="p-5"></div>
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
    <script src="js/dashboard.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" crossorigin="anonymous"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
<%--    <script type="text/javascript" src="js/custom.js"></script>--%>
</body>
</html>

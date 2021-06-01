<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EditarEmpresa.aspx.vb" Inherits="Empresas_EditarEmpresa" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOCORE | Editar Empresa</title>

    <link rel="stylesheet" href="../css/bootstrap.min.css" />
    <link rel="stylesheet" href="../css/hover/hover-min.css" />
    <link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" />
    <link href="../css/bocore.css" rel="stylesheet" />
    <style>
        /* Elimina el bord de los diálogos modales*/
        .modal-content {
            border: 0px;
        }

        .remover .btn {
          position: absolute;
          top: 0!important;
          right: 0!important;
          margin-top: 0px;
          margin-right: 15px;
/*       top: 50%;
          left: 50%;
          transform: translate(-50%, -50%);
          -ms-transform: translate(-50%, -50%);*/
          background-color: #555;
          color: white;
/*          font-size: 16px;*/
/*          padding: 12px 24px;*/
          border: none;
          cursor: pointer;
          border-radius: 5px;
          text-align: center;
        }

        .remover .btn:hover {
          background-color: black!important;
        }

        .removeButton{
            position: absolute;
            top: 0;
            right: 0;
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
                        <li class="nav-item">
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
                    <a href="#">Bocore</a> - Empresas
                </div>
                <div class="contentBox">
                    <div class="row">
                        <div class="col-sm">
                            <h3 class="titulo">Perfil Empresa</h3>
                            <form id="frmPerfilEmpresa" class="was-validated"  method="post">
                                 <input id="hddIDEmpresa" name="IdEmpresa" type="hidden" value="">
                                 <input id="hddNombreArchivoLogoServidor" name="nombreArchivoLogoServidor" type="hidden" value="">
                                 <div class="row">
                                     <div class="col-12 align-self-center">
                                         <label for="imgLogoEmpresa">Logo</label>
                                         <div class="form-group remover text-center container-fluid m-0 bg-infoX">
                                             <button id="btnRemoverLogo" type="button" class="btn btn-primary btn-xs rounded-circle fa fa-minus d-none" data-toggle="modal" data-target="#dlgMensajeConfirmacionModal"></button>
                                             <img id="imgLogoEmpresa" class="img-fluid" onclick="document.getElementById('fileUploadLogoEmpresa').click()" src="../images/SiluetaLogoCompany.png" style="cursor: pointer; height:100px;" title="Subir Logo Empresa (3cm x 4cm)" />
<%--                                            <button id="btnfileUploadLogoEmpresa" class="btn btn-light border border-dark" onclick="document.getElementById('fileUploadLogoEmpresa').click()">Seleccionar archivo...</button>
                                            &nbsp;
                                            <span id="spnfileChoiseNM">Archivo no escogido</span>--%>
                                            <input id="fileUploadLogoEmpresa" type="file" name="fileUploadLogoEmpresa" style="display: none;" />
                                        </div>
                                     </div>
                                </div>
                                <div class="row">
                                    <div class="form-group col-sm-12 col-lg-8">
                                        <label for="txtRazonSocial">RazonSocial</label>
                                        <input  id="txtRazonSocial" type="text" class="form-control letter-whitespace-only" placeholder="Nombre(s)" required>
                                    </div> 
                                    <div class="form-group col-sm-12 col-lg-4">
                                        <label for="txtNIT">NIT</label>
                                        <input  id="txtNIT"  class="form-control" maxlength="12"  
                                            placeholder="NIT" 
                                            type="text"
                                            pattern="[0-9]+"
                                            required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group col-sm-12 col-lg-6">
                                        <label for="txtRepresentanteLegal">Representante Legal</label>
                                        <input id="txtRepresentanteLegal" type="text" class="form-control letter-whitespace-only" placeholder="Representante Legal" required>
                                    </div>
                                    <div class="form-group col-sm-12 col-lg-6">
                                        <label for="txtEmail">Email</label>
                                        <input id="txtEmail" class="form-control" 
                                            placeholder="nombre@servidorcorreo.com" 
                                            type="email"
                                            required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group col">
                                        <label for="txtCelular1">Celular 1</label>
                                        <input  id="txtCelular1"  class="form-control" maxlength="15"  
                                            placeholder="999-9999999" 
                                            type="tel"
                                            pattern="[0-9]{3}-[0-9]{7}"
                                            required>
                                    </div>
                                    <div class="form-group col">
                                        <label for="txtCelular2">Celular 2</label>
                                        <input  id="txtCelular2"  class="form-control" maxlength="15"  
                                            placeholder="999-9999999" 
                                            type="tel"
                                            pattern="[0-9]{3}-[0-9]{7}">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group col">
                                        <label for="txtTelefono1">Télefono 1</label>
                                        <input  id="txtTelefono1"  class="form-control" maxlength="15"  
                                            placeholder="Teléfono 1" 
                                            type="tel"
                                            pattern="[0-9 ]+">
                                    </div>
                                    <div class="form-group col">
                                        <label for="txtTelefono2">Télefono 2</label>
                                        <input  id="txtTelefono2"  class="form-control" maxlength="15"  
                                            placeholder="Télefono 2" 
                                            type="tel"
                                            pattern="[0-9 ]+">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group col-sm-12 col-lg-4">
                                        <label for="cmbPais">País</label>
                                        <select id="cmbPais" class="form-control" id="select1" 
                                            oninvalid="this.setCustomValidity('Seleccione un País de la lista')"
                                            oninput="this.setCustomValidity('')"
                                            required>
                                        </select>
                                    </div>
                                    <div id="divDepartamento" class="form-group col-sm-12 col-lg-4">
                                        <label for="cmbDepartamento">Departamento/Estado</label>
                                        <select id="cmbDepartamento" class="form-control" id="select1" 
                                            oninvalid="this.setCustomValidity('Seleccione un departamento ó estado de la lista')"
                                            oninput="this.setCustomValidity('')"
                                            required>
                                            <option selected='selected' disabled='' value=''>- Seleccione -</option>
                                        </select>
                                    </div>
                                    <div id="divCiudad" class="form-group col-sm-12 col-lg-4">
                                        <label for="cmbCiudad">Ciudad/Municipio</label>
                                        <select id="cmbCiudad" class="form-control" id="select1" 
                                            oninvalid="this.setCustomValidity('Seleccione una ciudad ó municipio de la lista')"
                                            oninput="this.setCustomValidity('')"
                                            required>
                                            <option selected='selected' disabled='' value=''>- Seleccione -</option>
                                        </select>
                                    </div>
                                    <div id="divOtraCiudad" class="form-group col-sm-12 col-lg-4">
                                        <label for="txtOtraCiudad">Ciudad</label>
                                        <input  id="txtOtraCiudad"  class="form-control" maxlength="30"  
                                            oninvalid="this.setCustomValidity('La ciudad es obligatoria')"
                                            oninput="this.setCustomValidity('')"
                                            placeholder="Ciudad" 
                                            type="text"
                                            required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="txtDireccion">Dirección</label>
                                    <input  id="txtDireccion"  class="form-control" maxlength="50"  
                                        placeholder="Dirección" 
                                        type="text"
                                        required>
                                </div>
                                <div class="form-group float-right">
                     <%--               <button class="btn btn-danger">Cancelar</button>--%>
                                    <input type="submit" class="btn btn-success" value="Guardar cambios" />
                                </div>
                            </form>
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

    <!-- Dialogo de Confirmación -->
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
                   <span id="spnMensajeConfirmacion">¿Desea remover el Logo del perfíl empresarial?</span>
                </div>
                <div class="modal-footer">
                    <button id="btnAceptarRemoverLogo" type="button" class="btn btn-primary mr-sm-2">Aceptar</button>
                    <button type="button" class="btn btn-secondary ml-sm-2" data-dismiss="modal">Cancelar</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/feather-icons@4.28.0/dist/feather.min.js" integrity="sha384-uO3SXW5IuS1ZpFPKugNNWqTZRRglnUJK6UAZ/gxOX80nxEkN9NcGZTftn6RzhGWE" crossorigin="anonymous"></script>
    <%--    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js" integrity="sha384-zNy6FEbO50N+Cg5wap8IKA4M/ZnLJgzc6w2NqACZaK0u0FXfOWRRJOnQtpZun8ha" crossorigin="anonymous"></script>--%>

    <script type="text/javascript" src="../js/dashboard.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" crossorigin="anonymous"></script>

    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bs-custom-file-input/dist/bs-custom-file-input.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" crossorigin="anonymous"></script>
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <%--<script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/dataTables.bootstrap4.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/fixedheader/3.1.6/js/dataTables.fixedHeader.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.3/js/dataTables.responsive.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.3/js/responsive.bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.1/js/tempusdominus-bootstrap-4.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/sweetalert2@9.5.4/dist/sweetalert2.all.min.js"></script>
    <script type="text/javascript" src="js/tabledit/jquery.tabledit.min.js"></script>
    <script type="text/javascript" src="js/custom.js"></script>--%>

        <!--   Bootstrap 4.6.0   -->

<%--    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-Piv4xVNRyMGpqkS2by6br4gNJ7DXjqk09RmUpJ8jgGtD7zP9yug3goQfGII0yAns" crossorigin="anonymous"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>--%>
    <script type="text/javascript" src="../js/URLParametros.js"></script>

    <script type="text/javascript">
        $(window).load(function () {
            //Recupera la cadena de consulta 
            //let querystring = window.location.search.substring(1);

            let idEmpresa = GetQueryString("Id");
            let operacion = GetQueryString("op");

            //idEmpresa =1; //borrar
            //operacion = 2;

            //idEmpresa = getURLParameter("Id");
            //operacion = getURLParameter("op");

            //alert("idEmpresa: " + idEmpresa);
            //alert("operacion: " + operacion);

            $("#hddIDEmpresa").val(idEmpresa);

            if (idEmpresa != "null" && operacion != "null") {
                let usuarioLoggeado = '<%= Session("NombreUsuarioLoggeado") %>';
                $("#spnUsuarioLogueado").text(usuarioLoggeado);

                // Ejecuta secuencialmente y sincrónicamente las siguientes subrutinas.
                ListaPaises().then(estado => {
                    return EditarEmpresa(idEmpresa);
                }).then(estado => {
                    if (operacion == 1) {
                        $("#frmPerfilEmpresa :input").prop("disabled", true);
                        $("#btnRemoverLogo").remove();
                        $("#divGuardarCambios").remove();
                        $("#hTitulo").text("Empresa");
                    } else {
                        $("#hTitulo").text("Empresa - edición");
                    }

                }).catch(error => {
                    MostrarMensaje(error);
                    //window.location.replace(document.referrer);
                });
            }
            else {
                let urlPage404 = '<%=ResolveUrl("Usuarios.aspx") %>';
                window.location.href = urlPage404;
            }

        });

        //$(document).ready(function () {
        //    ListaPaises();

        //    // Inhabilita el DIV con todos los controles contenidos en su interior.
        //    $("#divDepartamento").children().prop('disabled', true);
        //    $("#divCiudad").children().prop('disabled', true);
        //    // Oculta la sección que expone el cuadro de texto para ingreso del nombre de ciudades fuera de Colombia.
        //    $("#divOtraCiudad").css("display", "none");

        //   DatosPrueba();
        //});

        function DatosPrueba() {
            $("#txtRazonSocial").val("Empresa XXXX");
            $("#txtNIT").val("1111111111");
            $("#txtRepresentanteLegal").val("Nombre1 Apellido1");
            $("#txtEmail").val("jorge.lievano@outlook.com");
            $("#txtCelular1").val("320-9192537");
            $("#txtTelefono1").val("6 385678");
            $("#txtDireccion").val("Direccion 1");
            //$("#cmbPais").val(48); //Colombia
            $("#cmbPais").val(70); //EEUU
            $("#cmbPais").trigger("change");
            //$("#cmbDepartamento").val("68"); // Santander
            $("#cmbDepartamento").val("00"); // Exterior
            $("#cmbDepartamento").trigger("change");
            //$("#cmbCiudad").val("68001"); //Bucaramanga
            $("#txtOtraCiudad").val("Oklahoma");
            //$("#chkActivo").val();
            $('#chkActivo').prop("checked", true);
        }

        function preventBack() { window.history.forward(); }
        setTimeout("preventBack()", 0);
        window.onunload = function () { null };

        //---------------------------------------------------------------------------------------------------------------------
        // Cerrar Sesión: Se apoya de un button ASP.Net oculto
        //---------------------------------------------------------------------------------------------------------------------
        function CerrarSesion() {
            // alert('Cerrando sesión');
            document.getElementById('btnCerrarSesion').click();
        }

        //---------------------------------------------------------------------------------------------------------
        // Remueve el logo de la empresa actual..
        //--------------------------------------------------------------------------------------------------------
        $("#btnAceptarRemoverLogo").on("click", function () {
            RemoverLogo();
        });

        //---------------------------------------------------------------------------------------------------------
        // Carga una imagen con el logo de la empresa actual, valida su formato y tamaño..
        //--------------------------------------------------------------------------------------------------------
        $("#fileUploadLogoEmpresa").on("change", function () {
            //alert('Cargando logo...');
            var ext = $('#fileUploadLogoEmpresa').val().split('.').pop().toLowerCase();
            var arrExtensiones = ['jpg', 'jpeg', 'png'];
            if ($.inArray(ext, ['jpg', 'jpeg', 'png']) == -1) {
                MostrarMensaje("Tipo de archivo no valido. Formatos permitdos JPG, PNG");
                this.value = "";
            } else if (this.files[0].size > 2097152) {  //2MB
                MostrarMensaje("No se permite cargar archivos mayores a " + 2097152 / 1024 / 1024 + "MB");
                this.value = "";
            } else {
                var reader = new FileReader();
                //Lee el contenido del archivo de imagen.
                reader.readAsDataURL(this.files[0]);
                reader.onload = function (e) {
                    //Inicializa el objeto de imagen de JavaScript
                    var image = new Image();
                    //Establezca el retorno de cadena Base64 a partir del FileReader como orígen.
                    image.src = e.target.result;
                    //Valida la altura y el ancho del archivo.
                    image.onload = function () {
                        let height = this.naturalHeight;
                        let width = this.naturalWidth;

                        if (height <= 100) { // Hasta 100 pixeles de altura.
                            var dataURL = e.target.result;
                            $("#imgLogoEmpresa").attr('src', dataURL);

                            let files = $("#fileUploadLogoEmpresa").prop("files");
                            let url = $("#fileUploadLogoEmpresa").val();
                            let extension = url.split('.')[1];

                            let datosLogo = new FormData();
                            datosLogo.append("IdEmpresa", $("#hddIDEmpresa").val());
                            datosLogo.append("NombreEmpresa", LimpiarCaracteresAcentuados($("#txtRazonSocial").val()));
                            datosLogo.append("Tipo", files[0].type);
                            datosLogo.append("Extension", extension);
                            datosLogo.append("file", $("#fileUploadLogoEmpresa").prop('files')[0]);

                            GuardarLogoEmpresa(datosLogo);
                            return true;
                        }
                        else {
                            MostrarMensaje("Tamaño de imagen no válido. Tamaño permitido hasta 100 pixeles de altura. Resolución 120 ó 300 ppp");
                            return false;
                        }
                    };
                };
            }
        });
        
        //---------------------------------------------------------------------------------------------------------------------
        // Guarda cambios del perfil de la empresa.
        //---------------------------------------------------------------------------------------------------------------------
        $('#frmPerfilEmpresa').submit(function (e) {
            e.preventDefault();  //prevent form from submitting
            //alert('Guardar cambios de Perfil de la Empresa.');

            // recupera datos del formulario Perfil de la Empresa.
            let dataEmpresa = {};
            dataEmpresa.IdEmpresa = $("#hddIDEmpresa").val();
            dataEmpresa.RazonSocial = $("#txtRazonSocial").val();
            dataEmpresa.NIT = $("#txtNIT").val();
            dataEmpresa.RepresentanteLegal = $("#txtRepresentanteLegal").val();
            dataEmpresa.Email = $("#txtEmail").val();
            dataEmpresa.Celular1 = $("#txtCelular1").val();
            dataEmpresa.Celular2 = $("#txtCelular2").val();
            dataEmpresa.Telefono1 = $("#txtTelefono1").val();
            dataEmpresa.Telefono2 = $("#txtTelefono2").val();
            dataEmpresa.IdPais = $("#cmbPais").val();
            dataEmpresa.IdDepartamento = $("#cmbDepartamento").val();
            dataEmpresa.IdCiudad = $("#cmbCiudad").val();
            dataEmpresa.OtraCIudad = $("#txtOtraCiudad").val();
            dataEmpresa.Direccion = $("#txtDireccion").val();
            //dataEmpresa.Activo = $("#chkActivo").prop("checked");

            ActualizarEmpresa(dataEmpresa);
        });

        //---------------------------------------------------------------------------------------------------------------------
        // Recupera lista de ciudades ó municipios del departamento ó estado especificado.
        //---------------------------------------------------------------------------------------------------------------------
        $('#cmbDepartamento').on('change', function () {
            if ($(this).val()) {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                if ($(this).val() != "00") { // Departamento 'Exterior'
                    $.ajax({
                        type: "POST",
                        url: pageUrl + "/ListaCiudades",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        processData: false,
                        async: false,
                        data: JSON.stringify({ 'idDepartamento': $(this).val() }),
                        success: function (response) {
                            var objResultado = JSON.parse(response.d);
                            if (objResultado.Codigo == '0') {
                                // Oculta la sección para ingresar una ciudad fuera de Colombia.
                                $("#divOtraCiudad").children().prop('disabled', true);
                                $("#divOtraCiudad").css("display", "none");
                                $("#txtOtraCiudad").val("");
                                // Hace visible la sección con lista de ciudades.
                                $("#divCiudad").css("display", "block");
                                // Habilita el DIV con todos los controles contenidos en su interior.
                                $("#divCiudad").children().prop('disabled', false);
                                $("#cmbCiudad").empty();
                                // Llena el cuadro de lista
                                $("#cmbCiudad").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");
                                $.each(objResultado.Resultado, function (i, listado) {
                                    $("#cmbCiudad").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
                                });
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
                else {
                    $("#divCiudad").children().prop('disabled', true);
                    $("#divCiudad").css("display", "none");
                    // Hace visible la sección con lista de ciudades.
                    $("#divOtraCiudad").css("display", "block");
                    $("#divOtraCiudad").children().prop('disabled', false);
                }

            } else {
                // Inhabilita el DIV con todos los controles contenidos en su interior.
                $("#divDepartamento").children().prop('disabled', true);
                $('#cmbDepartamento').val('');
                $('#cmbDepartamento').change();
            }
        });

        //---------------------------------------------------------------------------------------------------------------------
        // Recupera lista de Departamentos ó Estados de País especificado.
        //---------------------------------------------------------------------------------------------------------------------
        $('#cmbPais').on('change', function () {
            if ($(this).val()) {
                $('#cmbDepartamento').prop('disabled', false);
                $("#cmbDepartamento").empty();
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/ListaDepartamentos",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    async: false,
                    data: JSON.stringify({ 'idPais': $(this).val() }),
                    success: function (response) {
                        var objResultado = JSON.parse(response.d);
                        if (objResultado.Codigo == '0') {
                            // Habilita el DIV con todos los controles contenidos en su interior.
                            $("#divDepartamento").children().prop('disabled', false);
                            $("#cmbDepartamento").empty();
                            $("#cmbDepartamento").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");
                            $.each(objResultado.Resultado, function (i, listado) {
                                $("#cmbDepartamento").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
                            });
                            // Oculta la sección para ingresar una ciudad fuera de Colombia.
                            $("#divOtraCiudad").children().prop('disabled', true);
                            $("#divOtraCiudad").css("display", "none");
                            $("#txtOtraCiudad").val("");
                            // Hace visible la sección con lista de ciudades.
                            $("#divCiudad").css("display", "block");
                            // Habilita el DIV con todos los controles contenidos en su interior.
                            $("#divCiudad").children().prop('disabled', true);
                            $("#cmbCiudad").empty();
                            $("#cmbCiudad").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");
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
            } else {
                // Inhabilita el DIV con todos los controles contenidos en su interior.
                $("#divDepartamento").children().prop('disabled', true);
                $('#cmbDepartamento').val('');
                $('#cmbDepartamento').change();
            }
        });

        //---------------------------------------------------------------------------------------------------------------------
        // Guarda cambios del perfíl de la empresa.
        //---------------------------------------------------------------------------------------------------------------------
        function ActualizarEmpresa(dataEmpresa) {
            var objEmpresa = "{'dataEmpresa':" + JSON.stringify(dataEmpresa) + "}";
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                //headers: token,
                url: pageUrl + "/ActualizarEmpresa",
                cache: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false, 
                data: objEmpresa,
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    if (objResultado.Codigo == '0') {
                        MostrarMensaje("Cambios registrados éxitosamente");
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
        // Recupera el registro de datos de la empresa especificadoa
        //---------------------------------------------------------------------------------------------------------------------
        function EditarEmpresa(idEmpresa) {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/EditarEmpresa",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    data: JSON.stringify({ 'idEmpresa': idEmpresa }),
                    async: false,  // Establecer en false si se invoca desde una promesa.
                    success: function (response) {
                        var objResultado = JSON.parse(response.d);

                        if (objResultado.Codigo == '0') {
                            let dataEmpresa = objResultado.Resultado;

                            // Presenta/Oculta botón 'Remover Logo'
                            if (JSON.parse(dataEmpresa.ConLogo) === true) {
                                $("#btnRemoverLogo").addClass("d-block");
                                $("#btnRemoverLogo").removeClass("d-none");
                            }
                            else {
                                $("#btnRemoverLogo").addClass("d-none");
                                $("#btnRemoverLogo").removeClass("d-block");
                            }

                            $("#imgLogoEmpresa").attr('src', dataEmpresa.Logo);
                            $("#hddNombreArchivoLogoServidor").val(dataEmpresa.NombreArchivoLogoServidor);
                            $("#txtRazonSocial").val(dataEmpresa.RazonSocial);
                            $("#txtNIT").val(dataEmpresa.NIT);
                            $("#txtRepresentanteLegal").val(dataEmpresa.RepresentanteLegal);
                            $("#txtEmail").val(dataEmpresa.Email);
                            $("#txtCelular1").val(dataEmpresa.Celular1);
                            $("#txtCelular2").val(dataEmpresa.Celular2);
                            $("#txtTelefono1").val(dataEmpresa.Telefono1);
                            $("#txtTelefono2").val(dataEmpresa.Telefono2);
                            $("#cmbPais").val(dataEmpresa.IdPais);
                            $("#cmbPais").trigger("change");
                            $("#cmbDepartamento").val(dataEmpresa.IdDepartamento); // Exterior
                            $("#cmbDepartamento").trigger("change");
                            if (dataEmpresa.IdDepartamento == "00") { //Exterior
                                $("#txtOtraCiudad").val(dataEmpresa.OtraCIudad);
                            }
                            else { // Sólo Departamentos de Colombia.
                                $("#cmbCiudad").val(dataEmpresa.IdCiudad);
                            }
                            $("#txtDireccion").val(dataEmpresa.Direccion);
                /*            $('#chkActivo').prop("checked", true);*/

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
        // Función que permite recuperar el valor de una parámetro
        // de la cadena QueryString.
        //---------------------------------------------------------------------------------------------------------------------
        function GetQueryString(key) {
            key = key.replace("/[\[]/", "\\\[").replace("/[\]]/", "\\\]");
            var regex = new RegExp("[\\?&]" + key + "=([^&#]*)");
            var qs = regex.exec(window.location.href);
            if (qs == null) {
                respuesta = "-1";
            }
            else {
                respuesta = qs[1];
            }
            return respuesta;
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Guardar el archivo del logo de empresa en el servidor.
        //---------------------------------------------------------------------------------------------------------------------
        function GuardarLogoEmpresa(datosLogo) {
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
                url: pageUrl + "/GuardarLogoEmpresa",
                cache: false,
                contentType: false,   // tell jQuery not to set contentType
                processData: false,  // tell jQuery not to process the data
                async: true,
                data: datosLogo,  //FormData
                //global: false,  // this makes sure ajaxStart is not triggered
                success: function (response) {
                    //alert("Logo empresarial regisrado exitosamente");
                    // Agrega el icono spinner al botón
                    //BtnReset($("#btnSubirArchivoNM"));
                    var objResultado = JSON.parse(response);

                    if (objResultado.Codigo == '0') {
                        // Presenta el botón 'Remover Logo'
                        $("#btnRemoverLogo").addClass("d-block");
                        $("#btnRemoverLogo").removeClass("d-none");
                        $("#hddNombreArchivoLogoServidor").val(objResultado.Resultado);
                    } else {
                        MostrarMensaje(objResultado.Mensaje);
                    }
                    resultado = true;
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
        // Reempleza caracteres acentuados con caracteres no-acentuados.
        //---------------------------------------------------------------------------------------------------------------------
        function LimpiarCaracteresAcentuados(cadena) {
            return cadena
                .replace(/[ÀÁÂÃÄÅ]/g, "A")
                .replace(/[àáâãäå]/g, "a")
                .replace(/[ÈÉÊË]/g, "E")
                .replace(/[Í]/g, "I")
                .replace(/[í]/g, "i")
                .replace(/[Ó]/g, "O")
                .replace(/[ó]/g, "o")
                .replace(/[ÚÙÛÜ]/g, "U")
                .replace(/[úùûü]/g, "u")
                .replace(/[Ñ]/g, "N")
                .replace(/[ñ]/g, "n")
                .replace(/[ ]/g, "-")
                //....todo lo demás
                .replace(/[^a-z0-9- ]/gi, ''); // limpieza final
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Devuelve la lista de países del mundo.
        //---------------------------------------------------------------------------------------------------------------------
        function ListaDepartamentos() {
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                url: pageUrl + "/ListaDepartamentos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                processData: false,
                async: false,
                data: JSON.stringify({ 'idPais': $(this).val() }),
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    if (objResultado.Codigo == '0') {
                        $("#cmbDepartamento").empty();
                        $("#cmbDepartamento").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");
                        $.each(objResultado.Resultado, function (i, listado) {
                            $("#cmbDepartamento").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
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
        // Devuelve la lista de países del mundo.
        //---------------------------------------------------------------------------------------------------------------------
        function ListaPaises() {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/ListaPaises",
                    //headers: token,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    data: '',
                    async: false,
                    success: function (response) {
                        var objResultado = JSON.parse(response.d);
                        if (objResultado.Codigo == '0') {
                            $("#cmbPais").empty();
                            $("#cmbPais").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");
                            $.each(objResultado.Resultado, function (i, listado) {
                                $("#cmbPais").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
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
        // Remueve el logo empresarial del perfíl de la empresa actual.
        //---------------------------------------------------------------------------------------------------------------------
        function RemoverLogo() {
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                //headers: token,
                url: pageUrl + "/RemoverLogoEmpresa",
                cache: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                data: JSON.stringify({ 'idEmpresa': $("#hddIDEmpresa").val(), 'nombreArchivoLogoServidor': $("#hddNombreArchivoLogoServidor").val() }),
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    // Cierra el diálogo Modal
                    $("#dlgMensajeConfirmacionModal").modal("hide");

                    if (objResultado.Codigo == '0') {
                        // Oculta botón 'Remover Logo'
                        $("#btnRemoverLogo").addClass("d-none");
                        $("#btnRemoverLogo").removeClass("d-block");
                        // Establece la imagen silueta de logo empresarial por defecto
                        $("#imgLogoEmpresa").attr("src", "/images/SiluetaLogoCompany.png");
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

    <script type="text/javascript">
        //---------------------------------------------------------------------------------
        // INICIO -  Permite a los usuarios ingresar solamente letras y 
        // espacios en blanco.
        //---------------------------------------------------------------------------------
        $(".letter-whitespace-only").bind('keypress', function (e) {
            if (e.keyCode == '9' || e.keyCode == '16') { /* TAB / ESC */
                return;
            }

            var code;
            if (e.keyCode) code = e.keyCode;
            else if (e.which) code = e.which;
            console.log(code);
            if (code == 8 || code == 32 || code == 46) /* BACKSPACE / SPACE / DELETE */
                return true;
            if (code >= 65 && code <= 90) /* A-Z*/
                return true;
            if (code >= 97 && code <= 122) /* a-z*/
                return true;
            if (code == 164 || code == 165) /* ñ Ñ */
                return true;
            else
                return false;
        });

        //Deshabilita el 'Paste'
        $(".letter-whitespace-only").bind("paste", function (e) {
            e.preventDefault();
        });

        $(".letter-whitespace-only").bind('mouseenter', function (e) {
            var val = $(this).val();
            if (val != '0') {
                val = val.replace(/[^a-zA-ZñÑ ]+/g, "")
                $(this).val(val);
            }
        });
    </script>
</body>
</html>

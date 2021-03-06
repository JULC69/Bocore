<%@ Page Language="VB" AutoEventWireup="false" CodeFile="NuevoUsuario.aspx.vb" Inherits="Usuarios_NuevoUsuario" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOCORE | Nuevo Usuario</title>
    <link rel="stylesheet" href="../css/bootstrap.min.css" />
    <link rel="stylesheet" href="../css/hover/hover-min.css" />
    <link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.15/dist/summernote-bs4.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/dataTables.bootstrap4.min.css" />
    <link rel="stylesheet" href="../css/bootstrap.min.css" >
    <link rel="stylesheet" href="../css/bocore.css"/>
    <style>
        /* Elimina el bord de los diálogos modales*/
        .modal-content {
            border: 0px;
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
                    <a href="#">Bocore</a> - Usuarios
                </div>
                <div class="contentBox">
                    <div class="row">
                        <div class="col-sm">
                            <h3 class="titulo">Perfil Usuario</h3>
                            <form id="frmPerfilUsuario" class="was-validated"  method="post">
<%--                                <div class="form-group">
                                    <button id="btnfileUploadNM" class="btn btn-light border border-dark" onclick="document.getElementById('fileUploadNM').click()">Seleccionar archivo...</button>
                                    &nbsp;
                                 <span id="spnfileChoiseNM">Archivo no escogido</span>
                                    <input id="fileUploadNM" type="file" name="fileUploadNM" style="display: none;" />
                                </div>--%>
                                <div class="form-group">
                                    <label for="txtNombres">Nombres</label>
                                    <input  id="txtNombres" type="text" class="form-control letter-whitespace-only" placeholder="Nombre(s)" required>
                                </div> 
                                <div class="form-group">
                                    <label for="txtApellidos">Apellidos</label>
                                    <input id="txtApellidos" type="text" class="form-control letter-whitespace-only" placeholder="Apellido(s)" required>
                                </div>
                                <div class="row">
                                    <div class="form-group col-sm-12 col-lg-6">
                                        <label for="cmbTipoDocumento">Tipo de documento</label>
                                        <select id="cmbTipoDocumento" class="form-control" id="select1" 
                                            oninvalid="this.setCustomValidity('Seleccione un Tipo de documento de identificación de la lista')"
                                            oninput="this.setCustomValidity('')"
                                            required>
                                            <option selected='selected' disabled='' value=''>- Seleccione -</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-sm-12 col-lg-6">
                                        <label for="txtNoDocumento">N° documento</label>
                                        <input  id="txtNoDocumento"  class="form-control" maxlength="15"  
                                            placeholder="N° documento" 
                                            type="text"
                                            required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="txtEmail">Email</label>
                                    <input id="txtEmail" class="form-control" 
                                        placeholder="nombre@servidorcorreo.com" 
                                        type="email"
                                        required>
                                </div>
                                <div class="form-group">
                                    <label for="txtCelular">Celular</label>
                                    <input  id="txtCelular"  class="form-control" maxlength="15"  
                                        placeholder="999-9999999" 
                                        type="tel"
                                        pattern="[0-9]{3}-[0-9]{7}"
                                        required>
                                </div>
                                <div class="form-group">
                                    <label for="cmbRol">Rol</label>
                                    <select id="cmbRol" class="form-control" id="select1" 
                                        oninvalid="this.setCustomValidity('Seleccione un Rol de la lista')"
                                        oninput="this.setCustomValidity('')"
                                        required>
                                    </select>
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
<%--                                <div class="form-group">
                                    <label for="cmbProgramaAcademico">Programa</label>
                                    <select id="cmbProgramaAcademico" class="form-control" id="select1" 
                                        oninvalid="this.setCustomValidity('Seleccione un Programa de la lista')"
                                        oninput="this.setCustomValidity('')"
                                        required>
                                    </select>
                                </div>--%>
                                <div class="form-check">
                                    <input id="chkActivo" type="checkbox" class="form-check-input">
                                    <label class="form-check-label" for="chkActivo" style="color:black;">Activo</label>
                                </div>

                                <h3 class="titulo">Credenciales de acceso</h3>
                                <div class="form-group">
                                    <label for="txtUsuario">Usuario</label>
                                    <input type="text" class="form-control" 
                                               id="txtUsuario"  name="usuario" maxlength="20" 
                                               placeholder="Usuario"
                                               required>
                                </div>
                                <div class="form-group">
                                    <label for="txtContrasena">Contraseña</label>
                                    <input type="text" class="form-control" 
                                               id="txtContrasena"  name="Contrasena" maxlength="20" 
                                               placeholder="Contraseña" 
                                               required>
                                </div>
                                <div class="form-group">
                                    <label for="txtConfirmarContrasena">Confirmar Contraseña</label>
                                    <input type="text" class="form-control" 
                                               id="txtConfirmarContrasena"  name="ConfirmarContrasena" maxlength="20" 
                                               placeholder="Confirmar Contraseña" 
                                               oninput="ConfirmarContraseña(this)"
                                               required>
                                </div>
                                <div class="form-check">
                                    <input id="chkDebeCambiarContrasena" type="checkbox" class="form-check-input">
                                    <label class="form-check-label" for="chkDebeCambiarContrasena" style="color:black;">Debe cambiar contraseña</label>
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

    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/feather-icons@4.28.0/dist/feather.min.js" integrity="sha384-uO3SXW5IuS1ZpFPKugNNWqTZRRglnUJK6UAZ/gxOX80nxEkN9NcGZTftn6RzhGWE" crossorigin="anonymous"></script>
    <%--    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js" integrity="sha384-zNy6FEbO50N+Cg5wap8IKA4M/ZnLJgzc6w2NqACZaK0u0FXfOWRRJOnQtpZun8ha" crossorigin="anonymous"></script>--%>

    <script type="text/javascript" src="../js/dashboard.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" crossorigin="anonymous"></script>

<%--    <script type="text/javascript" src="//ajax.aspnetcdn.com/ajax/jquery.validate/1.13.1/jquery.validate.min.js"></script>
    <script type="text/javascript" src="//ajax.aspnetcdn.com/ajax/mvc/5.2.3/jquery.validate.unobtrusive.min.js"></script>--%>

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
    <script type="text/javascript" src="../js/tabledit/jquery.tabledit.min.js"></script>
    <script type="text/javascript" src="../js/custom.js"></script>--%>

        <!--   Bootstrap 4.6.0   -->

<%--    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-Piv4xVNRyMGpqkS2by6br4gNJ7DXjqk09RmUpJ8jgGtD7zP9yug3goQfGII0yAns" crossorigin="anonymous"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>--%>

    <script type="text/javascript">
        $(document).ready(function () {
            let usuarioLoggeado = '<%= Session("NombreUsuarioLoggeado") %>';
            $("#spnUsuarioLogueado").text(usuarioLoggeado);

            ListaTiposDocumento();
            ListaPaises();
           // ListaProgramasAcademicos("activo");
            ListaRoles();

            // Inhabilita el DIV con todos los controles contenidos en su interior.
            $("#divDepartamento").children().prop('disabled', true);
            $("#divCiudad").children().prop('disabled', true);
            // Oculta la sección que expone el cuadro de texto para ingreso del nombre de ciudades fuera de Colombia.
            $("#divOtraCiudad").css("display", "none");

            //DatosPrueba();
        });

        function DatosPrueba() {
            $("#txtNombres").val("Jorge");
            $("#txtApellidos").val("Lievano");
            $("#cmbTipoDocumento").val(1);
            $("#txtNoDocumento").val("91271544");
            $("#cmbRol").val(3); // Profesor
            $("#txtEmail").val("jorge.lievano@outlook.com");
            $("#txtCelular").val("320-9192537");
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

        //---------------------------------------------------------------------------------------------------------------------
        // Comprueba si la contraseña inicial coinicde con la confirmación de la misma.
        //---------------------------------------------------------------------------------------------------------------------
        function ConfirmarContraseña(input) {
            if (input.value != document.getElementById('txtContrasena').value) {
                input.setCustomValidity('Contraseña no válida.');
            } else {
                // input is valid -- reset the error message
                input.setCustomValidity('');
            }
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Crea las Credenciales del nuevo usuario.
        //---------------------------------------------------------------------------------------------------------------------
        //$('#frmCredencialesUsuario').submit(function (e) {
        //    e.preventDefault();  //prevent form from submitting
        //    alert('Crear Login de Usuario.');
        //    //return false;  // <- cancel event
        //});

        
        //---------------------------------------------------------------------------------------------------------------------
        // Guarda cambios del perfil del usuario.
        //---------------------------------------------------------------------------------------------------------------------
        $('#frmPerfilUsuario').submit(function (e) {
            e.preventDefault();  //prevent form from submitting
            //alert('Guardar cambios de Perfil de Usuario.');

            // recupera datos del formulario Perfil del Usuario.
            let dataUsuario = {};
            dataUsuario.Nombres = $("#txtNombres").val();
            dataUsuario.Apellidos = $("#txtApellidos").val();
            dataUsuario.IdTipoDocumento = $("#cmbTipoDocumento").val();
            dataUsuario.Documento = $("#txtNoDocumento").val();
            dataUsuario.IdRol = $("#cmbRol").val();
            dataUsuario.Email = $("#txtEmail").val();
            dataUsuario.Celular = $("#txtCelular").val();
            dataUsuario.Direccion = $("#txtDireccion").val();
            dataUsuario.IdPais = $("#cmbPais").val();
            dataUsuario.IdDepartamento = $("#cmbDepartamento").val();
            dataUsuario.IdCiudad = $("#cmbCiudad").val();
            dataUsuario.OtraCIudad = $("#txtOtraCiudad").val();
            dataUsuario.Activo = $("#chkActivo").prop("checked");
            // Credenciales de acceso
            let dataLogin = {};
            dataLogin.Usuario = $("#txtUsuario").val();
            dataLogin.Contrasena = $("#txtContrasena").val();
            dataLogin.DebeCambiar = $("#chkDebeCambiarContrasena").prop("checked");
            dataUsuario.Credenciales = dataLogin;

            CrearUsuario(dataUsuario);
        });

        //---------------------------------------------------------------------------------------------------------------------
        // Recupera lista de ciudades ó municipios del departamento ó estado especificado.
        //---------------------------------------------------------------------------------------------------------------------
        $('#cmbDepartamento').on('change', function () {
            if ($(this).val()) {
                //$('#cmbCiudad').prop('disabled', false);
                //$("#cmbCiudad").empty();
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
                                // Llena el cuadrode lista
                                $("#cmbCiudad").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");
                                $.each(objResultado.Resultado, function (i, listado) {
                                    $("#cmbCiudad").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
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
        // Guarda cambios del perfíl del usuario.
        //---------------------------------------------------------------------------------------------------------------------
        function ActualizarUsuario(dataUsuario) {
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                //headers: token,
                url: pageUrl + "/ActualizarUsuario",
                cache: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false, 
                data: dataUsuario,
                success: function (response) {
                    // Cierra el diálogo Modal
                    $("#nuevoMensajeModal").modal("hide");
                    var objResultado = JSON.parse(response);
                    if (objResultado.Codigo == '0') {
                        // Refresca la bandeja de Salida.
                        //$("#btnCorreoEnviados").click();
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
        // Crea un usuario nuevo y un inicio de sesión.
        //---------------------------------------------------------------------------------------------------------------------
        function CrearUsuario(dataUsuario) {
            //alert('CrearUsuario.');
            var dataObject = "{'dataUsuario':" + JSON.stringify(dataUsuario) + "}";
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';
            // var resultado = false;

            $.ajax({
                type: "POST",
                url: pageUrl + "/CrearUsuario",
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
                        // Refresca la bandeja de Salida.
                        let idUsuarioNuevo = objResultado.Resultado;
                        // Carga el registro de datos del nuevo usuario en modo 'Edicion'. Op=2.
                        window.location.href = "/EditarUsuario.aspx?Id=" + idUsuarioNuevo + "&op=2";
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
            //return resultado;
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
        // Devuelve la lista de tipos de documentos de identificación..
        //---------------------------------------------------------------------------------------------------------------------
        function ListaTiposDocumento() { 
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                url: pageUrl + "/ListaTiposDocumento",
                //headers: token,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                processData: false,
                data: '',
                async: false,
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    if (objResultado.Codigo == '0') {
                        $("#cmbTipoDocumento").empty();
                        $("#cmbTipoDocumento").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");
                        $.each(objResultado.Resultado, function (i, listado) {
                            $("#cmbTipoDocumento").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
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
        // Devuelve la lista de Programas Académicos..
        //---------------------------------------------------------------------------------------------------------------------
        function ListaProgramasAcademicos(estado) { // Roles de usuario.
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                url: pageUrl + "/ListaProgramasAcademicos",
                //headers: token,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                processData: false,
                data: JSON.stringify({ 'estado': estado }),
                async: false,
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    //console.log(response);
                    //console.log(objResultado);
                    //console.log(objResultado.Codigo);
                    if (objResultado.Codigo == '0') {
                        $("#cmbProgramaAcademico").empty();
                        $("#cmbProgramaAcademico").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");
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
        // Devuelve la lista de Roles de usuarios..
        //---------------------------------------------------------------------------------------------------------------------
        function ListaRoles() { // Roles de usuario.
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                url: pageUrl + "/ListaRoles",
                //headers: token,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                processData: false,
                data: '',
                async: false,
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    if (objResultado.Codigo == '0') {
                        $("#cmbRol").empty();
                        $("#cmbRol").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");
                        $.each(objResultado.Resultado, function (i, listado) {
                            $("#cmbRol").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
                        });
                    } else {
                        MostrarMensaje(objResultado.Mensaje);
                    }
                    //var objResultado = JSON.parse(response);
                    //if (objResultado.Codigo == '0') {
                    //    // Refresca la bandeja de Salida.
                    //    //$("#btnCorreoEnviados").click();
                    //} else {
                    //    MostrarMensaje(objResultado.Mensaje);
                    //}
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

        function MostrarMensaje(mensaje) {
            //alert("Se requiere ingresar el Asunto");
            $("#divCuerpoMensaje").empty();
            $("#divCuerpoMensaje").html(mensaje);
            // Presenta el diálogo Modal
            $("#dlgMensajeModal").modal('show');
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



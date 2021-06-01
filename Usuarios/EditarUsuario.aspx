<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EditarUsuario.aspx.vb" Inherits="Usuarios_EditarUsuario" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOCORE | Editar Usuario</title>
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

                            <h3 id="hTitulo" class="titulo">Perfil Usuario</h3>

                            <form id="frmPerfilUsuario" class="was-validated"  method="post">
                                 <input id="hddIDUsuario" name="IdUsuario" type="hidden" value="">
                                 <input id="hddNombreArchivoFotoServidor" name="nombreArchivoFotoServidor" type="hidden" value="">
                                 <div class="row bg-dangerX">
                                     <div class="col-md-2 col-sm-3 col-12 align-self-center">
                                         <div class="form-group remover text-center container-fluid m-0 bg-infoX">
                                             <button id="btnRemoverFoto" type="button" class="btn btn-primary btn-xs rounded-circle fa fa-minus d-none" data-toggle="modal" data-target="#dlgMensajeConfirmacionModal"></button>
                                             <img id="imgFotoUsuario" class="img-fluid w-100" onclick="document.getElementById('fileUploadFotoUsuario').click()" src="../images/Silueta.png" style="cursor: pointer;" title="Subir Foto (3cm x 4cm)" />
<%--                                            <button id="btnfileUploadFotoUsuario" class="btn btn-light border border-dark" onclick="document.getElementById('fileUploadFotoUsuario').click()">Seleccionar archivo...</button>
                                            &nbsp;
                                            <span id="spnfileChoiseNM">Archivo no escogido</span>--%>
                                            <input id="fileUploadFotoUsuario" type="file" name="fileUploadFotoUsuario" style="display: none;" />
                                        </div>
                                     </div>

                                    <div class="col-md-10 col-sm-9 col-12">
                                        <div class="form-group">
                                            <label for="txtNombres">Nombres</label>
                                            <input  id="txtNombres" type="text" class="form-control letter-whitespace-only" placeholder="Texto" required>
                                        </div> 
                                        <div class="form-group">
                                            <label for="txtApellidos">Apellidos</label>
                                            <input id="txtApellidos" type="text" class="form-control letter-whitespace-only" placeholder="Texto" required>
                                        </div>
<%--                                        <div class="form-group">
                                            <label for="cmbTipoDocumento">Tipo de documento</label>
                                            <select id="cmbTipoDocumento" class="form-control" id="select1" 
                                                oninvalid="this.setCustomValidity('Seleccione un Tipo de documento de identificación de la lista')"
                                                oninput="this.setCustomValidity('')"
                                                required>
                                                <option selected='selected' disabled='' value=''>- Seleccione -</option>
                                            </select>
                                        </div>--%>
                                    </div>
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
                                <div class="row">
                                    <div class="form-group col-12">
                                        <label for="txtEmail">Email</label>
                                        <input id="txtEmail" class="form-control" 
                                            placeholder="nombre@servidorcorreo.com" 
                                            type="email"
                                            required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group col-12">
                                        <label for="txtCelular">Celular</label>
                                        <input  id="txtCelular"  class="form-control" maxlength="15"  
                                            placeholder="999-9999999" 
                                            type="tel"
                                            pattern="[0-9]{3}-[0-9]{7}"
                                            required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group col-12">
                                        <label for="cmbRol">Rol</label>
                                        <select id="cmbRol" class="form-control" id="select1" 
                                            oninvalid="this.setCustomValidity('Seleccione un Rol de la lista')"
                                            oninput="this.setCustomValidity('')"
                                            required>
                                        </select>
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
                               <div class="row">
                                    <div class="form-group col-12">
                                        <label for="txtDireccion">Dirección</label>
                                        <input  id="txtDireccion"  class="form-control" maxlength="50"  
                                            placeholder="Dirección" 
                                            type="text"
                                            required>
                                    </div>
                                </div>
                               <div class="row pl-3">
                                    <div class="form-check">
                                        <input id="chkActivo" type="checkbox" class="form-check-input">
                                        <label class="form-check-label" for="chkActivo" style="color:black;">Activo</label>
                                    </div>
                                </div>

                                <div id="divGuardarCambios" class="form-group float-right">
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

    <!-- Diálogo de Mensajes -->
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
                   <span id="spnMensajeConfirmacion">¿Desea remover la fotografía del perfíl del usuario?</span>
                </div>
                <div class="modal-footer">
                    <button id="btnAceptarRemoverFoto" type="button" class="btn btn-primary mr-sm-2">Aceptar</button>
                    <button type="button" class="btn btn-secondary ml-sm-2" data-dismiss="modal">Cancelar</button>
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
    <script type="text/javascript" src="../js/URLParametros.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {

            $(window).load(function () {
                //Recupera la cadena de consulta 
                //let querystring = window.location.search.substring(1);
                //let idUsuario = GetQueryString("Id");
                //let operacion = GetQueryString("op");

                //idUsuario = "95403295-5E84-4F5C-A636-02A071EF254F"; //borrar
                //operacion = 2;
                idUsuario = getURLParameter("Id");
                operacion = getURLParameter("op");

                //alert("idUsuario: " + idUsuario);
                //alert("operacion: " + operacion);

                $("#hddIDUsuario").val(idUsuario);

                if (idUsuario != "null" && operacion != "null") {
                    let usuarioLoggeado = '<%= Session("NombreUsuarioLoggeado") %>';
                    $("#spnUsuarioLogueado").text(usuarioLoggeado);

                    // Ejecuta secuencialmente y sincrónicamente las siguientes subrutinas.
                    ListaTiposDocumento().then(estado => {
                        return ListaPaises();
                    }).then(estado => {
                        return ListaRoles();
                    }).then(estado => {
                        return EditarUsuario(idUsuario);
                    }).then(estado => {
                        //DatosPrueba();
                        if (operacion == 1) {
                            $("#frmPerfilUsuario :input").prop("disabled", true);
                            $("#btnRemoverFoto").remove();
                            $("#divGuardarCambios").remove();
                            $("#hTitulo").text("Usuario en consulta");
                        } else {
                            $("#hTitulo").text("Usuario en edición");
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

        function ListaRoles() {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/ListaRoles",
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

        function ListaTiposDocumento() {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/ListaTiposDocumento",
                    //headers: token,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    data: '',
                    async: false, // Para usar con promesas
                    success: function (response) {
                        var objResultado = JSON.parse(response.d);
                        if (objResultado.Codigo == '0') {
                            $("#cmbTipoDocumento").empty();
                            $("#cmbTipoDocumento").append("<option selected='selected' disabled='' value=''>- Seleccione -</option>");
                            $.each(objResultado.Resultado, function (i, listado) {
                                $("#cmbTipoDocumento").append('<option value="' + listado.Key + '">' + listado.Value + '</option>');
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

        function preventBack() { window.history.forward(); }
        setTimeout("preventBack()", 0);
        window.onunload = function () { null };

        //--------------------------------------------------------------------------------------------------------
        // Cerrar Sesión: Se apoya de un button ASP.Net oculto
        //--------------------------------------------------------------------------------------------------------
        function CerrarSesion() {
            // alert('Cerrando sesión');
            document.getElementById('btnCerrarSesion').click();
        }

       //---------------------------------------------------------------------------------------------------------
        // Remueve la fotografía del usuario actual..
        //--------------------------------------------------------------------------------------------------------
        $("#btnAceptarRemoverFoto").on("click", function () {
            RemoverFoto();
        });

       //---------------------------------------------------------------------------------------------------------
        // Carga una imagen con la fotografía del usuario actual, valida su formato y tamaño..
        //--------------------------------------------------------------------------------------------------------
        $("#fileUploadFotoUsuario").on("change", function () {
            //alert('Cargando foto...');
            var ext = $('#fileUploadFotoUsuario').val().split('.').pop().toLowerCase();
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
                        let razon = parseFloat(width / height);

                        if (razon.toFixed(2) == (75 / 100)) {
                            var dataURL = e.target.result;
                            $("#imgFotoUsuario").attr('src', dataURL);

                            let files = $("#fileUploadFotoUsuario").prop("files");
                            let url = $("#fileUploadFotoUsuario").val();
                            let extension = url.split('.')[1];

                            let datosFoto = new FormData();
                            datosFoto.append("IdUsuario", $("#hddIDUsuario").val());
                            datosFoto.append("NombreUsuario", LimpiarCaracteresAcentuados($("#txtNombres").val()) + "_" + LimpiarCaracteresAcentuados($("#txtApellidos").val()));
                            datosFoto.append("Tipo", files[0].type);
                            datosFoto.append("Extension", extension);
                            datosFoto.append("file", $("#fileUploadFotoUsuario").prop('files')[0]);

                            GuardarFoto(datosFoto);
                            return true;
                        }
                        else {
                            MostrarMensaje("Tamaño de imagen no válido. Tamaño permitido 3cm x 4cm, resolución 120 ó 300 ppp");
                            return false;
                        }
                    };
                };
            }
        });

        //$("#fileUploadFotoUsuario").on("change", function () {
        //    //alert('Cargando foto...');
        //    var ext = $('#fileUploadFotoUsuario').val().split('.').pop().toLowerCase();
        //    var arrExtensiones = ['jpg', 'png'];
        //    if ($.inArray(ext, ['jpg', 'png']) == -1) {
        //        MostrarMensaje("Tipo de archivo no valido. Formatos permitdos JPG, PNG");
        //        this.value = "";
        //    } else if (this.files[0].size > 2097152) {  //2MB
        //        MostrarMensaje("No se permite cargar archivos mayores a " + 2097152 / 1024 / 1024 + "MB");
        //        this.value = "";
        //    } else {
        //        var reader = new FileReader();
        //        reader.onload = function (e) {
        //            var dataURL = e.target.result;
        //            $("#imgFotoUsuario").attr('src', dataURL);

        //            //let files = $("#fileUploadFotoUsuario").prop("files");
        //            //let url = $("#fileUploadFotoUsuario").val();
        //            //let extension = url.split('.')[1];

        //            //let datosFoto = new FormData();
        //            //datosFoto.append("IdUsuario", 1452);
        //            //datosFoto.append("Tipo", files[0].type);
        //            //datosFoto.append("Extension", extension);
        //            //datosFoto.append("file", $("#fileUploadFotoUsuario").prop('files')[0]);

        //            //GuardarFoto(datosFoto);
        //        }
        //        reader.readAsDataURL(this.files[0]);
        //    }
        //});

        //---------------------------------------------------------------------------------------------------------------------
        // Guarda cambios del perfil del usuario.
        //---------------------------------------------------------------------------------------------------------------------
        $('#frmPerfilUsuario').submit(function (e) {
            e.preventDefault();  //prevent form from submitting
            //alert('Guardar cambios de Perfil de Usuario.');

            // recupera datos del formulario Perfil del Usuario.
            let dataUsuario = {};
            dataUsuario.IdUsuario = $("#hddIDUsuario").val();
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

            // Guarda cambios
            ActualizarUsuario(dataUsuario);
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
                                // Llena el cuadro de lista
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
            var dataObject = "{'dataUsuario':" + JSON.stringify(dataUsuario) + "}";

            $.ajax({
                type: "POST",
                //headers: token,
                url: pageUrl + "/ActualizarUsuario",
                cache: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false, 
                data: dataObject,
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    if (objResultado.Codigo == '0') {
                        MostrarMensaje("Cambios registrados éxitosamente");
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
        // Recupera el registro de datos para el usuario especificado.
        //---------------------------------------------------------------------------------------------------------------------
        function EditarUsuario(idUsuario) {
            return new Promise((resolve, reject) => {
                var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

                $.ajax({
                    type: "POST",
                    url: pageUrl + "/EditarUsuario",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    processData: false,
                    data: JSON.stringify({ 'idUsuario': idUsuario }),
                    async: false,  // Establecer en false si se invoca desde una promesa.
                    success: function (response) {
                        var objResultado = JSON.parse(response.d);

                        if (objResultado.Codigo == '0') {
                            let dataUsuario = objResultado.Resultado;

                            // Presenta/Oculta botón 'Remover Foto'
                            if (JSON.parse(dataUsuario.ConFoto)  === true) {
                                $("#btnRemoverFoto").addClass("d-block");
                                $("#btnRemoverFoto").removeClass("d-none");
                            }
                            else {
                                $("#btnRemoverFoto").addClass("d-none");
                                $("#btnRemoverFoto").removeClass("d-block");
                            }

                            $("#imgFotoUsuario").attr('src', dataUsuario.Foto);
                            $("#hddNombreArchivoFotoServidor").val(dataUsuario.NombreArchivoFotoServidor);
                            $("#txtNombres").val(dataUsuario.Nombres);
                            $("#txtApellidos").val(dataUsuario.Apellidos);
                            $("#cmbTipoDocumento").val(dataUsuario.IdTipoDocumento);
                            $("#txtNoDocumento").val(dataUsuario.Documento);
                            $("#cmbRol").val(dataUsuario.IdRol); 
                            $("#txtEmail").val(dataUsuario.Email);
                            $("#txtCelular").val(dataUsuario.Celular);
                            $("#txtDireccion").val(dataUsuario.Direccion);
                            $("#cmbPais").val(dataUsuario.IdPais);
                            $("#cmbPais").trigger("change");
                            $("#cmbDepartamento").val(dataUsuario.IdDepartamento); // Exterior
                            $("#cmbDepartamento").trigger("change");
                            if (dataUsuario.IdDepartamento == "00") { //Exterior
                                $("#txtOtraCiudad").val(dataUsuario.OtraCIudad);
                            }
                            else { // Sólo Departamentos de Colombia.
                                $("#cmbCiudad").val(dataUsuario.IdCiudad);
                            }
                            $('#chkActivo').prop("checked", true);

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
        // Guardar Archivo
        //---------------------------------------------------------------------------------------------------------------------
        function GuardarFoto(datosFoto) {
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
                url: pageUrl + "/GuardarFoto",
                cache: false,
                contentType: false,   // tell jQuery not to set contentType
                processData: false,  // tell jQuery not to process the data
                async: true,
                data: datosFoto,  //FormData
                //global: false,  // this makes sure ajaxStart is not triggered
                success: function (response) {
                    //alert("Fotografía de usuario regisrada exitosamente");
                    // Agrega el icono spinner al botón
                    //BtnReset($("#btnSubirArchivoNM"));
                    var objResultado = JSON.parse(response);

                    if (objResultado.Codigo == '0') {
                        // Presenta el botón 'Remover Foto'
                        $("#btnRemoverFoto").addClass("d-block");
                        $("#btnRemoverFoto").removeClass("d-none");
                        $("#hddNombreArchivoFotoServidor").val(objResultado.Resultado);
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
            //return resultado;
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

        function MostrarMensaje(mensaje) {
            //alert("Se requiere ingresar el Asunto");
            $("#divCuerpoMensaje").empty();
            $("#divCuerpoMensaje").html(mensaje);
            // Presenta el diálogo Modal
            $("#dlgMensajeModal").modal('show');
        }

        //---------------------------------------------------------------------------------------------------------------------
        // Remueve la fotografía del registro de datos del usuario..
        //---------------------------------------------------------------------------------------------------------------------
        function RemoverFoto() {
            var pageUrl = '<%=ResolveUrl("~/wsBocore.asmx")%>';

            $.ajax({
                type: "POST",
                //headers: token,
                url: pageUrl + "/RemoverFoto",
                cache: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                data: JSON.stringify({ 'idUsuario': $("#hddIDUsuario").val(), 'nombreArchivoFotoServidor': $("#hddNombreArchivoFotoServidor").val() }),
                success: function (response) {
                    var objResultado = JSON.parse(response.d);
                    // Cierra el diálogo Modal
                    $("#dlgMensajeConfirmacionModal").modal("hide");

                    if (objResultado.Codigo == '0') {
                        // Oculta botón 'Remover Foto'
                        $("#btnRemoverFoto").addClass("d-none");
                        $("#btnRemoverFoto").removeClass("d-block");
                        // Establece la imagen silueta de usuario por defecto
                        $("#imgFotoUsuario").attr("src", "../images/Silueta.png");
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

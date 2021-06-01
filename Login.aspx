<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOCORE | Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BmbxuPwQa2lc/FVzBcNJ7UAyJxM6wuqIj61tLrc4wSX0szH/Ev+nYRRuWlolflfl" crossorigin="anonymous">
    <link href="css/bocore.css" rel="stylesheet" />
</head>
<body class="loginView">
    <header>
        <div class="container-fluid">
            <div class="row">
                <div class="col-3">
                    <img src="images/logo.png" class="img-fluid" />
                </div>
            </div>
        </div>
    </header>

    <div class="container-fluid dashboardContainer">
        <div class="row">
            <div class="col-10 col-sm-8 col-md-6 col-lg-4 login">
                <form id="frmCredencialesUsuario" class="was-validated"  method="post" runat="server" novalidate="novalidate">
                    <p class="text-center"><img src="images/icono.png" class="img-fluid"/></p>
                    <h4 class="text-center">Iniciar Sesión</h4>
                    <div class="form-group">
                        <label>Usuario</label>
                        <input id="txtUsuario" class="form-control" type="text" name="usuario" maxlength="20" placeholder="Usuario" required />
<%--                        <div class="valid-feedback">Valido.</div>--%>
                        <div class="invalid-feedback">Ingrese el usuario</div>
                    </div>
                    <div class="form-group">
                        <label>Contraseña</label>
                        <input id="txtContrasena" class="form-control" type="password" name="contrasena"  maxlength="20" placeholder="Contraseña" required />
                <%--        <div class="valid-feedback">Valido.</div>--%>
                        <div class="invalid-feedback">Ingrese la contraseña</div>                    
                    </div>                    
                    <div class="row mt-3">
                        <div class="col-lg-6">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="" id="recordarme">
                                <label class="form-check-label" for="recordarme">
                                  Recordarme
                                </label>
                            </div>
                        </div>
                        <div class="col-lg-6 text-right">
                            <a href="#">Olvidó su contraseña?</a>
                        </div>
                    </div>
                    <p class="text-center"><input id="btnIniniciarSesion" type="submit" class="btn btn-primary submitBtn " value="Ingresar" /></p>
                </form>
            </div>
        </div>
    </div>

    <div class="container-fluid footer text-center">
        Universidad de Santander UDES - 2021
    </div>

    <div class="loader" id="AjaxLoader" style="display:none;">  
       <div class="strip-holder">  
           <div class="strip-1"></div>  
           <div class="strip-2"></div>  
           <div class="strip-3"></div>  
       </div>  
   </div> 

    <script src="Scripts/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>

   <script type="text/javascript">
       // Declaración de variables globales a nivel de archivo

       $(document).ready(function () {
           //alert("Hola");
       });

       //*******************************************************************
       // FUNCIONES CALLBACK
       //*******************************************************************
       $('#frmCredencialesUsuario').submit(function (e) {
           //$("#mensaje").css("display", "none");
           if ($('#frmCredencialesUsuario')[0].checkValidity()) {
               //prevent default
               e.preventDefault();

               let objDataLogin = {};

               //alert('Validando...');
               objDataLogin.IdCallback = "1";
               objDataLogin.Usuario = document.getElementById("txtUsuario").value;
               objDataLogin.Contrasena = document.getElementById("txtContrasena").value;
               //alert("Usuario: " + objDataLogin.Usuario);
               //alert("Contrasena: " + objDataLogin.Contrasena);

               //_usuario = ctrlUsuario.value;
               //_contraseña = ctrlContraseña.value;
               //var credenciales = _usuario + '|' + _contraseña;

               //var objParametros = {};
               //objParametros.IdCallback = "1";
               //objParametros.Parametro = credenciales;
               var jsonParametrosCliente = JSON.stringify(objDataLogin);

               CallValidarCredenciales(jsonParametrosCliente, "");
           }
           else {
               e.preventDefault();
               $('#frmCredencialesUsuario')[0].reportValidity();
           }
       });

       function ReceiveServerValidarCredenciales(data) {
           //$("#mensaje").css("display", "none");
           //$("#mensaje").text("");

           // Dump the JSON text response from the server.
           //document.forms[0].JSONResponse.value = arg;
           // Parse JSON text returned from callback.
           var objResultado = eval("(" + data + ")");
           console.log(objResultado);
           if (objResultado.Codigo == '0') {

               var URL = '<%=ResolveUrl("~/Proyectos/Proyectos.aspx") %>';
               if (UrlExists(URL) == true) {
                   window.location.href = URL;
               }
           } else {
               alert(objResultado.mensaje);
               $("#mensaje").css("display", "list-item");
               $("#mensaje").text(objResultado.mensaje);
           }
       }

       function ClientCallbackError(result, context) {
           var errorDecodificado = DecodeHtml(result);
           alert("Error: " + errorDecodificado);
           //$("#mensaje").css("display", "list-item");
           //$("#mensaje").text(errorDecodificado);
       }

       function DecodeHtml(html) {
           //Funcion que decodifica texto HTML
           //Artificio...
           var txt = document.createElement("textarea");
           txt.innerHTML = html;
           return txt.value;
       }

       function UrlExists(url) {
           var http = new XMLHttpRequest();
           try {
               http.open('GET', url, false);
               http.send();
               return (http.status == 404) ? false : true;
           } catch (e) {
               return false;
           }
       }
   </script>
</body>


</html>

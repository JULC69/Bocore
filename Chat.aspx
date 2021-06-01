<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Chat.aspx.vb" Inherits="Chat" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Chat</title>
    <script src="Scripts/jquery-3.5.1.min.js"></script>
    <script src="Scripts/jquery.signalR-2.4.1.min.js"></script>
    <script src="chatSignalR/hubs"></script>
    <script src="js/chat/chat.js"></script>

    <link href="css/bootstrap.css" rel="stylesheet" />

    <script type="text/javascript">
        var _gIdProyecto = 1;
        var x = 0;
        $(document).ready(function () {
            InicializarChat(1);
            //$("#divWrapChat").scroll(function () {
            //    console.log(x += 1);
            // });
            //$('#divWrapChat').on('scroll', function () {
            //    //console.log("Vertical " + $(this).scrollTop());
            //    if ($(this).scrollTop() == 0) {
            //        alert("Cargando más mensajes...");
            //    }
            //});

            //$(window).on('beforeunload', function () {
            //    broadcaster.server.leave($('#groupName').val());
            //    return 'Are you sure you want to leave?';
            //});
        });

        //$('#divWrapChat').on('scroll', function () {
        //    alert($(this).scrollTop());
        //    if ($(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight) {
        //        alert('end reached');
        //    }
        //})

        //$('#divWrapChat').on('scroll', function () {
        //    alert($(this).scrollTop());'
        //    if ($(this).scrollTop() == 0) {
        //        alert("Cargando más mensajes...");
        //    }
        //});

        //$(function () {
        //    var broadcaster = $.connection.broadcastHub;
        //    alert(broadcaster);
        //    $.connection.hub.logging = true;

        //    //var connection = $.hubConnection();
        //    //connection.error(function (error) {
        //    //    console.log('Error SignalR: ' + error);
        //    //});

        //    broadcaster.client.displayText = function (group, name, message) {
        //        $('#messages').append('<li class="list-group-item">' + name + ' dice: ' + message + '</li>');
        //        $('#divWrapChat').scrollTop($('#divWrapChat')[0].scrollHeight);
        //    };
        //    $.connection.hub.start().done(function () {
        //        // Al iniciar el servicio de Chat se carga la lista de mensajes relacionados con el proyecto actual.
        //        //$('#messages').empty();
        //        //broadcaster.server.join(_gIdProyecto); 
        //        //broadcaster.server.openBroadcast(_gIdProyecto);
        //        //alert("Hola");

        //        $('#btnEnviarMensaje').click(function () {
        //            broadcaster.server.join($('#groupName').val());

        //            broadcaster.server.broadcastMessage({
        //                IdCentroServicio: 1,
        //                IdProyecto: $('#groupName').val(),
        //                IdRemitente: "95403295-5E84-4F5C-A636-02A071EF254F",
        //                Remitente: $('#name').val(),
        //                Mensaje: $('#message').val(),
        //                FechaMensaje: new Date()
        //            });
        //        });

        //        $('#leave').click(function () {
        //            broadcaster.server.leave($('#groupName').val());
        //        });

        //        $("#btnConectar").click(function () {
        //            $('#messages').empty();
        //            broadcaster.server.join($('#groupName').val());
        //            broadcaster.server.openBroadcast($('#groupName').val());
        //        });
        //    }).fail(function (error) {
        //        alert(error);
        //    });
        //});
    </script>

</head>
<body>
    <div class="jumbotron text-center">
        <h1>ASP.NET SignalR</h1>
        <p>Chat usando Hubs</p>
    </div>
    <div class="container">
        <div class="form-inline">
            <a href="https://www.w3schools.com">Visit W3Schools</a>
            <input type="text" id="groupName" placeholder="Grupo" class="form-control mb-2 mr-sm-2 mb-sm-0" />
            <input type="text" id="name" placeholder="Nombre" class="form-control mb-2 mr-sm-2 mb-sm-0" />
            <input type="text" id="message" placeholder="Mensaje" class="form-control mb-2 mr-sm-2 mb-sm-0" />
            <input type="button" id="btnEnviarMensaje" value="Enviar" class="btn btn-success" />
            <input type="button" id="leave" value="Abandonar" class="btn btn-danger" />
            <input type="button" id="btnConectar" value="Conectar" class="btn btn-success" />
        </div>
        <div id="divWrapChat" style="background-color:yellow; height:500px; overflow:auto;">
           <ul id="messages" class="list-group border"></ul>
        </div>

    </div>
</body>
</html>

function InicializarChat(idGrupo) {
    var broadcaster = $.connection.broadcastHub;
    $.connection.hub.logging = true;

    //var connection = $.hubConnection();
    //connection.error(function (error) {
    //    console.log('Error SignalR: ' + error);
    //});

    broadcaster.client.displayText = function (group, name, message) {
        $('#messages').append('<li class="list-group-item">' + name + ' dice: ' + message + '</li>');
        $('#divWrapChat').scrollTop($('#divWrapChat')[0].scrollHeight);
    };

    $.connection.hub.start().done(function () {
        // Al iniciar el servicio de Chat se carga la lista de mensajes relacionados con el proyecto actual.
        $('#messages').empty();
        broadcaster.server.join(idGrupo);
        broadcaster.server.openBroadcast(idGrupo);

        $('#btnEnviarMensaje').click(function () {
            broadcaster.server.join(idGrupo);

            broadcaster.server.broadcastMessage({
                IdCentroServicio: 1,
                IdProyecto: idGrupo,
                IdRemitente: "95403295-5E84-4F5C-A636-02A071EF254F",
                Remitente: $('#name').val(),
                Mensaje: $('#message').val(),
                FechaMensaje: new Date()
            });
        });

        $('#leave').click(function () {
            broadcaster.server.leave(idGrupo);
        });

        $("#btnConectar").click(function () {
            $('#messages').empty();
            broadcaster.server.join($('#groupName').val());
            broadcaster.server.openBroadcast($('#groupName').val());
        });
    }).fail(function (error) {
        alert(error);
    });

    $('#divWrapChat').on('scroll', function () {
        if ($(this).scrollTop() == 0) {
            alert("Cargando más mensajes...");
        }
    });

    //$(window).on('beforeunload', function () {
    //    broadcaster.server.leave(idGrupo);
    //    return 'Are you sure you want to leave?';
    //});
};

function InicializarChat2(idGrupo) {
    var broadcaster = $.connection.broadcastHub;
    $.connection.hub.logging = true;

    //var connection = $.hubConnection();
    //connection.error(function (error) {
    //    console.log('Error SignalR: ' + error);
    //});

    broadcaster.client.displayText = function (group, name, message) {
        $('#messages').append('<li class="list-group-item">' + name + ' dice: ' + message + '</li>');
        $('#divWrapChat').scrollTop($('#divWrapChat')[0].scrollHeight);
    };

    $.connection.hub.start().done(function () {
        // Al iniciar el servicio de Chat se carga la lista de mensajes relacionados con el proyecto actual.
        $('#messages').empty();
        broadcaster.server.join(idGrupo);
        broadcaster.server.openBroadcast(idGrupo);

        $('#btnEnviarMensaje').click(function () {
            broadcaster.server.join(idGrupo);

            broadcaster.server.broadcastMessage({
                IdCentroServicio: 1,
                IdProyecto: idGrupo,
                IdRemitente: "95403295-5E84-4F5C-A636-02A071EF254F",
                Remitente: $('#name').val(),
                Mensaje: $('#message').val(),
                FechaMensaje: new Date()
            });
        });

        $('#leave').click(function () {
            broadcaster.server.leave(idGrupo);
        });

        $("#btnConectar").click(function () {
            $('#messages').empty();
            broadcaster.server.join($('#groupName').val());
            broadcaster.server.openBroadcast($('#groupName').val());
        });
    }).fail(function (error) {
        alert(error);
    });

    $('#divWrapChat').on('scroll', function () {
        if ($(this).scrollTop() == 0) {
            alert("Cargando más mensajes...");
        }
    });

    //$(window).on('beforeunload', function () {
    //    broadcaster.server.leave(idGrupo);
    //    return 'Are you sure you want to leave?';
    //});
};
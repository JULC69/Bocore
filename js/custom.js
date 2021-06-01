$(document).ready(function() {

    bsCustomFileInput.init();

    $('[data-toggle="tooltip"]').tooltip();

    // Editor Enriquecido
    $('#summernote').summernote();

    // Datepicker1 - Fecha
    $('#datetimepicker1').datetimepicker({
        format: 'L'
    });

    // Datepicker2 - Hora
    $('#datetimepicker2').datetimepicker({
        format: 'LT'
    });

    // Tabla editable
    //$('#editable').editableTableWidget();

    // Datatable
    $('.dataTable').DataTable({
        responsive: true,
        "language": {
            "url": "http://cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
        },
        columnDefs: [{
            targets: [0],
            orderData: [0, 1]
        }, {
            targets: [1],
            orderData: [1, 0]
        }, {
            targets: [4],
            orderData: [4, 0]
        }]
    });
    //new $.fn.dataTable.FixedHeader(table);

    $('.dataTableNO').DataTable({
        searching: false,
        ordering: false,
        paging: false,
        info: false,
        responsive: true,
        "language": {
            "url": "http://cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Spanish.json"
        }
    });

    /// Select Row
    $('.dataTable tbody').on('click', 'tr', function() {
        $('.dataTable tbody tr').removeClass('selected');
        $(this).toggleClass('selected');
    });

});

// Close
$(document).mouseup(function(e) {
    var container = $(".dropdownMenuUser");

    // if the target of the click isn't the container nor a descendant of the container
    if (!container.is(e.target) && container.has(e.target).length === 0) {
        container.hide();
    }

});

// Alerts - sweetalert

$(document).ready(function() {
    $('.example1').click(function() {
        Swal.fire('Alert basico');
    });
    $('.example5').click(function() {
        Swal.fire(
            'Exito!',
            'Registro guardado!',
            'success'
        )
    });
    $('.example4').click(function() {
        Swal.fire({
            title: 'Está seguro?',
            text: "Esta acción no se puede revertir!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Si, Eliminar!'
        }).then((result) => {
            if (result.value) {
                Swal.fire(
                    'Eliminado!',
                    'El registro se ha eliminado.',
                    'success'
                )
            }
        })
    });
    $('.example3').click(function() {
        Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: 'Algo salió mal',
            footer: '<a href>Why do I have this issue?</a>'
        })
    });
    $('.example2').click(function() {
        Swal.fire(
            'The Internet?',
            'That thing is still around?',
            'question'
        )
    });
    $('.exampleajax').click(function() {
        Swal.fire({
            title: 'Ingresar usuario Github',
            input: 'text',
            inputAttributes: {
                autocapitalize: 'off'
            },
            showCancelButton: true,
            confirmButtonText: 'Look up',
            showLoaderOnConfirm: true,
            preConfirm: async(login) => {
                try {
                    const response = await fetch(`https://api.github.com/users/${login}`);
                    if (!response.ok) {
                        throw new Error(response.statusText);
                    }
                    return response.json();
                } catch (error) {
                    Swal.showValidationMessage(`Request failed: ${error}`);
                }
            },
            allowOutsideClick: () => !Swal.isLoading()
        }).then((result) => {
            if (result.value) {
                Swal.fire({
                    title: `${result.value.login} avatar`,
                    imageUrl: result.value.avatar_url
                })
            }
        })
    });

    // Editable Datatable
    $('#editable').Tabledit({
        url: 'example.php',
        deleteButton: false,
        saveButton: true,
        autoFocus: true,
        restoreButton: true,
        buttons: {
            edit: {
                class: 'btn btn-sm btn-info',
                html: 'Editar',
                action: 'edit'
            },
            save: {
                class: 'btn btn-sm btn-success',
                html: 'Guardar'
            },
            restore: {
                class: 'btn btn-sm btn-warning',
                html: 'Restaurar',
                action: 'restore'
            },
        },
        columns: {
            identifier: [0, 'id'],
            editable: [
                [1, 'Nombre'],
                [2, 'Puesto'],
                [3, 'Oficina'],
                [4, 'Edad'],
                [5, 'Fecha Inicio'],
                [6, 'Salario'],
                [7, 'Opciones']
            ]
        }
    });
});
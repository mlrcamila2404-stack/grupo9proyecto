
document.addEventListener("DOMContentLoaded", () => {
    const formPerfil = document.getElementById("formPerfil");
    const inputNombre = document.getElementById("nombre");
    const inputApellido = document.getElementById("apellido");
    const inputCorreo = document.getElementById("correo");
    const inputPassword = document.getElementById("password");
    const divMensaje = document.getElementById("mensaje");

    // 1. Cargar datos del perfil al abrir la página
    fetch("obtener-perfil.php")
        .then(response => response.json())
        .then(resultado => {
            if (resultado.success) {
                inputNombre.value = resultado.data.nombre;
                inputApellido.value = resultado.data.apellido;
                inputCorreo.value = resultado.data.correo;
            } else {
                // Si no hay sesión válida, redirigir al login
                window.location.href = "login.html";
            }
        })
        .catch(error => {
            console.error("Error al obtener el perfil:", error);
        });

    // 2. Enviar actualización usando Fetch API
    formPerfil.addEventListener("submit", (e) => {
        e.preventDefault(); // Evitar recarga clásica del formulario

        const datosFormulario = new URLSearchParams();
        datosFormulario.append("nombre", inputNombre.value);
        datosFormulario.append("apellido", inputApellido.value);
        datosFormulario.append("correo", inputCorreo.value);
        datosFormulario.append("password", inputPassword.value);

        fetch("perfil-actualizar.php", {
            method: "POST",
            body: datosFormulario
        })
        .then(response => response.json())
        .then(resultado => {
            divMensaje.textContent = resultado.message;
            if (resultado.success) {
                divMensaje.className = "success";
                inputPassword.value = ""; // Limpiar campo de contraseña por seguridad
            } else {
                divMensaje.className = "error";
            }
        })
        .catch(error => {
            divMensaje.textContent = "Ocurrió un error al actualizar el perfil.";
            divMensaje.className = "error";
            console.error("Error:", error);
        });
    });
});
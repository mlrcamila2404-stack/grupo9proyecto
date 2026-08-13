document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('form-registro');
  if (form) {
    form.addEventListener('submit', crearCuenta);
  }
});

async function crearCuenta(evento) {
  evento.preventDefault();

  const nombre = document.getElementById('nombre').value.trim();
  const apellido = document.getElementById('apellido').value.trim();
  const correo = document.getElementById('correo').value.trim();
  const password = document.getElementById('password').value;
  const password2 = document.getElementById('password2').value;
  const boton = document.querySelector('.btn-practfy');
  const errorBox = document.getElementById('registro-error');

  errorBox.textContent = '';
  boton.disabled = true;
  boton.textContent = 'Creating account...';

  try {
    const formData = new FormData();
    formData.append('nombre', nombre);
    formData.append('apellido', apellido);
    formData.append('correo', correo);
    formData.append('password', password);
    formData.append('password2', password2);

    const respuesta = await fetch('auth/registro.php', {
      method: 'POST',
      body: formData
    });

    const datos = await respuesta.json();

    if (datos.success) {
      window.location.href = 'examenes.html';
    } else {
      errorBox.textContent = datos.message;
    }
  } catch (error) {
    errorBox.textContent = 'Error de conexión con el servidor.';
  } finally {
    boton.disabled = false;
    boton.textContent = 'Create Account';
  }
}
document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('form-login');
  if (form) {
    form.addEventListener('submit', iniciarSesion);
  }
});

async function iniciarSesion(evento) {
  evento.preventDefault();

  const correo = document.getElementById('correo').value.trim();
  const password = document.getElementById('password').value;
  const boton = document.querySelector('.btn-practfy');
  const errorBox = document.getElementById('login-error');

  errorBox.textContent = '';
  boton.disabled = true;
  boton.textContent = 'Logging in...';

  try {
    const formData = new FormData();
    formData.append('correo', correo);
    formData.append('password', password);

    const respuesta = await fetch('auth/login.php', {
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
    boton.textContent = 'Login';
  }
}
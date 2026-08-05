async function cargarPerfil() {
  try {
    const res = await fetch('usuarios/perfil-datos.php');

    if (res.status === 401) {
      window.location.href = 'login.html';
      return;
    }

    const data = await res.json();
    const iniciales = (data.nombre.charAt(0) + data.apellido.charAt(0)).toUpperCase();

    document.getElementById('avatarInitials').textContent = iniciales;
    document.getElementById('userFullName').textContent = data.nombre + ' ' + data.apellido;
    document.getElementById('userEmail').textContent = data.correo;
    document.getElementById('statExamenes').textContent = data.totalExamenes;
    document.getElementById('statPromedio').textContent = data.promedio + '%';
    document.getElementById('progressPercent').textContent = data.promedio + '%';

    document.querySelectorAll('.skeleton').forEach((el) => el.classList.remove('skeleton'));

    const ring = document.getElementById('progressRing');
    if (ring) {
      ring.style.background =
        'conic-gradient(var(--ink) 0% ' + data.promedio + '%, rgba(22,33,62,0.15) ' + data.promedio + '% 100%)';
    }

    document.getElementById('nombre').value = data.nombre;
    document.getElementById('apellido').value = data.apellido;
    document.getElementById('correo').value = data.correo;

  } catch (error) {
    console.error('Error al cargar el perfil:', error);
    document.getElementById('userFullName').textContent = 'Error al cargar datos';
  }
}

async function guardarPerfil(evento) {
  evento.preventDefault();

  const nombre = document.getElementById('nombre').value.trim();
  const apellido = document.getElementById('apellido').value.trim();
  const correo = document.getElementById('correo').value.trim();
  const password = document.getElementById('password').value;
  const errorBox = document.getElementById('perfil-error');
  const boton = document.querySelector('#form-editar-perfil .btn-practfy');

  errorBox.textContent = '';
  boton.disabled = true;
  boton.textContent = 'Guardando...';

  try {
    const formData = new FormData();
    formData.append('nombre', nombre);
    formData.append('apellido', apellido);
    formData.append('correo', correo);
    formData.append('password', password);

    const respuesta = await fetch('usuarios/actualizar.php', {
      method: 'POST',
      body: formData
    });

    if (respuesta.status === 401) {
      window.location.href = 'login.html';
      return;
    }

    const datos = await respuesta.json();

    if (datos.success) {
      document.getElementById('userFullName').textContent = nombre + ' ' + apellido;
      document.getElementById('userEmail').textContent = correo;
      document.getElementById('password').value = '';
    } else {
      errorBox.textContent = datos.message;
    }
  } catch (error) {
    errorBox.textContent = 'Error de conexión con el servidor.';
  } finally {
    boton.disabled = false;ssssss
    boton.textContent = 'Guardar cambios';
  }
}

function revelarPaneles() {
  const panels = document.querySelectorAll('.panel');

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('in-view');
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });

  panels.forEach((panel, index) => {
    panel.style.transitionDelay = (index * 0.08) + 's';
    observer.observe(panel);
  });
}

document.addEventListener('DOMContentLoaded', () => {
  cargarPerfil();
  revelarPaneles();

  const form = document.getElementById('form-editar-perfil');
  if (form) {
    form.addEventListener('submit', guardarPerfil);
  }
});
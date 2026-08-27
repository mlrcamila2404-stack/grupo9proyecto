function inicializarQuiz() {
  const cards = document.querySelectorAll('.question-card');
  const groups = new Set();
 
  cards.forEach((card) => {
    card.querySelectorAll('input[type="radio"]').forEach((input) => {
      groups.add(input.name);
    });
  });
 
  const total = groups.size;
  const bar = document.getElementById('quizProgressBar');
  const label = document.getElementById('quizProgressLabel');
 
  function currentPageStats() {
    let correct = 0;
    let answered = 0;
 
    groups.forEach((name) => {
      const checked = document.querySelector('input[name="' + name + '"]:checked');
      if (!checked) return;
      answered++;
      const correctInput = document.querySelector('input[name="' + name + '"][data-correct="true"]');
      if (correctInput) {
        if (checked === correctInput) correct++;
      } else {
        correct++;
      }
    });
 
    return { answered, correct, total };
  }
 
  function updateProgress() {
    const stats = currentPageStats();
    const percent = total ? Math.round((stats.answered / total) * 100) : 0;
    if (bar) bar.style.width = percent + '%';
    if (label) label.textContent = stats.answered + ' of ' + total + ' answered';
  }
 
  cards.forEach((card) => {
    card.addEventListener('change', () => {
      card.classList.add('answered');
      updateProgress();
    });
  });
 
  updateProgress();
 
  if (document.body.dataset.freshAttempt === 'true') {
    sessionStorage.removeItem('practifyCorrect');
    sessionStorage.removeItem('practifyTotal');
    sessionStorage.setItem('practifyStartTime', Date.now().toString());
  }
 
  document.querySelectorAll('[data-action="next"]').forEach((link) => {
    link.addEventListener('click', () => {
      const stats = currentPageStats();
      const prevCorrect = parseInt(sessionStorage.getItem('practifyCorrect') || '0', 10);
      const prevTotal = parseInt(sessionStorage.getItem('practifyTotal') || '0', 10);
      sessionStorage.setItem('practifyCorrect', prevCorrect + stats.correct);
      sessionStorage.setItem('practifyTotal', prevTotal + stats.total);
    });
  });
 
  document.querySelectorAll('[data-action="finalize"]').forEach((link) => {
    link.addEventListener('click', (e) => {
      e.preventDefault();
 
      const stats = currentPageStats();
      const prevCorrect = parseInt(sessionStorage.getItem('practifyCorrect') || '0', 10);
      const prevTotal = parseInt(sessionStorage.getItem('practifyTotal') || '0', 10);
 
      const finalCorrect = prevCorrect + stats.correct;
      const finalTotal = prevTotal + stats.total;
      const finalWrong = finalTotal - finalCorrect;
      const percent = finalTotal ? Math.round((finalCorrect / finalTotal) * 100) : 0;
 
      const startTime = parseInt(sessionStorage.getItem('practifyStartTime') || '0', 10);
      const elapsedMs = startTime ? Date.now() - startTime : 0;
 
      sessionStorage.removeItem('practifyCorrect');
      sessionStorage.removeItem('practifyTotal');
      sessionStorage.removeItem('practifyStartTime');
 
      const params = new URLSearchParams({
        score: percent,
        correct: finalCorrect,
        wrong: finalWrong < 0 ? 0 : finalWrong,
        total: finalTotal,
        time: elapsedMs
      });
 
      const href = link.getAttribute('href');
      const basePath = href.substring(0, href.lastIndexOf('/') + 1);
      window.location.href = basePath + 'retroalimentacion-excelente.html?' + params.toString();
    });
  });
 
  const finalizeBtn = document.querySelector('[onclick^="finalizarPrueba"]');
  if (finalizeBtn && document.body.dataset.next) {
    finalizeBtn.textContent = 'Next Part';
  }
}
 
document.addEventListener('DOMContentLoaded', () => {
  if (document.body.dataset.autoInit !== 'false') {
    inicializarQuiz();
  }
});
 
async function cargarPreguntas(idPrueba, contenedorId) {
  try {
    const base = document.body.dataset.base || '';
    const res = await fetch(base + 'pruebas/preguntas.php?id_prueba=' + idPrueba, { cache: 'no-store' });
    const data = await res.json();
 
    if (!data.success) {
      console.error(data.message);
      return;
    }
 
    const contenedor = document.getElementById(contenedorId);
    contenedor.innerHTML = '';
 
    data.secciones.forEach((seccion) => {
      seccion.recursos.forEach((recurso) => {
        let mediaHtml = '';
        if (recurso.tipo_recurso === 'imagen') {
          mediaHtml = '<img src="' + base + 'img/' + recurso.archivo + '" class="img-fluid w-75 mb-3" alt="Recurso">';
        } else if (recurso.tipo_recurso === 'audio') {
          mediaHtml = '<audio class="quiz-audio mb-3 w-100" id="audio' + recurso.id_recurso + '" src="' + base + 'audios/' + recurso.archivo + '"></audio>';
        }
 
        recurso.preguntas.forEach((pregunta, index) => {
          const card = document.createElement('div');
          card.className = 'question-card';
          card.dataset.idPregunta = pregunta.id_pregunta;
 
          let opcionesHtml = '';
          pregunta.opciones.forEach((opcion) => {
            const inputId = 'p' + pregunta.id_pregunta + opcion.letra;
            opcionesHtml += `
              <div class="form-check">
                <input class="form-check-input" type="radio" name="p${pregunta.id_pregunta}" id="${inputId}" value="${opcion.letra}">
                <label class="form-check-label" for="${inputId}">${opcion.texto_opcion}</label>
              </div>`;
          });
 
          const mediaBloque = index === 0 ? mediaHtml : '';
          const textoHtml = pregunta.texto_pregunta
            ? `<p><strong>Question ${pregunta.numero_pregunta}:</strong> ${pregunta.texto_pregunta}</p>`
            : `<p><strong>Question ${pregunta.numero_pregunta}:</strong> Choose the best option.</p>`;
 
          card.innerHTML = mediaBloque + textoHtml + opcionesHtml;
 
          if (index === 0 && recurso.tipo_recurso === 'audio') {
            card.dataset.audioId = 'audio' + recurso.id_recurso;
          }
 
          contenedor.appendChild(card);
        });
      });
    });
 
    const tarjetasConAudio = contenedor.querySelectorAll('[data-audio-id]');
    const audioObserver = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const audioEl = document.getElementById(entry.target.dataset.audioId);
          if (audioEl) audioEl.play();
          audioObserver.unobserve(entry.target);
        }
      });
    }, { threshold: 0.3 });
 
    tarjetasConAudio.forEach((card) => audioObserver.observe(card));
 
    inicializarQuiz();
 
  } catch (error) {
    console.error('Error al cargar preguntas:', error);
  }
}
 
async function guardarIntento(idPrueba) {
  const respuestas = [];
  const base = document.body.dataset.base || '';
 
  document.querySelectorAll('.question-card').forEach((card) => {
    const idPregunta = card.dataset.idPregunta;
    const checked = card.querySelector('input[type="radio"]:checked');
    if (checked) {
      respuestas.push({ id_pregunta: idPregunta, respuesta: checked.value });
    }
  });
 
  try {
    const res = await fetch(base + 'intentos/guardar.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id_prueba: idPrueba, respuestas: respuestas })
    });
 
    const data = await res.json();
 
    if (!data.success) {
      console.error(data.message);
      return null;
    }
 
    return data;
 
  } catch (error) {
    console.error('Error al guardar el intento:', error);
    return null;
  }
}
 
async function finalizarPrueba(idPrueba) {
  const resultado = await guardarIntento(idPrueba);
 
  if (!resultado) {
    alert('Hubo un error al guardar tu resultado. Intenta de nuevo.');
    return;
  }
 
  const prevCorrect = parseInt(sessionStorage.getItem('practifyCorrect') || '0', 10);
  const prevTotal = parseInt(sessionStorage.getItem('practifyTotal') || '0', 10);
  const finalCorrect = prevCorrect + resultado.correct;
  const finalTotal = prevTotal + resultado.total;
 
  const next = document.body.dataset.next;
 
  if (next) {
    sessionStorage.setItem('practifyCorrect', finalCorrect.toString());
    sessionStorage.setItem('practifyTotal', finalTotal.toString());
    window.location.href = next;
    return;
  }
 
  const finalWrong = finalTotal - finalCorrect;
  const percent = finalTotal ? Math.round((finalCorrect / finalTotal) * 100) : 0;
 
  const startTime = parseInt(sessionStorage.getItem('practifyStartTime') || '0', 10);
  const elapsedMs = startTime ? Date.now() - startTime : 0;
 
  sessionStorage.removeItem('practifyCorrect');
  sessionStorage.removeItem('practifyTotal');
  sessionStorage.removeItem('practifyStartTime');
 
  const params = new URLSearchParams({
    score: percent,
    correct: finalCorrect,
    wrong: finalWrong < 0 ? 0 : finalWrong,
    total: finalTotal,
    time: elapsedMs
  });
 
  const base = document.body.dataset.base || '';
  window.location.href = base + 'retroalimentacion-excelente.html?' + params.toString();
}
 
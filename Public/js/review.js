async function loadReview() {
  const params = new URLSearchParams(window.location.search);
  const attemptId = params.get('id');

  if (!attemptId) {
    document.getElementById('reviewList').innerHTML = '<div class="text-center py-5"><h3>Invalid Attempt ID</h3><a href="examenes.html" class="btn-practfy mt-3">Go Back</a></div>';
    return;
  }

  try {
    const res = await fetch(`auth/get_review.php?id=${attemptId}`);
    const data = await res.json();

    if (!data.success) {
      document.getElementById('reviewList').innerHTML = `<div class="text-center py-5"><h3>${data.message}</h3><a href="examenes.html" class="btn-practfy mt-3">Go Back</a></div>`;
      return;
    }

    const { intento, detalles, correctas } = data;

    document.getElementById('examTitle').textContent = intento.prueba_titulo;
    document.getElementById('finalScore').textContent = intento.porcentaje + '%';

    // Calculate and display time spent
    if (intento.fecha_inicio && intento.fecha_fin) {
      const start = new Date(intento.fecha_inicio).getTime();
      const end = new Date(intento.fecha_fin).getTime();
      const diffMs = end - start;

      const totalSeconds = Math.floor(diffMs / 1000);
      const minutes = Math.floor(totalSeconds / 60);
      const seconds = totalSeconds % 60;

      document.getElementById('timeSpent').textContent =
        `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    } else {
      document.getElementById('timeSpent').textContent = '--:--';
    }

    const listEl = document.getElementById('reviewList');
    listEl.innerHTML = '';

    detalles.forEach((item, index) => {
      const isCorrect = item.respuesta_usuario === item.respuesta_correcta;
      const userAnswerText = item.user_option_text || (item.respuesta_usuario ? `Option ${item.respuesta_usuario}` : 'No answer selected');
      const correctAnswerText = correctas[item.id_pregunta] || (item.respuesta_correcta ? `Option ${item.respuesta_correcta}` : 'N/A');

      const card = document.createElement('div');
      card.className = `review-card ${isCorrect ? 'correct' : 'wrong'} reveal`;
      card.style.animationDelay = (index * 0.05) + 's';

      let mediaHtml = '';
      const isReadingSection = item.seccion_titulo && item.seccion_titulo.toLowerCase().includes('reading');

      if (item.tipo_recurso === 'imagen') {
        mediaHtml = `<img src="img/${item.recurso_archivo}" class="review-media" alt="Resource">`;
      } else if (item.tipo_recurso === 'audio' && !isReadingSection) {
        mediaHtml = `
          <div class="audio-review-container mb-3">
            <label class="small fw-bold text-muted mb-1 d-block"><i class="fa-solid fa-volume-high me-1"></i> Listen again:</label>
            <audio controls class="w-100">
              <source src="audios/${item.recurso_archivo}" type="audio/mpeg">
            </audio>
          </div>`;
      }

      card.innerHTML = `
        <div class="d-flex justify-content-between align-items-center mb-3">
          <span class="fw-bold">Question ${item.numero_pregunta}</span>
          <span class="status-badge ${isCorrect ? 'badge-correct' : 'badge-wrong'}">
            ${isCorrect ? 'Correct' : 'Incorrect'}
          </span>
        </div>
        ${mediaHtml}
        <p class="mb-3">${item.texto_pregunta || 'Choose the best option'}</p>
        <div class="answer-box user-answer">
          <strong class="me-2">Your Answer:</strong> ${userAnswerText}
        </div>
        ${!isCorrect ? `
        <div class="answer-box correct-answer">
          <strong class="me-2">Correct Answer:</strong> ${correctAnswerText}
        </div>
        ` : ''}
      `;
      listEl.appendChild(card);
    });

  } catch (error) {
    console.error('Error loading review:', error);
    document.getElementById('reviewList').innerHTML = '<div class="text-center py-5"><h3>An error occurred while loading the review.</h3><a href="examenes.html" class="btn-practfy mt-3">Go Back</a></div>';
  }
}

document.addEventListener('DOMContentLoaded', loadReview);

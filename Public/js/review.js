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

    const listEl = document.getElementById('reviewList');
    listEl.innerHTML = '';

    detalles.forEach((item, index) => {
      const isCorrect = item.respuesta_usuario === item.respuesta_correcta;
      const correctText = correctas[item.id_pregunta] || 'Not available';

      const card = document.createElement('div');
      card.className = `review-card ${isCorrect ? 'correct' : 'wrong'} reveal`;
      card.style.animationDelay = (index * 0.05) + 's';

      let mediaHtml = '';
      if (item.tipo_recurso === 'imagen') {
        mediaHtml = `<img src="img/${item.recurso_archivo}" class="review-media" alt="Resource">`;
      } else if (item.tipo_recurso === 'audio') {
        mediaHtml = `<audio controls class="w-100 mb-3"><source src="audios/${item.recurso_archivo}" type="audio/mpeg"></audio>`;
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
          <strong>Your Answer:</strong> ${item.user_option_text || 'No answer selected'}
        </div>
        ${!isCorrect ? `
        <div class="answer-box correct-answer">
          <strong>Correct Answer:</strong> ${correctText}
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

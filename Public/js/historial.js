async function loadHistory() {
  const listEl = document.getElementById('historyList');

  try {
    const res = await fetch('auth/get_history.php');
    const data = await res.json();

    if (!data.success) {
      listEl.innerHTML = `<div class="text-center py-5"><h3 class="text-danger">${data.message}</h3><a href="login.html" class="btn-practfy mt-3">Log In</a></div>`;
      return;
    }

    const history = data.data;

    if (history.length === 0) {
      listEl.innerHTML = `
        <div class="text-center py-5">
          <i class="fa-solid fa-folder-open fa-3x text-muted mb-3"></i>
          <h3>No exams completed yet</h3>
          <p class="text-muted">Once you finish a practice, it will appear here.</p>
        </div>
      `;
      return;
    }

    listEl.innerHTML = '';

    history.forEach((item, index) => {
      const date = new Date(item.fecha_fin).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      });

      const card = document.createElement('div');
      card.className = 'history-item reveal';
      card.style.animationDelay = (index * 0.05) + 's';

      card.innerHTML = `
        <div class="history-info">
          <div class="history-date">${date}</div>
          <div>
            <p class="history-title">${item.prueba_titulo}</p>
          </div>
        </div>
        <div class="d-flex align-items-center">
          <div class="history-score">${item.porcentaje}%</div>
          <a href="review.html?id=${item.id_intento}" class="btn-review">Review</a>
        </div>
      `;
      listEl.appendChild(card);
    });

  } catch (error) {
    console.error('Error loading history:', error);
    listEl.innerHTML = '<div class="text-center py-5"><h3 class="text-danger">An error occurred while loading your history.</h3><a href="examenes.html" class="btn-practfy mt-3">Go Back</a></div>';
  }
}

document.addEventListener('DOMContentLoaded', loadHistory);

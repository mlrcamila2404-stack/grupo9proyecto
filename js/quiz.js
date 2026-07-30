document.addEventListener('DOMContentLoaded', () => {
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
 
      let level = 'mejorar';
      if (percent >= 80) level = 'excelente';
      else if (percent >= 60) level = 'bueno';
 
      sessionStorage.removeItem('practifyCorrect');
      sessionStorage.removeItem('practifyTotal');
 
      const params = new URLSearchParams({
        score: percent,
        correct: finalCorrect,
        wrong: finalWrong < 0 ? 0 : finalWrong,
        total: finalTotal
      });
 
      const href = link.getAttribute('href');
      const basePath = href.substring(0, href.lastIndexOf('/') + 1);
      window.location.href = basePath + 'retroalimentacion-' + level + '.html?' + params.toString();
    });
  });
});

// Espera a que la página cargue
    window.addEventListener("load", function() {
      const audio = document.getElementById("miAudio");
      // Intenta reproducir automáticamente
      audio.play().catch(error => {
        console.log("El navegador bloqueó la reproducción automática:", error);
      });
    });
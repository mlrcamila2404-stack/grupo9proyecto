document.addEventListener('DOMContentLoaded', () => {
  const groups = new Set();
 
  document.querySelectorAll('.question-card input[type="radio"]').forEach((input) => {
    groups.add(input.name);
  });
 
  const total = groups.size;
  const bar = document.getElementById('quizProgressBar');
  const label = document.getElementById('quizProgressLabel');
 
  function updateProgress() {
    const answered = new Set();
 
    document.querySelectorAll('.question-card input[type="radio"]:checked').forEach((input) => {
      answered.add(input.name);
    });
 
    const percent = total ? Math.round((answered.size / total) * 100) : 0;
 
    if (bar) {
      bar.style.width = percent + '%';
    }
 
    if (label) {
      label.textContent = answered.size + ' of ' + total + ' answered';
    }
  }
 
  document.querySelectorAll('.question-card').forEach((card) => {
    card.addEventListener('change', () => {
      card.classList.add('answered');
      updateProgress();
    });
  });
 
  updateProgress();
});
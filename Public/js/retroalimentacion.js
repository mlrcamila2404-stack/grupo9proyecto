document.addEventListener('DOMContentLoaded', () => {
  const params = new URLSearchParams(window.location.search);
 
  if (!params.has('score')) return;
 
  const score = params.get('score');
  const correct = params.get('correct');
  const wrong = params.get('wrong');
 
  const scoreEl = document.getElementById('scoreValue');
  const circleEl = document.getElementById('circleProgress');
  const correctEl = document.getElementById('statCorrect');
  const wrongEl = document.getElementById('statWrong');
 
  if (scoreEl) scoreEl.textContent = score + '%';
 
  if (circleEl) {
    const color = getComputedStyle(scoreEl || document.body).color;
    circleEl.style.background =
      'conic-gradient(' + color + ' 0% ' + score + '%, #EEF0FB ' + score + '% 100%)';
  }
 
  if (correctEl && correct !== null) correctEl.textContent = correct;
  if (wrongEl && wrong !== null) wrongEl.textContent = wrong;
});
 
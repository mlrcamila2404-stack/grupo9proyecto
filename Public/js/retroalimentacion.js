const NIVELES = {
  excelente: {
    color: '#4F46E5',
    titulo: 'Excellent work!',
    subtitulo: 'You have completed this activity with very good results.',
    badgeTexto: '🏅 Excellent Performance',
    badgeFondo: 'rgba(255,176,56,0.18)',
    badgeColor: '#8A5A00',
    feedback: [
      { icon: '✅', texto: 'Excellent understanding of main ideas.' },
      { icon: '✅', texto: 'Good use of vocabulary in context.' },
      { icon: '✅', texto: 'Very good response time.' }
    ]
  },
  bueno: {
    color: '#3A86FF',
    titulo: 'Good job!',
    subtitulo: "You did well, but there's still room to improve.",
    badgeTexto: '👍 Good Performance',
    badgeFondo: 'rgba(58,134,255,0.15)',
    badgeColor: '#1B4B91',
    feedback: [
      { icon: '✅', texto: 'Solid understanding of most of the content.' },
      { icon: '⚠️', texto: 'Some key details were missed.' },
      { icon: '📌', texto: 'Review the questions you got wrong to strengthen your score.' }
    ]
  },
  mejorar: {
    color: '#FFB038',
    titulo: 'Keep practicing!',
    subtitulo: 'You need a bit more practice to master this skill.',
    badgeTexto: '📘 Needs Improvement',
    badgeFondo: 'rgba(255,140,66,0.18)',
    badgeColor: '#9A3412',
    feedback: [
      { icon: '⚠️', texto: 'Basic concepts still need reinforcement.' },
      { icon: '📌', texto: 'Focus on reviewing vocabulary and key ideas.' },
      { icon: '📌', texto: 'Try this activity again after reviewing the feedback.' }
    ]
  }
};

document.addEventListener('DOMContentLoaded', () => {
  const params = new URLSearchParams(window.location.search);

  if (!params.has('score')) return;

  const score = parseInt(params.get('score'), 10);
  const correct = params.get('correct');
  const wrong = params.get('wrong');
  const timeMs = parseInt(params.get('time') || '0', 10);

  let nivel = 'mejorar';
  if (score >= 80) nivel = 'excelente';
  else if (score >= 60) nivel = 'bueno';

  const data = NIVELES[nivel];

  const titleEl = document.getElementById('screenTitle');
  const subEl = document.getElementById('screenSub');
  const scoreEl = document.getElementById('scoreValue');
  const circleEl = document.getElementById('circleProgress');
  const badgeEl = document.getElementById('badgeLevel');
  const correctEl = document.getElementById('statCorrect');
  const wrongEl = document.getElementById('statWrong');
  const timeEl = document.getElementById('statTime');
  const feedbackEl = document.getElementById('feedbackList');

  if (titleEl) titleEl.textContent = data.titulo;
  if (subEl) subEl.textContent = data.subtitulo;
  if (scoreEl) {
    scoreEl.textContent = score + '%';
    scoreEl.style.color = data.color;
  }

  if (circleEl) {
    circleEl.style.background =
      'conic-gradient(' + data.color + ' 0% ' + score + '%, #EEF0FB ' + score + '% 100%)';
  }

  if (badgeEl) {
    badgeEl.textContent = data.badgeTexto;
    badgeEl.style.background = data.badgeFondo;
    badgeEl.style.color = data.badgeColor;
  }

  if (correctEl && correct !== null) correctEl.textContent = correct;
  if (wrongEl && wrong !== null) wrongEl.textContent = wrong;

  if (timeEl && timeMs > 0) {
    const totalSeconds = Math.round(timeMs / 1000);
    const minutos = Math.floor(totalSeconds / 60);
    const segundos = totalSeconds % 60;
    timeEl.textContent = minutos + ':' + String(segundos).padStart(2, '0');
  }

  if (feedbackEl) {
    feedbackEl.innerHTML = '';
    data.feedback.forEach((item) => {
      const div = document.createElement('div');
      div.className = 'feedback-item';
      div.innerHTML = '<span class="icon">' + item.icon + '</span><span>' + item.texto + '</span>';
      feedbackEl.appendChild(div);
    });
  }
});
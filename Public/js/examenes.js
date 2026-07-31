const cards = document.querySelectorAll('.exam-card');
 
cards.forEach((card, index) => {
  card.style.transitionDelay = (index * 0.1) + 's';
});
 
const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add('in-view');
      revealObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.15 });
 
cards.forEach((card) => {
  revealObserver.observe(card);
});
 
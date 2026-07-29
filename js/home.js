const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add('in-view');
      revealObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.2 });
 
document.querySelectorAll('.feature-card, .step-item').forEach((card) => {
  revealObserver.observe(card);
});
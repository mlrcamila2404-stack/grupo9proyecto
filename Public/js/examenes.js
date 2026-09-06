const navList = document.getElementById('navSlider');
const navIndicator = document.getElementById('navPillIndicator');
const navLinks = navList?.querySelectorAll('.nav-link');

function moveNavIndicator(el) {
  if (!el || !navIndicator) return;
  navIndicator.style.left = el.offsetLeft + 'px';
  navIndicator.style.width = el.offsetWidth + 'px';
}

if (navLinks) {
  const activeNavLink = navList.querySelector('.nav-link.active');
  requestAnimationFrame(() => moveNavIndicator(activeNavLink));

  navLinks.forEach((link) => {
    link.addEventListener('mouseenter', () => moveNavIndicator(link));
  });

  navList.addEventListener('mouseleave', () => moveNavIndicator(activeNavLink));
  window.addEventListener('resize', () => moveNavIndicator(navList.querySelector('.nav-link.active')));
}

const filterButtons = document.querySelectorAll('.hub-filter-btn');
const filterIndicator = document.getElementById('hubFilterIndicator');
const groupEls = document.querySelectorAll('[data-group], [data-group-grid]');

function moveFilterIndicator(btn) {
  if (!btn || !filterIndicator) return;
  filterIndicator.style.left = btn.offsetLeft + 'px';
  filterIndicator.style.width = btn.offsetWidth + 'px';
}

if (filterButtons.length > 0) {
  requestAnimationFrame(() => moveFilterIndicator(document.querySelector('.hub-filter-btn.active')));

  filterButtons.forEach((btn) => {
    btn.addEventListener('click', () => {
      filterButtons.forEach((b) => b.classList.remove('active'));
      btn.classList.add('active');
      moveFilterIndicator(btn);

      const filter = btn.dataset.filter;
      groupEls.forEach((el) => {
        const key = el.dataset.group || el.dataset.groupGrid;
        if (filter === 'all' || filter === key) {
          el.style.display = '';
          setTimeout(() => el.style.opacity = '1', 10);
          setTimeout(() => el.style.transform = 'translateY(0)', 10);
        } else {
          el.style.opacity = '0';
          el.style.transform = 'translateY(10px)';
          setTimeout(() => {
            el.style.display = 'none';
          }, 300);
        }
      });
    });
  });

  window.addEventListener('DOMContentLoaded', () => {
    const params = new URLSearchParams(window.location.search);
    const filter = params.get('filter');
    if (filter) {
      const btn = document.querySelector(`.hub-filter-btn[data-filter="${filter}"]`);
      if (btn) {
        btn.click();
        setTimeout(() => {
          const target = document.querySelector(`[data-group="${filter}"]`);
          if (target) {
            target.scrollIntoView({ behavior: 'smooth', block: 'center' });
          }
        }, 100);
      }
    }
  });
}

const revealEls = document.querySelectorAll('.reveal');
revealEls.forEach((el, index) => {
  el.style.animationDelay = (index * 0.05) + 's';
});

const tiltCards = document.querySelectorAll('.hub-card');
tiltCards.forEach((card) => {
  card.addEventListener('mousemove', (e) => {
    const rect = card.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    const rotateX = ((y / rect.height) - 0.5) * -10;
    const rotateY = ((x / rect.width) - 0.5) * 10;
    card.style.transform = 'perspective(700px) rotateX(' + rotateX + 'deg) rotateY(' + rotateY + 'deg) translateY(-3px)';
  });
  card.addEventListener('mouseleave', () => {
    card.style.transform = 'perspective(700px) rotateX(0deg) rotateY(0deg) translateY(0)';
  });
});

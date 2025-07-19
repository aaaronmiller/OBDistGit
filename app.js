import { fetchMeta, aggregate, renderCharts, renderFiles, renderSpotlight } from './lib.js';

let meta = [];
let range = '7d';

(async () => {
  meta = await fetchMeta();
  initUI();
})();

function initUI() {
  document.getElementById('timeControls')
    .addEventListener('click', e => {
      if (e.target.dataset.range) {
        document.querySelectorAll('.btn').forEach(b => b.classList.remove('active'));
        e.target.classList.add('active');
        range = e.target.dataset.range;
        update();
      }
    });

  document.getElementById('search')
    .addEventListener('input', e => renderFiles(meta, e.target.value));

  update();
}

function update() {
  const data = aggregate(meta, range);
  renderSpotlight(data);
  renderCharts(data);
  renderFiles(meta);
}
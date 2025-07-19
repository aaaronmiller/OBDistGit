// lib.js
export async function fetchMeta() {
  const res = await fetch('file_metadata.json');
  return res.json();
}

export function aggregate(list, range) {
  const now = Date.now();
  const days = { '7d': 7, '30d': 30, all: 9999 }[range] || 9999;
  const cutoff = now - days * 86400000;
  const filtered = list.filter(f => new Date(f.modified_time) >= cutoff);

  // daily buckets
  const daily = {};
  filtered.forEach(f => {
    const day = f.modified_time.slice(0, 10);
    daily[day] = (daily[day] || 0) + f.work_minutes;
  });

  // content type ratio
  const types = { prose: 0, code: 0 };
  filtered.forEach(f => {
    const t = f.tags.includes('code') || f.type === 'code' ? 'code' : 'prose';
    types[t] += f.word_count;
  });

  // spotlight
  const spotlight = filtered.reduce((a, b) =>
    a.work_minutes > b.work_minutes ? a : b, filtered[0] || {});

  return { daily, types, spotlight };
}

export function renderSpotlight({ spotlight }) {
  const el = document.getElementById('spotlightTitle');
  const tm = document.getElementById('spotlightTime');
  if (!spotlight) { el.textContent = 'No work in period'; tm.textContent = ''; return; }
  el.textContent = spotlight.display_name;
  tm.textContent = `${spotlight.work_minutes} min`;
}

export function renderCharts({ daily, types }) {
  const labels = Object.keys(daily).sort();
  const data = labels.map(l => daily[l]);

  // Work Activity
  const ctx1 = document.getElementById('workChart');
  if (window.wChart) window.wChart.destroy();
  window.wChart = new Chart(ctx1, {
    type: 'bar',
    data: { labels, datasets: [{ label: 'Minutes', data, backgroundColor: '#00ffff' }] },
    options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
  });

  // Content Ratio
  const ctx2 = document.getElementById('contentChart');
  if (window.cChart) window.cChart.destroy();
  window.cChart = new Chart(ctx2, {
    type: 'doughnut',
    data: {
      labels: Object.keys(types),
      datasets: [{
        data: Object.values(types),
        backgroundColor: ['#00ffff', '#ff00ff']
      }]
    },
    options: { responsive: true, maintainAspectRatio: false }
  });
}

export function renderFiles(list, query = '') {
  const container = document.getElementById('fileList');
  const filtered = list.filter(f =>
    f.display_name.toLowerCase().includes(query.toLowerCase())
  );
  container.innerHTML = filtered.map(f => `
    <div class="fileItem" onclick="window.open('${f.url}', '_blank')">
      <div>${f.display_name}</div>
      <small>${f.word_count} words · ${f.work_minutes} min</small>
    </div>
  `).join('');
}
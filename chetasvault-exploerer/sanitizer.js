/*
  CustomJS Definitive Paste Sanitizer
  Version 5.3 (Ultimate Compatibility Build)

  This script automatically transforms malformed reference links into a dynamic,
  two-state HTML block. This version has been rewritten to build the HTML
  payload as a single, unbroken string to prevent parsing errors in any
  JavaScript engine.
*/

// --- Core Data Extraction Engine ---

function extractLinkData(text) {
  const links = [];
  const linkPattern = /\[!\[\]\(([^)]+)\)\s*([^\n]+)\s*([^\]]+?)\s*\]\(([^)]+)\)/g;

  text.replace(linkPattern, (match, faviconUrl, domain, title, url) => {
    links.push({
      faviconUrl: faviconUrl,
      domain: domain.trim(),
      title: title.replace(/\s+/g, ' ').trim(),
      url: url
    });
    return '';
  });

  return links;
}

// --- HTML Generation Engine ---

function buildLinkInterface(links) {
  const blockId = 'ref-block-' + Date.now();
  const compactId = 'compact-' + blockId;
  const expandedId = 'expanded-' + blockId;

  const compactIcons = links.map(link => {
    const cleanTitle = link.title.replace(/'/g, "\\'");
    return ('<a href="' + link.url + '" target="_blank" class="ref-icon-link" onmouseover="showRefTooltip_' + blockId + '(this, \'' + cleanTitle + '\', \'' + link.url + '\')" onmouseout="hideRefTooltip_' + blockId + '()"><img src="' + link.faviconUrl + '" class="ref-icon" alt="' + link.domain + ' favicon" onerror="this.onerror=null; this.src=\'https://www.google.com/s2/favicons?domain=' + link.domain + '&sz=32\';"></a>');
  }).join('');

  const expandedLinks = links.map(link => {
    return ('<p class="ref-expanded-item"><img src="' + link.faviconUrl + '" class="ref-icon-small" alt="favicon" onerror="this.onerror=null; this.src=\'https://www.google.com/s2/favicons?domain=' + link.domain + '&sz=16\';"><a href="' + link.url + '" target="_blank">' + link.title + '</a></p>');
  }).join('');

  // Build the HTML payload as a single, unbroken string for maximum compatibility.
  const htmlPayload = '<div><style>#' + blockId + ' { border: 1px solid var(--background-modifier-border); border-radius: 8px; padding: 12px; margin: 10px 0; background: var(--background-secondary); } #' + blockId + ' .ref-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; } #' + blockId + ' .ref-title { font-size: 0.9em; font-weight: bold; color: var(--text-muted); } #' + blockId + ' .ref-expand-btn { cursor: pointer; color: var(--text-accent); font-size: 0.8em; background: var(--background-modifier-hover); border: 1px solid var(--background-modifier-border); padding: 4px 8px; border-radius: 4px; } #' + blockId + ' .ref-compact-view { display: flex; flex-wrap: wrap; gap: 10px; } #' + blockId + ' .ref-icon-link { display: inline-block; position: relative; } #' + blockId + ' .ref-icon { width: 32px; height: 32px; vertical-align: middle; border-radius: 4px; transition: transform 0.2s ease; } #' + blockId + ' .ref-icon:hover { transform: scale(1.15); } #' + blockId + ' .ref-expanded-view { display: none; } #' + blockId + ' .ref-expanded-item { margin: 8px 0; display: flex; align-items: center; } #' + blockId + ' .ref-icon-small { width: 16px; height: 16px; margin-right: 8px; border-radius: 2px; } #' + blockId + ' .ref-tooltip { position: absolute; bottom: 110%; left: 50%; transform: translateX(-50%); background: #333; color: white; padding: 6px 10px; border-radius: 6px; font-size: 13px; white-space: nowrap; z-index: 1000; pointer-events: none; opacity: 0; transition: opacity 0.2s; } #' + blockId + ' .ref-tooltip-title { font-weight: bold; } #' + blockId + ' .ref-tooltip-url { font-size: 0.9em; opacity: 0.8; } </style><div id="' + blockId + '"><div class="ref-header"><span class="ref-title">Quick Access Links</span><button class="ref-expand-btn" onclick="toggleRefView_' + blockId + '(this)">Expand All</button></div><div id="' + compactId + '" class="ref-compact-view">' + compactIcons + '</div><div id="' + expandedId + '" class="ref-expanded-view">' + expandedLinks + '</div></div><script>function toggleRefView_' + blockId + '(button) {const compactView = document.getElementById(\'' + compactId + '\'); const expandedView = document.getElementById(\'' + expandedId + '\'); const isExpanded = expandedView.style.display === \'block\'; expandedView.style.display = isExpanded ? \'none\' : \'block\'; compactView.style.display = isExpanded ? \'flex\' : \'none\'; button.textContent = isExpanded ? \'Expand All\' : \'Collapse All\'; } function showRefTooltip_' + blockId + '(element, title, url) {const tooltip = document.createElement(\'div\'); tooltip.className = \'ref-tooltip\'; tooltip.innerHTML = \'<div class="ref-tooltip-title">\' + title + \'</div><div class="ref-tooltip-url">\' + url + \'</div>\'; element.appendChild(tooltip); setTimeout(() => { tooltip.style.opacity = 1; }, 10); } function hideRefTooltip_' + blockId + '() {const tooltips = document.querySelectorAll(\'#' + blockId + ' .ref-tooltip\'); tooltips.forEach(t => t.remove()); }</script></div>';

  return htmlPayload;
}

// --- Obsidian Integration ---

const handlePaste = (cm, event) => {
  const clipboardText = event.clipboardData.getData('text/plain');
  const hasAIPattern = /\[!\[\]\([^)]+\)/.test(clipboardText);

  if (hasAIPattern) {
    const links = extractLinkData(clipboardText);

    if (links.length > 0) {
      event.preventDefault();
      const htmlOutput = buildLinkInterface(links);
      cm.replaceSelection(htmlOutput);
      console.log("CustomJS: Injected dynamic reference link block v5.3.");
    }
  }
};

// Register the paste handler
this.app.workspace.on('editor-paste', handlePaste);

// Cleanup function
this.customJS.onunload = () => {
  this.app.workspace.off('editor-paste', handlePaste);
  console.log("CustomJS: Definitive Paste Sanitizer script unloaded.");
};

console.log("CustomJS: Definitive Paste Sanitizer v5.3 (Ultimate Compatibility) script loaded and active.");
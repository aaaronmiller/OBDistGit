'use strict';

// Function to log initialization
function logStatus(message) {
    console.log(`%c[SYSTEM]:// ${message}`, 'color: #00ffff; font-weight: bold;');
}

// Main App Logic
document.addEventListener('DOMContentLoaded', () => {
    logStatus('DOM loaded. Initializing interface...');

    const appRoot = document.getElementById('app-root');
    if (appRoot) {
        appRoot.innerHTML = '<p>JavaScript interface successfully mounted. Standby for data stream...</p>';
    } else {
        console.error('FATAL: #app-root element not found in DOM.');
    }

    // Example of a dynamic element
    const statusElement = document.createElement('p');
    statusElement.textContent = 'System Status: NOMINAL';
    statusElement.style.color = '#ff00ff';
    statusElement.style.textShadow = '0 0 5px rgba(255, 0, 255, 0.7)';
    appRoot.appendChild(statusElement);

    logStatus('Initialization complete.');
});

cd ~/Doc/ChetasVault/OBDistGit
npm init -y
npm i dotenv @google/generative-ai chart.js gsap
echo "GEMINI_API_KEY=YOUR_KEY" > .env
node update_metadata.js
# check logs/update.log
# open chetavault_dashboard.html in browser
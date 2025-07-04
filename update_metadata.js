const fs = require('fs').promises;
const path = require('path');
const { google } = require('googleapis');
const genai = require('@google/generative-ai');

// Configuration
const BASE_DIR = path.join(process.env.HOME, 'Doc', 'ChetasVault', 'OBDistGit');
const METADATA_FILE = path.join(BASE_DIR, 'file_metadata.json');
const LOG_FILE = path.join(BASE_DIR, 'metadata_update.log');
const GITHUB_URL = 'https://aaaronmiller.github.io/OBDistGit'; // Replace with your GitHub username
const GEMINI_API_KEY = process.env.GEMINI_API_KEY; // Set in environment variables

// Initialize Gemini API
const client = new genai.Client({ apiKey: GEMINI_API_KEY });
const model = client.getModel('gemini-2.5-flash-preview-05-20');

// Categories for classification
const CATEGORIES = {
  'aegis': 'Aegis',
  'rag': 'RAG',
  'ai': 'AI',
  'math': 'Mathematics',
  'security': 'Security',
  'hardware': 'Hardware'
};

// Logging function
async function log(message) {
  const timestamp = new Date().toISOString();
  const logMessage = `[${timestamp}] ${message}\n`;
  await fs.appendFile(LOG_FILE, logMessage);
  console.log(logMessage);
}

// Count words and characters
async function countWordsAndChars(content) {
  const words = content.split(/\s+/).filter(w => w.length > 0).length;
  const chars = content.length;
  return { word_count: words, char_count: chars };
}

// Generate summary using Gemini API
async function generateSummary(content, filename) {
  try {
    await log(`Generating summary for ${filename}`);
    const prompt = `Create a 50-word or less description for the following file content:\n\n${content.slice(0, 1000)}`;
    const response = await client.models.generateContent({
      model: 'gemini-2.5-flash-preview-05-20',
      contents: [{ role: 'user', parts: [{ text: prompt }] }],
      config: { response_modalities: ['TEXT'] }
    });
    const summary = response.candidates[0].content.parts[0].text;
    await log(`Summary generated for ${filename}: ${summary}`);
    return summary;
  } catch (error) {
    await log(`Error generating summary for ${filename}: ${error.message}`);
    return 'Summary unavailable';
  }
}

// Parse file and generate metadata
async function parseFile(filePath) {
  const filename = path.basename(filePath);
  const stats = await fs.stat(filePath);
  const content = await fs.readFile(filePath, 'utf8');
  const category = Object.keys(CATEGORIES).find(key => filename.toLowerCase().includes(key)) 
    ? CATEGORIES[Object.keys(CATEGORIES).find(key => filename.toLowerCase().includes(key))] 
    : 'Other';
  const summary = await generateSummary(content, filename);
  const { word_count, char_count } = await countWordsAndChars(content);
  const time_worked = ((stats.mtime - stats.birthtime) / 1000 / 60).toFixed(0);

  return {
    filename,
    url: `${GITHUB_URL}/${filename}`,
    category,
    creation_time: stats.birthtime.toISOString(),
    modified_time: stats.mtime.toISOString(),
    time_diff_hours: ((Date.now() - stats.birthtime) / 1000 / 3600).toFixed(1),
    time_worked,
    file_size: stats.size.toString(),
    word_count,
    char_count,
    summary,
    file_type: path.extname(filename).slice(1)
  };
}

// Check for file changes
async function hasFileChanged(filePath, existingMetadata) {
  const stats = await fs.stat(filePath);
  const existing = existingMetadata.find(m => m.filename === path.basename(filePath));
  if (!existing) return true;
  return stats.mtime.toISOString() !== existing.modified_time;
}

// Main function to update metadata
async function updateMetadata() {
  try {
    await log('Starting metadata update');
    // Read existing metadata
    let metadata = [];
    try {
      const existing = await fs.readFile(METADATA_FILE, 'utf8');
      metadata = JSON.parse(existing);
      await log(`Loaded existing metadata with ${metadata.length} files`);
    } catch (error) {
      await log('No existing metadata file, creating new one');
    }

    // Scan directory for HTML files
    const files = (await fs.readdir(BASE_DIR)).filter(f => f.endsWith('.html'));
    await log(`Found ${files.length} HTML files`);
    const newMetadata = [];
    let changesDetected = false;

    // Process each file
    for (const file of files) {
      const filePath = path.join(BASE_DIR, file);
      if (await hasFileChanged(filePath, metadata)) {
        changesDetected = true;
        await log(`Processing changed file: ${file}`);
        const fileMetadata = await parseFile(filePath);
        newMetadata.push(fileMetadata);
      } else {
        const existing = metadata.find(m => m.filename === file);
        if (existing) newMetadata.push(existing);
      }
    }

    // Update metadata file only if changes detected
    if (changesDetected) {
      await fs.writeFile(METADATA_FILE, JSON.stringify(newMetadata, null, 2));
      await log('Metadata file updated');
    } else {
      await log('No changes detected, skipping metadata update');
    }
  } catch (error) {
    await log(`Error updating metadata: ${error.message}`);
  }
}

// Run the script
updateMetadata();
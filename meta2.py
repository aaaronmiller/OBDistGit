import os
import json
import datetime
import stat
from pathlib import Path
import re
from datetime import datetime
import platform

# Function to get file creation time (cross-platform)
def get_creation_time(file_path):
    try:
        if platform.system() == "Windows":
            return os.path.getctime(file_path)
        else:
            # For macOS/Linux, use birthtime if available
            stat_info = os.stat(file_path)
            return getattr(stat_info, 'st_birthtime', stat_info.st_ctime)
    except:
        return os.path.getmtime(file_path)

# Function to generate a simple summary
def generate_summary(content, max_length=200):
    # Remove excessive whitespace and limit length
    content = ' '.join(content.split())
    return content[:max_length] + ('...' if len(content) > max_length else '')

# Function to extract ~1000 words
def extract_content(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
            # For HTML files, strip HTML tags
            if file_path.endswith('.html'):
                content = re.sub(r'<[^>]+>', '', content)
            elif file_path.endswith('.md'):
                # For markdown, remove markdown syntax
                content = re.sub(r'[#*>`\[\]]+', '', content)
            
            # Clean and split into words
            words = re.findall(r'\b\w+\b', content)
            
            # Get approximately 1000 words
            word_count = min(len(words), 1000)
            extracted_content = ' '.join(words[:word_count])
            
            # Generate summary
            summary = generate_summary(extracted_content)
            
            return extracted_content, summary
    except Exception as e:
        return "", f"Error reading file: {str(e)}"

# Main function to process files
def process_files():
    # Define the directory
    directory = os.path.expanduser("~/Documents/ChetasVault/OBDistGit")
    
    # File extensions to process
    valid_extensions = ('.html', '.md', '.txt')
    
    # Categories based on file name patterns
    categories = {
        'Aegis': r'Aegis\s*Processed',
        'RAG': r'RAG\s*(Implementation|Guide|Analysis)',
        'AI': r'AI\s*(Compute|Token|Document|Degradation)',
        'Infographic': r'(infographic|INFOGRAPH|Data\s*analysis)',
        'Other': r'.*'
    }
    
    # Output data structure
    metadata = []
    
    # Get all files in directory
    for file_name in os.listdir(directory):
        if not file_name.startswith('.') and any(file_name.endswith(ext) for ext in valid_extensions):
            file_path = os.path.join(directory, file_name)
            
            # Skip directories
            if os.path.isfile(file_path):
                # Get file stats
                stats = os.stat(file_path)
                
                # Get creation and modification times
                creation_time = datetime.fromtimestamp(get_creation_time(file_path))
                modified_time = datetime.fromtimestamp(stats.st_mtime)
                
                # Calculate time between creation and last edit
                time_diff = (modified_time - creation_time).total_seconds() / 3600  # in hours
                
                # Get file size
                file_size = stats.st_size / 1024  # in KB
                
                # Extract content and summary
                content, summary = extract_content(file_path)
                
                # Determine category
                category = 'Other'
                for cat, pattern in categories.items():
                    if re.search(pattern, file_name, re.IGNORECASE):
                        category = cat
                        break
                
                # Create metadata entry
                file_metadata = {
                    'filename': file_name,
                    'url': f"https://yourusername.github.io/OBDistGit/{file_name}",  # Replace with your GitHub username
                    'category': category,
                    'creation_time': creation_time.isoformat(),
                    'modified_time': modified_time.isoformat(),
                    'time_diff_hours': round(time_diff, 2),
                    'file_size': content,
                    'summary': summary,
                    'file_type': file_name.split('.')[-1].lower()
                }
                
                metadata.append(file_metadata)
                
            # Sort metadata by category and creation time
            metadata.sort(key=lambda x: (x['category'], x['creation_time']))
            
            # Write to JSON file
            output_path = os.path.join(directory, 'file_metadata.json')
            with open(output_path, 'w', encoding='utf-8') as f:
                json.dump(metadata, f, indent=2)
            
            print(f"Metadata generated and saved to {output_path}")

if __name__ == "__main__":
    process_files()
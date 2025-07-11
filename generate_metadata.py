import os
import json
import re
from datetime import datetime
import subprocess
from urllib.parse import quote

def get_git_file_info(file_path):
    try:
        # Check if the file is tracked by Git
        subprocess.check_output(['git', 'ls-files', '--error-unmatch', file_path], stderr=subprocess.DEVNULL)

        # Get the last commit that modified the file
        last_commit_hash = subprocess.check_output(
            ['git', 'log', '-1', '--pretty=format:%H', '--', file_path]
        ).decode('utf-8').strip()

        # Get the author and date of that commit
        commit_info = subprocess.check_output(
            ['git', 'show', '-s', '--format=%an|%ai', last_commit_hash]
        ).decode('utf-8').strip()
        
        author, date_str = commit_info.split('|')
        
        # Get the creation date of the file from git
        creation_date_str = subprocess.check_output(
            ['git', 'log', '--diff-filter=A', '--follow', '--format=%ai', '--', file_path]
        ).decode('utf-8').strip().split('\n')[-1]

        return {
            "last_modified_author": author,
            "last_modified_date": datetime.fromisoformat(date_str.replace(' ', 'T')).isoformat(),
            "creation_date": datetime.fromisoformat(creation_date_str.replace(' ', 'T')).isoformat()
        }
    except subprocess.CalledProcessError:
        # File is not tracked by Git
        return {
            "last_modified_author": "N/A",
            "last_modified_date": None,
            "creation_date": None
        }
    except Exception:
        return {
            "last_modified_author": "N/A",
            "last_modified_date": None,
            "creation_date": None
        }

def extract_obsidian_tags(content):
    """Extracts tags from the YAML frontmatter of an Obsidian note."""
    tag_match = re.search(r'^---\s*tags:\s*\[(.*?)\]', content, re.MULTILINE | re.DOTALL)
    if tag_match:
        return [tag.strip() for tag in tag_match.group(1).split(',')]
    return []

def generate_summary(content, is_html=False):
    """
    Generates a simple summary from the file content.
    For HTML, it starts from the body. For others, from the start.
    """
    text_content = content
    if is_html:
        body_match = re.search(r'<body[^>]*>(.*?)</body>', content, re.DOTALL | re.IGNORECASE)
        if body_match:
            text_content = body_match.group(1)
    
    # Strip all remaining tags and markdown for a clean text version
    text_content = re.sub(r'<[^>]+>', '', text_content)
    text_content = re.sub(r'[#*>`\[\]]+', '', text_content)
    
    # Consolidate whitespace and create the summary
    summary = ' '.join(text_content.strip().split())
    return (summary[:200] + '...') if len(summary) > 200 else summary

def process_files():
    directory = '.'
    metadata = []
    
    # Supported file extensions
    supported_extensions = ['.html', '.md', '.txt']

    for root, _, files in os.walk(directory):
        for file_name in files:
            if any(file_name.endswith(ext) for ext in supported_extensions):
                file_path = os.path.join(root, file_name)
                
                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()

                    # Basic file stats
                    stats = os.stat(file_path)
                    file_size = stats.st_size
                    word_count = len(re.findall(r'\w+', content))

                    # Git and tag info
                    git_info = get_git_file_info(file_path)
                    tags = extract_obsidian_tags(content)
                    
                    # Time worked (modification - creation)
                    creation_time = datetime.fromisoformat(git_info['creation_date']) if git_info['creation_date'] else datetime.fromtimestamp(stats.st_ctime)
                    modified_time = datetime.fromisoformat(git_info['last_modified_date']) if git_info['last_modified_date'] else datetime.fromtimestamp(stats.st_mtime)
                    time_worked = int((modified_time - creation_time).total_seconds() / 60) if creation_time and modified_time else 0


                    # Sanitize display name
                    display_name = os.path.splitext(file_name)[0]
                    display_name = display_name.replace('_', ' ').replace('-', ' ')

                    metadata.append({
                        'filename': file_name,
                        'display_name': display_name,
                        'category': tags[0] if tags else 'Other',
                        'tags': tags,
                        'file_size': file_size,
                        'word_count': word_count,
                        'time_worked': time_worked, # in minutes
                        'creation_time': creation_time.isoformat(),
                        'modified_time': modified_time.isoformat(),
                        'summary': generate_summary(content, is_html=file_name.endswith('.html')),
                        'url': f"https://aaaronmiller.github.io/OBDistGit/{quote(file_name)}"
                    })
                except Exception as e:
                    print(f"Error processing {file_path}: {e}")

    # Write to JSON file
    output_path = 'file_metadata.json'
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(metadata, f, indent=4)
    
    print(f"Metadata generated for {len(metadata)} files and saved to {output_path}")

if __name__ == "__main__":
    process_files()